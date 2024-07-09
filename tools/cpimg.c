/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/* This program copies a stream of bytes to the output (like dd).*/

#include <stdio.h>
#include "debug.h"

#define PROGRAM "cpimg"
#define VERSION "0.1.0"

/* Program usage information. */

void help()
{
#define msg(s)   fprintf (stderr, s "\n");
  msg("");
  msg("Usage   " PROGRAM " [option] | <input-file> [<output-file>]");
  msg("");
  msg("          <input-file>             if not given, reads from stdin");
  msg("          <output-file>            if not given, writes to stdout (in ascii)");
  msg("");
  msg("          options:   --help        this help");
  msg("                     --version     software version");
  msg("");
}

/* Main program. */


int main(int argc, char **argv)
{
  FILE *fpout, *fpin;
  int c, op;

  fpin = stdin;
  fpout = stdout;

  /* Process options. */
  
  if (argc > 1)
    {
      if (!strcmp (argv[1], "--help"))
	{
	  help();
	  exit(EXIT_SUCCESS);
	}
      if (!strcmp (argv[1], "--version"))
	{
	  printf ("Version: %s %s\n", PROGRAM, VERSION);
	  exit(EXIT_SUCCESS);
	}
    }


  if (argc > 1)
    {
      fpin = fopen(argv[1], "r");
      sysfatal(!fpin);
    }


  if (argc > 2)
    {      
      fpout = fopen(argv[2], "w");
      sysfatal(!fpout);
    }


  while ((c=fgetc(fpin)) != EOF)
    fputc (c, fpout);
  
  fclose(fpin);
  fclose(fpout);
  
  
  return 0;
}
