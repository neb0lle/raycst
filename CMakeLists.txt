cmake_minimum_required(VERSION 3.1)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

project(raycst C CXX)

# glfw
find_package(glfw3 REQUIRED)

# glm
find_package(glm CONFIG REQUIRED)

# glad
set(GLAD_SOURCES_DIR "${PROJECT_SOURCE_DIR}/external/glad/")
add_subdirectory("${GLAD_SOURCES_DIR}/cmake" glad_cmake)
glad_add_library(lglad SHARED API gl:core=4.1)

# stb
include_directories(${PROJECT_SOURCE_DIR}/external/stb)

set(SOURCE_FILES src/main.cpp)

configure_file(src/shaders/vert.glsl ${CMAKE_CURRENT_BINARY_DIR} COPYONLY)
configure_file(src/shaders/frag.glsl ${CMAKE_CURRENT_BINARY_DIR} COPYONLY)

add_executable(${PROJECT_NAME} ${SOURCE_FILES})
target_include_directories(${PROJECT_NAME} PRIVATE include)

target_link_libraries(${PROJECT_NAME} PRIVATE lglad glfw glm::glm)

