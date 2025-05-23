.code16

.section .text
.global RocketOS_DrawRect

RocketOS_DrawRect:
    # INPUTS:
    #   bp+6h: x
    #   bp+Ah: y
    #   bp+Eh: width
    #   bp+12h: height
    #   bp+16h: color

    push %bp
    mov %sp, %bp

    sub $0x10, %sp
    movw $0, -0x10(%bp) # max_x_ctr
    movw $0, -0xc(%bp)  # max_y_ctr
    movw $0, -0x8(%bp)  # x ctr
    movw $0, -0x4(%bp)  # y ctr

    mov 0x12(%bp), %ax
    mov %ax, -0x4(%bp) # sets y ctr
    mov %ax, -0xc(%bp)
    mov 0xe(%bp), %ax
    mov %ax, -0x8(%bp) # sets x ctr
    mov %ax, -0x10(%bp)
    mov 0x6(%bp), %dx
    mov 0xa(%bp), %cx
    mov 0x16(%bp), %si

    # DX (now X), CX (now Y), and SI (now color) will stay constant

draw_rect_row:
    mov -0x10(%bp), %ax
    mov %ax, -0x8(%bp)
    mov -0x4(%bp), %ax
    cmp $0, %ax
    je draw_rect_finish

draw_rect_col:
    mov -0x8(%bp), %ax
    cmp $0, %ax
    je draw_rect_finish_row

    mov -0x4(%bp), %ax
    add %cx, %ax # ensure height is 
    push %dx
    mov screen_width, %bx
    mul %bx
    pop %dx
    add %dx, %ax
    addw -0x8(%bp), %ax # ax now has pixel value
    mov %ax, %di # now di has it

    mov gfx_ptr, %ax
    mov %ax, %es
    mov %si, %bx
    mov %bl, %es:(%di)

    mov -0x8(%bp), %ax
    dec %ax
    mov %ax, -0x8(%bp)
    jmp draw_rect_col

draw_rect_finish_row:
    mov -0x4(%bp), %ax
    dec %ax
    mov %ax, -0x4(%bp)
    jmp draw_rect_row

draw_rect_finish:
    add $0x10, %sp
    mov %bp, %sp
    pop %bp
    ret

gfx_ptr: .2byte 0xa000
screen_width: .2byte 320
screen_height: .2byte 200
