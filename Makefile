# Install git-tools repo resources 
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
STOW_IGNORE_ARGS = --ignore='Makefile' --ignore='.*\.swp'


# MAIN ----
.PHONY: all
all: build

.PHONY: build
build: 
	@echo Farming symlinks to $(STOW_DIR)/$(REPO) files
	stow $(STOW_ARGS) $(STOW_IGNORE_ARGS) --dir=$(STOW_DIR)  \
		$(REPO)
	
	# check for bogus symlinks (pointing to non-existent files)
	chkstow -b

.PHONY: show
show:
	stow --simulate $(STOW_ARGS) $(STOW_IGNORE_ARGS) --dir=$(STOW_DIR)  \
		$(REPO)

.PHONY: clean
clean:
	@echo "Discarding symlinks from repo $(REPO)"
	cd .. && stow --delete $(REPO)
