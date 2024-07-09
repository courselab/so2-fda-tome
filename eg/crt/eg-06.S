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
	sti			/* Reenable interrupts.     */
	
	mov $0x0, %si  
	mov $0x0, %bx

	mov $0xb800, %ax	  
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
