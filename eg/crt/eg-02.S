#    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

/* A simple bare-metal C-style program for x86 real-mode.*/
	
	.code16
	.global _start
	
_start:
	jmp init              /* Jump to actuall code.           */
	.fill 60, 1, 0		/* Dummy BPB for annoyting BIOSes. */
init:	

	mov $0xe, %ah		/* BIOS int 0x19 TTY mode          */
	
	mov $'H', %al		/* Mov ASCII of 'H' into AL.       */
	int $0x10		/* Issue BIOS video service 10h.   */

	mov $'e', %al		/* And so on...                    */
	int $0x10

	mov $'l', %al
	int $0x10

	mov $'l', %al
	int $0x10

	mov $'o', %al
	int $0x10

	mov $' ', %al
	int $0x10

	mov $'W', %al
	int $0x10

	mov $'o', %al
	int $0x10
	
	mov $'r', %al
	int $0x10

	mov $'l', %al
	int $0x10

	mov $'d', %al
	int $0x10

halt:	
	hlt
	jmp halt
	
	. = 510 - _start	/* Advance to position 510.    */

	.word 0xaa55		/* Add boot signature.         */
