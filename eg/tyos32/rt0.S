#    SPDX-FileCopyrightText: 2001 Monaco F. J. <monaco@usp.br>
#    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

	.code16
	.global _start
	.global drive
	.global size2

	/* Some modern BIOSes expect that the boot media have a MS-DOS
	   compatible VBR (Volume Boot Record) header, typical of 
	   FAT-formatted media, stored at the begining of the first sector.
	   Such BIOSes may either refuse to boot or corrupt the bootstrap 
	   code if a VBR is not present. */
	
_start:	
	jmp code		   /* VBR signature for the case it's expected,*/
	.fill 60, 1 , 0	   	   /* and dummy BPB (BIOS Parameter Block). */

code:	/* Canonicalize segment registers to 0x0:7c00.                    */

	cli                        /* Disable interrupts.                 */
	xor %ax, %ax                 
        mov %ax, %ds               /* Zero data segment.                  */
        mov %ax, %es               /* Zero extra segment.                 */
        mov %ax, %fs               /* Zero extra segment 2.               */
        mov %ax, %gs               /* Zero extra segment 3.               */
        mov %ax, %ss               /* Zero stack segment.                 */
        mov $_END_STACK, %sp       /* Setup stack (from linker script).   */
	mov %dl, drive		   /* Save boot drive number for later.   */
        jmp $0x0,$init0            /* Set memory segment 0 and adjust ip. */ 
init0:                                
        sti                        /* Enable interrupts.                  */
	
     /* Call main. */

        call main                  /* Call main.                 */
halt:                               
        hlt                        /* On return from main, halt. */
        jmp halt               
     

drive:				   
	.byte 0x0		   /* For later use (boot device).        */
size2:				   
	.byte 0x0    		   /* Size of stage2 (in sectors).        */
	
	/* Notes.
	
	 (1) Originally, BIOS would read the first 512-byte sector and
	     and check for a boot signature. Some later BIOSes, however,
	     have decided that they will only boot from a FAT-formatted
	     media. The more nitpicker BIOSes will refuse to boot unless
	     a VBR (volume boot record) signature is found in the first
	     three bytes of the boot sector (which is a jump instruction
	     followed by a NOP instruction). Other BIOSes, even worse,
	     will silently load the sector and execute it... but then
	     they'll feel free to update some fields of the BPB (BIOS 
	     Paramter block) that follows the VBR signature. If the 
	     bootloader code starts at the beginning of the sector, 
	     it risks being overwritten (and consequently corrupted) by 
	     stickler BIOS. To avoid this, we added a VBR signature 
	     and a dummy BPB before the bootstrap code.
	
	 (2) Originally, BIOS would load the bootloader at 0h:7c00h. Some
	     clones, however, decided to load it at 7c00h:0h, which is
	     physically the same memory position, but using a different
	     segment:offset addressing. Not knowing which segment we're in
	     may be a headache, for instance, if we want to know if another
	     given memory position is within our segment or not. For this
	     reason, programmers use to canonicalize the segment to
	     0h:7c00h. Disabling the interrupts is possibly not strictly
	     necessary, as long as ss and sp are loaded in consecutive
	     instructions; it's good practice to disable interrupts though.
	     The way to canonicalize cs:ip is to perform a long jump
	     (the instruction will update both registers).
	
	 (3) To load the second stage, we'll need to tell BIOS which 
	     device the sectors should be read from. Traditionally, a USB
	     stick would be recognized by BIOS as the first floppy disk,
	     internally identified as device 0x0. More recently, however,
	     more and more BIOS implementations detects the USB stick
	     as the first HD, internally identified as device 0x80. Even
	     QEMU seems (?) to have changed this behavior, such that the
	     code examples in syseg that worked until last year had to
	     be modified.
	
	     Fortunately, during the boot BIOS loads the boot device
	     identifier in register DL. This is the only register whose
	     content can be trusted upon (for all the other registers,
	     we can't assume what BIOS left stored). In order to preserve
	     this piece of information until the moment we need it, we
	     save the value in the memory position 'drive'.
	*/
