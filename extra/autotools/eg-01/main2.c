/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

#include <stdlib.h>
#include <string.h>

#include "foobar.h"

/* Call bar() and foo() in this order. */

int main (int argc, char **argv)
{
  
  bar();
  foo();

  return EXIT_SUCCESS;
}

