/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/* Boot, say hello and halt. 
   Using macro-like functions (and deep hacks).
*/


/*  What if we move the hacked string to the top? */

const char __attribute__((section(".text#"))) msg[]  = "Hello World";

void __attribute__((naked)) _start()   /* This will be a label in asm code. */
{

__asm__("\
        mov   $0x0e,%ah               \n \
        mov   $0x0, %bx               \n \
loop:                                 \n \
        mov   msg(%bx), %al           \n \
        cmp   $0x0, %al               \n \
        je    halt                    \n \
        int   $0x10                   \n \
        add   $0x1, %bx               \n \
        jmp   loop                    \n \
                                      \n \
  halt:                               \n \
        hlt                           \n \
        jmp   halt                    \n \
");
  
 
}


/* The boot signature. */

__asm__(".fill 510 - (. - _start), 1, 0");  /* Pad with zeros */
__asm__(".byte 0x55, 0xaa");                /* Boot signature  */


/* Notes

   We moved the string to end of our program.

   A caveat is in order here:

 - The compiler will allocate the executable code in the section .text
   of the assembly code. By default, it would allocate the string in
   the read-only data (.rodata) section.  The problem is, the assembler
   computes offsets relatively to the start of the current section.   

   The attribute in the declaration of msg forces the compiler to allocate
   the string in the designated section.

   And the hack does not ends there. If we write '.text' as the
   argument of the attribute specification, GCC will append a '.a'
   after it, such that the string will be in section '.text.a' Not what
   we need.  We therefore specify '.text#' as a way to fool GCC:
   it will output '.text#.a'.  But '#' happens to be a comment mark
   for the the assembler, which will read just '.text' as we'd like.
   
   If this source looks like hackery to you, that's because it very much is. 
   
   Welcome to system level programming.


 */
