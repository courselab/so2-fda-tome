/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <string.h>
#include "debug.h"

int main (int argc, char **argv)
{
  int pid, signum, rs;

  argcheck (argc<3, "Usage: kill <pid> <signum>\n");
  
  pid    = atoi (argv[1]);
  signum = atoi (argv[2]);

  #ifdef _GNU_SOURCE
  printf ("Sending %s signal to process %d\n", sigabbrev_np(signum), pid);
  #endif
  
  rs = kill (pid, signum);
  sysfatal (rs<0);
  
  return EXIT_SUCCESS;
}
