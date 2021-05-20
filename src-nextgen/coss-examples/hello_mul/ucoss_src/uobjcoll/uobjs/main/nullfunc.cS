/*
    hello-mul main uobj null function casm implementation
    
    defines function main_nullfunc which simple returns

    author: amit vasudevan <amitvasudevan@acm.org>
*/

#include <uberspark/include/uberspark.h>
#include <uberspark/hwm/cpu/x86/32-bit/generic/include/hwm.h>

CASM_FUNCDEF(void, main_nullfunc,
{
    __casm__pushl_esi();
    __casm__pushl_ebx();


    __casm__popl_ebx();
    __casm__popl_esi();
    __casm__ret();
},
void *noparam)

