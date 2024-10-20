#include "stdint.h"
#include "stdout.h"

void run_boot2_c()
{
    clear_screen();

    for (uint8_t i = 0; i < 7; i++)
        for (char c = 'A'; c <= 'Z'; c++)
        {
            putc(c);
        }
    puts("             ");
    puts("hello world");
}