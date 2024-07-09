/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/* This symbol is defined in the linker script. */

extern void __END_STACK__;


/* Call main and halt. 

   This is where main() returns to,

   as do regular programs e.g. in GNU/Linux OS. */

void __attribute__((naked)) _start()
{
__asm__ 
(
"             mov  $__END_STACK__ , %sp  \n"
"             call main                  \n"
"halt:                                   \n"
"             hlt                        \n"
"             jmp halt                   \n"
);
}


/* Notes.

   Our rt0 file is now C with inline asm.

 */
