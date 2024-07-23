# Install script for directory: D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/eigen3/src/3.4.0-74a8d62212.clean/unsupported/Eigen

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/pkgs/eigen3_x64-windows")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
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
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/eigen3/unsupported/Eigen" TYPE FILE FILES
    "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/eigen3/src/3.4.0-74a8d62212.clean/unsupported/Eigen/AdolcForward"
    "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/eigen3/src/3.4.0-74a8d62212.clean/unsupported/Eigen/AlignedVector3"
    "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/eigen3/src/3.4.0-74a8d62212.clean/unsupported/Eigen/ArpackSupport"
    "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/eigen3/src/3.4.0-74a8d62212.clean/unsupported/Eigen/AutoDiff"
    "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/eigen3/src/3.4.0-74a8d62212.clean/unsupported/Eigen/BVH"
    "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/eigen3/src/3.4.0-74a8d62212.clean/unsupported/Eigen/EulerAngles"
    "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/eigen3/src/3.4.0-74a8d62212.clean/unsupported/Eigen/FFT"
    "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/eigen3/src/3.4.0-74a8d62212.clean/unsupported/Eigen/IterativeSolvers"
    "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/eigen3/src/3.4.0-74a8d62212.clean/unsupported/Eigen/KroneckerProduct"
    "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/eigen3/src/3.4.0-74a8d62212.clean/unsupported/Eigen/LevenbergMarquardt"
    "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/eigen3/src/3.4.0-74a8d62212.clean/unsupported/Eigen/MatrixFunctions"
    "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/eigen3/src/3.4.0-74a8d62212.clean/unsupported/Eigen/MoreVectorization"
    "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/eigen3/src/3.4.0-74a8d62212.clean/unsupported/Eigen/MPRealSupport"
    "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/eigen3/src/3.4.0-74a8d62212.clean/unsupported/Eigen/NonLinearOptimization"
    "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/eigen3/src/3.4.0-74a8d62212.clean/unsupported/Eigen/NumericalDiff"
    "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/eigen3/src/3.4.0-74a8d62212.clean/unsupported/Eigen/OpenGLSupport"
    "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/eigen3/src/3.4.0-74a8d62212.clean/unsupported/Eigen/Polynomials"
    "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/eigen3/src/3.4.0-74a8d62212.clean/unsupported/Eigen/Skyline"
    "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/eigen3/src/3.4.0-74a8d62212.clean/unsupported/Eigen/SparseExtra"
    "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/eigen3/src/3.4.0-74a8d62212.clean/unsupported/Eigen/SpecialFunctions"
    "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/eigen3/src/3.4.0-74a8d62212.clean/unsupported/Eigen/Splines"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/eigen3/unsupported/Eigen" TYPE DIRECTORY FILES "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/eigen3/src/3.4.0-74a8d62212.clean/unsupported/Eigen/src" FILES_MATCHING REGEX "/[^/]*\\.h$")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/eigen3/x64-windows-rel/unsupported/Eigen/CXX11/cmake_install.cmake")

endif()

