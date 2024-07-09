/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/* main.c - Example program.  */

#include <stdio.h>
#include <stdlib.h>

#include <rectangle.h>
#include <square.h>
#include <circle.h>

#define SIDE   5.0
#define RADIUS 3.0
#define BASE 3.0
#define HEIGHT 2.0

int main (int argc, char **argv)
{
  float ac, ar, as;

  ac = circle (RADIUS);
  ar = rectangle (BASE, HEIGHT);
  as = square (SIDE);

  printf ("Area of a circle of radius %1.1f is %1.1f\n", RADIUS, ac);
  printf ("Area of a rectangle of base %1.1f and height %1.1f is %1.1f\n", BASE, HEIGHT, ar);
  printf ("Area of a square of sides %1.1f is %1.1f\n", SIDE, as);

  return EXIT_SUCCESS;
}
