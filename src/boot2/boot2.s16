.code16
.section .text
.global boot2start
CODE_SEGMENT = code_descriptor - GDT_Start
DATA_SEGMENT = data_descriptor - GDT_Start

boot2start:
    mov $GDT_Start, %eax
    // add $0x10000, %eax
    // mov %eax, GDT_Descriptor_start

    call print_hex

    shr $16, %eax
    call print_hex

    cli
    lgdt GDT_Descriptor
    mov %cr0, %eax
    or $1, %eax
    mov %eax, %cr0

    jmp $CODE_SEGMENT, $test_protected_mode


    hlt

halt:
    jmp halt

GDT_Start:
    null_descriptor:
        .quad 0x0
    
    code_descriptor:
        .word 0xffff
        .word 0
        .byte 0
        .byte 0b10011010
        .byte 0b11001111
        .byte 0
    
    data_descriptor:
        .word 0xffff
        .word 0
        .byte 0
        .byte 0b10010010
        .byte 0b11001111
        .byte 0
GDT_End:

GDT_Descriptor:
    .word GDT_End - GDT_Start
GDT_Descriptor_start:
    .long GDT_Start

# INPUTS
#   - ax: A 16 bit hex number to convert
# OUTPUTS
#   None (sets bits in hex_buffer)
conv_hex:
    push %ax
    push %bx
    push %cx
    push %dx

    pushw $0
    mov $0x1000, %bx

conv_hex_loop:
    // push %si
    // mov $loopthing, %si
    // call print
    // pop %si

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

    pop %si
    pop %ax
    ret

// print_nl:
//     push %si

//     mov $newline, %si
//     call print

//     pop %si
//     ret

// memory_text:                .asciz "Total continuous memory: "
// memory_text_suffix:         .asciz " KB\r\n"

// # Required statements for printing
zero_x:                     .asciz "0x"
hex_buffer:                 .byte 0, 0, 0, 0, 0
// newline:                    .asciz "\r\n"


.code32

test_protected_mode:
    movw $0x0f41, 0xb8000
    // mov $0x41, %al
    // mov $0x0f, %ah
    // mov %ax, 0xb8000
    hlt

halt32:
    jmp halt32

.equ test_data, 0x410f
