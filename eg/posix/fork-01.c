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

int main()
{
  pid_t pid;
  
  /* Function fork() returns to the
      - parent: child's pid;
      - child : 0 (zero)              */
  
  pid = fork();
  
  if (pid>0)			/* Parent will execute this. */
    {
      printf ("Parent (pid %d): I'm your father.\n", getpid());
    }
  else				/* Child will execute this.  */
    {
      printf ("Child  (pid %d): Nooooo...\n", getpid());
    }

  sleep(10);

  
  return EXIT_SUCCESS;
}
