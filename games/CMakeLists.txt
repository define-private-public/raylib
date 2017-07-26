# Setup the project and settings
project(games)

include("../utils.cmake")

# Get the source toegher
file(GLOB sources *.c)

# Do each game
foreach(game_source ${sources})
  # Create the basename for the game
  get_filename_component(game_name ${game_source} NAME)
  string(REPLACE ".c" "" game_name ${game_name})
  
  # Setup the game
  add_executable(${game_name} ${game_source})

  # Link the libraries
  link_libraries_to_executable(${game_name})
endforeach()

# TODO the games w/ subdirectories

