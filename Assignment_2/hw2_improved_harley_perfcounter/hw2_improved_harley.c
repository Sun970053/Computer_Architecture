#include <stdint.h>
#include <stdio.h>
#include <string.h>

extern uint64_t get_cycles();
extern uint64_t get_instret();

#define iteration 5
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

int lz, lzc, i;
float ans;
int count_leading_zeros(uint32_t x)
{
    if(!x) return 32;

    /* Propagate leftmost 1-bit to the right */
    x = x | (x >> 1);
    x = x | (x >> 2);
    x = x | (x >> 4);
    x = x | (x >> 8);
    x = x | (x >> 16);

    x = (x << 3) - x;   /* Multiply by 7. */
    x = (x << 8) - x;   /* Multiply by 255. */
    x = (x << 8) - x;   /* Again. */
    x = (x << 8) - x;   /* Again. */

    return 31 - Table[x >> 26];
}
float uint_to_float(uint32_t u){
    if(u == 0) return 0;
    int c = count_leading_zeros(u);
    unsigned int exp=127+31-c;
    u <<= (c-8);
    uint32_t flt= (exp << 23) | (u & 0x7FFFFF);
    return * (float *) &flt;
}
float division(float a,float b){
    //change float into int 
    int32_t ia = *(int32_t *)& a;
    int32_t ib = *(int32_t *)& b;
    //get the exponential
    int32_t expa = (ia >> 23) & 0xff ;
    int32_t expb = (ib >> 23) & 0xff;
    // parameter used in rounded output
    //get the significand
    uint32_t siga= ((ia  & 0x7fffff) | 0x800000);
    uint32_t sigb= ((ib  & 0x7fffff) | 0x800000);
    //exponential output
    int32_t expout= expa - expb + 127;
    //allign two numbers' significand
    if(siga < sigb){
        siga = siga << 1;
        expout--;
    }
    // r means result
    uint32_t r = 0;
    // start division
    for(int i= 0 ; i < 25 ; i++){
        r= r << 1;
        if(siga >= sigb){
            siga = siga - sigb;
            r = r | 1;
        }
        // If the remainder is zero, jump out the loop
        // And then set all the remaining bits to zero
        if(siga == 0){
            r = r << (24-i);
            break;
        }
        siga = siga << 1 ;
    }
    r=(r >> 1);
    int32_t sigout=r & 0x7fffff;
    int32_t out= ((expout & 0xff) << 23) | (sigout);
    return *(float *) &out;
}
float addition(float a,float b){
    //change float into int
    int32_t ia = *(int32_t *)& a;
    int32_t ib = *(int32_t *)& b;
    //get the exponential
    int32_t expa = (ia >> 23) & 0xff ;
    int32_t expb = (ib >> 23) & 0xff;
    //get the significand
    uint32_t siga= ((ia & 0x7fffff) | 0x800000);
    uint32_t sigb= ((ib & 0x7fffff) | 0x800000);
    //exponential output
    int32_t expout=0;
    int dif= expa - expb;
    if(dif >= 0){
        sigb = sigb >> dif;
        expout = expa;
    }
    else{
        dif = -dif;
        siga = siga >> dif;
        expout = expb;
    }
    uint32_t sigout = siga + sigb;
    if(sigout >> 24 == 1){
        sigout = sigout >>1;
        expout = expout + 1;
    }
    int32_t out=(0 & 1 << 31) | ((expout & 0xff) << 23) | ((sigout) & 0x7fffff);
    return *(float *) &out;
}
int main(){
    uint32_t r[6]={500, 400, 31321, 64, 1, 0};
    float ans[6] = {};
    float t,c;
    for(int j = 0; j < 6;j++){
        /* measure cycles */
        uint64_t oldinstret = get_instret();
        uint64_t oldcount = get_cycles();
        lz =count_leading_zeros(r[j]);
        lzc = (32 - lz) / 2;
        ans[j]=uint_to_float(r[j] >> lzc);
        for (i = 0 ; i < iteration ; i++){
            if(ans[j] == 0) break;
            c = ans[j];
            t = division(r[j],ans[j]);
            t = addition(t,ans[j]);
            t = division(t,2);
            ans[j]=t;
            if(ans[j] == c){
                break;
            }
        }
        uint64_t instretcount = get_instret() - oldinstret;
        uint64_t cyclecount = get_cycles() - oldcount;
        printf("After %d iterations, the square root of %d is %f\n",i+1,r[j],ans[j]);
        printf("Cycle count: %u\n", (unsigned int) cyclecount);
        printf("Instructions retired: %u\n\n", (unsigned) instretcount);
    }
    return 0; 
}
