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

 Tyos32 - Tiny OS 32-bit version.
 ==============================================

 This is a very simple code example to demonstrate the procedure to switch from
 real to protected mode. First stage, the boot loader, fits entirely within
 the 512-byte master boot record of a USB stick. It is meant to be loaded
 through legacy BIOS boot method and execute in real mode on any x86 platform.
 When loaded, the 512-byte bootloader loads the second stage and calls
 the function init(), expected to be implemented by the latter program.
 The second stage perform all the steps to switch to 32-bit protected mode.

 DOCM4_INSTRUCTIONS

 Contents
 ------------------------------

 * rt0.S	startup file (runtime initialization).
 * bootloader.c	the first stage of the boot sequence.
 * utils.c	handy functions to be used by the bootloader.
 * init32.S	prepare GTD and switch to 32-bit protected mode.
 * kernel.c	the second stage of the boot sequence.
 * boot.ld	the linker script used to build the binary.
  
 To experiment with the code example, try:

    make boot.bin

 This should build the objects and linke them to form boot.bin.

 The linker script makes sure that a boot signature is written at end of the
 first 512-byte block, after rt0 and bootloader, and that the kernel is written
 at the beginning of the next block.

 Test the boot image with

   make boot.bin/run

 If everything is ok, you should see a message by the bootloader and another
 message by the loaded kernel.

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
 


 DOCM4_CLOSING_WORDS 


 APPENDIX A: SYSeg conventions.
 ----------------------------------
 
DOCM4_BINTOOLS_DOC 

 
