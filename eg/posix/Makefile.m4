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

CPP_FLAGS = $(CPPFLAGS)
C_FLAGS   = -Wall -Wno-parentheses $(CFLAGS)
LD_FLAGS  = $(LDFLAGS)


bin = getpid fork fork-01 fork-02 exec exec-01 wait loop open redir shell-loop shell-redir shell-pipe shell-job pipe pipeline kill sigaction sigaction-handler ctermid pgid tcpgrp

all: $(bin)

$(bin) : % : %.c
	gcc $(CPP_FLAGS) $(C_FLAGS) $(LD_FLAGS) $< -o $@

exec-01 : loop
kill : CPPFLAGS=-D_GNU_SOURCE
sigaction : CPPFLAGS=-D_GNU_SOURCE
sigaction-handler: CPPFLAGS=-D_GNU_SOURCE



.PHONY: clean

clean :
	rm -f *.o $(bin)
	rm -f *~

dnl
dnl Uncomment to include bintools
dnl
dnl
dnl DOCM4_BINTOOLS

