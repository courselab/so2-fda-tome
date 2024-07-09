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

bin = eg-00.bin eg-01_alpha.bin eg-01.bin eg-02.bin eg-03.bin egx-01.bin egx-02.bin

all : $(bin)



###########################################################                                    
##                                                                                             
## These are the rules of interest in this set of examples.                                    


## GAS assembly.
## We build with as and ld, using a linker script.

eg-00.o eg-01_alpha.o eg-01.o eg-02.o eg-02-v2.o eg-02-v3.o : %.o : %.S
	as --32 $< -o $@

eg-00.bin eg-01_alpha.bin eg-01.bin eg-02.bin eg-02-v2.bin eg-02-v3.bin : %.bin : %.o mbr.ld
	ld -melf_i386 --orphan-handling=discard  -T mbr.ld $(filter %.o, $^) -o $@




## C source code.
## We build the program using gcc, as and ld.

ifdef RT0
LDSCRIPT = rt0.ld
else
LDSCRIPT = mbr.ld
endif



ifdef BADORDER

eg-03.bin  : %.bin : %_utils.o %.o  $(LDSCRIPT) rt0.o
	ld -melf_i386 --orphan-handling=discard -T $(LDSCRIPT) $(filter-out %.ld rt0.o, $^) -o $@
else
eg-03.bin  : %.bin : %.o %_utils.o $(LDSCRIPT) rt0.o
	ld -melf_i386 --orphan-handling=discard -T $(LDSCRIPT) $(filter-out %.ld rt0.o, $^) -o $@
endif



eg-03.o eg-03_utils.o  : %.o: %.s
	as --32 $< -o $@

ifdef SIMPLIFY
eg-03.i eg-03_utils.i : %.i : %.c
	cpp -I. -DATTR="NAKED __attribute__((fastcall))" -DRET="__asm__(\"ret\");"  $< -o $@
else
eg-03.i eg-03_utils.i : %.i : %.c
	cpp -I. -DATTR="" -DRET="" $< -o $@
endif


# eg-03.s eg-03_utils.s  :%.s: %.c
# 	gcc -m16 -O0 -I. -Wall -fno-pic NO_CF_PROTECT  -DATTR="NAKED __attribute__((fastcall))" -DRET="__asm__(\"ret\");" --freestanding -S $< -o $@

# eg-03.s eg-03_utils.s  :%.s: %.c
# 	gcc -m16 -O0 -I. -Wall -fno-pic NO_CF_PROTECT  -DATTR="" -DRET="" --freestanding -S $< -o $@

eg-03.s eg-03_utils.s  :%.s: %.i
	gcc -m16 -O0 -I. -Wall -fno-pic NO_CF_PROTECT  --freestanding -S $< -o $@

rt0.o : %.o : %.S
	as --32 $< -o $@

#
# Test and inspect
#

.PHONY: clean clean-extra intel att 16 32 diss /diss /i16 /i32 /a16 /a32

#
# Extra auxiliary examples
#

egx-01.o egx-02.o : %.o : %.S
	as --32 $< -o $@

egx-01.bin egx-02.bin : %.bin : %.o mbr.ld
	ld -melf_i386 -T mbr.ld --orphan-handling=discard $(filter %.o, $^) -o $@

#
# Housekeeping
#

clean:
	rm -f *.bin *.elf *.o *.s *.iso *.img *.i
	make clean-extra

clean-extra:
	rm -f *~ \#*


DOCM4_BINTOOLS
DOCM4_UPDATE

