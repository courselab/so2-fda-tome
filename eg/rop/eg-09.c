/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(void)
{
  char buffer[512];

  printf ("Enter name:\n");

  gets (buffer);
  
  printf ("Hello %s\n", buffer);
  
  return EXIT_SUCCESS;
}

