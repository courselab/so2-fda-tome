/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>

int main()
{
  FILE *fp, *fp2;
  int fd;

  fp = fopen ("out.txt", "w");

  printf ("stdin %d\n", fileno(stdin));
  printf ("stdout %d\n", fileno(stdout));
  printf ("stderr %d\n", fileno(stderr));

  fd = open ("out.txt", O_RDWR | O_APPEND);

  fp2 = fdopen (fd, "w");

  fprintf (fp2, "Test\n");
  
  return EXIT_SUCCESS;


}
