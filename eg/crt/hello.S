#    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

	.code16
	.global _start
	
_start:	

	jmp init
	.fill 60, 1 ,0

	mov $0xe, %ah
	mov $0, %si
loop:
	mov msg(%si), %al
	cmp $0x0, %al
	je halt
	int $0x10
	inc %si
	jmp loop

	
halt:	
	hlt
	jmp halt 

msg:
	.sring "Hello World"

	
