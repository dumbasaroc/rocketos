#include "../stdout.h"

const uint8_t* GFX_START_PTR = (uint8_t*)0xb8000;

extern uint8_t cursor_x = 0;
extern uint8_t cursor_y = 0;
extern uint8_t color = 0x0f;

void putc(char c)
{
    uint8_t* ptr = GFX_START_PTR + 2*(SCREEN_WIDTH * cursor_y + cursor_x);
    *ptr = c;
    *(ptr + 1) = color;

    cursor_x++;
    if (cursor_x >= SCREEN_WIDTH)
    {
        cursor_x = 0;
        cursor_y++;
    }
}

void puts(const char* s)
{
    for (; *s; s++)
    {
        putc(*s);
    }
}

void clear_screen()
{
    for (uint8_t i = 0; i < SCREEN_WIDTH; i++)
    {
        for (uint8_t j = 0; j < SCREEN_HEIGHT; j++)
        {
            uint8_t* ptr = GFX_START_PTR + 2*(SCREEN_WIDTH * j + i);
            *ptr = 0;
            *(ptr + 1) = 0x0;
        }
    }
}

void printdbg()
{
    cursor_x = 0;
    cursor_y = 0;
    clear_screen();

    for (int i = 0; i < 16; i++)
    {
        for (int j = 0; j < 16; j++)
        {
            putc(i*16 + j);
        }
        cursor_x = 0;
        cursor_y++;
    }
}

void printb(uint8_t c)
{
    char hexnum[5];
    hexnum[0] = '0';
    hexnum[1] = 'x';

    uint8_t bottom_byte = c % 0x10;
    uint8_t top_byte = c / 0x10;

    if (bottom_byte < 0xa)
        hexnum[3] = bottom_byte + 0x30;
    else
        hexnum[3] = bottom_byte + 0x37;

    if (top_byte < 0xa)
        hexnum[2] = top_byte + 0x30;
    else
        hexnum[2] = top_byte + 0x37;
    
    puts(hexnum);
    cursor_x=0;
    cursor_y++;
}
