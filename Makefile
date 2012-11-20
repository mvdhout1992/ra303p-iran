NFLAGS=-I./include/
CC?=gcc
DAT=ra95.dat
EXE=ra95.exe
NASM?=nasm$(EXT)
REV=$(shell sh -c 'git rev-parse --short @{0}')
CFLAGS=-m32 -pedantic -O2 -Wall -DREV=\"$(REV)\"

all: ra95.exe build

tools: linker$(EXT) extpe$(EXT)

ra95.exe: $(DAT) extpe$(EXT)
	cp $(DAT) $(EXE)
	./extpe$(EXT) $(EXE) .patch rwxc 4096
	./extpe$(EXT) $(EXE) .patch2 rwxc 4096
	./extpe$(EXT) $(EXE) .patch3 rwxc 4096
	./extpe$(EXT) $(EXE) .patch4 rwxc 4096

build: linker$(EXT)
	./linker$(EXT) src/main.asm src/main.inc $(EXE) $(NASM) $(NFLAGS)
	./linker$(EXT) src/nocd_search_type.asm src/nocd_search_type.inc $(EXE) $(NASM) $(NFLAGS)
	./linker$(EXT) src/version.asm src/version.inc $(EXE) $(NASM) $(NFLAGS)	
	./linker$(EXT) src/test.asm src/test.inc $(EXE) $(NASM) -I./include/

$(DAT):
	@echo "You are missing the required ra95.dat from 3.03 patch"
	@false

linker$(EXT): tools/linker.c
	$(CC) $(CFLAGS) -o linker$(EXT) tools/linker.c

extpe$(EXT): tools/extpe.c tools/pe.h
	$(CC) $(CFLAGS) -o extpe$(EXT) tools/extpe.c

clean:
	rm -rf extpe$(EXT) linker$(EXT) $(EXE) src/*.map src/*.bin src/*.inc
