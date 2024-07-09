/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

const char msg[]  = "Hello world";

void __attribute__((naked)) _start()   
{


__asm__(
"        mov   $0x0e,%ah               \n"
"        mov   $0x0, %si               \n"
"loop:                                 \n"
"        mov   msg(%si), %al           \n"
"        cmp   $0x0, %al               \n"
"        je    halt                    \n"
"        int   $0x10                   \n"
"        add   $0x1, %si               \n"
"        jmp   loop                    \n"
"  halt:                               \n"
"        hlt                           \n"
"        jmp   halt                    \n"
);

}


 

__asm__(".fill 510 - (. - _start), 1, 0");  
__asm__(".byte 0x55, 0xaa");     
