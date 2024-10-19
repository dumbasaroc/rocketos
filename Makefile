PRJ_NAME=ROCKETOS

## COLORING
REDFG=\033[31m
GREENFG=\033[32m
YELLOWFG=\033[33m
NORMAL=\033[0m
## END COLORING

ASM=i686-elf-as
LD=i686-elf-ld
KERNEL_LINK_OPTIONS=-Tsrc/kernel/link.ld
BOOT_LINK_OPTIONS=-Tsrc/boot/boot.ld
BOOT2_LINK_OPTIONS=-Tsrc/boot2/boot2.ld

CC=i686-elf-gcc
CFLAGS16=-x c -m16 -Wall -fno-builtin
#-mpreferred-stack-boundary=0
CFLAGS32=-m32 -Wall -fno-builtin
CINCLUDES_KERNEL=-Isrc/kernel/cstd
CINCLUDES_BOOT2=-Isrc/boot2

BUILD_DIR=build
SRC_DIR=src
OBJ_DIR=obj
IMG_FILENAME=main.img

KERNEL_SOURCES=\
	$(SRC_DIR)/kernel/main.s \
	$(SRC_DIR)/kernel/cstd/stdio/print.s \
	$(SRC_DIR)/kernel/cstd/stdio/getchar.s \
	$(SRC_DIR)/kernel/main.c16 \
	$(SRC_DIR)/kernel/cstd/stdio.c16 \
	$(SRC_DIR)/kernel/gfx/rect.s \
	$(SRC_DIR)/kernel/gfx/letters.c16

KERNEL_OBJECTS=$(patsubst src/%,$(OBJ_DIR)/%,\
			   $(patsubst %.s,%.o,\
			   $(patsubst %.c16,%.obj,$(KERNEL_SOURCES))))


BOOT_SOURCES=$(SRC_DIR)/boot/boot.s

BOOT_OBJECTS=$(patsubst src/%,$(OBJ_DIR)/%,\
			 $(patsubst %.s,%.o,$(BOOT_SOURCES)))


BOOT2_SOURCES=$(SRC_DIR)/boot2/boot2.s \
			$(SRC_DIR)/boot2/gdt_idt/gdt_setup.c16 \
			$(SRC_DIR)/boot2/gdt_idt/idt_setup.c16 \
			$(SRC_DIR)/boot2/gdt_idt/gdt_struct.c16 \
			$(SRC_DIR)/boot2/gdt_idt/idt_struct.c16 \
			$(SRC_DIR)/boot2/interrupts/catchall_interrupt.s \
			$(SRC_DIR)/boot2/interrupts/test_kb_interrupt.s

BOOT2_OBJECTS=$(patsubst src/%,$(OBJ_DIR)/%,\
			  $(patsubst %.s,%.o,\
			  $(patsubst %.c16,%.obj, \
			  $(patsubst %.c,%.obj,$(BOOT2_SOURCES)))))


# Build Script
.PHONY: build
build: $(BUILD_DIR)/$(IMG_FILENAME)

# Testing setup (instead of having a shellscript)
.PHONY: test
test: build
	@echo -e "$(YELLOWFG)=========================$(NORMAL)"
	@echo -e "$(YELLOWFG) Starting QEMU emulation $(NORMAL)"
	@echo -e "$(YELLOWFG)=========================$(NORMAL)"
	@qemu-system-i386 -fda $(BUILD_DIR)/$(IMG_FILENAME) -d int -D qemu-log.txt -monitor stdio


# Debugging setup for GDB
.PHONY: debug
debug: build
	@echo -e "$(YELLOWFG)=========================$(NORMAL)"
	@echo -e "$(YELLOWFG) Starting QEMU emulation $(NORMAL)"
	@echo -e "$(YELLOWFG)=========================$(NORMAL)"
	@qemu-system-i386 -fda $(BUILD_DIR)/$(IMG_FILENAME) -s -S


# Actual File Rules

$(BUILD_DIR)/$(IMG_FILENAME): $(BUILD_DIR)/boot.bin $(BUILD_DIR)/kernel.bin $(BUILD_DIR)/boot2.bin
	@echo -e "$(YELLOWFG)======================$(NORMAL)"
	@echo -e "$(YELLOWFG)Creating bootable disk$(NORMAL)"
	@echo -e "$(YELLOWFG)======================$(NORMAL)"
	@dd if=/dev/zero of=$(BUILD_DIR)/main.img bs=512 count=2880
	@mkfs.fat -F 12 -n "TESTOS" $(BUILD_DIR)/$(IMG_FILENAME)
	@dd if=$(BUILD_DIR)/boot.bin of=$(BUILD_DIR)/$(IMG_FILENAME) conv=notrunc
	@mcopy -i $(BUILD_DIR)/$(IMG_FILENAME) $(BUILD_DIR)/boot2.bin "::boot2.bin"
	@mcopy -i $(BUILD_DIR)/$(IMG_FILENAME) $(BUILD_DIR)/kernel.bin "::kernel.bin"
	@echo -e "$(GREENFG)COMPLETED!$(NORMAL)"


$(BUILD_DIR)/kernel.bin: $(KERNEL_OBJECTS)
	@echo -e "$(YELLOWFG)Linking kernel...$(NORMAL)"
	@mkdir -p $(BUILD_DIR)
	@$(LD) -o $(BUILD_DIR)/kernel.bin $(KERNEL_LINK_OPTIONS) $^
	@echo -e "$(GREENFG)Linked kernel!$(NORMAL)"

$(BUILD_DIR)/boot.bin: $(BOOT_OBJECTS)
	@echo -e "$(YELLOWFG)Linking first-stage bootloader...$(NORMAL)"
	@mkdir -p $(BUILD_DIR)
	@$(LD) -o $(BUILD_DIR)/boot.bin $(BOOT_LINK_OPTIONS) $^
	@echo -e "$(GREENFG)Linked bootloader!$(NORMAL)"

$(BUILD_DIR)/boot2.bin: $(BOOT2_OBJECTS)
	@echo -e "$(YELLOWFG)Linking second-stage bootloader...$(NORMAL)"
	@mkdir -p $(BUILD_DIR)
	@$(LD) -o $(BUILD_DIR)/boot2.bin $(BOOT2_LINK_OPTIONS) $^
	@echo -e "$(GREENFG)Linked bootloader!$(NORMAL)"


#########################
# Individual File Rules #
#########################

$(OBJ_DIR)/boot2/%.obj: $(SRC_DIR)/boot2/%.c16
	@echo -e "Compiling GCC16 $(YELLOWFG)$@$(NORMAL)..."
	@mkdir -p $(dir $@)
	@$(CC) -c $(CFLAGS16) $(CINCLUDES_BOOT2) $< -o $@ -Xassembler -al=$@.lst

$(OBJ_DIR)/boot2/%.obj: $(SRC_DIR)/boot2/%.c
	@echo -e "Compiling GCC32 $(YELLOWFG)$@$(NORMAL)..."
	@mkdir -p $(dir $@)
	@$(CC) -c $(CFLAGS32) $(CINCLUDES_BOOT2) $< -o $@ -Xassembler -al=$@.lst

$(OBJ_DIR)/kernel/%.obj: $(SRC_DIR)/kernel/%.c16
	@echo -e "Compiling $(YELLOWFG)$@$(NORMAL)..."
	@mkdir -p $(dir $@)
	@$(CC) -c $(CFLAGS16) $(CINCLUDES_KERNEL) $< -o $@ -Xassembler -al=$@.lst

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.s
	@echo -e "Assembling $(YELLOWFG)$@$(NORMAL)..."
	@mkdir -p $(dir $@)
	@$(ASM) $< -al=$@.lst -o $@

.PHONY: clean
clean:
	@echo -e "Cleaning $(PRJ_NAME)..."
	@rm -rf $(BUILD_DIR)
	@rm -rf $(OBJ_DIR)
	@echo -e "$(GREENFG)Done!$(NORMAL)"
