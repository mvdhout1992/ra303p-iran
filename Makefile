# if you are on windows you can use build.bat instead of make

BUILD_DIR = .
# should be tools repo
TOOLS_DIR = ../nasm-patcher

LINKER    = $(BUILD_DIR)/linker$(EXT)
PETOOL    = $(BUILD_DIR)/petool$(EXT)

NASM     ?= nasm
NFLAGS    = -I./include/

default: ra95.exe

%.exe: %.ext $(LINKER) src/main.asm
	cp $< $@
	$(LINKER) src/main.asm src/main.inc $@ $(NASM) $(NFLAGS)

%.ext: %.dat $(PETOOL)
	cp $< $@
	$(PETOOL) $@ AUTO rwxc
	$(PETOOL) $@ .patch rwxci 131072

%.dat:
	@echo "You are missing the required orininal executable, \"$(@F)\""
	@false

clean: clean_tools
	rm -f *.exe src/*.map src/*.bin src/*.inc

.PHONY: clean

include $(TOOLS_DIR)/Makefile
