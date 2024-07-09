dnl    SPDX-FileCopyrightText: 2024 Monaco F. J. <monaco@usp.br>
dnl   
dnl    SPDX-License-Identifier: GPL-3.0-or-later
dnl
dnl    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

include(docm4.m4)

 SysQuiz - A few quick questios.
 ==============================

 Some questions for your answer based on your knowledge of system software.
 Please, answer the questions in the file NOTEBOOK.

 DOCM4_INSTRUCTIONS

 Challenge
 ------------------------------

 Tip: Taking a look at the './Makefile' may be instructive.

 * p1.c      Explain the results.

   	     Build p1: make p1
		   
	     Execute it a few times and explain the results.
	     What is the rationale for this behavior.


 * p2.c	     Fix design vulnerability.

   	     Refer to p2.c and understand how the program works.

   	     Build p2: make p2

	     Execute the program and enter the correct input to pass the
	     verification check.

	     Then, rerun p2 and, when prompted, enter: youshallnotpass.
	     
	     Explain the result and identify the design flaw that led to the
	     vulnerability. Discuss possible modifications to make the program
	     more robust.

	     Now, rebuild the original p2 with

	        make CFLAGS=-fstack-protector p2

	     Test the program with the same string and see what happens.

	     Tip: yes, the compiler protects the stack with a canary but, as
	     you may have noticed, no stack smash seems to be detected. What
	     else happened and why, exactly, the program's behavior changed?

 * p3	     Explain the function calls.

   	     Check p3.c and build p3 with: make p3.

	     Disassemble p3:  make p3/d

	     Locate the function 'main' (search for <main>).
	     For GCC vr. 11.4.0 the output is like this. Yours may vary
	     slightly if your GCC version is not the same but should not
	     be too different:

	      0804918d <main>:
	      804918d:       55                push   %ebp
 	      804918e:       89 e5             mov    %esp,%ebp
 	      8049190:       83 e4 f0          and    $0xfffffff0,%esp
	      8049193:       e8 07 00 00 00    call   804919f <foo>
	      8049198:       b8 00 00 00 00    mov    $0x0,%eax
	      804919d:       c9                leave  
	      804919e:       c3                ret    

 	      0804919f <foo>:
 	      804919f:       55                push   %ebp
 	      80491a0:       89 e5             mov    %esp,%ebp
 	      80491a2:       83 ec 18          sub    $0x18,%esp
 	      80491a5:       8b 45 08          mov    0x8(%ebp),%eax
 	      80491a8:       83 c0 01          add    $0x1,%eax
 	      80491ab:       83 ec 0c          sub    $0xc,%esp
 	      80491ae:       50                push   %eax
 	      80491af:       e8 eb ff ff ff    call   804919f <bar>
 	      80491b4:       83 c4 10          add    $0x10,%esp
 	      80491b7:       89 45 f4          mov    %eax,-0xc(%ebp)
 	      80491ba:       8b 45 f4          mov    -0xc(%ebp),%eax
 	      80491bd:       c9                leave  
 	      80491be:       c3                ret    

	      080491bf <bar>:
 	      80491bf:       55                push   %ebp
 	      80491c0:       89 e5             mov    %esp,%ebp
 	      80491c2:       83 ec 10          sub    $0x10,%esp
 	      80491c5:       8b 45 08          mov    0x8(%ebp),%eax
 	      80491c8:       83 c0 01          add    $0x1,%eax
 	      80491cb:       89 45 fc          mov    %eax,-0x4(%ebp)
 	      80491ce:       8b 45 fc          mov    -0x4(%ebp),%eax
 	      80491d1:       c9                leave  
 	      80491d2:       c3                ret    

	     Examine the functions 'main', 'foo' and 'bar'.

	     a) Locate the line where 'foo' calls 'bar' and explain how the
	     	caller passes the parameter to the callee. In your answer,
		clarify the concepts of calling convention and application
		binary interface.

	     b) How 'bar' returns its result to 'foo'? How does the answer
	     	related to what you discussed in item (a)?

	     c) Explain what is the purpose of the first two instruction and
	     	the second-to-last instruction of the function 'foo'. What does
		it have to do with what you explained in item (a)?

	     d) What is the purpose of the third line in both functions 'foo'
	     	and 'bar' and what does it have to do with the x86 ABI? Does it
		serve the same purpose than the third line of 'main'?

             e) In the source code, change the return type of 'bar' to 'char'.
	     	Rebuild p3 and examine the difference in the disassembly of
		'foo'. Explain what the compiler did and, based on your answer,
		discuss why the declaration of 'foo' and 'bar' before 'main'
		are useful. 

 * p4	     How libraries work.

   	     Examine the source code of program 'p4.c' and see that all it does
	     it to call the function 'foo', implemented in the custom library
	     'libp4', which, in turn, is available in both static and dynamic
	     versions.


	     The 'Makefile' in this directory provides three forms of building
	     'p4': passing all objects explicitly to the link editor; passing
	     the static library; and passing the dynamic library. You can build
	     all three versions by running, respectively

	        make p4-v1
		make p4-v2
		make p4-v3

	     Compare the tree version with respect to the following aspects.

	     a) Execute each program and comment the results.
	     
	     b) Compare the size of all programs and explain the differences.
	     
	     c) Inspect all the programs with 'nm <program>' and discuss the
	     	differences in when and how the symbols 'foo' and 'bar' are
		listed. Tip, read the 'man page' of 'nm' and interpret the
		letters in the second column.

	     d) Inspect all the programs with 'readelf -d <program>' and discuss
	     	the differences in the library information. How the 'Shared
		library' field is used by the kernel when 'p4-v3' is loaded?

	     e) Discuss the pros and cons of both static and dynamic libraries
	     	in scenarios such as a) the executable program should be
		installed in other hosts; b) the library is updated; c) the
		library should be used by many different programs running in
		the same host.

 DOCM4_EXERCISE_DIRECTIONS
 
 DOCM4_BINTOOLS_DOC

