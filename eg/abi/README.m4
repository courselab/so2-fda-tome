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

include(docm4.m4)

 DOCM4_REVIEW

 Application binary interface
 ==============================

 This directory contains a series of source code files illustrating different
 aspects of the x86 application binary interface and related concepts. It
 includes examples of data alignment, name mangling, syscall interface,
 calling convention, among others.

 Contents
 ------------------------------

 * eg-00.c		Simple source code to exemplify program sections.

   			   make eg-01.o/a*
			   

			Notice sections

			   .text	code (instructions)
			   .data	initialized global variables
			   .bss 	uninitalized global variables


			Try and compare

			   readelf -S eg-00.o

			   readelf -S eg-00

			   
 * eg-01.c		An example to illustrate how variables are allocated.

   			Try

			    make eg-01.o/a*
			    make eg-01/a*

 * eg-02.c		Memory aliment.

   			    make eg-02.o/d*

   			See that struct foo_t occupies 4 rather than 5 bytes.

                            make eg-02/d*

			See that even the .text segment has padding zeroes.

 * eg-02_pack.c		Forced packing.

   			    make eg-02_pack.o/d*

			See that now struct foo_t occupies 5 bytes.

 * eg-03_beta.asm	A minimal asm program which makes a syscall.



 * eg-03.asm		A minimal program that invokes a system call in Linux, x86.

   			Issuing int 0x80 directly.

			Syscall 1 is 'exit' (as it currently stands for
			x86 Linux). On the kernel side, the syscall reads
			eax, and pass its value as a 8-bit return status
			code to the parent process. We can inspect this value
			in variable $? at the shell prompt.

			   make eg-03
			   ./eg-03
			   echo $?

   			Entry point is defined through linker argument.

			   readelf -s eg-03_beta       (for symbol table)
			   readelf -h eg-03_beta       (for elf header)


 * eg-03_c.c		OS and C runtime ABIs.

   			Binary entry point defined by _start (.syntab).

			C entry point called by _start.

 * eg-03_c2.c		C Runtime initialization (crt0).

   			Runtime initilizer is prepended by compiler.

 * eg-04.c		Like eg-03.asm, but written in C.

   			Program calls syscall number 4: write.

 * eg-04_64.c		Like eg-04.c, but for x86_06.

   			Notice that the system call is the same, but 'write'
			now is number 1. Calling syscalls via their numbers
			is not portable.

 * eg-05.c		Call syscall via libc.

   			Rather than invoking the system call directly, we now
			use the runtime C library. Function 'write' performs the
			corresponding syscall using the appropriate parameters.

			   make eg-05       will build x86 version
			   make eg-05_64    will build x86_64 version

			both should work now, because the program will be linked
			against the appropriate implementation of 'write'.

 * eg-06.asm		A call to a void function.

   			Callee returns a value via register eax.

			make eg-06

 * eg-07.c		A C equivalent or eg-06, in x86 Linux.

   			An opportunity to recall the crt0 (c-runtime-zero) appended
			by the linker to provide a C runtime.

			make CFLAGS=-O1 eg-06

 * eg-08.asm		Calling convention: passing arguments via global variables.

 * eg-09.asm		Fastcall calling convention: passing via registers.

 * eg-10.asm		Passing paramter via stack (part I)

 * eg-11.asm 
 


 APPENDEX I
 -----------------------------
 
DOCM4_BINTOOLS_DOC

