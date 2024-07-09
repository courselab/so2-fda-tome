/*
 *    SPDX-FileCopyrightText: 2024 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */ 

/* This program can be used to format a disk image with a TyFS file system
   and to manipulate files in the volume.*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <libgen.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/wait.h>

#include "debug.h"

#define CMD_LINE_LEN 1024	  /* Max length of the command line.          */
#define MAX_ARGS 32		  /* Max number of arguments in command line. */
#define DIR_ENTRY_LEN 32 	  /* Max file name length in bytes.           */

/* In order to allow for the media to be bootable by BIOS, the file system 
   signature starts with a jump instruction that leaps over the header data, 
   and lands at the bootstrap program right next to it. In the present example,
   the signature is the instruction 'jump 0xe', follwed by the character
   sequence 'ty' (we thus jump 14 bytes). */

#define FS_SIGNATURE "\xeb\xety"  /* File system signature.                   */
#define FS_SIGLEN 4               /* Signature length.                        */

/* The file header. */

struct fs_header_t
{
  unsigned char  signature[FS_SIGLEN];    /* The file system signature.              */
  unsigned short total_number_of_sectors; /* Number of 512-byte disk blocks.         */
  unsigned short number_of_boot_sectors;  /* Sectors reserved for boot code.         */
  unsigned short number_of_file_entries;  /* Maximum number of files in the disk.    */
  unsigned short max_file_size;		  /* Maximum size of a file in blocks.       */
  unsigned int unused_space;              /* Remaining space less than max_file_size.*/
} __attribute__((packed)) fs_header;      /* Disable alignment to preserve offsets.  */

char *volume_name = NULL ;	/* Name of the current file. */
FILE *volume_fp = NULL;		/* Pointer to the open file. */

int readint(FILE *fp);		/* Read user input as an integer (avoid scanf).      */
int go_on = 1;

/* User command: command name and pointer to the respective function. */

struct cmd_t
{
  int (*func)(int, const char**);
  const char *name;
};
extern struct cmd_t cmds[];

int volume_is_open();		      /* Check if volume is open.          */
int volume_is_fs_header();	      /* Check if volume has a TyFS heder. */
int arg_count(int, int, const char*); /* Check for required number of args. */

/* There we go. */

int main()
{
  int i, argc;
  char buffer[CMD_LINE_LEN];
  char *argv[MAX_ARGS];

  /* Reset header info. */
  
  memset (&fs_header, 0, sizeof(fs_header));

  printf ("TyDOS file manager.\n");

  /* Main command interpreter loop. */
  
  while (go_on)
    {
      int c;

      /* Read and parse the user input. */

      if (!volume_name)
	printf ("<none> ");
      else
	printf ("[%s]> ", volume_name);
      
      fflush(stdout);
      fgets (buffer, CMD_LINE_LEN-1, stdin);

      i = 0;
      while ( (argv[i] = strtok (i == 0 ? buffer : NULL, " \t\n"))) i++;
      argc = i;

      /* Execute command. */
      
      i = 0;
      if (argv[0])
	while (cmds[i].func)
	  {
	    if (  !strcmp(argv[0], cmds[i].name)   )
	      {
		cmds[i].func( argc, (const char**) argv );
		break;
	      }
	    i++;
	  }
      if (!cmds[i].func)
	printf ("Command not found\n");
    }

  return EXIT_SUCCESS;
}

/*  Open volume.
 *  Arguments: <volume-name>  
 */

int f_open (int argc, const char **argv)
{
  int rs;
  
  /* Precondition check. */
  
  if ( !arg_count(argc, 2, "Usage: open <volume-name>") )
    return 1;

  /* Open the volume. */
  
  if (volume_fp)
    fclose (volume_fp);

  volume_fp = fopen (argv[1], "r+");
  sysfault (!volume_fp, 1, argv[1]);

  /* Read volume header. */
  
  rs = fread (&fs_header, sizeof(fs_header), 1, volume_fp);
  sysfatal (rs<0);

  /* Set the prompt string. */
  
  volume_name = strdup (argv[1]); 

  return 0;
}

/*  Close volume.
 *  Arguments: (none)
 */

int f_close (int argc, const char **argv)
{
  int rs;

  /* Close volume. */
  if (volume_fp)
    fclose (volume_fp);

  /* Reset volume name and header info. */
  
  volume_fp = NULL;
  free (volume_name);
  volume_name = NULL;

  memset (&fs_header, 0, sizeof(fs_header));
  
  return 0;
}


