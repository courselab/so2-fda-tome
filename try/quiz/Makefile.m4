dnl    SPDX-FileCopyrightText: 2024 Monaco F. J. <monaco@usp.br>
dnl   
dnl    SPDX-License-Identifier: GPL-3.0-or-later
dnl
dnl    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

include(docm4.m4)dnl

all : p1 p2 p3 p4-v1 p4-v2 p4-v3

p1 : p1.c
	gcc -m32 $< -o $@

p2 : p2.c
	gcc -Wall -m32  -O0 -fno-stack-protector -fno-pic -fno-pie -Wl,-no-pie $(CFLAGS) $<  -o $@

p3 : p3.c
	gcc -Wall -m32  -O0  -fno-pic -fno-pie -Wl,-no-pie $< -o $@

p4-v1 : p4.o p4a.c p4b.o
	gcc -m32 $^ -o $@

p4-v2 : p4.o libp4.a
	gcc -m32 $< -L. -Wl,-Bstatic -lp4 -Wl,-Bdynamic -o $@

p4-v3 : p4.o libp4.so
	gcc -m32 $< -L. -lp4 -o $@

p4.o p4a.o p4b.o : %.o : %.c
	gcc -m32 -c $< -o $@

libp4.a : p4a.o p4b.o
	ar rcs $@ $^

libp4.so : p4a.o p4b.o
	gcc -m32 --shared $^ -o $@

.PHONY: clean

clean:
	rm -f *.o p1 p2 p3 *.a *.so p4-v1 p4-v2 p4-v3


## Makefile automation rules.
##
## SYSeg creates and automatically updates this Makefile from the source 
## Makefile.m4 template, so as to reflect changes in the project's design
## and auxiliary resources. The next rules serve this purpose and are not 
## relevant for the code examples in this directory.

DOCM4_UPDATE

dnl
dnl Uncomment to include bintools
dnl
dnl
DOCM4_BINTOOLS
EXPORT_FILES = Makefile README p1.c p2.c p3.c p4.c p4a.c p4b.c
EXPORT_NEW_FILES = NOTEBOOK
DOCM4_EXPORT([quiz],[1.0.0])
