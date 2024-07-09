/*
 *    SPDX-FileCopyrightText: 2001 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/* Calling convention: global-variable method. */


int arg1;			/* First argument.  */
int arg2;			/* Second argument. */

int foo ()
{
  return arg1 - arg2;
}

int main()
{
  arg1 = 5;
  arg2 = 2;

  return foo();
}
