.code16

.section .text
.global x86_GetCharacterInterrupt
x86_GetCharacterInterrupt:
    push %bp
    mov %sp, %bp

    xor %ax, %ax
    int $0x16
    # AH is the scancode
    # AL is the ascii character
    xor %ah, %ah

    mov %bp, %sp
    pop %bp
    ret
