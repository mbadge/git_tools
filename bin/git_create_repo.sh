#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

#/ Usage: git_create_repo.sh [OPTIONS] REPO_NAME
#/ Description: Create GitHub/GitLab repository via API and initialize local git repo
#/ Examples:
#/   git_create_repo.sh my-new-repo                    # Create private GitLab repo
#/   git_create_repo.sh --github my-new-repo           # Create private GitHub repo
#/   git_create_repo.sh --public my-new-repo           # Create public GitLab repo
#/   git_create_repo.sh --gitlab --namespace libR myrepo  # Create in GitLab namespace
#/   git_create_repo.sh --github --org myorg myrepo    # Create in GitHub organization
#/   git_create_repo.sh --in-place my-repo             # Use current directory
#/ Options:
#/   --help: Display this help message
#/   --github: Use GitHub API (default is GitLab)
#/   --gitlab: Use GitLab API (default)
#/   --public: Create public repository (default is private)
#/   --namespace NAME: GitLab namespace/group (default: user's namespace)
#/   --org ORG: GitHub organization (default: user's account)
#/   --in-place: Use current directory instead of creating new one
#/   --no-register: Skip myrepos registration
#/   --no-initial-commit: Skip creating initial commit
usage() { grep '^#/' "$0" | cut -c4- ; exit 0 ; }
expr "$*" : ".*--help" > /dev/null && usage

readonly LOG_FILE="/tmp/$(basename "$0").log"
info()    { echo "[INFO]    $*" | tee -a "$LOG_FILE" >&2 ; }
warning() { echo "[WARNING] $*" | tee -a "$LOG_FILE" >&2 ; }
error()   { echo "[ERROR]   $*" | tee -a "$LOG_FILE" >&2 ; }
fatal()   { echo "[FATAL]   $*" | tee -a "$LOG_FILE" >&2 ; exit 1 ; }

# Utility function: Get current git branch (from git_push_set_upstream.sh)
function git_current_branch() {
  local ref
  ref=$(command git symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo "${ref#refs/heads/}"
}

# Default values
PLATFORM="gitlab"
VISIBILITY="private"
NAMESPACE=""
ORG=""
IN_PLACE=false
NO_REGISTER=false
NO_INITIAL_COMMIT=false
REPO_NAME=""

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --github)
      PLATFORM="github"
      shift
      ;;
    --gitlab)
      PLATFORM="gitlab"
      shift
      ;;
    --public)
      VISIBILITY="public"
      shift
      ;;
    --namespace)
      NAMESPACE="$2"
      shift 2
      ;;
    --org)
      ORG="$2"
      shift 2
      ;;
    --in-place)
      IN_PLACE=true
      shift
      ;;
    --no-register)
      NO_REGISTER=true
      shift
      ;;
    --no-initial-commit)
      NO_INITIAL_COMMIT=true
      shift
      ;;
    -*)
      error "Unknown option: $1"
      usage
      exit 1
      ;;
    *)
      REPO_NAME="$1"
      shift
      ;;
  esac
done

# Validate repository name
if [[ -z "$REPO_NAME" ]]; then
  error "Repository name is required"
  usage
  exit 1
fi

info "Creating repository: $REPO_NAME on $PLATFORM (visibility: $VISIBILITY)"

# Check required tools
command -v git >/dev/null 2>&1 || fatal "git is not installed"
command -v curl >/dev/null 2>&1 || fatal "curl is not installed"
command -v jq >/dev/null 2>&1 || fatal "jq is not installed"

# Get script directory to locate token files
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOOLS_DIR="$(dirname "$SCRIPT_DIR")"

# Read API token
if [[ "$PLATFORM" == "gitlab" ]]; then
  TOKEN_FILE="$TOOLS_DIR/.gitlab/secret.txt"
  if [[ ! -f "$TOKEN_FILE" ]]; then
    fatal "GitLab token file not found: $TOKEN_FILE"
  fi
  API_TOKEN=$(cat "$TOKEN_FILE")
  [[ -z "$API_TOKEN" ]] && fatal "GitLab token file is empty"
  info "Using GitLab API at git.nak.co"
