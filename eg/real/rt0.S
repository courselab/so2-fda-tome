#    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

	.code16
	.global _start
	.text

_start:

	cli                          
        ljmp $0x0,$init0             
init0:                               
        xorw %ax, %ax                
        movw %ax, %ds                
        movw %ax, %es                
        movw %ax, %fs                
        movw %ax, %gs                
        movw %ax, %ss                
        mov $0x7c00, %sp      
        sti                          
        call main                    
 halt:                               
        hlt                          
        jmp halt                     

