cmake_minimum_required(VERSION 3.0)

# Detect linux
if(UNIX AND NOT APPLE)
  set(LINUX TRUE)
endif()

# Setup the project and settings
project(examples)

# Need GLFW 3.2.1
find_package(glfw3 3.2.1 REQUIRED)

# Make sure raylib has been build
# TODO `build` directory should maybe be somethign else...
include_directories("../build/release")

# Get the sources together
file(GLOB_RECURSE example_sources
  audio/*.c
  core/*.c
  models/*.c
  others/*.c
  physac/*.c
  shaders/*.c
  shapes/*.c
  text/*.c
  textures/*.c
)

# On OS X for shared libs we need the -framework when doing .dylib stuff
if(APPLE)
  find_library(OPENGL_LIBRARY OpenGL)
  find_library(OPENAL_LIBRARY OpenAL)
  find_library(COCOA_LIBRARY Cocoa)
  set(OSX_FRAMEWORKS ${OPENGL_LIBRARY} ${OPENAL_LIBRARY} ${COCOA_LIBRARY})
endif()

# Do each example
foreach(example_source ${example_sources})
  # Create the basename for the example
  get_filename_component(example_name ${example_source} NAME)
  string(REPLACE ".c" "" example_name ${example_name})

  # Setup the example
  add_executable(${example_name} ${example_source})

  # Link the libraries
  # OpenAL is a little platform dependant
  if(APPLE)
    # OS X, we use multiple frameworks
    target_link_libraries(${example_name} ${OSX_FRAMEWORKS})
  elseif(LINUX)
    # Elsewhere (such as Linux), need `-lopenal -lGL`, etc...
    target_link_libraries(${example_name} m pthread dl)
    target_link_libraries(${example_name} openal)
    target_link_libraries(${example_name} GL)
    target_link_libraries(${example_name} X11 Xrandr Xinerama Xi Xxf86vm Xcursor) #X11 stuff
  else()
    # TODO windows
  endif()
  
  # Add in GLFW as a linking target
  target_link_libraries(${example_name} glfw)

  # And raylib
  target_link_libraries(${example_name} raylib)
endforeach()


