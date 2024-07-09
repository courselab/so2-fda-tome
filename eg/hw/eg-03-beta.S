#    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

	## Boot, say hello, and halt
	## AT&T assembly, translated from NASM
	
	.code16                # Set 16-bit code
	
	.global begin	       # So the linker can find it.
	
begin:		               # Program beginning (no equivalent to NASM $$)
	
	mov   $0xe, %ah	       # BIOS tty mode
	
	mov   $0x0, %si	       # Using linker's org flag
loop:			      
	mov   msg(%si), %al    # Offset to the message
	cmp   $0x0, %al	       # Loop while char is not 0x0
	je    halt             # Jump to halt
	int   $0x10	       # Call bios
	add   $0x1, %si	       # Point to the next character
	jmp   loop	       # Repeat until we find a 0x0
	
halt:
	hlt		       # Halt
	jmp   halt	       # Safeguard

msg:			       # C-like NULL terminated string

	.string    "Hello World"
	
	.fill 510 - (. - begin), 1, 0       # Pad with zeros
	.word 0xaa55			    # Boot signature


	# Notes
	#
	# This is a intentionally literal translation of mbr-02.asm
	# into AT&T Gas assembly.  See extended comments in ./README
	# for the rationales.

	
