# Install script for directory: D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/opencv2/src/2.4.13.7-9017b199ee.clean/include

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/pkgs/opencv2_x64-windows/debug")
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

if(CMAKE_INSTALL_COMPONENT STREQUAL "dev" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/opencv2.4/opencv" TYPE FILE FILES
    "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/opencv2/src/2.4.13.7-9017b199ee.clean/include/opencv/cv.h"
    "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/opencv2/src/2.4.13.7-9017b199ee.clean/include/opencv/cv.hpp"
    "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/opencv2/src/2.4.13.7-9017b199ee.clean/include/opencv/cvaux.h"
    "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/opencv2/src/2.4.13.7-9017b199ee.clean/include/opencv/cvaux.hpp"
    "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/opencv2/src/2.4.13.7-9017b199ee.clean/include/opencv/cvwimage.h"
    "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/opencv2/src/2.4.13.7-9017b199ee.clean/include/opencv/cxcore.h"
    "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/opencv2/src/2.4.13.7-9017b199ee.clean/include/opencv/cxcore.hpp"
    "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/opencv2/src/2.4.13.7-9017b199ee.clean/include/opencv/cxeigen.hpp"
    "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/opencv2/src/2.4.13.7-9017b199ee.clean/include/opencv/cxmisc.h"
    "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/opencv2/src/2.4.13.7-9017b199ee.clean/include/opencv/highgui.h"
    "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/opencv2/src/2.4.13.7-9017b199ee.clean/include/opencv/ml.h"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "dev" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/opencv2.4/opencv2" TYPE FILE FILES "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/opencv2/src/2.4.13.7-9017b199ee.clean/include/opencv2/opencv.hpp")
endif()

