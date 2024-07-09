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

init: all 

DOCM4_UPDATE

##
## Relevant rules
##

all:

.PHONY: clean

clean :

#
# Programming exercise
#


EXPORT_FILES  = check.sh docrypt encrypt libauth.so.md5 test.cry sample.cry
EXPORT_FILES += Makefile README credentials.cry   docrypt.md5   libauth.so   libmylib.so 
EXPORT_FILES += README ../../tools/COPYING 


DOCM4_EXPORT(hack01,0.1.0)

dnl
dnl Uncomment to include bintools
dnl
dnl
dnl DOCM4_BINTOOLS

