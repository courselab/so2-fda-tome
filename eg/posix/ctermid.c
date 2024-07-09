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
#include <fcntl.h>
#include "debug.h"

int main()
{

  printf ("Controlling terminal: %s\n", ctermid(NULL));

  printf ("TTY name:             %s\n", ttyname(0));
  
  return EXIT_SUCCESS;
}