/*  Print a help message.
 *  Arguments: (none)
 */

int f_help(int argc, const char** argv)
{
  printf
    ("Available commands\n\n"
     "open   <image>      open a volume image in the host system\n"
     "close               close a previously opened volume\n"
     "info                show open volume's file system information\n"
     "format              format the open volume with tyFS\n"
     "list                list files in the open volume\n"
     "put    <file>       copy file from host to the open volume\n"
     "get    <file>       copy file from the open volume to host\n"
     "get    <file> :dump dump the content of the file on the screen\n"
     "delete <file>       remove file from the open volume\n"
     "help                show this help message\n"
     "hlist  [path]       list files in the host system\n"
     "quit                exit the program\n\n");
  
  return 0;
}

/*  Quit the program.
 *  Arguments: (none)
 */

int f_quit(int argc, const char** argv)
{
  printf ("Bye.\n");
  go_on = 0;
  return 0;
}

/*  Format the volume.
 *  Arguments: (none)
 */

int f_format (int argc, const char** argv)
{
  int i, rs;
  float number_of_entries;

  /* Check preconditions. */

  if (!volume_is_open())
    return 1;

  /* Get file size (in blocks). */
  
  rs = fseek(volume_fp, 0, SEEK_END);
  sysfatal (rs<0);
  
  fs_header.total_number_of_sectors = ftell(volume_fp) / 512;
  printf ("File has %u blocks of 512 bytes (%d KB)\n",
	  fs_header.total_number_of_sectors,
	  fs_header.total_number_of_sectors/2);

  /* Ask how many reserved sectors. */
  
  printf ("Number of sectors reserved for boot code : ");
  fs_header.number_of_boot_sectors = readint (stdin);
  
  /* Ask the maximum file size (in KBytes). */
  
  printf ("Maximum file size in KBytes (1024 bytes) : ");  
  fs_header.max_file_size = readint(stdin) * 2;

  /* Compute how may files the volume can support. */

  number_of_entries = (float)
    (fs_header.total_number_of_sectors - fs_header.number_of_boot_sectors) * 512  /
    (DIR_ENTRY_LEN + fs_header.max_file_size*512);

  fs_header.number_of_file_entries = floor (number_of_entries);
    
  printf ("Maximum number of files will be          : %d\n", fs_header.number_of_file_entries);

  fs_header.unused_space = (int)
    fs_header.total_number_of_sectors*512 - fs_header.number_of_boot_sectors * 512 -
    fs_header.number_of_file_entries * (DIR_ENTRY_LEN + fs_header.max_file_size*512);
  
  printf ("Unused space                             : %d (%.2f KBytes)\n",
	  fs_header.unused_space, (float) fs_header.unused_space/1024);

  strncpy (fs_header.signature, FS_SIGNATURE, FS_SIGLEN);
  
  fseek (volume_fp, 0, SEEK_SET);
  
  fwrite(&fs_header, 1, sizeof(fs_header), volume_fp);

  /* Zero the remaining of the file. */
  
  for (i=sizeof(fs_header); i<fs_header.total_number_of_sectors*512; i++)
      fwrite ("\0", 1, 1, volume_fp);
  
  return 0;
}

/* Print volume information.
 * Arguments: (none).
 */

int f_info(int argc, const char **argv)
{

  /* Check preconditions. */
  
  if (!volume_is_open() || !volume_is_fs_header())
    return 1;
 
  printf ("Volume info reported by FS_HEADER header:\n");
  printf ("phisical volume size           : %d blocks (%d bytes) \n",
	  fs_header.total_number_of_sectors, fs_header.total_number_of_sectors * 512);
  printf ("number of reserved sectors     : %d blocks\n",
	  fs_header.number_of_boot_sectors);
  printf ("maximum number of file entries : %d files\n",
	  fs_header.number_of_file_entries);
  printf ("maximum supported file size    : %d bytes (%.2f KiB)\n",
	  fs_header.max_file_size*512, (float) fs_header.max_file_size/2);
  printf ("unused space                   : %d bytes (%.2f KiB)\n",
	  fs_header.unused_space, (float) fs_header.unused_space/1024);
  
  return 0;
  
}

/* List files in the volume. 
 * Arguments: (none)
*/

