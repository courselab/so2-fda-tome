#!/bin/sh

#    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

#
# main.sh - Wrapper script template
#
# This is a provision for allowing proper execution of installed binaries
# directly from the source tree --- e.g. for build-time testing.
#
# Example:
#
# Say that, upon installation, the binary $(bindir)/foo is supposed to read
# data files from the directory $(datarootdir)/foo. If one wants to execute
# the binary from within the source tree, $(srcdir)/foo must be issued with
# an option to read data from $(srcdir)/data.
#
# Upon build, program $(bindir)/foo is actually a script which invokes the
# real binary $(srcdir)/foo.bin with the with appropriate options to read
# data from $(srcdir)/data. Upon installation, binary foo.bin is copied to
# the $(bindir) and renamed to foo. 
#
# For instance, say that the installed binary program $(bindir)/foo is
# supposed to read data from $(datarootdir)/bar by default. Upon build,
# however, data is not there and therefore it needs to be 

PROG_NAME="main.bin"
PROG_ARGS="-d scenes"

PROGRAM="$(dirname $0)/main.bin"

if [ -f "$PROGRAM" ]; then
    if [ -z "$1" ] ; then
	./$PROGRAM -d $PROG_ARGS
    else
	./$PROGRAM $1
    fi
else
    echo "Program not found."
    exit 1
fi
       
