/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/* Like eg-03.c but including header file. */

#include <eg-04.h>

int main ()
{
   int a,b;
   a = foo(1);
   b = bar(2);
   return a+b;
}

int foo(int x)
{
   return x+1;
}

int bar(int x)
{
   return x+2;
}
