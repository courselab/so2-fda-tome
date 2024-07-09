/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/*  Linker script. */

OUTPUT_FORMAT(binary)		/* Output flat binary (no structure)  */
SECTIONS
{
        . = 0x7c00;		/* Load address.            */
	 
	.text :			/* Stage 1.                 */
	{
	  rt0.o (.text .data .bss .rodata)
	  bootloader.o (.text .data .bss .rodata)
	  utils.o (.text .data .bss .rodata)
	}

        . = 0x7c00 + 510;	 /* Boot signature address. */

	.signature : 		 /* Boot signature.         */
	{
	    BYTE(0x55)
            BYTE(0xAA)
        }

	_STAGE2_ADDR = .;	 /* For load_sector().      */

	.text2 :		 /* Stage 2                 */
	{
	   init32.o (.text .data .bss .rodata)
	   kernel.o (.text .data .bss .rodata)
	}

        _STAGE2_SIZE = . - _STAGE2_ADDR ;

	_END_STACK = 0x7c00;	 /* Just bellow 7c00h.                */


}
STARTUP(rt0.o)			 /* Prepend with the start file.      */


/* 
   Notes.

   (1) This script cause the linker to create two "pseudo variables"
       _STAGE2_ADDR and _STAGE2_SIZE. These are here called this way
       because they are not regular variables.

       When the compiler creates a global variable, it does two things:
       a) allocate some memory for the variable; b) create an entry for that
       variable in the symbol table, containing the name of the symbol (the
       name of the variable), and it's address in memory. When this variable
       is accessed, say to attribute it a value, the linker looks at the
       symbol table to find the variable location, and store the value at
       that location.

       The "variables" created by the linker script are, in a sense, half
       of a variable. The linker creates an entry for the symbol at the
       symbol table, but does not allocate memory. Instead, the value we
       have attributed to it is annotated as if it were the symbol's address.

       In the C source code, a linker's symbol can be referenced as if it
       were a normal variable, with the exception that we can neither read
       for it nor write into it. We can only reference it's address (which
       is, naturally, the value attributed by the linker).
       
   
 */
