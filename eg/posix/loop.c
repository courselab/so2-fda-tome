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

int main (int argc, char **argv)
{
  int count = atoi(argv[1]);

  while (count)
    {
      printf ("Loop: %d\n", count--);
      sleep(1);
    }
  
  return EXIT_SUCCESS;
}
