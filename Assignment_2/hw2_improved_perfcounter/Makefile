.PHONY: clean

include ../../../rv32emu/mk/toolchain.mk

CFLAGS = -march=rv32i_zicsr_zifencei -mabi=ilp32 -Ofast -Wall

OBJS = \
    getcycles.o \
    getinstret.o \
    hw2_improved.o
BIN = hw2_improved.elf

%.o: %.S
	$(CROSS_COMPILE)gcc $(CFLAGS) -c -o $@ $<

%.o: %.c
	$(CROSS_COMPILE)gcc $(CFLAGS) -c -o $@ $<

all: $(BIN)

$(BIN): $(OBJS)
	 $(CROSS_COMPILE)gcc -o $@ $^

clean:
	$(RM) $(BIN) $(OBJS)
