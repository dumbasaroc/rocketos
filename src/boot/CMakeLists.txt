# Folder-level variables
set(BOOT_BASE_DIR "src/boot")
set(BOOT_OUT_DIR "obj/boot")

set(BOOT_LINK_OPTIONS "-T${CMAKE_SOURCE_DIR}/src/boot/boot.ld")

# Preprocessing function
#  - Takes in local (to this folder) source filenames
#  - Outputs the absolute path to the file the build rule
#    will generate.
function(
    bootloader_preprocess
    input_filename
    output_filename
)

    get_filename_component(BASE_FILENAME ${input_filename} NAME_WLE)
    get_filename_component(BASE_SUBDIR ${input_filename} DIRECTORY)    
    get_filename_component(ORIG_EXT ${input_filename} LAST_EXT)

    set(SRC_FILE ${CMAKE_SOURCE_DIR}/${BOOT_BASE_DIR}/${input_filename})
    set(DST_BASENAME ${CMAKE_BINARY_DIR}/${BOOT_OUT_DIR}/${BASE_SUBDIR}/${BASE_FILENAME})

    if(${ORIG_EXT} MATCHES "\.s$")
        set(GAS_LISTING "-al=${DST_BASENAME}.lst")
        
        add_custom_command(
            OUTPUT ${DST_BASENAME}.o
            DEPENDS ${SRC_FILE}
            BYPRODUCTS ${DST_BASENAME}.lst
            COMMAND mkdir -p ${BOOT_OUT_DIR}/${BASE_SUBDIR}
            COMMAND ${I686_ASSEMBLER} ${SRC_FILE} ${GAS_LISTING} "-o" ${DST_BASENAME}.o 
        )

        set(${output_filename} ${DST_BASENAME}.o PARENT_SCOPE)
    endif()

endfunction()


# Define sources
set(BOOTLOADER_SOURCES
    boot.s
)


# Preprocess sources
foreach(FILE ${BOOTLOADER_SOURCES})
    bootloader_preprocess(${FILE} OUTFILE)
    set(BOOTLOADER_OBJECTS ${BOOTLOADER_OBJECTS} ${OUTFILE})
endforeach()


# Create build command and build target
set(BOOTLOADER_COMPILE_COMMAND ${I686_LINKER} "-o" "${BIN_PATH}/boot.bin" "${BOOT_LINK_OPTIONS}" "${BOOTLOADER_OBJECTS}")

add_custom_target(
    BootPartition ALL
    DEPENDS ${BOOTLOADER_OBJECTS}
    COMMAND mkdir -p ${BIN_PATH}
    COMMAND ${BOOTLOADER_COMPILE_COMMAND}
)
