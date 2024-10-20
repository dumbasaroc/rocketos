#include "../stdout.h"

extern uint8_t cursor_x = 0;
extern uint8_t cursor_y = 0;
extern uint8_t color = 0x0f;

void putc(char c)
{
    uint8_t* ptr = 0xb8000 + 2*(SCREEN_WIDTH * cursor_y + cursor_x);
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
            uint8_t* ptr = 0xb8000 + 2*(SCREEN_WIDTH * j + i);
            *ptr = 0;
            *(ptr + 1) = 0x0;
        }
    }
}
