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
  pid_t pid, N;
  int status, i, j, pfd[128][2], exit_status;
  char buffer[1024], *args[128][1024], *p, *q, *r, *s;
  
  
  while (1)
    {

      /* Read user imput. */
      
      do
	{
	  printf ("> ");
	  fgets (buffer, 1023, stdin);
	}
      while (buffer[0] == '\n');

      
      /* Parse input: (break pipeline into commands, and commands into args.*/
      
      for (i=0 ; p = strtok_r (i ? NULL : buffer, "|", &r); i++)
	{
	  q=p;
	  for (j=0; args[i][j] = strtok (j ? NULL : p, " \t\n"); j++);
	  p=q;
	}
      
      N = i;			/* Number of commands in the pipeline. */

      /* Creat N-1 pipes;  */
      
      for (i=0; i < N-1; i++)
	pipe (pfd[i]);

      /* Fork N subprocesses. */
      
      for (i=0; (i<N) && (pid = fork()); i++);


      /* Parent waits, child execs. */
      
      if (pid>0)                      /* In the parent process,              */
	{
	  for (j=0; j<N-1; j++)       /* close all pipes.                    */
	    {
	      close (pfd[j][0]);
	      close (pfd[j][1]);
	    }

	  /* All children must be wait()ed to eliminate zombies.
	     We proceed only after the last child returns. */

	  while (pid != wait(&status)); 

	  
	  if (WIFEXITED(status)) 
	    exit_status = WEXITSTATUS(status); /* Status of the last child.*/

	}
      else                        /* In the child processes, */
	{

	  
	  if (i>0)                /* all but the 1st child redirects input;    */
	    {
	      close(0);
	      dup (pfd[i-1][0]);
	    }
	  if (i<N-1)              /* all but the last child redirects output.*/
	    {
	      close(1);
	      dup (pfd[i][1]);
	    }


	  for (j=0; j<N-1; j++)    /* Then each child close all the pipes,*/
	    {
	      close (pfd[j][0]);
	      close (pfd[j][1]);
	    }



	  execvp (args[i][0], args[i]); /* and calls exec. */

	  sysfatal(1);                 /* If we reach here, exec has failed.*/
	  

	}


    }
  
  return EXIT_SUCCESS;
}


