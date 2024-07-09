#    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

	# A code excerpt to illustrate NASM vs GAS
	# GAS version
	
	.code16
	
	movb $0x1, %ah
	movw $0x2, %ax
	movl $0x3, %eax
