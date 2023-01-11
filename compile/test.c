#include <stdint.h>
typedef struct mem_test{
    uint8_t a;
    uint16_t b;
    uint32_t c;
    uint64_t d;
}mem;
int main(){
    mem test;
    test.a=32;
    test.b=3457;
    test.c=test.b/test.a;
    test.d=test.b*test.a;
    return 0;
}