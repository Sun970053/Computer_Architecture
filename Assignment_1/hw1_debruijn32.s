.data:
    test_nums: .word 0, 2, 69, 4777, 36, 65536
    len: .word 6
    str1: .string " The clz value of "
    str2: .string " is "
    newline: .string "\n"
    debruijn32:
    .byte 0, 31, 9, 30, 3, 8, 13, 29
    .byte 2, 5, 7, 21, 12, 24, 28, 19
    .byte 1, 10, 4, 14, 6, 22, 25, 20
    .byte 11, 15, 23, 26, 16, 27, 17, 18
    
.text:
    # a0 = clz function argument
    # a1 = return value
    # s2 = loop counter
    # s3 = iterator
    # t0 = temporary register1 in printResult, clz
    # t1 = temporary register2 in printResult, clz
    # t2 = debruijn32 address
    
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
    beq a0, zero, zeros
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
    # b=b+1
    addi t0, t0, 1
    # return debruijn32[b*0x076BE629>>27];
    li t3, 0x076BE629
    mul t0, t0, t3
    srli t0, t0, 27
    la t4, debruijn32
    add t4, t4, t0
    lbu a1, 0(t4)
    ret
zeros:
    li a1, 32
    ret
    