/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */


OUTPUT_FORMAT(binary)		/* Output flat binary (no structure). */
SECTIONS
{
        . = 0x7C00;		/* Line counter is now 0x7c00. */
        .stage1 :
	{
          rt0.o (.text .data .bss .rodata)
          stage1.o (.text .data .bss .rodata)
          bios1.o (.text .data .bss .rodata)
	}
	
        . = 0x7c00 + 510;	/* Advance 510 bytes. */
	
        .signature : 		/* Add a signadure section with this content. */
	{
	    BYTE(0x55)
            BYTE(0xAA)
        }

	_KERNEL_ADDR = .;

	.kernel :
	{
	  kernel.o (.text .data .bss .rodata)
	  klib.o (.text .data .bss .rodata)
	  bios2.o (.text .data .bss .rodata)
	}

	_KERNEL_SIZE = . - _KERNEL_ADDR;

	_END_STACK = 0x7c00;
	
}
STARTUP(rt0.o)			 /* Prepend with the start file. */




