#    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

	.code16
	.global clear, print, println, fatal, load_kernel
	
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
        popa			/* Restore all GP registers.           */
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

	## void fatal(const char* msg)
	##
	## Prints 'msg' and halts.
fatal:
	pusha
	push %cx
	lea fatal_msg, %cx
	call print
	pop %cx
	call println
	call halt
fatal_halt:
	hlt
	jmp fatal_halt
	popa

	## void halt(void)
	##
	## Halts the system

halt:
	hlt
	jmp halt

	## void load_kernel(void)
	##
	## Boot's second stage.

load_kernel:
	pusha			/* Save all GP registers.              */

	/* Compute the kernel size in sectors.  */

	xor %dx, %dx		/* Will divide %dx:%ax by %cx.         */
	mov $_KERNEL_SIZE, %ax	/* Kernel size in bytes (from boot.ld).*/
	mov $512, %cx		/* Disk sector is 512 bytes.           */
	div %cx			/* Integher division.                  */
	add $1, %ax		/* Result in %ax.                      */
	mov %ax, stage2_size	/* Store in RAM for later use.         */

	/* Reset the floppy just for the case.  */

	mov $0x0, %ah		/* BIOS service 0x13: test operation.  */
	mov boot_drive, %dl	/* Select the boot drive (from rt0.o). */
	int $0x13		/* Call BIOS disk service 0x13.        */
	jnc load_kernel_read	/* On error (CF),                      */
	mov $err_reset, %cx	/* load error message and              */
	call fatal		/* report fatal error.                 */

load_kernel_read:
	mov boot_drive, %dl	/* Select the boot drive (from rt0.o). */
	mov $0x2, %ah		/* BIOS disk service: op. read sector. */
	mov stage2_size, %al	/* Number of sectors to read.          */
	mov $0x0, %ch		/* Cylinder coordinate (starts at 0).  */
	mov $0x2, %cl		/* Sector coordinate   (starts at 1).  */
	mov $0x0, %dh		/* Head coordinage     (starts at 0).  */
	mov $_KERNEL_ADDR, %bx	/* Where to load the kernel (rt0.o).   */
	int $0x13		/* Call BIOS disk service 0x13.        */
	mov $err_load, %cx	/* On error (CF), report and halt.     */
	jc fatal

	popa			/* Restore all GP registers.           */
	ret			/* Retur to the caller.                */
	
	
	## 
	## Read-only data
	##
	
	.section .rodata

crlf:
	.byte 0xd, 0x0a, 0x0 	/* CR-FL seqquence.  */
	
fatal_msg:
	.string "Fatal error: "
err_reset:
	.string "Can't reset drive"
err_load:
	.string "Can't load kernel"

	##
	## Read/Write global data
	##
	
	.section .data
	
stage2_size:	
	.byte 0x0		/* Computed by load_kernel.            */
