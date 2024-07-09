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

 BARE-METAL HELLO WORLD
 ==============================

 This directory contains a series of code examples that illustrate the
 step-by-step implementation of a bare-metal "Hello World" program,
 intended for the x86 platform, which can be booted and executed on
 a real piece of hardware supporting BIOS legacy boot mode.

 The sequence starts as simple as a program written directly in machine
 code, which is then rewritten in pure assembly, and finally translated
 into C language.


DOCM4_INSTRUCTIONS

 Contents
 ------------------------------


 Take a look at the following examples, preferably in the suggested order.
 

 * eg-00.hex	    Hello World in bare-metal machine code.
 
   		    This is a wild, old-school version of the classical
		    Hello World program, implemented directly in machine code.
		    No compiler, no library, no operating system, not even
		    assembly; only the bare-bone instruction opcodes and
		    arguments. The program should be loaded by the computer's
		    BIOS upon initialization, using the legacy boot mode.

		    The implementation uses the instructions (in hexadecimal)

		      b4  imm8	       move the next byte to register AL
		      b0  imm8	       move the next byte to register AH
		      cd  imm8	       issues the given BIOS interrupt
		      eb  rel8	       jump short to the relative offset
		      f4  	       halt the CPU

		    The program issues BIOS interrupts (opcode 0xCD) to access
		    the BIOS video service (0x10), one character at a time.
		    The video service expects the video mode to be set by
		    register %ah, and the ASCII code of the character to be
		    written in %al. By the end, the program halts. Just for
		    the case the CPU 'unhalts' (yes, it may happen), there
		    is a final jump that goes back to the halt instruction. 

		    The source code is an ASCII file containing the opcodes of
		    the program in hexadecimal representation. In order to
		    generate the bootable file, we need to transform the source
		    into a binary file, by converting each string representing
		    and opcode into the corresponding numerical value.
		    The file has 512 bytes and the boot signature 0xaa55
		    occupies the last two bytes of the file. Remember, x86 is
		    a little-endian, two's complement CPU architecture.

		    E.g. the opcode 'b4' in eg-00.hex should become the byte
		    '10110100' (decimal value 180) in eg-00.bin. Implementing
		    such an hex-to-binary conversion program is a no-brainer;
		    there is an example in tools/hex2bin.c.
		    
		    Build the example using the simple hex-to-binary converter:

		       make eg-00.bin

		    Test with the emulator

 		       make eg-00.bin/run

		    Transfer eg-00.bin to a USB sick 

		       make eg-00.bin/stick <your-device e.g. /dev/sdb>

		    and boot it in the real PC hardware. If it does not work,
		    please refer to "Note on booting the real hardware" ahead
		    in this document.

		    Note: if you want to rewrite eg-00.hex from the scratch, you
		    can get a 512-byte text file filled with 0s by doing

		    	for ((i=50; i<=512; i++)); do echo 0; done >> hello.hex

 * eg-00-r1.hex	    The same as eg-00.hex, but handling VBR-oriented BIOSes.

		    Some BIOSes assume the the boot media contains a volume
		    boot record (VBR) entry (i.e. that the media is formatted
		    as FAT file system). This being the case, the former program
		    may not boot or, even worse, it may indeed boot, but then
   		    execute with errors.

		    This is example is provided to handle such idiosyncratic
		    BIOSes. It works around the problem by adding some bytes
		    just before our executable code so as to fake the BIOS
		    into identifying a BPB (BIOS parameter block), which should
		    exist in a FAT-formatted disk. Apropos, the dummy BPB is
		    sequence of bytes starting with 0xeb 0x3c --- which is a
		    jump instruction leading to the start of the actual hello
		    world program.

   		    See eg-01-r1.asm for further details.

 * eg-00-r2.hex	    The same as eg-00-r1.hex, but with a valid BPB.

   		    There has been no reports about eg-00-r1.hex failing to boot.
		    Just for the case, though, this is an alternative version
		    of eg-00-r1.hex with a valid BPB.

   		    See eg-01-r2.asm for further details.


 * eg-01.asm        The same as eg-00.hex, but now in assembly code.

   		    This program implements literally the same algorithm as
		    eg-01.hex, but written in assembly code. Assembly code is
		    also informally referred to as asm code. We then use
		    an assembler, NASM, to build the binary from the asm code.
		    NASM uses the Intel assembly syntax.

		    Compare eg-01.bin and eg-02-beta.1.bin, by disassembling
		    them with

		      make eg-00.bin/16i
		      make eg-01.bin/16i

                    or, alternatively, with the graphical diff tool

		      make i16 eg-00.bin eg-01.bin

		    and see that the resulting object codes match. We may thus
		    conclude that we would have being able to write an ad hoc
		    assembler that does the same thing for this program. Not
		    bad, ah?

		    We are forcing the disassembler to interpret the object
		    as code for a i8086 (16-bit) CPU, using intel asm syntax.

 * eg-01-r1.asm	    The same as eg-01.asm, but handling VBR-oriented BIOSes.

   		    Try this if your eg-01.bin works as expected with the
		    emulator, but not with the physical hardware.

		    This is the same problem addressed by eg-00-r1.hex.

		    See the notes in eg-01-r1.asm for further explanation.

 * eg-01-r2.asm	    The same as eg-01-r1.asm, but with a valid BPB.

   		    Like eg-00-r2.hex, but in assembly.

 * eg-02-alpha.asm  A variation of eg-01.asm, using a loop.

   		    This code does not work. Can you spot the problem?

 * eg-02-beta.asm   Same as eg-02-alpha.asm, but fixed.

  		    Now that we are dealing with memory references, we must
		    beware of the program load address. In this example, we
		    handle this by manually adding the offset in the code where
		    needed.

 * eg-02-beta-r1    Same as eg-02-beta.asm, but using a macro.

   		    Alternative way to manually add the load-address offset.
		    
 * eg-02.asm	    Same as eg-02-beta.2.asm, but using the 'org' directive.

   		    The more elegant and systematic way to handle the
		    load-address offset.

   		    The directive 'org' causes all labels to be offset so as
		    to match the position where BIOS loads the program.
		    
		    Compare eg-02-beta.bin and eg-02.bin with

		      make eg-02-beta.bin/i16 
		      make eg-02.bin/i16

		    or

		      make i16 eg-02-beta.bin eg-02.bin
  		    
		    and see that the resulting object codes match. Yep, if we
		    were to write our ad hoc assembler, implementing the org
		    directive would not be a problem.

		    Now it's opportune to observe that NASM is performing
		    both the assembling (object code generation) and
		    linking (build-time address relocation) steps. Strictly
		    speaking, one might argue that calling NASM an assembler
		    is not very precise; it might well be referred to an
		    assembler/linker tool.


