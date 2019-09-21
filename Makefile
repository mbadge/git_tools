# Install git-tools repo resources 
#
# build: execute custom restow to farm symlinks to external files
REPO = "git-tools"
STOW_DIR = /home/$(USER)/stow
STOW_IGNORE_ARGS = --ignore='Makefile' --ignore='restow.sh' --ignore='.*\.swp'


.PHONY: all
all: build

.PHONY: build
build: 
	@echo "Running restow.sh to farm symlinks to $(STOW_DIR)/$(REPO) files"
	./restow.sh

.PHONY: show
show: 
	stow --dir=$(STOW_DIR) $(STOW_IGNORE_ARGS) --verbose=2 --restow $(REPO)

.PHONY: clean
clean:
	@echo "Discarding symlinks from repo $(REPO)"
	cd .. && stow --delete $(REPO)
