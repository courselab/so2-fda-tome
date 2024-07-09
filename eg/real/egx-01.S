#    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

	/* Auxiliary example:

	   Write a character onto video display memory using the
	   real-mode segemented memory model.
	
	*/

	
	.code16
	
_start:


	mov $0xb800, %ax
	mov %ax, %es            /* Load video ram address into %es */
	
	mov $0, %di
	
	movb $'A',   %es:(%di)   /* Write character into %es:%di    */
	movb $0x20,  %es:1(%di)

halt:
	hlt
	jmp halt

	
