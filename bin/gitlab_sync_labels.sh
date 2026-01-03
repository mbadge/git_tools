#!/usr/bin/env bash
#
# gitlab_sync_labels.sh - Sync labels from one GitLab repository to another
#
# Usage: gitlab_sync_labels.sh [OPTIONS]
#
# Options:
#   --source-repo REPO       Source repository (format: namespace/project or project ID)
#   --target-repo REPO       Target repository (format: namespace/project or project ID)
#   --gitlab-url URL         GitLab instance URL (default: https://gitlab.com)
#   --token TOKEN            GitLab API token (or set GITLAB_TOKEN env var)
#   --export-only            Only export labels from source repo to JSON file
#   --import-file FILE       Import labels from JSON file to target repo
#   --dry-run                Show what would be created without making changes
#   -h, --help               Show this help message

set -euo pipefail

# Default values
GITLAB_URL="${GITLAB_URL:-https://gitlab.com}"
GITLAB_TOKEN="${GITLAB_TOKEN:-}"
SOURCE_REPO=""
TARGET_REPO=""
EXPORT_ONLY=false
IMPORT_FILE=""
DRY_RUN=false

# Colors for output
if [[ -t 1 ]]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m' # No Color
else
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    NC=''
fi

# Function to show usage
show_usage() {
    sed -n '2,11p' "$0" | sed 's/^# \?//'
    exit 0
}

# Function to log messages
log_info() {
    echo -e "${BLUE}[INFO]${NC} $*" >&2
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*" >&2
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $*" >&2
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

# Function to URL encode project path
urlencode() {
    local string="${1}"
    local strlen=${#string}
    local encoded=""
    local pos c o

    for (( pos=0 ; pos<strlen ; pos++ )); do
        c=${string:$pos:1}
        case "$c" in
            [-_.~a-zA-Z0-9] ) o="${c}" ;;
            * ) printf -v o '%%%02x' "'$c"
        esac
        encoded+="${o}"
    done
    echo "${encoded}"
}

# Function to make GitLab API call
gitlab_api() {
    local endpoint="$1"
    local method="${2:-GET}"
    local data="${3:-}"

    local url="${GITLAB_URL}/api/v4/${endpoint}"
    local curl_opts=(-s -H "PRIVATE-TOKEN: ${GITLAB_TOKEN}")

    if [[ "$method" != "GET" ]]; then
        curl_opts+=(-X "$method")
    fi

    if [[ -n "$data" ]]; then
        curl_opts+=(-H "Content-Type: application/json" -d "$data")
    fi

    curl "${curl_opts[@]}" "$url"
}

# Function to get all labels from a repository (handles pagination)
get_labels() {
    local repo="$1"
    local encoded_repo
    encoded_repo=$(urlencode "$repo")
    local page=1
    local per_page=100
    local all_labels="[]"

    log_info "Fetching labels from ${repo}..."

    while true; do
        local response
        response=$(gitlab_api "projects/${encoded_repo}/labels?page=${page}&per_page=${per_page}")

        # Check if response is empty array or no results
        local count
        count=$(echo "$response" | jq -e 'length' 2>/dev/null || echo "0")

        if [[ "$count" == "0" ]]; then
            break
        fi

        # Merge labels using jq
        all_labels=$(jq -n --argjson prev "$all_labels" --argjson new "$response" '$prev + $new')

        # Check if we got fewer results than per_page (last page)
        if [[ $count -lt $per_page ]]; then
            break
        fi

        ((page++))
    done

    echo "$all_labels"
}

