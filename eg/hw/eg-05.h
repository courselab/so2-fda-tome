/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/* Header file for eg-05.c. */

#ifndef EG_05_H
#define EG_05_H

/* A function-which prints pointed by str using BIOS' int 0x10 service. 


   Differently from eg-04.h's macro version, this function takes 
   either a pointer to labeled string or an anonymous pointer to 
   a quoted literal string.

   This function clobbers some registers.

 */

void __attribute__((fastcall, naked))  write_str(const char* s);


/* A function which halts the system. 
 
   This function takes no arguments and does not clobber registers.

*/

void __attribute__((naked)) halt();


/* As we make function calls, we need to tell the cpu where to store the
   return address of the caller, so that the return instruction in the
   called function knows where to jump back to.

   In our case, this is informed in register %sp.

   More technically, this is the stack pointer but we shall go deeper 
   into this topic opportunely. 

   Let's take, for instance, 1 Kbyte right after the 512-byte MBR:

   (LOAD_ADDRESS + 512) + 1K = 0x8200

   Note: there is a much neater way of doing this, as we'll see soon.

*/

#define init_stack()  __asm__("mov $0x8200, %sp") 


#endif

/*
    Advanced note:


   We don't need to understand all this at this point, but it may
   satisfy our curiosity to know where the value 0x8200 comes from.

   x86 real-mode implements segmented memory, i.e. the memory is
   divided in blocks called segment, each of 64 Kbyes. References
   to memory address such as 0x8200 actually means an offset from
   the begining of a given segment. Which segment? The segment
   pointed by the pertinent segement register. For instance

       mov $0x8200, %sp

   causes %sp to point to the physical memory computed as

       %ss * 0x10 + 0x8200

   where %ss is the stack segment register.

   The details about why the hardware works like this are not
   relevant now. The what does matter at this point is what is
   in register %ss. Hopefully, the BIOS has zeroed it before
   jumping to our program. In this case

       0x0 * 0x10 + 0x8200 = 0x8200

   that is, the reference address is the same as the physical
   address. Unfortunately (one should be already used to
   'unfortunately' when it comes to BIOS), some BIOSes may
   leave %ss with the load address 0x7c00. Therefore, %sp will
   be actually pointing to

       0x7c00 * 0x10 + 0x8200 = 0x84200

   With those BIOSes, this will be address of the stack base.
   The relevant observation here is that 0x84200 is still
   inside the free area.


 */
