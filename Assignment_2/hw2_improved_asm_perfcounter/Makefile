.PHONY: clean

include ../../../rv32emu/mk/toolchain.mk

ASFLAGS = -march=rv32i_zicsr -mabi=ilp32 -mabi=ilp32
LDFLAGS = --oformat=elf32-littleriscv

%.o: %.S
	$(CROSS_COMPILE)as -R $(ASFLAGS) -o $@ $<

all: hw2_improved.elf

hw2_improved.elf: hw2_improved.o
	 $(CROSS_COMPILE)ld -o $@ -T hw2_improved.ld $(LDFLAGS) $<

clean:
	$(RM) hw2_improved.elf hw2_improved.o