elif [[ "$PLATFORM" == "github" ]]; then
  TOKEN_FILE="$TOOLS_DIR/.github/secret.txt"
  if [[ ! -f "$TOKEN_FILE" ]]; then
    fatal "GitHub token file not found: $TOKEN_FILE. Please create it with your GitHub personal access token."
  fi
  API_TOKEN=$(cat "$TOKEN_FILE")
  [[ -z "$API_TOKEN" ]] && fatal "GitHub token file is empty"
  info "Using GitHub API"
fi

# Setup local repository
if [[ "$IN_PLACE" == true ]]; then
  info "Using current directory: $(pwd)"
  if [[ -d ".git" ]]; then
    fatal "Current directory is already a git repository"
  fi
  REPO_DIR="$(pwd)"
else
  info "Creating directory: $REPO_NAME"
  if [[ -d "$REPO_NAME" ]]; then
    fatal "Directory already exists: $REPO_NAME"
  fi
  mkdir "$REPO_NAME"
  REPO_DIR="$(pwd)/$REPO_NAME"
  cd "$REPO_NAME"
fi

# Initialize git repository
info "Initializing git repository"
git init

# Create initial commit if requested
if [[ "$NO_INITIAL_COMMIT" == false ]]; then
  info "Creating initial commit"
  cat > README.md <<EOF
# $REPO_NAME

This repository was created with git_create_repo.sh
EOF
  git add README.md
  git commit -m "Initial commit"
fi

# Create remote repository via API
info "Creating remote repository on $PLATFORM"

if [[ "$PLATFORM" == "gitlab" ]]; then
  # Build GitLab API request
  GITLAB_URL="https://git.nak.co"
  API_ENDPOINT="$GITLAB_URL/api/v4/projects"

  # Prepare JSON payload
  if [[ -n "$NAMESPACE" ]]; then
    # Look up namespace ID
    info "Looking up namespace: $NAMESPACE"
    NAMESPACE_RESPONSE=$(curl -s -H "PRIVATE-TOKEN: $API_TOKEN" \
      "$GITLAB_URL/api/v4/namespaces?search=$NAMESPACE")
    NAMESPACE_ID=$(echo "$NAMESPACE_RESPONSE" | jq -r '.[0].id')
    if [[ "$NAMESPACE_ID" == "null" || -z "$NAMESPACE_ID" ]]; then
      fatal "Namespace not found: $NAMESPACE"
    fi
    info "Found namespace ID: $NAMESPACE_ID"
    JSON_PAYLOAD=$(jq -n \
      --arg name "$REPO_NAME" \
      --arg visibility "$VISIBILITY" \
      --arg namespace_id "$NAMESPACE_ID" \
      '{name: $name, visibility: $visibility, namespace_id: $namespace_id, initialize_with_readme: false}')
  else
    JSON_PAYLOAD=$(jq -n \
      --arg name "$REPO_NAME" \
      --arg visibility "$VISIBILITY" \
      '{name: $name, visibility: $visibility, initialize_with_readme: false}')
  fi

  # Make API request
  API_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$API_ENDPOINT" \
    -H "PRIVATE-TOKEN: $API_TOKEN" \
    -H "Content-Type: application/json" \
    -d "$JSON_PAYLOAD")

  HTTP_CODE=$(echo "$API_RESPONSE" | tail -n1)
  RESPONSE_BODY=$(echo "$API_RESPONSE" | sed '$d')

  # Check response
  if [[ "$HTTP_CODE" -ge 200 && "$HTTP_CODE" -lt 300 ]]; then
    info "Repository created successfully"
    SSH_URL=$(echo "$RESPONSE_BODY" | jq -r '.ssh_url_to_repo')
    HTTP_URL=$(echo "$RESPONSE_BODY" | jq -r '.web_url')
  elif [[ "$HTTP_CODE" == "400" ]]; then
    ERROR_MSG=$(echo "$RESPONSE_BODY" | jq -r '.message // .error // "Bad request"')
    fatal "Failed to create repository: $ERROR_MSG (HTTP $HTTP_CODE)"
  elif [[ "$HTTP_CODE" == "401" || "$HTTP_CODE" == "403" ]]; then
    fatal "Invalid token or insufficient permissions (HTTP $HTTP_CODE)"
  elif [[ "$HTTP_CODE" == "409" ]]; then
    fatal "Repository already exists (HTTP $HTTP_CODE)"
  else
    ERROR_MSG=$(echo "$RESPONSE_BODY" | jq -r '.message // .error // "Unknown error"')
    fatal "API request failed: $ERROR_MSG (HTTP $HTTP_CODE)"
  fi

