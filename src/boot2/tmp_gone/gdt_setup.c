#include "gdt_struct.h"
#include "idt_struct.h"

#define GDT_SIZE 24

#define CODE_SEGMENT 0x5000
#define CODE_LIMIT   0xFFF
#define DATA_SEGMENT 0x6000
#define DATA_LIMIT   0xFFF

uint8_t global_descriptor_table[GDT_SIZE];
GDT_Descriptor gdt_descriptor;

void idt_setup() {
    // Set up IDT entries
}

void gdt_setup() {
    // ensure everything is zeroed out
    for (int i = 0; i < GDT_SIZE; i++)
        global_descriptor_table[i] = 0x0;
    
    GDT_SegmentDescriptor seg;

    // Define kernel code segment
    seg.base_address = CODE_SEGMENT;
    seg.access_byte = 0b10011010;
    seg.flags = 0b1100;
    seg.limit = CODE_LIMIT;

    encode_gdt_entry(global_descriptor_table + 8, &seg);

    // Define a data segment (for now, kernel level access)
    seg.base_address = DATA_SEGMENT;
    seg.access_byte = 0b10010010;
    seg.flags = 0b0100;
    seg.limit = DATA_LIMIT;

    encode_gdt_entry(global_descriptor_table + 16, &seg);
    
    // // Define a task state segment (whatever that means)
    // seg.base_address = 0x0;
    // seg.access_byte = 0x0;
    // seg.flags = 0x0;
    // seg.limit = 0x0;

    // encode_gdt_entry(global_descriptor_table + 24, &seg);

    // Does the Interrupt Descriptor Table live here too?

    // ... after all that, put data in the GDT descriptor, then
    // load the GDT into the computer
    gdt_descriptor.gdt_offset = &global_descriptor_table;
    // This describes the size of the GDT table in bytes subtracted by 1
    gdt_descriptor.size = GDT_SIZE - 1;

    // [LOAD GDT COMMAND HERE]
}
