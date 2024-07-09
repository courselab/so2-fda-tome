/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/* Header file for eg-08.c */

#ifndef EG_04_H
#define EG_04_H

/* A function-like macro which prints a string named str using BIOS' 
   int 0x10 service. 

   Note that we can't pass a quoted literal string like "Foo"
   as argument of this macro, since the argument will be  literally  
   replaced as is within the asm code. Argument str should be a label,
   existing in the scope of the asm code.

   This macro clobbers registers ax, and si.

 */

#define write_str(str) __asm__\
(\
"        mov   $0x0e,%ah            \n"\
"        mov   $0x0, %si            \n"\
"loop:                              \n"\
"        mov   " # str "(%si), %al  \n"\
"        cmp   $0x0, %al            \n"\
"        je    halt                 \n"\
"        int   $0x10                \n"\
"        add   $0x1, %si            \n"\
"        jmp   loop                 \n"\
)

/* A function-like macro which halts the system. 
e 
   This function takes no arguments and does not clobber registers.

*/

#define halt() __asm__\
(\
"  halt:               \n"\
"        hlt           \n"\
"        jmp   halt    \n"\
)


#endif

/* Notes.

   We must be carefull with labels not to reuse symbols. Inline asm
   is copied into the output; if there is another label (e.g.
   function name) which the same name, that'd be a problem.

   Note the use of \n to split lines in a multi-line assembly 
   source code. This is because assemblers read LF-terminated lines.
*/
