#    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

	.code16
	.global mbs

mbs:	
	push %cs		# Make sure %cs and %ds point to
	pop  %ds		# the same segment.
	mov $msg, %si		# Make %si point to the start of the string

write:
	lodsb                   # Load ds:(%si) into %al and increment %si
	and %al, %al		# If %al is zero
	je retry		# junp to retry
	mov $0xe, %ah		# Select INT 0x10's tty mode
	mov $0x7, %bx
	int $0x10		# Call BIOS INT 10h
	jmp write		# Repeat

retry:
	xor %ah, %ah
	int $0x16		# Read keyboard
	int $0x19		# Reload the MBR

end:	                        # We should never reach this point
	jmp end
msg:
	.string "No bootable image. Please replace disk and press any key to retry."
