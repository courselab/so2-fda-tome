#    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

	/* Prints one character in video display memory.

	   Bug fixed.
	*/

	
  .code16

__start:

	mov $0x0, %si
	
	mov $0xb800, %ax
	mov %ax, %es		   /* Extra segment.        */
	
	movb msg, %al
        movb %al, %es:(%si)        /* Write a character.    */
        movb $0x20, %es:1(%si)	   /* Apply attribute.      */

halt:
	hlt
	jmp halt

msg:
	.string "Hello World"
	


	/*

	Notes.

	Here we use the extra segment register to access the video display
	memory, while the reference to msg is implicitly translated into 
        %ds:msg. We assumed that %ds holds our current segment.
	
	
	*/
