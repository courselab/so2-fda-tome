/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

const char msg[];

int __attribute__((naked, fastcall)) puts(const char*);

int main()
{
  puts(msg);
  return 0;
}

const char msg[] = "Hello World" ;

int __attribute__((naked, fastcall)) puts(const char *s)
{
  __asm__
    (
"        mov %cx, %si            \n"
"        mov $0x0, %bx           \n"
"        mov $0xb800, %ax        \n"
"        mov %ax, %es            \n"
"loop:                           \n"
"        mov (%si), %al          \n"
"        cmp $0x0, %al           \n"
"        je end                  \n"
"        movb %al, %es:(%bx)     \n"
"        movb $0x20, %es:1(%bx)  \n"
"        add $2, %bx             \n"
"        add $1, %si             \n"
"        jmp loop                \n"
"end: ;"
"        mov %si, %ax;"            /* Return status in AX.            */
"        ret"

     );
}
