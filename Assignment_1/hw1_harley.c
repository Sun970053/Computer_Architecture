#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>


uint32_t test_nums[6] = {0, 2, 69, 4777, 36, 65536};

uint16_t count_leading_zeros(uint32_t x)
{
    if(!x) return 32;
    static uint8_t const Table[] = {
      0xFF, 0, 0xFF, 15, 0xFF, 1, 28, 0xFF,
      16, 0xFF, 0xFF, 0xFF, 2, 21, 29, 0xFF,
      0xFF, 0xFF, 19, 17, 10, 0xFF, 12, 0xFF,
      0xFF, 3, 0xFF, 6, 0xFF, 22, 30, 0xFF,
      14, 0xFF, 27, 0xFF, 0xFF, 0xFF, 20, 0xFF,
      18, 9, 11, 0xFF, 5, 0xFF, 0xFF, 13,
      26, 0xFF, 0xFF, 8, 0xFF, 4, 0xFF, 25,
      0xFF, 7, 24, 0xFF, 23, 0xFF, 31, 0xFF,
    };

    /* Propagate leftmost 1-bit to the right */
    x = x | (x >> 1);
    x = x | (x >> 2);
    x = x | (x >> 4);
    x = x | (x >> 8);
    x = x | (x >> 16);

//    x = (x << 3) - x;   /* Multiply by 7. */
//    x = (x << 8) - x;   /* Multiply by 255. */
//    x = (x << 8) - x;   /* Again. */
//    x = (x << 8) - x;   /* Again. */

    return 31 - Table[(x * 0x6EB14F9) >> 26];
}


int main()
{
    for(int i = 0;i < 6;i++){
        printf("The clz number of %u", test_nums[i]);
        printf(" is %u \n", count_leading_zeros(test_nums[i]));
    }

    return 0;
}
