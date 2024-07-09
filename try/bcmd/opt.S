#    SPDX-FileCopyrightText: 2024 Monaco F. J. <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

	.code16
	.global strcmp

	## Compare two strings
	##
	## This is a handcrafted memory-optized version of the strcmp()
	## function's C counterpart in utils.c. You may prefer this one
	## if running out of space in the 512-byte program.
	##
	## PS: can you think of an even shorter version? If so, contribute 
	## your thoughts (see CONTRIBUTING.md)
	
strcmp:
	pusha	           /* Save all GP registers.                         */
	xor %ax, %ax       /* Zero %ax to contain the result.                */
	mov %cx, %si       /* Copy string1 to %si.                           */
	mov %dx, %di       /* Copy string2 to %si.                           */
strcmp_loop:
	cmpb $0, (%si)    /* Compare byte at address pointed by %si with 0.  */
	je strcmp_end     /* If it's 0, we've reached the end of the string. */
	cmpb $0, (%di)    /* Compare byte at address pointed by %di with 0.  */
	je strcmp_end     /* If it's 0, we've reached the end of the string. */
	movb (%si), %bl   /* Load byte from address pointed by %si into %bl. */
	movb (%di), %cl   /* Load byte from address pointed by %di into %cl. */
	cmpb %cl, %bl     /* Compare the bytes in %bl and %cl.               */
	je strcmp_eq      /* If they're equal, skip 'inc %ax'.               */
	inc %ax
strcmp_eq:
	inc %si           /* Move to the next byte in string1.               */
	inc %di           /* Move to the next byte in string2.               */
	jmp strcmp_loop   /* Repeat the loop.                                */
strcmp_end:
	mov %ax, strcmp_tmp  /* Save %ax before popa.                        */
	popa	             /* Restore all GP registers.                    */
	mov strcmp_tmp, %ax  /* Restore %ax after popa.                      */
	ret               /* Return.                                         */

	.section .data

strcmp_tmp:	          /* Temporary memory for %ax.                       */
	.byte 0x0
