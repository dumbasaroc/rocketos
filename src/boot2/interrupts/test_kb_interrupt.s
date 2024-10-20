.code32
.section .text
.global kb_int

kb_int:
    push %eax    # make sure you don't damage current state
    in $0x60, %al   # read information from the keyboard

    cmp $0x80, %al
    jae release

down:
    and $0x000000ff, %eax
    push %eax
    call kb_int_c
    pop %eax

release:
    mov $0x20, %al
    out %al, $0x20  # acknowledge the interrupt to the PIC
    pop %eax     # restore state
    iret        # return to code executed before.
