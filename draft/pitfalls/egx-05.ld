/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

OUTPUT_FORMAT(binary)
ENTRY(_start)
SECTIONS {

	 . = 0x7C00;             /* Line counter is now 0x7c00. */

        .text :   { *(.text) }

        . = 0x7c00 + 510;       /* Advance 510 bytes. */
        .signature :            /* Add a signadure section with this content. */
        {
            BYTE(0x55)
            BYTE(0xAA)
        }


}
