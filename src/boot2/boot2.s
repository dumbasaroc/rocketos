.code16
.section .text
.global boot2start

boot2start:
    call gdt_setup

    cli
    lgdt gdt_descriptor
    mov %cr0, %eax
    or $1, %eax
    mov %eax, %cr0

    jmp $0x8, $test_protected_mode


    hlt

halt:
    jmp halt

comment_thing:
    // # INPUTS
    // #   - ax: A 16 bit hex number to convert
    // # OUTPUTS
    // #   None (sets bits in hex_buffer)
    // conv_hex:
    //     push %ax
    //     push %bx
    //     push %cx
    //     push %dx

    //     xor %dx, %dx
    //     pushw $0
    //     mov $0x1000, %bx

    // conv_hex_loop:
    //     pop %cx
    //     push %cx
    //     cmp $4, %cx
    //     je conv_hex_finish

    //     div %bx # ax has numeral, dx has remainder
    //     cmp $0xa, %ax
    //     jl conv_hex_numeral

    // conv_hex_letter:
    //     add $0x37, %ax
    //     jmp conv_hex_loopfinish

    // conv_hex_numeral:
    //     add $0x30, %ax

    // conv_hex_loopfinish:
    //     pop %cx
    //     push %bx
    //     mov $hex_buffer, %bx
    //     add %cx, %bx
    //     mov %ax, (%bx)
    //     pop %bx
    //     shr $4, %bx
    //     inc %cx
    //     push %cx
    //     mov %dx, %ax
    //     xor %dx, %dx
    //     jmp conv_hex_loop

    // conv_hex_finish:
    //     pop %cx
    //     pop %dx
    //     pop %cx
    //     pop %bx
    //     pop %ax
    //     ret

    // print:
    //     push %si
    //     push %ax
    //     push %bx

    // print_loop:
    //     lodsb # loads a character from si and puts it in al
    //     or %al, %al # end at zero
    //     jz print_end

    //     mov $0x0e, %ah # print character in al to screen
    //     mov $0, %bh # page num
    //     int $0x10 # video interrupt

    //     jmp print_loop

    // print_end:
    //     pop %bx
    //     pop %ax
    //     pop %si
    //     ret

    // print_hex:
    //     push %ax
    //     push %si

    //     mov $zero_x, %si
    //     call print

    //     call conv_hex
    //     mov $hex_buffer, %si
    //     call print

    //     pop %si
    //     pop %ax
    //     ret

    // // # Required statements for printing
    // zero_x:                     .asciz "0x"
    // hex_buffer:                 .byte 0, 0, 0, 0, 0
    // // newline:                    .asciz "\r\n"



.code32

test_protected_mode:
    movl $0x06420f41, 0xb8000
    // mov $0x41, %al
    // mov $0x0f, %ah
    // mov %ax, 0xb8000
    hlt

halt32:
    jmp halt32

.equ test_data, 0x410f
