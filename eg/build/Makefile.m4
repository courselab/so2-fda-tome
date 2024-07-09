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
# Main examples and auxiliary examples
#

bin = eg-01 eg-02-int eg-02-char eg-02-implicit eg-02-var-int eg-02-var-char eg-03-guessok eg-03-guessbad eg-03 eg-04-beta eg-04 eg-06 eg-06 eg-08 eg-08_alt
bin : $(bin)


BARE= -fno-pic -fno-pie -fno-asynchronous-unwind-tables NO_CF_PROTECT

# Very simple example to illustrate the build steps

eg-01 : % : %.o %.i
	gcc -m32 -Wall -O0 $< -fno-pic -o $@

eg-01.o : %.o : %.s
	as -32 $< -o $@

eg-01.s : %.s : %.i
	gcc -Wall -O0 -m32 $(BARE) -Wl,--static -S $< -o $@

eg-01.i : %.i : %.c
	cpp -Wall -P $< -o $@

# Implicit declaration


eg-02-int eg-02-char eg-02-implicit eg-02-mismatch: eg-02-% : eg-02-%.i
	gcc -m32 -Wall $< -o $@

eg-02-int.i eg-02-char.i: eg-02-%.i : eg-02.c
	cpp $< -Dfoo_t=$* -o $@

eg-02-implicit.i eg-02-mismatch.i: %.i : %.c
	cpp $< -o $@


eg-02-var-int eg-02-var-char: eg-02-var-% : eg-02-var.c
	- gcc -m32 -Dvarb_t="$*" $< -o $@


# Compilation unities

eg-03-alpha : % : %.c
	gcc -Wall $< -o $@
	@echo "Note: it's ok, we were expecting this warning"
	@echo

# Try also wtih -Wstrict-prototypes
eg-03-guessok eg-03-guessbad eg-03: % : %.c
	- gcc -Wall -Wextra $(CFLAGS)  -m32 $< -o $@

#

eg-04-beta : % : %.c
	gcc -Wall $< -o $@

eg-04 : % : %.i
	gcc -Wall $< -o $@

eg-04.i : %.i : %.c %.h
	gcc -E -I. -P $< -o $@

eg-05.i : %.i : %.c
	gcc -E -I. -P $< -o $@

eg-05:
	@echo "Not a target; see README."

ifndef ALT
eg-06 : % : %.o %_foo.o %_bar.o
	gcc -Wall $^ -o $@
else
eg-06 : % : %.o lib%.a
	gcc -Wall $< -fno-pie -o  $@ -L. -l$*
endif

eg-06.o eg-06_foo.o eg-06_bar.o eg-06_baz.o: %.o : %.s 
	gcc -Wall -c -fno-pie $< -o $@

eg-06.s eg-06_foo.s eg-06_bar.s eg-06_baz.s : %.s : %.i
	gcc -S $< -fno-pic -o $@

eg-06.i : %.i : %.c %.h
	gcc -E -I. -P $< -o $@

eg-06_foo.i  eg-06_bar.i eg-06_baz.i : %.i : %.c 
	gcc -E -I. -P $< -o $@

ifeq ($(ALT), 1)
libeg-06.a : eg-06_foo.o eg-06_bar.o
	ar rs $@ $^
endif

ifeq ($(ALT),2)
libeg-06.a : eg-06_foo.o eg-06_bar.o eg-06_baz.o
	ar rs $@ $^
endif

eg-07.a :
	echo AAAAAAAAAA > f1
	echo BBBBBBBBBB > f2
	ar r $@ f1 f2




libeg-08.a: eg-08_foo.o eg-08_bar.o
	ar rcs $@ $^  

eg-08_foo.o eg-08_bar.o eg-08.o: %.o : %.c
	gcc -c $< -o $@

eg-08 : eg-08.o libeg-08.a
	gcc -L. eg-08.o -leg-08 -o $@


eg-08_alt: eg-08.o eg-08_foo.o eg-08_bar.o
	gcc $^ -o $@

.PHONY: clean

clean:
	rm -f $(bin) *.o *.i *.a main *.s *~ f1 f2 f

DOCM4_BINTOOLS
DOCM4_UPDATE 
