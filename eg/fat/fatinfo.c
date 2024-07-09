/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

#include "fat.h"
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <stdarg.h>
#include "debug.h"

#define PROGRAM "fatinfo"
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

void checking (const char*, ...);
int boot_record_type (struct boot_record_t *br);
int boot_record_type (struct boot_record_t *br);
int detect_fat_type (struct boot_record_t *br);


typedef enum {vbr, mbr} sector_t;
typedef enum {fat12, fat32} fat_type_t;

int main(int argc, char **argv)
{
  int opt, rs;
  FILE *fpin;
  unsigned int bootstrap_offset;
  sector_t sector_type;
  fat_type_t fat_type;
  
  struct boot_record_t br;		/* The FAT12's BR structure. */
  
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

  /* Read br */

  rs = read (fileno(fpin), &br, 512);
  sysfatal (rs<0);


  /* Heuristics to determine the FS type. */

  /* sector_type = boot_record_type (&br); */

  /* 
   * Show file system info
   */

  /*Premable.*/
  
  printf ("DOS startup code               : %x %x %x\n",
	  (unsigned char) br.dos_startup_code[0],
	  (unsigned char) br.dos_startup_code[1],
	  (unsigned char) br.dos_startup_code[2]);


  printf ("OEM name                       : %.8s\n", br.oem_name);

  /* BIOS Paramber Block (BPB) */
  

  
  printf ("Bytes per logical sector       : %d\n",  br.bpb.bytes_per_logical_sector);
  
  printf ("Logical sectors per cluster    : %d\n",  br.bpb.logical_sectors_per_cluster);

  printf ("Number of reserved sectors     : %d\n",  br.bpb.number_of_reserved_sectors);

  printf ("Number of FATs                 : %d\n",  br.bpb.number_of_fats);


  printf ("Maximum root directory entries : %d\n",  br.bpb.maximum_root_directory_entries);

  printf ("Total number of logic sectors  : %d\n",  br.bpb.total_number_of_logic_sectors);

  
  printf ("Media descriptor               : %2x\n",  br.bpb.media_descriptor);

  printf ("Logical sectors per fat        : %d\n",  br.bpb.logical_sectors_per_fat);

  printf ("Physical sectors per track     : %d\n",  br.bpb.physical_sectors_per_track);

  printf ("Number of heads                : %d\n",  br.bpb.number_of_heads);

  printf ("Number of hidden sectors       : %d\n",  br.bpb.number_of_hidden_sectors);

  
  fat_type = detect_fat_type(&br);

  if (fat_type == fat12)
    {
      printf ("Total logic sectors            : %d\n",  br.bpb.ebpb.total_number_of_sectors);

      printf ("Physical drive number          : %x\n",  br.bpb.ebpb.physical_drive_number);
      
      printf ("Reserved field                 : %d\n",  br.bpb.ebpb.reserved_field);
      
      printf ("Extended boot signature        : 0x%x\n", br.bpb.ebpb.extended_boot_signature);
      
      printf ("Volume ID                      : %u\n",  br.bpb.ebpb.volume_id);
      
      printf ("Partition volume label         : %.11s\n", br.bpb.ebpb.partition_volume_label);
      
      printf ("File system type               : %.8s\n", br.bpb.ebpb.file_system_type);
    }
  
#ifdef NONE

  


  /* Boot signature. */

  printf ("\n");

  bootstrap_offset = (unsigned char) br.dos_startup_code[1] + 2;
  

  printf ("Bootstrap region start         : 0x%x %s\n",
	  bootstrap_offset,
	  bootstrap_offset == 0x3e ? "(FAT12/FAT16)":"");
  /* printf ("Bootstrap region end           : 0x%x\n", */
  /* 	  512-2);   */
  printf ("Bootstrap region size          : %d\n",
	  512 - 2 - bootstrap_offset);
  
  printf ("Boot signature                 : %s (0x%x)\n",
	  br.boot_signature == 0xaa55 ? "present" : "not present",
	  br.boot_signature);

#endif
  
  /* -----------------------------------------------------------------
   *
   *  Some heuristics. 
   * 
   * -----------------------------------------------------------------
   */

  /* printf ("\nInsights:\n"); */


  /* bootstrap_offset = (unsigned char) br.dos_startup_code[1]; */
  
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
  /* 	   br.bpb.total_number_of_logic_sectors/  */
  /* 	   br.bpb.number_of_heads/  */
  /* 	   br.bpb.physical_sectors_per_track);  */

  /* printf ("Disk infered capacity is %d KB\n",  */
  /* 	   br.bpb.total_number_of_logic_sectors * */
  /* 	  br.bpb.bytes_per_logical_sector / 1024 ); */
  
  return EXIT_SUCCESS;
}



int boot_record_type (struct boot_record_t *br)
{
  int isvbr=0, ismbr=0, count;
  
  /*  If sector 0 starts with a jmp, this is an unpartionted FAT12/16 VBR. 
      Otherwise, it may be a MBR (FAT32) of a partitioned media. */
  
  /* checking ("Sector 0 starts with a short jump followed by a NOP"); */

  /* printf ("Sector 0 starts with a short jump followed by a NOP %n %*s", &count, 60-count, "."); */
  printf ("Sector 0 starts with a short jump + NOP.............. ");
  
  if ( (((unsigned char) br->dos_startup_code[0]) == 0xeb) &&
       (((unsigned char) br->dos_startup_code[2]) == 0x90))
    {
      isvbr++;
      printf ("yes.\n");
	
    }
  else
    {
      ismbr++;
      printf ("no.\n");
    }

  printf ("Jump lands at.. ..................................... "); 

  switch ((unsigned char) br->dos_startup_code[1]+2)
    {
    case 0x3e:
      printf ("0x3e (possibly FAT12 or FAT16 BPB)\n");
      ismbr++;
      break;
      ;;
    case 0x5a:
      printf ("0x5a (possibly FAT32 BPB)\n");
      isvbr++;
      break;
      ;;
    default:
      printf ("that's weird.");
      exit(1);
      ;;
    }
  

  printf ("0x%x\n", (unsigned char) br->bpb.ebpb.extended_boot_signature);
  printf ("0x%x\n", (unsigned char) br->bpb.ebpb32.extended_boot_signature);

  printf ("File system type               : %.8s\n", br->bpb.ebpb.file_system_type);
  /* printf ("File system type               : %.8s\n", br->bpb.ebpb32.file_system_type +4 + 11); */
  printf ("File system type               : %.8s\n", br->bpb.ebpb32.file_system_type);

  printf("\n");

  return ismbr > isvbr ? mbr : vbr; 
  
}

void checking (const char* template, ...)
{
  va_list args;
  int count, i;
  
  va_start (args, template);
  
  count = vprintf (template, args);

  va_end(args);

  for (i=count; i<60; i++)
    printf (".");
}

int detect_fat_type (struct boot_record_t *br)
{

  switch ((unsigned char) br->dos_startup_code[1]+2)
    {
    case 0x3e:
      printf (">>> Detected FAT12\n");
      return fat12;
      break;
      ;;
    case 0x5a:
      printf (">>> Detected FAT32\n");
      return fat32;
      break;
      ;;
    default:
      printf (">>> Weird DOS startup code\n");
      exit(1);
      ;;
    }

}
