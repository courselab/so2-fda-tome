#    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

	/* eg-11.c - A shell code for buffer overflow attack.

	   This program writes a message in the standard output and exits.
	   That's not the most amzing exploit, but suffices to illustrate
	   the techique.

	*/
	
	.global _start

	/* We will use the syscal write (linux 32bit):
	
	      in %eax we store the syscall number : 4
	      in %ebx we store the descriptor number: 1
	      in %ecx we store the pointer to the string
	      in %edx we store the number of characters to be written
	*/
	
_start:

	/* Special atention is in order to determine the string pointer str.

	   Since we don't know where the program will be loaded in memory,
	   we'll have to relocate the address of str during run time.
	   Address relocation is a duty normally fulfilled by the operating
	   system as it loads the program into the RAM ; here, however,
	   we are forcefully injecting the code without the OS knowledge
	   of it and, thus, we have to make the relocation ourselves.

           An alternative to load-time relocation through address rewriting
	   is the concept of position-independent code, or PIC for short.
	
	   The present example is a very simple hand-made implementation of a
	   position-independent code.

	   The function _load_eip_in_eax is an instance of what is sometimes
	   referred to as a 'thunk function': a function used as a wrapper
	   for another function. In x86 architecture, there's no instruction
	   to read the value of %eip. On the other hand, we know that the
	   address of the next instruction is pushed onto the stack by the
	   call instruction; if we can read the top of the stack just after
	   a function call is performed, we can use this value to compute the
	   content of %eip.

	   To that end, we use the thunk function: it copies the value on the
	   top of the stack into %eax. With this value we can infer the
	   program's load address.
	
	*/
	
	call _load_eip_in_eax     /* Get value of %eip (next instruction). */
	sub $5, %eax              /* Previous instruction is 5-byte long.*/
	add $0x2a, %eax		  /* String's absolute offset (prog. start).*/
	mov %eax, %ecx		  /* Load string address into %ecx. */

	mov $4,   %eax
	mov $1,   %ebx
	mov $8,   %edx
	int $0x80
	
	mov $0,  %ebx
	mov $1,   %eax
	int $0x80
	
str:	                          /* The string. */
	.string "Hacked!"

_load_eip_in_eax:                 /* Thunk function. */
	mov (%esp), %eax
	ret
