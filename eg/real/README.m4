dnl    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
dnl   
dnl    SPDX-License-Identifier: GPL-3.0-or-later
dnl
dnl    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
dnl
dnl    >> Usage hint:
dnl
dnl       If you're looking for a file such as README or Makefile, then this one 
dnl       you are reading now is probably not the file you are interested in. This
dnl       and other files named with suffix '.m4' are source files used by SYSeg
dnl       to create the actual documentation files, scripts and other items they
dnl       refer to. If you can't find a corresponding file without the '.m4' name
dnl       extension in this same directory, then chances are that you have missed
dnl       the build instructions in the README file at the top of SYSeg's source
dnl       tree (yep, it's called README for a reason).

include(docm4.m4)

DOCM4_REVIEW

 REAL MODE PROGRAMMING
 ==============================

 This directory contains a series of examples exploring the segmented
 memory model of x86 real-mode.

DOCM4_INSTRUCTIONS

 
 Contents
 ------------------------------


 Take a look at the following examples, preferably in the suggested order.


 * eg-00.S   	    Write a character character on the video display memory

   		    The character is referred to by an immediate value.

 * eg-01_alpha. S   Attempt to write from memory to video display memory

   		    We are gradually taking steps to write a string... but for
		    now, to keep things simple, we're staring with the first
		    character only.

		    We try to address the character as a memory location.
		    
  		    The thing is, this code does not work, though.

		    Take a look at the source and try to spot the problem.

 * eg-01.S	    Like its alpha release, but with the problem fixed.

   		    We use the extra segment register to handle the issue.

 * eg-02.S	    Like eg-01.S, but writing an entire string.

 * eg-02-v2.S	    Like eg-02.S, but with an alternative implementation.

   		    The aim of x86 real-mode is to provide a compatible
		    environment for old programs created for the original
		    16-bit 8086 cpu.

   		    This example takes advantage of the fact that, while the
		    x86 real-mode mimics the 8086 real-mode, e.g. by
		    implementing segmented memory, it does not prevent the
		    program from using 32-bit registers. We can thus
		    access memory beyond the boundaries of the current
		    64K memory segment. This possibility allow us to
		    simplify the assembly in eg-02-v2.S.

		    See the auxiliary examples egx-01.S and egx-02.S mentioned
		    in Notes (2) for a more detailed explanation.

		    Compare eg-02.S and eg-02-v2.S with diff.

  
 * eg-03.c          This is a port of eg-02.S to C.

   		    Note that the function puts() is written entirely in
		    plain C (the only inline asm is not needed if we don't
		    apply the attribute naked; which we only used to make
		    the binary shorter and less complicated).


		    That is possible because writing into RAM is as simple
		    as assigning a value to a variable.

		    Try

		        make eg-03_utils.o/a32

		    and see that the start of the video memory is stored
		    in %si, while %bx is initialized with zero. Later on,
		    the ascii in %edx is moved to (%bx, %si), and then
		    %bx is incremented.

		    In this example we initialize the segment registers
		    and stack pointer in rt0.c.

 * rt0.c	    This is the runtime-zero used by eg-03.c.

   		    It's worth to go through this code because it illustrates
		    the recommended way of initializing the bootloader.

		    The entry function _start performs the initial setup of
		    the segment registers, and then calls main. Then, when
		    main returns, the function halts the cpu (in a program
		    hosted on a POSIX OS, _start would issue the syscall
		    'exit' to the kernel asking it to terminate the process).

		    It's often advisable that the hardware interrupts be
		    disable during the initialization, and that's why the
		    first part of _start() is enclosed between instructions
		    cli and sti. Incidentally, the critical part here is
		    the initialization of %ss and %sp, which should occur
		    atomically (otherwise a hardware interrupt could cause
		    the stack to be used inconsistently). Nonetheless, the
		    specification of instruction that modifies %ss is says
		    that interrupts are disabled during the operation until
		    the completion of the next instruction --- and therefore
		    modifying %sp right after %ss would suffice. We are
		    using cli/sti anyway, as most references suggest.

		    The first thing we do after disabling interrupts is to
		    canonicalize %cs:%ip. That is advisable because we don't
		    know for what the BIOS left in those registers. As we know,
		    the boot program is loaded at position 0x7c00, which
		    corresponds to the offset 0x7c00 of the segment 0x0.
		    In fact, originally, the BIOSes would load cs=0 and
		    ip=0x7c00, and then jump to the bootloader. However,
		    the load address corresponds to many other segment:offset
		    combinations, including 0x7c00:0x00. And, as always,
		    some BIOS clones do it differently and opt for the
		    second form, sometimes referred as to normalized boot
		    address. For most examples in this series, this should
		    not be a problem, since both 0x7c00:0x00 and 0x0:7c00 point
		    to the same physical position. However, if we need to
		    initialize %ds (to access data), we would better know
		    what is in %cs. Most system-level programmers will
		    recommend initializing %cs:%ip. As we can't simple move
		    random values into %ip, the usual way to accomplish this
		    is performing a long jump to the next position. While
		    the near jump simply lands to somewhere in the same
		    segment (modifying thus %ip), the far jump modifies the
		    segment register before the leaping, so that it can
		    reach another segment.

		    With %cs:%ip set, we zero the data and extra registers,
		    as well as %ss:%sp pair.




 Notes
 ------------------------------

 (1)   Original PC's BIOS used to read the MBR from the first 512 bytes of
       either the floppy or hard disks. Later on, when CD-ROM technology
       came about, it brought a different specification for the boot
       information, described in the iso9960 (the conventional CD file system
       format). Vendors then updated the BIOSes to detect whether the storage
       is either a floppy (or HD) or a CD-ROM, and apply the appropriate boot
       procedure. More recently, when USB flash devices were introduced, the
       approach adopted by BIOS vendors was not to specify a new boot procedure,
       but to emulate  some of the former devices. The problem is that this
       choice is not very consistent: some BIOSes would detect a USB stick as
       a floppy, whereas other BIOSes would see it as a CD (welcome to the
       system layer!).

       If your BIOS mimics the original PC, to make a bootable USB stick
       all you need to do is to copy the MBR code to its first 512 bytes:


   	  make stick IMG=foo.bin STICK=/dev/sdX


       On the other hand, if your BIOS insists in detecting your USB stick
       as a CD-ROM, you'll need to prepare a bootable iso9660 image as
       described in El-Torito specification [1]. 

       As for that, the GNU xorriso utility may come in handy: it prepares a
       bootable USP stick which should work in both scenarios. Xorriso copies
       the MBR code to the first 512 bytes to the USB stick and, in addition,
       it also transfer a prepared iso9660 to the right location. If you can't
       get your BIOS to boot and execute the example with the above (floppy)
       method, then try

         make stick IMG=foo.iso STICK=/dev/sdX


       We wont cover iso9660 El-Torito boot for CD-ROM, as newer x86-based
       computers now offers the Unified Extensible Firmware Interface meant
       to replace the BIOS interface of the original PC.  EFI is capable
       of decoding a format device, allowing the MBR code to be read from a
       standard file system. Although EFI is gradually turning original PC
       boot obsolete, however, most present day BIOSes offer a so called
       "legacy mode BIOS" and its useful to understand more sophisticated
       technologies, as low-level boot is still often found in legacy
       hardware and embedded systems.


  (2)   Original 8086 was a 16-bit cpu implementing segmented memory.         
        Modern x86 are powered by x86 processors which have 32-bit            
        registers (or 64-bit for x86_64) and implement protected mode.        
        In protected mode, memory is not segmented. For compatibility         
        with older programs, though, the x86 will boot in real-mode.          
        x86 real-mode tries to mimic original 8086 real-mode, e.g. by         
        implementing segment memory: a pair of valid segment and offset       
        register will point to a linear memory address given by               
        segment * 10h + offset.

        A caveat in in order, in that x86 real mode does not prevent          
        the program from using 32-bit registers. That is, it is possible      
        and ligitimate to do                                                  
                                                                              
                mov $2, %ebx                                                  
                                                                              
        The assembly will prefix the mov instruction opcode with a            
        operand override prefix (0x66) which causes the instruction           
        to operate with 16 rather than 32-bit. Moreover, the cpu won't        
        forbid the program from doing                                         
                                                                              
                mov $2, (%ebx)                                                
                                                                              
        As expected in real-mode segmented memory, this will load $2          
        in the memory position %ds:%ebx. The noteworth detail here            
        is that %ebx can contain a value grater than 0xffff, i.e.             
        we can have an offset of more than 64K (with %bx we can not).         
                                                                              
        Therefore, rather than loading $b800 in %es, to access the            
        video display memory, we can simply load 0xb8000 in %ebx              
        and that is it.

	You can compare both approaches with
	    
	    meld egx-01.S egx-02.S

	and then
	    
	    make a16 egx-01.bin egx-02.bin


DOCM4_BINTOOLS_DOC


