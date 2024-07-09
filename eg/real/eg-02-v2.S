#    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

	/* Prints a string in video display memory.

	   Virtual 8086 version.
	
	*/

	
  .code16

__start:

	

	
	mov $0xb8000, %ebx
	mov $0x0, %esi
loop:	
	mov msg(%si), %al	# Move the si-esime character of msg to al.
	cmp $0, %al
	je halt
	
        movb %al, (%ebx,%esi,2)	      # The position at ebx+si*2.
        movb $0x20, 1(%ebx,%esi,2)    # The position at ebx+si*2 + 1.

	inc %si			      # Advance 1 position in the string.
	jmp loop

halt:
	hlt
	jmp halt

msg:
	.string "Hello World"
	

	# Notes
	#
	# In eg-02.S we used the register si to traverse the string,
	# and the register bx to traverse the memory display. In each
	# iteration, we increment si by 1, and bx by 2.
	#
	#   mov msg(%si), %al
	#       ...
	#   movb %al, %es:(%bx)	
        #   movb $0x20, %es:1(%bx)  
	#
        #   add $2, %bx		
	#   inc %si		
	#
	# If the x86 adressing modes were all available in 16-bit real mode,
	# then we could have achieve the same result with only one interation
	# register :
	#
	#   mov msg(%si), %al
	#       ...
	#   movb %al, %es:(, %si, 2)	
        #   movb $0x20, %es:1(, %si, 2)  
	#
	#   inc %si		
	#
	# where (,%si,2) would mean the value at position %si*2.
	#
	# Unfortunaltely, however, this kind of address mode with an scale
	# factor does not fit the limitations of instruction encoding in
	# 16-bit operation. Nevertheless, there is a workaround taking
	# advantage of the x86 real-mode (see egx-01.S and egx-02.S),
	# we can actually use the 32-bit register and reach the video
	# memory beyound the boundaries of the theoretical 64K segment.
	# This would not be possible in a real 8086 cpu.
