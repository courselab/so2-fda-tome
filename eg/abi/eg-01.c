/*
 *    Copyright (c) 2021, Monaco F. J. <monaco@usp.br>. <monaco@usp.br>
 *    SPDX-FileCopyrightText: 2001 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

#include <stdio.h>

int b=1;
int a;

int main(void)
{
  int c;
  int d=2;

  a = 3;
  b = 4;
  c = 5;
  d = 6;

  printf ("%d %d %d %d\n",a,b,c,d);

  return 0;
}

