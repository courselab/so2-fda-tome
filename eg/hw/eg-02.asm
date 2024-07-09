;;;    SPDX-FileCopyrightText: 2001 Monaco F. J. <monaco@usp.br>
;;;    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
;;;   
;;;    SPDX-License-Identifier: GPL-3.0-or-later
;;;
;;;    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

	;; Boot, say hello, and halt
	;; NASM assembly, neater version wit loop

	bits 16			    ; Set 16-bit mode
	
	org 0x7c00		    ; Our load address (alternative way)

	mov ah, 0xe		    ; BIOS tty mode

	mov si, 0		    ; Offsets now handled via org directive
loop:				
	mov al, [msg + si]	    ; Ofsset to the message
	cmp al, 0x0		    ; Loop while char is not 0x0 
	je halt			    ; Jump to halt
	int 0x10		    ; Call BIOS video interrupt
	add si, 0x1		    ; Point to the next character
	jmp loop		    ; Repeat until we find a 0x0

halt:
	hlt			    ; Halt
	jmp halt		    ; Safeguard

msg:				    ; C-like NULL terminated string

	db 'Hello World', 0x0
	
	times 510 - ($-$$) db 0	    ; Pad with zeros
	dw 0xaa55		    ; Boot signature


	;; Notes
	;;
	;;  The org directive tells nasm where we intende to load the program.
	;;  The offset is now automatically applied wherever needed.
