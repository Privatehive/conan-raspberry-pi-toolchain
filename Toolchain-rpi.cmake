# The package contains either the 64 bit or the 32 bit toolchain
if(EXISTS "${CMAKE_CURRENT_LIST_DIR}/x-tools/aarch64-rpi3-linux-gnu")
    set(RPI_GCC_TRIPLE "aarch64-rpi3-linux-gnu")
    set(RPI_SYSTEM_PROCESSOR "aarch64")
    set(RPI_LIBRARY_ARCHITECTURE "aarch64-linux-gnu")
    set(ARCH_FLAGS "-mcpu=cortex-a53+crc+simd")
else()
    set(RPI_GCC_TRIPLE "armv6-rpi-linux-gnueabihf")
    set(RPI_SYSTEM_PROCESSOR "arm")
    set(RPI_LIBRARY_ARCHITECTURE "arm-linux-gnueabihf")
    set(ARCH_FLAGS "-mcpu=arm1176jzf-s")
endif()

set(TOOLCHAIN_ROOT "${CMAKE_CURRENT_LIST_DIR}/x-tools/${RPI_GCC_TRIPLE}")
set(SYSROOT_PATH "${TOOLCHAIN_ROOT}/${RPI_GCC_TRIPLE}/sysroot")

# Cross-compilation system information
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR ${RPI_SYSTEM_PROCESSOR})

# The sysroot contains all the libraries we might need to link against and 
# possibly headers we need for compilation
set(CMAKE_SYSROOT ${SYSROOT_PATH})
set(CMAKE_FIND_ROOT_PATH ${CMAKE_SYSROOT})
set(CMAKE_LIBRARY_ARCHITECTURE ${RPI_LIBRARY_ARCHITECTURE})
#set(CMAKE_STAGING_PREFIX $ENV{HOME}/RPi-dev/staging-armv6-rpi)

# Set the compilers for C, C++ and Fortran
set(CMAKE_C_COMPILER ${RPI_GCC_TRIPLE}-gcc CACHE FILEPATH "C compiler")
set(CMAKE_CXX_COMPILER ${RPI_GCC_TRIPLE}-g++ CACHE FILEPATH "C++ compiler")
set(CMAKE_Fortran_COMPILER ${RPI_GCC_TRIPLE}-gfortran CACHE FILEPATH "Fortran compiler")

# Set the architecture-specific compiler flags
set(CMAKE_C_FLAGS_INIT ${ARCH_FLAGS})
set(CMAKE_CXX_FLAGS_INIT ${ARCH_FLAGS})
set(CMAKE_Fortran_FLAGS_INIT ${ARCH_FLAGS})

set(CMAKE_SHARED_LINKER_FLAGS "${COMMON_FLAGS} ${CMAKE_SHARED_LINKER_FLAGS}" )
set(CMAKE_MODULE_LINKER_FLAGS "${COMMON_FLAGS} ${CMAKE_MODULE_LINKER_FLAGS}" )
set(CMAKE_EXE_LINKER_FLAGS    "${COMMON_FLAGS} ${CMAKE_EXE_LINKER_FLAGS}" )

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

set(OpenGL_GL_PREFERENCE LEGACY)

set(QT_HOST_PATH "$ENV{QT_HOST_PATH}" CACHE PATH "Set QT_HOST_PATH")

install(FILES "${SYSROOT_PATH}/lib/libstdc++.so.6.0.32" "${SYSROOT_PATH}/lib/libstdc++.so.6" "${SYSROOT_PATH}/lib/libstdc++.so" DESTINATION "lib")
