/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <sys/wait.h>
#include "debug.h"

int main()
{
  int pid, status, rs;

  pid = fork();

  if (pid>0)			/* Parent process. */
    {

      printf ("Parent: pid %d, pgid: %d\n", getpid(), getpgid( getpid() ) );

      wait (&status);
    }
  else				/* Child process. */
    {
      /* Child inherits the progress group. */
      
      printf ("Child:  pid %d, pgid: %d\n", getpid(), getpgid( getpid() ) );

      /* But we can create it a new group. */

      setpgid (getpid(), getpid());

      /* Now the child has its own progress group */
      
      printf ("Child:  pid %d, pgid: %d\n", getpid(), getpgid( getpid() ) );


    }

  
  return EXIT_SUCCESS;
}
