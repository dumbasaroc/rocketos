.code16gcc
.section .text
.global boot2start

.extern catchall_interrupt

boot2start:
    mov $0x5000, %ax
    mov %ax, %sp
    mov %ax, %bp

    mov %sp, %ax
    call print_hex

    call gdt_setup
    mov %sp, %ax
    call print_hex

    mov %sp, %ax
    sub $2, %ax
    mov %ax, %sp
    call print_hex

    call idt_setup

    mov $testprint, %si
    call print

    cli
    lgdt gdt_descriptor
    lidt idt_descriptor
    mov %cr0, %eax
    or $1, %eax
    mov %eax, %cr0

    jmp $0x8, $test_protected_mode

    hlt

halt:
    jmp halt

comment_thing:
# INPUTS
#   - ax: A 16 bit hex number to convert
# OUTPUTS
#   None (sets bits in hex_buffer)
conv_hex:
    push %ax
    push %bx
    push %cx
    push %dx

    xor %dx, %dx
    pushw $0
    mov $0x1000, %bx

conv_hex_loop:
    pop %cx
    push %cx
    cmp $4, %cx
    je conv_hex_finish

    div %bx # ax has numeral, dx has remainder
    cmp $0xa, %ax
    jl conv_hex_numeral

conv_hex_letter:
    add $0x37, %ax
    jmp conv_hex_loopfinish

conv_hex_numeral:
    add $0x30, %ax

conv_hex_loopfinish:
    pop %cx
    push %bx
    mov $hex_buffer, %bx
    add %cx, %bx
    mov %ax, (%bx)
    pop %bx
    shr $4, %bx
    inc %cx
    push %cx
    mov %dx, %ax
    xor %dx, %dx
    jmp conv_hex_loop

conv_hex_finish:
    pop %cx
    pop %dx
    pop %cx
    pop %bx
    pop %ax
    ret

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

print_hex:
    push %ax
    push %si

    mov $zero_x, %si
    call print

    call conv_hex
    mov $hex_buffer, %si
    call print

    mov $newline, %si
    call print

    pop %si
    pop %ax
    ret

// # Required statements for printing
zero_x:                     .asciz "0x"
hex_buffer:                 .byte 0, 0, 0, 0, 0
testprint:                  .asciz "TESTPRINT\r\n"
newline:                    .asciz "\r\n"


.macro isr_err_stub i
isr_stub_\i:
    push %eax
    call catchall_interrupt
    mov $0x20, %al
    out %al, $0x20  # acknowledge the interrupt to the PIC
    pop %eax
    iret
.endm

.macro isr_no_err_stub i
isr_stub_\i:
    push %eax
    call catchall_interrupt
    mov $0x20, %al
    out %al, $0x20  # acknowledge the interrupt to the PIC
    pop %eax
    iret
.endm

.code32

isr_no_err_stub 0
isr_no_err_stub 1
isr_no_err_stub 2
isr_no_err_stub 3
isr_no_err_stub 4
isr_no_err_stub 5
isr_no_err_stub 6
isr_no_err_stub 7
isr_err_stub    8
isr_no_err_stub 9
isr_err_stub    10
isr_err_stub    11
isr_err_stub    12
isr_err_stub    13
isr_err_stub    14
isr_no_err_stub 15
isr_no_err_stub 16
isr_err_stub    17
isr_no_err_stub 18
isr_no_err_stub 19
isr_no_err_stub 20
isr_no_err_stub 21
isr_no_err_stub 22
isr_no_err_stub 23
isr_no_err_stub 24
isr_no_err_stub 25
isr_no_err_stub 26
isr_no_err_stub 27
isr_no_err_stub 28
isr_no_err_stub 29
isr_err_stub    30
isr_no_err_stub 31
isr_no_err_stub 32
isr_no_err_stub 33
isr_no_err_stub 34
isr_no_err_stub 35

// .macro define_isr_stub_table i=0, m=31
// .long isr_stub_\i
// .if \m-\i
// define_isr_stub_table "(\i+1)", \m
// .endif
// .endm

.global isr_table
isr_table:
    .long isr_stub_0
    .long isr_stub_1
    .long isr_stub_2
    .long isr_stub_3
    .long isr_stub_4
    .long isr_stub_5
    .long isr_stub_6
    .long isr_stub_7
    .long isr_stub_8
    .long isr_stub_9
    .long isr_stub_10
    .long isr_stub_11
    .long isr_stub_12
    .long isr_stub_13
    .long isr_stub_14
    .long isr_stub_15
    .long isr_stub_16
    .long isr_stub_17
    .long isr_stub_18
    .long isr_stub_19
    .long isr_stub_20
    .long isr_stub_21
    .long isr_stub_22
    .long isr_stub_23
    .long isr_stub_24
    .long isr_stub_25
    .long isr_stub_26
    .long isr_stub_27
    .long isr_stub_28
    .long isr_stub_29
    .long isr_stub_30
    .long isr_stub_31
    .long isr_stub_32
    .long kb_int        # interrupt 33
    .long isr_stub_34
    .long isr_stub_35



test_protected_mode:
    call setup_pic
    sti

    addb $1, 0xb8001
    // movl $0x06420f41, 0xb8000
    hlt

halt32:
    jmp halt32

.equ test_data, 0x410f
