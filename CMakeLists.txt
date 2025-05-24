cmake_minimum_required(VERSION 3.31)
project(rocket_os)

# --------------------------------------
#  Find required i686 compiler programs
# --------------------------------------

find_program(
    I686_ASSEMBLER i686-elf-as
    REQUIRED
)

find_program(
    I686_LINKER i686-elf-ld
    REQUIRED
)

find_program(
    I686_CC i686-elf-gcc
    REQUIRED
)

set(BIN_PATH "${CMAKE_BINARY_DIR}/bin")


# ------------
#  PARTITIONS
# ------------

include(src/boot/CMakeLists.txt)
include(src/boot2/CMakeLists.txt)
