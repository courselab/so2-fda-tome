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

#
# Code examples
#

bin = kh eg-00.bin eg-00-r1.bin eg-00-r2.bin eg-01.bin eg-01-r1.bin eg-01-r2.bin eg-02-alpha.bin eg-02-beta.bin eg-02-beta-r1.bin eg-02.bin eg-03-beta.bin eg-03.bin eg-04-alpha.bin eg-04-alpha.bin eg-04-alpha.1.bin eg-04-alpha.2.bin eg-04-beta.bin eg-04-beta+bug.bin eg-04-beta.1.bin eg-04.bin eg-05.bin eg-06.bin eg-07.bin eg-08.bin

binx =  egx-01.bin

all : $(bin) $(binx)

###########################################################                                    
##                                                                                             
## These are the rules of interest in this set of examples.                                    
## 

## Kerninghan & Richie's legacy program.
##

kh : kh.c
	gcc $< -o $@

## Machine code in hex.
## 
## We use the auxiliary tool hex2bin to convert an ASCII file representing
## hexadecimal values in the range [00,FF] into their respective binary values.

eg-00.bin eg-00-r1.bin eg-00-r2.bin foo.bin bar.bin: %.bin : %.hex
	@if ! test -f TOOL_PATH/hex2bin; then \
	echo "Have you read syseg/README?" ; exit 1; fi
	TOOL_PATH/hex2bin $< $@ 


## NASM assembly code (intel syntax).
##
## We build it with NASM assembler, which actually performs both
## the assembling and the linking steps.

eg-01.bin eg-01-r1.bin eg-01-r2.bin eg-02-alpha.bin eg-02-beta.bin eg-02-beta-r1.bin eg-02.bin : %.bin : %.asm
	nasm $< -f bin -o $@

## GAS assembly code (AT&T syntax).
## 
## We build it using GCC toolchain:
## - the assembler 'as' reads the asm code and outputs an elf_32 object;
## - the liker 'ld' reads the elf_32 objects and outputs a flat binary.
##


# Program ld needs to know
#
#   -Text     where in the elf file is the executable code (.text section);
#   -e	      where in the elf file is the executable entry point.
#
#   For the assembler we use
#
#    --32     to produce an elf object (default) for 32-bit platform.
#
#   For the linker we use
#
#   -melf_i386        to read the input file as an elf 32-bit object
#   --oformat=binary to  output a flat-binary (only executable code)
#   
#
# Remember, the BIOS loads our program at 0x7c00.
#
# As for -e, we can use either an absolute address (0x7c00)
# or a label declared global (begin)

eg-03-beta.bin : %.bin : %.o
	ld -melf_i386 --oformat=binary -Ttext=0x7c00 -e begin  $< -o $@

eg-03-beta.o : %.o : %.S
	as --32 $< -o $@

# If we use the default label __start, we can omit it in the command line

ifndef ALT
eg-03.bin : %.bin : %.o
	ld -melf_i386 --oformat=binary -Ttext=0x7c00  $< -o $@

eg-03.o : %.o : %.S
	as --32 $< -o $@
endif

# This is an example of how we can use a one-line GCC command to
# indirectly invoke both the assembler and the linker.
#
# We use command-line options
#
#   -Wl,opt 	tells gcc to pass 'opt' literally to ld;
#
#   -nostdlib   to prevent the default gcc behavior of passing ld
#		command-line options to link the program against
#               the standard C library (libc);

ifeq ($(ALT), 1)
eg-03.bin : %.bin : %.S
	gcc -Wl,--oformat=binary -nostdlib -Ttext=0x7c00 $< -o $@
endif

## C source code.
##
## We build it using GCC toolchain:
## - the preprocessor 'cpp' reads the C source and outputs a preprocessed file;
## - the compiler 'gcc' reads the preprocessed C source and outputs asm code;
## - the assembler 'as' reads the asm code and outputs an elf_32 object;
## - the liker 'ld' reads the elf_32 objects and outputs a flat binary.

# We use the following required gcc options
#
#  -m16		generate asm for a 16-bit CPU (i8086)
#  -O0		to disable any optmization (keep inline asm it is)
#
# Also, we use some options to minimize unecessary clobbering of as code
#
#  -fno-pic	disable position-independent code, a default gcc feature meant
#		for building shared libraries (DLL). This is only meaningful
#		if the program were to interact to an operating system
#		(which is naturally not the case of our stand-alone program).
#	
#
#  -fno-assuncrhonous-unwind-tables      disables stack unwinding tables, a 
#					 default gcc feature meant for
#		clearing the stack upon the occurrence of asynchronous events
#		such as exception handling and garbage collection. This is
#		only meaningful if the program were to interact with the
#		OS, and if asynchronous execution flow deviations are
#		to be supported. None is the case of our program.
#  
#  -fcf-protection=none			  disables code for control-flow
#					  integrity enforcement, a default
#		gcc feature intended to enhance security against return
#		return/call/jump-oriented programming attacks. We can 
#		safely get along without it for benefit of readability.
#
#   All the above features, when enabled, add extra sections in the asm
#   produced by gcc, which would be wiped out by the linker (because of
#   (--oformat=binary), making them pointless anyway.
#   
#
# It's often useful to use
#
#  -Wall	enable warnings for common problems


