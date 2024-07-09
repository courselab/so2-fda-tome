/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

#include "bios1.h"
#include "kernel.h"

#define PROMPT "$ "		/* Prompt sign.      */
#define SIZE 20			/* Read buffer size. */

int main()
{
  clear();
  
  println  ("Bootloader: boot sector successfully loaded by BIOS.");

  load_kernel();
  
  kernel_init();
  
  return 0;

}

