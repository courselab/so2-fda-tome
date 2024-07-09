dnl    SPDX-FileCopyrightText: 2024 Monaco F. J. <monaco@usp.br>
dnl   
dnl    SPDX-License-Identifier: GPL-3.0-or-later
dnl
dnl    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

include(docm4.m4)

 tyDOS - Tiny DOS
 ==============================
 
 TyDOS is a very simple code example illustrating the basic workings of a
 (trivial) disk operating system. It is intended to boot from a floppy image
 through the BIOS legacy mode and run in x86 real mode.

 The kernel registers a syscall handler accessible via 'int 0x21' (pretty much
 like some other well-known, industry standard DOSes). Rather than issuing the
 syscall directly, user applications can use the provided custom C library.
 
 Contents
 ------------------------------

 The bootable program:

 * bootloader.c		The bootloader (loads and starts the kernel)
 * kernel.c		Essential kernel code (implements the shell)
 * kaux.c		Extra kernel code (separate for legibility).
 * bios1.S		Low-level procedures used by the bootloader.
 * bios2.S		Low-level procedures used by the kernel.
 * syscall.c		A few system calls implemented by the OS.
 * logo.c		A not that impressive ASCII logo

 User program example:

 * prog.c		An example of an external user program.
 * libtydos.a		A simple C library for user programs (use syscalls).
 * tydos.h		Header file for libtydos.a.
 

 The bootloader implements a singe-stage boot that loads the kernel and calls
 its entry function, which then execute a very simple command-line interpreter.
 User input comprise single-word tokens and are interpreted as built-in
 commands: if the string matches an existing command, the command is executed.
 
 Before calling the shell, the kernel registers a system call handler in the
 IVT (interrupt vector table), to answer to int 0x21. Rather than calling
 the syscall directly, though, user programs can use a custom C library
 ('libtydos.a') that implements a few (currently only one) function.

 Directions
 ------------------------------

1) Build and execute the program:

   make
   make tydos.bin/run

   Try the command 'help' and follow the instructions.

2) Take some time to understand the program source.

   The file 'bootloader.c' implements the single-stage boot in plain C.

   In the bootloader the function 'load_kernel()', if successful, uses
   the BIOS disk services to read a few more disk sectors (containing the
   kernel) from the disk and load them into RAM.

   That function is conveniently written in assembly in the source file
   'bios1.S'. Since the bootloader must fit the 512-byte limit (actually less
   than that), 'bios1.S' contains only the functions that are needed during
   the boot procedure.
   
   After the kernel is loaded, the bootloader calls the the function
   'kmain', which is implemented by the kernel itself.

   The kernel code can be found in the file 'kernel.c', in plain C. Again,
   low-level functions that interact with the BIOS are conveniently coded in
   assembly, in the file 'bios2.C'.
   
   The kernel entry function, 'kernel_init()', performs two main tasks.

   First, it registers an interrupt handler at the IVT to answer to software
   interrupt 0x21 --- meant to be used by user program for issuing syscalls.
   The handler receives the syscall number in '%bx', and the mandatory
   arguments in %ax, %dx and %cx (like in regparm calling convention by GCC).
   The kernel implements a few syscalls in the file 'syscall.c', which can be
   invoked by user programs.

   The bootable program (bootloader + kernel) is linked using the linker script
   'tydos.ld', which takes care of building the flat binary, performing
   static relocation (to mach the load address) and making sure that the
   bootloader fits the first 512 bytes of the binary 'tydos.bin', and that the
   kernel is positioned right after the boot signature.

   The example introduces a very useful feature of the linker script, that is
   the possibility of defining new symbols in addition to those already
   existing in the form of variables and function names in the objects.
   The symbol '_KERNEL_ADDR' in 'tydos.ld' is defined as the address of the
   kernel in the binary file (since it comes after the boot signature, we
   know for sure that the kernel starts at the 513rd byte). Then, symbol
   '_KERNEL_SIZE' is assigned the value of the computed kernel size. The
   kernel size is required by the function 'load_kernel()', that needs to know
   how many disk sectors to read.

   Observe that '_KERNEL_SIZE' is not a variable, nor a function. It is just an
   entry in the object's symbol table. You can see it by running

      $ readelf -s bios1.o
      $ readlef -r bios1.o

   It is a symbol that must be resolved in bios1.o by the linker, as any other
   undefined symbol. In this case, we make it easier for the linker because we
   manually defined it in the linker script itself. The symbol '_END_STACK',
   used by 'rt0.o' is defined through the same scheme.

   The linker scripts also prepends the program with 'rt0.o' (created from
   rt0.S), which performs the basic C runtime initialization, including the
   proper  canonicalization of registers and ensuring that 'boot' is the entry
   function of 'tydos.bin'.

   For simplicity, all functions (except syscalls) are assumed to implement the
   fastcall calling convention, what means that function arguments, if any, are
   passed through registers %cx and %dx, and that return values are passed back
   to caller using register %ax.

   Go through the 'Makefile' script to see how each component is built from its
   source. Consult GCC manual if needed to recall the command-line compiler
   options.

 3) Go through the user program example.

    The program 'prog.c' is provided a user program example. The code looks like
    a regular C program (except that 'main' doesn't receive arguments).

    The program calls the function 'puts', which is implemented in 'libtydos.a',
    a custom C runtime library. Function 'puts' prints a string on the screen,
    and accomplishes its purpose by issuing a syscall.

    For simplicity, the user program is statically linked to 'tydos.bin', such
    that it's loaded by the bootloader during boot. An interesting exercise
    is to extend TyDOS to support some file system, and effectively load
    'prog.bin' from a storage device.


 DOCM4_BINTOOLS_DOC

