/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

#include <eg-03.h>

void ATTR puts (const char *str)
{

  short *video = (short *) VIDEO_MEMORY;
  int i = 0;
  
  while (str[i])
    {
      video[i] = (VIDEO_ATTRIBUTE << 8) + str[i];
      i++;
    }
  RET
}
