#include <stdio.h>
#include <stdlib.h>

#include <stdint.h>
uint32_t test_nums[6] = {0, 2, 69, 4777, 36, 65536};

uint16_t count_leading_zeros(uint32_t x){
    x |= (x >> 1);
    x |= (x >> 2);
    x |= (x >> 4);
    x |= (x >> 8);
    x |= (x >> 16);

    /* count ones (population count) */
    /* add pairs of bits*/
    x -= ((x >> 1) & 0x55555555);
    /*group of 4*/
    x = ((x >> 2) & 0x33333333) + (x & 0x33333333);
    /*group of 8*/
    x = ((x >> 4) + x) & 0x0f0f0f0f;
    /*horizontal sum of bytes
    x += (x >> 8);
    x += (x >> 16);*/
    /*or we can replace it by x *= 0x01010101; */
    x *= 0x01010101;
    /*return (32 - (x & 0x7f))*/
    return 32-(x>>24);
}

int main()
{
    for(int i = 0;i < 6;i++){
        printf("The clz number of %u", test_nums[i]);
        printf(" is %u \n", count_leading_zeros(test_nums[i]));
    }

    return 0;
}
