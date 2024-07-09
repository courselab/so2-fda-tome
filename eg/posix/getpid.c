/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

int main()
{
  pid_t pid, ppid;

  pid = getpid();		/* Get caller's PID.               */

  ppid = getppid();		/* Get PID of the caller's parent. */

  printf ("Pid: %d, parent pid: %d\n", pid, ppid);

  sleep(10);			/* Inspect running process with ps.*/
  
  return 0;
}