# eg-04-alpha.bin eg-04-beta.bin eg-04-beta.1.bin : %.bin : %.o
# 	ld -melf_i386 -Ttext=0x7c00 $< --oformat=binary  -o $@

# eg-04-alpha.o eg-04-beta.o eg-04-beta.1.o : %.o : %.s
# 	as --32 $< -o $@

# eg-04-alpha.s eg-04-beta.s eg-04-beta.1.s : %.s : %.i
# 	gcc -m16 -O0 -Wall -fno-pic -fno-asynchronous-unwind-tables -fcf-protection=none -S $< -o $@

# eg-04-alpha.i eg-04-beta.i eg-04-beta.1.i : %.i : %.c
# 	cpp $< -I. -o $@

###

eg-04-alpha.bin :
	make $(@:.bin=.o)

eg-04-alpha.o : %.o : %.s
	-as -32 $< -o $@ 

eg-04-alpha.1.bin eg-04-alpha.2.bin eg-04-beta.bin eg-04-beta+bug.bin eg-04-beta.1.bin: %.bin : %.o
	ld -melf_i386 -Ttext=0x7c00 $< --oformat=binary  -o $@

eg-04-alpha.1.o eg-04-alpha.2.o eg-04-beta.o eg-04-beta+bug.o eg-04-beta.1.o : %.o : %.s
	as --32 $< -o $@

eg-04-alpha.s  eg-04-alpha.1.s eg-04-alpha.2.s eg-04-beta.s eg-04-beta+bug.s eg-04-beta.1.s : %.s : %.i
	gcc -m16 -O0 -Wall -fno-pic -fno-asynchronous-unwind-tables NO_CF_PROTECT -S $< -o $@

eg-04-alpha.i eg-04-alpha.1.i eg-04-alpha.2.i eg-04-beta.i eg-04-beta+bug.i eg-04-beta.1.i : %.i : %.c
	cpp $< -I. -o $@


# Here we use a linker script.
#
# The linker script gives the recipe of how the linker should build up its
# output. Usually, ld resorts for a default script, but we can overwrite it
# with our own script.  This examples uses a linker script which instructs ld to
#
#  - output a flat binary (no headers etc.)
#  - set initial offset to the RAM load address
#  - copy the input file's .text section to the output .text section
#  - copy the input file's .rodata section to the output .text section
#  - add the boot signature at the last 2 bytes of the 512-byte block
#
#  We may therefore omit the corresponding ld's command-line options.
#
#  On the other hand we've added
#
#  --orphan-handling=discard      to instruct ld to discard any section
#				  which we haven't explicitly added
#				  in the linker script.

ifndef ALT

eg-04.bin : %.bin : %.o %.ld
	ld -melf_i386 -T $*.ld --orphan-handling=discard $<   -o $@

eg-04.o : %.o : %.s
	as --32 $< -o $@

# (?) Does cf-protection makes any difference here?
eg-04.s : %.s : %.i %.h
	gcc -m16 -O0 -Wall -fno-pic -fno-asynchronous-unwind-tables NO_CF_PROTECT -S $< -o $@

eg-04.i : %.i : %.c
	cpp $< -I. -o $@

endif

# This is a one-line gcc command that performs the same operation.
# The assembler and linker are evoked as needed. 

ifeq ($(ALT),1)
eg-04.bin : %.bin : %.c %.ld
	gcc -m16 -O0 -Wall -fno-pic NO_CF_PROTECT -I. -nostdlib -T $*.ld -Wl,--orphan-handling=discard  $< -o $@
endif

# Using linker script to define entry, flat binary and boot signature,
# and to place the string in the .text section.

# eg-07.s : %.s : %.c 
# 	gcc -m16 -O0 -Wall -fno-pic  -fcf-protection=none -S $< -o $@

# eg-07-O1.s : %-O1.s : %.c
# 	gcc -m16 -O1 -Wall -fno-pic  -fcf-protection=none -S $< -o $@


# eg-07.bin eg-07-O1.bin : %.bin : %.s eg-07.ld
# 	as --32 $< -o $*.o
# 	ld -melf_i386 -T eg-07.ld $*.o --orphan-handling=discard  -o $@

# # A better implementation of eg-07.c


# eg-08.bin : %.bin : %.c %.ld %.h
# 	gcc -m16 -O0 -I. -Wall -fno-pic  -fcf-protection=none -S $< -o $*.s
# 	as --32 $*.s -o $*.o
# 	ld -melf_i386 -T $*.ld $*.o --orphan-handling=discard  -o $@

## C source using a function to call BIOS int 0x10.
##
## Rather than a function-like macro to inline asm code,
## we use a real function call.

# We have to initialize the stack pointer.
# Here we do it in an ad hoc way using the header file.

eg-05.s : %.s : %.c %.h 
	gcc -m16 -O0 -I. -Wall -fno-pic   -S $< -o $@

