.code32
.section .text
.global kb_int

kb_int:
    push %eax    # make sure you don't damage current state
    in $0x60, %al   # read information from the keyboard

    mov $0x05, %ah
    movw %ax, 0xb8008
    xor %eax, %eax

    mov $0x20, %al
    out %al, $0x20  # acknowledge the interrupt to the PIC
    pop %eax     # restore state
    iret        # return to code executed before.
