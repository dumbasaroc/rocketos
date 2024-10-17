.code16
.global bootstart

bootstart:
    jmp bootcode
    nop

###
# BIOS PARAMETER BLOCK
###

# OEM Identifier - not really necessary
oem_ident:              .ascii "MSWIN4.1"

# These two values specify the size of
# a cluster to be 2KiB
n_bytes_per_sector:     .2byte 512
n_sectors_per_cluster:  .byte 1
n_reserved_sectors:     .2byte 1
n_fat_tables:           .byte 2

# Number of directory entries =
#  number root dir sectors * sector size /
#       32
#
# (WHY DOES 0xE0 WORK HERE)
n_root_dir_entries:     .2byte 0xe0

# 512 Bytes * 2880 sectors = ~14K bytes
#   = floppy disk
n_sectors_total:        .2byte 2880

# Defines our disk type:
# - 80 tracks per side
# - 18 or 36 sectors per track
media_descriptor_type:  .byte 0xf0

n_sectors_per_fat:      .2byte 9
n_sectors_per_track:    .2byte 18
n_heads:                .2byte 2
n_hidden_sectors:       .4byte 0
large_sector_count:     .4byte 0

###
# EXTENDED BOOT RECORD
###

drive_number:           .byte 0
                        .byte 0
ebr_signature:          .byte 0x28
disk_serial_number:     .byte 0x12, 0x23, 0x34, 0x45
disk_label:             .ascii "ROCKETOS   "
disk_format:            .ascii "FAT12   "

## Actual bootloader

bootcode:
    mov $0, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %ss    
    mov $0x7c00, %sp # sets stack pointer to application code

    mov $19, %ax
    mov $0, %bx
    mov %bx, %es
    mov $buffer, %bx

    call read_disk

    # we're going to find BOOT2.BIN now
    pushl $buffer

find_boot2:
    pop %bx

    mov (%bx), %ax
    test %ax, %ax
    jz did_not_find_boot2

    mov $secondstage_filename, %si
    mov $11, %cx # size of file name
    mov %bx, %di
    push %bx
    repe cmpsb
    pop %bx
    je found_boot2

    add $32, %bx

    push %bx
    jmp find_boot2

found_boot2:
    mov $found_boot2_msg, %si
    call print

    # get the disk location of the file
    # and set up the place we want to put stuff
    mov %bx, %di # di now has the location in the buffer
    mov 26(%di), %ax # this is the cluster to get data from
    mov %ax, boot2_cluster

    # load something silly into buffer
    mov n_reserved_sectors, %ax
    mov $buffer, %bx
    mov n_sectors_per_fat, %cl
    mov drive_number, %dl

    call read_disk

    # not included currently, but 28(%di) would give the 4 byte size
    # of the file
    mov $boot2_memory_segment, %bx
    mov %bx, %es
    mov $boot2_memory_offset, %bx

load_second_stage:
    mov boot2_cluster, %ax
    add $31, %ax # any offset is 31 sectors ahead of where i think it is
    // mov $1, %cl # number of sectors to read
    mov drive_number, %dl

    call read_disk

    add n_bytes_per_sector, %bx

load_second_stage_find_next_cluster:
    mov boot2_cluster, %ax
    mov $3, %cx
    mul %cx
    mov $2, %cx
    div %cx # boot2_cluster * 3 / 2 = next cluster loc

    mov $buffer, %si
    add %ax, %si
    mov %ds:(%si), %ax

    or %dx, %dx
    jz load_second_stage_even

load_second_stage_odd:
    shr $4, %ax
    jmp load_second_stage_load_next_cluster

load_second_stage_even:
    and $0x0fff, %ax

load_second_stage_load_next_cluster:
    cmp $0x0ff8, %ax
    jae finish_second_stage

    mov %ax, boot2_cluster
    jmp load_second_stage

finish_second_stage:
    # that should place things at the correct offset
    mov drive_number, %dl
    mov $boot2_memory_segment, %ax
    mov %ax, %ds
    mov %ax, %es

    ljmp $boot2_memory_segment, $boot2_memory_offset

    jmp halt

did_not_find_boot2:
    mov $no_find_boot2, %si
    call print
    hlt

halt:
    jmp halt


# Inputs:
#   - AX: LBA index
read_disk:
    push %ax
    push %bx
    push %cx
    push %dx
    push %di

    # sets dx and cx correctly
    call lba_to_chs

    xor %ax, %ax
    mov $0x2, %ah
    mov $0x1, %al

    stc
    int $0x13
    jc failure

    pop %di
    pop %dx
    pop %cx
    pop %bx
    pop %ax
    ret

failure:
    jmp halt


# INPUT:
#   AX: LBA index
# OUTPUT
#   CX[bits 0-5]: sector number
#   CX[bits 6-15]: cylinder
#   DH: head
lba_to_chs:
    push %ax
    push %dx

    xor %dx, %dx
    divw n_sectors_per_track # LBA % sectors_per_track + 1 = sector
    # ax has division, dx has modulus
    inc %dx # sector!
    mov %dx, %cx

    # head: ax % num heads
    # cylinder: ax / num_heads
    xor %dx, %dx
    divw n_heads

    mov %dl, %dh # head
    mov %al, %ch
    shl $6, %ah
    or %ah, %cl # cylinder

    pop %ax
    mov %al, %dl
    pop %ax
    ret


// # INPUT:
// #   AX: LBA index
// # OUTPUT
// #   CX[bits 0-5]: sector number
// #   CX[bits 6-15]: cylinder
// #   DH: head
// lba_to_chs:
//     push %ax
//     push %dx

//     xor %cx, %cx
//     xor %dx, %dx

//     divw n_sectors_per_track # ax has division, dx has modulo

//     # dx has sector number - 1, inc and put into
//     # cx
//     inc %dx
//     mov %dl, %cl
//     xor %dx, %dx

//     divw n_heads # ax has cylinder, dl has head
//     mov %dl, %dh # but dh should have it

//     shl $6, %ax
//     and $0xffe0, %ax
//     add %ah, %ch

//     pop %ax
//     mov %al, %dl
//     pop %ax
//     ret


print:
    push %si
    push %ax
    push %bx

print_loop:
    lodsb # loads a character from si and puts it in al
    or %al, %al # end at zero
    jz print_end

    mov $0x0e, %ah # print character in al to screen
    mov $0, %bh # page num
    int $0x10 # video interrupt

    jmp print_loop

print_end:
    pop %bx
    pop %ax
    pop %si
    ret


secondstage_filename:   .ascii "BOOT2   BIN"
no_find_boot2:          .asciz "Could not find boot2.bin.\r\n"
found_boot2_msg:        .asciz "Found BOOT2.BIN!\r\n"

.equ boot2_memory_segment, 0x0
.equ boot2_memory_offset, 0x8800
boot2_cluster:          .2byte 0

.zero 510-(.-bootstart)
.2byte 0xaa55

buffer:
