/*
 *    SPDX-FileCopyrightText: 2001 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/* Calling convention: register method. */

int __attribute__((fastcall)) foo (int arg1, int arg2)
{
  return arg1 - arg2;
}


int main()
{
  return foo (5,2);
}