elif [[ "$PLATFORM" == "github" ]]; then
  # Build GitHub API request
  if [[ -n "$ORG" ]]; then
    API_ENDPOINT="https://api.github.com/orgs/$ORG/repos"
  else
    API_ENDPOINT="https://api.github.com/user/repos"
  fi

  # Prepare JSON payload
  PRIVATE_BOOL="true"
  [[ "$VISIBILITY" == "public" ]] && PRIVATE_BOOL="false"

  JSON_PAYLOAD=$(jq -n \
    --arg name "$REPO_NAME" \
    --argjson private "$PRIVATE_BOOL" \
    '{name: $name, private: $private, auto_init: false}')

  # Make API request
  API_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$API_ENDPOINT" \
    -H "Authorization: token $API_TOKEN" \
    -H "Content-Type: application/json" \
    -d "$JSON_PAYLOAD")

  HTTP_CODE=$(echo "$API_RESPONSE" | tail -n1)
  RESPONSE_BODY=$(echo "$API_RESPONSE" | sed '$d')

  # Check response
  if [[ "$HTTP_CODE" -ge 200 && "$HTTP_CODE" -lt 300 ]]; then
    info "Repository created successfully"
    SSH_URL=$(echo "$RESPONSE_BODY" | jq -r '.ssh_url')
    HTTP_URL=$(echo "$RESPONSE_BODY" | jq -r '.html_url')
  elif [[ "$HTTP_CODE" == "401" || "$HTTP_CODE" == "403" ]]; then
    fatal "Invalid token or insufficient permissions (HTTP $HTTP_CODE)"
  elif [[ "$HTTP_CODE" == "422" ]]; then
    ERROR_MSG=$(echo "$RESPONSE_BODY" | jq -r '.message // "Repository already exists or validation failed"')
    fatal "Failed to create repository: $ERROR_MSG (HTTP $HTTP_CODE)"
  else
    ERROR_MSG=$(echo "$RESPONSE_BODY" | jq -r '.message // "Unknown error"')
    fatal "API request failed: $ERROR_MSG (HTTP $HTTP_CODE)"
  fi
fi

# Configure remote
info "Adding remote origin: $SSH_URL"
git remote add origin "$SSH_URL"

# Push to remote
if [[ "$NO_INITIAL_COMMIT" == false ]]; then
  CURRENT_BRANCH=$(git_current_branch)
  warning "Push to remote $PLATFORM repository?"
  select yn in "Yes" "No"; do
    case $yn in
      Yes )
        info "Pushing to origin/$CURRENT_BRANCH"
        git push -u origin "$CURRENT_BRANCH"
        break
        ;;
      No )
        warning "Skipping push. You can push later with: git push -u origin $CURRENT_BRANCH"
        break
        ;;
    esac
  done
else
  info "Skipping push (no initial commit created)"
fi

# Register with myrepos
if [[ "$NO_REGISTER" == false ]] && command -v mr >/dev/null 2>&1; then
  info "Registering with myrepos"
  mr register || warning "Failed to register with myrepos (you can do this manually with 'mr register')"
else
  if [[ "$NO_REGISTER" == true ]]; then
    info "Skipping myrepos registration (--no-register flag)"
  else
    info "myrepos not installed, skipping registration"
  fi
fi

# Success summary
info "================================================"
info "Repository created successfully!"
info "  Name: $REPO_NAME"
info "  Platform: $PLATFORM"
info "  Visibility: $VISIBILITY"
info "  URL: $HTTP_URL"
info "  Local path: $REPO_DIR"
info "================================================"
