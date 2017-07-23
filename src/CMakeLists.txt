cmake_minimum_required(VERSION 3.0)

# Setup the project and settings
project(raylib)
set(raylib_VERSION_MAJOR 1)
set(raylib_VERSION_MINOR 8)
set(SHARED_RAYLIB OFF CACHE BOOL "Build raylib as a dynamic library")  

# Need GLFW 3.2.1
find_package(glfw3 3.2.1 REQUIRED)

# Get the sources togheter
file(GLOB raylib_sources *.c)
file(GLOB stb_vorbis external/stb_vorbis.c)
set(sources ${raylib_sources} ${stb_vorbis})

# Build a static or shared raylib?
if(${SHARED_RAYLIB})
  # Shared library
  add_library(raylib SHARED ${sources}) 

  # On OS X for shared libs we need the -framework when doing .dylib stuff
  if(APPLE)
    find_library(OPENGL_LIBRARY OpenGL)
    find_library(OPENAL_LIBRARY OpenAL)
    find_library(COCOA_LIBRARY Cocoa)
    set(OSX_FRAMEWORKS ${OPENGL_LIBRARY} ${OPENAL_LIBRARY} ${COCOA_LIBRARY})
  endif()
else()
  # Static library
  add_library(raylib STATIC ${sources}) 
endif()

# Add in GLFW as a linking target
target_link_libraries(raylib glfw)

# OpenAL is a little platform dependant
if(APPLE)
  # OS X, we use multiple frameworks
  target_link_libraries(raylib ${OSX_FRAMEWORKS})
else()
  # Elsewhere (such as Linux), need`-lopenal -lGL`
  target_link_libraries(raylib openal)
  target_link_libraries(raylib GL)
endif()

# Library file & Header
set_target_properties(raylib PROPERTIES PUBLIC_HEADER "raylib.h")
install(
  TARGETS raylib
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  PUBLIC_HEADER DESTINATION include
)

