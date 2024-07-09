#    SPDX-FileCopyrightText: 2001 Monaco F. J. <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

	.text
	.global main

		
main:
	push $2			/* f(5,2): push arguments in reverse order: */
	push $5			
	call f1			/* Push return address and jump to main.     */
	
	add $8, %esp		/* Remove arguments from the stack.          */

	ret			

f1:				/* int f(int a, int b) return a-b.          */
	
	mov %esp, %ebp		/* Save the return address' location.       */
	
	sub $4, %esp		/* Reserve 4 bytes for the local variable.  */
	movl $1, (%esp)
	
	mov  8(%esp), %eax	/* First argument at  ESP+4 + 4              */
	mov  12(%esp), %ebx	/* Second argument at ESP+6 + 4              */

	call f2
	
	sub %ebx, %eax		/* Subtract second from first argument.      */
	add (%esp), %eax

	mov %ebp, %esp		/* "Remove" locals (in place of add $4, %esp  */
	
	ret			/* Remove addr from the stack and return.     */


f2:

	mov %esp, %ebp

	sub $1, %esp

	mov %ebp, %esp

	ret
	
	/* Need to preserve ebx.  */

	/* Notes.


  */
