/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/*  Linker script file. */

OUTPUT_FORMAT(binary)		/* Output flat binary (no structure) */
SECTIONS
{
        .text :
	{
	  *(.text)              /* Copy input section .text to the oputput. */
	}	
}




