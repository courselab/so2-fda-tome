dnl    SPDX-FileCopyrightText: 2024 Monaco F. J. <monaco@usp.br>
dnl   
dnl    SPDX-License-Identifier: GPL-3.0-or-later
dnl
dnl    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

include(docm4.m4)dnl


DOCM4_RELEVANT_RULES

all: boot.bin

boot.bin : stage1.o bios1.o kernel.o klib.o bios2.o
	ld -melf_i386 -T boot.ld --orphan-handling=discard $^ -o $@

%.o : %.c
	gcc -m16 -O0 --freestanding -fno-pic NO_CF_PROTECT -c $(CFLAGS) $< -o $@

%.o : %.S
	as -32 $< -o $@

stage1.o : bios1.h kernel.h
kernel.o : bios1.h klib.h
klib.o:    bios2.h klib.h

boot.bin : .EXTRA_PREREQS = rt0.o boot.ld

.PHONY: clean

clean:
	rm -f *.bin *.o *~ 


dnl
dnl Uncomment to include bintools
dnl
dnl
DOCM4_BINTOOLS


EXPORT_FILES = Makefile README stage1.c  bios1.S bios1.h  boot.ld  kernel.h  klib.h  kernel.c  klib.c  rt0.S     
EXPORT_NEW_FILES = NOTEBOOK
DOCM4_EXPORT([bl],[1.0.0])


DOCM4_UPDATE
