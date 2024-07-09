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

#include <eg-05.h>

const char msg[]  = "Hello World";


void __attribute__((naked)) _start()   /* This will be a label in asm code. */
{

  init_stack();		    /* Needed for function calls (see eg-05.h) */
  
  write_str(msg);	    /* This will be a functional call in asm code. */

  halt();                   /* This will be a function call in asm code. */
}


/* Notes

   This code looks like eg-04.c, but with function-like macros replaced 
   with actual function calls.

 */
