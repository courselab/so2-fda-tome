#    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

	/* Prints a string in video display memory.
	*/

	
  .code16

__start:

	mov $0xb800, %ax	
	mov %ax, %es		# Point to video display memory

	mov $0, %bx		
	mov $0, %si		
loop:	
	mov msg(%si), %al	# Move the si-esime character of msg to al
	cmp $0, %al		
	je halt
	
        movb %al, %es:(%bx)	# ASCII at the bx-esmime video-memory position
        movb $0x20, %es:1(%bx)  # and attribute at the next adjacent position
	
        add $2, %bx		# Advance 2 positions in video memory
	inc %si			# Advance 1 character in the string
	jmp loop

halt:
	hlt
	jmp halt

msg:
	.string "Hello World"
	
