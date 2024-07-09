dnl    SPDX-FileCopyrightText: 2024 Monaco F. J. <monaco@usp.br>
dnl   
dnl    SPDX-License-Identifier: GPL-3.0-or-later
dnl
dnl    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

include(docm4.m4)dnl

DOCM4_RELEVANT_RULES

# By default, the bootable program name will by $(dosname).bin
# If you export this directory to extend the example as part of a programming
# exercise, redefine $(dos) to reflect your own DOS name, say
# dos = "amazingOS" 

dos=$(shell basename $$(realpath .))

# Build the OS and an example user program.

all: $(dos).bin prog.bin

# Link all objects needed by the OS.

$(dos).bin : bootloader.o bios1.o kernel.o kaux.o bios2.o logo.o syscall.o 
	ld -melf_i386 -T tydos.ld --orphan-handling=discard $^ -o $@

# Here we are statically linking the user program 'prob.bin' into the kernel,
# so as to simulate the execution of a user program. If we were to actually load
# and execute an external program, we should remove 'prog.o' and 'libtydos.o'
# from the list of pre-requisites, and edit the linker script accordingly.
# Comment out the following line if this is the case.

$(dos).bin : prog.o libtydos.o 

# Rules to build objects from either C or assembly code.

%.o : %.c
	gcc -m16 -O0 --freestanding -fno-pic NO_CF_PROTECT -c $(CFLAGS) $< -o $@

%.o : %.S
	as -32 $< -o $@

bootloader.o : bios1.h kernel.h 
kernel.o : bios1.h bios2.h kernel.h kaux.h   
kaux.o:    bios2.h kaux.h   

$(dos).bin : .EXTRA_PREREQS = rt0.o tydos.ld

# Rules to build the user programs
# You would add new programs to this variable if bulding other user programs.
# The user library is automatically added by the linker script.

progs = prog.bin

$(progs)  : %.bin : %.o libtydos.a 
	ld -melf_i386 -T prog.ld --orphan-handling=discard $< -o $@

$(progs:%.bin=%.o) : %.o : %.c tydos.h
	gcc -m16 -O0 --freestanding -fno-pic NO_CF_PROTECT -c $(CFLAGS) $< -o $@

$(progs:%.bin=%.o) : tydos.h

$(progs:%.bin=%.o) : .EXTRA_PREREQS = prog.ld

# Recipes to build the user library.

libtydos.o: libtydos.c tydos.h
	gcc -m16 -O0 --freestanding -fno-pic NO_CF_PROTECT -c $(CFLAGS) $< -o $@

libtydos.o : tydos.h

libtydos.a : libtydos.o
	ar rcs $@ $^

# Housekeeping.

.PHONY: clean

clean:
	rm -f *.bin *.o *~ *.s *.a

dnl
dnl Uncomment to include bintools
dnl
dnl
DOCM4_BINTOOLS


EXPORT_FILES = Makefile README bootloader.c kernel.c kernel.h kaux.c kaux.h bios1.S bios1.h bios2.S bios2.h syscall.c tydos.ld  libtydos.c tydos.h tydos.h prog.c prog.ld rt0.S  logo.c
EXPORT_NEW_FILES = NOTEBOOK
DOCM4_EXPORT([$(dos)],[1.0.0])


DOCM4_UPDATE
