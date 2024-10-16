#pragma once
#include "stdint.h"

typedef uint8_t* GlobalDescriptorTable;

typedef struct {
    uint32_t gdt_offset;
    uint16_t size;
} GDT_Descriptor;

typedef uint16_t SegmentSelector;

typedef struct {
    uint32_t base_address;
    uint32_t limit;

    /**
     * `7 [6---5] 4 3 2- 1- 0`
     * `P [ DPL ] S E DC RW A`
     * - P: Present bit. Allows an entry to refer to a valid segment. Must be set (1) for any valid segment.
     * - DPL: Descriptor privilege level field. Contains the CPU Privilege level of the segment. 0 = highest privilege (kernel), 3 = lowest privilege (user applications).
     * - S: Descriptor type bit. If clear (0) the descriptor defines a system segment (eg. a Task State Segment). If set (1) it defines a code or data segment.
     * - E: Executable bit. If clear (0) the descriptor defines a data segment. If set (1) it defines a code segment which can be executed from.
     * - DC: Direction bit/Conforming bit.
     *   -- For data selectors: Direction bit. If clear (0) the segment grows up. If set (1) the segment grows down, ie. the Offset has to be greater than the Limit.
     *   -- For code selectors: Conforming bit.
     *     --- If clear (0) code in this segment can only be executed from the ring set in DPL.
     *     --- If set (1) code in this segment can be executed from an equal or lower privilege level. For example, code in ring 3 can far-jump to conforming code in a ring 2 segment. The DPL field represent the highest privilege level that is allowed to execute the segment. For example, code in ring 0 cannot far-jump to a conforming code segment where DPL is 2, while code in ring 2 and 3 can. Note that the privilege level remains the same, ie. a far-jump from ring 3 to a segment with a DPL of 2 remains in ring 3 after the jump.
     * - RW: Readable bit/Writable bit.
     *   -- For data segments: Writeable bit. If clear (0), write access for this segment is not allowed. If set (1) write access is allowed. Read access is always allowed for data segments.
     *   -- For code segments: Readable bit. If clear (0), read access for this segment is not allowed. If set (1) read access is allowed. Write access is never allowed for code segments.
     * - A: Accessed bit. The CPU will set it when the segment is accessed unless set to 1 in advance. This means that in case the GDT descriptor is stored in read only pages and this bit is set to 0, the CPU trying to set this bit will trigger a page fault. Best left set to 1 unless otherwise needed.
     */
    uint8_t access_byte;
    uint8_t flags;
} GDT_SegmentDescriptor;

/**
 * Returns a segment selector (a 16 bit number)
 * with bits set correctly for the given index, table,
 * and permission level.
 * 
 * @param index A segment index between 0x0 and 0xFFFFFFFFFFFFF (i think?)
 * @param descriptor_table 0 if adding to the GDT, 1 if adding to the current
 * LDT
 * @param privilege Which ring (either 0 or 3, in our case) to place
 * the entry in.
 */
uint16_t generate_segment_selector(uint16_t index, uint8_t descriptor_table, uint8_t privilege);


void encode_gdt_entry(uint8_t* target, GDT_SegmentDescriptor* segment);
