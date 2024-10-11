#include "stdint.h"
#include "stdio.h"
#include "../gfx/rect.h"

#define BLACK 0x0
#define BLUE 0x1
#define MAGENTA 0x5
#define YELLOW 0xE
#define WHITE 0xF

#define START 1

#define SCREENWIDTH 318
#define SCREENHEIGHT 198
#define PIXEL_WIDTH 2
#define PIXEL_HEIGHT 2

#define LETTER_WIDTH 4
#define LETTER_HEIGHT 6
#define LETTER_SPACE 2

uint8_t A_chr[] = {
    0, 1, 1, 0,
    1, 0, 0, 1,
    1, 1, 1, 1,
    1, 0, 0, 1,
    1, 0, 0, 1,
    1, 0, 0, 1
};

uint8_t B_chr[] = {
    1, 1, 1, 0,
    1, 0, 0, 1,
    1, 1, 1, 0,
    1, 0, 0, 1,
    1, 0, 0, 1,
    1, 1, 1, 0
};

uint8_t C_chr[] = {
    0, 1, 1, 1,
    1, 0, 0, 0,
    1, 0, 0, 0,
    1, 0, 0, 0,
    1, 0, 0, 0,
    0, 1, 1, 1
};

uint8_t D_chr[] = {
    1, 1, 1, 0,
    1, 0, 0, 1,
    1, 0, 0, 1,
    1, 0, 0, 1,
    1, 0, 0, 1,
    1, 1, 1, 0
};

void cstart_() {

    uint8_t* characters[] = { C_chr, A_chr, B_chr, A_chr, D_chr };
    uint8_t num_chars = 5;

    uint16_t x_ctr = START;
    for (int n = 0; n < num_chars; n++)
    {
        for (int i = 0; i < LETTER_WIDTH; i++)
        {
            for (int j = 0; j < LETTER_HEIGHT; j++)
            {
                RocketOS_DrawRect(x_ctr + i, START + j, 1, 1, WHITE*(characters[n][LETTER_WIDTH*j+i]));
            }
        }
        x_ctr += LETTER_WIDTH + LETTER_SPACE;
    }

    // uint16_t ctr = START;
    // int8_t dir = 1;

    // uint16_t i = START;
    // for (; i < SCREENWIDTH; i++)
    // {
    //     RocketOS_DrawRect(i, ctr, PIXEL_WIDTH, PIXEL_HEIGHT, WHITE);
    //     ctr += dir;
    //     if (ctr == SCREENHEIGHT - 1)
    //     {
    //         dir = -1;
    //     }
    //     if (ctr == START)
    //     {
    //         dir = 1;
    //     }
    // }
    // i = SCREENWIDTH - 1;
    // for (; i > START; i--)
    // {
    //     RocketOS_DrawRect(i, ctr, PIXEL_WIDTH, PIXEL_HEIGHT, BLUE);
    //     ctr += dir;
    //     if (ctr == SCREENHEIGHT - 1)
    //     {
    //         dir = -1;
    //     }
    //     if (ctr == START)
    //     {
    //         dir = 1;
    //     }
    // }
    // i = START;
    // for (; i < SCREENWIDTH; i++)
    // {
    //     RocketOS_DrawRect(i, ctr, PIXEL_WIDTH, PIXEL_HEIGHT, YELLOW);
    //     ctr += dir;
    //     if (ctr == SCREENHEIGHT - 1)
    //     {
    //         dir = -1;
    //     }
    //     if (ctr == START)
    //     {
    //         dir = 1;
    //     }
    // }
    // i = SCREENWIDTH - 1;
    // for (; i > START; i--)
    // {
    //     RocketOS_DrawRect(i, ctr, PIXEL_WIDTH, PIXEL_HEIGHT, MAGENTA);
    //     ctr += dir;
    //     if (ctr == SCREENHEIGHT - 1)
    //     {
    //         dir = -1;
    //     }
    //     if (ctr == START)
    //     {
    //         dir = 1;
    //     }
    // }
    
}