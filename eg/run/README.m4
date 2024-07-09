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

 This directory contains a series of source code files illustrating 
 the POSIX mechanism of process execution, with examples of usage
 of fork, exec and wait functions.

 Contents
 ------------------------------

 * eg-01.c		Simple fork & wait example.

   			Parent finishes first and waits for child.
			Child's exit status is collected by parent.

			Execute and observe.

			Also run

			   ps -p $$ -o tty=

			and in a different terminal, run

			   make TERM=<term> ps

			where <term> is the output of the previos command.

 * eg-02.c		Simple example of exec.

   			If argv[1] is large enough, program calls exec and replace
			its image iwth eg-02_aux.

			Execute and observe.

 * eg-03.c		Fork, exec, wait: the bare bones of a command-line shell.

   			Program reads a program name from the terminal prompt and execute it.

			No support for command-line arguments; no built-in commands.

 * eg-04.c		A small program to illustrate static linking.

  			Compare

  			  make eg-04.o/a
			  make eg-04/a

			and see that the variable's and the function's addresses are
			unresolved. Later on, the linker checks the object's relocation
			section

			  readelf -r eg-04.o

			and detect that the address of the variable should be replaced
			at the indicated offset. Then, in the binary (linked) program,
			the pending symbols are resolved.


			Also, run the program within GDB, set a break point at main(),
			execute the program and disassemble it

			  gdb eg-04
			  break main
			  run
			  disassemble

		 	See that the variable address is now different. This is the
			location in RAM where the variable landed when the OS loaded
			the program.


* eg-05.c	A small program to illustrate reolocation and PIC.

  			
   		This example is simular to eg-04. The program eg-05 calls a
		function defined in a different translation unity eg-05-aux.c

		In the first verion, eg-05-aux.c is converted into the object
		format, and then converted into a static library.  Subsequently,
		the library is linked against eg-05.o to produce the binary
		eg-05-rel.

		We called it '-rel' to highlight the fact that the library
		function's address will relocated during load time.

		We can see the relocation information passed to the loader

		   readelf -r eg-05-rel

		Now, build eg-05-pic

		   make eg-05-pic

               Unlike eg-05-rel, linked against libeg-05-rel.so, this
	       version of the program is liked against libeg-05-pic.so.

	           The difference is produced by the gcc option -fpic and
		   -fno-pic used to produce the objects eg-05-rel.o and
		   eg-05-pic.o.

		Rather than load-time relocation, position-independent code
		(PIC) relies on run-time relocation. It's the program itself
		that computes the symbol address while in execution.

		Compare

		   readelf -r eg-05-rel
		   readelf -r eg-05-pic

		and see that the symbol bar is listed, respective, in the
		dynamic relocation section (load-time), and in the procedure
		linkage table (PLT).

		TODO: explain how PLD and Got work.

		



			
 APPENDEX I
 -----------------------------
 
DOCM4_BINTOOLS_DOC

