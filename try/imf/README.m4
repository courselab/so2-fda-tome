dnl    SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
dnl   
dnl    SPDX-License-Identifier: GPL-3.0-or-later
dnl
dnl    This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
dnl
dnl    >> Usage hint:
dnl
dnl       If you're looking for a file such as README or Makefile, then this one 
dnl       you are reading now is probably not the file you are interested in. This
dnl       and other files named with suffix '.m4' are source files used by SYSeg
dnl       to create the actual documentation files, scripts and other items they
dnl       refer to. If you can't find a corresponding file without the '.m4' name
dnl       extension in this same directory, then chances are that you have missed
dnl       the build instructions in the README file at the top of SYSeg's source
dnl       tree (yep, it's called README for a reason).

include(docm4.m4)

 Decode encrypted message
 ==============================

DOCM4_DIR_NOTICE

  Good evening Mr. Hunt.

  Along with this message, you should find a few software artifacts obtained
  from a confidential source by undisclosed means. While many details on the
  origin of the material is considered strictly classified, we are cleared to
  let you know that our Intelligence authority detected that the device can
  be used to intercept the communication of an untrusted organization. 

  Unfortunately, to effectively use the software which you now have access to
  requires evading a sophisticated access protection mechanism enforced by
  the organization. Having the ability to break in such security scheme is
  considered of utmost strategical importance by our agency.
 
  Your mission, should you accept it, is to reverse engineer the software
  fragment and provide an effective mechanism to circumvent the protection.

  Complementary technical information and directions to complete the task
  follow in the attached specifications.

  As always, should you or any of your team would be caught or killed, the
  Secretary will disavow any knowledge of your actions.

  While it is unlikely that this message self-destruct in five seconds, no
  one can really say for certain what else can happen in five seconds.
 

  Mission directions
  --------------------------------

  The Intelligence is informed that a computer program  is being used by a
  suspicious organization to obfuscate the communication between its members.
  Their security workflow requires that received messages be handled once
  within the organization's premises and then destroyed immediately, without
  any data or software file being transferred outside the facility. The network
  and operational protocols are heavily secured to detect any attempt to
  violate this directive.

  As the only resort, special maneuvers have been put to work to infiltrate
  an undercover agent withing the organization headquarters, who was granted
  access to the tool used to decrypt the messages. The agent, however, is not
  in possession of a secret key required to decipher the content.
  
  That is why your team is being called up. You are expected to propose a
  method to circumvent the security measures, and allow the agent to decode
  the intercepted communication.

  Naturally, as you must presume, your team's expertise would not be called
  forth if things were as simple as that.

  The target platform in the facility is secured by a mechanism that performs
  a hash-check verification of the program during its loading, and then
  denies the execution if the computed check does not match. This method
  rules out any practical possibility of replacing or modifying the program
  code.

  The only way to evade the protection is through a non-invasive intervention
  by exploiting some vulnerability in the software design, if any.

  To assist you with in this task, a copy of the program 'decode' is provided
  in this directory along with a sample encrypted message 'secret.cry'.
  Briefly, the program requests an access token which, if valid, will allow
  the message to be decoded. The encryption keys and access credentials used
  by the program are provided by the library 'libcry.so'.

  Extracting information from the library is of no practical use, since the
  file is updated in a regular basis; the sample we have is an obsolete
  version obtained via channels that are no longer available. Our undercover
  agent will not have access to the library directory. 

  As an additional measure, the library will detect if 'decode' is modified
  by computing it's hash code and comparint it against the known value.

  If you can successfully decrypt the sample message under the given
  restrictions, then the undercover agent will be able to reproduce the
  operation from within the organization's facility.
  
  For the mission to be considered accomplished, the tactical unity expects
  that you provide any needed artifact and that you update the Makefile
  accordingly.

  Please, annotate your interventions in the file NOTEBOOK, describing your
  steps and how the undercover agend is supposed to use your hack. Also,
  explain how you explited any design or implementation vulnerability, and
  instruct us on how to avoid them in our own systems.


  Ethan, good luck.



