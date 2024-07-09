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


bin = eg-00 eg-01 eg-02 eg-02_pack eg-03 eg-03_c eg-04 eg-04_64 eg-05 eg-06 eg-06-alt eg-07-a eg-07-b eg-08 eg-09 eg-10 eg-11 eg-12 eg-13-bug eg-13 eg-14 eg-15 eg-16 eg-17 eg-17-opt

all : $(bin) 

DOCM4_UPDATE



###########################################################
##
## These are the rules of interest in this set of examples.
##

# When applicable, we use some options to minimize "noise" in asm code
#
#  -fno-pic	disable position-independent code, a default gcc feature meant
#		for building shared libraries (DLL). This is not our case here.
#
#  -fno-assuncrhonous-unwind-tables      disables stack unwinding tables, a 
#					 default gcc feature meant for
#		clearing the stack upon the occurrence of asynchronous events
#		such as exception handling and garbage collection. This is
#		only meaningful if asynchronous execution flow deviations are
#		to be supported. None is the case of our programs here.
#  
#  -fcf-protection=none			  disables code for control-flow
#					  integrity enforcement, a default
#		gcc feature intended to enhance security against return
#		return/call/jump-oriented programming attacks. We can 
#		safely get along without it for benefit of readability.
#
#  -Qn		prevents gcc from outputing compiler metainformation e.g.
#		the section .comment, which is not relevant in this context.

CFLAGS_00 = -m32 -Wall -Wno-unused-but-set-variable -O0 -fno-pic -fno-pie NO_CF_PROTECT -fno-asynchronous-unwind-tables -Qn 
LDFLAGS_00 = -m32 -Wall

C_FLAGS = -Wall -Wno-unused-but-set-variable -O0 -fno-pic -fno-pie NO_CF_PROTECT -fno-asynchronous-unwind-tables -Qn
LD_FLAGS = -fno-pic -fno-pie -no-pie

#
# eg-00
#

eg-00 : eg-00.o
	gcc -m32 $(LD_FLAGS) $< -o $@

eg-00.o : eg-00.c
	gcc -m32 -c $(C_FLAGS) $< -o $@

#
# eg-01
#

eg-01 : eg-01.o
	gcc -m32 $(LD_FLAGS) $< -o $@

eg-01.o : eg-01.c
	gcc -m32 -c $(C_FLAGS) $< -o $@


#
# eg-02
#

eg-02 eg-02_pack: % : %.o
	gcc -m32 $(LD_FLAGS)  $< -o $@

eg-02.o eg-02_pack.o : %.o : %.c
	gcc -m32 -c $(C_FLAGS) -O1 $< -o $@


#
# eg-03
#

eg-03 : eg-03.o
	ld -melf_i386 -e init $< -o $@

eg-03.o : eg-03.S
	as -32 $< -o $@

eg-03_c : eg-03_crt0.o eg-03_c.o
	gcc -m32 $(LD_FLAGS) -nostartfiles $^ -o $@

eg-03_c.o : eg-03_c.c
	gcc -m32 $(C_FLAGS) -c $< -o $@

eg-03_crt0.o : eg-03_crt0.S
	as -32 $< -o $@
#
# eg-04
#

eg-04 : eg-04.o
	gcc -m32 $(LD_FLAGS) $< -o $@

eg-04.o : eg-04.c
	gcc -m32 $(C_FLAGS) -c $< -o $@

eg-04_64 : eg-04_64.o
	gcc -m64 $(CFLAGS) $< -o $@

eg-04_64.o : eg-04_64.c
	gcc -m64 $(CFLAGS) -c $< -o $@

#
# eg-05
#

eg-05 : eg-05.o
	gcc -m32 $(LD_FLAGS) $< -o $@

eg-05.o : eg-05.c
	gcc -m32 $(C_FLAGS) -c $< -o $@


#
# eg-06
#

eg-06 : eg-06.o
	gcc -m32 $(LD_FLAGS) $< -o $@

eg-06.o : eg-06.c
	gcc -m32 -c $(C_FLAGS) -O1 $< -o $@

eg-06-alt : eg-06.o
	gcc -m32 $(LD_FLAGS) -O0 $< -o $@

eg-06-alt.o : eg-06.c
	gcc -m32 -c $(C_FLAGS) -O0 $< -o $@


#
# eg-07
#

eg-07-a eg-07-b : % : %.o
	gcc -m32 $(LD_FLAGS) $< -o $@

eg-07-a.o eg-07-b.o: %.o : %.c
	gcc -m32 $(C_FLAGS) -c -O1 $< -o $@

#
# eg-08
# 

eg-08 : eg-08.o
	gcc -m32 $(LD_FLAGS) $< -o $@

eg-08.o : eg-08.c
	gcc -m32 $(C_FLAGS) -c -O1 $< -o $@

#
# eg-09
# 

eg-09 : eg-09.o
	gcc -m32 $(LD_FLAGS) $< -o $@

eg-09.o : eg-09.c
	gcc -m32 -c $(C_FLAGS) -Og $< -o $@

#
# eg-10
#

eg-10 : eg-10.o
	gcc -m32 $(LD_FLAGS) $< -o $@

eg-10.o : eg-10.S
	as -32 $< -o $@

#
# eg-11
#

eg-11 : eg-11.o
	gcc -m32 $(LD_FLAGS) $< -o $@

eg-11.o : eg-11.S
	as -32 $< -o $@

#
# eg-12
#

eg-12 : eg-12.o
	gcc -m32 $(LD_FLAGS) $< -o $@

eg-12.o : eg-12.S
	as -32 $< -o $@

#
# eg-13
#

eg-13-bug eg-13 : % : %.o
	gcc -m32 $(LD_FLAGS) $< -o $@

eg-13-bug.o eg-13.o: %.o : %.S
	as -32 $< -o $@
#
# eg-14
#

eg-14 : eg-14.o
	gcc -m32 $(LD_FLAGS) $< -o $@

eg-14.o : eg-14.S
	as -32 $< -o $@

#
# eg-15
#

eg-15 : eg-15.o
	gcc -m32 $(LD_FLAGS) $< -o $@

eg-15.o : eg-15.S
	as -32 $< -o $@

#
# eg-16
#

eg-16 : eg-16.o
	gcc -m32 $(LD_FLAGS) $< -o $@

eg-16.o : eg-16.S
	as -32 $< -o $@

#
# eg-17
#

eg-17 eg-17-opt : % : %.o
	gcc -m32 $(LD_FLAGS) $< -o $@

eg-17.o : eg-17.c
	gcc -m32 $(C_FLAGS) -c -fno-stack-protector -mpreferred-stack-boundary=2 $< -o $@


eg-17-opt.o : eg-17.c
	gcc -m32 $(C_FLAGS) -c -fno-stack-protector -mpreferred-stack-boundary=2 -Og $< -o $@



##
## Housekeeping
##

.PHONY: clean
clean:
	rm -f $(bin) *.o *.s


DOCM4_BINTOOLS
