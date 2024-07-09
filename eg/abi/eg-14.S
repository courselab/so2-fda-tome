#    SPDX-FileCopyrightText: 2001 Monaco F. J. <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

	.text
	.global main

		
main:
	push %ebp		/* Save stack frame.        */
	mov %esp, %ebp		

	push $2			/* Push second argument.     */
	push $5			/* Push first argument.      */
	
	call f1			/* Call function.            */
	add $8, %esp		/* Clear arguments.          */

	mov %ebp, %esp		/* Restore the stack frame.  */
	pop %ebp
	ret			

f1:				
	push %ebp
	mov %esp, %ebp		

	sub $4, %esp		
	movl $1, (%esp)
	mov  12(%esp), %eax	
	mov  16(%esp), %ebx	
	call f2
	sub %ebx, %eax		
	add (%esp), %eax
	
	mov %ebp, %esp		
	pop %ebp
	ret			

f2:
	push %ebp
	mov %esp, %ebp

	sub $1, %esp

	mov %ebp, %esp
	pop %ebp
	ret
	
