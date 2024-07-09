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

 Bare-Metal Hello World
 ==============================================

 This activity is meant for practicing the concepts and techniques addressed by
 the series of examples in section 'syseg/eg/hw'.

 Challenge
 ------------------------------
 
 In the following instructions, conisder that the program 'eg.asm' is one of the
 example programs 'eg/hw/hw-01.asm' or 'eg/hw/hw-02.asm' by your own choice
 (picking the latter is a signal of boldness, but the former is not bad either). 

 This directory includes a 'Makefile' script with a set of handy rules
 preconfigure for your convenience.
 

 1) Assembler

    a) Rewrite program 'eg.asm' as 'hw.S', using AT&T assembly syntax.

    b) Implement an ad hoc assembler+linker program 'hwasm' that takes 'hw.S'
       as input, and produces a flat-binary 'hw.bin', suitable to be loaded and
       executed using the x86 BIOS legacy boot.

       Write 'hwasm.c' in C, using only the ISO-C standard library [[1]].

       The assembler may be a specific-purpose implementation that works only
       with the given input.


    c) Use 'hwasm' to assemble 'hw.S' and produce 'hw.bin'.

       To assembly any file 'foo.S' the program must be invoked like
       'hwasm foo.S' to produce 'foo.bin'.

       Tip: make 'hw.bin' should build the binary. 


    d) Compare 'hw.bin' with 'eg.bin'.

       Tip:   make a16 hw.bin <path>/eg.bin

       Do the outputs match? (They don't necessarily have too).

       Comment in the file 'SOLVING'.

    e) Disassemble 'hw.bin' and compare the result with 'hw.S'.

       Tip:   make hw.bin/a16

       Does the output (at least approximately) matches 'hw.S'? 

       Comment in the file 'SOLVING'.
       
    f) Boot 'hw.bin' using the 'qemu' emulator.

       Tip:   make hw.bin/run

       Does it work?

       Comment in the file 'SOLVING'.
       
    g) Boot 'hw.bin' in a real piece of hardware.

       Tip:  - plug a USB stick into your computer (data will be lost!)
       
             - check which device it is associated to (use lsblk)

	     - double check if the device is correct, and then triple check
	     
	     - make stick IMG=hw.bin DEVICE=<your-usb-stick-device>

	     - ensure that legacy boot is enabled in your BIOS setup

	     - reboot your computer

	Does it work?

	Yeah? Go to show your friends you have written two words on the screen!!!
	     
        Doesn't it work? Bummer! Proceeed to item (h).

	Comment in the file 'SOLVING'.


     h) What if does not work.

        If 'hw.bin' boots with 'qemu' but not with the real pieace of hardware,
        chances are your computer has one of those ripster BIOSes that decide
        to assume that all boot media is FAT-formatted, and thus believe they
        can write things at the beginning of your 512-byte initialization
        program after it has been loaded into RAM.

	To handle such a situation, allow some spare space at the beginning of
	your program, so that the BIOS can write there without messing up with
	your program

	Start your program with a jump instruction that lands at the beginning
	of you executable code, 61 bytes below. Fill in the space between the
	jump instruction and your code with 'not' instructions.

	Tip:  Use the instruction 'jmp' and the directive '.fill'.

	- Assemble your modified 'hw.S' with the GNU Assembler (as)
	- Test it in the emulator to check everything is all right.
	- Try to boot it in the real hardware.

	Comment in the file 'SOLVING'.

      i) Test 'hw.S' implementation using the GNU build chain.

         - Use 'as' to assemble 'hw.S' and produce 'hw2.o'
	 - Use 'ld' to link 'hw2.o' and producude 'hw2.bin'
	 - Boot 'hw2.bin' using 'qemu'.
	 - Compare 'hw.bin' and 'hw2.bin' (see tips above)
	 - Optionally, boot 'hw.bin' in the real hardware.

         Tip: You'll need to tell 'ld' where in the object file the entry point
         of your program is (remeber, 'hw2.o' is not a flat binary). To that
         end, you need to create a global label in 'hw.S' right at the
         beginning of the program. Your assembly code should look like this

	    '        .global _start        '
	    '_start:                       '
	    '        <start of your code>  '    

	 (see 'eg/hw/eg-03.S' for an example)
                   

	 Comment in the file 'SOLVING'.

	 
 Reference
 ------------------------------

 [[1]] C Standard library, https://en.wikipedia.org/wiki/C_standard_library


 DOCM4_EXERCISE_DIRECTIONS

 DOCM4_BINTOOLS_DOC
