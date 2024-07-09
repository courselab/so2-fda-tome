#    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

	
  /* Prints one character in video display memory. */



  /* In real mode, memory is segmented in 64k blocks addressed by means of
     two 16-bit registers: one, called segment register, holds the base
     address (start of the segment), and another, referred to the offset
     segment, holds the (positive) distance from the base address.

     The effective, linear address corresponding to the pair
     segment:offset is a 20bit value computed as
     
     address = (segment << 4)   + offset 
             = (segment * 0x10) + offset     
     
     Eg: 0x6EF:0x1234 = 0x8124   (notice: segment+offset = 0x1923 != 0x8124)
     
         0000 0110 1110 1111 0000   segment << 4   0x6EF0
       +      0001 0010 0011 0100   Offset         0x1234
         ------------------------               	
         0000 1000 0001 0010 0100   Address        0x8124


     Segmented memory is conventionally denoted as <segment>:<memory>, 
     both values expressed in hexadecimal base, e.g. 6efe:1234.

     In total, it is possible to access 2^20 = 1M memory positions.

     But at each time, the selected segment corresponds to a 2^16 = 64k 
     memory block.
     
     Notice that there may be more than one combination segment:offset
     corresponding to a same effective address e.g. 0:10 = 10:0.

     In the x86 architecture, color video display memory starts at 0xb8000 
     real, linear address.

     We may access it as b800:0000.

*/

  .code16			   

__start:

        mov $0xb800, %ax           /* Color display memory. */
        mov  %ax, %ds              /* Set data segement.    */
	
	mov $0x0, %si	
        movb $'H',   (%si)         /* Write a character.    */
        movb $0x20, 1(%si)	   /* Apply attribute.      */

halt:
	hlt
	jmp halt

/* Notes.

   All references to memory using (%di) are affected by %cs.

   Therefore, line

       movb $'A', (%di)

  defaults to

       movb $'A', %cs:(%di)

   which moves the ASCII code of the character 'A' into cs:di, or the 
   effective memory location
   
       cs * 0x10 + di

   Let's do the math:

      0xb800 * 0x10 + 0x0 = 0xb8000

 */
