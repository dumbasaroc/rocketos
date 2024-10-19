#pragma once
#include "stdint.h"

#define IDT_32BIT_TRAP_GATE 0b1111
#define IDT_32BIT_INTERRUPT_GATE 0b1110

#define IDT_RING0 0x0
#define IDT_RING3 0x3

typedef struct _idt_descriptor {
    uint16_t size;
    uint32_t offset;
} __attribute__((__packed__)) IDT_Descriptor;

typedef struct _gate_descriptor {
    uint32_t offset;
    uint16_t seg;
    uint8_t type_selector;
} Gate_Descriptor;

void encode_idt_entry(uint8_t* target, Gate_Descriptor* desc);

extern void catchall_interrupt();
