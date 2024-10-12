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

void draw_character(char c, uint16_t x, uint16_t y, uint8_t color)
{
    uint8_t* character = 0;
    switch (c)
    {
    case 'A':
        character = A_chr;
        break;
    case 'B':
        character = B_chr;
        break;
    case 'C':
        character = C_chr;
        break;
    case 'D':
        character = D_chr;
        break;
    case 'E':
        character = E_chr;
        break;
    case 'F':
        character = F_chr;
        break;
    case 'G':
        character = G_chr;
        break;
    case 'H':
        character = H_chr;
        break;
    case 'I':
        character = I_chr;
        break;
    case 'J':
        character = J_chr;
        break;
    case 'K':
        character = K_chr;
        break;
    case 'L':
        character = L_chr;
        break;
    case 'M':
        character = M_chr;
        break;
    case 'N':
        character = N_chr;
        break;
    case 'O':
        character = O_chr;
        break;
    case 'R':
        character = R_chr;
        break;
    case 'W':
        character = W_chr;
        break;
    case '0':
        character = ZERO_chr;
        break;
    default:
        break;
    }

    if (character == 0) return;

    for (int i = 0; i < LETTER_WIDTH; i++)
    {
        for (int j = 0; j < LETTER_HEIGHT; j++)
        {
            RocketOS_DrawRect(x + i, y + j, 1, 1, color*(character[LETTER_WIDTH*j+i]));
        }
    }
}

void cstart_() {

    /// @todo doesn't work under Roc bootloader
    const char* test_string1 = "HELLO W0RLD";
    const char* test_string2 = "ABCDEFGHIJKLMNORW0";

    uint16_t x_ctr = START;
    char* sptr = test_string1;
    for (; *sptr; sptr++)
    {
        draw_character(*sptr, x_ctr, START, WHITE);
        x_ctr += LETTER_WIDTH + LETTER_SPACE;
    }

    x_ctr = START;
    uint8_t clr = 0x1;
    sptr = test_string2;
    for (; *sptr; sptr++)
    {
        draw_character(*sptr, x_ctr, START + 40, clr);
        clr += 1;
        if (clr == 0x10) clr = 0x1;
        x_ctr += LETTER_WIDTH + LETTER_SPACE;
    }
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