#    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

	.code16
	.global init32
init32:
	jmp switch32

gdt_start:			/* Mandatory numm descriptor.  */
	
	.long 0x0
	.long 0x0

	/* 
	Base 0x0, limit 0xfffff
	1st flags: present (1), priviledge (00), type (1) : 0b1001  
	type flags: code (1), conforming (0), readalbe (1) accessed (0) : 0b1010
	2nd flags: granularity (1), 32bit (1), 64bit seg (0), AVL (0):0b1100   */
	
	
gdt_code:			/* Code segement.  */
	
	.word 0xFFFF		/* Limit (bits  0-15).            */
	.word 0x00		/* Base  (bits  0-15).            */
	.byte 0x00		/* Base  (bits 16-23).            */
	.byte 0b10011010	/* 1st flags, type flags.         */
	.byte 0b11001111	/* 2nd flags, Limit (bits 16-19)  */
	.byte 0x00		/* Base  (bits 24-31).            */

	/* 
	Like in code segement, except
	type flags: code (0), expand-down (0), writable (1)*/
	
gdt_data:			/* Data segement.  */
	
	.word 0xFFFF		/* Limit (bits  0-15).            */
	.word 0x00		/* Base  (bits  0-15).            */
	.byte 0x00		/* Base  (bits 16-23).            */
	.byte 0b10010010	/* 1st flags, type flags.         */
	.byte 0b11001111	/* 2nd flags, Limit (bits 16-19). */
	.byte 0x00		/* Base  (bits 24-31).             */
	
gdt_end:			
	
gdt_descriptor:

	.word gdt_end - gdt_start - 1 
	.long gdt_start
		
	CODE_SEG = gdt_code - gdt_start
	DATA_SEG = gdt_data - gdt_start

switch32:			/* Prepare to switch to 32-bit.   */
	
	mov $0x2401, %ax
	int $0x15
	mov $0x3, %ax
	int $0x10
	cli
	lgdt gdt_descriptor
	mov %cr0, %eax
	or $0x1, %eax
	mov %eax, %cr0
	sti
	
	jmp $CODE_SEG, $code32	/* Actual switch to 32-bit.      */

	
	.code32			/* Now we're in 32-bit.          */
code32:
	
	mov $DATA_SEG, %ax	/* Recanonicalize segments.      */
	mov %ax, %ds
	mov %ax, %es
	mov %ax, %fs
	mov %ax, %gs
	mov %ax, %ss
	
	mov $0x9000, %sp	/* Initialize new stack.         */

	call pm_start		/* Call the first 32-bit function.*/

halt:		       /* We'll never return to the boot loader.  */
	cli
	hlt

