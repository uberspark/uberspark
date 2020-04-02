/*
    hello-mul main uobj implementation
    
    multiplies two unsigned 32-bit integers specified via integer parameters and returns the result

    author: amit vasudevan <amitvasudevan@acm.org>
*/

#include <uberspark/include/uberspark.h>


uint32_t main (uint32_t multiplicand, uint32_t multiplier){
    uint32_t result;

    result = multiplicand * multiplier;

    return result;
}