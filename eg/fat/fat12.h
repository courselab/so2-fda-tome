/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/* bpb.h - BIOS Parameter Block */
 
#ifndef FAT12_H
#define FAT12_H

/* BIOS Parameter Block (BPB) 

   This structure represents the BPB of a MS-DOS 4.0 FAT12 filesystem,
   including the extended BPB fields. See [1] and [2] for details.

   Note that the structure is marked with the attribute packed to prevernt
   aligment optmizaton.

*/

struct bpb12_t
{
  unsigned short bytes_per_logical_sector;
  unsigned char logical_sectors_per_cluster;
  unsigned short number_of_reserved_sectors;
  unsigned char number_of_fats;
  unsigned short maximum_root_directory_entries;
  unsigned short total_number_of_logic_sectors;
  unsigned char media_descriptor;
  unsigned short logical_sectors_per_fat;
  unsigned short physical_sectors_per_track;
  unsigned short number_of_heads;
  unsigned int number_of_hidden_sectors;
  unsigned int total_number_of_sectors;
  unsigned char physical_drive_number;
  unsigned char reserved_field;
  unsigned char extended_boot_signature;
  unsigned int volume_id;
  char partition_volume_label[11];
  char file_system_type[8];
} __attribute__((packed));


/* The MBR. See [1] for details.*/

struct boot_record_t
{
  char dos_startup_code[3];
  char oem_name[8];
  struct bpb12_t bpb;
  char bootstrap_code[512 - 3 - 8 - sizeof(struct bpb12_t) - 2];
  unsigned short boot_signature;
  
} __attribute__((packed));

#endif /* FAT12_H */

/* Notes

   [1] Wikepedia, Design of the FAT file system, 
       https://en.wikipedia.org/wiki/Design_of_the_FAT_file_system#Extended_BIOS_Parameter_Block

   [2] Wikipedia, BIOS parameter block,
       https://en.wikipedia.org/wiki/BIOS_parameter_block#DOS_4.0_EBPB

 */
