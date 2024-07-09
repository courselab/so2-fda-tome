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
  pid_t pid;
  int status, i;
  char buffer[1024], *args[1024];
  
  while (1)
    {
      /* Read user imput. */
      
      do
	{
	  printf ("> ");	        /* Shop prompt.            */
	  fgets (buffer, 1023, stdin);	/* Read command line.      */
	}
      while (buffer[0] == '\n');        /* Prevent empty commands. */

      /* Parse input and create an argv vector. */
      
      i = 0;
      while (args[i] = strtok (i ? NULL : buffer, " \t\n"))
	i++;

      /* Create a subprocess. */
      
      pid = fork();

      if (pid>0)		  /* Parent process (shell).             */
	{
	  wait (&status);
	}
      else			  /* Subprocess (command).               */
	{

	  execvp (args[0], args); /* Exec command.                       */
      
	  sysfatal(1);		  /* If we reach heare, exec has failed. */
	}      
    }
  return EXIT_SUCCESS;
}
