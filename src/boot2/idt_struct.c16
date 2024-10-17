#include "idt_struct.h"


void encode_idt_entry(uint8_t* target, Gate_Descriptor* desc)
{
    // encode top bits of offset
    *target = (desc->offset & 0xFF000000) >> 24;
    *(target + 1) = (desc->offset & 0x00FF0000) >> 16;

    // encode type selector
    *(target + 2) = (0b10000000 | desc->type_selector);

    // put zeroes in the reserved section
    *(target + 3) = 0x0;

    // encode the segment selector
    *(target + 4) = (desc->seg & 0xFF00) >> 8;
    *(target + 5) = desc->seg & 0xFF;

    // encode the bottom bits of the offset
    *(target + 6) = (desc->offset & 0xFF00) >> 8;
    *(target + 7) = desc->offset & 0x00FF;
}
