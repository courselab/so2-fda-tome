/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/* Boot, say hello and halt. 
   Almost literal translation of eg-06.S using
   basic inline assembly and register variables. */

extern const char msg[];


void __attribute__((naked)) _start()
{

  /* Force variables to be allocated in registers rather
     than in RAM, as usual. */
  
  register short ax __asm__("ax"); /* Variable ax is register ax. */
  register short bx __asm__("bx"); /* Variable bx is register bx. */

  ax = 0x0e00;	       /* Store 0xe in ah, we don't care about al.*/

  bx = 0x0;	       /* Zero-initilize bx. */

  do
    {

      /* Gimmick to put msg[bx] in al. */
      
      ax = (ax & 0xff00) | (msg[bx] & 0x00ff);

      /* This is output as is in the assembly. */

      __asm__ ("int $0x10");	/* Call BIOS. */

      bx = bx + 1;
      
    }
  while ( (ax & 0x00ff) != 0  ); /* Do while al != 0. */

    while (1)
      __asm__("hlt");		/* Halt with safeguard. */
}

/*  The string, with a hack to allocate it in the same code section. */

const char msg[] __attribute__((section(".text#"))) = "Hello world";

__asm__(". = _start + 510");                /* Pad with zeros */
__asm__(".byte 0x55, 0xaa");                /* Boot signature  */

/* Notes.

   There are several due remarks here.

 - Asm statements inside __asm__() are ouput as are.

 - We declared variables to be allocated in registers.

 - The compiler will allocate the executable code in the section .text
   of the assembly code. By default, it would allocate the string in
   the read-only data (.rodata).  The problem is, the assembler
   computes offsets relatively to the start of the current section.   

   The attribute in the declaration of msg forces the compiler to allocate
   the string in the designated section.

   And the hack does not ends there. If we write '.text' as the
   argument of the attribute specification, GCC will append a '.a'
   after it, such that the string will be in section '.text.a' Not what
   we need.  We therefore specify '.text#' as a way to fool GCC:
   it will output '.text#.a'.  But '#' happens to be a comment mark
   for the the assembler, which will read just '.text' as we'd like.

 - Althouth it hopefully works, there are some due concerns about
   this code. Please, refer to ./README for further details.
   
 - Does this code look like hackery? It is. 
   Welcome to system level programming.

*/


