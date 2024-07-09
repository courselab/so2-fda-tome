/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/* Program with multiple compilation units. */

#include <eg-06.h>


int main ()

{

  int a, b;

  a = foo(1);

  b = bar(2);

  return a+b;

}

