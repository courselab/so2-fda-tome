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

	
f1:				/* int f(int a, int b) return a-b.        */
	mov  4(%esp), %eax	/* First argument at ESP+4.               */
	mov  8(%esp), %ebx	/* Second argument at ESP+6.              */
	sub %ebx, %eax		/* Subtract second from first argument.   */
	ret			/* Remove addr from the stack and return. */
	

	/* Notes.

	The x86 calling convention pass parameters via stack in reverse order
	(and receive return value in EAX). 

	To compute f1(5,2), main() pushes 2 and 5 into the stack, and then 
	calls f1(). The call instruction pushes the return address into the
	stack and jumps to f1. 

	When execution lands in f1(), the stack is like this:
		  
                  [  ...  ]
	          [   2   ]       4 bytes
	          [   5   ]	  4 bytes
	   esp -> [ addr  ]       4 bytes

        (memory addresses grow upwards; stack grows downwards.)

	The first argument is at esp+4, and the second at esp+8.

	f(1) performs the substraction and issue a ret instruction. This 
	operation pops the return address from the stack and jumps back
	to main(). The stack is now like

                  [  ...  ]	  
	          [   2   ]       4 bytes
	   esp -> [   5   ]	  4 bytes
	          [ addr  ]	  4 bytes       



	Now main() should return (to _start, the entry point). The return 
	instruction will once more pop the return address from the stack; 
	the stack, though, is pointing to the first function's argument
	(not what we want).  We must thus first remove the two arguments 
	we had previously pushed: this is equivalent to add 8 to esp:
	
          esp ->  [  ...  ]	  4 bytes
	          [   2   ]       4 bytes
	          [   5   ]	  4 bytes
	          [ addr  ]	  4 bytes       

	Just like f1(), the value main() receive at the top of the stack
	is the return address of the caller (the crt0 entry point, usually
	__start).

	If we forget to clean up the stack, we'll return to some weird place
	and will probably get a segmentation fault.

  */
