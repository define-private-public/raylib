# All sorts of things that we need cross project
cmake_minimum_required(VERSION 3.0)

# Detect linux
if(UNIX AND NOT APPLE)
  set(LINUX TRUE)
endif()

# Need GLFW 3.2.1
find_package(glfw3 3.2.1 REQUIRED)

# Make sure raylib has been built
# TODO `build` directory should maybe be somethign else...
include_directories("build/release")

# Do the linking for executables that are meant to link raylib
function(link_libraries_to_executable executable)
  # Link the libraries
  if(APPLE)
    # OS X, we use multiple frameworks
    find_library(OPENGL_LIBRARY OpenGL)
    find_library(OPENAL_LIBRARY OpenAL)
    find_library(COCOA_LIBRARY Cocoa)
    set(OSX_FRAMEWORKS ${OPENGL_LIBRARY} ${OPENAL_LIBRARY} ${COCOA_LIBRARY})
    target_link_libraries(${executable} ${OSX_FRAMEWORKS})
  elseif(LINUX)
    # Elsewhere (such as Linux), need `-lopenal -lGL`, etc...
    target_link_libraries(${executable} m pthread dl)
    target_link_libraries(${executable} openal)
    target_link_libraries(${executable} GL)
    target_link_libraries(${executable} X11 Xrandr Xinerama Xi Xxf86vm Xcursor)  # X11 stuff
  else()
    # TODO windows
  endif()
  
  # Add in GLFW as a linking target
  target_link_libraries(${executable} glfw)

  # And raylib
  target_link_libraries(${executable} raylib)
endfunction()

