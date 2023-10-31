.set SYSEXIT,  93
.set SYSWRITE, 64
.set PRINT_INT, 65
.set PRINT_HEX, 66

.data
intput:	.word 500, 400, 31321, 64, 1, 0
table:
    .byte 0xFF, 0, 0xFF, 15, 0xFF, 1, 28, 0xFF
    .byte 16, 0xFF, 0xFF, 0xFF, 2, 21, 29, 0xFF
    .byte 0xFF, 0xFF, 19, 17, 10, 0xFF, 12, 0xFF
    .byte 0xFF, 3, 0xFF, 6, 0xFF, 22, 30, 0xFF
    .byte 14, 0xFF, 27, 0xFF, 0xFF, 0xFF, 20, 0xFF
    .byte 18, 9, 11, 0xFF, 5, 0xFF, 0xFF, 13
    .byte 26, 0xFF, 0xFF, 8, 0xFF, 4, 0xFF, 25
    .byte 0xFF, 7, 24, 0xFF, 23, 0xFF, 31, 0xFF
str1: .string "After "
      .set str1_size, .-str1
str2: .string " iterations, the square root of "
      .set str2_size, .-str2
str3: .string " is "
      .set str3_size, .-str3
str4: .string "\n"
      .set str4_size, .-str4
str5: .string "Cycle count: "
      .set str5_size, .-str5

.text
# s0 = integer(input)
# s1 = float(input)
# s3 = test data address
# s4 = test dataset len
# s5 = j iterator
# a5 = square root of input

main:
    la      s3, intput 	     # get test data address
    li      s4, 6            # load test dataset len
    li      s5, 0            # j iterator = 0
loop:
    jal     ra, get_cycles
    mv      s8, a0           # s8 = save cycle number
    lw      s0, 0(s3)        # r[j] = test data j;
    mv      a1, s0           # utf(a1)
    jal     ra, utf          # goto utf
    mv      s1, a1           # store float(input) to s1
    jal     ra, clz          # jump to clz and get a0 =clz(r)
    addi    t0, x0, 32       # t0 = 32
    sub     t0, t0, a0       # 32 -lz
    srli    t0, t0, 1        # t0 = lzc =(32 - lz)/2
    srl     a1, s0, t0       # a1 = r >> lzc
    jal     ra, utf          # jump to utf and get ans (a1 = utf(a1))
    mv      a0, x0           # i = 0
    addi    a2, x0, 5	     # iteration times in 5
newton:
    bge	    a0,	a2,	print
    beq     a1, zero, print
    mv      s2, a1           # c = ans
    mv	    a3,	s1	         # dividend = s0
    mv	    a4,	a1	         # division = a1
    jal	    ra,	division     # go to division (r / ans)
    mv      a6, a5	         # a6 = t	
    mv      a3,	a6	         # a3 = a6 
    mv	    a4, a1	         # a4 = ans
    jal     ra, addition     # go to addition (t + ans)
    addi    t0, x0, 1	     # t0 = 1
    slli    t0, t0, 23       # t0 = << 1
    sub     a5, a5, t0       # a5 - t0 (exp-1) do the divide 2
    mv	    a1, a5           # ans = t
    beq     s2, a1,  print    # if last est == now est
    addi    a0, a0, 1        # i++
    beq     x0, x0,  newton
print:
    jal     ra, get_cycles   # get the cycle count
    sub     t0,a0,s8
    li      a0, 1
    la      a1, str1         # "after "
    la      a2, str1_size
    li      a7, SYSWRITE
    ecall
    li      a0, 1
    mv      a1, t0           # i
    li      a7, PRINT_INT
    ecall
    li      a0, 1
    la      a1, str2         # " iteration, the square root of "
    la      a2, str2_size
    li      a7, SYSWRITE
    ecall
    li      a0, 1
    mv      a1, s0           # input
    li      a7, PRINT_INT
    ecall
    li      a0, 1
    la      a1, str3         # " is "
    la      a2, str3_size
    li      a7, SYSWRITE
    ecall
    li      a0, 1
    mv      a1, s2          # sqrt
    li      a7, PRINT_HEX
    ecall
    li      a0, 1
    la      a1, str4        # \n
    la      a2, str4_size
    li      a7, SYSWRITE
    ecall
    li      a0, 1
    la      a1, str5        # "Cycle count:"
    la      a2, str5_size
    li      a7, SYSWRITE
    ecall
    li      a0, 1
    mv      a1, t0           # input
    li      a7, PRINT_INT
    ecall
    li      a0, 1
    la      a1, str4        # \n
    la      a2, str4_size
    li      a7, SYSWRITE
    ecall
    addi    s3, s3, 4       # r[j] address + 4
    addi    s5, s5, 1       # j++
    blt     s5, s4, loop
