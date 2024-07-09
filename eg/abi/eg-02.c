/*
 *    Copyright (c) 2021, Monaco F. J. <monaco@usp.br>. <monaco@usp.br>
 *    SPDX-FileCopyrightText: 2001 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

struct foo_t
{
  char a;
  int b;
} foo;

int main()
{
  foo.a = 1;
  foo.b = 2;

  return 0;
};

