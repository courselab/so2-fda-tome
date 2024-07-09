#!/usr/bin/env bash

#    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

if ! md5sum -c docrypt.md5  ; then
   echo "docrypt invalid"
   exit 1
fi

if !  md5sum -c libauth.so.md5  ; then
   echo "libauth.so invalid"
   exit 1
fi

echo "All checks passed."
