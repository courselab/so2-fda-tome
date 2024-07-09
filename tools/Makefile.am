#    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

AM_CPPFLAGS = @CPP_FLAGS@ -DDATADIR=\"${datarootdir}\"
AM_CFLAGS =   @C_FLAGS@ 
AM_LDFLAGS =  @LD_FLAGS@   

# SYSeg resources are meant to be installed locally in a per-use basis.

#bindir=$$HOME/.syseg/bin

noinst_bindir="$$HOME/.syseg/bin"

noinst_bin_PROGRAMS = hex2bin bin2hex cpimg 

hex2bin_SOURCES = hex2bin.c debug.h
bin2hex_SOURCES = bin2hex.c debug.h

cpimg_SOURCES = cpimg.c
cpimg_CPPFLAGS = -Wno-unused-result

syseg_SOUCES = syseg.c debug.h

noinst_bin_SCRIPTS = syseg-newfile syseg-export syseg-reuse syseg-project


install-exec-local:
	install -d $(noinst_bindir)
	for f in $(noinst_bin_PROGRAMS); do install $$f $(noinst_bindir); done
#	install $(top_srcdir)/.local/bin/reuse $(noinst_bindir)

uninstall-local:
	for f in $(noinst_bin_SCRIPTS); do rm -f $(DESTDIR)$(noinst_bindir)/$$f; done


#lib_LTLIBRARIES = libsyseg.la
#libsyseg_la_SOURCES = syseg.c
#libsyseg_la_LDFLAGS = -version-info "0:1:0"

EXTRA_DIST = syseg-export  syseg-newfile  syseg-reuse syseg-project docm4.m4 bintools.m4 docm4.m4 docm4.am

# Wrapper execution script
#
# bin_PROGRAMS += main.bin 
# main_bin_SOURCES = main.c 
# bin_SCRIPTS += main
#
# main: main.sh
# 	cp $< $@
#
# clean-local:
# 	rm -f main
#
# install-exec-hook: 
# 	cd $(DESTDIR)/$(bindir) && mv main.bin main
#
# uninstall-hook:
# 	rm -f $(DESTDIR)/$(bindir)/main
#
# EXTRA_DIST += main.sh

#doc:

