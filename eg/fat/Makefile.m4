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

include(docm4.m4)dnl

bin = mkfat12-beta mkfat12 mbrinfo fatinfo

all : $(bin)

DOCM4_UPDATE

DOCM4_BINTOOLS


##
## Programs
##

# Create a FAT12 filesystem

mkfat12-beta : mkfat12-beta.o 
	gcc $< -o $@

# Creaate a FAT12 filesystem with custom bootstrap code

mkfat12 : mkfat12.o mbs.o 
	gcc $(filter %.o, $^) -o $@

# Inspect a FAT12/FAT16 BPB information

mbrinfo : mbrinfo.o
	gcc $< -o $@

fatinfo : fatinfo.o
	gcc $< -o $@

%.o : %.c
	gcc -c $< -o $@

mkfat12-beta mkfat12 mbrinfo : fat12.h

mbrinfo: fat.h

##
## Using the mkfat12-beta program
##

# Create a FAT12-formatted floppy disk image

fat12.img: | mkfat12-beta
        # Create the floppy disk information
	dd if=/dev/zero of=$@ count=2880       
        # Write the fat information
	./mkfat12-beta $@


# Create a bootable FAT12-formatted floppy disk image.
# How about using the Hello World program we developed in eg/hw?

fat12-boot.img: hw.bin | mkfat12-beta
        # Create the floppy disk image
	dd if=/dev/zero of=$@ count=2880       
        # Write the fat information
	./mkfat12-beta $@                      
        # Write the bootstrap program at the appropriate offset
	dd if=hw.bin of=$@ obs=1 conv=notrunc seek=62 

##
## Using the full-featured mkfat12 program
##

#  The program mkfat12 creates a FAT12 filesystem on a device.
#  If a file containing a bootstrap program is specified, its contents are
#  copied verbatim to the appropriate location in the device's MBR. If such
#  a program is not specified, mkfat12 uses a default bootstrap program.

mkfat12 : mkfat12.o mbs.o
	gcc mkfat12.o mbs.o -o $@

#  This is the default bootstrap program used by mkfat12.
#  The program outputs a message and offers the user the possibility of
#  replacing the media and pressing any key to reload the boot sector.
#
#  The program is written in assembly.

#  (notice -Ttext=0x7c3e = load_address + bootstrap_offset)

mbs.bin : mbs.S
	as --32 $< -o mbs.o
	ld -melf_i386 --oformat=binary -Ttext=0x7c3e -e mbs  mbs.o -o $@

#  In order to embed the program within mkfat, that's how we proceed.
#
#  We convert the binary mbr.bin into a sequence of hexadecimal values,
#  like hexdump does. Then we create a program mbs.c containting
#
#     int mbs_length =  <the length of mbr.bin> ;
#     const char mbs[]={ ... the sequence of bytes in mbr.bin, as hex values };
#

mbs.c : mbs.bin
	echo "int mbs_length = " `TOOL_PATH/bin2hex mbs.bin | wc -w` ";" > $@
	echo "const char mbs[[]]={" >> $@
	TOOL_PATH/bin2hex mbs.bin | sed -s 's/ [[0-9a-f]][[0-9a-f]]/,&/g' | sed -s 's/[[0-9a-f]][[0-9a-f]]/0x&/g'>> $@
	echo "};" >> $@

#  We then compile mbr.c into mbr.o and link mbr.o with mkfat12.
#  Then, in mkfat, we can access the vector mbr[] to write its contents,
#  byte by byte, into the device's MBR.

mbs.o : mbs.c
	gcc $< -c -o $@


# Create a bootable FAT12-formatted floppy disk image using mkfat12.

boot12.img: mbs.bin | mkfat12
	dd if=/dev/zero of=$@ count=2880
	./mkfat12  $@


# Create some disk-image examples and format them with
# a standard utility (mkfs, from util-linux).


fat12-mkfs.img:
	dd if=/dev/zero of=$@ count=2880
	mkfs.fat -F 12 $@

fat16-mkfs.img:
	dd if=/dev/zero of=$@ count=32768
	mkfs.fat -F 16 $@

fat32-mkfs.img:
	dd if=/dev/zero of=$@ count=131072
	mkfs.fat -F 32 $@


# Extra examples

egx-01.bin : egx-01.hex
	TOOL_PATH/hex2bin $< $@

#
# Auxiliary artifacts
#

# This is the bare-metal Hello World we've developed as part of eg/hw series.
# For illustration purpose, We may use it as a boostrap code for a bootable
# FAT-formatted disk.

hw.bin : hw.ld $(addprefix ../hw/, eg-07.o eg-07_utils.o eg-07_rt0.o)
	ld -melf_i386 -T hw.ld --orphan-handling=discard  $(addprefix ../hw/, eg-07.o eg-07_utils.o) -o $@

.PHONY: $(addprefix ../hw/, eg-07.o eg-07_utils.o eg-07_rt0.o) 
$(addprefix ../hw/, eg-07.o eg-07_utils.o eg-07_rt0.o) : 
	make -C ../hw/ $(notdir $@)


img = fat12.img fat12-boot.img
img += fat12-mkfs.img fat16-mkfs.img fat32-mkfs.img

all: $(img)

.PHONY: clean-local
clean-local :
	rm -f *.img *.bin mbs.c *.o $(bin)

clean : clean-local
