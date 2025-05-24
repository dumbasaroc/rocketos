# Folder level Variables
set(BOOT2_BASE_DIR "src/boot2")
set(BOOT2_OUT_DIR "obj/boot2")

set(BOOT2_INCLUDES "-I${CMAKE_SOURCE_DIR}/src/boot2" "-I${CMAKE_SOURCE_DIR}/src/cstd")
set(BOOT2_C16FLAGS "-x" "c" "-m16" "-Wall" "-fno-builtin")
set(BOOT2_C32FLAGS "-m32" "-Wall" "-fno-builtin")
set(BOOT2_LINK_OPTIONS "-T${CMAKE_SOURCE_DIR}/src/boot2/boot2.ld")

# Preprocessing function
#  - Takes in local (to this folder) source filenames
#  - Outputs the absolute path to the file the build rule
#    will generate.
function(
    boot2_preprocess
    input_filename
    output_filename
)
    get_filename_component(BASE_FILENAME ${input_filename} NAME_WLE)
    get_filename_component(BASE_SUBDIR ${input_filename} DIRECTORY)
    get_filename_component(ORIG_EXT ${input_filename} LAST_EXT)

    set(SRC_FILE ${CMAKE_SOURCE_DIR}/${BOOT2_BASE_DIR}/${input_filename})
    set(DST_BASENAME ${CMAKE_BINARY_DIR}/${BOOT2_OUT_DIR}/${BASE_SUBDIR}/${BASE_FILENAME})
    set(GAS_LISTING "-al=${DST_BASENAME}.lst")

    if(${ORIG_EXT} MATCHES "\.s$")
        
        add_custom_command(
            OUTPUT ${DST_BASENAME}.o
            DEPENDS ${SRC_FILE}
            BYPRODUCTS ${DST_BASENAME}.lst
            COMMAND mkdir -p ${BOOT2_OUT_DIR}/${BASE_SUBDIR}
            COMMAND ${I686_ASSEMBLER} ${SRC_FILE} ${GAS_LISTING} "-o" ${DST_BASENAME}.o 
        )

        set(${output_filename} ${DST_BASENAME}.o PARENT_SCOPE)

    elseif(${ORIG_EXT} MATCHES "\.c16$")

        add_custom_command(
            OUTPUT ${DST_BASENAME}.obj
            DEPENDS ${SRC_FILE}
            BYPRODUCTS ${DST_BASENAME}.lst
            COMMAND mkdir -p ${output_base_dir}/${BASE_SUBDIR}
            COMMAND ${I686_CC} "-c" ${BOOT2_C16FLAGS} ${BOOT2_INCLUDES} ${SRC_FILE} "-o" ${DST_BASENAME}.obj "-Xassembler" ${GAS_LISTING}
        )

        set(${output_file_name} ${DST_BASENAME}.obj PARENT_SCOPE)
    
    elseif(${ORIG_EXT} MATCHES "\.c$")

        add_custom_command(
            OUTPUT ${DST_BASENAME}.obj
            DEPENDS ${SRC_FILE}
            BYPRODUCTS ${DST_BASENAME}.lst
            COMMAND mkdir -p ${output_base_dir}/${BASE_SUBDIR}
            COMMAND ${I686_CC} "-c" ${BOOT2_C32FLAGS} ${BOOT2_INCLUDES} ${SRC_FILE} "-o" ${DST_BASENAME}.obj "-Xassembler" ${GAS_LISTING}
        )

        set(${output_file_name} ${DST_BASENAME}.obj PARENT_SCOPE)
    else()
        message(STATUS "BOOT2 MISSED: ${input_filename}")
    endif()
endfunction()

set(BOOT2_SOURCES
    boot2.s
    gdt_idt/gdt_setup.c16
    gdt_idt/idt_setup.c16
    gdt_idt/gdt_struct.c16
    gdt_idt/idt_struct.c16
    interrupts/catchall_interrupt.s
    interrupts/test_kb_interrupt.s
    interrupts/test_kb_interrupt.c
    gdt_idt/pic_setup.s
    boot2.c
)

# Preprocess sources
foreach(FILE ${BOOT2_SOURCES})
    boot2_preprocess(${FILE} OUTFILE)
    set(BOOT2_OBJECTS ${BOOT2_OBJECTS} ${OUTFILE})
endforeach()


# Create build command and build target
set(BOOT2_COMPILE_COMMAND ${I686_LINKER} "-o" "${BIN_PATH}/boot2.bin" "${BOOT2_LINK_OPTIONS}" "${BOOT2_OBJECTS}")

add_custom_target(
    Boot2 ALL
    DEPENDS ${BOOT2_OBJECTS}
    COMMAND mkdir -p ${BIN_PATH}
    COMMAND ${BOOT2_COMPILE_COMMAND}
)
