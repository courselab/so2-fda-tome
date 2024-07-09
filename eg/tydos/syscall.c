/*
 *    SPDX-FileCopyrightText: 2024 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/* The kernel registers a syscall handler at IVT entry 0x21. */

#include "bios1.h"
#include "bios2.h"

/* TyDOS syscall calling convetion: arguments in %ax, %dx and %cx.
   return value in %ax. See regparm(3) in function attributes section
   of the GCC manual.*/

#define _tycall_ __attribute__((regparm(3) ))

/* Print a string on the screen. */

int _tycall_ sys_write(const char* str)
{
  kwrite (str);
  return 0;
}

/*  Syscall 0 is invalid (should never be called)*/

int _tycall_ sys_invalid ()
{
  fatal ("Invalid syscall.");
  return 1;
}


/* This syscall should be called by the program upon termination. */

int _tycall_ sys_exit()
{
  return 0;
}


int sys_gets(char *buffer) {
    gets(buffer);
    return 0;
}

void syscall_handler(int syscall_number, ...) {
    va_list args;
    va_start(args, syscall_number);
    switch (syscall_number) {
        case SYS_GETS:
            sys_gets(va_arg(args, char*));
            break;
        // Outros casos de syscalls existentes
        default:
            printf("Unknown syscall: %d\n", syscall_number);
            break;
    }
    va_end(args);
}
