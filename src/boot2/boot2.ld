OUTPUT_FORMAT("binary")
ENTRY(boot2start)
MEMORY
{
    mem : ORIGIN = 0x00008800, LENGTH = 0x2000
}
SECTIONS
{
    .text : { *(.text) } > mem
    /DISCARD/ : {*(.note.gnu.property)}
}
