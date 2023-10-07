.data:
    test_nums: .word 0, 2, 69, 4777
    len: .word 4
    str1: .string " The clz value of "
    str2: .string " is "
    newline: .string "\n"
    
.text:
    # a0 = clz function argument
    # a1 = return value
    # s2 = loop counter
    # s3 = iterator
    # t0 = temporary register1 in printResult, clz
    # t1 = temporary register2 in printResult, clz
    
main:
    la s1, test_nums
    lw s2, len
    li s3, 0
    Loop:
        lw a0, 0(s1) # init function argument
        jal ra, clz # clz function call
        jal ra, printResult # printResult function call
        addi s3, s3, 1
        addi s1, s1, 4
        blt s3, s2, Loop
# --- Exit program ---
    li a7, 10
    ecall
# --- printResult ---
# a0: Value which clz number was computed from
# a1: clz result
printResult:
        mv t0, a0
        mv t1, a1
        la a0, str1
        li a7, 4
        ecall
        mv a0, t0
        li a7, 1
        ecall
        la a0, str2
        li a7, 4
        ecall
        mv a0, t1
        li a7, 1
        ecall
        la a0, newline
        li a7, 4
        ecall
        ret
# --- Count leading zeros ---
clz:
    mv t0, a0
    # Replace all bits with 1 after the top bit.
    srli t1, t0, 1
    or t0, t0, t1
    
    srli t1, t0, 2
    or t0, t0, t1
    
    srli t1, t0, 4
    or t0, t0, t1
    
    srli t1, t0, 8
    or t0, t0, t1
    
    srli t1, t0, 16
    or t0, t0, t1
    # x -= ((x >> 1) & 0x55555555);
    li t3, 0x55555555
    srli t1, t0, 1 # t1 = t0 >> 1
    and t1, t1, t3 # t1 = t1 & 0x55555555
    sub t0, t0, t1 # t0 = t0 -t1
    # x = ((x >> 2) & 0x33333333) + (x & 0x33333333);
    li t3, 0x33333333
    srli t1, t0, 2
    and t1, t1, t3 
    and t2, t0, t3
    add t0, t1, t2
    # x = ((x >> 4) + x) & 0x0f0f0f0f;
    li t3, 0x0f0f0f0f
    srli t1, t0, 4
    add t1, t1, t0
    and t0, t1, t3
    # or we can replace it by x *= 0x01010101;
    li t3, 0x01010101
    mul t0, t0, t3
    # return (32-(x>>24));
    srli t1, t0, 24
    li t0, 32
    sub a1, t0, t1
    
    ret