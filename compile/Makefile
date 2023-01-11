RISCV_ARCH := rv32im
RISCV_ABI := ilp32
RISCV_MCMODEL := medlow

TARGET = main

COMMON_DIR = .

C_SRCS := calculator.c main.c

CFLAGS += -O2 -Wall
#-O0 -Wall
RISCV_PATH := /home/linchi/.local/xPacks/@xpack-dev-tools/riscv-none-elf-gcc/12.2.0-1.1/.content/

RISCV_GCC     := $(abspath $(RISCV_PATH)/bin/riscv-none-elf-gcc)
RISCV_AS      := $(abspath $(RISCV_PATH)/bin/riscv-none-elf-as)
RISCV_GXX     := $(abspath $(RISCV_PATH)/bin/riscv-none-elf-g++)
RISCV_OBJDUMP := $(abspath $(RISCV_PATH)/bin/riscv-none-elf-objdump)
RISCV_GDB     := $(abspath $(RISCV_PATH)/bin/riscv-none-elf-gdb)
RISCV_AR      := $(abspath $(RISCV_PATH)/bin/riscv-none-elf-ar)
RISCV_OBJCOPY := $(abspath $(RISCV_PATH)/bin/riscv-none-elf-objcopy)
RISCV_READELF := $(abspath $(RISCV_PATH)/bin/riscv-none-elf-readelf)

.PHONY: all
all: $(TARGET)
ASM_SRCS += $(COMMON_DIR)/start.S

LINKER_SCRIPT = $(COMMON_DIR)/link.lds

INCLUDES += -I$(COMMON_DIR)

LDFLAGS += -T $(LINKER_SCRIPT) -nostartfiles -Wl,--gc-sections -Wl,--check-sections

ASM_OBJS := $(ASM_SRCS:.S=.o)
C_OBJS := $(C_SRCS:.c=.o)

LINK_OBJS += $(ASM_OBJS) $(C_OBJS)
LINK_DEPS += $(LINKER_SCRIPT)

CLEAN_OBJS += $(TARGET) $(LINK_OBJS) $(TARGET).txt $(TARGET).bin $(TARGET).mem $(TARGET)v2.mem

CFLAGS += -march=$(RISCV_ARCH)
CFLAGS += -mabi=$(RISCV_ABI)
CFLAGS += -mcmodel=$(RISCV_MCMODEL) -ffunction-sections -fdata-sections -fno-builtin-printf -fno-builtin-malloc

$(TARGET): $(LINK_OBJS) $(LINK_DEPS) Makefile
	$(RISCV_GCC) $(CFLAGS) $(INCLUDES) $(LINK_OBJS) -o $@ $(LDFLAGS)
	$(RISCV_OBJCOPY) -O binary $@ $@.bin
	$(RISCV_OBJCOPY) -O verilog $@ $@.ver
	$(RISCV_OBJDUMP) --disassemble-all $@ > $@.txt
	python3 $(COMMON_DIR)/converter.py $@.bin
	python3 $(COMMON_DIR)/converterv2.py $@.ver

$(ASM_OBJS): %.o: %.S
	$(RISCV_GCC) $(CFLAGS) $(INCLUDES) -c -o $@ $<

$(C_OBJS): %.o: %.c
	$(RISCV_GCC) $(CFLAGS) $(INCLUDES) -c -o $@ $<

.PHONY: clean
clean:
	rm -f $(CLEAN_OBJS)