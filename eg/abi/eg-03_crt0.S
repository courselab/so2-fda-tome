#    SPDX-FileCopyrightText: 2001 Monaco F. J. <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

 	 .global _start    
 	 .section .text    

 _start:                 
         call main       
         mov %eax, %ebx  
         mov $1, %eax    
         int $0x80       
  
