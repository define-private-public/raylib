cmake_minimum_required(VERSION 3.0)

# Detect linux
if(UNIX AND NOT APPLE)
  set(LINUX TRUE)
endif()

# Setup the project and settings
project(games)

# Need GLFW 3.2.1
find_package(glfw3 3.2.1 REQUIRED)

# Make sure raylib has been built
# TODO `build` directory should maybe be somethign else...
include_directories("../build/release")

# Get the sources together

# On OS X for shared libs we need the -framework when doing .dylib stuff
if(APPLE)
  find_library(OPENGL_LIBRARY OpenGL)
  find_library(OPENAL_LIBRARY OpenAL)
  find_library(COCOA_LIBRARY Cocoa)
  set(OSX_FRAMEWORKS ${OPENGL_LIBRARY} ${OPENAL_LIBRARY} ${COCOA_LIBRARY})
endif()

file(GLOB sources *.c)

# Do each game
foreach(game_source ${sources})
  # Create the basename for the game
  get_filename_component(game_name ${game_source} NAME)
  string(REPLACE ".c" "" game_name ${game_name})
  
  # Setup the game
  add_executable(${game_name} ${game_source})
  
  # Link the libraries
  # OpenAL is a little platform dependant
  if(APPLE)
    # OS X, we use multiple frameworks
    target_link_libraries(${game_name} ${OSX_FRAMEWORKS})
  elseif(LINUX)
    # Elsewhere (such as Linux), need `-lopenal -lGL`, etc...
    target_link_libraries(${game_name} m pthread dl)
    target_link_libraries(${game_name} openal)
    target_link_libraries(${game_name} GL)
    target_link_libraries(${game_name} X11 Xrandr Xinerama Xi Xxf86vm Xcursor) #X11 stuff
  else()
    # TODO windows
  endif()
  
  # Add in GLFW as a linking target
  target_link_libraries(${game_name} glfw)
  
  # And raylib
  target_link_libraries(${game_name} raylib)
endforeach()


# TODO the games w/ subdirectories
