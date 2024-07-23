# Install script for directory: D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/opencv2/src/2.4.13.7-9017b199ee.clean/modules/ts

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
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/opencv2/x64-windows-dbg/lib/opencv_ts2d.lib")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "dev" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/opencv2.4/opencv2" TYPE FILE FILES "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/opencv2/src/2.4.13.7-9017b199ee.clean/modules/ts/include/opencv2/ts.hpp")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "dev" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/opencv2.4/opencv2/ts" TYPE FILE FILES "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/opencv2/src/2.4.13.7-9017b199ee.clean/modules/ts/include/opencv2/ts/gpu_perf.hpp")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "dev" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/opencv2.4/opencv2/ts" TYPE FILE FILES "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/opencv2/src/2.4.13.7-9017b199ee.clean/modules/ts/include/opencv2/ts/gpu_test.hpp")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "dev" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/opencv2.4/opencv2/ts" TYPE FILE FILES "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/opencv2/src/2.4.13.7-9017b199ee.clean/modules/ts/include/opencv2/ts/ts.hpp")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "dev" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/opencv2.4/opencv2/ts" TYPE FILE FILES "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/opencv2/src/2.4.13.7-9017b199ee.clean/modules/ts/include/opencv2/ts/ts_gtest.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "dev" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/opencv2.4/opencv2/ts" TYPE FILE FILES "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/opencv2/src/2.4.13.7-9017b199ee.clean/modules/ts/include/opencv2/ts/ts_perf.hpp")
endif()

