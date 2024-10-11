.code16

.section .text
.global x86_Video_WriteCharTeletype
x86_Video_WriteCharTeletype:
    push %bp
    mov %sp, %bp

    push %bx

    mov 6(%bp), %al
    cmp $0xd, %al # is character newline?
    jne print_char

    mov $0xa, %al
    mov $0xe, %ah
    mov 10(%bp), %bh
    int $0x10

print_char:
    mov 6(%bp), %al
    mov 10(%bp), %bh
    mov $0xe, %ah

    int $0x10

    pop %bx

    mov %bp, %sp
    pop %bp
    ret

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
