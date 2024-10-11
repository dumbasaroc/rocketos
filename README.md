# Rocket OS <!-- omit in toc -->

*An OS to teach myself low-level programming in x86*

This is a **very limited project!** See `todo.md` to see what is currently wrong with the OS (likely lots).

**Table of Contents**
- [Overview](#overview)
- [Building](#building)
  - [Dependencies (Arch Linux + AUR)](#dependencies-arch-linux--aur)
  - [Build Instructions](#build-instructions)

## Overview

This is an OS based quite heavily off of OliveStem's fantastic YouTube series on [x86 assembly in NASM](https://www.youtube.com/watch?v=yBO-EJoVDo0&list=PL2EF13wm-hWCoj6tUBGUmrkJmH1972dBB). It is, however, written in GNU Assembler language and compiled with GCC, AS, and LD to both conform to the Linux toolset and for added challenge.

## Building

### Dependencies (Arch Linux + AUR)

```
yay -Syu
yay -S i686-elf-binutils-bin i686-elf-gcc-bin qemu-full
```

### Build Instructions

Call `make build` to simply build the OS image, but not test it.

Call `make test` to run the OS image under QEMU.

Call `make debug` to set up a debugging session under QEMU for stepping through code in GDB.