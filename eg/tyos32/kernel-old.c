/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

#include <utils.h>

int puts(const char *string)
{
  register short i __asm__("%si") = 0; /* Variable i is register %si. */
  
  while (string[i])
    {
      ((short *)0xb8000)[i] = (0x20 << 8) + string[i];
      i++;
    }
  
  return i;
}


void __attribute__((naked)) init()
{
  /* echo (" Stage 2: second stage loaded sucessuflly!" NL); */

  /* echo(NL " Kernel up and running!" NL); */

  puts ("We're in.")
  
}



