#!/bin/sh

#    SPDX-FileCopyrightText: 2021 Monaco F. J <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

# If you have obtained the software from the Git repository.Run this script
# from the root of the source tree to bootstrap the build system locally. 
# You won't probably need to do it if you have obtained the software from
# a pre-initialized distribution bundle (see doc/syseg.md for further info).

RECOMMENDED_FILES="AUTHORS NEWS ChangeLog" 

REQUIRED_PROGRAMS="autoconf automake libtoolize m4"

for i in $REQUIRED_PROGRAMS; do
    if test -z "$(which $i)" ; then
	echo "*** Required program '$i' not found."
	echo "    To install it, e.g. in an apt-based distribution:"
	echo "    $ sudo apt install $i"
	exit 1
    fi
done

AUTORECONF=$(which autoreconf)
if test -z "$AUTORECONF"; then
  echo "Program autoreconf not found"
  exit 1
fi


echo "Bootstrapping project..."

for i in $RECOMMENDED_FILES; do
    if test ! -f "$i" ; then 
	touch "$i"
    fi
done

$AUTORECONF --install 

# grep -nri "# INSTALL by Automake" .reuse/dep5 > /dev/null
# has_install=$?

# if test $has_install -ne 0; then

#     echo "Adding INSTALL license"

#     cat<<EOF >> .reuse/dep5
# # INSTALL by Automake

# Files: INSTALL
# Copyright: 1994-1996, 1999-2002, 2004-2017, 2020-2021 Free Software Foundation, Inc.
# License: LicenseRef-INSTALL

# EOF
# fi

# if ! ls LICENSES/LicenseRef-INSTALL.txt 2> /dev/null; then
    
#     cat<<EOF > LICENSES/LicenseRef-INSTALL.txt
#     Copying and distribution of this file, with or without modification,
#     are permitted in any medium without royalty provided the copyright
#     notice and this notice are preserved.  This file is offered as-is,
#     without warranty of any kind.
# EOF
    
    
# fi


# Provisional procedure to install custom version of REUSE helper tool.
# Eventually, when it's possible to install the mainstream version
# this step shall be addressed by the autoconf script.

if ! test -f "$HOME/.syseg/bin/reuse" ; then
    
    cat <<EOF

    FSFE's REUSE helper tool is required for successfully building SYSeg.

    As of the time this build script was prepared, some of the desired 
    features of reuse-tool are available only via a few patches. As a 
    temporary workaround, for your convenience, this SYSeg release uses 
    a custom pre-patched version of the tool which can be installed from 
    the SYSeg author's repository. This script should install a local copy 
    of the reuse-tool within $HOME/.syseg, with the executable located 
    at $HOME/.syseg/bin (this custom version should not conflict with any 
    global/system-wide REUSE installation, if one exists in your system; 
    if the install script warns you about updating your PATH environment 
    variable, you may safely ignore it.)

EOF
    printf "    Confirm to install REUSE tool locally (y|N): "
    
    read opt
    echo
    if test "$opt" != "y" && test "$opt" != "Y"; then
	echo "    Aborted."
	exit 0
    fi

    if test -z "$(which pipx)"; then
	echo
	echo " ** Tool pipx is needed; please install it and rerun this script."
	echo "    E.g. for apt-based install:  apt install pipx"
	exit 1
    fi

    tools/install-reuse

fi
