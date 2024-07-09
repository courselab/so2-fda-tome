#    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

	.code16
	.global _start

_start:

	jmp code
	.fill 60, 1, 0
code:
	cli			/* Disable interrupts.     */
        xor %ax, %ax
        mov %ax, %ds		/* Zero all registers.     */
        mov %ax, %es
        mov %ax, %fs
        mov %ax, %gs
        mov %ax, %ss
        mov $0x7c00, %sp
        jmp $0x0,$init0		/* Canonicalize CS:IP.      */
init0:
	sti
	call main
halt:
	hlt
	jmp halt
