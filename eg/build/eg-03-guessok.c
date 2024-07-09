/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

#include <stdio.h>

int foo();

int main()
{
  int b;
  b = foo(1, 2);

  printf("%u\n", b);

  return b;
}

int foo(int a, int b)
{
  return a+b;
}
