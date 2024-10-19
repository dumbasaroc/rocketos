.code32
.section .text
.global setup_pic

# Lifted these defines and the following
# code (at least the idea of them) off of
# https://wiki.osdev.org/8259_PIC#Initialisation

ICW1_ICW4 = 0x01                /* Indicates that ICW4 will be present */
ICW1_SINGLE = 0x02              /* Single (cascade) mode */
ICW1_INTERVAL4 = 0x04           /* Call address interval 4 (8) */
ICW1_LEVEL = 0x08               /* Level triggered (edge) mode */
ICW1_INIT = 0x10                /* Initialization - required! */
ICW4_8086 = 0x01                /* 8086/88 (MCS-80/85) mode */
ICW4_AUTO =	0x02                /* Auto (normal) EOI */
ICW4_BUF_SLAVE = 0x08           /* Buffered mode/slave */
ICW4_BUF_MASTER = 0x0C          /* Buffered mode/master */
ICW4_SFNM = 0x10                /* Special fully nested (not) */

PIC1_DATA = 0x21
PIC1_COMMAND = 0x20
PIC2_DATA = 0xA1
PIC2_COMMAND = 0xA0

MASTER_PIC_OFFS = 0x20
SLAVE_PIC_OFFS = 0x28

.macro io_wait
push %eax
mov $0, %eax
outb %al, $0x80
pop %eax
.endm

setup_pic:
    push %eax

    xor %eax, %eax

    # Save PIC data from before init
    inb $PIC1_DATA, %al
    movb %al, mask_pic_1
    inb $PIC2_DATA, %al
    movb %al, mask_pic_2
    xor %eax, %eax

    # Begin initialization
    mov $ICW1_INIT, %al
    or $ICW1_ICW4, %al
    outb %al, $PIC1_COMMAND
    io_wait
    outb %al, $PIC2_COMMAND
    io_wait

    xor %al, %al

    # Set PIC Offsets
    # Master PIC
    movb $MASTER_PIC_OFFS, %al
    outb %al, $PIC1_DATA
    io_wait

    # Slave PIC
    movb $SLAVE_PIC_OFFS, %al
    outb %al, $PIC2_DATA
    io_wait

    # Set Cascade values
    movb $0x4, %al      # tell master that there is a slave pic
    outb %al, $PIC1_DATA
    io_wait

    movb $0x2, %al      # tell slave its cascade identity
    outb %al, $PIC2_DATA
    io_wait

    # use 8086 mode
    movb $ICW4_8086, %al      # tell master that there is a slave pic
    outb %al, $PIC1_DATA
    io_wait

    movb $ICW4_8086, %al      # tell slave its cascade identity
    outb %al, $PIC2_DATA
    io_wait

    # Return saved masks
    movb mask_pic_1, %al
    // or $1, %al
    outb %al, $PIC1_DATA
    movb mask_pic_2, %al
    outb %al, $PIC2_DATA

finish_setup_pic:
    pop %eax
    ret

mask_pic_1:
    .byte 0

mask_pic_2:
    .byte 0
