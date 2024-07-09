<!--
   SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
  
   SPDX-License-Identifier: GPL-3.0-or-later

   This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
-->

 Conventions
 ==============================

 Unless otherwise explicitly annotated, the project documentation uses
 the following conventions.

 Numerical values and unities
 ------------------------------

 - Values in decimal base are denoted in their usual form as 1, 15, 42.
 
   Values in hexadecimal base are denoted with the prefix 0x, as in
   0x1, 0xF, 0x2F, or else by the suffix h, as in 1h, 2Ah.

   Values in binary are informally denote as a sequence of 0s and 1s
   when the base may be inferred by the context. Otherwise, they may
   be denoted with the prefix 0b, as in 0b10, 0b111000.

 - When referring to memory capacity, the symbols b is used to indicate
   a bit of information, while the symbols B and Byte are used to indicate
   an 8-bit byte. 

 - The symbols K, M, G etc. are used to denote the power-of-two multiples
   of a unit.

    E.g. 4 KBytes = 4 * 1024 Bytes.
    	 1 Gb = 1024 * 1024 b = 1048576 b = 100000h bits.

   When power-of-ten multipliers are eventually preferred, we'll resort to
   the alternative E-notation (see below).

   Background:

   In the context of digital transmission, the electrical engineering community
   usually follow the SI (International System of Units) convention, where the
   prefixes k, M, G etc. denote power-of-ten multipliers (10kb = 10*1000 bits).
   On the other hand, computer engineers and scientists, when referring to
   memory size, most often associate the prefixes with power-or-two multipliers
   (10kb = 10 * 1024 bits). This in congruence can be a source of confusion when
   reading equipment datasheets and technical manuals (e.g. it's not all rare
   that the capacity of a storage device be given in one way, and the data
   transfer rate in the other).

   To avoid the confusion, some references use the prefix Ki, Mi, Gi etc. to
   explicitly indicate the power-of-two multiplier [1] --- a proposal endorsed
   by several normative organizations. In this approach, rather than kilo, mega
   and giga, the alternative prefixes are called kibi, mibi and gibi, and so on.
   

   Our call is to assume the traditional power-of-two multiples that are familiar
   to most specialists and apprentices in the context of computer sciences and
   engineering. If we ever need to express a quantity using that multiple-of-ten
   unities, we will resort to the conventional E-notation like mEn, meaning
   m * 10^n (for instance, 5e3 = 5 * 10^3 = 5000). In Engineering context, it's
   often preferred to use multiple-of-tree exponents as those matches the SI
   multipliers, for example 5e3 V means 5 kV (5 thousand volts) in SI.

 [1] Binary prefix: https://en.wikipedia.org/wiki/Binary_prefix

 

