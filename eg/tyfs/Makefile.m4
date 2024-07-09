dnl    SPDX-FileCopyrightText: 2024 Monaco F. J. <monaco@usp.br>
dnl   
dnl    SPDX-License-Identifier: GPL-3.0-or-later
dnl
dnl    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

include(docm4.m4)dnl

DOCM4_RELEVANT_RULES

# Build the OS and an example user program.

all: tyfsedit

%.o : %.c
	gcc -c $(CPPFLAGS) $(CFLAGS) $< -o $@

tyfsedit : tyfsedit.o
	gcc $< -lm -o $@

# Create a 1.44 MB floppy image (2880 * 512 bytes)

disk.img:
	rm -f $@
	dd if=/dev/zero of=$@ count=2880

.PHONY: clean img

clean:
	rm -f *.o tyfsedit img

dnl
dnl Uncomment to include bintools
dnl
dnl
DOCM4_BINTOOLS


EXPORT_FILES = Makefile README tyfsedit.c debug.h
EXPORT_NEW_FILES = NOTEBOOK
DOCM4_EXPORT([tyfs],[1.0.0])


DOCM4_UPDATE
