/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/* Boot, say hello and halt. 
   Improved code using linker script.
*/

extern const char msg[];

void __attribute__((naked)) _start()
{

  /* Force variables to be allocated in registers rather
     than in RAM, as usual. */
  
  register short ax __asm__("ax"); /* Variable ax is register ax. */
  register short bx __asm__("bx"); /* Variable bx is register bx. */

  ax = 0x0e00;	       /* Store 0xe in ah, we don't care about al.*/

  bx = 0x0;	       /* Zero-initilize bx. */

  do
    {

      /* Gimmick to put msg[bx] in al. */
      
      ax = (ax & 0xff00) | (msg[bx] & 0x00ff);

      /* This is output as is in the assembly. */

      __asm__ ("int $0x10");	/* Call BIOS. */

      bx = bx + 1;
      
    }
  while ( (ax & 0x00ff) != 0  ); /* Do while al != 0. */

    while (1)
      __asm__("hlt");		/* Halt with safeguard. */
}

/*  The string. */

const char msg[]  = "Hello world";


/* Notes.

   The attribute 'naked' is used to prevent GCC from generating extra asm
   code that we don't need in our example, and can be safely discarded for
   easy of readability. This extra code is normally important for implementing
   consistent memory utilization across functions which exchange data using
   the memory stack (a memory region which programs use to pop and push
   data when they need). This is not the case of our simple program and we
   therefore may safely get along without it for now. We should get back 
   to this topic opportunely.

 */
