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

#define SCREENWIDTH 319
#define SCREENHEIGHT 199
#define PIXEL_WIDTH 2
#define PIXEL_HEIGHT 2
#define BUFSIZE 32

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
    case 'P':
        character = P_chr;
        break;
    case 'Q':
        character = Q_chr;
        break;
    case 'R':
        character = R_chr;
        break;
    case 'S':
        character = S_chr;
        break;
    case 'T':
        character = T_chr;
        break;
    case 'U':
        character = U_chr;
        break;
    case 'V':
        character = V_chr;
        break;
    case 'W':
        character = W_chr;
        break;
    case 'X':
        character = X_chr;
        break;
    case 'Y':
        character = Y_chr;
        break;
    case 'Z':
        character = Z_chr;
        break;
    case '.':
        character = PERIOD_chr;
        break;
    case '!':
        character = EXCLAM_chr;
        break;
    case '?':
        character = QUESTN_chr;
        break;
    case '0':
        character = ZERO_chr;
        break;
    case '1':
        character = ONE_chr;
        break;
    case '2':
        character = TWO_chr;
        break;
    case '3':
        character = THREE_chr;
        break;
    case '4':
        character = FOUR_chr;
        break;
    case '5':
        character = FIVE_chr;
        break;
    case '6':
        character = SIX_chr;
        break;
    case '7':
        character = SEVEN_chr;
        break;
    case '8':
        character = EIGHT_chr;
        break;
    case '9':
        character = NINE_chr;
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

char buffer[BUFSIZE] = {};
void cstart_() {

    uint8_t len = 0;
    while (1)
    {
        // Draw background
        RocketOS_DrawRect(0, 0, SCREENHEIGHT, SCREENWIDTH, BLACK);
        RocketOS_DrawRect(0, 0, 5, 5, MAGENTA);

        // render buffer
        char* buf_ptr = buffer;
        uint16_t x_pos = START;
        for (; *buf_ptr; buf_ptr++)
        {
            char c = *buf_ptr;
            if (c >= 'a' && c <= 'z') {
                c -= ('a' - 'A');
            }
            draw_character(c, x_pos, START + 20, WHITE);
            x_pos += LETTER_WIDTH + LETTER_SPACE;
        }

        char c = getc();
        // if backspace
        if (c == 0x8 && len > 0)
        {
            buffer[len-1] = '\0';
            len--;
        }
        else if (len < BUFSIZE) {
            buffer[len] = c;
            len++;
        }
    }
    
}