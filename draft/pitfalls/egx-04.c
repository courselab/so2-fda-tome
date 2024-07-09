/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/* An exaple to illustrate GCC limitations when
   dealing with 8-bit registers. */

void __attribute__((naked)) foo()
{

  register short bx   __asm__  ("bx");
  register short ax   __asm__  ("ax");
  register char  ah   __asm__  ("ah");
  register char  al   __asm__  ("al");
  register int  eax   __asm__  ("eax");
  
  bx = 0x1;
  ax = 02;
  ah = 0x3;
  al = 0x4; 
  
}











