#    SPDX-FileCopyrightText: 2001 Monaco F. J. <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

;;;    SPDX-FileCopyrightText: 2001 Monaco F. J. <monaco@usp.br>
;;;   
;;;    SPDX-License-Identifier: GPL-3.0-or-later
;;;
;;;    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

.global main
main:
	mov $4, %eax		/* syscall 4: write  */
	mov $1, %ebx		/* descriptor (stdout)  */
	mov $msg, %ecx		/* Buffer  */
	mov $5, %edx
	int $0x80

	mov $0, %eax
	ret
msg:
	.string "Hello"

	