int f_list(int argc, const char** argv)
{
  int i;
  char name[DIR_ENTRY_LEN];

  /* Check preconditions. */
  
  if (!volume_is_open() || !volume_is_fs_header() )
    return 1;

  /* Position at the begining of the directory region. */
  
  fseek (volume_fp, fs_header.number_of_boot_sectors * 512, SEEK_SET);

  /* Read all entries. */
  
  for (i=0; i < fs_header.number_of_file_entries; i++)
    { 
      fread (name, DIR_ENTRY_LEN, 1, volume_fp);
      if (name[0])
	{
	  fwrite (name, DIR_ENTRY_LEN, 1, stdout);
	  printf ("\n");
	}
    }
  
  return 0;
}

/* Copy a file from the host file system to the volume.
 * Arguments: <file-name>
 *
 * Notes: file name is an ASCII string with not blanks.
 *        Quotes are not parsed as in usual shell grammar.
*/

int f_put(int argc, const char **argv)
{
  int i, j, c, rs;
  char buffer[DIR_ENTRY_LEN];
  char out_file_name;
  FILE *fpin;

  /* Check preconditions. */
  
  if (!volume_is_open() || !volume_is_fs_header())
    return 1;

  if ( !arg_count(argc, 2, "Usage: put <file-name>") )
    return 1;

  /* Position at the begining of the directory reagion. */
  
  fseek (volume_fp, fs_header.number_of_boot_sectors*512, SEEK_SET);

  /* Check for either free entry or a matching file name. */

  i = -1;
  do
    {
      fread (buffer, DIR_ENTRY_LEN, 1, volume_fp);

      if (!strncmp (buffer, argv[1], DIR_ENTRY_LEN))
	{
	  printf ("File '%s' already exists in the volume\n", argv[1]);
	  return 1;
	}

      i++;
    }
  while ((buffer[0]!='\0')  && (i<fs_header.number_of_file_entries) ) ;

  if (i == fs_header.number_of_file_entries)
    {
      printf ("Volume is full\n");
      return 1;
    }

  /* Position at the i-th entry at the directory region. */

  fseek (volume_fp,
	 fs_header.number_of_boot_sectors * 512 +
	 fs_header.number_of_file_entries * DIR_ENTRY_LEN +
	 fs_header.max_file_size * 512 * i,
	 SEEK_SET);

  /* Open the local file (in the host). */
  
  fpin = fopen (argv[1], "r");
  sysfault (!fpin, 1, argv[1]);

  /* Copy the file in to the volume. */

  j = 0;
  while ( ((c = fgetc(fpin)) != EOF) &&
	  (j<fs_header.max_file_size*512)  )
    {
      fwrite (&c, 1, 1, volume_fp);
      j++;
    }
  if (ferror(fpin))
    sysfatal(1);
  
  fclose (fpin);
  
  /* If everything works up to this point, create file entry. 
     
     Position at the ith-entry in the file directory region 
     and write the entry. */

  fseek (volume_fp,		
	 fs_header.number_of_boot_sectors * 512 +
	 DIR_ENTRY_LEN * i, SEEK_SET);

  strncpy (buffer, basename((char *) argv[1]), DIR_ENTRY_LEN);
  fwrite (buffer, DIR_ENTRY_LEN, 1, volume_fp);

  printf ("File '%s' copied at entry %d\n", argv[1], i);
  
  return 0;
  
}

/* Copy a file from the volume into the host file system.
 * Arguments: <file-name> [optional].
 *
 * If and optional argument is not provided, a file with the same is
 * created (or overwritten) in the host file system. If the option is
 * ':dump' the file content is dumped on the screen; if the optional
 * argument is something else, it indicates the name of the destination
 * file in the host system.
 *
 * Notes: file name is an ASCII string with not blanks.
 *        Quotes are not parsed as in usual shell grammar.
*/

