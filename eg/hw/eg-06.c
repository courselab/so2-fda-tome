/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/* Boot, say hello and halt. 
   Using extended assembly.
*/

#include <eg-06.h>

const char msg[]  = "Hello World";

 
int __attribute__((naked)) main()   /* This function is called by _start() */
{
  

  write_str(msg);	    /* This will be a function call in asm code. */


  _return;
}



/* Notes

   This program has the familiar look of a regular C program now (almost).

   The code is similar to eg-05, with the following notable difference.

(1) We moved the function _start() to another compilation unit eg-06_rt0.S 
   which we'll refert to as runtime initializer, or simply rt0. The purpose of 
   an rt0 is to perform the initial setup needed for the whole program to 
   execute properly in a given enviroment --- this includes, for example, 
   initializing the stack.

   In conventional plataforms such as Linux and Windows, the rt0 contains
   the program entry point, a function usualy called _start. When the program
   is loaded, the execution starts from _start(). Under a C runtime, it is
   this function which then calls main(). When main() returns, it returns to
   _start(), which properly asks the kernel to end the process by issuing
   the syscall 'exit'. We don't normally see this happening because the
   runtime initializar (an object file named crt0.o in Linux) is automatically
   added by the linker it is invoked by the compiler when we do

       gcc foo.c -o foo

   (there's no need to pass crt0.o in the command line).

   In our standalone bare-metal program, _start() just initializes SP and
   call main(). When main() returns, _start() halts the program (as there is
   not kernel to issue an exit syscall).

 (2) The _return macro.

     When main() comples, it should return to _start(). We need therefore
     a 'ret' instruction. Normally, the compiler adds such an instruction
     at the any of any function. However, to make the assembly as simple as
     possible, we used the attribute 'naked' with main(), which causes
     the compiler to supress some extra asm code that we don't strictly
     need. As a collateral effect, thought, the 'naked' attribute supress
     the return instruction as well, even if we use the keyword 'return'
     explicitly. For that reason, we need to add it manually using 
     inline assembly.

     In our code we do it using the macro _return, defined in eg-06.h.

 */
