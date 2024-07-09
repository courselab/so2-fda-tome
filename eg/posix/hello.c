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
#include <fcntl.h>

int main()
{
  int fd;
  
  /* FILE *fp; */

  /* fp = fopen ("out.txt", "w"); */
  
  /* fprintf (fp, "Hello world\n"); */

  /* fclose (fp); */

  fd = open ("out.txt", O_CREAT|O_WRONLY, S_IRUSR|S_IWUSR);
  
  write (fd ,"Hello world\n", 12) ;

  printf ("id = %d\n", fd);

  write (1, "Something\n", 10);

  printf ("stdout is fd %d\n", fileno(stdout));

  close (1);

  open ("/dev/pts/1", O_CREAT|O_WRONLY, S_IRUSR|S_IWUSR);
  
  printf ("Hi\n");
  
  close (fd);
    
  return EXIT_SUCCESS;
}
