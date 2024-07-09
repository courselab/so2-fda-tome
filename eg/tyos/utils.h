/*
 *    SPDX-FileCopyrightText: 2001 Monaco F. J. <monaco@usp.br>
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

#ifndef UTILS_H
#define UTILS_H

#define VIDEO_MEMORY 0xb8000
#define VIDEO_ATTRIBUTE 0X02

/* Print string str on standard output. */

#define NL "\r\n"   /* CR-LF sequence.*/

void __attribute((naked, fastcall)) echo (const char *str);

/* Clear the screen. */

void __attribute__((naked, fastcall)) clear (void);

/* Halt the system. */

void system_halt();


#endif	/* UTILS_H. */
