#    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

	/* Here we are taking steps to print a string.

	   Our intention is to read the first charater of the string at msg
	   and write it onto the video display memory as in eg-00.S

	   This code won't work, though. Can you spot the bug?

	*/	
	
  .code16

__start:

	mov $0x0, %si
	
        mov $0xb800, %ax           /* Color display memory. */
        mov  %ax, %ds              /* Set data segement.    */
	
	movb msg, %al              /* Read byte at msg.     */
        movb %al, (%si)            /* Write a character.    */
        movb $0x20, 1(%si)	   /* Apply attribute.      */

halt:
	hlt
	jmp halt

msg:
	.string "Hello World"
	

	/*

	Notes.

	Try to identify the problem before reading this note.

	Ok, here we go.

	We load 0xb800 into %ds so we can write the charcter to memory position

           DS:DI b800:DI

	and the line

	   movb %al, (%si)

	can correctly store the content of %al into the memory position given by
	0xb8000 + %si.  So far so good.

	The problem is that the line

	  mov msg, %al

	is also affected by the value we've stored in the data segment DS.
	Its result is actually


	  mov %cs:msg, %al


	We're therefore not reaching the string, but something else at position
	b8000 + msg.

	Let's do the math:

	   If we disassembly eg-01_alpha.bin, we'll see that msg is 0x7c06.

	   cs << 0x10    + 0x7c06
	=  0xb800 * 0x10 + 0x7c06
	=  0xb8000       + 0x7c06 = 0xbf06 != 0x7c06

	   This is somewhere within the video memory display area, far away
	   from msg.
	
	
	*/
