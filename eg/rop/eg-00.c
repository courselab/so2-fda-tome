/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/* eg-09.c - A buffer-overflow vulnerable program. */
 
#include <stdio.h>
#include <stdlib.h>

int verify_password (const char *);

int main (void)
{
  int verified = 0;
  char user_key[10];

  /* Read user's credentials. */

  printf ("Enter password: ");  
  scanf ("%s", user_key);

  /* Verify credentials. */
  
  if (verify_password (user_key))
    verified = 1;

  if (!verified)
    {
      printf ("Access denied\n");
      exit (1);
    }

  printf ("Access granted.\n");
  
  /* Priviledged code follows... */

  return 0;
}

/* This might be a function which encrypts the supplied 'key' and
   checks it agains a well-secured database.*/

int verify_password (const char *key)
{
  return 0;  /* Let's assume the supplied credentials are wrong. */
}

