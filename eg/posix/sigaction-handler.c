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
#include <signal.h>
#include <string.h>
#include "debug.h"

void my_handler (int num)
{
  printf ("\nOops, signal %d is being handled; try another signal.\n", num);
}

int main(int argc, char **argv)
{
  int rs, signum;
  struct sigaction act;

  /* Interpret command line. */
  
  argcheck (argc<2, "Usage: nokill <signum>\n");

  signum  = atoi (argv[2]);

  #ifdef _GNU_SOURCE
  printf ("Handling %s signal (%d)\n", sigabbrev_np(signum), signum);
  #endif

  /* Ignore signum. */
  
  rs = sigaction (signum, NULL, &act);
  sysfatal (rs<0);
 
  act.sa_handler = my_handler;
  
  rs = sigaction (signum, &act, NULL);
  sysfatal (rs<0);

  /* Do something. */
 
  while (1)
    {
      printf ("."); fflush(stdout);
      sleep(1);
    }

  return EXIT_SUCCESS;
}

/* Notes.

   (1) When a child is forked, it inherits the signal dispositions from the
       parent process. When the process calls exec(), its ignored signals
       remain ignored; its signal handlers, however are reset to their defaults.
       This makes sense, since the handler implemented by the program won't
       exist when the image is replaced by exec().

       That's why, contrarily to what we did in sigaction.c, here we can't
       use exec() to run an existing program.
       
*/
