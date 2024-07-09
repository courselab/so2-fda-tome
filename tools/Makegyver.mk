#    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

## MakeGyiver is a boilerplate Makefile for automating the build process
## of simple projects written in C language meant to be built on a
## GNU/Linux platform. The script is capable of building executable
## binaries and libraries, and has handy rules for common tasks such
## as installation, creating distribution tarballs etc.
##
## Bear in mind that this script is in no way nearly as capable as GNU 
## Autotools, which one is strongly encouraged to rely on for more
## flexible, portable and feature-rich build automation. MakeGyver is
## a much simpler and less portable option if you just need a
## straightforward alternative for a quick setup.
##
## MakeGyver makes use of GNU make and GCC particular features and
## own extensions to regular standards which may not be available
## in all POSIX systems. MakeGyver should work with most GNU/Linux
## distributions, though.

## USAGE INSTRUCTIONS
## 
## a) Copy file Makegyiver.mk into the root of your project's directory tree.
## b) Create an empty file Makefile and edit it with the following contents:
##
## Define a variable 'bin' listing your project's binaries, e.g.
##
## bin = foo bar
##
## For each binary program foo, create a variable foo_obj lising the objects
## needed to build it. For instance
##
## foo_obj = foo1.o foo2.o
## bar_obj = bar1.o bar2.o


##############################################################
##
## MakeGyver rules.
## You probably do not need to edit beyond this line


ifndef bin
bin=
endif

## 
## Project flags & user flags
##

MKG_CPPFLGAS = $(CPP_FLAGS) $(CFLAGS)
MKG_CFLAGS   = $(C_FLAGS)   $(CFLAGS)
MKG_LDFLAGS  = $(LD_FLAGS)  $(LDFLAGS)

## Programs

CC=gcc
AR=ar
MAKE=make

# Second expansion necessary for $* to be available in the pre-requisite
# list. This is a GNU make extension.

.SECONDEXPANSION:

# Aggregates

objs = $(foreach i, $(bin:%=%_obj) $(lib:%=%_obj), $($i))
deps = $(objs:%.o=%.d)
libs = $(lib:%=%.a) $(lib:%=%.so)

# What we'll build by default.

all = $(bin) $(lib:%=%.a)

all: $(all)

# Binaires

$(bin) : % : $$($$*_obj) $$($$*_lib)
	$(CC) $(MKG_LDFLAGS)  $(filter %.o, $^) -o $@ -Wl,--push-state,--as-needed $($*_ldflags) $($*_lib:lib%=-l%) -Wl,--pop-state

#Objects

$(objs) : %.o : %.c
	$(CC) -fno-pic $(MKG_CPPFLAGS) $(MKG_CFLAGS)  $($*_cppflags) $($*_cflags) -c $< -o $@

$(objs:%.o=%-pic.o) : %-pic.o : %.c
	$(CC) -fpic $(MKG_CPPFLAGS) $(MKG_CFLAGS)  $($*_cppflags) $($*_cflags) -c $< -o $@

##
## Libraries
##

# MKGFLAGS=static : do not build shared libraries

ifneq (,$(filter static, $(MKGFLAGS)))
$(lib) : % : %.a 
else
$(lib) : % : %.a %.so
endif

$(lib:%=%.a) : %.a : $$($$*_obj)
	$(AR) rcs $*.a $(filter %.o, $^)



$(lib:%=%.so) : %.so : $$($$*_obj:.o=-pic.o)
	$(CC) --shared $(MKG_LDFLAGS) $($*_ldflags) $(filter %.o, $^) -o $@


#
# Header dependencies
#

# If make is invoked with no arguments, we update MAKECMDGOALS with
# the prerequisite of the default (all) rule so that we can decide
# whether or not to produce the dependencies files based on the
# selected targets.

ifeq (,$(MAKECMDGOALS))
MAKECMDGOALS=$(all)
endif

#ifeq (,$(filterout clean install uninstall, $(MAKECMDGOALS)))
ifneq (,$(filter $(bin) %.o, $(MAKECMDGOALS)))
include $(deps)
endif

%.d : %.c
	$(CC) $(MKG_CPPFLAGS) -MM -MT '$(<:%.c=%.o) $@' $< -o $@

# Housekeeping

.PHONY: clean

clean:
	rm -rf $(bin) $(objs) $(objs:%.o=%-pic.o) $(deps) $(libs) 
	rm -f $(LOCAL_CLEAN)

