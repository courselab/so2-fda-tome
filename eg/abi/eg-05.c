/*
 *    SPDX-FileCopyrightText: 2001 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/* Call write (works with x86 and x86_64. */

#include <unistd.h>

int main ()
{
  write (1, "hello world!\n", 13);
  
  return 0;
}
