#    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

	.code16
	.global clear, print, readln, println, strcmp
	
	.section .text

	## void clear(void)
	##
	## Clear the screen.
	
clear:
	pusha			/* Save all GP registers.              */
	mov $0x0600, %ax	/* Video service: scroll up.           */
	mov $0x07, %bh		/* Attribute (background/foreground).  */
	mov $0x00, %cx		/* Upper-left corner:   (0,0).         */
	mov $0x184f, %dx	/* Botton-right corner: (24,79).       */
	int $0x10		/* Call BIOS video service.            */

	mov $0x2, %ah		/* Video service: set cursor position. */
	mov $0x0, %bh		/* Select page number 0.               */
	mov $0x0, %dx		/* Set position (0,0).                 */
	int $0x10		/* Call BIOS video service.            */
	
	popa			/* Restore all GP-registers.           */
	ret

	## void print(const char* msg)
	## 
	## Print 'msg' onto the screen.
	
print:
        pusha			/* Save all GP registers.              */
        mov %cx, %bx		/* Copy argument into base register.   */
	mov $0x0, %si		/* Initialize buffer index.            */
        mov $0x0e, %ah          /* BIOS video service: TTY mode.       */
print_loop:
        mov (%bx, %si), %al	/* Get each ASCII character.           */
        cmp $0x0, %al		/* End writing on 0.                   */
        je print_end
        int $0x10		/* Call BIOS video service.            */
        inc %si			/* Point to the next character.        */
        jmp print_loop
print_end:
        popa
        ret


	## void println(const char* msg)
	##
	## Print 'msg', followed by a CR-LF sequence, onto the screen.
	
println:
	pusha			/* Save all GP registers.              */
	call print		/* Print argument (in %cx).            */
	lea crlf, %cx		
	call print		/* Print a CR-LF sequence.             */
	popa			/* Restore all GP registers.           */
	ret


	## void readln(char *buffer)
	##
	## Reads a CR-terminated line from keyboard into buffer.

	
readln:
	pusha	                /* Save all GP registers.                     */

	mov %cx, %bx		/* Argument received in %cx.                  */
	mov $0x0, %si		/* Initialize buffer index.                   */
	
readln_loop:
	mov $0x0, %ax		/* BIOS keyboard service (blocking read).     */
	int $0x16		/* Call BIOS keyboard service.                */

	cmp $0xb, %si		/* End reading if more than 10 characters.    */
	je readln_trunc

	mov %al, %es:(%bx,%si)	/* Add ASCII to the buffer.                   */
	inc %si			/* Increment the buffer index.                */
	
readln_trunc:	
	mov $0xe, %ah		/* Echo the ascii onto the screen.            */
	int $0x10

	cmp $0xd, %al		/* End reading if character is CR.            */
	je readln_end		
	
	jmp readln_loop		/* Keep reading.                              */
	
readln_end:	
	mov $0xe, %ah		/* Echo a newline.                            */
	mov $0xa, %al
	int $0x10

	movb $0x0, -1(%bx,%si)  /* Remove trailing CR.                        */
	popa			/* Restore all GP registers.                  */
	ret

	## Read-only data
	##
	##
	
	.section .rodata

crlf:
	.byte 0xd, 0x0a, 0x0 	/* CR-FL seqquence.  */

