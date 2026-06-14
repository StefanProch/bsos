set(_srcdir ${CMAKE_CURRENT_LIST_DIR}/mpfr)

if (MSVC)
    set(_output  ${DESTDIR}/include/mpfr.h
                 ${DESTDIR}/include/mpf2mpfr.h
                 ${DESTDIR}/lib/libmpfr-4.lib
                 ${DESTDIR}/bin/libmpfr-4.dll)

    set(_mpfr_sources
        ${_srcdir}/include/mpfr.h
        ${_srcdir}/include/mpf2mpfr.h
        ${_srcdir}/lib/win-${DEPS_ARCH}/libmpfr-4.lib
        ${_srcdir}/lib/win-${DEPS_ARCH}/libmpfr-4.dll
    )

    add_custom_target(dep_MPFR
        COMMAND ${CMAKE_COMMAND} -E make_directory ${DESTDIR}/include ${DESTDIR}/lib ${DESTDIR}/bin
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${_srcdir}/include/mpfr.h ${DESTDIR}/include/mpfr.h
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${_srcdir}/include/mpf2mpfr.h ${DESTDIR}/include/mpf2mpfr.h
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${_srcdir}/lib/win-${DEPS_ARCH}/libmpfr-4.lib ${DESTDIR}/lib/libmpfr-4.lib
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${_srcdir}/lib/win-${DEPS_ARCH}/libmpfr-4.dll ${DESTDIR}/bin/libmpfr-4.dll
        BYPRODUCTS ${_output}
        DEPENDS ${_mpfr_sources}
        VERBATIM
    )
    add_dependencies(dep_MPFR dep_GMP)

else ()

    set(_cross_compile_arg "")
    if (CMAKE_CROSSCOMPILING)
        # TOOLCHAIN_PREFIX should be defined in the toolchain file
        set(_cross_compile_arg --host=${TOOLCHAIN_PREFIX})
    endif ()

    ExternalProject_Add(dep_MPFR
        URL https://ftp.gnu.org/gnu/mpfr/mpfr-4.2.2.tar.bz2
            https://www.mpfr.org/mpfr-4.2.2/mpfr-4.2.2.tar.bz2
        URL_HASH SHA256=9ad62c7dc910303cd384ff8f1f4767a655124980bb6d8650fe62c815a231bb7b
        DOWNLOAD_DIR ${DEP_DOWNLOAD_DIR}/MPFR
        BUILD_IN_SOURCE ON
        CONFIGURE_COMMAND autoreconf -f -i && 
                          env "CC=${CMAKE_C_COMPILER}" "CXX=${CMAKE_CXX_COMPILER}" "CFLAGS=${_gmp_ccflags}" "CXXFLAGS=${_gmp_ccflags}" "LDFLAGS=${CMAKE_EXE_LINKER_FLAGS}" ./configure ${_cross_compile_arg} --prefix=${DESTDIR} --enable-shared=no --enable-static=yes --with-gmp=${DESTDIR} ${_gmp_build_tgt}
        BUILD_COMMAND make -j
        INSTALL_COMMAND make install
        DEPENDS dep_GMP
    )
endif ()
