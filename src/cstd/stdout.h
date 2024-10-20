#pragma once

#include "stdint.h"

#define SCREEN_WIDTH 80
#define SCREEN_HEIGHT 25

extern uint8_t cursor_x;
extern uint8_t cursor_y;
extern uint8_t color;

/**
 * Not quite conforming to Cstd
 * 
 * Returns the character c on success, or
 * -1 on failure
 */
void putc(char c);
void puts(const char* s);

void printdbg();
void printb(uint8_t c);

void clear_screen();