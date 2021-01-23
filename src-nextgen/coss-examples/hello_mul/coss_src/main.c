/*
    minimal coss example application that multiplies two unsigned 32-bit integers 
    specified via integer parameters and returns the result

    author: amit vasudevan <amitvasudevan@acm.org>
*/
#include <stdint.h>

uint32_t g_multiplicand = 10;
uint32_t g_multiplier = 100;

uint32_t h_mul (uint32_t multiplicand, uint32_t multiplier){
    uint32_t result;

    result = multiplicand * multiplier;

    return result;
}

void main(void){
    h_mul(g_multiplicand, g_multiplier);
}