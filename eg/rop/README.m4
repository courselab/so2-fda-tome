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

 Return-oriented programming
 ==============================

 This directory contains a sereis of source code examples illustrating
 the security exploit based on buffer overflow. The programs exercises
 the knowledge on the x86 ABI, and also offer some hints on why 
 POSIX.1-2008 marks gets() obsolescent, and  ISO C11 removes the
 specification of gets() from the C  language.
 

dnl
dnl Uncomment to include docm4 instructions
dnl
dnl DOCM4_INSTRUCTIONS

 Contents
 ------------------------------

 To better appreciate the following examples, it's useful to have a basic
 knowledge of the x86 calling convention, particularly of the CDCL, and
 be able to understand how the functions' prologue and epilogue work to
 handle the stack frame. The series of examples in syseg/eg/abi may be
 worth of a review.


 * eg-01.c	A very simple program to illustrate local variable storage.

   		This program uses a statically allocated array to hold a
		4-character buffer. As we can see in the disassembled code

		  make eg-01
		  make eg-01/main

                The array is allocated in the stack by way of the instruction

		    sub 0x4,%esp

                which reserve 4 bytes of memory.

		The contents of the array are then stored in positions relative
		to the register %ebp (the top of the stack frame).

		To make the code easy to read and understand, we purposely
		disabled some default features of the compiler. Particularly,
		we prevented it from emitting extra code for improved stack
		manipulation. The program still runs, but execution is less
		optimal and less secure, as we'll see ahead.

		
 * eg-02.c	Similar to eg-01, but make stack alignment visible.

   		The code is almost identical to eg-01.c, but now we create
		an array of 5 bytes.

		    make eg-02/main

		The noteworthy difference in the result is that, unlike in
		the case of a 4-byte array, the register %esp is decremented
		by 8 rather than by the 5 bytes needed to contain the 5-byte
		array.

		We used the same compilation options, though.

		What happens is that, in order to honor the stack alignment
		laid down by the x86 ABI, the compiler allocates the stack
		within boundaries of fixed size. In the present case, we
		used a command-line option to cause gcc to align the stack
		with 4-byte boundaries.  Therefore, while for a 4-byte array
		an exact 4-byte allocation is ok, now for a 5-byte array we
		need 8 positions.

		See that the extra space in the stack is not used.
		The contents of the array are stored in the top 5 positions
		of the reserved 8-byte stack region.


 * eg-03.c	Identical to eg-02, but using the default stack alignment.

   		In this example we omitted the compiler option
		
		    -mpreferred-stack-boundary=2

   		GCC then defaults to the x86's preferred 16-bit stack
		alignment.

		   make eg-03/main

 * eg-04.c	Like eg-03, but with an undetected buffer overrun.

   		Disassemble the program

		   make eg-04/main

                and see that, a[5] overwrites the saved stack frame pointer
		(the value of ebp saved in the stack).

		The program still executes, mostly because the lost of the
		stack frame is not felt in such a small program; had it
		happened in more sophisticated a chain of nested functions,
		the problem would more likely to manifest.

 * eg-05.c	Identical to eg-04, but with stack canary.

   		A 'stack canary' is so metaphorically called in allusion to
		the birds that miners used to bring underground as safety
		means; birds will be the first to exhibit the signs of bad
		air quality.

		The canary here is some extra code added by the compiler,
		which is here used because we omitted the gcc option

		      -fno-stack-protector.

		Try to execute the program and compare to eg-05.

		Then, disassemble the program with

		    make eg-05/main


		There are several details worthy of being highlighted in
		this example.

		First, notice that after the function prologue, %esp has its
		rightmost 4 bits zeroed

		    11b0: 83 e4 f0  and    $0xfffffff0,%esp

		what makes the value in %esp a multiple of 16. This is the
		stack alignment in effect.

		    The reason why it did not appear in the previous examples
		    is something for which I could not find a good
		    explanation as yet. With some other examples I've tried,
		    it seems that enabling and disabling -fno-stack-protector
		    has some effect on whether the stack alignment code is
		    emitted or not.
		
		See then that the contents of the array are stored  not in the
		topmost positions of the 16-byte reserved block of the stack,
		like in eg-04, which referred to those addresses as offsets
		relative to %ebp. Rather, in the present example, the compiler
		referred to the array positions as offsets relative to %esp,
		which is pointing to somewhere 16 or more positions bellow
		%ebp (we say 16 or more because %esp was first aligned-down to
		the 16-bit boundary, and then decremented by 0x10).

		We don't now exactly where is %esp right now relatively to
		%ebp, but we know that the array contents are placed starting
		at the offset 7 from %esp.  In the worst case, if %esp is
		16 bytes bellow %ebp, the array content, had we honored the
		declared size of 5 chars, would end at offset 11 (0xb) from %esp.

		This would leave at least 4 extra remaining positions before
		reaching the value of %ebp saved in the stack.

		Now, observe that the program stores a value in these
		remaining bytes, specifically

		   11b6:	65 a1 14 00 00 00    	mov    %gs:0x14,%eax
    		   11bc:	89 44 24 0c          	mov    %eax,0xc(%esp)

		The value is obtained from the memory location %gs:0x14.
		In Linux, this memory location points to thread-local data,
		and and contain some random value.

		Why so? Because, later on, before leaving the function,
		the program checks to see if this value is unchanged.
		If a buffer overrun occurs, and the canary value is
		overwritten, the program calls a function

		   11e5:	8b 54 24 0c          	mov    0xc(%esp),%edx
    		   11e9:	65 33 15 14 00 00 00 	xor    %gs:0x14,%edx
		   11f0:	74 05                	je     11f7 <main+0x4a>
    		   11f2:	e8 fc ff ff ff       	call   11f3 <main+0x46>
    		   11f7:	c9                   	leave  
    		   11f8:	c3                   	ret    

		If we inspect the program's relocation table with

		   readelf -r eg-05

		we'll see that

		000011f3  00000202 R_386_PC32  00000000   __stack_chk_fail@GLIBC_2.4

		which tells the dynamic linker to replace the instruction call's
		argument with the address of the given libc function when
		the program is loaded (the series of examples in syseg/eg/run
		approaches relocation and dynamic linking).

		In the present example, the value stored in a[5] overwrites
		the canary code. 

   
 * eg-06.c	Similar to eg-05, but we bypass the stack canary.

   		Notice that we've deliberately skipped the stack position where
		the compiler stores the canary. Now the program dos not detect
		the overflow. This is not a very useful program, but it
		illustrates the protection limitations.

		Often, buffer overruns result from sequential, rather than randon,
		write operations, like reading data from a file or I/O device,
		and therefore the examined stack protection mechanism usually works.

 * eg-07.c 	Similar to eg-06, this example overwrites the return address.

   		At this point, it must have become clear that, if we write
		past the end of the array limit, we may reach other regions
		of the stack beyond the area reserved for the array. We may
		for instance, overwrite the saved stack frame pointer (ebp), or
		if we advance 4 bytes more, we may even overwrite the function's
		return address.

		And this is the basis of the so called return-oriented-programming
		(ROP), a class of security exploits that target programs
		with stack-frame vulnerabilities.

		This particular program was handcrafted to overwrite the return
		address directly, by carefully locating its position relatively
		to the array start (it's thus more of an inside sabotage than
		of an external security attack; the example is however suitable
		to address some aspects of buffer-overflow vulnerabilities).

		In the example we replaced the return address with the bogus
		value 0x42424242. When the function returns, it actually
		branches to that address, causing a memory segmentation fault,
		a.k.a a segfault.

		We can confirm the return address with the aid of GDB:

		   gdb eg-07
		   run            (you should get a segmentation fault signal)
		   info registers

		   eip            0x42424242          0x42424242   
		

		Incidentally, how did we figured out the return address on the
		stack in the first place?

		Well, it's not easy. Although we can disassemble the program
		and see the size of the stack reserved by the compiler, the
		array elements are addressed as offsets relatively to %esp,
		and we don't know how much %esp was shifted to meet the stack
		alignment constraint.

		In this example we determined the return address' location
		in the stack by inspecting the CPU registers with the program
		in execution.

		Using GDB, we set a break point at the line where the array
		position a[0] is modified, then we executed the program and
		inspect the registers

		   gdb eg-07
		   break 30     (a[0]='H', in the current program's version)
		   run
		   info registers

		   eax            0x0                 0
		   ecx            0xf6cc9dae          -154362450
		   edx            0xffffd094          -12140
		   ebx            0x0                 0
		   esp            0xffffd050          0xffffd050
		   ebp            0xffffd068          0xffffd068
		   esi            0xf7fa0000          -134610944
		   edi            0xf7fa0000          -134610944
		   eip            0x565561c2          0x565561c2 <main+21>
		   eflags         0x246               [ PF ZF IF ]
		   cs             0x23                35
		   ss             0x2b                43
		   ds             0x2b                43
		   es             0x2b                43
		   fs             0x0                 0
		   gs             0x63                99


		Let's interpret this result.

		Upon entering the function main(), the program pushes %ebp
		onto the stack: %esp points now to the top of the stack.
		Then we copy this value into %ebp: the value in %ebp is then
		the top of the stack at that moment. We know then that the
		return address is 4 bytes over %ebp:

		       return address = %ebp       + 4 =
		       
		       	      	      = 0xffffd068 + 4
				      
				      = 0xffffd06c

		That's a useful piece of information. However, from our C
		source code, we can only refer to positions in the stack
q		indirectly, through the address of the array.

		By inspecting the disassembly, we see that the array starts at

		      a = 0x7(%esp) = 0xffffd050 + 7 = 0xffffd057

		To reach the return address we must thus access

		      delta = (%ebp + 4bytes) - (%esp + 7bytes)
		      
		            =      0xffffd06c - 0xffffd057

			    =      21

	        That's why we wrote a[21] through a[24].



 * eg-08.c	Like eg-07, but we return to a function.

   		This is not a very useful program, but it's suitable to
		explore some aspects of buffer-overflow vulnerabilities.

		Like in eg-07, we manually overwrite the main function's
		return address (again more of a sabotage than and attack;
		we shall get to the latter soon). 

		Here we overwrite the return address with the address of
		a function.

		Notice that we ended foo() by calling exit(); otherwise foo()
		would try to return to the caller by popping the return
		address from the stack --- but we've not not actually called
		this function (using the 'call' instruction).

		To test this program, proceed as follows:

		   make eg-08
		   setarch $(uname -m) -R ./eg-08

		You should see the string sent to the standard output,
		because we forced foo() to be called upon the main's return.

		In this example, we invoked the program indirectly through the
		setarch utility. Why was that?

		First, try to execute the program directly at the terminal
		prompt:

		   ./eg-08

		You should get a segmentation fault. That is because Linux
		implement Address Space Layout Randomization (ASLR) as a
		measure to make it more difficult for buffer-overflow attacks.

		Basically, when the program is loaded, the kernel places the
		different program sections at positions that are randomly
		shifted across multiple executions. We therefore miss the
		jump to foo().

		The utility setarch may be used to disable ASLR for a specific
		process (command line option -R).

		Incidental, if you try to execute eg-08 with GDB

		   gdb eg-08
		   run

		the program will execute as we intended. That's because GDB,
		by default, disables ASLR. You may force GDB to honor
		randomization through

		  gdb eg-08
		  set disable-randomization off
		  run

               If you look at foo disassembly across multiple runs

	          gdb
		  set disable-randomization off
		  run
		  disass foo
		  run
		  disass foo


	       you may see how the address of foo changes (compare with the
	       execution with

	       
	          gdb
		  set disable-randomization on
		  run
		  disass foo
		  run
		  disass foo


	       Along with stack protection, address space layout randomization
	       makes stack-overflow attacks not that easy.


 * eg-00.c     A very simple example of a buffer-overflow attack.

   	       This program reads the user's credential through the standard
	       input and checks it against a user database. If the credentials
	       match, the user is granted access; otherwise the program
	       terminates.

   	       The vulnerability of the program is due to the naive use of
	       the scanf() function to store the input into a buffer. In order
	       to expose the breach we compiled the program without stack
	       protection.

	       Try to execute the program and enter as password a single
	       string of 1 to 9 consecutive non-blank characers such as

	       abcdefghij


	       Then, repeat the experiment with 10 consecutive non-blank
	       characers such as

	       abcdefghijk

	       and compare the result.

 * eg-00a.c    Identical to eg-00, compiled with stack protection.

   	       The stack vulnerabolity is not present anymore.
	       Observe that, in addtion to the canary, the compiler allocated
	       the local integer variable below the array, such that an
	       overflow attack canot happen.
	       

 * eg-09.c     A shellcode injection exploit.

   	       This example illustrate an external buffer-overflow attack
	       with shellcode ijection.  In this kind of exploit we
	       overrrun the buffer as before, but rewrite the function's
	       return address such that it points back to the stack. In
	       the stack we write the machine code implementing some
	       program we want to run.

	       To test the program, proceed as follows.

	          make eg-09
		  ./eg-09

               The program asks the user's names and echoes a greeting message.

	       Now, execute the program within GDB , set a break point at the
	       function main and run

	          gdb eg-09
		  break main
		  run

	       When the program stops at the break point, disassemble it

	          disassemble

               Right after the prologue we can see the instruction sub
	       reserving 512 bytes in the stack. We can confirm that this space
	       is meant for a local buffer by observing that 0x200(%ebp) is
	       pushed onto the stack as an argument for the Libc's read()
	       function. 

	       To implement the exploid we need to write 512 bytes, plus 8 more
	       bytes: 4 to overwrite %ebp, and the next 4 to overwite the
	       return address. Instead of entering all those bytes via keyboard,
	       we'll redirect the program's standard input to a file, and put
	       everything we need within that file.
	       
	       The input file, which we named eg-09in, should contain:

	            the shellcode we want to execute
	            the return address poiting to the shellcode
		    some padding bytes to make the file 520 byte long
  
	       As for the shell code, we'll use the program eg-09S, that
	       should output a message into the standard output. While not a
	       particularly interesting exploit, the program suffices to
	       illustrate the mechanism.  See the shellcode's source for
	       details.

			You can build the shellcode as an independent ELF
			program and execute it at the shell prompt to
			see how it works:

			make eg-09.elf
			./eg-09.elf
		

	       We could well start eg-09in with the shellcode. A more common
	       approach, though, is to start the input file with a sequence of
	       NOP instruction. This way the return address does not need to
	       aim precisely at the shell code; if it lands onto the sequence
	       of NOPs, the execution flow will continue and eventually reache
	       the injected program.  The leading NOP instructions are known
	       as NOP sled.

	       In order to build eg-09.in

	         make eg-09.in

	       The Makefile rule uses the script eg-09sh to create the input
	       file, whose layout is

	          NOP Sled
		  Shellcode
		  Padding
		  Return address

	       Refer to the source to see how eg-09in is built.

	       With the break point at main(), re-run the program within GDB
	       using the command

	          run < eg-09.in

	       When the program stops at the break point, check %ebp

	          print $ebp

	       The return address start 4 bytes on top of it:
	       
	          x/x $ebp+4
		  0xffffd06c:	0xf7dcfed5

	       and to see where the return from main lands

	          disassemble  0xf7dcfed5

	       We should see that it returns to the Libc's start function
	       (the start function is part of the C runtime).

	       We can also see the array in the stack:

	          x/512x $esp

	       Anyway, let's move on.

	       Set another break point at printf() and continue:

	          break printf
		  cont

	       When the program stops, check the stack

	          x/512x $ebp

		and now we see the NOPs (opcode 0x90) we entered,
		and amid them, there is the exploit payload, i.e.
		the shellcode.

		At the upper part (higher address) of the NOP sequence there
		lies the NOP sled, and at the very bottom (lower address)
		there is the return address. Observe that the address point
		to somewhere at the NOP sled.

		You may verify if the return address is in the right position
		in the tack by checking

		   x/x $ebp+4

		Now, continue the program until the end:

		   cont

		And we should see the output of the shellcode.

		If you want to try with other paylods, you may write your
		own shellcode or search for some interesting program at [1].

		Notice:  we had to compile the program with gcc's -z stackezec
		         option. Also, GDB disables Address Space Laouyt
			 Randomization (ASLR) by default.



		RELESE NOTICE

		This example works within GDB. Outside the debugger, the
		program crashes with an illegal instruction message:

		   setarch $(uname -m) -R ./eg-11 < eg-09in

		Figuring out what is wrong is left as an exercise (which is
		another way of saying that if you can come up with a didactic
		explanation, you're welcome to contribute).

REFERENCES

[1] Shell storm, http://www.shell-storm.org/shellcode/
		

		

dnl
dnl Uncomment to include bintools instructions
dnl 
DOCM4_BINTOOLS_DOC

