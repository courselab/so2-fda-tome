/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>

int main(int argc, char **argv)
{

  printf ("Hello\n");
  
  execlp ("./t", "./t", "xpto", NULL);

  printf ("Bye\n");
  
  return EXIT_SUCCESS;
}
