dnl    SPDX-FileCopyrightText: 2021 Monaco F. J <monaco@usp.br>
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

 CODE EXAMPLES
 ==============================

 Contents of syseg/eg

 Please refer to README in each subdirector for detailed information.

 * hw 	      Hello World bare metal (from machine code, to asm, up to C)
 * real	      Real-mode: segmented memory, memory-mapped io etc.
 * build      Basics of building a C program, static library
 * make	      Build automation with make, the principles
 * abi	      Application-binary interface
 * bl	      A two-state bootloeader example
 * crt	      C runtime initializer
 * format     FAT file system formatting
 * posix      Code snippets with POSIX API call examples
 * real	      Real-memory manipulation
 * rop	      Return-oriented programming examples
 * run	      Process execution
 * tyos	      A tiny real-mode OS kernel
 * tyos32     Like tyos, swithing to protected mode


