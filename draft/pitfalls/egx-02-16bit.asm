;;;    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
;;;   
;;;    SPDX-License-Identifier: GPL-3.0-or-later
;;;
;;;    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

	;; A code excerpt to illustrate NASM vs GAS
	;; NASM version.
	
	
	bits 16
	
	mov ah, 0x1
	mov ax, 0x2
	mov eax,  0x3
