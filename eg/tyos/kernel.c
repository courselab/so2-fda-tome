/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

#include <utils.h>
#include <syscall.h>
#include <runtime.h>


void __attribute__((naked)) init()
{
  echo (" Stage 2: second stage loaded sucessuflly!" NL);

  /* We'll use the software interrupt int 21h as the syscall trap. 

     All we have to do is to write the address of the syscall handler into
     the 0x21st entry of the IVT (Interrupt Vector Table). Each entry has 4
     bytes in the form segment:register (16bit addresses). Therefore, the
     entry for int 21h is at position 21h*4.

     Well, "trap" is sometimes associated with switching from user to 
     kernel mode in protected mode; we are always in real-mode though. */

  __asm__
    (
     "    .equ offset, 0x21 * 4          ;" /* Int 21h entry.        */
     "    cli                            ;" /* Disable interrupts.   */
     "    movw $syscall_handler, offset          ;" /* Offset and segment in */
     "    movw $0x0, offset+2            ;" /* little endian.        */
     "    sti                            ;" /* Reenable interrupts.  */
     );

  puts(NL " Kernel up and running!" NL);

  system_halt();
  
}


