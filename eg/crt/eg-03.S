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
	mov $0xe, %ah             /* TTY mode. */

	mov $0x0, %si             /* Iteration index. */

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
	.string "Hello World"

	. = _start + 510

	.word 0xaa55
