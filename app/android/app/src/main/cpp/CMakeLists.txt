cmake_minimum_required(VERSION 3.22.1)

# Phase 1: minimal simavr subset (core + ATmega32) + JNI bridge.
# Upstream Makefiles are POSIX-only, so sources are listed explicitly.
# Deliberately compiled WITHOUT -DHAVE_LIBELF (NDK ships no libelf):
# sim_elf.c then builds its no-ELF fallback, and firmware loads via HEX.

project("simavr_jni" C)

set(SIMAVR_DIR ${CMAKE_CURRENT_SOURCE_DIR}/third_party/simavr)

file(GLOB SIMAVR_SIM_SOURCES ${SIMAVR_DIR}/sim/sim_*.c ${SIMAVR_DIR}/sim/avr_*.c)
# Family-shared init/reset for the mega32 core (mx_init/mx_reset).
list(APPEND SIMAVR_CORE_SOURCES
    ${SIMAVR_DIR}/cores/sim_mega32.c
    ${SIMAVR_DIR}/cores/sim_megax.c
)

add_library(simavr_jni SHARED
    simavr_jni.c
    ${SIMAVR_SIM_SOURCES}
    ${SIMAVR_CORE_SOURCES}
)

target_include_directories(simavr_jni PRIVATE
    ${SIMAVR_DIR}
    ${SIMAVR_DIR}/sim
    ${SIMAVR_DIR}/cores
)

# NOTE: do NOT define AVR_CORE here. Upstream defines it only for cores/*.c;
# sim_avr.h hides the logger typedef behind #ifndef AVR_CORE, while sim_avr.c
# uses it unconditionally. Likewise AVR_KIND_DECL is defined by sim_avr.c
# itself (line 37) before pulling in sim_core_decl.h.

target_compile_options(simavr_jni PRIVATE
    -O2 -Wall -Wextra
    -Wno-unused-parameter -Wno-unused-result
    -Wno-missing-field-initializers -Wno-sign-compare
    # Portable 64/32-bit regression gate: simavr predates LP64 discipline.
    # Any pointer<->int truncation introduced (or exposed) here fails the build
    # on every ABI instead of crashing on device. No device-specific flags.
    -Werror=pointer-to-int-cast
    -Werror=int-to-pointer-cast
)

find_library(log-lib log)
target_link_libraries(simavr_jni ${log-lib} m)
