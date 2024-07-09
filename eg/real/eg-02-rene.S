#    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

.code16

.global _start
_start:

        mov $0xb800, %ax
        mov %ax, %es
        mov $0, %si
        mov $0, %bx
loop:
        mov msg(%si), %al
        cmp $0, %al
        je halt
        movb %al, %es:(%bx)
        movb $0x20, %es:1(%bx)
        inc %si
        add $2, %bx
        jmp loop

halt:
        hlt
        jmp halt

msg:
        .string "Hello World"
