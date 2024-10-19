.code32
.section .text
.global catchall_interrupt

catchall_interrupt:
    addb $1, 0xb8001
    ret
