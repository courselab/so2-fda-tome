;;;    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
;;;   
;;;    SPDX-License-Identifier: GPL-3.0-or-later
;;;
;;;    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

	;; Boot, say hello, and halt
	;; NASM assembly, naive char by char, manually
	
	bits 16			; Set 16-bit mode
	
	mov ah, 0xe		; set BIOS teletype mode

	mov al, 'H'		; Load 'H' ascii code
	int 0x10		; Issue BIOS interrupt

	mov al, 'e'		; Load 'H' ascii code; 
	int 0x10		; Issue BIOS interrupt

	mov al, 'l'		; Load 'H' ascii code
	int 0x10		; Issue BIOS interrupt

	mov al, 'l'		; Load 'H' ascii code
	int 0x10		; Issue BIOS interrupt

	mov al, 'o'		; Load 'H' ascii code
	int 0x10		; Issue BIOS interrupt

	mov al, ' '		; Load ' ' ascii code
	int 0x10		; Issue BIOS interrupt

	mov al, 'W'		; Load 'W' ascii code
	int 0x10		; Issue BIOS interrupt

	mov al, 'o'		; Load 'o' ascii code
	int 0x10		; Issue BIOS interrupt

	mov al, 'r'		; Load 'r' ascii code
	int 0x10		; Issue BIOS interrupt

	mov al, 'l'		; Load 'l' ascii code
	int 0x10		; Issue BIOS interrupt

	mov al, 'd'		; Load 'd' ascii code
	int 0x10		; Issue BIOS interrupt
halt:	
	hlt			; Halt the machine
	jmp halt		; Safeguard 

	times 510 - ($-$$) db 0	; Pad with zeros
	dw 0xaa55		; Boot signature



	;; Notes
	;;
	;; BIOS interruption 0x10 causes the process flow to jump to the
	;; interruption vector table area, where there is a pre-loaded BIOS
	;; routine capable of output characters at the video device.
	;;
	;; This interruption handler routine reads the byte at the 8-bit
	;; register and send to the video controller. The video operation
	;; mode (e.g. ascii character) is controlled by register ah.
	;; After completing the operation, execution flow is returned to
	;; the next line after 'int' instruction.

	;; Instruction hlt should cause the processor to halt.
	;; It is however possible that a hardware interruption could
	;; cause the processor resume from its halt state. We use an
	;; infinite loop calling jmp as a safeguard.
	
	;; Instruction jmp arg performs a jump to the position arg.
	;; The label 'halt' is the position which jump should reach.
	;; In the present case, an ad hoc alternative to attain the
	;; same result might be
	;;
	;;    jmp $-1
	;;
	;; Here, $ is the current position. Knowing that hlt does not
	;; take arguments, we need to jmp to the current position minus one.

	;; In user space, a binary (executable) programs often has
	;; a specific structure with several sections other than the code
	;; section: code (text) section, data section, etc. Format elf
	;; in GNU Linux and format PE in MS Windows are known examples.
	;; The variable $ is actually the offset of the current position with
	;; respect to the start of the current section, whose position is $$.
	;; That is why we compute ($-$$) when we use the directive times.
	;; 
	;; That said, in the running example we have a flat-binary, with no
	;; structure. Our program has only one single (implied) section.
