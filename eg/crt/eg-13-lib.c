/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

#define video ((short*) 0xb8000)


int puts(const char *string)
{
  int i = 0;
  
  while (string[i])
    {
      video[i] = (0x20 << 8) + string[i];
      i++;
    }
  
  return i;
}
  


