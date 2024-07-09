/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/* debug.h - Debugging facilities. */
 

#ifndef DEBUG_H
#define DEBUG_H

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

/* Fatal system error:   sysfatal (exp)

   If expression 'exp' is true, the error string for 'errno' and abort.

   Use this macro to check the return status of functions that perform
   syscalls and can fail, specifically when the problem is irrecoverable
   and aborting the program is the most sensible measure.

*/

#define sysfatal(exp) do{if(exp) {fprintf(stderr, "%s : %d : %s\n", __FILE__, __LINE__, strerror(errno)); exit(EXIT_FAILURE);}}while(0)

/* sysfault (exp, rs, msg)

   If 'exp' is true, return immediately with status 'rs', and print the error
   string for 'errno', plus a user-supplied descriptive string 'msg'.
   
   Use this macro to check the return status of functions that perform
   sycalls and can fail, specifically when the problem should be handled
   by the caller.

*/ 
#define sysfault(exp, rs, msg) do{if(exp) {fprintf(stderr, "%s (%s)\n", strerror(errno), msg ? msg : ""); return rs;}}while(0)

#define sysfail(exp, rs, msg) do{if(exp) {fprintf(stderr, "%s (%s)\n", strerror(errno), msg ? msg : ""); exit(rs);}}while(0)


#define usage(str) fprintf (stderr, str)
/* #define argcheck(exp, str) do{if (exp) {usage(str); exit (EXIT_FAILURE);}}while(0) */

#endif	/* DEBUG_H */
