cmake_minimum_required(VERSION 3.0)
project(raylib)

set(raylib_VERSION_MAJOR 1)
set(raylib_VERSION_MINOR 8)
set(SHARED_RAYLIB OFF)  

file(GLOB sources *.c)

# Build a static or shared raylib?
if(${SHARED_RAYLIB})
  set(library_type SHARED)
else(${SHARED_RAYLIB})
  set(library_type STATIC)
endif(${SHARED_RAYLIB})

# Library file & Header
add_library(raylib ${library_type} ${sources}) 
set_target_properties(raylib PROPERTIES PUBLIC_HEADER "raylib.h")
install(
  TARGETS raylib
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  PUBLIC_HEADER DESTINATION include
)
