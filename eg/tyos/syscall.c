/*
 *    Copyright (c) 2020-2022 - Monaco F. J. <monaco@usp.br>. <monaco@usp.br>
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

#define pop_all_but_ax\
     "     pop %bx                  ;"\
     "     pop %bx                  ;"\
     "     pop %cx                  ;"\
     "     pop %dx                  ;"\
     "     pop %si                  ;"\
     "     pop %di                  ;"\
     "     pop %bp                  ;"


/* Write a string on the standard output.
   Arguments:  bx   pointer to the string. */

void __attribute__((naked)) sys_write(void)
{				
  __asm__
    (
     "     pusha                    ;" /* Push all registers.               */

     "     mov   $0x0e, %ah         ;" /* Video BIOS service: teletype mode */
     "     mov   $0x0, %si          ;"
     "loop2:                        ;"
     "     mov   (%bx, %si), %al    ;" /* Read character at bx+si position. */
     "     cmp   $0x0, %al          ;" /* Repeat until end of string (0x0). */
     "     je    end2               ;"
     "     int   $0x10              ;" /* Call video BIOS service.          */
     "     add   $0x1, %si          ;" /* Advace to the next character.     */
     "     jmp   loop2              ;" /* Repeat the procedure.             */
     "end2:                         ;"

     "     mov %si, %ax             ;" /* Return string length in %ax.      */
   
     pop_all_but_ax
     
     "     ret                      ;"
     );
}


/* Array pointing to all syscall functions. */

  
void (*syscall_table[])() =
  {
    sys_write			/*   0 : SYS_WRITE. */
  };


/* Syscall handler. 

   Attribute regparm(2) modifies the calling convention such that
   the arguments are passed through registers ax, dx and cx, respectively.
   Syscall functions should look for their arguments in those registers.

*/

void  __attribute__((naked))
syscall_handler (int number, int arg1, int arg2, int arg3)
{
  
  syscall_table[number]();

  __asm__("iret");
  
}



/* Notes.



 */
