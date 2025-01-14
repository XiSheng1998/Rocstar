# This file contains code which must run to start up the build system, and includes files that are common to Amber and every submodule.
# This file must run AFTER a project() command without any languages, but BEFORE the enable_language() command


if(NOT DEFINED FIRST_RUN)

	# create a cache variable which is shadowed by a local variable
	set(FIRST_RUN FALSE CACHE INTERNAL "Variable to track if it is currently the first time the build system is run" FORCE)
	set(FIRST_RUN TRUE)

endif()


# print header
# --------------------------------------------------------------------
message(STATUS "**************************************************************************")
message(STATUS "Starting configuration of ${PROJECT_NAME} version ${${PROJECT_NAME}_VERSION}...")

# print CMake version at the start so we can use it to diagnose issues even if the configure fails
message(STATUS "CMake Version: ${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}.${CMAKE_PATCH_VERSION}")
message(STATUS "For how to use this build system, please read this wiki:")
message(STATUS "    http://ambermd.org/pmwiki/pmwiki.php/Main/CMake")
message(STATUS "For a list of important CMake variables, check here:")
message(STATUS "    http://ambermd.org/pmwiki/pmwiki.php/Main/CMake-Common-Options")
message(STATUS "**************************************************************************")

# fix search path so that libraries from the install tree are not used
# --------------------------------------------------------------------
list(REMOVE_ITEM CMAKE_SYSTEM_PREFIX_PATH "${CMAKE_INSTALL_PREFIX}")

# eliminate extraneous install messages
# --------------------------------------------------------------------
set(CMAKE_INSTALL_MESSAGE LAZY)

# configure module path
# --------------------------------------------------------------------

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR} 
	"${CMAKE_CURRENT_LIST_DIR}/find-modules" 
	"${CMAKE_CURRENT_LIST_DIR}/patched-cmake-modules"
	"${CMAKE_CURRENT_LIST_DIR}/hanjianwei")

# includes
# --------------------------------------------------------------------

#Basic utilities.  These files CANNOT use any sort of compile checks or system introspection because no languages are enabled yet
include(CMakeParseArguments)
include(Utils)
include(Shorthand)
include(ColorMessage)
include(Policies NO_POLICY_SCOPE)

# get install directories
include(InstallDirs)

#control default build type.
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------

set(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "Allowed build types for Amber.  This only controls debugging flags, set the OPTIMIZE variable to control compiler optimizations." FORCE)
if("${CMAKE_BUILD_TYPE}" STREQUAL "")
	set(CMAKE_BUILD_TYPE Release CACHE STRING "Type of build.  Controls debugging information and optimizations." FORCE)
endif()
