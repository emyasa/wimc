cmake_minimum_required(VERSION 3.15)
project(wimc)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

find_library(CARBON_FRAMEWORK Carbon REQUIRED)
execute_process(
    COMMAND brew --prefix libyaml
    OUTPUT_VARIABLE LIBYAML_PREFIX
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

add_executable(wimc main.c)

target_link_libraries(wimc PRIVATE ${CARBON_FRAMEWORK})
target_link_libraries(wimc PRIVATE
    "${LIBYAML_PREFIX}/lib/libyaml.a"
)

target_include_directories(wimc PRIVATE
    "${LIBYAML_PREFIX}/include"
)

add_custom_target(copy_config ALL 
    COMMAND mkdir -p ./config
    COMMAND cp -r ../config/* ./config/
)
