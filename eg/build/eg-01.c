/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/* Call foo and return. */

#define MAX 10

const char *msg = "bar";

void foo();

int main()
{
  foo();
  return MAX;
}

void foo()
{
}

