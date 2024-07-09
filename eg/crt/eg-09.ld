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
		*(*)		/* Copy all objects into the output (1). */
	}

	. = 0x7c00 + 510;

	.signature :
	{
		BYTE(0x55)
		BYTE(0xAA)
	}

}
STARTUP(eg-09-crt0.o)	/* Now we don't need to pass it in the command-line.*/

/* Notes

   (1) We're tellin the linker to copy all the objects entirely into the output
       files. In the present case, we have only two files: the main program,
       which is passed as argument to the linker, and the startup file crt0, 
       which now is automatically selected by the linker. Since the startup
       file is prepended to the final binary, we didn't have to specify the
       ordem in which we want objects to be ensembled into the binary file.

 */
