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
#include <fcntl.h>
#include "debug.h"

int main()
{
  pid_t pid;
  int status, i, rs;
  char buffer[1024];
  char *args[1024], *outfile;
  
  while (1)
    {
      /* Read user imput. */
      
      do
	{
	  printf ("> ");	        
	  fgets (buffer, 1023, stdin);	
	}
      while (buffer[0] == '\n');        


      /* Parse (tokenize) */
      
      i = 0;
      while (args[i] = strtok (i ? NULL : buffer, " \t\n"))
	i++;

      /* Check if output redirection is selected. */
      
      outfile = NULL;
      if ((i>2) && (args[i-2][0] == '>'))
	{
	  outfile = args[i-1];
	  args[i-2] = NULL;
	}

      /* Fork. */
      
      pid = fork();             

      if (pid>0)		/* Shell. */
	{
	  wait (&status);
	}
      else			/* Subprocess. */
	{
	  /* Redirect output. */
	  if (outfile)		
	    {
	      close (1);
	      rs = open (outfile, O_CREAT | O_RDWR, S_IRUSR|S_IWUSR);
	      sysfatal (rs<0);
	    }

	  execvp (args[0], args);
      
	  sysfatal(1);
	}
      
    }


  return EXIT_SUCCESS;
}
