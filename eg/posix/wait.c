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
#include "debug.h"


int main()
{
  pid_t pid, status, rs;

  pid = fork();		/* Fork: now we have two processes.           */
  
  if (pid>0)		/* The shell (parent) executes this block.    */
    {
      wait (&status);	/* Blocks until child terminates.              */

      if (WIFEXITED(status))
	printf ("Process terminated normally with exit status %d\n",
		WEXITSTATUS(status));
      else
	printf ("Process terminated abnormally.\n");
      
      
    }
  else			/* The subprocess (child) executes this block.*/
    {      
      rs = execlp ("xeyes", "xeyes", NULL); /* Replace child's image.            */
      sysfatal (rs<0);
    }
  

  return EXIT_SUCCESS;
}
