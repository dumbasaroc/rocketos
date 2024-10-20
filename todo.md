BUGS
====

- ~~Can't load any files larger than one sector (ex. current kernel)~~
- ~~Kernel doesn't fully work on my bootloader, but does for OLS' bootloader~~
  - ~~Corrupted textures on the letters~~
- Doesn't support any disks besides floppy disk

TODO
====

- [x] Finish spriting letters
- [ ] Compact letter sprite data (move each row into a single byte)
- [x] Exit 16 bit mode
  - [x] Get memory map (low-data)
  - [ ] Get memory map (high-data)
  - [x] Write a global descriptor table for protected mode
  - [x] Write an interrupt descriptor table for protected mode
  - [x] Disable interrupts
  - [ ] Enable A20 line

KEYBOARD SUPPORT
================

- [ ] Add check bits for modifier keys (CTRL, SHIFT, ALT, CAPSLOCK)
  - [ ] alter outputted ascii with that