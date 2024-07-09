/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/* Header file for eg-06.c */

#ifndef EG_06_H
#define EG_06_H

/* A function-which prints pointed by str using BIOS' int 0x10 service. */

void __attribute__((fastcall, naked))  write_str(const char* s);


/*  */

#define _return __asm__("ret\n")


#endif

/* Notes.
   
   Function write_str() is implemented in eg-06_utils.c

   We don't need the function-like macro init_stack() anymore, because
   we're using eg-06_rt0.S.

   The only reason we need the macro _return is because we decided to use the
   attributed 'naked' with our main function. Usually, the compiler would issue
   an instruction ret at the end of the function; the attribute 'naked' supress
   this behavior. We therefore have to manually return to _start().
*/
