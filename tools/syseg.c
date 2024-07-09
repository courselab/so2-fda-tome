/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/* syseg.c - SYSeg information. */

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include "syseg.h"
#include <config.h>

char syseg_error_buffer[2][SYSEG_ERROR_BUFFER_LENGTH] = {"",""};

void fail_ (		    
	    const char *program,	  
	    const char *file,
	    unsigned int line,
	    const char *message
			    )
{
  sprintf (syseg_error_buffer[0], "%s: %s : %d : %s",
	   program, file, line, message);

  fprintf (stderr, "%s\n", syseg_error_buffer[0]);
  fprintf (stderr, "%s\n", syseg_error_buffer[1]);

  
  exit(EXIT_FAILURE);
}


void fault_ (		    
	    const char *lib,	  
	    const char *file,
	    unsigned int line,
	    const char *message			    )
{

  
  sprintf (syseg_error_buffer[1], "%s: %s : %d : %s",
	   lib, file, line, message);

}
