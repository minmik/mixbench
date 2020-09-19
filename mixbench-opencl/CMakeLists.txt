cmake_minimum_required(VERSION 3.7 FATAL_ERROR)
project(mixbench-ocl LANGUAGES CXX)

#find_package(OpenCL REQUIRED)
# Manually set OpenCL directories
set(OpenCL_INCLUDE_DIR /home/jongminkim/project/OpenCL-Headers)
# add_library(opencl_library SHARED IMPORTED)
# set_property(TARGET opencl_library PROPERTY IMPORTED_LOCATION /home/jongminkim/project/libOpenCL.so)
set(OpenCL_LIBRARY /home/jongminkim/project/libOpenCL.so)


include_directories(${OpenCL_INCLUDE_DIR} "../include")
link_directories("/home/jongminkim/project")

# Get version info from git tag
execute_process(COMMAND git describe --tags --always
                OUTPUT_VARIABLE GIT_REV
                ERROR_QUIET)

# Store version info
if ("${GIT_REV}" STREQUAL "")
    set(GIT_REV "")
endif()
string(STRIP "${GIT_REV}" GIT_REV)
file(WRITE "version_info.h" "#define VERSION_INFO \"")
file(APPEND "version_info.h" ${GIT_REV})
file(APPEND "version_info.h" "\"")

add_executable(mixbench-ocl-alt main-ocl.cpp mix_kernels_ocl.h loclutil.h mix_kernels_ocl.cpp mix_kernels_ocl.h loclutil.h)
add_executable(mixbench-ocl-ro main-ocl.cpp mix_kernels_ocl.h loclutil.h mix_kernels_ocl_ro.cpp mix_kernels_ocl_ro.h loclutil.h)
file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/mix_kernels.cl
        DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/mix_kernels_ro.cl
        DESTINATION ${CMAKE_CURRENT_BINARY_DIR})

target_compile_definitions(mixbench-ocl-ro PRIVATE READONLY)

try_compile(HAVE_HALF2 ${CMAKE_BINARY_DIR}
        ${CMAKE_SOURCE_DIR}/check-half2-def.cpp
		CMAKE_FLAGS "-DINCLUDE_DIRECTORIES:STRING=${OpenCL_INCLUDE_DIR}")

#if(${OpenCL_VERSION_MAJOR} LESS 2)
if(NOT ${HAVE_HALF2})
	message( "cl_half2 workaround path" )
	target_compile_definitions(mixbench-ocl-alt PRIVATE HF_WORKAROUND)
	target_compile_definitions(mixbench-ocl-ro PRIVATE HF_WORKAROUND)
endif()

target_link_libraries(mixbench-ocl-alt ${OpenCL_LIBRARY} "/home/jongminkim/project/libc++.so" "/home/jongminkim/project/libcutils.so" "/home/jongminkim/project/liblog.so")
target_link_libraries(mixbench-ocl-ro ${OpenCL_LIBRARY} "/home/jongminkim/project/libc++.so" "/home/jongminkim/project/libcutils.so"  "/home/jongminkim/project/liblog.so")