end:
    mv      ra ,x0
    li      a7, SYSEXIT
    ecall
    
clz:
    mv      t0, s0          # t0 = x
    mv      t1, t0     		# t1 = t0
    srli    t0, t0, 1   	# x >> 1
    or      t0, t0, t1  	# x = x | x >> 1
    srli    t1, t0, 2   	# x >> 2
    or      t0, t0, t1  	# x = x | x >> 2
    srli    t1, t0, 4   	# x >> 4
    or      t0, t0, t1  	# x = x | x >> 4
    srli    t1, t0, 8   	# x >> 8
    or      t0, t0, t1  	# x = x | x >> 8
    srli    t1, t0, 16   	# x >> 16
    or      t0, t0, t1  	# x = x | x >> 16
    # count ones (population count) 
    slli    t1, t0, 3
    sub     t0, t1, t0      # x = (x << 3) - x
    slli    t1, t0, 8
    sub     t0, t1, t0      # x = (x << 8) - x
    slli    t1, t0, 8
    sub     t0, t1, t0      # x = (x << 8) - x
    slli    t1, t0, 8
    sub     t0, t1, t0      # x = (x << 8) - x
    srli    t0, t0, 26      # x >> 26
    la      t1, table
    add     t1, t1, t0
    lbu     t0, 0(t1)       # Table[x >> 26]
    li      t1, 31
    sub     a0, t1, t0      # 31 - Table[x >> 26]
    jr      ra
utf:
    addi    sp, sp, -12 	# make space on stack 
    sw      ra, 8(sp)   	# save  ra
    sw      s0, 4(sp)   	# save  s0
    sw      a0, 0(sp)   	# save  a0
    beq     a1, zero, return
    mv      s0, a1
    jal     ra, clz
    mv      t0, a1      	# t0 = a1 = u ,a0 = clz(u)
    addi    t1, x0, 158 	# t1 = 127 + 31
    sub     t1, t1, a0  	# exp = 158 - clz(u)
    addi    a0,  a0,-8    	# c-8
    sll     t0, t0, a0      # u << (c - 8)
outloop: 
    slli    t1, t1, 23 		# exp << 23
    li      t6, 0x7fffff    # load mask 0x7fffff
    and     t0, t0, t6      # u & 0x7fffff
    or      a1, t1, t0  	# a1= (exp << 23) | (u & 0x7FFFFF);
return:
    lw      ra, 8(sp)   	# get return adress
    lw      s0, 4(sp)   	# get s0
    lw      a0, 0(sp)   	# get a0
    jr	    ra				# back to main

#/////////////////division
#a3= dividend
#a4= divisor
#a5= quotient
#///////////////
#t0 = expout;
#t1 = siga
#t2 = sigb
#t3 = i
#t4 = 25
division:	
	srli	t0,	a3,	23		# ia >> 23
 	andi	t0,	t0,	0xff	# (ia >> 23) & 0xff expa
	srli	t1,	a4,	23		# ib >> 23
	andi	t1,	t1,	0xff	# (ib >> 23) & 0xff expb
	sub		t0,	t0,	t1      # (expa - expb)
	addi	t0,	t0,	127 	# expout = expa -expb +127
	li		t6,	0x7fffff	# load mask 0x7fffff
	and		t1,	a3,	t6      # ia & 0x7fffff siga
	and		t2,	a4,	t6	    # ib & 0x7fffff sigb
	li		t6,	0x800000	# load mask 0x7fffff
	or		t1,	t1, t6 		# siga = (ia & 0x7fffff ) | 0x800000
	or		t2,	t2, t6		# sigb = (ib & 0x7fffff ) | 0x800000
