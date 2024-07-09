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
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>
#include <fcntl.h>
#include "debug.h"


int main()
{
  pid_t pid, shell_pid;
  int status, i, rs, background;
  char buffer[1024], *args[1024];
  
  while (1)
    {
      /* Read user imput. */
      
      do
	{
	  printf ("> ");	        /* Prompt.                 */
	  fgets (buffer, 1023, stdin);	/* Read command line.      */
	}
      while (buffer[0] == '\n');        /* Prevent empty commands. */

      /* Parse input and create an argv vector. */
      
      i = 0;
      while (args[i] = strtok (i ? NULL : buffer, " \t\n"))
	i++;

      /* Check for background token. */

      background = 0;
      if (args[i-1][0] == '&')
	{
	  background = 1;
	  args[i-1] = NULL;
	}

      /* Get a new progress group for the shell, and get control of it. */

      shell_pid = getpid();
      
      rs = setpgid (shell_pid, shell_pid);
      sysfatal (rs<0);
      
      rs = tcsetpgrp (0, shell_pid);
      sysfatal (rs<0);
      
      /* Create a subprocess. */
      
      pid = fork();

      if (pid>0)		  /* Parent process (shell).             */
	{

	  if (!background)
	    wait (&status);
	  else
	    {
	      rs = tcsetpgrp (0, pid);
	      sysfatal (rs<0);
	    }
	}
      else			  /* Subprocess (command).               */
	{
	  setpgid (getpid(), getpid());

	  execvp (args[0], args); /* Exec command.                       */
      
	  sysfatal(1);		  /* If we reach heare, exec has failed. */
	}      
    }
  return EXIT_SUCCESS;
}
