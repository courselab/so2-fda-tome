/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

#ifndef BIOS_H
#define BIOS_H

void __attribute__((fastcall)) clear (void);
void __attribute__((fastcall)) print();
void __attribute__((fastcall)) println();
void __attribute__((fastcall)) readln(char *);


#endif
