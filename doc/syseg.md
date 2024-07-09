<!--
   SPDX-FileCopyrightText: 2021 Monaco F. J. <monaco@usp.br>
  
   SPDX-License-Identifier: GPL-3.0-or-later

   This file is part of SYSeg, available at https://gitlab.com/monaco/syseg.
-->

 SYSeg Manual
 ==============================

 TL;DR

- As part of an undergraduate scientific program at the university, the author
  did some research work at the institute of physics. There was this huge and
  intimidating high-tech precision measurement equipment that mainly resembled
  an alien artifact straight out of a sci-fi movie. On a stainless-steel tag
  attached to the device, a short, subtly ironic note, read:

  _After all solo assembling attempts have failed, read the instruction manual._

 Introduction
 ------------------------------

 SYSeg (System Software, _exempli gratia__) is a collection of source-code
 examples and programming exercises intended to illustrate general concepts
 and techniques related to system-software design and implementation. 

 The material has been compiled from class notes throughout teaching sessions
 in undergraduate and graduate courses in Computer Sciences and Engineering.
 It is meant as a companion learning resource for both students and instructors
 interested in low-level programming.

 SYSeg is distributed under the GNU General Public License version 3 or later.

 See file `AUTHORS` for contact information and the list of contributors.

 Quick start
 ------------------------------

 You are strongly encouraged to thoroughly read the entire content of this file.

 Anyway, if you need a short summary:

 - Set up SYSeg before start using it: see section 'Setup instructions' below.

 - To try the examples, refer to the file `README` in each subdirectory.
 
 - To try the exercises, do read the section 'Proposed exercises' below.
 
 - To contribute, refer to `CONTRIBUTING.md` in the root of the source tree.

 In case you are exploring SYSeg for teaching or as a self-learning tool, the
 author would be glad to know. If you could be so kind as sending an e-mail,
 that would be much appreciated.
 
 Essential Information
 ------------------------------

 Each subdirectory in the source tree has a file `README` which contains
 important instructions on how use the directory's contents. 

 If you find a file named `README.m4`, this is not the file you're looking
 for; it's a source file that is used by SYSeg be create the actual `README`.
 If you find the source `README.m4` file but not the corresponding `README`
 file in the same directory, chances are that you have missed the package
 configuration procedure described bellow. If so, please go through the
 step-by-step directions and proceed as explained below.

 Requirements
 ------------------------------
 
 SYSeg was designed to be executed on the GNU/Linux operating systems for the
 x86 hardware platform (aka the standard PC computer). Code examples should
 presumably work with other POSIX OSes on x86-based computers as well.
 
 WINDOWS AND MAC USERS
 
 There have been reports of users being able to try SYSeg either on Linux
 running in a virtual machine over Microsoft Windows, or on WSL (Windows
 Subsystem for Linux) --- although not always smoothly. None of those
 configurations have been systematically tested.  If you decide to try a
 setup like those, feedback will be much appreciated.
 
 The examples should work on MacOS too, according to a few accounts,
 specifically for x86-based computers. Low-level platform-dependent code
 specifically to i386 processors will not work as expected.
 
 If you decide to try a setup like those, feedback will be much appreciated.

 DEPENDENCIES

 In order to build and execute SYSeg code examples, the following pieces of
 software may be needed. Some are strictly required and should be installed
 in your system; others may be used only by some examples and their
 installation is optional, depending on the functionality you want to try.

 The SYSeg configuration scripts should guide you during the build procedure,
 and the instructions relative to each code example should also give further
 instructions.

 If a particular package is requested, the list bellow indicates the lowest
 version against which SYSeg examples have been tested. Using a more recent
 version should be fine, but it is not absolutely guaranteed that results
 won't exhibit (hopefully) minor variations. Feedback is always appreciated
 (feel free to open an issue at the official repository).

 It should be safe to use

 - Linux         5.13.0         (any decent ditribution)
 - Bash		 4.4-18		(most shell scripts need bash)
 - GCC 	     	 9.3.0	        (the GNU compiler)
 - GNU binutils  2.34		(GNU assembler, linker, disassembler etc.)
 - GNU coreutils 8.30		(basic utilities, probably already installed)
 - GNU make	 4.3		(build automation tool)
 - nasm		 2.14.02	(NASM assembler)
 - qemu		 4.2.1		(x86 emulator, specifically qemu-system-i386)
 - gcc-multilib  9.3.0		(to compile 16/32-bit code in a 64-bit platform)
 - xorriso	 1.5.2-1	(depending on your computer's BIOS)
 - hexdump	 POSIX.2	(binary editor)
 - meld		 3.20		(graphical diff tool, optional)
 - Git		 2.34.1		(some SYSeg scripts use git under the hood).
 - pipx		 1.0.0		(this dependence will eventually be deprecated)
 - reuse-tool    (see below)	(for REUSE/SPDX standard compliance)

 SYSeg uses the FSFE's REUSE helper tool. Currently, though, some of the desired
 features of reuse-tool are available only via a few patches. For convenience,
 this SYSeg release uses a custom version of the tool which can be installed
 from the SYSeg author's repository. The setup instructions described bellow
 should assist you in this procedure.

 Setup Instructions (IMPORTANT)
 ------------------------------
 
 Some examples in SYSeg need auxiliary artifacts which must be built 
 beforehand. To that end, follow this sequence of steps.

 1) Bootstrap the prject source.

 Skip this step if you have downloaded SYSeg as distribution bundle (usually 
 in the form of a compressed 'tar' archive file), rather than from its Git 
 repository.

 In case you have obtained SYSeg source from the its official VCS  (i.e. you 
 have cloned it from the mainstream Git repository), then execute the 
 following script, found at the top of the project's source tree:

 ```
  $ ./bootsrap.sh
 ```

 The script `bootstrap.sh` requires that you have the GNU build system, aka 
 Autotools, installed in your computer. In an apt-based Linux distribution,
 for instance, you may install Autotools with

