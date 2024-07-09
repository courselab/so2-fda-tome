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

 Autotools by example
 ==============================

 This directory contains a series of code examples that illustrate the
 step-by-step configuration of the GNU Build System toolchain (aka
 Autotools) for building a simple C program.

 The sequence starts as simple as minimal Autootls configuration, which
 is then incrementally sophisticated to expore more advanced features.
 The examples are by no means exhaustive and do not necessarily reflect
 all the possible cenarios, experts' practices or deep hackery. As for
 that I may suggest some references [1-5] listed bellow.

 CONTENTS
 ------------------------------

 Contents of syseg/extra/autootols

 Please refer to README in each subdirector for detailed information.

 * eg-00      A very simple handcrafted Makefile


 REFERENCES
 ------------------------------

 [1] Diego Elio, Autotools Mythbuster
     https://autotools.info/

 [2] GNU.org, An Introduction to Autotools, chapter in GNU Automake Manual,
     https://www.gnu.org/software/automake/manual/html_node/Autotools-Introduction.html

 [3] GNU.org, Automake manual
     https://www.gnu.org/software/automake/manual/

 [4] GNU.org, Autoconf manual
     https://www.gnu.org/software/autoconf/manual/

 [5] GNU.org, Libtool manual
     https://www.gnu.org/software/libtool/manual/
