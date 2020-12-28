/*
    hello-mul main uobj implementation
    
    multiplies two unsigned 32-bit integers specified via integer parameters and returns the result

    author: amit vasudevan <amitvasudevan@acm.org>
*/

#include <uberspark/include/uberspark.h>
#include <uberspark/hwm/include/arch/x86_32/generic/hwm.h>

//CASM_FUNCDECL(void main_nullfunc(void *noparam));

uint32_t init (void){
    return 0;   
}


uint32_t main (uint32_t multiplicand, uint32_t multiplier){
    uint32_t result;
    char l_mybuf[5];

    //CASM_FUNCCALL(main_nullfunc, CASM_NOPARAM);
    
    result = multiplicand * multiplier;

    return result;
}