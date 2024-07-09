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
  
  fork();
  
  printf ("Hi, my pid is %d and my parent's is %d\n",
	  getpid(), getppid());


  sleep (10);
  
  return EXIT_SUCCESS;
}
