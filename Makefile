# Install git-tools repo resources 
#
# recipes
# * build: execute custom restow to farm symlinks to external files
#
# params 
# * REPO: what repo to install/clean


# PARAMS ----
REPO = "git-tools"
# [snippet] list all downstream directories: `sh $ Cp "$(ls -1 | tr '\n' ' ')"`

STOW_DIR = /home/$(USER)/stow
STOW_ARGS = --restow
STOW_IGNORE_ARGS = --ignore='Makefile' --ignore='restow.sh' --ignore='.*\.swp'


# MAIN ----
.PHONY: all
all: build

.PHONY: build
build: 
	@echo "Running restow.sh to farm symlinks to $(STOW_DIR)/$(REPO) files"
	stow $(STOW_ARGS) $(STOW_IGNORE_ARGS) --dir=$(STOW_DIR)  \
		$(REPO)
	
	# check for bogus symlinks (pointing to non-existent files)
	chkstow -b


.PHONY: show
show: 
	tree -I .git -a
   
.PHONY: clean
clean:
	@echo "Discarding symlinks from repo $(REPO)"
	cd .. && stow --delete $(REPO)
