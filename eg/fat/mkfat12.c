/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/* mkfat12.c - Format media with fat12. */
 
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <time.h>
#include "debug.h"
#include "fat12.h"

#define PROGRAM "mkfat12"
#define VERSION "0.1.0"

char usage[] =
  "\n"
  "Usage : " PROGRAM " [options] <file-name>\n\n"
  "        Options \n\n"
  "        -b <filename>   load the named bootstrap program (implies -b)\n"
  "        -h              this help message\n"
  "        -v              show program version\n"
  "\n\n"
  ;

char version[] =
  PROGRAM " " VERSION;

/* Read the named bootstrap program. */

void read_bootstrap_program(const char*, char *);

/* Main function. */

extern const char mbs[];
extern int mbs_length;

int main(int argc, char **argv)
{
  int opt, rs, i;
  FILE *fpin;
  struct boot_record_t mbr;
  char *bootstrap_program = NULL;
  
  /* Process command-line options. */
  
  while ((opt = getopt(argc, argv, "hvb:")) != -1)
    {
      switch (opt)
	{
	case 'h':
	  printf("%s", usage);
	  exit (EXIT_SUCCESS);
	  break;
	case 'v':
	  printf(PROGRAM " " VERSION "\n");
	  exit (EXIT_SUCCESS);
	  break;
	case 'b':
	  bootstrap_program = strdup(optarg);
	  break;
	default:
	  fprintf (stderr, "%s", usage);
	  exit (EXIT_FAILURE);
	  break;
	}
    }

  if (argc < (optind+1))
    {
      printf("%s", usage);
      exit (EXIT_FAILURE);
    }

  /***********************************************************************

        Fill in the MBR

   ***********************************************************************/

  /* DOS startup code is a jump to the begining of the boostrap program.

     Remeber: BIOS loads the first 512 bytes of the storage device into
     address 0x7c00 and transfer execution to that location. The first 
     three bytes in our formatted media (that will be at 0x7c00) tells the
     CPU to jump all the BPB data and land at the offset of 0x03e (from the
     begining of the device) where lays the bootstrap code.
     
      jmp 0x3c  ; jump to an offset of 0x03c starting from the next instruction
      nop	; does nothing		

     In terms of opcodes, that yields  

      eb 3c
      90
     
     We need to fill in the three bytes into char bpb.dos_startup_code[3].

     If we do not want to manually iterate through the array positions,
     we can cast bpb.dos_startup_code as an int, and asign it a literal
     value. We just need to remember that x86 is little endian. 

 */
  
  *(unsigned int *) mbr.dos_startup_code = (unsigned int) 0x903ceb; 

  /* This is any arbitrary 8-byte alphanumeric (ASCII) identification. */

  memcpy(mbr.oem_name, PROGRAM, 8);

  /* Zero-out the bootstrap code section (just for tidiness) */

  for (i=0; i < sizeof(mbr.bootstrap_code); i++)
    mbr.bootstrap_code[i] = 0x00;

  /* and if asked, load the bootstrap program into the MBR. This program
     needs to be at most 448 bytes long to fit into the bootstrap code
     region. The boot signature will follow it.*/

  if (bootstrap_program)
    read_bootstrap_program (bootstrap_program, mbr.bootstrap_code);
  else
    for (i=0; i < mbs_length; i++)
      mbr.bootstrap_code[i] = mbs[i];
    
  /* Bytes per logical sector: default to 512. 

     Block devices such as HD and USB flash sticks cannot read individual bytes
     form the media; instead, they read blocks of bytes. The minimum size of a
     read-write block that can be physically addressed by the device is referred 
     to as a disk sector --- which usually counts 512 bytes. Oftentimes, 
     aiming at efficiency improvement, the sector size reported by the hardware
     to the system software layer (e.g. to BIOS or to  the OS) may be different. 
     For instance, newer devices are migrating to the Advanced Format standard, 
     in which a disk sector has 4K, rather than 512 bytes (4k = 8 * 512).  
     In order to support legacy systems, those devices can emulate 512-byte 
     block devices. Disk sectors are this also reffered to as logical sector,
     which correponds to the read-write block reported by the device.  
     A logical sector size (known by BIOS) is less or equal the physical sector 
     size (actualy used by the device's hardware).

     We need only care about the logical sector here. 

*/

  mbr.bpb.bytes_per_logical_sector = 512;
    
  /* Logical sectors per cluster. 

     Large capacity storage media will have a large number of disk (logical)
     sectors. In order to address each sector individually, a large index 
     would be needed (FAT, Root Directory Entry), resulting in inefficient 
     use of the media capacity and more read-write operations. Rather,
     it is often more advantageous to group disk sectors into clusters
     and address those clusters instead of individual disk sectors. While 
     the disk sector is the least read-write unit at the device level, 
     a cluster is the least read-write unity at the file system level ---
     that is, in a formatted disk we will say that a given file occupies 
     determined clusters, not sectors. 

     Let's choose 1-sector clusters for simplicity (indeed, this is not
     uncommon for FAT12 disks).

*/

  mbr.bpb.logical_sectors_per_cluster = 1;

  /* Number of reserved sectors.

     We'll have only one reserved sesctor (the boot sector). 
 */

  mbr.bpb.number_of_reserved_sectors = 1;

  /* Number of FATS. 

     We usually have a FAT backup.
  */

  mbr.bpb.number_of_fats = 2;

  /*  Maximum root directory entries. 

      This field tells how may files we may have in our disk. For instance,
      (util-linux) mkfs chooses 224 entries for FAT12.

      Say we select 224 entries (maximum number of files):
      
      each entry is 32-byte long; therefore we'll have

      (224 entry) * 32 (byte/entry) / (512 byte/sector) = 14 sectors.

*/
  
  mbr.bpb.maximum_root_directory_entries = 224;

  /* Total number of logical sectors. 

     The commercial label 1.44M actually (and weirdly) means 1440 Kb.

     (1440 * 1024 bytes) / (512 bytes / sector) = 2880 sector.

*/

  mbr.bpb.total_number_of_logic_sectors = 2880;


  /* Media descriptor: 
     
     0xf0, used for floppy     (i.e. removable)
     0xf8, used for HD         (i.e. fixed)

     Apparently, mkfs (from util-linux) uses 0xf0 for FAT12 (non-partionable?)
     and 0xf8 for FAT16 and FAT32 (partionable?). 

  */

  mbr.bpb.media_descriptor = 0xf0;

  /* Logical sectors per fat.

     Say we select 9 sectors per FAT, like util-linux's mkfs.

     This determines how many clusters we can address in the data region.

     Considering that


     (9 sector) * (512 byte/sector) = 4608 byte in each FAT.

     (4608 bytes) / (12 bit/entry) = 

     (4608 bytes) / (1.5 byte/entry) = 3072 addressable clusters.

     For 1-sector clusters, that is 3072 files.

 */

  mbr.bpb.logical_sectors_per_fat = 9;


  /* Geometrical (cylinder) sectors per track. */
  
  mbr.bpb.physical_sectors_per_track = 18;

  /* Number of heads. */

  mbr.bpb.number_of_heads = 2;

  /* Number of hidden sectors. 
     
     We don't need any here. */

  mbr.bpb.number_of_hidden_sectors = 0;

  /* Total number of sectors. 
     
     Some programs let this to be zero. */

  mbr.bpb.total_number_of_sectors = 0;

  /* Physical drive number. 

     Convention:

     First removable media:  0x00
     First fixed disk:       0x80

     Some BIOS uses values in the ranges 0x00-0x7E and 0x80-0xFE.
  */     

  mbr.bpb.physical_drive_number = 0;

  /* Reserved field. */

  mbr.bpb.reserved_field = 0;

  /* Extended boot signature.

     This field indicates if Extended BPB is in use.

     Value 0x29 means yes.

  */

  mbr.bpb.extended_boot_signature = 0x29;

  /* Volume ID

     This is an arbitrary serial number.

  */

  mbr.bpb.volume_id = time(NULL);


  /* Partition volume label. 

     An arbitrary 11-byte alphanumeric (ASCII) sequence. */

  strncpy (mbr.bpb.partition_volume_label, "NO LABEL", 11);

  /* File system type. 

     An 11-byte alphanumeric (ASCII) sequence.  */


  strncpy (mbr.bpb.file_system_type, "FAT12", 8);

  /* Boot signature. */

  mbr.boot_signature = 0xaa55 ;

  /* 
   * The mbr struture is filled up. Now let's write it on the disk. 
   *
   */

  fpin = fopen (argv[optind],"r+");
  sysfatal (!fpin);


  rs = write (fileno(fpin), &mbr, sizeof(struct boot_record_t));
  
  

  /* 
   * Now let's write the FATs at their proper location. 
   */

  /* First FAT goes right after the reserved sectors. */
  
  rs = write (fileno(fpin), (char []) {0xf0,0xff, 0xf0} , 3);
  sysfatal (rs<0);

  /* Second FAT goes after the first FAT. */
  
  rs = fseek (fpin, (mbr.bpb.logical_sectors_per_fat * 512 - 3), SEEK_CUR);
  
  sysfatal (rs<0);
  rs = write (fileno(fpin), (char []) {0xf0,0xff, 0xff} , 3);
  sysfatal (rs<0);

  fclose (fpin);
  
  return EXIT_SUCCESS;
}


/* Writes the content of the file whose name is filename into 
   the buffer code.*/

void read_bootstrap_program(const char* filename, char * code)
{
  FILE *fp;
  int c, i=0;
  fp = fopen (filename, "r");
  sysfatal (!fp);
  while ((c=getc(fp))!=EOF)
    code[i++] = (char) c;
}
