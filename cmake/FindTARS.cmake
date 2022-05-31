include(FindPackageHandleStandardArgs)
include(ExternalProject)
include(GNUInstallDirs)

add_library(TARS MODULE IMPORTED)
# Check found directory
if(NOT TARS_ROOT_DIR)
  message(STATUS "Install TARS from github")
  set(TARS_INSTALL ${CMAKE_CURRENT_BINARY_DIR}/tars-install)

  ExternalProject_Add(tars-project
    URL https://${URL_BASE}/FISCO-BCOS/TarsCpp/archive/7299ad23830b50ca6284e11bb0374f2670f23cdf.tar.gz
    URL_HASH SHA1=9667c0d775bbbc6400a47034bee86003888db978
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${TARS_INSTALL} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
  )

  set(TARS_INCLUDE_DIRS "${TARS_INSTALL}/include")
  make_directory(${TARS_INCLUDE_DIRS})
  set(TARS_LIBRARIES
    "${TARS_INSTALL}/${CMAKE_INSTALL_LIBDIR}/${CMAKE_STATIC_LIBRARY_PREFIX}tarsparse${CMAKE_STATIC_LIBRARY_SUFFIX}"
    "${TARS_INSTALL}/${CMAKE_INSTALL_LIBDIR}/${CMAKE_STATIC_LIBRARY_PREFIX}tarsservant${CMAKE_STATIC_LIBRARY_SUFFIX}"
    "${TARS_INSTALL}/${CMAKE_INSTALL_LIBDIR}/${CMAKE_STATIC_LIBRARY_PREFIX}tarsutil${CMAKE_STATIC_LIBRARY_SUFFIX}"
  )
  set(TARS_TARS2CPP ${TARS_INSTALL}/tools/tarscpp)

  add_dependencies(TARS evmc-project)
  set(TARS_ROOT_DIR ${TARS_INSTALL})
endif()

message(STATUS "Find TARS in ${TARS_ROOT_DIR}")
find_program(TARS_TARS2CPP NAMES tars2cpp PATHS ${TARS_ROOT_DIR}/tools/ REQUIRED)
find_path(TARS_INCLUDE_DIRS NAMES framework servant PATHS ${TARS_ROOT_DIR}/include/ REQUIRED)
find_library(TARS_LIBRARIES NAMES
  ${CMAKE_STATIC_LIBRARY_PREFIX}tarsparse${CMAKE_STATIC_LIBRARY_SUFFIX}
  ${CMAKE_STATIC_LIBRARY_PREFIX}tarsservant${CMAKE_STATIC_LIBRARY_SUFFIX}
  ${CMAKE_STATIC_LIBRARY_PREFIX}tarsutil${CMAKE_STATIC_LIBRARY_SUFFIX}
  PATHS ${TARS_ROOT_DIR}/${CMAKE_INSTALL_LIBDIR} REQUIRED)

target_include_directories(TARS INTERFACE ${TARS_INCLUDE_DIRS})
set_property(TARGET TARS PROPERTY IMPORTED_LOCATION ${TARS_LIBRARIES})

set(TARS_FOUND ON)