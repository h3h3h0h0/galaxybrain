# Install script for directory: D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/flatbuffers/src/v23.5.26-35b11ae345.clean

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/pkgs/flatbuffers_x64-windows")
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

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE DIRECTORY FILES "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/flatbuffers/src/v23.5.26-35b11ae345.clean/include/flatbuffers")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/flatbuffers" TYPE FILE FILES
    "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/flatbuffers/src/v23.5.26-35b11ae345.clean/CMake/flatbuffers-config.cmake"
    "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/flatbuffers/src/v23.5.26-35b11ae345.clean/CMake/BuildFlatBuffers.cmake"
    "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/flatbuffers/x64-windows-rel/flatbuffers-config-version.cmake"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/flatbuffers/x64-windows-rel/flatbuffers.lib")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/flatbuffers/FlatBuffersTargets.cmake")
    file(DIFFERENT _cmake_export_file_changed FILES
         "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/flatbuffers/FlatBuffersTargets.cmake"
         "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/flatbuffers/x64-windows-rel/CMakeFiles/Export/71b83468706c459fb1a02b1113714617/FlatBuffersTargets.cmake")
    if(_cmake_export_file_changed)
      file(GLOB _cmake_old_config_files "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/flatbuffers/FlatBuffersTargets-*.cmake")
      if(_cmake_old_config_files)
        string(REPLACE ";" ", " _cmake_old_config_files_text "${_cmake_old_config_files}")
        message(STATUS "Old export file \"$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/flatbuffers/FlatBuffersTargets.cmake\" will be replaced.  Removing files [${_cmake_old_config_files_text}].")
        unset(_cmake_old_config_files_text)
        file(REMOVE ${_cmake_old_config_files})
      endif()
      unset(_cmake_old_config_files)
    endif()
    unset(_cmake_export_file_changed)
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/flatbuffers" TYPE FILE FILES "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/flatbuffers/x64-windows-rel/CMakeFiles/Export/71b83468706c459fb1a02b1113714617/FlatBuffersTargets.cmake")
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/flatbuffers" TYPE FILE FILES "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/flatbuffers/x64-windows-rel/CMakeFiles/Export/71b83468706c459fb1a02b1113714617/FlatBuffersTargets-release.cmake")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE EXECUTABLE FILES "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/flatbuffers/x64-windows-rel/flatc.exe")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/flatbuffers/FlatcTargets.cmake")
    file(DIFFERENT _cmake_export_file_changed FILES
         "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/flatbuffers/FlatcTargets.cmake"
         "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/flatbuffers/x64-windows-rel/CMakeFiles/Export/71b83468706c459fb1a02b1113714617/FlatcTargets.cmake")
    if(_cmake_export_file_changed)
      file(GLOB _cmake_old_config_files "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/flatbuffers/FlatcTargets-*.cmake")
      if(_cmake_old_config_files)
        string(REPLACE ";" ", " _cmake_old_config_files_text "${_cmake_old_config_files}")
        message(STATUS "Old export file \"$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/flatbuffers/FlatcTargets.cmake\" will be replaced.  Removing files [${_cmake_old_config_files_text}].")
        unset(_cmake_old_config_files_text)
        file(REMOVE ${_cmake_old_config_files})
      endif()
      unset(_cmake_old_config_files)
    endif()
    unset(_cmake_export_file_changed)
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/flatbuffers" TYPE FILE FILES "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/flatbuffers/x64-windows-rel/CMakeFiles/Export/71b83468706c459fb1a02b1113714617/FlatcTargets.cmake")
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/flatbuffers" TYPE FILE FILES "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/flatbuffers/x64-windows-rel/CMakeFiles/Export/71b83468706c459fb1a02b1113714617/FlatcTargets-release.cmake")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE FILES "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/flatbuffers/x64-windows-rel/flatbuffers.pc")
endif()

if(CMAKE_INSTALL_COMPONENT)
  set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
file(WRITE "D:/Programming/galaxybrain/galaxybrain/vcpkg_installed/vcpkg/blds/flatbuffers/x64-windows-rel/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
