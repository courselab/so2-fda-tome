/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

#include "bios1.h"
#include "klib.h"

void kernel_init(void)
{
  println  ("Kernel:     extra sectors successfully loaded by the bootloader.");

  splash();

  bounce();
  
  halt();
  
}


