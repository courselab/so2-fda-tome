/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/* A function which prints a string pointed by str using BIOS' int 0x10. 

   We use fascall calling convention, which receives the argument in ecx.

   
*/

void __attribute__((fastcall, naked))  write_str(const char* s)
 {
__asm__
  (
"       mov   %cx, %bx              \n" /* Caller has passed argument in cx. */
"	mov   $0x0e, %ah            \n"
"	mov   $0x0, %si             \n"
"loop:			            \n"
"	mov   (%bx, %si), %al       \n" /* This means %bx + %si. */
"	cmp   $0x0, %al	            \n"
"	je    end                   \n"
"	int   $0x10	            \n"
"	add   $0x1, %si	            \n"
"	jmp   loop	            \n"
"end:                               \n"
"      ret                          \n" /* Return to caller. */
);
}

/* Halt. */

void __attribute__((naked)) halt()
{
__asm__					
(
"halt:                \n"
"	hlt           \n"
"	jmp   halt    \n"
/*      ret           \n   This function never returns.  */
);
}

/* Notes.

   Function _start calls write_srt, and, by means of attribte fascall,
   we told it to pass its arguments via register cx (it's a convention.)

   Some caveats.

 - Again, we must be careful not to redefine labels.
 
 - In eg-04, the string location was identified by a label 'msg', and 
   we could read it using 

     mov msg(%bx)

   Now the string position is given by a register. We can't use eg.

     %cx(%bx)

   One reason is because AT&T assembly uses the syntax

     (register_1, register_2)

   which means base and index, respoectively (the full statement
   allow more parameters, but this is suffices for now).

   Another reason, is that we can't use

    (%cx, %bx)

   simply because in 16-bit real mode we can't choose any registers
   for base and index respectively. We are limited to a few choices.

   (%bx, %si)

   is one of them. Indeed, that is why bx and si are referred to as 
   base  and index register, respectively.

   See ./README for more on this matter.

   If it feels to you that the hardware is kind of sadly inconsistent,
   that's because it is.  It's our duty as reckless system programs 
   to mask those idiosyncrasies out and simulate the idyllic illusion 
   of consistency and simplicity tha the innocents of userland belive in.


 */
