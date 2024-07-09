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

int main(int argc, char **argv)
{
  int pid, status, rs;
  char opt, buffer[1024];
  
  argcheck (argc<2, "Usage: tcpgrp <p|c>\n");
  opt = argv[1][0];
  argcheck ( (opt != 'c') && (opt != 'p'), "Usage: tcpgrp <p|c>");

  
  pid = fork();

  if (pid>0)			/* Parent process. */
    {

      printf ("Parent: pid %d, pgid: %d\n", getpid(), getpgid( getpid() ) );

      if (opt=='c')
	tcsetpgrp (0, pid);
      
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


      /* Who is controlling the terminal? */

      sleep(1);
      
      printf ("Foreground process: %d\n", tcgetpgrp(0));

      fgets (buffer, 1023, stdin);

      printf ("Child read: %s\n", buffer);
      
    }

  
  return EXIT_SUCCESS;
}
