/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

int main(int argc, char **argv)
{
  pid_t pid;
  int count = 10, k;

  k = (argc > 1) && (argv[1][0] == 'c') ? 1 : 0;
  printf ("%s terminates first.\n", k ? "Child" : "Parent");
  
  pid = fork();
  
  if (pid>0)			/* Parent will execute this. */
    {
      while (count)
	{
	  printf ("P (pid %d, ppid %d): %d\n",
		  getpid(), getppid(), count--);
	  sleep(1 + k);
	}
    }
  else				/* Child will execute this.  */
    {
      while (count)
	{
	  printf ("C (pid %d, ppid %d): %d\n",
		  getpid(), getppid(), count--);
	  sleep(1 + !k);
	}
    }
  
  return EXIT_SUCCESS;
}
