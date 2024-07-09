/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/* A function-which prints pointed by str using BIOS' int 0x10 service. 

%   This function clobbers eax, ebx, ecx and esi.
*/

void __attribute__((fastcall, naked))  write_str(const char* s)
{
__asm__ volatile
(
"	mov   $0x0e, %%ah           \n"
"	mov   $0x0, %%si            \n"
"loop%=:	          	    \n"
"	mov   (%%bx, %%si), %%al    \n"
"	cmp   $0x0, %%al	    \n"
"	je    end%=                 \n"
"	int   $0x10	            \n"
"	add   $0x1, %%si	    \n"
"	jmp   loop%=	            \n"
"end%=:                             \n"
"        ret                        \n"
:				      /* No ouptut parameters. */
: "b" (s)	                      /* Var. s is stored in bx.*/
: "ax", "cx", "si"       	      /* Clobbred registers (bx is input).   */
 );
}

/* Halt. */

void __attribute__((naked)) halt()
{
__asm__					
(
"  halt%=:            \n"
"	hlt           \n"
"	jmp   halt    \n"
 :::
 );
}


/* Notes.

   This code uses GCC extende assembly.
  
   Register %reg is denoted %%reg
      
   The input parameter specifies that the C variable s should be copied into
   register b, and referenced in the code by str --- we therefore don't need 
   to mind that s is being received in ecx via function call.

   The line

        movw  %w[str], %%bx
   
    references str and the constraint %w tells the assembler that we want to
    operate on 16-bit register (therefor it should use bx).

    Token %= outputs a symbol which is unique in the entire compilation.
    This frees us from the risk of using the same label in another asm code
    in the same compilation unit.

    The last line informs GCC that the registers ax, cx, dx and si are 
    clobbered by this asm code. That bx is also clobbered GCC already 
    knows because bx is mentioned in the input/output parameter list.

    In extended asm GCC can modify the code. We used volatile qualifier
    to prevent optimization.

 */
