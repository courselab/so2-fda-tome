;;;    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
;;;   
;;;    SPDX-License-Identifier: GPL-3.0-or-later
;;;
;;;    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

	;; Boot, say hello, and halt
	;; NASM assembly, naive char by char, manually
	;; Revision 2: prepend a valid BPB if r1 doesn't work
	
	bits 16			; Set 16-bit mode

	;; This is a typical DOS VBR header for a 1.44M floppy

	jmp init		; Jump to bootsrap code
	nop			; A nop to complete the VBR signature
	db 'SYSeg   '		; OEM name
	dw 512			; Bytes per sector
	db 1			; Sectors per cluster
	dw 1			; Number of reserved sectors
	db 2			; Number of FATs
	dw 224			; Maximum root directory entries
	dw 2880			; Number of sectors
	db 0xf0			; Midia descriptor (floppy)
	dw 9			; Sectors per FAT
	dw 18			; Physical sectors per track
	dw 2			; Number of heads
	dd 0			; Number of hidden sectors
	dd 0			; Total number of sectors (?)
	db 0			; Physical drive number
	db 0 			; Reserved field
	db 0x29			; Extended boot signature
	dd 0x0 			; Volume id / serial
	db 'SYSeg disk '	; Partition volume label
	db 'FAT12   '
	

init:	
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
	;; This example is almost identical to the program eg-01.asm, except
	;; that it's prepended a short leading code prepented to it, which is
	;; meant to satisfy some BIOSes that expect that the bootable media
	;; contain a Volume Boot Record. A VBR is a type of of boot sector
	;; introduced by the IBM PC. Basically, a VBR starts with a jump
	;; instruction leading to the bootloader code. Before the bootloader
	;; there are some fields
