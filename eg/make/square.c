/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/* square.c - Area of a rectangle. */

#include <rectangle.h>

float square (float side)
{
  float a;

  a = rectangle (side, side);

  return a;
}
