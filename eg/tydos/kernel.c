/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

/* This source file implements the kernel entry function 'kmain' called
   by the bootloader, and the command-line interpreter. Other kernel functions
   were implemented separately in another source file for legibility. */

#include "bios1.h"		/* For kwrite() etc.            */
#include "bios2.h"		/* For kread() etc.             */
#include "kernel.h"		/* Essential kernel functions.  */
#include "kaux.h"		/* Auxiliary kernel functions.  */
#include "tydos.h"		/* TinyDOS kernel functions.    */
/* Kernel's entry function. */

void kmain(void)
{
  int i, j;
  
  register_syscall_handler();	/* Register syscall handler at int 0x21.*/

  splash();			/* Uncessary spash screen.              */

  shell();			/* Invoke the command-line interpreter. */
  
  halt();			/* On exit, halt.                       */
  
}

/* Tiny Shell (command-line interpreter). */

char buffer[BUFF_SIZE];
int go_on = 1;

void shell()
{
  int i;
  clear();
  kwrite ("TinyDOS 1.0\n");

  while (go_on)
    {

      /* Read the user input. 
	 Commands are single-word ASCII tokens with no blanks. */
      do
	{
	  kwrite(PROMPT);
	  kread (buffer);
	}
      while (!buffer[0]);

      /* Check for matching built-in commands */
      
      i=0;
      while (cmds[i].funct)
	{
	  if (!strcmp(buffer, cmds[i].name))
	    {
	      cmds[i].funct();
	      break;
	    }
	  i++;
	}

      /* If the user input does not match any built-in command name, just
	 ignore and read the next command. If we were to execute external
	 programs, on the other hand, this is where we would search for a 
	 corresponding file with a matching name in the storage device, 
	 load it and transfer it the execution. Left as exercise. */
      
      if (!cmds[i].funct)
	kwrite ("Command not found\n");
    }
}


/* Array with built-in command names and respective function pointers. 
   Function prototypes are in kernel.h. */

struct cmd_t cmds[] =
  {
    {"help",    f_help},     /* Print a help message.       */
    {"quit",    f_quit},     /* Exit TyDOS.                 */
    {"exec",    f_exec},     /* Execute an example program. */
    {0, 0}
  };


/* Build-in shell command: help. */

void f_help()
{tydos  kwrite ("...me, Obi-Wan, you're my only hope!\n\n");
  kwrite ("   But we can try also some commands:\n");
  kwrite ("      exec    (to execute an user program example\n");
  kwrite ("      quit    (to exit TyDOS)\n");
}


#include "tydos.h"
#include "kaux.h"
#include "bios.h"
#include "tyfs.h"

// Tamanho máximo do arquivo em bytes
#define MAX_FILE_SIZE 65536

// Função para carregar e executar programas
int exec_program(const char *filename) {
    // Buffer para carregar o programa
    char buffer[MAX_FILE_SIZE];

    // Estrutura de cabeçalho do sistema de arquivos tyFS
    struct tyfs_header *header = (struct tyfs_header *)0x7c00; // endereço do cabeçalho tyFS na memória

    // Verificar se o arquivo existe no sistema de arquivos
    struct tyfs_entry *entry = tyfs_find_file(header, filename);
    if (entry == NULL) {
        printf("File not found: %s\n", filename);
        return -1;
    }

    // Carregar o arquivo na memória
    int size = tyfs_load_file(header, entry, buffer, MAX_FILE_SIZE);
    if (size < 0) {
        printf("Failed to load file: %s\n", filename);
        return -1;
    }

    // Executar o programa carregado
    void (*entry_point)() = (void (*)())buffer;
    entry_point();

    return 0;
}

// Função principal do interpretador de comandos
void command_interpreter() {
    char command[256];
    while (1) {
        // Lê o comando do usuário
        gets(command);
        if (strcmp(command, "exit") == 0) {
            break;
        } else if (strcmp(command, "ls") == 0) {
            // Lista os arquivos no sistema de arquivos
            list_files();
        } else {
            // Tenta executar o programa pelo nome
            if (exec_program(command) == -1) {
                printf("Command not found: %s\n", command);
            }
        }
    }
}



void f_quit()
{
  kwrite ("Program halted. Bye.");
  go_on = 0;
}

/* Built-in shell command: example.

   Execute an example user program which invokes a syscall.

   The example program (built from the source 'prog.c') is statically linked
   to the kernel by the linker script (tydos.ld). In order to extend the
   example, and load and external C program, edit 'f_exec' and 'prog.c' choosing
   a different name for the entry function, such that it does not conflict with
   the 'main' function of the external program.  Even better: remove 'f_exec'
   entirely, and suppress the 'example_program' section from the tydos.ld, and
   edit the Makefile not to include 'prog.o' and 'libtydos.o' from 'tydos.bin'.

  */

extern int main();
void f_exec()
{
  main();			/* Call the user program's 'main' function. */
}

