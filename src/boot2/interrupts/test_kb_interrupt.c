#include "stdint.h"
#include "stdout.h"
#include "hardware/ps2keyboard/kb.h"

void kb_int_c(char c)
{
    putc(ascii_from_scancode(c));
}