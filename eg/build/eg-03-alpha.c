/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/* Like eg-02.c but with functions implemented after main().
   We should expect a warning message from the compiler.*/

int main ()
{
   int a,b;
   a = foo(10);
   b = bar(20);
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

