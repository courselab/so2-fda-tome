#    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

	#   The program entry point.
	
	#   We moved _start from the main program to this auxiliary program
	#   that performs the runtime initialization.

	.code16
	
_start:	
	mov $0x8200, %sp
	call main
halt:
	hlt
	jmp halt

	# Notes.
	#
	# Initialize an 1k stack.
	#
	# In x86, the stack grows downwards, that is, each push operation
	# decrements %sp, and each pop operation increments it. We want
	# to put our stack somewhere where it does not eventually overwrite
	# our program, should many bytes be pushed. Let's assume a stack of
	# 1 Kbyte (it's much more than we need for this simple example).
	#
	# (LOAD_ADDRESS + 512 bytes) + 1 Kbyte = 0x8200
	#
	# The comments in eg-05.h offer further discussion.

