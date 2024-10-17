OUTPUT_FORMAT("binary")
ENTRY(kernelenter)
MEMORY
{
    app : ORIGIN = 0x00008800, LENGTH = 0x1000
}
SECTIONS
{
    .text : { *(.text) } > app
    .data : { *(.data) } > app
    .rodata : { *(.rodata) } > app
    /DISCARD/ : {*(.note.gnu.property)}
}
