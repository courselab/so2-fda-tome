/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

extern const char here[];


/* Reminder: 16bit object code (see note 1). */

/* This will be our entry point.*/

void __attribute__ ((naked)) _start()           
{

  register int eax __asm__  ("eax");                                      
  register int ebx __asm__  ("ebx");                                      
                                                                                   
  eax = 0x0e00;                 /* Load 0xe into ah. */                            
                                                                                   
  ebx = 0x0;                    /* Offest to the string. */                        
                                                                                   
  do                            
    {                                                                              
      eax &= 0xffffff00;        /*     prepare for the next line   */              
      eax |= (char) here[ebx];  /*     mov al, BYTE [here + bx]    */              
      __asm__("int $0x10"); /*     int 0x10                    */              
      ebx++;                    /*     add bx, 0x1                 */              
                                                                                   
    }                                                                              
  while ( (eax & 0x000000ff)   != 0x0);      /*  while(ah != 0x0)  */    
  
  while(1);

}

const char here[] = "Hello world";




/* Notes. 

   1) In oder to produce 16-bit program, we may either use the inline assembly

      __asm__ (".code16");

      at the beginning of the file, or else pass the command line option
      -m16 to gcc, which is absolutely equivalent here. Remember, this 
      directive needs to be present in the assembly so that the assembly
      know what to do.

*/

