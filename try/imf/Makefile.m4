dnl    SPDX-FileCopyrightText: 2024 Monaco F. J. <monaco@usp.br>
dnl   
dnl    SPDX-License-Identifier: GPL-3.0-or-later
dnl
dnl    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

include(docm4.m4)dnl

##
## Relevant rules.
## Update if necessary to solve the programming challenge.
##


## 
## Rules used by SYSeg.
## Not relevant for the example.
##

EXPORT_FILES = README Makefile decode libcry.so
EXPORT_NEW_FILES = NOTEBOOK
DOCM4_EXPORT([imf],[1.0.0])
DOCM4_UPDATE
