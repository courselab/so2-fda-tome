dnl    SPDX-FileCopyrightText: 2024 Monaco F. J. <monaco@usp.br>
dnl   
dnl    SPDX-License-Identifier: GPL-3.0-or-later
dnl
dnl    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

include(docm4.m4)dnl


## Relevant rules for the code examples in this directory.
## 
## The following rules are part of the relevant content of this directory.
## They are meant both as a convenience for building the code examples and
## as a reference for understanding the details of the build process.

all: bcmd.bin

bcmd.bin : main.o bios.o utils.o 
	ld -melf_i386 -T bcmd.ld --orphan-handling=discard $^ -o $@

%.o : %.c
	gcc -m16 -O0 --freestanding -fno-pic NO_CF_PROTECT -c $(CFLAGS) $< -o $@

%.o : %.S
	as -32 $< -o $@

main.o : bios.h

bcmd.bin : .EXTRA_PREREQS = rt0.o bcmd.ld

utils.o : CFLAGS += -Os

.PHONY: clean

clean:
	rm -f *.bin *.o *~ 


dnl
dnl Uncomment to include bintools
dnl
dnl
DOCM4_BINTOOLS

## Makefile automation rules.
##
## SYSeg creates and automatically updates this Makefile from the source 
## Makefile.m4 template, so as to reflect changes in the project's design
## and auxiliary resources. The next rules serve this purpose and are not 
## relevant for the code examples in this directory.

EXPORT_FILES = README Makefile main.c utils.c utils.h bios.S bios.h rt0.S opt.S  bcmd.ld
EXPORT_NEW_FILES = NOTEBOOK
DOCM4_EXPORT([bcmd],[0.1.1])



DOCM4_UPDATE
