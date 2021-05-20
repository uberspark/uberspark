/*
    hello-mul main uobj implementation
    
    multiplies two unsigned 32-bit integers specified via integer parameters and returns the result

    author: amit vasudevan <amitvasudevan@acm.org>
*/

#include <uberspark/include/uberspark.h>
#include <uberspark/hwm/cpu/x86/32-bit/generic/include/hwm.h>

CASM_FUNCDECL(void main_nullfunc(void *noparam));

extern uint32_t init (void);
extern uint32_t test_call (uint32_t value);

//global variable
unsigned int g_int;
unsigned int g_total=0;
unsigned char g_char;

unsigned int g_int_address = &g_int;

//global ACSL predicate
/*@ predicate is_separated (char * x) = 
    \separated(&g_char, x) &&
    \separated(&g_total, x);
*/


/*@ 
    requires 0 <= multiplicand <= 10;
*/
uint32_t main (uint32_t multiplicand, uint32_t multiplier){
    uint32_t result;
    char l_mybuf[5];
    char *p= &l_mybuf;

    CASM_FUNCCALL(main_nullfunc, CASM_NOPARAM);
    //whois(0);
    result = multiplicand * multiplier;

    p++;

    /*@ assert 1;  */
    *p='A';
    
    /*@ assert is_separated(p)  ; */
    *p++ = 'B';
    
    p = &g_char;

    /*@ assert is_separated(p)  ; */
    *p++ = 'C';

    g_int = 0;

 

    for(g_int = 0; g_int < 20; g_int++){
        g_total = g_total + g_int; 
    }   

    test_call(g_int++ + g_total++);

    return result;
}