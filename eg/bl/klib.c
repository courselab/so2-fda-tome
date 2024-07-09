/*
 *    SPDX-FileCopyrightText: 2024 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */


#include "klib.h"
#include "bios2.h"

/* Video RAM as 2D matrix: short vram[row][col]. */

short (*vram)[COLS] = (short (*)[COLS])0xb8000;

char character_color = 0x70;	/* Default fore/background character color.*/

/* Write 'string' starting at the position given by 'row' and 'col'.
   Text is wrapped past either the last column or last line. */

void writexy(unsigned char row, unsigned char col, const char* string)
{
  int i=col;
  int k=0;
  while (string[k])
    {
      if (col >= COLS)
	{
	  row += 1;
	  col = 0;
	}

      row = row % ROWS;
      
      vram[row][i] = color_char(string[k]);
      i++;
      k++;
    }
}

/* Delay 't' milisseconds. */

void __attribute__((fastcall)) delay(unsigned short t)
{
  __asm__
    (				   
      "  pusha                   \n" /* Save all GP registers.                            */
      "  mov %cx, %bx            \n" /* Argument already in %cx (fastcall).               */
      "  mov $0, %cx             \n" /* BIOS in 15h delay is of %cx:%dx microsseconds:    */
      "  mov $0x03e8, %dx        \n" /* therefore we must have 0000:03e8 for 1ms.         */
      "delay_loop:               \n" /* We'll delay 1ms, t times                          */
      "  test %bx, %bx           \n" /* Loop until t==0.                                  */
      "  jz delay_end            \n" /* On zero, return                                   */
      "  movb $0x86, %ah         \n" /* %ah = 0x86 (BIOS function for waiting).           */
      "  int $0x15               \n" /* Call BIOS interrupt 0x15, function AH=0x86.       */
      "  dec %bx                 \n" /* t = t-1                                           */
      "  jmp delay_loop          \n" /* Repeat loop.                                      */
      "delay_end:                \n"
      "  popa                    \n" /* Restore all GP registers.                         */
     );
}

void splash(void)
{
  int i,j;
  char buffer[20];
  
  character_color = 0x70;
  
  writexy(ROWS*1/5, 5, "                                                                      ");
  
  for (j = (ROWS*1/5) + 1; j <= (ROWS*4/5) -1; j++)
    {
      writexy(j, 5, " ");
      writexy(j, COLS-6, " ");
    }
  writexy(ROWS*4/5, 5, "                                                                      ");

  character_color = 0x02;
  writexy( ROWS/2-2, 10, "Preparing...");
  character_color = 0x20;
  for (i=10; i<=COLS-10; i++)
    {
      writexy(ROWS/2, i, " ");
      delay(20);
    }
  character_color = 0x02;
  writexy( ROWS/2-2, 10, "Ready.      ");
  
  writexy(18,10, "Press ENTER to start");
  readln(buffer);
  
}

void halt(void)
{
  __asm__
    (
     "khalt:        \n"
     "   hlt        \n"
     "   jmp khalt  \n"
     );
}


 /* A simple ASCII art animation. */

void bounce (void)
{
  char x=10, y=10;
  char dx=1, dy=-1;
  const char* sym = " ";
  char color = 0x20;
  
  clear();

  character_color = 0xf0;
  writexy (10,20," S I M P L E   B O O T   L O A D E R ");
  
  character_color = color;
  writexy(y,x, sym);
	
  while (1)
    {
      delay(40);
      
      /* Erase last char. */
      character_color = 0x0;
      writexy(y,x, sym);

      /* Bounce within the 80x25 screen. */
      
      if ( (y==0) || (y == (ROWS-1) ))
	{
	  dy = -dy;
	  color = (color + 0x10 % 8)+0x10;
	}
      
      if ( (x==0) || (x == (COLS-1) ))
	{
	  dx = -dx;
	  color = (color + 0x10 % 8)+0x10;
	}
      x = x + dx;
      y = y + dy;

      /* Draw new char. */
      character_color = color;
      writexy(y,x, sym);
    }
  
}


