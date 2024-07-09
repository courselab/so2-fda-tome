/*
 *    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
 *   
 *    SPDX-License-Identifier: GPL-3.0-or-later
 *
 *    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
 */

#include "bios1.h"		/* Function load_kernel . */
#include "kernel.h"		/* Function kmain.        */

int boot()
{
  
  load_kernel();		/* Load the kernel from disk image.  */
  
  kmain();		        /* Call the kernel's entry function. */
  
  return 0;

}

