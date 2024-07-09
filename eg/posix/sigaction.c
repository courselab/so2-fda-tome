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


int main(int argc, char **argv)
{
  int rs, signum;
  char *prog;
  struct sigaction act;

  /* Interpret command line. */
  
  argcheck (argc<3, "Usage: nokill <program> <signum>");

  prog    = argv[1];
  signum  = atoi (argv[2]);

  #ifdef _GNU_SOURCE
  printf ("Ignoring %s signal\n", sigabbrev_np(signum));
  #endif

  /* Ignore signum. */
  
  rs = sigaction (signum, NULL, &act);
  sysfatal (rs<0);
 
  act.sa_handler = SIG_IGN;
  
  rs = sigaction (signum, &act, NULL);
  sysfatal (rs<0);

  /* Exec program.*/
    
  execlp (prog, prog, NULL);
  
}
