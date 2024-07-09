/*
 *    Copyright (c) 2021, Monaco F. J. <monaco@usp.br>. <monaco@usp.br>
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

#ifndef SYSEG_H
#define SYSEG_H

#include <string.h>
#include <errno.h>

#define SYSEG_ERROR_BUFFER_LENGTH 1024
#define LIBNAME "libsyseg"

#ifdef program_invocation_short_name
#  define program_name program_invocation_short_name
#else
#  ifdef PROGRAM
#    define porigram_name PROGRAM
#  else
#    define program_name "Error"
#  endif
#endif

void fault_ (const char *program, const char *file, unsigned int line, const char *message);

void fail_ (const char *program, const char *file, unsigned int line, const char *message);

/* Macro called by a function to return on error. */

#define sysfault(exp, val) do{if (exp) fault_ (LIBNAME, __FILE__, __LINE__, strerror(errno)); return val; }while(0)

/* Macro called by a program to exit on function call error. */

#define fail(exp) do{if (exp) fail_ (program_name, __FILE__, __LINE__, "system fault");}while(0)

#define fault(exp, val) do{ if (exp) return val;}while(0)


#endif	/* SYSEG_H */
