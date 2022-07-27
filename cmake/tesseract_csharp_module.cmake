function(tesseract_csharp_module PY_MOD_NAME )

  cmake_parse_arguments(PY_MOD "" "NAMESPACE" "SWIG_SRCS;LIBS" ${ARGN})	

  list(GET PY_MOD_SWIG_SRCS 0 PY_MOD_SWIG_SRC1)

  set(SWIG_CXX_EXTENSION cxx)
  set_property(SOURCE ${PY_MOD_SWIG_SRC1} PROPERTY CPLUSPLUS ON)
  set_property(SOURCE ${PY_MOD_SWIG_SRC1} PROPERTY SWIG_FLAGS ${SWIG_NET_EXTRA_ARGS}
  -namespace ${PY_MOD_NAMESPACE}
  #-DSWIG2_CSHARP
  -outfile ${PY_MOD_NAME}_SWIG.cs
  #-debug-tmused
  -dllimport ${PY_MOD_NAME}_native
  -I${TESSERACT_PYTHON_SWIG_DIR} -I${CMAKE_CURRENT_SOURCE_DIR}/swig/swig_lib
  )
  
  set_property(SOURCE ${PY_MOD_SWIG_SRC1} PROPERTY USE_LIBRARY_INCLUDE_DIRECTORIES TRUE)

  #set(CMAKE_SWIG_OUTDIR ${CMAKE_CURRENT_BINARY_DIR}/python/tesseract_robotics/${PY_MOD_PACKAGE})
  set(SWIG_OUTFILE_DIR ${CMAKE_CURRENT_BINARY_DIR})
  if(${CMAKE_VERSION} VERSION_GREATER "3.8.0" OR ${CMAKE_VERSION} VERSION_EQUAL "3.8.0")
    swig_add_library(${PY_MOD_NAME} TYPE MODULE LANGUAGE csharp SOURCES ${PY_MOD_SWIG_SRCS})
  else()
    swig_add_module(${PY_MOD_NAME} csharp ${PY_MOD_SWIG_SRCS})
  endif()
  swig_link_libraries(${PY_MOD_NAME} ${PY_MOD_LIBS} jsoncpp_lib ${TinyXML2_LIBRARIES} ${EIGEN3_LIBRARIES} ${PYTHON_LIBRARIES})

  set(PY_MOD_REAL_NAME1 SWIG_MODULE_${PY_MOD_NAME}_REAL_NAME)
  set(PY_MOD_REAL_NAME ${${PY_MOD_REAL_NAME1}})

  target_include_directories(${PY_MOD_REAL_NAME} PUBLIC 
      "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>"
      "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/swig>"
      "$<INSTALL_INTERFACE:include>")
  target_include_directories(${PY_MOD_REAL_NAME}  SYSTEM PUBLIC
    ${EIGEN3_INCLUDE_DIRS}
    ${Boost_INCLUDE_DIRS}
    ${TinyXML2_INCLUDE_DIRS}
    ${PYTHON_INCLUDE_DIRS}
    ${NUMPY_INCLUDE_DIR}
    )
  target_compile_definitions(${PY_MOD_REAL_NAME} PRIVATE -DSWIG_TYPE_TABLE=tesseract_python )
 
  # set_target_properties(${PY_MOD_REAL_NAME}
  #   PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/python/tesseract_robotics/${PY_MOD_PACKAGE})
  # set_target_properties(${PY_MOD_REAL_NAME}
  #   PROPERTIES LIBRARY_OUTPUT_DIRECTORY_RELEASE ${CMAKE_CURRENT_BINARY_DIR}/python/tesseract_robotics/${PY_MOD_PACKAGE})
  # set_target_properties(${PY_MOD_REAL_NAME}
  #   PROPERTIES LIBRARY_OUTPUT_DIRECTORY_RELWITHDEBINFO ${CMAKE_CURRENT_BINARY_DIR}/python/tesseract_robotics/${PY_MOD_PACKAGE})

  target_compile_options(${PY_MOD_REAL_NAME} PRIVATE ${TESSERACT_COMPILE_OPTIONS_PRIVATE})
  target_compile_options(${PY_MOD_REAL_NAME} PUBLIC ${TESSERACT_COMPILE_OPTIONS_PUBLIC})
  target_cxx_version(${PY_MOD_REAL_NAME} PUBLIC VERSION ${TESSERACT_CXX_VERSION})
  set_target_properties(${PY_MOD_REAL_NAME}
                                  PROPERTIES OUTPUT_NAME ${PY_MOD_NAME}_native)

endfunction()
