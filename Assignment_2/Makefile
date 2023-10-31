.PHONY: clean

include ../../rv32emu/mk/toolchain.mk

ASFLAGS = -march=rv32i -mabi=ilp32
LDFLAGS = --oformat=elf32-littleriscv

%.o: %.S
	$(CROSS_COMPILE)as -R $(ASFLAGS) -o $@ $<

all: hw2_origin_O0.elf

hw2_origin_O0.elf: hw2_origin_O0.o
	 $(CROSS_COMPILE)ld -o $@ -T hw2_origin_O0.ld $(LDFLAGS) $<

clean:
	$(RM) hw2_origin_O0.elf hw2_origin_O0.o
