/*
 *    Copyright (c) 2020-2022 - Monaco F. J. <monaco@usp.br>. <monaco@usp.br>
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

#ifndef SYSCALL_H
#define SYSCALL_H

#define SYS_WRITE 0

/* void  syscall_handler(void); */

void __attribute__((naked)) sys_write(void);

void  __attribute__((naked)) syscall_handler (int, int, int, int);

#endif	/* SYSCALL_H */
