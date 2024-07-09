/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/* Boot, say hello and halt. 
   Using macro-like functions, with linkder script.
*/

#include <eg-04.h>

/*  The string. */

const char msg[]  = "Hello world";

 
void __attribute__((naked)) _start()   /* This will be a label in asm code. */
{
  
  write_str(msg);	    /* This will be relaced with inline asm code. */

  halt();                   /* This will be relaced with inline asm code. */
}


/* Notes

   We use a linker script to handle several issues:

   - merge .rodata into .text section  (don't need the hack on msg)
   - add the the boot signature        (don't need inline asm)
   - covert from elf to binary         (don't need ld command-line option)
   - set load address                  (don't need ld command-line option)
   - entry point                       (don't need ld command-line option)

   If this source looks less a hackery now, that's because of our might tools!
   
   Thanks GNU build toolchain.


 */
