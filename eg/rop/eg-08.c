/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/* eg-01.c - C source file. */
 
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

void foo();

int main()
{
  char a[5];
  
  a[0] = 'H';
  a[1] = 'e';
  a[2] = 'l';
  a[3] = 'l';
  a[4] = 'o';

  /* a[21] =  ( char ) ((int)foo      ) & 0x000000ff; */
  /* a[22] =  ( char ) ((int)foo >>  8) & 0x000000ff; */
  /* a[23] =  ( char ) ((int)foo >> 16) & 0x000000ff; */
  /* a[24] =  ( char ) ((int)foo >> 24) & 0x000000ff; */

  * ((int *) &a[21]) = (int) foo;
  
  return 7;
}

void foo()
{
  write (1, "Ops\n", 4);
  exit(0);
}
