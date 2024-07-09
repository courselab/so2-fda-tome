/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/* Header file for eg-07.c */

#ifndef EG_07_H
#define EG_07_H

/* Prints string pointed by s using BIOS' int 0x10 service. */

int __attribute__((fastcall, naked))  puts(const char* s);

#endif

/* Notes.
   
   Both puts and exit are now functions implemented in eg-10_utils.c.

   We should be careful not to clash names with libc.

   The function puts() was declared of type integer just to look like
   the usual ISO-C API. Since the example is a freestanding program,
   this will have no effect, though.

*/
