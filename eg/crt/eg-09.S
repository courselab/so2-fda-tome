#    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

	.code16
	.global main


main:
	mov $msg, %cx
	call puts
	mov $0, %ax
	ret
	
	/* Standard-C like function puts(). */
puts:				

	mov %cx, %si		
	mov $0x0, %bx		
	mov $0xb800, %ax	  
	mov %ax, %es
loop:
	mov (%si), %al
	cmp $0x0, %al
	je end
	movb %al, %es:(%bx)
	movb $0x20, %es:1(%bx)
	add $2, %bx
	add $1, %si	
	jmp loop
end:
	mov %si, %ax		/* Return status in AX.            */
	ret

msg:
	.string "Hello World"
/*

*/
	
