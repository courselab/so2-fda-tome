dnl    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
dnl   
dnl    SPDX-License-Identifier: GPL-3.0-or-later
dnl
dnl    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
dnl
dnl    >> Usage hint:
dnl
dnl       If you're looking for a file such as README or Makefile, then this one 
dnl       you are reading now is probably not the file you are interested in. This
dnl       and other files named with suffix '.m4' are source files used by SYSeg
dnl       to create the actual documentation files, scripts and other items they
dnl       refer to. If you can't find a corresponding file without the '.m4' name
dnl       extension in this same directory, then chances are that you have missed
dnl       the build instructions in the README file at the top of SYSeg's source
dnl       tree (yep, it's called README for a reason).

include(docm4.m4)dnl

##
## Relevent files for this exercise.
##

all: hw.bin

hw.bin : hw.S hwasm
	./hwasm hw.S hw.bin

hwasm : hwasm.c
	gcc -Wall --ansi hwasm.c -o hwasm

hw2.bin: hw2.o
	ld -melf_i386 --oformat=binary -Ttext=0x7c00 hw2.o -o h2.bin

hw2.o: hw.S
	as --32 hw.S -o hw.o


.PHONY: clean

clean:
	rm -rf *.bin *.o
	rm -f *~ 

# Create stand-alone distribution

EXPORT_FILES = README Makefile
EXPORT_NEW_FILES = NOTEBOOK

DOCM4_BINTOOLS
DOCM4_EXPORT([hw],[0.1.1])
DOCM4_UPDATE

