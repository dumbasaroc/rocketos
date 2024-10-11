#include "stdio.h"
#include "stdio/print.h"
#include "stdio/getchar.h"

void putc(char c)
{
    x86_Video_WriteCharTeletype(c, 0);
}

void puts(const char* str)
{
    while (*str)
    {
        putc(*str);
        str++;
    }
}

char getc()
{
    return x86_GetCharacterInterrupt();
}
