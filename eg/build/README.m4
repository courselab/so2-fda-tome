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

 BUILD PROCESS
 ==============================

 This directory contains a series of examples illustrating the process
 by which a program is transformed from its source into its executable form,
 aka the build process.

DOCM4_INSTRUCTIONS

 Contents
 ------------------------------

 Take a look at the following examples.



 * eg-01.c          Very simple program to exemplify the build steps.

   		    In this example, we'll use

		      make eg-01.i           to produce the preprocessed source
		      make eg-01.s           to produce the assembly
		      make eg-01.o	     to produce the object code
		      make eg-01	     to produce the binary

		      less eg-01.s	     to inspect the assembly
		      make eg-01.o/diss      to disassemble the object
		      make eg-01/diss        to disassemble the executable

		    a) THE PREPROCESSOR

		    Inspect the preprocessed source file with

		       cat eg-01.i

		    and observe that the macros have ben resolved.

		    b) THE COMPILER

		    Next, inspect the assembly source with

		       cat eg-01.s

 		    and see how the compiler divides the code in sections. In
 		    this assembly source, the executable code goes into section
 		    .text, while the constant string goes into section
	     
 		     .rodata (read-only data).

		    It's interesting to observe how the compiler translate the
		    programming language (in this case, C) into assembly. See
		    that the semantic of a function definition translates into
		    a label, followed by the function code, and by a return
		    instruction. The functional call, then, translates into an
		    instruction 'call'. The 'call' instruction is a kind of
		    jump, and the compiler annotates that the jump should
		    land at the label position.

		    Notice also that the compiler add yet another section:

		      .note.GNU-stack

		    whose purpose is not of interest here, but we mention just
		    to point out that the assembly code may have several
		    compiler-dependent sections.

		    c) THE ASSEMBLER
		     
		    Let's now see what the assembler does with this assembly:

		       make eg-01.o/d

		       6: e8 fc ff ff ff       	

		    Notice the argument of the 'call' instruction. This
		    function takes a 32-bit value as an offset relative to the
		    next instruction. What is this value (remember, two's
		    complement, little endian value)? It's not the address of
		    the function.

		    Well, consider this. 

		    The assembler processes the input line by line, from the
		    start to the end of the file. It may happen, as in the
		    example, that the function 'foo' is defined past the
		    point where it is called --- if so, then, when the assembler
		    reaches the line with the call instruction, it has not
		    found the label  ´foo' yet, and thus does not know how
		    to calculate the offset for the call. Not only that, but
		    the definition of 'foo' might well be in a different source
		    file --- we can't tell the offset between the call and the
		    actual function until both object files have been assembled
		    and concatenated.
		    
		    In face of those possibilities, it may sound more practical
		    to postpone the computation of the call offset until there
		    is sufficient information. And that's what the assembler
		    actually does. It writes a dummy value as the argument of
		    the call instruction, and hand over the responsibility to
		    the next tool in the build chain: the linker.

		    Only after the object is built, the linker can compute the
		    offset between the call instruction and the function it is
		    pointing to.  'Symbol' is how we call variable and function
		    names; and so we say that the linker will resolve the
		    pending symbols.

		    To that end, the linker must able to find the symbol 'foo'.
		    Cleverly, the assembly annotates this piece of information
		    in a special section called symbol table.
		    
		    You can check this table with

		       readelf -s eg-01.o

		    The output should have several lines, including

		       Symbol table '.symtab' contains 6 entries:
		       
		          Num:    Value  Size Type    Bind   Vis      Ndx Name
     			    3: 00000000     4 OBJECT  GLOBAL DEFAULT    3 msg
     			    4: 00000000    18 FUNC    GLOBAL DEFAULT    1 main
     			    5: 00000012     6 FUNC    GLOBAL DEFAULT    1 foo

 		    The last line informs about the symbol 'foo' (last column).
		    The column 'Value' says that the symbol was found by the
		    assembler at the position 0x12 from the beginning of the
		    section which contains it. We already know by experience
		    that 'foo' must be in section '.text', but the symbol table
		    has the answer in the column 'Ndx': it says that  'foo' is
		    in the first section of the object.
		    
		    We can list all the sections in the object with

		       readelf -S eg-01.o


		       Section Headers:
		         [Nr] Name              Off    Size   
			 [ 0]                   000000 000000 
  			 [ 1] .text             000034 000018 
  			 [ 2] .rel.text         0000f8 000008 
  			 [ 3] .data             00004c 000004 
  			 [ 4] .rel.data         000100 000008 
  			 [ 5] .bss              000050 000000 
  			 [ 6] .rodata           000050 000004 
  			 [ 7] .comment          000054 00002c 
  			 [ 8] .note.GNU-stack   000080 000000 
  			 [ 9] .symtab           000080 000060 
  			 [10] .strtab           0000e0 000016 
  			 [11] .shstrtab         000108 000055 
			 
                   (some columns were omitted as they are not relevant now)

 		   The output shows that section 1 (that contains 'foo') is
 		   the '.text' section: it starts at offset 0x34 from the
 		   beginning of the file and occupies 0x18 bytes.

		   In summary, the sections list says that section .texts
		   starts at offset 0x34 and the symbol table says that 'foo'
		   is 0x12 bytes after that: 'foo' is then at the absolute
		   position 0x36+0x12 = 0x45 (70 in decimal).

		   You may 'make eg-01.o/d', take note of the binary content
		   of 'foo' and then 'make eg-02.o/hex' to see if the
		   sequence can be found at 0x45.
		     
		   So far so good, we know where to find 'foo'. Now we need
		   to go back to that call that was left unfinished and replace
		   the dummy argument with the actual offset to 'foo'.

		   But where is it again? 

		   Ta-da! Once more, the assembler gets us covered!

		   There is another section in the object file, called
		   relocation table, where we can get the information from:

		      readelf -r eg-01.o

                   whose output should contain a line like this:

		        Offset     Info    Type            Sym.Value  Sym. Name
		        00000007  00000502 R_386_PC32      00000012   foo

		   This line says that, once we know the address of 'foo', the
		   linker should overwrite the (dummy) 32-bit address (column
		   'Type') at the offset 0x7 (column 'Offset') with the offset
		   to 'foo' address.

		   d) THE LINKER

		   Start by disassembling the binary

		      make eg-01/d

                   and analyze the output:


		   0000118d <main>:
    		      118d: 55                 push   %ebp
    		      118e: 89 e5              mov    %esp,%ebp
    		      1190: 83 e4 f0           and    $0xfffffff0,%esp
    		      1193: e8 07 00 00 00     call   119f <foo>
    		      1198: b8 0a 00 00 00     mov    $0xa,%eax
    		      119d: c9                 leave  
    		      119e: c3                 ret    

		   0000119f <foo>:
    		      119f: 55                 push   %ebp
    		      11a0: 89 e5              mov    %esp,%ebp
    		      11a2: 90                 nop
    		      11a3: 5d                 pop    %ebp
    		      11a4: c3                 ret

		    See that the call instruction at position 0x1193 in main
		    now has the offset 0x7 as it's argument (32-bit little
		    endian). The jump will land at 0x1198+0x7 = 0x1197, that's
		    the address of foo. Done. Symbol resolved.
		    
		    See also the 'foo' is no longer listed when we look at the
		    relocation tables with 'readelf -r eg-01' (actually, we
		    don't see section '.text.rel' in the binary, but other
		    different relocation sections that are of more interest in
		    the context of program loading).

		    Try
			readelf -S eg-01

	            and see that some of sections of the object file are not
	            present in the binary (executable) file, and vice versa.

		    The linker is the component of the build chain that defines
		    final format of the executable program. If the program is
		    made of several object files, the linker will concatenate o
		    objects and combine their sections (e.g., merging '.text'
		    sections). The linker decides which sections of the object
		    will go into the binary executable and in which order. It
		    is possible to control this behavior using a linker script,
		    as exemplified in 'eg/hw'.
		    
 * eg-02.c	    A C program containing one single compilation unity.

		    Build and execute the binary, and then check the return
		    status with.

		      echo $?

 * eg-03-alpha.c    Same as eg-02.c, but implementing functions after main().

		    Build the binary. You should see a warning about 
		    implicit function declarations.

 * eg-03.c	    Same as eg-03l-alpha, but with function declarations
   		    before main().

		    Build the binary and see that the issue is fixed.

 * eg-04.c	    Same as eg-03.c, but with declarations in a separate
   		    header file.

		    File eg-04.h is provided.
		    
		    Build the proprocessing translated unity with

 		       make eg-04.i

		    and compare with the source eg-02.c to see that the
		    processor directives have been resolved.

 * eg-05.c	    A program to illustrate the translation units

   		    Source eg-05.c calls an external function, which is
		    declared in eg-07.h.

		    Build the translation unit eg-05.i with

		       make eg-05.i

		    and inspect its contents with 'cat' to verify the
		    inclusions were resolved and macros have been expanded.


 * eg-06.c	    Like eg-03.c, but split into several translation units

   		    Build eg-06 with

		      make eg-06

		    and see the intermediate build steps which invoke the
		    preprocessor, compiler, assembler and linker.

		    Then build with

		      make eg-06 ALT=1

                    and see that this time we build the objects, create
		    a static library and then build the binary by linking
		    its object against the library
		    
		    Yet, build with
 
		      make eg-06 ALT=2


		    This time, libeg-06.a includes another object file, baz.o,
		    defining the symbol baz.

		    Run


		    meld <(make clean && make eg-06 ALT=1 && nm libeg-06.a) \
		         <(make clean && make eg-06 ALT=2 && nm libeg-06.a)

	            to compare both libraries.  Then, run

		    meld <(make clean && make eg-06 ALT=1 && nm eg-06) \
		         <(make clean && make eg-06 ALT=2 && nm eg-06)
		    

                    and see that baz is not included in the binary.

		    Also, compare the disassembly to make it sure
		    
		    meld <(make clean && make eg-06 ALT=1 && objdump -d eg-06)\
		         <(make clean && make eg-06 ALT=2 && objdump -d eg-06)

		    
DOCM4_BINTOOLS_DOC
