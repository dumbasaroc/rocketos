OUTPUT_FORMAT("binary")
ENTRY(boot2start)
MEMORY
{
    mem : ORIGIN = 0x00000000, LENGTH = 0x400
}
SECTIONS
{
    .text : { *(.text) } > mem
    /DISCARD/ : {*(.note.gnu.property)}
}
