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

 Application binary interface
 ==============================

 This directory contains a series of source code files illustrating the
 concept of file system. Available examples contain programs to manipulate
 the traditional Microsoft's FAT file system --- including utilities
 to format a USB stick and inspect its contents.

 Contents
 ------------------------------

 * mbrinfo		Read file system information from FAT12/16 disk.

   			Build with

			  $ make mbrinfo

			To test the program, one may create a floppy image,
			for instance, with util-linux's mkfat.fat program,
			found in most GNU/Linux distribution

			  $ make fat12-mkfs.img

			and then inspect it with

			  $ ./mbrinfo fat12-mkfs.img


			The program would also work with FAT16 disks.
			

 * mkfat12-beta		Create a FAT12-formatted disk.


			Formatting a disk with FAT12 in practice corresponds
			to writing a few bytes into the disk at appropriate
			places. For FAT12 this involves two steps.

			a) Write a FAT12 header file at the beginning of the
			   first disk sector (aka Boot Sector, BS).

			   The disk sector of a floppy disk is usually 512
			   byte long. The Boot Sector is the first disk sector.

			   The FAT header occupies the first 62 bytes of the BS
			   (as of DOS 4.0 format, including the extended BPB)
			   and contains information about the file system
			   such as the disk sector size, number of disk sectors
			   number of disk sectors per track etc. The header
			   file fat.h in this directory lists all the fields
			   of a FAT12 header.

			   We need to write those 62 bytes starting from the
			   beginning of the first sector.

			b) Write a few bytes at the beginning of each FAT.

			   The BS is called a reserved sector. A FAT12 file
			   system may contain additional reserved sectors.
			   In the present example, we don't need extra
			   sectors and therefore have only the BS in the
			   reserved sectors region.

			   Usually, after the reserved sectors region a
			   FAT12-formatted disk will have a FAT region, within
			   which there is the FAT itself and, optionally
			   (and most frequently) a second FAT used as a backup.


			   Each FAT spans a few disk sectors and may be seeing
			   as a map that tells where in the disk a given file is
			   to be found (in disk's the Data Region.)
	
			   An entry in a FAT12's FAT is a 12-bit map that is
			   associated to a corresponding cluster. The value
			   in the FAT entry tells if the given cluster is 
			   either free, used, reserved or unusable. If a 
			   cluster is in use, its associated entry in the FAT
			   is the number of the next cluster comprising the file,
			   forming thus a linked map.

			   The two first entries have however a special
			   meaning: they codify information about the file
			   system.  In a FAT12 disk, these two entries,
			   comprising 3 bytes, are 

			   0xf0 0xff 0xf0

			   The FAT12 codification may be a bit hard to grasp at
			   a first glance, but the above sequence tells that
			   this is a non-partitioned media.

			   The other data about the file, including its name,
			   size, data of creation etc. are stored in the
			   Root Directory Entry that follow the FAT region.
			   The file content itself is stored in the disk's
			   Data Region, and the end of the disk.

			All we have to do, therefore, is to write a) the FAT
			header at the beginning of the BS, and b) those three bytes
			at the beginning of each FAT.

   			The command

			   $ make mkfat12-beta

			will build the program mkfat12-beta which we can use for
			format a floppy, while the command

   			   $ make fat12.img

			will build a 1.44MB floppy disk image formatted
			with a FAT12 file system.

			One may inspect the image's BS information using the
			provided mbrinfo program:

			   $ ./mbrinfo fat12.img

			It may also be interesting to compare the image with
			that created by the Linux's standard utility mkfs.fat

			   $ make fat12-mkfs
			   $ ./mbrinfo fat12-mkfs.img 
			
                        One may test the disk image:

			   $ sudo losetup -f fat12.img

			should mount the disk image fat12.img. If all goes well,
			the OS should recognize the image as a removable media
			and you should be able to read and write from it as usual.

			You may also transfer the image to an USB stick*:

 			   $ dd if=fat12.img of=<device>

			here, <device> is the USB stick's device e.g. /dev/sdb.
			You should be able to plug the sick into any PC with a
			FAT-capable OS and use it as usual.

			(*) Note: data in the USB stick will be lost!

			Alternatively, one can use mkfat12 to format the stick
			directly by doing

			   $ ./mkfat12 <device>
			   
			The image fat12.img is bootable (see the source for
			more comments on this). The bootstrap code just halts
			the system, though.

			To replace the bootstrap code one may use the command

			   $ make fat12-boot.img

			This will build fat12.img and use the (GNU core utils)
			utility dd to insert a custom bootstrap program directly
			into the disk image's BS (we reuse a program we have
			developed in another example series).  The original
			fat12.img is preserved and a new file fat12-boot.img is
			created.

			To test it, one may mount the image as aforementioned,
			and you may also boot it with either the emulator or
			a physical USB stick (detailed directions by the end
			of this document).

 * mkfat12		Like mkfat12-beta, but with custom boot loader.

   			This is the same program as mkfat12-beta, but it now
			accepts a command-line option where the user may
			specify a custom program to be used as bootstrap code.

			If a custom boot loader is not specified, a contingency
			bootstrap code is used which outputs a message and
			allow for the user to replace the media and reload
			the boot sector.

			   $ make mkfat12

			will build the program, and

			   $ make boot12.img

			will create a FAT12-formatted, bootable disk image.

			One may try mounting and booting the image.

			Check the Makefile in this directory to see how the
			contingency bootstrap code mbs.S is handled.

			Try with a physical USP stick: format it and see if your
			operating system can access it: open the device and add
			a file to it:

			echo "Hello FAT" > file.txt

			Remove the stick and reinsert it, to make sure the file
			is there.

			The available (free) space in the stick can be computed
			like this:
			
			   total size : 1440 * 1024 bytes = 1474560 bytes

			   used by the file system :
			   - 1 reserved sector: 512 bytes
			   - 2 FATS : 2 * (9 sectors/fat * 512 bytes)
			   - Directory: 224 entries * 32 bit/entry

			   used by the file: 512

			That should give 1.39M. Check using a program like GParted.
			
			
			
			

  * fat12-mkfs.img	Example floppy images formatted with mkfs.fat
    fat16-mkfs.img
    fat32-mkfs.img	These are FAT12, FAT16 and FAT32 floppy images created
    			with the aid of the utility mkfs.fat provided by
			linux-util package.

			One may compare, for instance

			  $ ./mbrinfo fat12-mkfs.img
			  $ ./mbrinfo fat12.img

 Extra examples
 ------------------------------

 * egx-01.hex		Bootstrap loader added by mkfs.fat

   			The standard (util-linux) mkfs.fat adds a fallback
			bootstrap code into the disk's BS which just outputs
			a warning message and allows a new boot attempt to
			be requested.

			Try

			  make egx-01.bin/a16

                        to disassemble it.



 APPENDIX I
 -----------------------------
 
DOCM4_BINTOOLS_DOC

