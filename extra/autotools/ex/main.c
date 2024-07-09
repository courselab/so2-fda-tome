/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "foobar.h"
#include "config.h"

#define MSG "xpto"

#if HAVE_DECL_STRDUP == 0
char *strdup (const char*);
#endif

int main (int argc, char **argv)
{
  char *s;
  
  printf (PACKAGE_STRING "\n");

  foo();
  bar();

  s = strdup(MSG);

  printf ("String: %s\n", s);

  
  return EXIT_SUCCESS;
}
