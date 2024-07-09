/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>
#include <stdlib.h>

#define N 3			/* Number of commands. */

int main()
{
  int pfd[N-1][2], status, i, j, pid, exit_status;


  /* For simplicity, let's assume the command line is a pipeline with 
     3 commands like this:

     ls -l | grep \\.c | wc -l                                        */
  
  char *args[][1024] =
    {
      {"ls", "-l", NULL},
     {"grep", "\\.c", NULL},
     {"wc", "-l", NULL}
    };


  /* Create N-1 pipes (the subprocesses will inherit them). */
  
  for (i=0; i < N-1; i++)
    pipe (pfd[i]);

  /* Fork N suprocesses. 

     Notice that we need to prevent the newly created subprocess from keeping
     executing the look (and thus creating more subprocesses). The condition
     on pid>0 ensures that the subprocess escapes from the loop. In the 
     parent process, when the loop comples pid contains the PID of its last
     child. Observe also that in the n-esime child, i == n.                    */
  
          
  for (i=0; (i<N) && (pid = fork()); i++);


  if (pid>0)			/* In the parent process,               */
    {
      for (j=0; j<N-1; j++)	/* close all pipes and                  */
	{
	  close (pfd[j][0]);
	  close (pfd[j][1]);
	}

      waitpid(pid, &status, 0);	/* wait for the last child to complete. */

      if (WIFEXITED(status))
	exit_status = WEXITSTATUS(status);

      getchar();
      
    }
  else				/* In the child processes, */
    {

      if (i>0)			/* all but the 1st child redirects input;    */
	{
	  close(0);
	  dup (pfd[i-1][0]);
	  close (pfd[i-1][0]);
	}
      if (i<N-1)		/* all but the last child redirects output. */
	{
	  close(1);
	  dup (pfd[i][1]);	  	  	  
	}
      
      
      for (j=0; j<N-1; j++)	   /* Then each child close all the pipes,*/
	{
	  close (pfd[j][0]);
	  close (pfd[j][1]);
	}

      execvp (args[i][0], args[i]); /* and calls exec. */

      return EXIT_FAILURE;	    /* If we reach here, exec has failed.  */
      
    }

  /* The exit status of a pipeline is the exit status of its last child. */
  
  return exit_status;		/* Only the parent reaches here. */
}
