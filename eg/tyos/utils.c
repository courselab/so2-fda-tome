/*
 *    SPDX-FileCopyrightText: 2001 Monaco F. J. <monaco@usp.br>
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

#include <utils.h>


/* Prints string in buffer on the screen.  */

void __attribute__((fastcall, naked))  echo (const char* buffer)
{
__asm__
(
 "        pusha                      ;" /* Save all registers.               */
 "        mov   %cx, %bx             ;"
 "        mov   $0x0e, %ah           ;" /* Video BIOS service: teletype mode */
 "        mov   $0x0, %si            ;" 
 "loop:                              ;"                                    
 "        mov   (%bx, %si), %al      ;" /* Read character at bx+si position. */
 "        cmp   $0x0, %al            ;" /* Repeat until end of string (0x0). */
 "        je    end                  ;"                                    
 "        int   $0x10                ;" /* Call video BIOS service.          */
 "        add   $0x1, %si            ;" /* Advace to the next character.     */
 "        jmp   loop                 ;" /* Repeat the procedure.              */
 "end:                               ;"
 "        popa                       ;" /* Restore all registers.             */
 "        ret                        ;" /* Return from this function.         */

 );
}

/* For debugging. */

void __attribute__((naked, fastcall)) fatal(const char *msg)
{
  echo (msg);
  echo (NL);
    
  __asm__ 
    (
     "fatal_halt2:       ;"		/* Halt the CPU. */
     "   hlt;           ;"		/* Make sure it */
     "   jmp fatal_halt2 "		/* remains halted. */
     );
}


/* Clear the screen and set video colors. */

void __attribute__((naked, fastcall)) clear (void)
{

  __asm__ 
    (
     " pusha                            ;" /* Push all registers. */
     " mov $0x0600, %ax                 ;" /* Video BIOS service: Scroll up. */
     " mov $0x07, %bh                   ;" /* Attribute (back/foreground).   */
     " mov $0x0, %cx                    ;" /* Upper-left corner.             */
     " mov $0x184f, %dx                 ;" /* Upper-right corner.            */
     " int $0x10                        ;" /* Call video BIOS service.       */
     " popa                             ;" /* Pop all registers. */
     " ret                               " /* Return from function. */
     );

}

void system_halt()
{

  __asm__
    (
     "sys_halt:            ;"
     "        hlt          ;"
     "        jmp sys_halt ;"
     );
}
  


/* Notes.



 */
