/*
 *    SPDX-FileCopyrightText: 2001 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

int bar = 0;

int foo (void)
{
  return ++bar;
}


int main (void)
{
  bar = foo();
  return 0;
}
