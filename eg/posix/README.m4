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

 Title
 ==============================

 This directory contains simple examples illustrating the usage of
 the POSIX API.

DOCM4_INSTRUCTIONS

 Contents
 ------------------------------

 * getpid.c	Usage of getpid() and getppid().

   		Build, execute and inspect the running process with

		   ps uf

 		Observe that getpid's is a child of the shell.

		The child's return status is informed to the parent:

		  echo $?

 * fork.c       Duplicate the caller process.

 * fork-01.c    Execute different code in parent and child.

 * fork-02.c	What happens if either parent or child terminates first.

 * exec.c	Exec a binary program.

 * wait.c	Wait for child to terminate.

 * shell.c	A very simple shell skeleton.

 * shell-01.c	Like shell.c, but accepting program arguments.

 * pipe.c 	IPC with pipes.

 * 

dnl
dnl Uncomment to include bintools instructions
dnl 
dnl DOCM4_BINTOOLS_DOC

