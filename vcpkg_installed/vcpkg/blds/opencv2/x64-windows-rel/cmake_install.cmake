# Install script for directory: D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/opencv2/src/2.4.13.7-9017b199ee.clean

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/pkgs/opencv2_x64-windows")
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

if(CMAKE_INSTALL_COMPONENT STREQUAL "dev" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/opencv2.4/opencv2" TYPE FILE FILES "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/opencv2/x64-windows-rel/opencv2/opencv_modules.hpp")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "dev" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/opencv2" TYPE FILE FILES "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/opencv2/x64-windows-rel/unix-install/OpenCVConfig.cmake")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "dev" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/opencv2" TYPE FILE FILES "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/opencv2/x64-windows-rel/unix-install/OpenCVConfig-version.cmake")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "dev" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/share/opencv2/OpenCVModules.cmake")
    file(DIFFERENT _cmake_export_file_changed FILES
         "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/share/opencv2/OpenCVModules.cmake"
         "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/opencv2/x64-windows-rel/CMakeFiles/Export/07b21a2e0040897beca74f5a4497fcb2/OpenCVModules.cmake")
    if(_cmake_export_file_changed)
      file(GLOB _cmake_old_config_files "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/share/opencv2/OpenCVModules-*.cmake")
      if(_cmake_old_config_files)
        string(REPLACE ";" ", " _cmake_old_config_files_text "${_cmake_old_config_files}")
        message(STATUS "Old export file \"$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/share/opencv2/OpenCVModules.cmake\" will be replaced.  Removing files [${_cmake_old_config_files_text}].")
        unset(_cmake_old_config_files_text)
        file(REMOVE ${_cmake_old_config_files})
      endif()
      unset(_cmake_old_config_files)
    endif()
    unset(_cmake_export_file_changed)
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/opencv2" TYPE FILE FILES "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/opencv2/x64-windows-rel/CMakeFiles/Export/07b21a2e0040897beca74f5a4497fcb2/OpenCVModules.cmake")
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/opencv2" TYPE FILE FILES "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/opencv2/x64-windows-rel/CMakeFiles/Export/07b21a2e0040897beca74f5a4497fcb2/OpenCVModules-release.cmake")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "libs" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/." TYPE FILE PERMISSIONS OWNER_READ GROUP_READ WORLD_READ FILES "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/opencv2/src/2.4.13.7-9017b199ee.clean/LICENSE")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/opencv2/x64-windows-rel/include/cmake_install.cmake")
  include("D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/opencv2/x64-windows-rel/modules/cmake_install.cmake")
  include("D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/opencv2/x64-windows-rel/doc/cmake_install.cmake")
  include("D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/opencv2/x64-windows-rel/data/cmake_install.cmake")

endif()

if(CMAKE_INSTALL_COMPONENT)
  set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
file(WRITE "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/opencv2/x64-windows-rel/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
