# Install script for directory: D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/eigen3/src/3.4.0-74a8d62212.clean/unsupported/Eigen/CXX11

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/pkgs/eigen3_x64-windows/debug")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Debug")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "OFF")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/eigen3/unsupported/Eigen/CXX11" TYPE FILE FILES
    "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/eigen3/src/3.4.0-74a8d62212.clean/unsupported/Eigen/CXX11/Tensor"
    "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/eigen3/src/3.4.0-74a8d62212.clean/unsupported/Eigen/CXX11/TensorSymmetry"
    "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/eigen3/src/3.4.0-74a8d62212.clean/unsupported/Eigen/CXX11/ThreadPool"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/eigen3/unsupported/Eigen/CXX11" TYPE DIRECTORY FILES "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/eigen3/src/3.4.0-74a8d62212.clean/unsupported/Eigen/CXX11/src" FILES_MATCHING REGEX "/[^/]*\\.h$")
endif()
