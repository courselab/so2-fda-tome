/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/* egx-04.c - Auxiliary example source. */

void __attribute__((naked)) foo()
{
  register int bar __asm__("eax");

  bar = 42;

  __asm__("hlt");
  
}
