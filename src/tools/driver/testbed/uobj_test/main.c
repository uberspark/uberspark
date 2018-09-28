#include <uberspark.h>
#include <stdint.h>
#include <string.h>

__attribute__((section (".data"))) char from_buffer[512];
__attribute__((section (".data"))) char to_buffer[512];

void main(void){
 memset(from_buffer, 0, sizeof(from_buffer));
 memcpy(to_buffer, from_buffer, sizeof(to_buffer)); 
}
