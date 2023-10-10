.data:
    test_nums: .word 0, 2, 69, 4777, 36, 65536
    len: .word 6
    str1: .string " The clz value of "
    str2: .string " is "
    newline: .string "\n"
    table:
    .byte 0xFF, 0, 0xFF, 15, 0xFF, 1, 28, 0xFF
    .byte 16, 0xFF, 0xFF, 0xFF, 2, 21, 29, 0xFF
    .byte 0xFF, 0xFF, 19, 17, 10, 0xFF, 12, 0xFF
    .byte 0xFF, 3, 0xFF, 6, 0xFF, 22, 30, 0xFF
    .byte 14, 0xFF, 27, 0xFF, 0xFF, 0xFF, 20, 0xFF,
    .byte 18, 9, 11, 0xFF, 5, 0xFF, 0xFF, 13,
    .byte 26, 0xFF, 0xFF, 8, 0xFF, 4, 0xFF, 25,
    .byte 0xFF, 7, 24, 0xFF, 23, 0xFF, 31, 0xFF
    
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
    # return 31 - Table[(x*0x6EB14F9) >> 26];
    li t3, 0x6EB14F9
    mul t0, t0, t3
    srli t0, t0, 26
    la t4, table
    add t4, t4, t0
    lbu t0, 0(t4)
    li t3, 31
    sub a1, t3, t0 
    ret
zeros:
    li a1, 32
    ret