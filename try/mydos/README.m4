dnl    SPDX-FileCopyrightText: 2024 Monaco F. J. <monaco@usp.br>
dnl   
dnl    SPDX-License-Identifier: GPL-3.0-or-later
dnl
dnl    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

include(docm4.m4)

 myDOS -  myDOS
 ==============================

 This programming exercise consists of extending the example tyDOS, provided
 under the directory 'eg/tydos'. The source code illustrates a DOS-like
 program that runs in x86 real-mode. TyDOS already implements a trivial
 command-line interpreter that can execute built-in functions.

 The present challenge is to improve the interpreter such that, if the user
 enters the name of an executable file, the interpreter searches for the file
 in the storage media from which the kernel was booted, loads it, and executes
 it to completion (returning thus the prompt of the command-line interpreter).

 The example also implements a syscall handler, which the user program can
 invoke to request OS services. Rather than issuing the syscall directly,
 though, the programmer can take advantage of a small custom user library that
 should then be linked against the executable.
 
 For the purpose of illustration, the project comes with a user program example
 that is statically linked to the kernel, such that it is automatically loaded
 by the bootloader. We want to extend the example to load the program, given its
 name, from a formatted storage media --- what implies implementing support for
 the media's file system.

 To help with this, the example tyFS, found in 'eg/tyfs' introduces a trivial
 file system that should be very easy to understand and implement.

 The programming exercise can thus be summarizing as adding the support for tyFS
 to the kernel, and extending the command-line interpreter to locate a file
 by name, load and execute it.

 Directions
 ------------------------------

 This directory contains a copy of TyDOS source code.

 Proceed as indicated in the 'Directions for the exercise' section, further
 ahead, to export the code example into your own project. After that,
 follow the steps below (you'll have to export this directory into your
 own project tree).

 1) Play with tyDOS and tyFS.

    Visit both examples, read the documentation, build and execute some
    experiments to get acquainted with them. 

 2) Build and execute myDOS in this directory.

   make
   make mydos.bin/run

   Try the command 'help' and follow the instructions.

 3) Please, chose an original name for your project.

    Yeah... that. You know, it's a programmer's duty to honor their projects
    with a distinctive name. Do not fail with the venerable traditions.

    At least edit the greeting messages (e.g. the prompt) and, preferably, the
    logo accordingly. You can also edit the variable 'dos' in the 'Makefile'
    and rename source files to match the changes.

 4) Remove the statically linked program.

    Figure out how to edit 'Makefile', 'kernel.c' and 'tydos.ld' such that
    'prog.bin' is not statically linked to 'mydos.ld' (or whatever name you
    have gave to your DOS).

 5) Create a tyfs disk image.

    Add a rule in your 'Makefile' to create a zeroed 1.44M floppy image
    'disk.img' (see 'img' rule in 'eg/tyfs/Makefile).

    Use 'tyfsedit' in 'eg/tyfs' to format it with tyFS, and copy some
    text files into it.

 6) Make the disk image boot your DOS program.

    Add a rule to your 'Makefile' to write 'mydos.bin' into 'disk.img'.
    Remember that you should not overwrite the tyFS header in the disk,
    or else you'll corrupt the file system (see the option 'skip'
    of the utility 'dd'). Also, mind that you must have formatted your
    media with sufficient boot sectors to accommodate your DOS.

 7) Boot your DOS from the disk image.

    Try it with QEMU x86 emulator.

       make mydos.bin/run

    should do it (replace 'mydos' with your DOS name).

 8) Implement a built-in command that lists the contents of the disk.

    Study the source code of 'tyfsedit' and figure out how to implement
    the functionality into your kernel.

    Remember that the FS header is already in RAM (it was loaded by BIOS
    during the boot). You can easily access it using plain C.

    In the header you have all the information to locate the directory
    region. You can then load it (using the BIOS disk service.) into RAM
    and go through and the file names, again, in plain C.
    
 9) Create a loadable user program out of prog.c.

    In tyDOS example, 'prog.o' was directly linked into the kernel and
    we could execute it simply by calling it's 'main' function. That was
    possible because, when 'tydos.bin' was built, the linker could resolve
    the symbol 'main'.

    Now, 'main' is in the user program, and the link-editor does not know
    anything about 'prog' at the time 'mydos.bin' is built.  Try to figure
    out how to handle this new scenario before reading on.

    Ok, that's how OSes do it.

    First, notice that the binary 'prog.bin' is missing the old'n good
    runtime initializer. The tip is: create a file crt0.S where you
    define the symbol '_start' as the very first function and, from there,
    call 'main'. Then, modify 'prog.ld' so that 'crt0.S' is prepended
    to 'prob.bin' (you'll need to update 'Makefile' accordingly).
    
    Since '_start' is guaranteedly the start of 'prob.bin' code, and
    since you know where the kernel has loaded the program, you can
    make a "virtual" call to _start by pushing the return address
    onto the stack and jumping to the program load address; the return
    from main will happily find the address and pop it.

    Note: how to get the return address to push it onto the stack is not
    necessarily obviously. On x86 real mode (and even in 32-bit for that
    matter), you can't read the value of the instruction pointer register
    to know where is the address of the next instruction. The trick, here
    is to call an auxiliary function whose only purpose is to "discover"
    the current execution address. For instance

        (asm code...)
	call get_ip_into_ax  
	(push the return address and jmp to main)
	

      get_ip_into_ax:
        mov (%sp), %ax		# Load %ax with the return address
	ret

    The function 'get_ip_into_ax' is called often called a thunk function.

 10) Implement a new syscall and call it from a new library function.

   Finally, to end with all honor and glory, add a new syscall to your kernel
   that reads the user input from the keryboard. The kernel already has this
   capability and you can reuse it to implement the syscall. See 'bios2.S'
   and 'syscall.c' to see how this is done for 'sys_write'.

   Then, increment the user library 'libtydos.a' by implementing the
   user function

   	void gets(char *buffer)

   that reads the user input and stores it into 'buffer'.

   Now, create a new program 'hello.c' that uses both 'puts' and 'gets' to
   read the user name and print the string "Hello <name>".

   Build, 'hello.bin', copy it into 'disk.img' using 'tyfsedit', boot it with
   the emulator, and execute it from your DOS command-line interpreter.

   Lastly, edit your 'Makefile' to build 'hello.bin'.

   Get a USB stick, copy the disk image into it, and then try to boot and
   run your DOS in the real x86 hardware.

   If you've made it this far, now stop. Rest your hands, take a deep breath.
   Slide your chair away from the desk, lean back, half-close your eyes, and,
   contemplating your creation, acknowledge to yourself: 'Damn, I’m good.'

 DOCM4_EXERCISE_DIRECTIONS
    

 DOCM4_BINTOOLS_DOC

