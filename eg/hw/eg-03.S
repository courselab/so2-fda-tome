#    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

	## Boot, say hello, and halt
	## AT&T assembly, translated from NASM
	
	.code16                # Set 16-bit code
	
	.global _start	       # Default entry point (for the linker)
	
_start:		               # Beginning of the program 
	
	movb  $0xe, %ah	       # Select BIOS tty mode
	
	movw  $0x0, %si	       # Iteration index
loop:			      
	movb  msg(%si), %al    # Offset to each character in the message
	cmp   $0x0, %al	       # Loop while char is not 0x0 (end of string)
	je    halt             # Jump to halt if last cmp was true
	int   $0x10	       # Call BIOS video service
	add   $0x1, %si	       # Point to the next character
	jmp   loop	       # Repeat until we find a character 0x0
	
halt:
	hlt		       # Halt
	jmp   halt	       # Safeguard

msg:			       

	.string    "Hello World" 	 # C-like NULL terminated string
	
	.fill 510 - (. - _start), 1, 0   # Pad with zeros
	.word 0xaa55			 # Boot signature


	# Notes
	#
	# By default, the linker will consider _start the entry point,
	# such that we don't need to pass it as a command-line option.
	
