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

 Introduction to Build Automation With Make
 ==========================================

 Step-by-step example of how to prepare a Makefile for a simple,
 single-binary, C project.

 The example
 ------------

 The example-program foo, implemented in the main source-file main.c,
 calculates the area of a few 2D geometric objects by calling appropriate
 functions, each defined in a different source file. Foo's source code is
 therefore organized as follows:


 * main.c      is the the main program which output the results
 * circle.c    function 'circle' return a circle's area given its radius
 * rectangle.c function 'rectangle' returns a rectangle's area given the sides
 * square.c    function 'square' returns a square's area by invoking 'rectangle'

 Each source file has it's companion header file circle.h, rectangle.h and
 square.h, respectively.

 If a header file bar.h is included by a source file baz.c, then any
 modification in bar.h may potentially affect the object baz.o. Therefore,
 if bar.h is edited, bar.o must be rebuilt. Likewise, if a binary program
 qux is linked against the object baz.o, then qux must be rebuilt as well.

 The diagram of dependencies for the project foo is illustrated in figure
 deps/deps.pdf. The block 'main' represents the target executable file. The
 object files, source files and header files are marked with their respective
 names. The arrows account for dependencies: an arrow from file foo to file bar
 means that bar needs to be rebuilt if foo changes.  The complete graph offers
 a visual insight or the dependency relation among all files.

 The crude way for building main out from the sources is issuing

    $ gcc main.c circle.c rectangle.c square.c -o main

 every time any of the source or header file is modified.  All the sources
 are compiled into objects, and the objects are linked.

 A little less naive approach would be to compile only the affected object and
 re-link the binary. For instance, if rectangle.h is modified,

   $ gcc -c square.c
   $ gcc main.o circle.o rectangle.o square.o -o main

 The POSIX utility 'make' is aimed at automatizing this process by detecting
 which files need to be rebuilt and performing solely the steps which are 
 necessary for that.  The input to the command 'make' is a script file named
 Makefile, which contains a description of the dependency graph in a high-level
 symbolic notation.

 Basically, a Makefile contains 'rules' in the form

 target : prerequisite
       receipt
    
 For instance

 foo : bar
     do_it

 means that the target foo depends on the prerequisite bar, and that in order
 to make bar, the receipt do_it must be executed.  Targets and prerequisites
 are usually file names and the receipt is a shell-script command line.
 For example

 main.o : main.c circle.h rectangle.h square.h
        gcc -c main.c

 means that main.o must be rebuilt whenever one or the prerequisites are
 modified, and to that end the indicated gcc command line must be issued.
 A detailed description of make's working principles and the Makefile syntax
 may be found in make's documentation.  Here we have a very basic overview
 depicted in form of step-by-step examples.

 Consider the Makefiles below for the project foo. Each, in order, incorporate
 incremental additions staring from a trivial example up to a moderately
 elaborated Makefile which can be used as a boilerplate for simple single-binary
 C projects.


 Makefile-00: Trivial makefile 
 Makefile-01: Conventional all and clean targets
 Makefile-02: Variables and automatic variables
 Makefile-03: Split object and header dependences
 Makefile-04: Pattern rules for source dependencies
 Makefile-05: Automatically detecting header dependences
 Makefile-06: User and maintainer flags
 Makefile-07: Install rule
 Makefile-08: Distribute rule
 Makefile-09: Add-ons with conditionals and functions


 In order to try the examples, issue

   $ make -f <Makefile-nn>


