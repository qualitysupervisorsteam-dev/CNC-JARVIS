cmake_minimum_required(VERSION 3.20)

project(cnc_cad VERSION 0.4.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

enable_testing()

set(OCCT_ROOT "" CACHE PATH "Open CASCADE Technology SDK root directory")
if(NOT OCCT_ROOT)
  message(FATAL_ERROR "OCCT_ROOT must be provided.")
endif()

find_path(OCCT_INCLUDE_DIR Standard.hxx
  PATHS
    "${OCCT_ROOT}/inc"
    "${OCCT_ROOT}/include"
  NO_DEFAULT_PATH)
if(NOT OCCT_INCLUDE_DIR)
  message(FATAL_ERROR "OCCT Standard.hxx was not found under ${OCCT_ROOT}/inc or ${OCCT_ROOT}/include")
endif()

find_path(OCCT_LIBRARY_DIR NAMES TKernel.lib
  PATHS
    "${OCCT_ROOT}/win64/vc14/lib"
    "${OCCT_ROOT}/lib"
  NO_DEFAULT_PATH)
if(NOT OCCT_LIBRARY_DIR)
  message(FATAL_ERROR "OCCT libraries were not found under ${OCCT_ROOT}/win64/vc14/lib or ${OCCT_ROOT}/lib")
endif()

set(OCCT_TOOLKITS
  TKernel TKMath TKG2d TKG3d TKGeomBase TKBRep TKGeomAlgo TKTopAlgo TKPrim TKMesh
  TKXSBase TKDE TKDESTEP TKDEIGES)

set(OCCT_LIBRARIES)
foreach(OCCT_TOOLKIT IN LISTS OCCT_TOOLKITS)
  find_library(OCCT_${OCCT_TOOLKIT}_LIBRARY NAMES ${OCCT_TOOLKIT}
    PATHS "${OCCT_LIBRARY_DIR}" NO_DEFAULT_PATH REQUIRED)
  list(APPEND OCCT_LIBRARIES "${OCCT_${OCCT_TOOLKIT}_LIBRARY}")
endforeach()

add_library(cnc_cad SHARED src/cnc_cad.cpp)
target_include_directories(cnc_cad PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/include" "${OCCT_INCLUDE_DIR}")
target_link_libraries(cnc_cad PRIVATE ${OCCT_LIBRARIES})

if(WIN32)
  set_target_properties(cnc_cad PROPERTIES WINDOWS_EXPORT_ALL_SYMBOLS TRUE)
  target_compile_definitions(cnc_cad PRIVATE CNC_CAD_BUILD)
endif()

add_executable(cnc_cad_test tests/cnc_cad_test.cpp)
target_include_directories(cnc_cad_test PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/include" "${OCCT_INCLUDE_DIR}")
target_link_libraries(cnc_cad_test PRIVATE cnc_cad)

add_test(NAME cnc_cad_native_test
  COMMAND $<TARGET_FILE:cnc_cad_test> "${CMAKE_CURRENT_SOURCE_DIR}/../../test/fixtures/box_20x20x20.step")
