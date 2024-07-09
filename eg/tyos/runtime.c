/*
 *    Copyright (c) 2020-2022 - Monaco F. J. <monaco@usp.br>. <monaco@usp.br>
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

#include "syscall.h"

/* Issue syscall number with arguments arg1, arg2, arg3. 
   Return the value in %ax. */

int syscall (int number, int arg1, int arg2, int arg3)
{
  int register ax __asm__("ax"); /* Declare variables are registers. */
  int register bx __asm__("bx");
  int register cx __asm__("cx");
  int register dx __asm__("dx");
  int ax2, bx2, cx2, dx2;
  int status;

  /* Save current registers. */
  ax2 = ax;
  bx2 = bx;
  cx2 = cx;
  dx2 = dx;

  /* Load registers. */
  ax = number;
  bx = arg1;
  cx = arg2;
  dx = arg3;
  
  __asm__("int $0x21");

  status = ax;
  
  /* Restore registers. */
  ax = ax2;
  bx = bx2;
  cx = cx2;
  dx = dx2;

  return status;
}


int puts (const char *buffer)
{
  int status;
  status = syscall (SYS_WRITE, (int) buffer, 0, 0);
  return status;
  
}

