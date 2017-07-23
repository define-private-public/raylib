cmake_minimum_required(VERSION 3.0)
find_package(glfw3 3.2.1 REQUIRED)
#find_package(OpenAL REQUIRED)
#find_package(OpenGL REQUIRED)

project(raylib)
set(raylib_VERSION_MAJOR 1)
set(raylib_VERSION_MINOR 8)
set(SHARED_RAYLIB OFF CACHE BOOL "Build raylib as a dynamic library")  

file(GLOB raylib_sources *.c)
file(GLOB stb_vorbis external/stb_vorbis.c)
set(sources ${raylib_sources} ${stb_vorbis})

#include_directories(external)
##include_directories(external/glfw3/include)
#
## TODO replace with the GLFW3 cmake files
#find_package(glfw3 3.2.1)

# Build a static or shared raylib?
if(${SHARED_RAYLIB})
  add_library(raylib SHARED ${sources}) 

  # On OS X for shared libs we need the -framework
  if(APPLE)
    find_library(OPENGL_LIBRARY OpenGL)
    find_library(OPENAL_LIBRARY OpenAL)
    find_library(COCOA_LIBRARY Cocoa)
    set(OSX_FRAMEWORKS ${OPENGL_LIBRARY} ${OPENAL_LIBRARY} ${COCOA_LIBRARY})
  endif(APPLE)
else(${SHARED_RAYLIB})
  add_library(raylib STATIC ${sources}) 
endif(${SHARED_RAYLIB}) 

#target_include_directories(raylib ${OPENGL_INCLUDE_DIR})
#target_link_libraries(raylib ${OPENGL_gl_LIBRARY})
# Add in GLFW
target_link_libraries(raylib glfw)

# OpenAL is a little platform dependant
if(APPLE)
  # OS X, we use multiple frameworks
  target_link_libraries(raylib ${OSX_FRAMEWORKS})
else(APPlE)
  # Elsewhere (such as Linux), only need a `-lopenal`
  target_link_libraries(raylib openal)
endif(APPLE)

# Library file & Header
set_target_properties(raylib PROPERTIES PUBLIC_HEADER "raylib.h")
install(
  TARGETS raylib
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  PUBLIC_HEADER DESTINATION include
)
