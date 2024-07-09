;;;    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
;;;   
;;;    SPDX-License-Identifier: GPL-3.0-or-later
;;;
;;;    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

	;; Boot, say hello, and halt
	;; NASM assembly, naive char by char, manually
	;; Revision 1: prepend a dummy BPB for idiosyncratic BIOSes
	
	bits 16			; Set 16-bit mode
	
	jmp init		; VBR signature (jump to code)
	times 60 db 0x90	; A dummy BPB to avoid overwriting

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
	;; This example is practically identical to eg-00.hex, except for a few
	;; extra lines added at the beginning of the program. Those may be 
	;; required by some idiosyncratic BIOSes that check for the presence
	;; of a VBR (Volume Boot Record) on the bootable media. One such BIOS
	;; may either refuse to boot or, even worse, boot and execute the wrong
	;; code (you know that this is the case if you see a corrupted string
	;; "Hello World" string or some random characters being printed.
	;; 
	;; The scenario occurs because, in a FAT-formatted disk, the leading
	;; bytes of the first 512-byte block contains information about the
	;; the media, such as its capacity, a volume label, FAT version etc.
	;; This kind of block, known as a Volume Boot Record, was introduced
	;; by MS DOS and is in common use by mobile devices like smartphones
	;; and digital cameras.
	;;
	;; As we know, during the boot, the BIOS loads the first 512-bytes
	;; of the media device into the RAM and executes it from the first
	;; byte onward. Therefore, the very first bytes of the VBR should
	;; be a jump to the actual boot program. Some BIOSes treats those
	;; bytes as a VBR signature and refuses to boot if one is not found.
	;; Other FAT-oriented BIOSes may bypass the signature check and load
	;; the sector into RAM. So far so good, because the leading jump
	;; instruction will leap over the bytes containing the media
	;; information --- known as BIOS Parember Block, BPB --- and reach the
	;; executable code correctly. The problem is that some BIOSes decide
	;; to overwrite the BPB in RAM to update some of the fields as the
	;; information is probed by the firmware. 
	;;
	;; In eg-00.asm there is not VBR signature, and the executable code
	;; starts at the first byte. BIOSes that check for a VBR signature
	;; may refuse to boot. BIOSes that update the in-RAM BPB will end
	;; up overwriting our executable code.
	;;
	;; To fix this, the present example adds a 3-byte VBR signature,
	;; and reserve some space before the executable code for a
	;; dymmy BPB. Hopefully, this will handle a FAT-oriented BIOS.
