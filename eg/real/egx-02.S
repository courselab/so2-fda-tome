#    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

	/* Auxiliary example:

	   Write a character onto video display memory using
	   lnear memory in real mode, using 32-bit registers.
	
	*/

	
        .code16

_start:




	
        mov $0xb8000, %edi

        movb $'A',   (%edi)   /* Write character into %es:%di    */
        movb $0x20, 1(%edi)

halt:
        hlt
        jmp halt



/*
	Notes.

	Original 8086 was a 16-bit cpu implementing segmented memory.
	Modern x86 are powered by x86 processors which have 32-bit 
	registers (or 64-bit for x86_64) and implement protected mode. 
	In protected mode, memory is not segmented. For compatibility
	with older programs, though, the x86 will boot in real-mode.
	x86 real-mode tries to mimic original 8086 real-mode, e.g. by
	implementing segment memory: a pair of valid segment and offset
	register will point to a linear memory address given by
	segment * 10h + offset. 

	A caveat in in order, in that x86 real mode does not prevent
	the program from using 32-bit registers. That is, it is possible
	and ligitimate to do

		mov $2, %ebx

	The assembly will prefix the mov instruction opcode with a
	operand override prefix (0x66) which causes the instruction
	to operate with 16 rather than 32-bit. Moreover, the cpu won't
	forbid the program from doing

		mov $2, (%ebx)

	As expected in real-mode segmented memory, this will load $2
	in the memory position %ds:%ebx. The noteworth detail here
	is that %ebx can contain a value grater than 0xffff, i.e.
	we can have an offset of more than 64K (with %bx we can not).

	Therefore, rather than loading $b800 in %es, to access the
	video display memory, we can simply load 0xb8000 in %ebx
	and that is it. Let's say ds = 0

		mov $0xb8000, %ebx
		mov $'A', (%ebx)

	does the job.

*/	
