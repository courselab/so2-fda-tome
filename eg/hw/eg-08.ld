/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/*  Linker script for MBR. */

OUTPUT_FORMAT(binary)		/* Output flat binary (no structure) */
SECTIONS
{
        . = 0x7c00;		/* Line counter is now 0x7c00. */
        .text :
	{
	  *(.text)              /* Copy input section .text to the oputput. */
	  *(.rodata)		/* Copy input section .rodata to the output. */
	}	
        . = 0x7c00 + 510;	/* Advance 510 bytes. */
        .signature : 		/* Add a signadure section with this content. */
	{
	    BYTE(0x55)
            BYTE(0xAA)
        }
	__END_STACK__ = 0x8200;	
}
STARTUP(eg-08_rt0.o);
INPUT(eg-08_utils.o)



