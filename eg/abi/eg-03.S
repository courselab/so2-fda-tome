#    SPDX-FileCopyrightText: 2001 Monaco F. J. <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

	/* A minimal syscall example  */
	
	.section .text		/* Our program has only section .text  */

	.global init		/* Make _start visible to the linker  */

init:
	mov $1, %eax		/* Prepare to request syscall 1 (exit)  */
	mov $42, %ebx		/* Exit's argument is expected in ebx   */
	
	int $0x80		/* Perform syscall                      */


	
/*	 Notes
	 
	 When the following C program is compiled
	
	 int main()
	 {
	    return 42;
	 }
	
	 the resulting assembly code perform exactly this operation:
	 loads the return status into ebx and trigger syscall exit.
*/
