/*
 *    SPDX-FileCopyrightText: 2001 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

int f1(int, int);
void f2();

int main()
{
  return f1(5,2);
}

int f1(int a, int b)
{
  int n;
  n = 1;
  f2();
  return a - b + n;
}

void f2(int a)
{
}
