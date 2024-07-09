dnl    SPDX-FileCopyrightText: 2024 Monaco F. J. <monaco@usp.br>
dnl   
dnl    SPDX-License-Identifier: GPL-3.0-or-later
dnl
dnl    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

include(docm4.m4)

 tyFS - Tiny File System
 ==============================

 tyFS is an extremely simple file system.

 For the purpose of illustration, this directory contains the program
 'tyfsedit.c', a file-manager application that can format, read and edit a
 tyFS-formatted disk image.   

 Contents
 ------------------------------

 The file manager program:

 * tyfsedit.c	A tyFS file manager.

 tyFS is a trivial file system that is intentionally simple to understand and
 easy to implement: each file occupies one single fixed-length cluster of
 contiguous sectors (files can't be split across multiple clusters and thus
 have a maximum allowed size); a file name has also a maximum length and
 is the only attribute associated with a file.

 The basic layout of a tyFS-formatted volume is like this:

  ---------------------------------------
 | Header | Directory | Data             |
  ---------------------------------------
 

  The Header region contains information about the volume, including
  
      - tyFS signature
      - total number of logical sectors (512-byte blocks) in the image
      - number of sectors reserved for the boot program (at least 1) 
      - maximum number of entries (file names) in the directory region
      - maximum allowed file size (in the Data region)
      - unused space

  The Directory region is a sequence of 32-bit entries used to store
  the file names: alphanumeric strings with no blanks.

  The first entry in the directory region refers to the first cluster
  (i.e. the content of the first file) and so on.

  That is it.

 Directions
 ------------------------------

 1) First, create a disk image

      make disk.img

   That should create a file 'disk' full of zeros.

 2) Build and execute the program:

   make
   ./tyfsedit

   Try the command 'help' and follow the instructions.

 3) Try some operations (use 'help' command):

     a) open the image file
     b) get the image info
     c) format image (when asked, choose 4 boot sectors and 16K file size)
     
    Observe the resulting number of file entries (89) and the unused space;
    go through the source code to understand how these values are computed.
    This will give you a grasp on how easy is to manipulate the file system.

    Then,

     d) list the files in the volume (none so far);
     e) copy a file from the host to the volume;
     f) list the volume again;
     g) copy other files from the host to the volume;
     h) copy a file from the volume to the host;
     i) delete a file, and list;
     k) dump the content of a file on the screen.

 4) Take some time to understand the program source.

   The file 'tyfsedit.c' implements the tyFS file manager.

   The structure 'fs_header_t' represents the volume header.

   See the source and code documentation to understand how each function
   works.

 5) A good exercise would be to implement a command 'rename' that renames
    a file in the volume. Give it a try.

 DOCM4_BINTOOLS_DOC

