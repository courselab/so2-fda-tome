#    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.


##
## Configuration
##

# Name the subdirs in this section.

extra_subdirs = tyos imf bcmd tydos quiz

# List of files that should be created from the source m4 files.

docm4_files = README tyos/Makefile tyos/README imf/README imf/Makefile hack01/README hack01/Makefile hw/README hw/Makefile bcmd/README bcmd/Makefile mydos/README mydos/Makefile quiz/Makefile quiz/README


##
## No need to change this
##

# REUSE-IgnoreStart
include $(top_srcdir)/tools/docm4.am
# REUSE-IgnoreEnd 

EXTRA_DIST += $(extra_subdirs)

