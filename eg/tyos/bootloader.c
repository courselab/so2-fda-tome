/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

#include <utils.h>


void __attribute__((naked)) load_stage2();

void init();   /* This function is the entry point of stage2. */

int main()
{
  clear();
  
  echo (" Stage 1: loading second stage..." NL NL);

  load_stage2();

  init();     /* Call init() in stage2. */
  
  return 0;
}

extern char drive;

/* Load stage2. */

void __attribute__((naked)) load_stage2()
{
  __asm__  
    (

     /* Save all registers. */

     "  pusha                   ;" /* Save all registers (note 1). */

     /* Compute the size of the second stage. */

     "  xor %dx, %dx;"
     "  mov $_STAGE2_SIZE, %ax;"  /* Stage2 size determined by the linker. */
     "  mov $512, %cx;"
     "  div %cx;"
     "  add $1, %ax;"
     "  mov %ax, size2;"	 

     
     /* Reset floppy just for the case. */
     
     "reset:                      ;"
     "    mov $0x0, %ah           ;" /* Teset disk.       */
     "    mov drive, %dl          ;" /* The boot drive    */
     "    int $0x13               ;" /* Call BIOS.        */
     
     "    jnc load                ;" /* On error, abort.  */     
     "    mov $err2, %cx          ;"
     "    call fatal              ;" 
     
     /* Load stage 2.   */

     " load:                     ;"
     
     "   mov drive, %dl          ;" /* The boot drive.           */
     "   mov $0x2, %ah           ;" /* Means read sector.        */
     "   mov size2, %al          ;" /* Number of sectors to read */
     "   mov $0x0, %ch           ;" /* Cylinder (starts at 0)    */
     "   mov $0x2, %cl           ;" /* Sector   (starts at 1)    */
     "   mov $0x0, %dh           ;" /* Head     (starts at 0)    */
     "   mov $_STAGE2_ADDR , %bx ;" /* Where to load data.       */
     "   int $0x13               ;" /* Call BIOS.                */

     "   mov $err1, %cx          ;"
     "   jc fatal                ;" /* On error, abort.          */


     /* Restore all registers. */

     "  popa                     ;"
   
     "   ret                     ;"
     );
}

const char err1[] = " Error: device reset failure." NL;
const char err2[] = " Error: device read failure." NL;

/* 
   Notes.

   (1) When we program in C, the compiler has total control of which registers
       it uses. When the program calls a function, and the function changes
       the registers, the compiler may decide to save the registers when
       entering the function and restoring them when returning from the 
       function.

       When we add inline asm, we're messing with reigsters in a way that 
       the compiler is not aware of. Because of this, it's a good ideia to save
       and restore the registers manually. We could do it only for the
       registers we change in the inline asm; or we can simply save and restore
       all general purpose registers.

 */
