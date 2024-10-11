#include "stdint.h"
#include "stdio.h"
#include "../gfx/rect.h"
#include "../gfx/letters.h"

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

void cstart_() {

    /// @todo doesn't work under Roc bootloader
    // uint8_t* characters[] = { A_chr, B_chr, C_chr, D_chr, E_chr, F_chr, G_chr, O_chr, R_chr, ZERO_chr };
    // uint8_t num_chars = 10;

    // uint16_t x_ctr = START;
    // for (int n = 0; n < num_chars; n++)
    // {
    //     for (int i = 0; i < LETTER_WIDTH; i++)
    //     {
    //         for (int j = 0; j < LETTER_HEIGHT; j++)
    //         {
    //             RocketOS_DrawRect(x_ctr + i, START + j, 1, 1, WHITE*(characters[n][LETTER_WIDTH*j+i]));
    //         }
    //     }
    //     x_ctr += LETTER_WIDTH + LETTER_SPACE;
    // }

    // uint8_t* characters_2[] = { R_chr, O_chr, C_chr };
    // num_chars = 3;

    // x_ctr = START;
    // for (int n = 0; n < num_chars; n++)
    // {
    //     for (int i = 0; i < LETTER_WIDTH; i++)
    //     {
    //         for (int j = 0; j < LETTER_HEIGHT; j++)
    //         {
    //             RocketOS_DrawRect(x_ctr + i, 40 + j, 1, 1, WHITE*(characters_2[n][LETTER_WIDTH*j+i]));
    //         }
    //     }
    //     x_ctr += LETTER_WIDTH + LETTER_SPACE;
    // }

    uint16_t ctr = START;
    int8_t dir = 1;

    uint16_t i = START;
    for (; i < SCREENWIDTH; i++)
    {
        RocketOS_DrawRect(i, ctr, PIXEL_WIDTH, PIXEL_HEIGHT, WHITE);
        ctr += dir;
        if (ctr == SCREENHEIGHT - 1)
        {
            dir = -1;
        }
        if (ctr == START)
        {
            dir = 1;
        }
    }
    i = SCREENWIDTH - 1;
    for (; i > START; i--)
    {
        RocketOS_DrawRect(i, ctr, PIXEL_WIDTH, PIXEL_HEIGHT, BLUE);
        ctr += dir;
        if (ctr == SCREENHEIGHT - 1)
        {
            dir = -1;
        }
        if (ctr == START)
        {
            dir = 1;
        }
    }
    i = START;
    for (; i < SCREENWIDTH; i++)
    {
        RocketOS_DrawRect(i, ctr, PIXEL_WIDTH, PIXEL_HEIGHT, YELLOW);
        ctr += dir;
        if (ctr == SCREENHEIGHT - 1)
        {
            dir = -1;
        }
        if (ctr == START)
        {
            dir = 1;
        }
    }
    i = SCREENWIDTH - 1;
    for (; i > START; i--)
    {
        RocketOS_DrawRect(i, ctr, PIXEL_WIDTH, PIXEL_HEIGHT, MAGENTA);
        ctr += dir;
        if (ctr == SCREENHEIGHT - 1)
        {
            dir = -1;
        }
        if (ctr == START)
        {
            dir = 1;
        }
    }
    
}