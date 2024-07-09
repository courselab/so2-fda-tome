/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/* This program reads an ASCII file containing a series of byte values
   in hexadcimal representation and converts each one into its binary
   value. For instance, the string "0c" in the input file is converted
   to the value 12 in the output.  */


#include <stdio.h>
#include <stdlib.h>
#include "debug.h"

#define PROGRAM "hex2bin"
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

int main (int argc, char **argv)
{
  FILE *fpin, *fpout;
  unsigned char val;
  /* int count=0; */
  
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
    }
  

  /* This the part of the program which does the actual job. */
  
  /* printf ("unsigned char prog[] = "); */
  /* while ( fscanf (fpin, "%c", &val) >= 0) */
  /*   printf ("%c 0x%.2x", (count++ ? ',':' '), val); */
  /* printf (");"); */
    
  while ( fscanf (fpin, "%c", &val) >= 0)
    printf ("%.2x ", val);

  /* Cleanup upon leaving. */
  
  if(fpin != stdin)
    fclose (stdin);
  if(fpout != stdout)
    fclose (stdin);

  return EXIT_SUCCESS;
}
