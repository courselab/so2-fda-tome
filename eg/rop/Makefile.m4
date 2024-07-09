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

bin =  eg-00 eg-00a eg-01 eg-01 eg-02 eg-03 eg-04 eg-04a eg-05 eg-06 eg-07 eg-08 eg-09 # eg-10 eg-11

all: $(bin)

eg-00 : eg-00.c
	gcc -Wall -g -m32 -Wall -Wno-unused -O0 NO_CF_PROTECT -fno-stack-protector -fno-pie -fno-pic $<  -o $@

eg-00a : eg-00a.c
	gcc -Wall -g -m32 -Wall -Wno-unused -O0 NO_CF_PROTECT -fno-pie -fno-pic $<  -o $@

eg-01 : eg-01.c
	gcc -g -m32 -Wall -Wno-unused -O0 NO_CF_PROTECT -fno-pie -fno-stack-protector -mpreferred-stack-boundary=2 $<  -o $@

eg-02 : eg-02.c
	gcc -g -m32 -Wall -Wno-unused -O0 NO_CF_PROTECT -fno-pie -fno-stack-protector -mpreferred-stack-boundary=2 $<  -o $@

eg-03 : eg-03.c
	gcc -g -m32 -Wall -Wno-unused -O0 NO_CF_PROTECT -fno-pie -fno-stack-protector  $<  -o $@

eg-04 : eg-04.c
	gcc -g -m32 -Wall -Wno-unused -O0 NO_CF_PROTECT -fno-pie -fno-stack-protector  $<  -o $@

eg-04a : eg-04a.c
	gcc -g -m32 -Wall -Wno-unused -O0 NO_CF_PROTECT -fno-pie -fno-stack-protector  $<  -o $@

eg-05 : eg-05.c
	gcc -g -m32 -Wall -Wno-unused -O0 NO_CF_PROTECT -fno-pie -no-pie $<  -o $@

eg-06 : eg-06.c
	gcc -g -m32 -Wall -Wno-unused -O0 NO_CF_PROTECT -fno-pie -no-pie $<  -o $@

eg-07 : eg-07.c
	gcc -Wall -g -m32 -Wall -Wno-unused -O0 NO_CF_PROTECT -fno-pie -fno-pic -no-pie $<  -o $@

eg-08 : eg-08.c
	gcc -Wall -g -m32 -Wall -Wno-unused -O0 NO_CF_PROTECT -fno-pie -fno-pic -no-pie $<  -o $@

eg-09 : eg-09.c 
	gcc -Wall -g -m32 -Wall -Wno-unused -O0 NO_CF_PROTECT -fno-stack-protector -mpreferred-stack-boundary=2 -fno-pie -fno-pic -z execstack -Wno-deprecated-declarations --ansi -no-pie $<  -o $@

eg-09.in : eg-09.bin eg-09.sh
	./eg-09.sh $<

eg-09.bin : eg-09.S
	as --32 $< -o $@.o
	ld -melf_i386 --oformat=binary -Ttext=0x0 $@.o -o $@

eg-09.elf : eg-09.S
	as --32 $< -o $@.o
	ld -melf_i386  $@.o -o $@




%/main: %
	objdump -m i386 --disassemble=main $< | sed  's/:\(\t.*\t\)/:    /g'



.PHONY: clean

clean :
	rm -f $(bin) *.o *.in *.bin *.elf

dnl
dnl Uncomment to include bintools
dnl
dnl
DOCM4_BINTOOLS

