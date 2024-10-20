.code16gcc
.section .text
.global boot2start

.extern catchall_interrupt

boot2start:
    mov $0x5000, %ax
    mov %ax, %sp
    mov %ax, %bp

    mov $0x0, %ah
    mov $0x2, %al
    int $0x10

    call gdt_setup
    call idt_setup

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

// .macro isr_err_stub i
// isr_stub_\i:
//     push %eax
//     call catchall_interrupt
//     mov $0x20, %al
//     out %al, $0x20  # acknowledge the interrupt to the PIC
//     pop %eax
//     iret
// .endm

// .macro isr_no_err_stub i
// isr_stub_\i:
//     push %eax
//     call catchall_interrupt
//     mov $0x20, %al
//     out %al, $0x20  # acknowledge the interrupt to the PIC
//     pop %eax
//     iret
// .endm

// .code32

// isr_no_err_stub 0
// isr_no_err_stub 1
// isr_no_err_stub 2
// isr_no_err_stub 3
// isr_no_err_stub 4
// isr_no_err_stub 5
// isr_no_err_stub 6
// isr_no_err_stub 7
// isr_err_stub    8
// isr_no_err_stub 9
// isr_err_stub    10
// isr_err_stub    11
// isr_err_stub    12
// isr_err_stub    13
// isr_err_stub    14
// isr_no_err_stub 15
// isr_no_err_stub 16
// isr_err_stub    17
// isr_no_err_stub 18
// isr_no_err_stub 19
// isr_no_err_stub 20
// isr_no_err_stub 21
// isr_no_err_stub 22
// isr_no_err_stub 23
// isr_no_err_stub 24
// isr_no_err_stub 25
// isr_no_err_stub 26
// isr_no_err_stub 27
// isr_no_err_stub 28
// isr_no_err_stub 29
// isr_err_stub    30
// isr_no_err_stub 31
// isr_no_err_stub 32
// isr_no_err_stub 33
// isr_no_err_stub 34
// isr_no_err_stub 35


.code32


.global isr_table
isr_table:
.rept 33
    .long catchall_interrupt
.endr
    .long kb_int        # interrupt 33
.rept 256-34
    .long catchall_interrupt
.endr



test_protected_mode:
    call setup_pic
    sti

    call run_boot2_c

    hlt

halt32:
    jmp halt32

.equ test_data, 0x410f
