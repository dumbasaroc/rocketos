#include "gdt_struct.h"

uint16_t generate_segment_selector(uint16_t index, uint8_t descriptor_table, uint8_t privilege)
{
    return 0x0;
}


void encode_gdt_entry(uint8_t* target, GDT_SegmentDescriptor* segment)
{
    // our limit cannot be larger than 0xFFFFF (20 bit number)
    if (segment->limit > 0xFFFFF) return;
    
    // encode 16 bottom bits of the limit
    *(target + 7) = segment->limit & 0x000FF;
    *(target + 6) = (segment->limit & 0x0FF00) >> 8;

    // encode bottom 16 bits of the base
    *(target + 5) = segment->base_address & 0x000000FF;
    *(target + 4) = (segment->base_address & 0x0000FF00) >> 8;

    // encode the next 8 bits of the base
    *(target + 3) = (segment->base_address & 0x00FF0000) >> 16;

    // Put in the access byte
    *(target + 2) = segment->access_byte;

    // using this 16-bit number as a pseudo buffer
    // ...encode the funny business that is the flags/limit 8 bits
    uint8_t buf = (segment->limit & 0xF0000) >> 16;
    buf |= segment->flags;
    *(target + 1) = buf;

    // and put in the last 8 bits of the base address
    *target = (segment->base_address & 0x0000FF00) >> 24;
}