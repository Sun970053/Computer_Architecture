#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

/* debruijn32 = 0000 0111 0110 1011 1110 0110 0010 1001 */

uint32_t test_nums[4] = {0, 2, 69, 4777};

int count_leading_zeros(uint32_t b)
{
    static const uint8_t debruijn32[32] = {
        0, 31, 9, 30, 3, 8, 13, 29,
        2, 5, 7, 21, 12, 24, 28, 19,
        1, 10, 4, 14, 6, 22, 25, 20,
        11, 15, 23, 26, 16, 27, 17, 18
    };
    b |= b>>1;
    b |= b>>2;
    b |= b>>4;
    b |= b>>8;
    b |= b>>16;
    b++;
    return debruijn32[b*0x076BE629>>27];
}

int main()
{
    for(int i = 0;i < 4;i++){
        printf("The clz number of %u", test_nums[i]);
        printf(" is %u \n", count_leading_zeros(test_nums[i]));
    }

    return 0;
}