```
 $ sudo apt install automake autoconf libtool
```

 On the other hand, if you have obtained the software in the form a
 pre-initialized distribution bundle, usually as a tarball, you should
 already have the  script `configure` pre-built and thus you will not need
 to recriate it.

 2) Execute the configuration script

 Perhaps you are already familiar with the GNU build system but, if not, no
 worries. The `configure` script is meant to check if your system meets all
 the requirements for building SYSeg. As a result, `configure` will create
 a customized build script that takes into account your compiler version,
 system libraries etc.
 
 Locate the script in the root of SYSeg source directory tree and execute it:

```
 $ ./configure
```

 This script shall perform a series of tests to collect data about the build 
 platform. If it complains about missing pieces of software, install them 
 as needed and rerun `configure`. The file `syseg.log` contains a summary
 of the last execution of the configuration script.

 3) Build and install SYSeg.

 Next, build the software with

```
 $ make
```

 Finally, install SYSeg in your computer:

```
 $make install
```

 This should install SYSeg auxiliary scripts, programs and data files under
 `$HOME/.syseg`. You won't need to add that location to the `PATH` environment
 variable, as the tools that need to access the resources in it will know
 where to find them. Do not build or install SYSeg as the `root` user, nor use
 `sudo` to perform those tasks.

 **Note** that, as mentioned, this procedure is intended to build the auxiliary
 tools needed by SYSeg. The examples and programming exercises themselves will
 not be built as result of the main build script being executed. The process of
 building the example code in each subdirectory is part of the skills that each
 example and implementation challenge is meant to illustrate. You will build
 each example manually, as part of the exercise itself.

 To build each example or programming exercise, one needs to access the
 subdirectory containing the respective source code and follow the instructions
 indicated in the corresponding `README` file (found in that respective
 subdirectory after you have built SYSeg as described.)

 The file `INSTALL` (that should exist after you have bootstrapped the project)
 contains detailed instruction on how to customize SYSeg build and installation.
 You'll only need to refer to this file if you have some special need to modify
 the build and install process (usually, that's not the case).

 SYSeg Contents
 -------------------------------

 The file `README.md`, at the top of SYSeg source tree, contains a summary of
 the project directory structured. In each individual sub-directory, there
 should be a file `README` further detailing its contents. Remember, you need
 to build SYSeg in order to generate the `README` files.

 Reusing SYSeg Code
 ------------------------------
 
 SYSeg is open source; you may freely reuse portions of it in your work.

 However, please take notice of the following directions.

 COPYRIGHT AND LICENSING LITERACY

 If you reuse third-party's source code in your own project, and modify that
 code, then, under the international copyright convention, you have created
 a 'derivative work'. The derivative work is now a production of multiple
 authors: the author(s) of the original code you copied, and you, who made
 changes to that work. Being your project a derivative work, you share its
 copyright with the copyright holder of the original work that you modified.

 (Side note: if you are developing your project under a work contract, then, 
 depending on its terms, it is possible that your contractor is entitled to
 claim the copyright. If in doubt, it is a good ideia to clarify with your 
 contractor.)
 
 The proper way to handle this shared rights is to keep any copyright
 and licensing notice present in the material, and add your name as an
 additional copyright holder. Also, bear in mind that you may only redistribute
 your derivative work in accordance with the license of the original work ---
 you may chose a different license, but this license must not conflict with the
 terms of the license under which the original work' is distributed (beware
 that the derivative work can then be redistributed under both licenses).
 
 To assist you in addressing these requirements, SYSeg offers a script that
 you can use to export files from SYSeg to your project. You can invoke the
 script like this

     tools/syseg-export <original-file> <destination-directory>

 The script will copy the original file into the destination directory
 and change the copyright notice (the comments at the top of the file)
 with the correct information. The script will also annotate the file
 with proper attribution for the original author.

 You can subsequently edit the information if you wish, for instance, to
 add the names of other authors (or they can add themselves through the
 same procedure, as described).

 Proposed Exercises
 ------------------------------
 
 In addition to code examples, SYSeg contains also some proposed implementation
 challenges which can be found in directory `syseg/try`.

 Users interested in practicing skills on system software design and
 implementation are encouraged to explore the programming exercises.

 Instructors are welcome, as well, to use SYSeg's exercises to teach their
 students. SYSeg provides some handy tools for this purpose, including
 scripts to prepare bootstrap code and directions to deliver the activities
 through a VCS repository.

 If you reuse SYSeg code in either your classes or implementation project, you
 are kindly invited to drop the author a message. It's always interesting to
 know who else is exploring the material.

 USING BOOTSTRAP CODE

 If the specification of a SYSeg programming exercise provides some bootstrap
 code for you to build upon, please, do not simply copy the individual files
 to your project. 

 Some examples and bootstrap code work in conjunction with other components of
 SYSeg and may require either that you modify the source or copy complementary
 files into your project --- if you don't, you may end up with incomplete or
 non-functional code.

 Moreover, as explained before, if you just copy the files, this may result
 in your project having legally misleading copyright and licensing information.

 Instead, proceed as indicated in the `README` file in respective directory.

 EXERCISE DEVELOPMENT WORKFLOW 

 Unless otherwise indicated, proceed as follow to prepare and deliver the 
 programming exercise.

 1) Set up the project directory.

 If asked to deliver your exercise as a Git repository, please clone it
 locally and follow these steps. 
 
 If your source tree is in `<project-dir>`, the command

    tools/syseg-project <some-path>/<project-dir>

 will set up a new project for you to solve the programming exercise. 
 
 The script should populate your source tree with scripts, data files, 
 documentation files and other resources required for the boilerplate 
 code to work from a stand-alone directory, outside the SYSeg source 
 directory tree. 

 The subdirectory `<project-dir>/.tools` will contain several tools which
 you are suposed to use while developing the implementation challenge.

 Please, read the complementary documentation in

      <project-dir>/.tools/readme.md

 for detailed directions on how to edit files and to deliver the project.

 2) Export the exercise

 Having completed the set up as described above, you should export the exercise
 source files into your project directory. You should repeat step 2 for every
 exercise you decide to try.

 If a given implementation exercise provides some bootstrap code for you
 to build upon, its specification will instruct you to export the code from
 SYSeg into your project directory using the aforementioned export facility.
 Usually, the directory containing the exercise will provide you with a
 Makefile implementing a rule specifically to assist you in this procedure.
 Withing the SYSeg exercise directory, run

  
      make export 
  
 The command should create a tarball within the current directory containing
 all the files relevant for that exercise. You should then copy/move the 
 tarball into your project directory and uncompress it there. This should
 create a subdirectory under `<project-dir>` with all source files.

 Enter the newly created subdirectory and develop the implementation challenge.

 3) Deliver the exercise

 This step applis in case SYSeg is used in an instruction program.

 The directions in the file `README` copied into your new exercise directory 
 will suggest you to deliver your work by committing your changes into your Git
 repository, and tagging it with a delivery identifier. If not otherwise
 specified by the instructor, use the tag name 'done' for the first delivery.
 If you need to submit a revised version, use the 'rev1',  'rev2' and so on.

 To deliver and tag your project:

 ```
   git add <relevant-files>
   git commit
   git push 
   git tag done
   git push origin done
 ```
 
 Conventions
 ------------------------------

 The file `doc/conventions.md` summarize some conventions used throughout
 the documentation and source code examples.

 Contributing
 ------------------------------
 
 Bug reports and suggestions are always welcome: feel free to open and issue
 at the version-control repository, or to contact the author directly.

 The file 'AUTHORS' lists all contributors and acknowledgments, with
 respective contact information.

 Should you like to contribute, please, refer to the file `CONTRIBUTING.md`.

 Licensing
 -----------------------------
 
 SYSeg (system-software, _exempli gratia_)
 Copyright (c) 2021 Monaco F. J. <monaco@usp.br>. 

 SYSeg is free software and can be distributed under the terms of GNU General
 Public License version 3 of the license or, at your discretion, any later 
 version. Third-party source files distributed along with SYSeg are made 
 covered by their respective licenses, as annotated in each individual file.

 See the terms of each license under the directory LICENSES. 

 Troubleshooting
 ------------------------------   
   
 If you ever find any trouble using SYSeg, consider the following tips.

* I can see a `README.m4` or a `Makefile.m4` file in a given directory,
    but can't find the corresponding `README` or `Makefile`.

    This probably happens because you've missed the installation instructions.
   
    To fix the issue:
   
    ```
    cd <path>/syseg
    ./bootstrap.sh
    ./configure
    make
    make install
    ```

    Do noty run the commands above as super user.


* I edited a `Makefile.m4`, a `README.m4` or other docm4 source and now
    I need to update the corresponding file.
 
   Within the directory containing the edited m4 source, invoke:
   
   ```
   make updatem4
   ```
   
* I tried everything to no avail.

    You're welcome to drop a message to the author or to open an issue
    at SYSeg repository.