int f_get(int argc, const char **argv)
{
  int i, c;
  FILE *fpout;
  char buffer[DIR_ENTRY_LEN];
  char *out_file_name;
  
  /* Check preconditions. */

  if (!volume_is_open() || !volume_is_fs_header())
    return 1;
    
  if ( !arg_count(argc, 2, "Usage: get [-d] <file-name>") )
    return 1;

 
  /* Position at the begining of the file directory region. */
  
  fseek (volume_fp, fs_header.number_of_boot_sectors*512, SEEK_SET);

  /* Search for the file name. */
  
  i = -1;
  do
    {
      fread (buffer, DIR_ENTRY_LEN, 1, volume_fp);
      i++;
    }
  while (strncmp (buffer, argv[1], DIR_ENTRY_LEN) &&
	 (i<fs_header.number_of_file_entries) ) ;

  if (i == fs_header.number_of_file_entries)
    {
      printf ("File '%s' not found in the volume\n", argv[1]);
      return 1;
    }

  
  /* Position at the ith-entry in the data region. */
  
  fseek (volume_fp,
	 fs_header.number_of_boot_sectors * 512 +
	 fs_header.number_of_file_entries * DIR_ENTRY_LEN +
	 fs_header.max_file_size * 512 * i,
	 SEEK_SET);

  /* Determine the destination stream. */

  if (argc < 3)
    out_file_name = (char *) argv[1];
  else
    {
      if (!strcmp (argv[2], ":dump"))
	out_file_name = NULL;
      else
	out_file_name = (char *) argv[2];
    }

  if (out_file_name)
    {
      fpout = fopen (out_file_name, "w");
      sysfault (!fpout, 1, out_file_name);
    }
  else
    fpout = stdout;

  
  /* Copy the content in the volume into the local file. */
  
  i=0;
  while ( ((c = fgetc(volume_fp)) != EOF) &&
	  (i<fs_header.max_file_size*512))
    {
      fputc (c, fpout);
      i++;
    }
  if (ferror(fpout))
    sysfatal(1);

  if (fpout != stdout)
    fclose (fpout);
  
  return 0;
}

/* Delete a file in the volume.
 * Arguments: <file-name> 
 */

int f_delete (int argc, const char **argv)
{
  int i;
  char buffer[DIR_ENTRY_LEN];

  /* Check preconditions. */
  
  if (!volume_is_open() || !volume_is_fs_header())
    return 1;

  if (!arg_count (argc, 2, "Usage: get <file-name>"))
    return 1;
  
  /* Position at the begining of the directory region. */
  
  fseek (volume_fp, fs_header.number_of_boot_sectors*512, SEEK_SET);

  /* Search for the file name. */
  
  i = -1;
  do
    {
      fread (buffer, DIR_ENTRY_LEN, 1, volume_fp);
      i++;
    }
  while (strncmp (buffer, argv[1], DIR_ENTRY_LEN) &&
	 (i<fs_header.number_of_file_entries) ) ;

  if (i == fs_header.number_of_file_entries)
    {
      printf ("File '%s' not found in the volume\n", argv[1]);
      return 1;
    }

  /* Position at the respective entry in the directory region.*/
  
  fseek (volume_fp, -DIR_ENTRY_LEN, SEEK_CUR);

  /* Zero the entry (data region is not touched). */
  
  for (i=0; i<DIR_ENTRY_LEN; i++)
    fputc (0, volume_fp);
  
  return 0;
}

/* List local files in the host.
   Arguments: (like the 'ls' utility from GNU coreutils). */

int f_hlist(int argc, const char **argv)
{
  int pid, status, rs;
  pid = fork();
  sysfatal (pid<0);
  if (pid>0)
    wait(&status);
  else
    {
      rs = execvp ("ls", (char * const*) argv);
      sysfatal (!rs);
    }
}

/* All the user commands. */

struct cmd_t
 cmds[] =
  {
    {f_help,   "help"},
    {f_quit,   "quit"},
    {f_quit,   "exit"},
    {f_open,   "open"},
    {f_close,  "close"},
    {f_info,   "info"},
    {f_format, "format"},
    {f_list,   "list"},
    {f_put,    "put"},
    {f_get,    "get"},
    {f_delete, "delete"},
    {f_hlist,  "hlist"},
    {0, 0}
  };


/* Read an integer from stdin (alternative to scanf)*/

int readint(FILE *fp)
{
  int val;
  char buffer[CMD_LINE_LEN];
  fgets (buffer, CMD_LINE_LEN-1, fp);
  val = atoi(buffer);
  return val;
}

/* If a volume is currently open, return 1; 
   otherwise, prints a message and return 0.*/

int volume_is_open()
{
  if (!volume_fp)
    {
      printf ("No open volume\n");
      return 0;
    }
  return 1;
}

/* If the volume currently open has a TyFS heander return 1; 
   otherwise, prints a message and return 0.*/

int volume_is_fs_header()
{
  if (memcmp (fs_header.signature, FS_SIGNATURE, FS_SIGLEN))
    {
      printf ("Fs_Header signature not found in the volume\n");
      return 0;
    }
  return 1;
}

/* if the 'argc' greather or equal than 'number', return 1;
   otherwise, prints a message and return 0. */

int arg_count(int argc, int number, const char *msg)
{
  if (argc < number)
    {
      printf ("%s\n", msg);
      return 0;
    }
  return 1;
}
