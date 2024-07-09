/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

#include <eg-01.h>

#define _(...) # __VA_ARGS__ "\n\t"

int main()
{

  //puts ("Here we are.");

#if 0
  
  __asm__ volatile 
    (
     _(           mov $0xb800, %%ax          )
     _(           mov %%ax, %%ds             )
     _(           movb $'A', (%%di)          )
     _(           movb $0x20, 1(%%di)        )
     
     :::
     );


  
  __asm__ volatile
    (
     /* _( mov $0, %%ax) */
     /* _( mov %%ax, %%ds) */
     _(           movw $0xb800, %%ax          )
     _(           movw %%ax, %%ds             )
     _(           movw $0, %%di               )
     _(           movb $'B', (%%di)           )
     _(           movb $0x20, 1(%%di)         )
     _(           movw $2, %%ax               )
     _(           add %%ax, %%di              )
     _(           movb $'C', (%%di)           )
     _(           movb $0x20, 1(%%di)         )
     
     :::
     );


  
  __asm__ volatile
    (
     _(           mov $0, %%ax                  )
     _(           mov %%ax, %%ds                )
     _(           movl $0xb8000, %%edi          )
     _(           movb $'D', (%%edi)            )
     _(           movb $0x20, 1(%%edi)          )
     :::
     );
  
  __asm__ volatile 
    (
     _(           mov $0xb800, %%ax          )
     _(           mov %%ax, %%ds             )
     _(           movw (msg%=), %%bx         )
     _(           movb $0x20, 1(%%bx, %%di)  )
     _( halt%=:                              )
     _(           hlt                        )
     _(           jmp halt%=                 )
     _( msg%=:                               )
     _(           .string "Hello World"      )
     :::
     );

  __asm__ volatile
    (
     _( mov $0xb800, %%ax)
     _( mov %%ax, %%ds)
     _(           movl $0x0, %%edi          )
     _(           movb $'Y', (%%edi)            )
     _(           movb $0x02, 1(%%edi)          )
     :::
     );
#endif    

#define VIDEO_MEMORY 0xb8000
#define VIDEO_MEMORY_SEGMENT (VIDEO_MEMORY >> 4)

  /* This is the f*ing problem!

     When we move xb800 to %ds, then (msg + %bx) actually points
     to (0xb800 << 4) + (msg + %bx)... 

 */


  #if 0
  
  __asm__ volatile
    (
     "           mov %[vid] , %%ax             ;"
     "           mov %%ax, %%ds                ;"
     "           mov  $0x0, %%ax               ;"
     "           mov  $0x0, %%di               ;"
     "           mov  $0x0, %%bx               ;"
     " loop%=:                                 ;"
     "           movb %%es:msg%=(%%di), %%al   ;"
     "           movb %%al,  (%%bx,%%di)       ;"
     "           inc %%bx                      ;"
     "           movb $0x02, (%%bx,%%di)       ;"
     "           inc %%di                      ;"
     "           mov %%bx, %%di                ;"
     "           cmp $0x0, %%al                ;"
     "           jne loop%=                    ;"
     " halt%=:                                 ;"
     "           hlt                           ;"
     "           jmp halt%=                    ;"
     " msg%=:                                  ;"
     "           .string \"Hello World\"       ;"
     "leave%=:                                 ;"
     :
     :  [vid] "n"  (VIDEO_MEMORY >> 4) 
     );

#endif

  #define VIDEO_ATTRIBUTE 0X02
  
  
  __asm__ volatile
    (
     "           mov %[vid] , %%ax             ;"
     "           mov %%ax, %%ds                ;"
     "           mov  $0x0, %%ax               ;"
     "           mov  $0x0, %%di               ;"
     "           mov  $0x0, %%bx               ;"
     " loop%=:                                 ;"
     "           movb %%es:msg%=(%%di), %%al   ;"
     "           cmp $0x0, %%al                ;"
     "           je halt%=                     ;"
     "           movb %%al,  (%%bx,%%di)       ;"
     "           inc %%bx                      ;"
     "           movb %[attr], (%%bx,%%di)     ;"
     "           inc %%di                      ;"
     "           mov %%bx, %%di                ;"
     "           jmp loop%=                    ;"
     " halt%=:                                 ;"
     "           hlt                           ;"
     "           jmp halt%=                    ;"
     " msg%=:                                  ;"
     "           .string \"Hello World\"       ;"
     :
     :  [vid]  "n"  (VIDEO_MEMORY >> 4),
	[attr] "n"  (VIDEO_ATTRIBUTE)
     );


  return 0;
}
