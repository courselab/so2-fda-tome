/*
 *    SPDX-FileCopyrightText: 2001 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

int foo()
{
  int register var __asm__("ebx");
  var += 1;
  return var;
}

int main ()
{
  foo();
  return 0;
}
