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

 TinyOS - A trivial x86 real-mode DOS-like OS
 =============================================
 DOCM4_DIR_NOTICE

 
 Overview
 ------------------------------
 
 In this programming exercise you are invited to write a very simple DOS-like
 kernel. The program should run in x86 real-mode and implement some
 functionality as described bellow. A start-up code based on the example
 syseg/eg/bl is included as inspiration. Unless otherwise specified by the
 instructor, you are encouraged to write your own source code from the scratch,
 rather than coping the provided files. If you do need to reuse the start-up
 code, please do not simply copy the files to your repository. Rather, use the
 SYSeg export facility:

    make export

 That should create a subdirectory with the files ready for being copied.
 If you copy some of the exported files into your repository, do not forget to
 edit the heading comments in the file to fill-in your author information.

 DOCM4_INSTRUCTIONS


 Directions
 ------------------------------

 1) Build and execute boot.img under the x86 emulator (qemu).

 2) Copy the program to a USB stick and boot it with BIOS legacy mode.

 3) Implement some cool functionality in for stage2.c.

    Note: Contrary to the first stage, which is constricted by the 512-byte
    (or shorter) upper bound, the second stage can be considerably large
    (limited only by the available space in the 640K conventional memory).
    Usually, we can carefreely use a few dozen of Kbytes.

    PART I
    ------

    (a) Implement a function help() that prints a "help" message on
    	the screen.

	As a suggestion, writing directly into the video display memory
	can be accomplished with just plain C source code. On the other
	hand, you'd have to implement the usual tty behavior by hand.

    (b) Implement a shell-like command processor.

        The program should show a prompt on the screen, next to which the
	user can enter some single-world command.

	The command processor should then read the user input and proceed
	as follows.

	If the command corresponds to any built-in command, the referred
	command should be executed. Implement at least the command 'help',
	which executes the function help().

	When the command execution is complete, the program should show
	the prompt again and wait for the next command.

	If the command is not recognized, show an error message and get
	back to the prompt.

	Tips: - BIOS interrupt 16h gives access to the keyboard services.
	        See https://en.wikipedia.org/wiki/INT_16H.

    (c) Implement another command that uses some BIOS service.

    	Tips: - See https://en.wikipedia.org/wiki/BIOS_interrupt_call

	With BIOS services you can get current date, available memory etc.
	
    PART II
    -------

    (a) Write write your kernel into a FAT-23 formatted USB stick.

	Get a USB disk and use your regular OS (e.g. Linux, Windows) to format
	it with a FAT32 file system.

	Then create a Make rule in your project's Makefile that write your file
	to the MBR (Master Boot Record) of the USB stick.

	Boot your OS in the emulator and, if possible in the phyisical hardware.


    (b) Extend your command-line processor to execute external programs.

        If a command entered by the user is not recognized as a built-in
	command of your OS, then it should be interpreted as the name
	of an executable file.

	Search for the file in the boot media (the disk from which the OS
	has booted) and, if found, load the file into the RAM (byte per
	byte as is).

	Then, transfer execution to the just loaded program. When the execution
	finishes, return to the command processor and present the prompt again.

    (c) ... (to be updated).

 DOCM4_CLOSING_WORDS 


 APPENDIX A: Coding and delivering.
 ----------------------------------

 Created a directory tyos under your project repository and implement the
 programming exercise within it.

 Use the tag tyos-1a for the part I item (a) of the exercise, tyos-1b for
 part I item (b) and so on. Unless otherwise specified, you don't need to
 deliver part (a), (b) etc. separately; you can just deliver tyos-1c, for
 instance, to signal that you have completed part I items (a) and (b) already.

 DOCM4_DELIVERY_DIRECTIONS

 APPENDIX B: SYSeg conventions.
 ----------------------------------
 
DOCM4_BINTOOLS_DOC 

 
