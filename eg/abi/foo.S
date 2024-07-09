#    SPDX-FileCopyrightText: 2001 Monaco F. J. <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

	.code32
	.global _start

_start:

	call func
	mov $0, %eax
	ret
	
/* func:  */
/* 	mov $1, %eax  */
