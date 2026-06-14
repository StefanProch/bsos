# Minimal Eigen3 finder with imported target fallback.
# Prefer a package config when it exists, but support dependency builds that only install headers.

find_path(EIGEN3_INCLUDE_DIR
    NAMES signature_of_eigen3_matrix_library
    PATHS
        ${CMAKE_PREFIX_PATH}
        ${CMAKE_INSTALL_PREFIX}
        ${CMAKE_SOURCE_DIR}/deps/build/OrcaSlicer_dep/usr/local
    PATH_SUFFIXES include/eigen3 include/eigen eigen3 eigen
)

if(EIGEN3_INCLUDE_DIR)
    file(READ "${EIGEN3_INCLUDE_DIR}/Eigen/src/Core/util/Macros.h" _eigen3_version_header)
    string(REGEX MATCH "define[ \t]+EIGEN_WORLD_VERSION[ \t]+([0-9]+)" _eigen3_world_version_match "${_eigen3_version_header}")
    set(EIGEN3_WORLD_VERSION "${CMAKE_MATCH_1}")
    string(REGEX MATCH "define[ \t]+EIGEN_MAJOR_VERSION[ \t]+([0-9]+)" _eigen3_major_version_match "${_eigen3_version_header}")
    set(EIGEN3_MAJOR_VERSION "${CMAKE_MATCH_1}")
    string(REGEX MATCH "define[ \t]+EIGEN_MINOR_VERSION[ \t]+([0-9]+)" _eigen3_minor_version_match "${_eigen3_version_header}")
    set(EIGEN3_MINOR_VERSION "${CMAKE_MATCH_1}")
    set(Eigen3_VERSION "${EIGEN3_WORLD_VERSION}.${EIGEN3_MAJOR_VERSION}.${EIGEN3_MINOR_VERSION}")
    set(EIGEN3_VERSION "${Eigen3_VERSION}")
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Eigen3
    REQUIRED_VARS EIGEN3_INCLUDE_DIR
    VERSION_VAR Eigen3_VERSION
)

if(Eigen3_FOUND AND NOT TARGET Eigen3::Eigen)
    add_library(Eigen3::Eigen INTERFACE IMPORTED)
    set_target_properties(Eigen3::Eigen PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${EIGEN3_INCLUDE_DIR}"
    )
endif()

mark_as_advanced(EIGEN3_INCLUDE_DIR)
