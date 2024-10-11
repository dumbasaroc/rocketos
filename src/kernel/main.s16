.code16
.global kernelenter

kernelenter:
    mov $19, %al
    mov $0, %ah
    int $0x10

    call cstart_

halt:
    jmp halt

