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

 C runtime initializer (crt0)
 ==============================

 This directory contains a series of code examples that illustrate the
 step-by-step implementation of a simplified C-runtime instance for a
 bare-metal x86-real mode program (the programs are meant to be loaded
 via the BIOS legacy boot mechanism).  

 The sequence starts as simple as a machine code implementation, and
 gradually introduces the assembler, the linker, the C compiler and
 its preprocessor and other system software concepts. 

 
 DOCM4_INSTRUCTIONS

 Contents
 ------------------------------

 eg-00.hex	A bare-metal hardcore Hello World from syseg/eg/hw.

 		The program invokes the BIOS video service through int 10h
		interrupt for each character, one by one, and then halts.
		The program needs to be exactly 512-byte long and end
		with the sequence 0xAA 0x55, so that it can be recognized
		as a bootable program by the BIOS legacy boot.

		The program is written directly in machine code as a
		sequence of CPU instructions, identified by their opcodes
		and operands, denoted in hexadecimal representation.
		Basically, the program

		  - loads %ah with 0xe to select TTY video service
		  - loads %ax with the ASCII of the character to be printed
		  - issues interrupt 10h to request BIOS video service
		  - repeats the from the second step until the end of string
		  - halts the CPU

		The instructions used in the program are

		   Opcode   operation   argument
		   -------  ---------   ----------
		   b4	    load %ah    1 byte (value to be load)
		   b0       load %ax    1 byte (value to be load)
		   cd       interrupt   1 byte (interrupt number)
		   eb       jump        1 byte (relative offset)
		   f4       halt           -

                The program is a text file. In order to produce the binary
		file that will be loaded in RAM, each two-character token
		must be converted into its corresponding 1-byte value.
		To perform this transformation, the program

		   syseg/tools/hex2bin

                can be utilized (the source code is very simple).

		Build and execute the example it in the emulator with

		   make eg-00.bin/run

		You may also try to write eg-00.bin to an USB stick with

		   dd if=boot.bin of=<your-device>     (see lsblk)

                and boot it in a physical hardware. If everything is ok,
		you should see the string 'Hello World' on the screen.
		Boot legacy mode must be enabled in your computer.
		
                If the program wont work, chances are that your BIOS is not
		implementing the original behavior of the legacy boot procedure.
		Some modern BIOSes assume the media is formatted with a FAT
		file system. Such firmware models may either not boot, or
		corrupt the boot program during execution. In the example
		eg-02.S we come up with a workaround for this problem.

 eg-01.S	The translation of eg-00.hex into assembly.

 		The code is written in the AT&T assembly syntax, native of
		GNU Assembler (GAS).

		The program is a instruction-by-instruction translation of
		the previous example into assembly.

		Build and execute it in the emulator with

		  make eg-01.bin/run

		Observe that eg-00.bin and eg-01.bin are binary-identical.


 eg-02.S	Like eg-01, but instrumented for unorthodox BIOSes.

 		Some annoying BIOSes insist in assuming that the boot media
		is formatted with a FAT file system. In a FAT12 disk, for
		instance, the first sector, called Volume Boot Record (VBR),
		starts with a VBR signature and several data fields that
		contain information about the media and the file system
		(e.g. media characteristics, volume label etc.). If this
		heading information is not present, some BIOSes may either
		refuse to boot or else perform the boot but then corrupt
		the program in RAM.

		The present example includes a dummy VBR header to handle such
		annoying BIOSes.

 		Build the program with

		    make eg-02.bin

                and try to boot it in a physical hardware.

		If it still does not work, chances are that you're BIOS is
		detecting your USB as if it's a CD-ROM instead of a floppy
		or hard disk, as usual. Booting from a CD-ROM is a little
		different from booting from a floppy or an HD. To circumvent
		this problem, use the command

		    make stick IMG=boot.bin DEVICE=<your-device>

                If it still fails, perhaps your BIOS does not support legacy
		boot mode (some recent BIOS don't). Shame on your computer
		manufacturer for having chosen a less capable BIOS.


 * eg-03.S	Write a string using a loop.

   		Instead of manually issuing int 10h for each character
		individually, this more reasonable example uses a loop.

		There is a catch here.

		The previous examples did not reference memory, and therefore
		it did not matter where in RAM the program is loaded. Now,
		if the object file aims at memory position, say, 0x100, the
		loaded program must actually aim at 0x7c00 + 0x100.

		That is why we need to tell the linker where the code will
		be in memory. The linker will then add the offset, when
		appropriate, to each instruction that performs memory access.
		This is sometimes referred to as static-linking relocation,
		or build-time relocation.

		Try first building the example without informing the load
		address:

		   make eg-03-bug.bin

 		and see that it does not even build.
		
		Then, try again building and running the same program, but
		now informing the link where the code will be.

		   make eg-03.bin/run

		To compare both binaries, we can issue

		   make a16 eg-03-bug-2.bin eg-03.bin

		(here, we supply 0x0 as the code address so that the linker
		can build a binary).

		Notice that the memory addresses are fixed.

 * eg-04	Like eg-03.S, but using video display memory.

   		There is a region in RAM starting at 0xb8000 that is shadowed
		by the video display memory. If you write something there,
		you're writing directly into the video memory, i.e. it will
		be displayed on the screen.

		Notice that 0xb8000 is a 18-bit number and can't fit within
		a 16-bit register of the original PC real-mode. Because of this
		design feature, real-mode memory is segmented in 64KB blocks,
		each accessible using a segment:offset indicator. The segment
		registers identifies which block (segment) and the offset
		register identifies the offset from the beginning of the
		respective segment. The pair is converted into a 20-bit memory
		address --- addressable by the PC's 20 address lines --- by
		computing: segment * 0x10 + offset.

		Observe also that the video display memory, at 0xb8000 is
		beyond the boundaries of the current code segment (either we
		are at 0h:7c00h, or at best at 7c00h:0h, a bit closer but
		still away from the video memory).

		In order to access other memory segments, we can use the
		available segment registers (the extra segment ES, in the
		example).

		It's in order to mention that, when accessing msg, it's
		implied that we are actually accessing %ds:msg (data segment).

		We are using %ds to access the string in our current segment,
		and %es to access the video display memory.
		

 * eg-06.S	Like eg-05.S, but canonicalizing segments.

   		Original PC's BIOS used to load the boot program at

		  0x0:0x7c00

		Some BIOS clones, though, decided to use

		  0x7c00:0x0

		Therefore, after the boot, we don't actually know if the
		code, data and other segments are loaded with 0x0, or with
		0x7c00. Consequently we don't know which of the possible
		64K memory block is our current segment.

		It's a good practice, thus, to make a choice. The usual
		approach is to pick segment 0x0.

		In this example we modified function _start to initialize all
		segments. See the comments for further details.

 * eg-07.S	Like eg-06.S, but implement a call to main.

   		This looks like a little bit more as a C program. The _start
		function performs a series of initialization and calls main().

		When main returns, _start() halts the system.

		In a hosted environment (i.e. served by an OS) like Linux or
		Windows, _start() would issue a syscall 'exit' to ask the
		kernel to terminate the process. We don't have a kernel to
		refer to, thus we just halt.

 * eg-08.S	Like eg-07.S but splitting runtime initializer from program.

   		In this example we moved _start() to another source file. By
		doing this, we are separating the body of our program --- that
		implements our application's algorithm --- from the preliminary
		initialization routines that serves only to prepare our program
		to interact with the runtime. This is a common practice in
		modern OSes. When we compile a C program in Linux or Windows,
		the linker automatically prepends a runtime initializer, usually
		called 'C runtime zero', a.k.a crt0, to the binary.

		In a typical C runtime, the _start function in the runtime
		initializer will call the function main() in the user program.
		When main completes, it returns to _start(). In a POSIX system,
		the return status from main is passed to the parent process
		via syscall 'wait'. In our case, we don't have a parent process
		to refer to; we just discard the value.

		In our program, this will have a collateral effect, though.
		
		Now that we have two separate files, the directive that
		we used to make the binary 512-byte in size no longer works
		(because the assembler directive that uses _start to compute
		the program size in the file that contains main() does not
		know anything about _start).

		Instead, we can achieve the same result using a linker script
		that specify how the linker should ensemble the output program.

		Incidentally, see that in the script we already provide some
		information pieces that we had been previously passing at the
		command line. Now we don't need some of those command-line
		options anymore.


 * eg-09.S	Like eg-08 but implementing puts().

   		Now we moved the functionality that writes the string out
		of main() and into a new function puts(). The puts() function
		is specified in the ISO-C API as

		    int puts(const char *str)

                The function will output the null-terminated string 'str' into
		the standard output (usually the terminal). On success, it
		returns the number of characters written; on error, it will
		return the EOF value (usually -1). Our implementation mimics
		this behavior (except that our puts never fails! Oh yeah.)

   		We're passing arguments via %cx and returning status in %ax.
		(his is known as the fastcall calling convention). Our main()
		returns with the return status to _start, like it would in
		typical Linux and Windows C runtimes.

		As a plus, we now use the linker script statement INPUT
		to tell ld to prepend crt0 to our program, such that we
		don't need to pass it in the command-line (like it's done
		in Linux, for instance).

 * eg-10.c	Like eg-10.S, but now in C with inline assembly.

   		The statament __asm__(string_literal) implements the ISO-C
		inline assembly feature. When the compiler finds this
		statement, it copies the string_literal to the assembly
		output verbatim.

		Try the example with

		   make eg-11.bin/run

		It's interesting to observe how a C source code is translated
		into assembly. Take a look, for instance at

		   cat eg-11.s

		and see that both functions, main() and puts() map into
		labels in the assembly. The same is true for the global
		variable msg. A function call 'puts()' in C becomes an
		instruction call aimed at the label 'puts'. The last
		instruction of puts() is a return instruction. That's
		precisely what we have been doing when we were coding
		directly in assembly --- what tell us that we understand
		what the compiler is doing. There's no magic.


		For the moment, ignore all the asm directives (words starting
		with a dot) .file, .align, .size, .type, .ident; they were
		output by GCC to help the assembler but are not strictly
		necessary. We can safely remove them by hand and, if we do
		so, we'll see that the compiler-generated asm is practically
		the same we had previously coded by hand. Cool, eh?

		The only exception is that the compiler decided to split our
		executable code from the literal string:

		           .section .rodata
		    msg:
			   .string
			   .text
		    main:
			   (...)


	        GCC located the string in a read-only section aimed at immutable
		data, and the executable code in a section it called .text.
		There is a third section .note.GNU-stack that will be discarded
		by the linker.

		One issue that comes up is how will the assembler arrange
		the sections in the output. Wee need .text to come before
		.rodata, and therefore we indicted this precedence in the
		linker script:

			.code :
				{
				  eg-10.o (.text .rodata)
				}


		This is telling the linker to output a block (here named .code,
		although it does not matter that much in the example), and put
		in this block the section .text and .rodata of the input file
		eg-10.o. Incidentally, chances are that the linker would output
		the sections in this order anyway, but, you know, better safe
		than sorry.

		Apropos, we haven't explicitly located our handmade asm code
		within a .text section. The linker was smart enough to consider
		that everything is in the same section, and thus put everything
		in the same block in the output.
		
		Other differences that can be noted is that the compiler may
		have added a few extra instructions at the end of function
		puts(). It's typical of GCC to insert a nop (no-operation)
		followed by a ud2 (invalid instruction) such the program is
		prevented from executing code past the end of function in
		case something goes wrong (like a miss-speculated execution
		pipeline, perhaps).

		There is also the .align 4. It so happens that the i386
		architecture was designed to read and write in memory positions
		that are multiple of 4 (because 4 bytes is the size of the CPU's
		register). Reading from positions that are not multiple of 4
		is possible, but less efficient as it requires more CPU cycles.
		It's a performance issue. For instance, reading a 32-bit value
		from position 0, 4 or 8 is faster than reading from positions,
		say, 1, 7 or 12. The .align 4 directive tells the assembler
		to pad the binary with extra bytes such as the symbols
		(variables and functions) land in multiple-of-four positions.
		


 * eg-11.c	Similar to eg-10.c, but puts() is implemented in plain C.

		It's not difficult to mentally follow the way the compiler will
		transform the C code into assembly.

		Function puts() will become a label in the assembly output.

		We are declaring a variable 'i' but the attribute tells the
		compiler to allocate the variable in a given register, rather
		than in memory as usual (we don't actually need this, and only
		did to cause the compiler- generated asm to look more like our
		handmade assembly).

		Function puts() was declared with attribute 'fastcall'. This
		tells the compiler to pass arguments to the function via the
		register %cx. In the loop, we test to see if the value pointed
		by %cx (the address of the string) is zero. If it's not zero,
		we write directly at the video display memory making a C-pointer
		deference.

		Try the code with

		    make eg-11.bin/run

		Check the assembled program eg-11.o with

		    make eg-11.o/a16

		One thing to noticed is that the disassembly makes use of
		the 32-bit registers %eax, %esi etc. instead of the 16-bit
		counterparts %ax, %si etc. This is because the x86 real-mode
		is actually an emulation of a 8086 CPU; the 32-bit registers
		are available. However, notice that the operations that read
		and write to the 32-bit registers is preceded by the byte
		0x66. This is an instruction prefix --- in this case an
		operand-size overwrite. It causes the following instruction
		to handle the operands as if they were 16-bit.

		It's easier to see this if we tell the disassemble to consider
		this program as a 32-bit program:

		    make eg-11.o/a32

		Now we can better appreciate what is going on.

		Particularly, see the line (around line 0x4b) where the
		disassembly output reads

		    mov %edx, (%bx, %si)

		this is where the character is written into the video memory,
		just like we had done manually in the previous example.

 * eg-12.c	Like eg-11.c, but puts() moved to a library file.

   		Our main program now contains only the function main().

 * eg-13.c	A familiar C look & feel.

   		In this program we include the familiar header stdio.h from
		the ISO-C API. This is our implementation of stdio.h, however
		and it only contains the header of puts().

		This time we removed the attribute 'fastcall' from all the
		functions. This will change the way main() passes arguments
		to puts(): now arguments are passed via memory (the stack)
		rather than via registers.

		Also, we added the statement INPUT() in the linker script
		so that we don't need to pass the library at the ld command
		line.

   		
		

dnl
dnl Uncomment to include bintools instructions
dnl 
 DOCM4_BINTOOLS_DOC

