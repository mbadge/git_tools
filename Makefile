# Install repo resources
#
# recipes
# * build: execute custom restow to farm symlinks to external files
# * show: show planned symlinks without actually linking
# * clean: remove managed symlinks from home directory 
#
# params 
# * REPO: what repo to install/clean


# PARAMS ----
REPO = "git-tools"

STOW_DIR = /home/$(USER)/stow
STOW_ARGS = --restow --verbose=1
# Note: Ignore patterns are defined in .stow-local-ignore


# MAIN ----
.PHONY: all
all: build

.PHONY: build
build:
	@echo Farming symlinks to $(STOW_DIR)/$(REPO) files
	stow $(STOW_ARGS) --dir=$(STOW_DIR) $(REPO)

	# remove broken symlinks in ~/bin that appear to be from this repo
	@find ~/bin -maxdepth 1 -xtype l 2>/dev/null | while read -r link; do \
		target=$$(readlink "$$link" 2>/dev/null); \
		name=$$(basename "$$link"); \
		if echo "$$target" | grep -qE "(git-tools|stow.*/bin)" || \
		   echo "$$name" | grep -qE "^(git_|gl|gd|Gl|Gd|Gdc|clone_all|docker_enter)"; then \
			if rm -f "$$link" 2>/dev/null; then \
				echo "Removed broken link: $$link"; \
			else \
				echo "Warning: cannot remove $$link (permission denied)"; \
			fi; \
		fi; \
	done

.PHONY: show
show:
	stow --simulate $(STOW_ARGS) --dir=$(STOW_DIR) $(REPO)

.PHONY: clean
clean:
	@echo "Discarding symlinks from repo $(REPO)"
	cd .. && stow --delete $(REPO)

.PHONY: docs
docs:
	@echo "Building Sphinx documentation"
	$(MAKE) -C docs html

.PHONY: docs-show
docs-show: docs
	@echo "Opening documentation in browser"
	xdg-open docs/_build/html/index.html || open docs/_build/html/index.html || echo "Please open docs/_build/html/index.html in your browser"
