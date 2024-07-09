#    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

	.code16
	.global _start

_start:

	jmp init
	.fill 60, 1, 0

init:	
	
	mov $0x0, %si             /* Iteration index. */
	mov $0x0, %bx

	/* Video display memory is at 0xb8000, but this is out of our current.
	   segment. We can even store 0xb8000 in a 16-bit register. */
	
	mov $0xb800, %ax	  /* Point extra segement to video memory. */ 
	mov %ax, %es
	
loop:
	mov msg(%si), %al
	cmp $0x0, %al
	je halt
	movb %al, %es:(%bx)
	movb $0x20, %es:1(%bx)
	add $2, %bx
	add $1, %si
	
	jmp loop

halt:
	hlt
	jmp halt

msg:
	.string "Hello World"

	. = _start + 510

	.word 0xaa55
