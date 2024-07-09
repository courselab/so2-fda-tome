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
#include <unistd.h>

int main()
{

  close (1);

  open ("out.txt", O_CREAT|O_WRONLY, S_IRUSR|S_IWUSR);
  
  printf ("Hello world\n");

  return EXIT_SUCCESS;
}
