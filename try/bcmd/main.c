/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

#include "bios.h"
#include "utils.h"

#define PROMPT "$ "		/* Prompt sign.      */
#define SIZE 20			/* Read buffer size. */

char buffer[SIZE];		/* Read buffer.      */

int main()
{
  clear();
  
  println  ("Boot Command 1.0");

  while (1)
    {
      print(PROMPT);		/* Show prompt.               */
      readln(buffer);		/* Read use input.            */

      if (buffer[0])		/* Execute built-in command.  */
	{
	  if (!strcmp(buffer,"help"))
	    println("A Beattles's song.");
	  else 
	    println("Unkown command.");
	}
    }
  
  return 0;

}

