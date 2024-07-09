/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>
#include "debug.h"

int main()
{
  int fd;
  int n;
  
  fd = open ("out.txt", O_CREAT|O_WRONLY, S_IRUSR|S_IWUSR);
  sysfatal (fd<0);

  n = write (fd, "Hello", 5);
  sysfatal (n<0);

  printf ("fd = %d\n", fd);
  
  close (fd);

  write (1, "xpto\n", 5);

  close (1);

  open ("/dev/pts/1", O_CREAT|O_WRONLY, S_IRUSR|S_IWUSR);
  
  printf ("Something\n");
  
  return EXIT_SUCCESS;

}
