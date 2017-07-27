# Setup the project and settings
project(raylib)
include("../utils.cmake")

set(raylib_VERSION_MAJOR 1)
set(raylib_VERSION_MINOR 8)

# Config options
set(SHARED_RAYLIB OFF CACHE BOOL "Build raylib as a dynamic library")  

# Get the sources together
file(GLOB raylib_sources *.c)
file(GLOB stb_vorbis external/stb_vorbis.c)
set(sources ${raylib_sources} ${stb_vorbis})

# Build a static or shared raylib?
if(${SHARED_RAYLIB})
  # Shared library
  add_library(raylib SHARED ${sources}) 

  # Will link -framework (if on OS X)
  link_os_x_frameworks(raylib)
else()
  # Static library
  add_library(raylib STATIC ${sources}) 

  if(LINUX)
    # On Linux, need to link a few extra things for static
    target_link_libraries(raylib m pthread dl)
    target_link_libraries(raylib X11 Xrandr Xinerama Xi Xxf86vm Xcursor)  # X11 stuff
  endif()
endif()

# Always need to link OpenAL and OpenGL
if(LINUX)
  # Elsewhere (such as Linux), need `-lopenal -lGL`
  target_link_libraries(raylib openal)
  target_link_libraries(raylib GL)
endif()

# Add in GLFW as a linking target
target_link_libraries(raylib glfw)

# Library file & Header
set_target_properties(raylib PROPERTIES PUBLIC_HEADER "raylib.h")
install(
  TARGETS raylib
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  PUBLIC_HEADER DESTINATION include
)

# Copy the header files to the build directory
file(COPY "raylib.h" DESTINATION ".")
file(COPY "physac.h" DESTINATION ".")
file(COPY "raymath.h" DESTINATION ".")
file(COPY "audio.h" DESTINATION ".")
