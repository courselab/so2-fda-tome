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
#include <sys/wait.h>

int main()
{
  int pipefd[2];
  int pid, status;
  char buffer[1024];

  /* Create a pipe.

     pipefd[0]: input, pipefd[1]: output. */
  
  pipe (pipefd);  

  pid = fork();

  if (pid)
    {
      close (pipefd[0]);		/* Parent won't read from the pipe. */
	
      write (pipefd[1], "Hello\0", 6);
      wait (&status);
    }
  else
    {
      /* Child inherits the parent's file descriptors. */

      close (pipefd[1]);	/* Child won't write into the pipe. */
      
      read (pipefd[0], buffer, 6);
      printf ("Parent said: %s\n", buffer);
    }
  
  return EXIT_SUCCESS;
}
