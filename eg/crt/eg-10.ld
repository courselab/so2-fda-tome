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
		eg-10.o (.text .rodata)
		
	}

	. = 0x7c00 + 510;

	.signature :
	{
		BYTE(0x55)
		BYTE(0xAA)
	}

}
STARTUP(eg-10-crt0.o)

/* Notes

   (1) In this example, the assembly file is produced by the C compiler.
       See in 'eg-10.s' that the compiler decided to split the executable
       and the string in two different sections. Section .txt contains
       the code; section .rodata contains read-only data.

       Now that we have two sections in eg-10.o, we should specify in
       which order they will be copied into the binary file. We need the
       executable code to come first.

 */
