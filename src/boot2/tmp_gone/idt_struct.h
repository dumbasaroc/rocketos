#pragma once
#include "stdint.h"
#include "gdt_struct.h"

typedef struct _idt_descriptor {
    uint32_t offset;
    uint16_t size;
} IDT_Descriptor;

typedef struct _gate_descriptor {
    uint32_t offset;
    SegmentSelector seg;
    uint8_t type_selector;
} Gate_Descriptor;

void encode_idt_entry(uint8_t* target, Gate_Descriptor* desc);
