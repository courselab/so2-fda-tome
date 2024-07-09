/*
 *    SPDX-FileCopyrightText: 2001 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/* Call syscall write in linux x86. */

#include <unistd.h>
#include <sys/syscall.h>

int main(void)
{
  syscall(4, 1, "hello, world!\n", 14);
  return 0;
}