* eg-03-beta.S      Like eg-02.asm, but translated into AT&T assembly syntax.

  		    One motivation to convert the assembly source code from
		    Intel to AT&T syntax is because we intend to rewrite
		    the running example in C language.  To that end, we will
		    use the powerful and flexible GNU build chain, including
		    the compiler, assembler and linker. The thing is, the GNU
		    build toolchain speaks AT&T asm and does not understand
		    NASM's intel asm very well. In order to fully explore the
		    GNU build toolchain, we'd better translate our code from
		    Intel to AT&T syntax (moreover, being assembly-polyglot
		    is a useful skill when reading tutorials and documentation
		    material).

		    See note (2) for a more detailed explanation.

   		    The translation was made as literal as possible so as to
		    facilitate the comparison with eg-04.asm.

		    A noteworthy observation is that the build procedure of
		    this example involves two steps: assembling and linking.
		    The former translates assembly to object (machine) code,
		    and the latter remaps offsets to match the load address.
		    Those are the normal duties of, respectively, the assembler
		    and the linker. With NASM, which we had been using
		    previously, those two functions are performed by the same
		    program.

		    In the GNU build toolchain, differently, those duties are
		    performed by two distinct programs: the assembler (GAS,
		    whose executable program name is 'as') converts assembly
		    to object code (machine code), and then the linker (ld)
		    is used to remap the addresses offset so as to match the
		    load address. GAS does not have an equivalent for the
		    '.org' directive that we used with NASM for this purpose.
		    Instead, we must inform the linker directly via a command
		    line argument.

		    While we had instructed NASM to produce a flat binary,
		    the version of GAS installed in our x86 / x86_64
		    platform outputs binaries in ELF format --- a structured
		    executable format that has much more than the executable
		    code itself (e.g. the file contains a header with meta
		    data about the program and other information that the OS
		    uses to load and execute the program). In our case, we have
		    a bare-metal program and don't want the extra information.
		    We have, thus, to instruct the linker to strip all extra
		    sections and output a flat binary. We tell ld to do that
		    by using another command-line option.

		    Finally, ld let us specify which will be the entry point
		    of the executable. This would be important for structured
		    file formats such as ELF (Linux) or PE (windows). For
		    us, it's the first byte. However, since ld dos expect it,
		    we pass this information in yet another command-line option.


 * eg-03.S	    Same as before, but with standard entry-point name.

   		    This example is to illustrate that the default symbol name
		    for the entry point is _start. If we stick to it, we do
		    not need to pass it as an option for to the linker. 

		    Alternative:

		    Issuing the build rule with the command-line variable
		    ALT=1 selects an alternative recipe using a single GCC 
		    invocation (GCC then invokes the assembler and the linker
		    with appropriate arguments).

		    Disassemble (AT&T syntax, i8080 cpu) with 

		      make eg-02.bin/a16 
		      make eg-03.bin/a16

		      or

  		      make a16 eg-02.bin eg-03.bin 
		      
		    and see that both binaries match, i.e. the output of
		    both assemblers (NASM and GAS) are the same.


 * eg-04-alpha.c   Like eg-03.S but rewritten in C and inline assembly (buggy).

   		    We use basic inline assembly. GCC should copy the asm code
                    as is to the output.  The two function-like macros
		    are expanded by the pre-processor during build time.

		    Caveats:

                    We declared the function with attribute 'naked' to prevent
                    GCC from generating extra asm code which is not relevant
                    here and may be omitted for readability. See comments
                    in the source file.

		    Yes, the program does not build. The assembler fails because
		    q

		    Notice that the string is placed before the executable code.
		    Since the flat-binary code will be executed from the very first
		    byte (BIOS will assure so) the program will not work. 

		    Notice also that even if we move the string  to some place
		    after the executable code, the string is still allocated in
		    the read-only data section. This is also a problem because
		    the labels are offsets relative to the start of the section
		    where they are defined, and this the string label won't be
		    correctly accessible from within the .text section.

 * eg-04-beta.c	    Like eg-04-alpha.c, but the string is moved to the end.

   		    Observe the ad hoc tactic (aka plain hack) we used to work
		    around the compiler's default policy to allocate the
		    string in the .rodata section.


 * eg-04-beta.1.c    Like eg-04-beta, but with asm code in a header file.

  		    Now the source looks a bit more like a C code.
  		    

 * eg-04.c	    Like eg-04-beta-1.c, but using a linker script.

   		    The provided eg-04.ld script handles several issues:

   		    - merge .rodata into .text section

		    as well as

   		    - add the the boot signature        
   		    - convert from elf to binary         
   		    - set load address                  
   		    - set entry point


		    The first feature frees our code from the hack on .rodata
		    problem, and the latter four simplify ld command-line options.


		    Compare eg-03.bin and eg-04.bin with

		    	make a16 eg-03.bin eg-04.bin

                    Both object codes are almost a perfect match.

		    Bearing in mind that, since there is possibly more than
		    one way to implement the behavior specified by the C
		    source code into assembly form, it is not guaranteed
		    that both the handwritten eg-03.bin and the GCC-produced
		    eg-04.bin will match.
		    
		    Indeed if we inspect the disassembled objects, we may see
		    that GCC added a few extra instructions after the code.
		    Those are no-operation (NOP) and undefined (UD2)
		    instructions that are inserted by the compiler as a
		    security measure to assert that code is not executed
		    past the end of the legit code.  The appended
		    instructions however cause the string to be moved some
		    positions away from its original place in eg-03.S.
		    This is reflected in some other parts of the code.
		    

 * eg-05.c	    A rewrite of eg-04.c replacing macros with actual functions.

   		    This code introduces a new form of addressing memory in
		    AT&T syntax. See note (3) for the rationales.

		    Moreover, remember that when a function calls another
		    function, the caller needs to save the address to where
		    callee must return to after its execution completes.
		    The call instruction pushes the return address onto
		    the stack. The top of the stack is pointed to by register
		    SP. Up to now we have tacitly assumed that, when our 
		    program starts, the value left in SP by the BIOS is a good
		    one. The rationale for this guess is that the BIOS itself
		    uses the stack and it must have already initialized SP.
		    That is a hopeful bet, though. The right thing to do is
		    to explicitly initialize the stack.

		    To initialize the stack, we use a function-like macro
		    that expands into an inline asm statement. Just remember
		    that we can't implement it as a function because, well,
		    we would need an initialized tack to call functions.

		    This macro must be placed right at the beginning of
		    the function _start() before we call any other function
		    or interrupt calls.

		    Note: we elected __start() as the entry point of our
		    program. Technically, the function is not "called"
		    by any other function and, therefore, there's no
		    problem if SP is only initialized by __start() itself.
		    Also, our function halt() never returns; it just halts
		    the computer (this is not how conventional programs
		    end; we're simplifying things for now).

 * eg-06.c 	    Using a runtime initializer.

   		    To make our program look like a bit more like a regular
		    C program, we moved _start() to another compilation
		    unit named rt0. In conventional C runtime  such as in
		    Linux and Windows, _start() (usually implemented by
		    the object file greet0.o) calls main(), working as both
		    the entry point and the place where main() returns to
		    after completion.

		    See file eg-06.c for further details.		    


 * eg-07.c	    Our real C-looking program.

   		    The example is similar to eg-06 but with some changes.

		    - We replaced the asm rt0 with a C version
		      (just'cause we can).
		    
		    - We defined the stack address in the linker script as a
		      macro and used the macro in rt0. This way we can control
		      the stack from the linker rather than having to modify
		      the program should we change our mind. It's just a
		      convenience.

		    - We used the linker script also to prepend rt0 to the
		      main program. This way we don't need to explicitly pass
		      the object as argument to the linker at the command line.
		      That gives the build procedure a look-and-feel more akin
		      to what we are conventionally used to.

		    - We renamed write_str() and call it puts(), the name of
		      the well-known function specified by the standard C
		      library. Moreover, we implemented puts fully compatible
		      with the ISO-C API, which determines that, on success

		      	   int puts (const char *p)

		      return the number of characters written.

		      Under the fastcall calling convention (as well as under
		      the default conventions employed by Linux and Windows),
		      the callee pass the return status to the caller using
		      the register %ax.

		    - We dismissed the attribute 'naked' with main(). This will
		      not prevent the compiler from adding a few extra
		      instructions in the assembly --- which, although not
		      strictly need, causes no harm either --- but also let us
		      use the regular 'return' keyword in main().

   		    See comments in the file.

  * eg-08.c 	    Finally our masterpiece: a Hello World that looks exactly
    		    like the legendary Kernighan & Ritchie's one.

    		    In this example we have just defined a printf macro that
		    actually calls puts. The function is not compatible with
		    the standard C's API (because printf does much more than
		    writing into the standard output), but it suffices to
		    reproduce original K&H's "Hello world".

		    Notice that, contrary to eg-07.h, we don't declare printf
		    in our own header. Instead, we just include the regular
		    stdio.h header provided by the standard C library (glibc).

		    Also, we don't need to pass the object containing the
		    puts() implementation (eg-08_utils.o). Instead, we
		    use the linker script that does it silently, not unlike
		    what happens when gcc quietly links hosted programs
		    against the standard libc.

		    You can see this in action by doing 

		       make eg-08.bin

		    to create all the files, then removing eg-08.bin with

		       rm eg-08.bin

		    and finally issuing the make command with the option

		       make ALT=1 eg-08.bin

		    The gcc command-line specifies only the options required
		    by a stand-alone bare-metal program, plus the linker
		    script. The runtime initializer (rt0) and our custom
		    "libc" are handled by the linker script.

		    Not bad, eh?


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
       described in El-Torito specification [2]. 

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



 (2)  One reason we had better switch from NASM to GAS  assembly here is
      because GCC (the compiler) and NASM (the assembler) do not go that well
      together. GCC speaks AT&T assembly by default, while NASM spekas Intel
      assembly. True, GCC is actually capable of outputing Intel assembly
      if asked to. The problem is that GCC's Intel syntax is in a different
      dialect than the Intel syntax understood by NSAM (i.e. the same syntax
      but different dialects; assembly is not standardized, as usually are
      the high-level programming languages). GCC's Intel dialect is meant
      for the GNU Assembler (GAS) and contains, for instance, directives that
      are understood by GAS, but not by NASM. As an example, 'bit 16' in
      NASM's dialect translates into '.code 16') in GAS dialect; data type
      'dw' in NASM becomes 'word' in GAS; GAS supports instructions with
      argument-size suffixes ('movb' loads one byte into the register, while
      'movl' loads 4 bites into the register). Also, and importantly, GAS does
      not understand the 'org' directive, since GAS is strictly an assembler,
      and leaves static address relocation for the linker.

      A glimpse of those differences may be seen in egx-01.S.

      It's therefore not practical to ask GCC to generate intel assembly
      from C, and have the latter assembled by NASM (we would need to manually
      modify the code). We'd better use GAS, instead (and that would be our
      choice, anyway, since we want to explore the GNU build chain). 

 (3)  Previously, we would do
		    
      		    AT&T syntax			Intel syntax

      		    msg(%si)			[msg + si]


      to iterate through the characters of the string located at msg, using bx
      as the index of the array.

      Now, rather than constant labeled position, our string may be anywhere
      and we pass it to the function as an address stored in %cx. The thing
      is, we can't do

      Now, we don't have a label to reference the string. Instead, the
      write_str() function receives the parameter in register %cx (because
      the function attribute specify the fastcall calling convention).
      The thing is, we can't do this

		    AT&T syntax			Intel syntax

		    %cx(%bx)			[cx + bx]
		    
      Why not? Because the i8086 (16-bit precursos of x86) does not allow us to.
      The way to traverse an array here is by using the base-index-scale

		  base address + index array * scale

      E.g.

		   (%bx, %si, 1)

      is the memory position starting from the base address %bx, advancing
      %si * 1 positions. The scale factor is helpful if we want to consider
      %si the index of a vector whose elements spans multiple bytes. For
      instance, if %bx is the base of an integer vector, we can deference
      the 3rd element by doing

      	           mov 3, %si
      	      	   mov (%bx, %si, 4), %ax

      We can omit the scale factor if it's equal to 1.

      So, in our example, can we do

		  (%cx, %si)

       No.

       Real-mode x86 allow us limited choices

	     	   (%bx), (%bp), (%si), (%di),

	           (%bx,%si), (%bx,%di), (%bp,%si) and (%bp,%di)


        We had than to first copy %cx to %bx,
	
	(Do the respective names "base register" for %bx and "source  index 
	register" for si ring you a bell?)

	Do I really need to know all of this??? 

	"Hump... know this you must, for intricate and deceptive the hardware
	may be... and fighting the darkness you shall, to bring consistency
	and balance where there would be only chaos and fear."

 (4) Extend asm

     Program egx-03.c is similar to eg-05.c but uses GCC's extended assembly.

     Extended assembly augment the standard inline assembly functionality
     with several advanced features that may be quite useful. It's possible to

     	  - rerence the C-program's variables from within the inline asm code;
	  - automatically create labels that are unique across the entire
	    compilation (formally, translation) unit
	  - make GCC aware of which registers your inline asm has modified,
	    so as to avoid conflics with the remaing C code

      To exemplify, notice the line

          : b (s)

      in file egx-03.c. It tells the compiler that we want the value in local
      variable 's' (the function argument) to be stored in register %bx.
      (because later on we intend to use %bx to reference the string).
      To fulfill our requirement, the compiler adds some assembly code to
      copy %cx into %bx (remember, fastcall calling convention says that the
      first argument is passed by the caller to the callee in register %cx)

          mov %ecx, %edx
	  mov %edx, %bx

      We don't need to do that manually as in eg-05.c (standard asm).

      Incidentally, observe that the disassembled code shows the name of
      the 32-bit registers %ecx and %edx instead of the respective 16-bit 
      registers %cx and %dx. This is because the compiler decided to use the
      instruction 0x89 for the mov operation. Normally, instruction 0x89
      manipulate the 32-bit registers, but notice that the opcode is preceded by
      the value 0x66. That is called an operand-size prefix, and its effect
      is to modify the operand size of the following instruction (yep, there's
      this too). See note 5 for more on instruction prefix.  
      
      You may compare eg-05.bin (asm) and egx-03.bin (extended asm) with

         make a16 eg-05.bin egx-03.bin

      Because of the operand prefix, some corresponding lines are offset
      in the second program, as we can see in the disassembled code.
      
      Test eg-06.bin:

          make egx-03.bin/run

      Finally, notice that in extended asm GCC is allowed to optmize output. We used
      the volatile keyword with extended asm to prevent optimization. Even so,
      there may be changes made by the compiler. If you want to be sure that your
      inline assembly goes untouched to the compiler output, do not use extended
      asm. Rather, stick to the standard asm.


 (5) Instruction prefix

     Some x86 instructions may be prefixed with certain bytes. If present, the
     prefix modifies the original behavior of the instruction.

     For instance, 0x66 before a mov instruction changes the size of the
     operand: if the instruction normally manipulate a 32-bit value, the 0x66
     prefix, named operand-size override, causes the instruction to operate with
     a 16-bit operand. The reverse is also true: if the mov instruction would
     operate with 16-bit registers, it now operates with 32-bit. There are
     several kind of prefixes which change operand and addresses sizes, override
     segment registers and perform other modifications.

     If you disassemble eg-06.bin with

        make egx-03.bin/a16

     you'll see two mov instructions prefixed with 0x66. Moreover, the assembly
     output will read

     	mov %ecx, %edx
	mov %edx, %ebx

     This is because the command is telling the disassemble to assume a 16-bit
     and in such an architecture, the operand prefix has no meaning (the
     instruction still works because the real-mode in a modern x86 hardware
     is actually an emulation, and 32-bit instructions still work. For some
     reason only GCC-gurus will reveal to you, the compiler opted to use a
     0x66-prefixed 32-bit mov.

     If you otherwise disassemble the program with

       make egx-03.bin/a32

     instead, you are asking the disassemble to assume that the cpu is 32-bit,
     and the disassembler will honor the prefix, showing

       mov %cx, %dx
       mov %dx, %bx

     Now, the disassemble knows that the instruction will operate on %cx and %dx.
 
DOCM4_BINTOOLS_DOC

DOCM4_BOOT_NOTE

 References
 ------------------------------
 
 [1] Auxiliary program: syseg/src/hex2bin

 [2] El-Torito: https://wiki.osdev.org/El-Torito




