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
	
	sub $4, %esp		/* Reserve 4 bytes for the local variable.  */
	movl $1, (%esp)
	
	mov  8(%esp), %eax	/* First argument at  ESP+4 + 4              */
	mov  12(%esp), %ebx	/* Second argument at ESP+6 + 4              */

	sub %ebx, %eax		/* Subtract second from first argument.      */
	add (%esp), %eax

	add $4, %esp		/* Remove local variables from the stack.   */
	
	ret			/* Remove addr from the stack and return.   */

	

	/* Need to preserve ebx.  */

	/* Notes.

	 When the execution lands on f1, the stack is like this:
		  
                  [  ...  ]
	          [   2   ]       4 bytes
	          [   5   ]	  4 bytes
	   esp -> [ addr  ]       4 bytes

	Local (temporary) variables are allocated in the stack.
	Therefore, after allocating one local variable and attributing a value
	to it, the stack in f1 becomes this:

                  [  ...  ]
	          [   2   ]       4 bytes
	          [   5   ]	  4 bytes
	          [ addr  ]       4 bytes
	  esp ->  [   1   ]

	The first and second arguments to f1 are at positions ESP+8 and ESP+12, 
	respectively.

	The function does its thing and, before retorning, it has to remove the
	local variable from the stack, so that the ESP  points to the return 
	address:	

                  [  ...  ]
	          [   2   ]       4 bytes
	          [   5   ]	  4 bytes
	  esp ->  [ addr  ]       4 bytes
	          [   1   ]


	Then f1 returns to main, and main proceeds as in eg-10.S.

	Naturally, the compiler must keep track of how it manipulates ESP within
	the callee, so that it can revert the register back to as it left by
	the caller after the call instruction. 

	The portion of the stack containing the function parameter, the caller's
	return address and the calle's local variables

			       _ _ _ _ _ _ _ _ _ _ _    ___
	          [   arg 1  ]                           |
	          [   arg 2  ]	Function arguments       |
	          [   ...    ]				 |
	          [   arg n  ] _ _ _ _ _ _ _ _ _ _ _     |
							 |  Stack frame
	  esp ->  [   addr   ] Return address            |
			       _ _ _ _ _ _ _ _ _ _ _     |
	          [   var 1  ]                           |
	          [   var 2  ]  Local variables          |
	          [   ...    ]				 |
	          [   var m  ] _ _ _ _ _ _ _ _ _ _ _    _|_


	is called stack frame (or call stack, program stack).

	The ideia is that the callee must preserve the caller's stack frame.

  */