div1:
	bge     t1,	t2,	div2 	# siga > sigb go to div2
	slli	t1,	t1,	1	 	# siga = siga << 1
	addi	t0,	t0,	-1 		# expout--
	mv		a5,	x0		    # r = 0
	beq     x0,	x0,	div1	# back to div1
div2:
	mv      t3,	x0			# i = 0
	addi	t4,	x0,	25	 	# t4 = 25
shift_sub:
	bge     t3,	t4,	div3	# if i >= 25 go to div3
	slli	a5,	a5,	1		# r = r << 1
	bltu	t1,	t2,	next	# if (siga < sigb) go to next
	sub     t1,	t1,	t2		# siga = siga - sigb
	ori  	a5,	a5,	1		# r = r | 1
    bne     t1, zero, next  # check if the reminder is zero
    li      t6, 24          # load integer 24
    sub     t6, t6, t3      # 24-i
    sll     a5, a5, t6      # r = r << (24-i)
    jal     zero, div3      # break, jump to div3
next:
	slli	t1,	t1,	1		# siga = siga << 1
	addi	t3,	t3,	1	    # i = i + 1
	beq     x0,	x0, shift_sub # back to shift_sub
div3:
  	srli    a5, a5, 1       # r = r  >> 1
	li      t6,	0x7fffff	# load mask 0x7fffff
	and     a5,	a5, t6		# r & 0x7fffff
	andi	t0,	t0,	0xff	# expout & 0xff
	slli	t0,	t0, 23		# expout = expout << 23
	or		a5, a5, t0		# out= ((expout & 0xff) << 23) | (sigout)
	jr 		ra              # back to main
 
#///////////////////addition
#a3= a
#a4= b
#a5= a+b
#///////////////
#t0 = expa / expout;
#t1 = expb /	sigout
#t2 = dif
#t3 = siga 
#t4 = sigb
addition:
	srli	t0,	a3,	23		# ia >> 23
	andi	t0,	t0,	0xff	# expa = (ia >> 23) & 0xff 
	srli	t1,	a4,	23		# ib >> 23
	andi	t1,	t1,	0xff	# expb = (ib >> 23) & 0xff 
	sub	    t2,	t0,	t1		# dif = expa - expb
	li	    t6,	0x7fffff	# load mask 0x7fffff
	and	    t3,	a3,	t6		# ia & 0x7fffff	
	and 	t4,	a4,	t6		# ib & 0x7fffff
	li	    t6,	0x800000		# load mask 0x800000
	or	    t3,	t3,	t6		# siga = ((ia & 0x7fffff) | 0x800000)
	or	    t4,	t4,	t6		# sigb = ((ib & 0x7fffff) | 0x800000)

	blt	    t2,	x0,	out_b	# if dif < 0 , expout = expb, else expout=expa
	srl	    t4,	t4,	t2		# sigb = sigb >> dif
	beq	    x0,	x0,	plus	# go to plus
out_b:
	sub	    t2,	x0,	t2		# dif= - dif change dif to positive
	srl 	t3,	t3,	t2		# siga = siga >> dif
	mv	    t0,	t1			# expout = expb
plus:
	add	    t1,	t3,	t4		# sigout= siga + sigb
	srli	t2,	t1,	24		# sigout >> 24
	addi	t3,	x0,	1		# t3 = 1
	bne 	t2,	t3,	add_out # if (sigout >> 24) != 1 end addition
	srli	t1,	t1,	1		# sigout = sigout >> 1
	addi	t0, 	t0,	1	# expout ++
add_out:
	andi	t0,	t0,	0xff	# expout & 0xff
	slli	t0,	t0,	23		# (expout & 0xff) << 23
	li	    t6,	0x7fffff	# load mask 0x7fffff
	and	    t1,	t1,	t6		# sigout& 0x7fffff
	or	    a5,	t0,	t1		# out = ((expout & 0xff) <<23) | ((sigout) & 0x7fffff)
	jr	    ra

get_cycles:
    csrr a1, cycleh
    csrr a0, cycle
    csrr a2, cycleh
    bne a1, a2, get_cycles
    ret
