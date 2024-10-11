OUTPUT_FORMAT("binary")
ENTRY(bootstart)
MEMORY
{
    mem : ORIGIN = 0x00007C00, LENGTH = 0x200
}
SECTIONS
{
    .text : { *(.text) } > mem
    /DISCARD/ : {*(.note.gnu.property)}
}
