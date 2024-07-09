#    SPDX-FileCopyrightText: 2001 Monaco F. J <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

##
## Configuration
##

# Name the subdirs in this section.

extra_subdirs = hw abi build make fat run real bl tyos crt tyos32 posix tydos tyfs

# List of files that should be created from the source m4 files.

docm4_files = README abi/README abi/Makefile fat/Makefile fat/README run/Makefile run/README hw/README hw/Makefile real/README real/Makefile build/README build/Makefile make/README rop/README rop/Makefile bl/Makefile bl/README tyos/README tyos/Makefile crt/Makefile crt/README tyos32/Makefile tyos32/README posix/README posix/Makefile tydos/Makefile tyfs/Makefile tyfs/README

##
## No need to change this
##

# REUSE-IgnoreStart
include $(top_srcdir)/tools/docm4.am
# REUSE-IgnoreEnd 

EXTRA_DIST += $(extra_subdirs)
