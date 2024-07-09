#    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.


	.code16
	.global readln
	
readln:
        pusha                   /* Save all GP registers.                     */

        mov %cx, %bx            /* Argument received in %cx.                  */
        mov $0x0, %si           /* Initialize buffer index.                   */

readln_loop:
        mov $0x0, %ax           /* BIOS keyboard service (blocking read).     */
        int $0x16               /* Call BIOS keyboard service.                */

        cmp $0xb, %si           /* End reading if more than 10 characters.    */
        je readln_trunc

        mov %al, %es:(%bx,%si)  /* Add ASCII to the buffer.                   */
        inc %si                 /* Increment the buffer index.                */

readln_trunc:
        mov $0xe, %ah           /* Echo the ascii onto the screen.            */
        int $0x10

        cmp $0xd, %al           /* End reading if character is CR.            */
        je readln_end

        jmp readln_loop         /* Keep reading.                              */

readln_end:
        mov $0xe, %ah           /* Echo a newline.                            */
        mov $0xa, %al
        int $0x10

        movb $0x0, -1(%bx,%si)  /* Remove trailing CR.                        */
        popa                    /* Restore all GP registers.                  */
        ret
