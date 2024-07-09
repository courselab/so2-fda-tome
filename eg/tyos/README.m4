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

 Boot loader
 ==============================================

 This is a very simple code example to demonstrate the two stage boot
 loading procedure. First stage, the boot loader, fits entirely within
 the 512-byte master boot record of a USB stick. It is meant to be loaded
 through legacy BIOS boot method and execute in real mode on any x86 platform.
 When loaded, the 512-byte bootloader loads the second stage and calls
 the function init(), expected to be implemented by the latter program.
 The second stage does nothing but printing a welcome message.
 Everything runs in x86 real-mode (we're not going 32bit yet).

 DOCM4_INSTRUCTIONS

 Contents
 ------------------------------

 * stage1.c	the first stage of the boot sequence.
 * stage2.c	the first stage of the boot sequence.
 * utils.c	some handy functions for stage1 and stage2.
 * rt0.S	startup file (runtime initialization).
 * boot.ld	is the linker script used to build the binary.
  
 To experiment with the code example, try:

    make boot.bin

 This should build the objects

   rt0.o stage1.o core.o stage2.o

 which are then linked in this order to form boot.bin.

 The linker script makes sure that a boot signature is written at end of the
 first 512-byte block, after rt0 and stage1, and that stage2 is written
 at the beginning of the next block.

 Test the boot image with

   make boot.bin/run

 If everything is ok, you should see a message by stage1 and another message
 by stage2.

 To test with the physical hardware, you can write boot.bin directly into
 a USB stick and then boot using it.

 Alternatively, you can create a FAT12-formatted 1.44 MB floppy disk image with

   make boot.img

 You can either boot boot.img with the emulator

   make boot.img/run

 or write the image into the USB sitck and boot it on the physical hardware

   dd if=boot.img of=<your-usb-device>

 The program source code is extensively commented and contains detailed
 information on how the program works. In special, rt0.S and boot.ld have some
 in-depth technical notes on the hardware and the build tools.
 

 Challenge
 ------------------------------

 There is a related programming exercise in syseg/try/bl.

 DOCM4_CLOSING_WORDS 


 APPENDIX A: Coding and delivering.
 ----------------------------------

 Use the tag bl.

 DOCM4_EXERCISE_DIRECTIONS

 APPENDIX B: SYSeg conventions.
 ----------------------------------
 
DOCM4_BINTOOLS_DOC 

 
