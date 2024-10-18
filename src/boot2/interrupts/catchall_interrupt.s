.code32
.section .text
.global catchall_interrupt

catchall_interrupt:
    cli
    movw $0x0641, 0xb8000
    hlt