eg-05_utils.s  : %_utils.s : %_utils.c 
	gcc -m16 -O0 -I. -Wall -fno-pic   -S $< -o $@

eg-05.o eg-05_utils.o  : %.o : %.s
	as --32 $*.s -o $@


eg-05.bin: %.bin : %.o %_utils.o %.ld
	ld -melf_i386 -T $*.ld --orphan-handling=discard $(filter %.o, $^) -o $@


## C with extended inline assembly
## 
## This is a GCC feature.

eg-06.s : %.s : %.c %.h 
	gcc -m16 -O0 -I. -Wall -fno-pic   -S $< -o $@

eg-06_utils.s  : %.s : %.c 
	gcc -m16 -O0 -I. -Wall -fno-pic   -S $< -o $@

eg-06.o eg-06_utils.o  : %.o : %.s
	as --32 $< -o $@

eg-06_rt0.o  : %.o : %.S
	as --32 $< -o $@

eg-06.bin: %.bin : %_rt0.o %.o %_utils.o %.ld
	ld -melf_i386 -T $*.ld --orphan-handling=discard $(filter %.o, $^) -o $@


## Our final piece of work:
##
## a source code with a familiar C look & feel.

# Since we are naming ours functions like the conventional standard C functions,
# we would clash with the C library. To prevent it, we use
#
#   --freestanding	witch tells gcc we are not using libc.
#
# We are using the linker script to prepend the startup file rt0, therefore
# we can omit it in the command line (as we usually do in hosted programs).


ifndef ALT

eg-07.s : %.s : %.c %.h 
	gcc -m16 -O0 -I. -Wall -fno-pic   --freestanding -S $< -o $@

eg-07_utils.s  : %.s : %.c 
	gcc -m16 -O0 -I. -Wall -fno-pic   --freestanding -S $< -o $@

eg-07_rt0.s  : %.s : %.c 
	gcc -m16 -O0 -I. -Wall -fno-pic   -S $< -o $@

eg-07.o eg-07_utils.o  eg-07_rt0.o : %.o : %.s
	as --32 $*.s -o $@

eg-07.bin: %.bin :  %.o %_utils.o %.ld | %_rt0.o
	ld -melf_i386 -T $*.ld --orphan-handling=discard  $(filter %.o, $^) -o $@

endif

# One line command (given rt0.o)

ifeq ($(ALT),1)

eg-07.bin  : %.bin : %.c %_utils.c  %.h | %_rt0.o %.ld
	gcc -m16 -O0 -I. -Wall -fno-pic NO_CF_PROTECT  --freestanding -nostdlib -T $*.ld -Wl,--orphan-handling=discard $(filter %.c, $^) -o $@

eg-07_rt0.o : %_rt0.o : %_rt0.c 
	gcc -m16 -O0 -I. -Wall -fno-pic NO_CF_PROTECT -c $(filter %.c, $^) -o $@


endif


## eg-08
##
##

eg-08.s : %.s : %.c stdio.h 
	gcc -m16 -O0 -I. -Wall -fno-pic   --freestanding -S $< -o $@

eg-08_utils.s  : %.s : %.c 
	gcc -m16 -O0 -I. -Wall -fno-pic   --freestanding -S $< -o $@

eg-08_rt0.s  : %.s : %.c 
	gcc -m16 -O0 -I. -Wall -fno-pic   -S $< -o $@

eg-08.o eg-08_utils.o  eg-08_rt0.o : %.o : %.s
	as --32 $*.s -o $@

ifeq (,$(ALT))

eg-08.bin: %.bin :  %.o %_utils.o %.ld | %_rt0.o
	ld -melf_i386 -T $*.ld --orphan-handling=discard  $< -o $@
else

eg-08.bin: %.bin :  %.o %_utils.o %.ld | %_rt0.o
	gcc -m16 -nostdlib -ffreestanding -T eg-08.ld eg-08.o -o eg-08
endif


##
## Auxiliary extra examples
##
## Refer to ./README


# Program eg-04.asm in GAS's intel dialict

egx-01.bin : %.bin : %.S
	as -32 -msyntax=intel -mnaked-reg $< -o $*.o
	ld -melf_i386 --oformat=binary -Ttext=0x7c00 -e 0x7c00  $*.o -o $@

# How to read the compiler output

egx-02.o: %.o : %.s
	as --32 $< -o $@

egx-02.s : %.s : %.c
	gcc -m16 -O0 -Wall -fno-pic -fno-asynchronous-unwind-tables NO_CF_PROTECT -S $< -o $@

egx-03.bin : eg-05.c eg-05.h eg-05.ld egx-03.c
	gcc -m16 -O0 -Wall -fno-pic -fno-asynchronous-unwind-tables NO_CF_PROTECT -nostdlib  -I. -T eg-05.ld eg-05.c egx-03.c -o $@

.PHONY: clean clean-extra 

#
# Housekeeping
#

clean:
	rm -f  *.bin *.elf *.o *.s *.iso *.img *.i kh
	make clean-extra

clean-extra:
	rm -f *~ \#*

DOCM4_BINTOOLS

DOCM4_UPDATE


