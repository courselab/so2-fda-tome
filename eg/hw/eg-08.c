/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/* Boot, say hello and halt. 
   A source code with a familiar C look.
*/

#include <stdio.h>

int main (void){

  printf ("Hello World");

  return 0;
}


/* 
   In honor of the sacred ancestral traditions and beholden 
   reverence to the braves who coded before us, we  hereby 
   bestow our humble 'Hello World' tribute. May our source be 
   blessed and stand against all bugs that dare to come along.

   Notes:
   
   * The program's entry point is the function _start, which then
     calls main(), as it's also the case in traditional PC OSes.
     When main() is done, it leaves the return value in %eax,
     and returns to __start(), which then halts the computer.

     In a Linux-based OS, __start would call the syscall 'exit'
     to terminate the process normally, and would make the process' 
     return status available for the parent process, as specified 
     by POSIX. The parent process can obtain the value through 
     the syscall 'wait'.

     Our example is a freestanding program, though, and our
     __start() is much simpler; it just halts the CPU.

   * The function printf() is declared in our own version of the
     standard IO library (stdio.h). Like ISO-C printf(), our
     version returns the number of characters written.
     This is a partial, incomplete implementation, though, as it
     does not encompass all the functionality required by the
     ISO standard. For the sake of the example, though, all we
     need is available and the program looks identical to the
     original K&H's source code example.

 */
