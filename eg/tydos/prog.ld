/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/* This is the linker script used to build user programs. */

OUTPUT_FORMAT(binary)		/* Output flat binary (no structure). */
SECTIONS
{
	PRG_LOAD_ADDR = 0xFE00;	/* Program load address.              */
	
        . = PRG_LOAD_ADDR;
	
        .bin :
	{
          *.o   (.text .data .bss .rodata) /* Command line objects. */
	  libtydos.o (.text .data .bss .rodata) /* Runtime library. */
	}		
     . = 0x10000; /* Endereço de carga */
  .text : {
    *(.text)
  }
  .rodata : { *(.rodata) }
  .data : { *(.data) }
  .bss : {
    _bss_start = .;
    *(.bss)
    _bss_end = .;
  }
  /DISCARD/ : { *(.note.GNU-stack) }
}
INPUT(libtydos.a)		/* Link with the TyDOS user library. */




