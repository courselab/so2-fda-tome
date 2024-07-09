/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/* mbrinfo.c - Show information abou the MBR. */
 
#include "fat12.h"
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include "debug.h"

#define PROGRAM "mbrinfo"
#define VERSION "0.1.0"

char usage[] =
  "\n"
  "Usage : " PROGRAM " [options] <file-name>\n\n"
  "        Options \n\n"
  "        -h             this help message\n"
  "        -v             show program version\n"
  "\n\n"
  ;

char version[] =
  PROGRAM " " VERSION;


int main(int argc, char **argv)
{
  int opt, rs;
  FILE *fpin;
  unsigned int bootstrap_offset;
  
  struct boot_record_t mbr;		/* The FAT12's MBR structure. */
  
  /* Process command-line options. */
  
  while ((opt = getopt(argc, argv, "hvs:b")) != -1)
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
	default:
	  fprintf (stderr, "%s", usage);
	  exit (EXIT_FAILURE);
	  break;
	}
    }

  if (argc < (optind+1))
    {
      printf("%s", usage);
      exit (EXIT_SUCCESS);
    }


  /* Open device. */
  
  fpin = fopen (argv[optind],"r");
  sysfatal (!fpin);

  /* Read mbr */

  rs = read (fileno(fpin), &mbr, 512);
  sysfatal (rs<0);
  
  /* 
   * Show file system info
   */

  /*Premable.*/
  
  printf ("DOS startup code               : %x %x %x\n",
	  (unsigned char) mbr.dos_startup_code[0],
	  (unsigned char) mbr.dos_startup_code[1],
	  (unsigned char) mbr.dos_startup_code[2]);


  printf ("OEM name                       : %.8s\n", mbr.oem_name);

  /* BIOS Paramber Block (BPB) */
  

  printf ("Bytes per logical sector       : %d\n",  mbr.bpb.bytes_per_logical_sector);
  
  printf ("Logical sectors per cluster    : %d\n",  mbr.bpb.logical_sectors_per_cluster);

  printf ("Number of reserved sectors     : %d\n",  mbr.bpb.number_of_reserved_sectors);

  printf ("Number of FATs                 : %d\n",  mbr.bpb.number_of_fats);

  printf ("Maximum root directory entries : %d\n",  mbr.bpb.maximum_root_directory_entries);

  printf ("Total number of logic sectors  : %d\n",  mbr.bpb.total_number_of_logic_sectors);

  printf ("Media descriptor               : %2x\n",  mbr.bpb.media_descriptor);

  printf ("Logical sectors per fat        : %d\n",  mbr.bpb.logical_sectors_per_fat);

  printf ("Physical sectors per track     : %d\n",  mbr.bpb.physical_sectors_per_track);

  printf ("Number of heads                : %d\n",  mbr.bpb.number_of_heads);

  printf ("Number of hidden sectors       : %d\n",  mbr.bpb.number_of_hidden_sectors);

  printf ("Total number of sectors        : %d\n",  mbr.bpb.total_number_of_sectors);

  printf ("Physical drive number          : %x\n",  mbr.bpb.physical_drive_number);

  printf ("Reserved field                 : %d\n",  mbr.bpb.reserved_field);

  printf ("Extended boot signature        : 0x%x\n", mbr.bpb.extended_boot_signature);
  
  printf ("Volume ID                      : %u\n",  mbr.bpb.volume_id);

  printf ("Partition volume label         : %.11s\n", mbr.bpb.partition_volume_label);

  printf ("File system type               : %.8s\n", mbr.bpb.file_system_type);


  /* Boot signature. */

  printf ("\n");

  bootstrap_offset = (unsigned char) mbr.dos_startup_code[1] + 2;
  

  printf ("Bootstrap region start         : 0x%x %s\n",
	  bootstrap_offset,
	  bootstrap_offset == 0x3e ? "(FAT12/FAT16)":"");
  /* printf ("Bootstrap region end           : 0x%x\n", */
  /* 	  512-2);   */
  printf ("Bootstrap region size          : %d\n",
	  512 - 2 - bootstrap_offset);
  
  printf ("Boot signature                 : %s (0x%x)\n",
	  mbr.boot_signature == 0xaa55 ? "present" : "not present",
	  mbr.boot_signature);

  /* -----------------------------------------------------------------
   *
   *  Some heuristics. 
   * 
   * -----------------------------------------------------------------
   */

  /* printf ("\nInsights:\n"); */


  /* bootstrap_offset = (unsigned char) mbr.dos_startup_code[1]; */
  
  /* printf ("Bootstrap code offset 0x%x+2 = 0x%x: ", bootstrap_offset, bootstrap_offset+2); */
  /* switch (bootstrap_offset) */
  /*   { */
  /*   case 0x3c: */
  /*     printf ("possibly FAT12 or FAT16\n"); */
  /*     break; */
  /*   case 0x58: */
  /*     printf ("possibly FAT32\n"); */
  /*     break; */
  /*   default: */
  /*     printf ("unexpected value\n"); */
  /*     break; */
	  
  /*   } */
  
  /* printf ("Disk appears to have %d cylinders (tracks)\n", */
  /* 	   mbr.bpb.total_number_of_logic_sectors/  */
  /* 	   mbr.bpb.number_of_heads/  */
  /* 	   mbr.bpb.physical_sectors_per_track);  */

  /* printf ("Disk infered capacity is %d KB\n",  */
  /* 	   mbr.bpb.total_number_of_logic_sectors * */
  /* 	  mbr.bpb.bytes_per_logical_sector / 1024 ); */
  
  return EXIT_SUCCESS;
}