# Function to create a label
create_label() {
    local repo="$1"
    local label_json="$2"
    local encoded_repo
    encoded_repo=$(urlencode "$repo")

    local name color description priority
    name=$(echo "$label_json" | jq -r '.name')
    color=$(echo "$label_json" | jq -r '.color')
    description=$(echo "$label_json" | jq -r '.description // ""')
    priority=$(echo "$label_json" | jq -r '.priority // null')

    local data="{\"name\": $(echo "$label_json" | jq -c '.name'), \"color\": $(echo "$label_json" | jq -c '.color')"

    if [[ -n "$description" && "$description" != "null" ]]; then
        data="${data}, \"description\": $(echo "$label_json" | jq -c '.description')"
    fi

    if [[ -n "$priority" && "$priority" != "null" ]]; then
        data="${data}, \"priority\": ${priority}"
    fi

    data="${data}}"

    if [[ "$DRY_RUN" == true ]]; then
        log_info "[DRY RUN] Would create label: $name (${color})"
        return 0
    fi

    local response
    response=$(gitlab_api "projects/${encoded_repo}/labels" "POST" "$data" 2>&1)

    # Check if label already exists
    if echo "$response" | jq -e '.message.name[]? | select(. == "has already been taken")' >/dev/null 2>&1; then
        log_warning "Label already exists: $name"
        return 0
    elif echo "$response" | jq -e '.name' >/dev/null 2>&1; then
        log_success "Created label: $name"
        return 0
    else
        log_error "Failed to create label: $name"
        log_error "Response: $response"
        return 1
    fi
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --source-repo)
            SOURCE_REPO="$2"
            shift 2
            ;;
        --target-repo)
            TARGET_REPO="$2"
            shift 2
            ;;
        --gitlab-url)
            GITLAB_URL="$2"
            shift 2
            ;;
        --token)
            GITLAB_TOKEN="$2"
            shift 2
            ;;
        --export-only)
            EXPORT_ONLY=true
            shift
            ;;
        --import-file)
            IMPORT_FILE="$2"
            shift 2
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        -h|--help)
            show_usage
            ;;
        *)
            log_error "Unknown option: $1"
            show_usage
            ;;
    esac
done

# Validate dependencies
if ! command -v jq &> /dev/null; then
    log_error "jq is required but not installed. Install it with: sudo apt install jq"
    exit 1
fi

if ! command -v curl &> /dev/null; then
    log_error "curl is required but not installed."
    exit 1
fi

# Validate token
if [[ -z "$GITLAB_TOKEN" ]]; then
    log_error "GitLab token is required. Set GITLAB_TOKEN environment variable or use --token option."
    exit 1
fi

# Main logic
if [[ -n "$IMPORT_FILE" ]]; then
    # Import mode: read labels from file and create them in target repo
    if [[ -z "$TARGET_REPO" ]]; then
        log_error "Target repository is required when importing labels."
        exit 1
    fi

    if [[ ! -f "$IMPORT_FILE" ]]; then
        log_error "Import file not found: $IMPORT_FILE"
        exit 1
    fi

    log_info "Importing labels from ${IMPORT_FILE} to ${TARGET_REPO}..."

    labels=$(cat "$IMPORT_FILE")
    label_count=$(echo "$labels" | jq 'length')

    log_info "Found ${label_count} labels to import"

    for i in $(seq 0 $((label_count - 1))); do
        label=$(echo "$labels" | jq ".[$i]")
        create_label "$TARGET_REPO" "$label"
    done

    log_success "Import completed!"

elif [[ "$EXPORT_ONLY" == true ]]; then
    # Export mode: get labels from source repo and save to file
    if [[ -z "$SOURCE_REPO" ]]; then
        log_error "Source repository is required when exporting labels."
        exit 1
    fi

    labels=$(get_labels "$SOURCE_REPO")
    label_count=$(echo "$labels" | jq 'length')

    output_file="gitlab_labels_$(echo "$SOURCE_REPO" | tr '/' '_').json"
    echo "$labels" | jq '.' > "$output_file"

    log_success "Exported ${label_count} labels to ${output_file}"

else
    # Sync mode: get labels from source and create in target
    if [[ -z "$SOURCE_REPO" ]]; then
        log_error "Source repository is required."
        exit 1
    fi

    if [[ -z "$TARGET_REPO" ]]; then
        log_error "Target repository is required."
        exit 1
    fi

    labels=$(get_labels "$SOURCE_REPO")
    label_count=$(echo "$labels" | jq 'length')

    log_info "Found ${label_count} labels in source repository"
    log_info "Syncing labels to ${TARGET_REPO}..."

    for i in $(seq 0 $((label_count - 1))); do
        label=$(echo "$labels" | jq ".[$i]")
        create_label "$TARGET_REPO" "$label"
    done

    log_success "Sync completed!"
fi
