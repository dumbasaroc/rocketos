.code32
.section .text
.global catchall_interrupt

catchall_interrupt:
    push %eax
    mov $0x20, %al
    out %al, $0x20  # acknowledge the interrupt to the PIC
    pop %eax
    iret
