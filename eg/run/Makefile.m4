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
DOCM4_HASH_HEAD_NOTICE([Makefile],[Makefile script.])

bin = eg-01 eg-02

WARN = -Wall -Wno-unused-result -Wno-parentheses

CPP_FLAGS=  $(WARN) $(CPPFLAGS)
C_FLAGS= -Og -m32 NO_CF_PROTECT  $(CFLAGS)
LD_FLAGS= -m32 $(LDFLAGS)

#
# eg-01
#

eg-01.o : eg-01.c
	gcc -c $(CPP_FLAGS) $(C_FLAGS) $< -o $@

eg-01 : eg-01.o
	gcc $(LD_FLAGS) $< -o $@

#
# eg-02
#

eg-02-static.o eg-02a-static.o: %-static.o : %.c
	gcc -c -fno-pic -fno-pie $(CPP_FLAGS) $(C_FLAGS) $< -o $@

libeg-02.a : eg-02a-static.o
	ar -rcs $@ $^

eg-02-static : eg-02-static.o libeg-02.a
	gcc -no-pie $(LD_FLAGS) -L.  eg-02-static.o -leg-02 -o $@

#

eg-02-rel.o eg-02a-rel.o: %-rel.o : %.c
	gcc -c -fno-pic -fno-pie $(CPP_FLAGS) $(C_FLAGS) $< -o $@

libeg-02-rel.so : eg-02a-rel.o
	gcc --shared -fno-pic $(LD_FLAGS) $^ -o $@

eg-02-rel : eg-02-rel.o libeg-02-rel.so
	gcc $(LD_FLAGS)  -L. eg-02-rel.o  -leg-02-rel -fno-pic -fno-pie -o eg-02-rel

#

eg-02-pic.o eg-02a-pic.o eg-02b-pic.o : %-pic.o : %.c
	gcc -c -fpic -fpie $(CPP_FLAGS) $(C_FLAGS) $< -o $@

libeg-02-pic.so : eg-02a-pic.o
	gcc --shared -fpic $(LD_FLAGS) $^ -o $@

eg-02-pic : eg-02-pic.o libeg-02-pic.so
	gcc $(LD_FLAGS)  -L. eg-02-pic.o  -leg-02-pic -fpic -fpie -o eg-02-pic


libother.so : eg-02b-pic.o
	gcc --shared -fpic $(LD_FLAGS) $^ -o $@




##
## Housekeeping
##

.PHONY: clean
clean:
	rm -f $(bin)
	rm -f *-rel *-pic *-static *.a *.so *.d *.o


DOCM4_UPDATE

DOCM4_BINTOOLS

# Local rules

# ps :
# 	term=$$(ps -p $$$$ -o tty=); while true; do ps axf | grep "$$term" ; sleep 1; clear; done 


ps :
	while true; do ps axf | grep "$(TERM)" ; sleep 1; clear; done 


