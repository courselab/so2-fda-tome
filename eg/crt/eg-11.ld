/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

OUTPUT_FORMAT(binary)
SECTIONS
{
	. = 0x7c00;

	.code :
	{
		*(.text)	/* All sections .text. */
		*(.rodata)	/* Then all sections .rodata. */
		
	}

	. = 0x7c00 + 510;

	.signature :
	{
		BYTE(0x55)
		BYTE(0xAA)
	}

}
STARTUP(eg-11-crt0.o)

