#    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

	.code16
	.global main


main:	
	mov $0x0, %si  
	mov $0x0, %bx

	mov $0xb800, %ax	  
	mov %ax, %es

loop:
	mov msg(%si), %al
	cmp $0x0, %al
	je end
	movb %al, %es:(%bx)
	movb $0x20, %es:1(%bx)
	add $2, %bx
	add $1, %si	
	jmp loop
end:	
	ret

msg:
	.string "Hello World"
/*
	We can't referece _start here because it's in a different assembling
	unit (different file). Note: this is an assembler directive (not a
	variable access).

	. = _start + 510

	.word 0xaa55
*/
