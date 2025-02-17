if(CMAKE_COMPILER_IS_GNUCXX)
    SET_SOURCE_FILES_PROPERTIES(pcrmfpy.cc
        COMPILE_FLAGS
            "-Wno-strict-aliasing"
    )
endif()

# NO_EXTRAS required for success on macOS conda build
pybind11_add_module(_pcraster_modflow_python MODULE NO_EXTRAS THIN_LTO
    pcrmfpy.cc
)

if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    # It seems that clang doesn't set flag this by default yet
    set_property(
        SOURCE
            pcrmfpy.cc
        PROPERTY
            COMPILE_OPTIONS
                -fsized-deallocation
    )
endif()

target_include_directories(_pcraster_modflow_python
    PRIVATE
        $<TARGET_PROPERTY:pcraster::pcrmf_python,INTERFACE_INCLUDE_DIRECTORIES>
)

add_library(pcraster::modflow_python ALIAS _pcraster_modflow_python)

# TODO why is Python::module not working on Linux?
if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    target_link_libraries(_pcraster_modflow_python
      PUBLIC
        pcraster::pcrmf_python
      PRIVATE
        Python::Python
    )
else()
    target_link_libraries(_pcraster_modflow_python
      PUBLIC
        pcraster::pcrmf_python
      PRIVATE
        Python::Module
    )
endif()

set_target_properties(_pcraster_modflow_python
    PROPERTIES
        PREFIX "${PYTHON_MODULE_PREFIX}"
        SUFFIX "${PYTHON_MODULE_EXTENSION}"
)

add_dependencies(_pcraster_modflow_python
    _pcraster
    pcraster_modflow
)

# configure_python_extension(_pcraster_modflow_python
#     "_pcraster_modflow"
# )

set_target_properties(_pcraster_modflow_python
    PROPERTIES
        LIBRARY_OUTPUT_DIRECTORY  "$<TARGET_FILE_DIR:pcrcalc>/pcraster"
        RUNTIME_OUTPUT_DIRECTORY  "$<TARGET_FILE_DIR:pcrcalc>/pcraster"
        OUTPUT_NAME               "_pcraster_modflow"
        DEBUG_POSTFIX ""
        INSTALL_RPATH             "\\\$ORIGIN/../../lib"
)


#----------------------------------------------------------
install(
    TARGETS _pcraster_modflow_python
    LIBRARY DESTINATION ${PCRASTER_PYTHON_INSTALL_DIR}/pcraster
    RUNTIME DESTINATION ${PCRASTER_PYTHON_INSTALL_DIR}/pcraster
)
