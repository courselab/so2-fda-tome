/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/* Boot, say hello and halt. 
   Using macro-like functions, now with asm in the header.
*/

#include <eg-04.h>

extern const char msg[];

 
void __attribute__((naked)) _start()   /* This will be a label in asm code. */
{
  
  write_str(msg);	    /* This will be relaced with inline asm code. */

  halt();                   /* This will be relaced with inline asm code. */
}

/*  The string, with a hack to allocate it in the same section (.text). */

const char __attribute__((section(".text#"))) msg[]  = "Hello world";

/* The boot signature. */

__asm__(". = _start + 510");                /* Pad with zeros */
__asm__(".byte 0x55, 0xaa");                /* Boot signature  */


/* Notes

   Macros write_str() and halt() are defined in eg-04.h.


 */
