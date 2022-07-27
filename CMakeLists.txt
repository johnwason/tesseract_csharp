cmake_minimum_required(VERSION 3.5.0)

# Extract package name and version
find_package(ros_industrial_cmake_boilerplate REQUIRED)
extract_package_metadata(pkg)
project(${pkg_extracted_name} VERSION ${pkg_extracted_version})

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/")

# Read version
FILE (STRINGS "${CMAKE_CURRENT_SOURCE_DIR}/package.xml" tesseract_csharp_version1 REGEX "<version>[0-9]+\\.[0-9]+\\.[0-9]+</version>")
IF ("${tesseract_csharp_version1}" STREQUAL "" )
MESSAGE(FATAL_ERROR "Could not read tesseract_csharp version.")
ENDIF()
STRING (REGEX REPLACE "<version>([0-9]+\\.[0-9]+\\.[0-9]+)</version>" "\\1" tesseract_csharp_version2 ${tesseract_csharp_version1})
STRING (STRIP ${tesseract_csharp_version2} tesseract_csharp_version)
MESSAGE(STATUS "tesseract_csharp version: ${tesseract_csharp_version}")


if (NOT MSVC)
  add_compile_options(-w)
else()
  add_compile_options(/bigobj)
endif()

# find_package(tesseract_motion_planners REQUIRED)
# find_package(tesseract_common REQUIRED)
# find_package(tesseract_geometry REQUIRED)
# find_package(tesseract_visualization REQUIRED)
# find_package(tesseract_collision REQUIRED)
# find_package(tesseract_urdf REQUIRED)
# find_package(tesseract_srdf REQUIRED)
# find_package(tesseract_kinematics REQUIRED)
# find_package(tesseract_environment REQUIRED)
# find_package(tesseract_scene_graph REQUIRED)
# find_package(tesseract_command_language REQUIRED)
# find_package(tesseract_time_parameterization REQUIRED)
# find_package(PCL REQUIRED COMPONENTS core features filters io segmentation surface)
# find_package(trajopt REQUIRED)
# find_package(TinyXML2 REQUIRED)
# find_package(opw_kinematics REQUIRED)

find_package(tesseract_process_managers REQUIRED)

if(NOT TinyXML2_INCLUDE_DIRS AND TARGET tinyxml2::tinyxml2)
get_target_property(TinyXML2_INCLUDE_DIRS tinyxml2::tinyxml2 INTERFACE_INCLUDE_DIRECTORIES)
message(STATUS "Found from target interface: TinyXML2_INCLUDE_DIRS=${TinyXML2_INCLUDE_DIRS}")
endif()

tesseract_variables()

set(TESSERACT_PYTHON_SWIG_DIR "${CMAKE_CURRENT_SOURCE_DIR}/ext/tesseract_python/tesseract_python/swig" CACHE PATH "Tesseract Python directory")
include_directories(${TESSERACT_PYTHON_SWIG_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/swig/swig_lib)

include_directories(
  ${trajopt_INCLUDE_DIRS} 
  ${tesseract_common_INCLUDE_DIRS}
  ${tesseract_geometry_INCLUDE_DIRS}
  ${tesseract_collision_INCLUDE_DIRS}
  ${tesseract_motion_planners_INCLUDE_DIRS}
  ${tesseract_kinematics_INCLUDE_DIRS}
  ${tesseract_urdf_INCLUDE_DIRS}
  ${tesseract_scene_graph_INCLUDE_DIRS}
  ${tesseract_srdf_INCLUDE_DIRS}
  ${tesseract_environment_INCLUDE_DIRS}
  ${tesseract_command_language_INCLUDE_DIRS}
  ${tesseract_time_parameterization_INCLUDE_DIRS}
  ${tesseract_visualization_INCLUDE_DIRS}
  ${tesseract_process_managers_INCLUDE_DIRS}
  ${opw_kinematics_INCLUDE_DIRS}
  ${TinyXML2_INCLUDE_DIRS}
)

# End Find NumPy

if(${CMAKE_VERSION} VERSION_GREATER "3.13.0" OR ${CMAKE_VERSION} VERSION_EQUAL "3.13.0")
cmake_policy(SET CMP0078 OLD)
endif()

if(${CMAKE_VERSION} VERSION_GREATER "3.14.0" OR ${CMAKE_VERSION} VERSION_EQUAL "3.14.0")
cmake_policy(SET CMP0086 OLD)
endif()

include(FindSWIG)
find_package(SWIG 4.0 REQUIRED)
include(UseSWIG)

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/tesseract_csharp_module.cmake)

tesseract_csharp_module(tesseract_common_csharp SWIG_SRCS swig/tesseract_common_csharp.i NAMESPACE tesseract_common LIBS tesseract::tesseract_common )
tesseract_csharp_module(tesseract_geometry_csharp SWIG_SRCS swig/tesseract_geometry_csharp.i NAMESPACE tesseract_geometry LIBS tesseract::tesseract_geometry )
tesseract_csharp_module(tesseract_collision_csharp SWIG_SRCS swig/tesseract_collision_csharp.i NAMESPACE tesseract_collision LIBS tesseract::tesseract_collision_core tesseract::tesseract_collision_bullet_factories tesseract::tesseract_collision_fcl_factories )
tesseract_csharp_module(tesseract_scene_graph_csharp SWIG_SRCS swig/tesseract_scene_graph_csharp.i NAMESPACE tesseract_scene_graph LIBS tesseract::tesseract_scene_graph )
tesseract_csharp_module(tesseract_srdf_csharp SWIG_SRCS swig/tesseract_srdf_csharp.i NAMESPACE tesseract_srdf LIBS tesseract::tesseract_srdf )
tesseract_csharp_module(tesseract_urdf_csharp SWIG_SRCS swig/tesseract_urdf_csharp.i NAMESPACE tesseract_urdf LIBS tesseract::tesseract_urdf )
tesseract_csharp_module(tesseract_state_solver_csharp SWIG_SRCS swig/tesseract_state_solver_csharp.i NAMESPACE tesseract_state_solver LIBS tesseract::tesseract_state_solver_core tesseract::tesseract_state_solver_ofkt tesseract::tesseract_state_solver_kdl)
tesseract_csharp_module(tesseract_kinematics_csharp SWIG_SRCS swig/tesseract_kinematics_csharp.i NAMESPACE tesseract_kinematics LIBS tesseract::tesseract_kinematics_kdl_factories tesseract::tesseract_kinematics_ur_factory tesseract::tesseract_kinematics_opw_factory tesseract::tesseract_kinematics_core_factories tesseract::tesseract_kinematics_core )
tesseract_csharp_module(tesseract_environment_csharp SWIG_SRCS swig/tesseract_environment_csharp.i NAMESPACE tesseract_environment LIBS tesseract::tesseract_environment )
tesseract_csharp_module(tesseract_visualization_csharp SWIG_SRCS swig/tesseract_visualization_csharp.i NAMESPACE tesseract_visualization LIBS tesseract::tesseract_visualization)
tesseract_csharp_module(tesseract_command_language_csharp SWIG_SRCS swig/tesseract_command_language_csharp.i NAMESPACE tesseract_command_language LIBS tesseract::tesseract_command_language)
# tesseract_csharp_module(tesseract_motion_planners_python SWIG_SRCS swig/tesseract_motion_planners_python.i NAMESPACE tesseract_planning LIBS tesseract::tesseract_motion_planners_simple tesseract::tesseract_motion_planners_core )
# tesseract_csharp_module(tesseract_motion_planners_simple_python SWIG_SRCS swig/tesseract_motion_planners_simple_python.i NAMESPACE tesseract_planning_simple LIBS tesseract::tesseract_motion_planners_simple )
# tesseract_csharp_module(tesseract_motion_planners_trajopt_python SWIG_SRCS swig/tesseract_motion_planners_trajopt_python.i NAMESPACE tesseract_planning_trajopt LIBS tesseract::tesseract_motion_planners_trajopt )
# tesseract_csharp_module(tesseract_motion_planners_ompl_python SWIG_SRCS swig/tesseract_motion_planners_ompl_python.i NAMESPACE tesseract_planning_ompl LIBS tesseract::tesseract_motion_planners_ompl )
# tesseract_csharp_module(tesseract_motion_planners_descartes_python SWIG_SRCS swig/tesseract_motion_planners_descartes_python.i NAMESPACE tesseract_planning_descartes LIBS tesseract::tesseract_motion_planners_descartes )
tesseract_csharp_module(tesseract_time_parameterization_csharp SWIG_SRCS swig/tesseract_time_parameterization_csharp.i NAMESPACE tesseract_time_parameterization LIBS tesseract::tesseract_time_parameterization )
# tesseract_csharp_module(tesseract_process_managers_python SWIG_SRCS swig/tesseract_process_managers_python.i NAMESPACE tesseract_process_managers LIBS tesseract::tesseract_process_managers )


  # Allows Colcon to find non-Ament packages when using workspace underlays
  file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/share/ament_index/resource_index/packages/${PROJECT_NAME} "")
  install(FILES ${CMAKE_CURRENT_BINARY_DIR}/share/ament_index/resource_index/packages/${PROJECT_NAME} DESTINATION share/ament_index/resource_index/packages)
  file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/share/${PROJECT_NAME}/hook/ament_prefix_path.dsv "prepend-non-duplicate;AMENT_PREFIX_PATH;")
  install(FILES ${CMAKE_CURRENT_BINARY_DIR}/share/${PROJECT_NAME}/hook/ament_prefix_path.dsv DESTINATION share/${PROJECT_NAME}/hook)

  
# if(TESSERACT_ENABLE_TESTING)
#   enable_testing()

#   add_run_tests_target(ENABLE ${TESSERACT_ENABLE_RUN_TESTING})

#   if (${TESSERACT_ENABLE_RUN_TESTING})
#   add_dependencies(run_tests _tesseract_common_python _tesseract_geometry_python _tesseract_collision_python 
#     _tesseract_collision_bullet_python _tesseract_collision_fcl_python _tesseract_scene_graph_python
#     _tesseract_urdf_python _tesseract_kinematics_python _tesseract_kinematics_kdl_python
#     _tesseract_kinematics_opw_python _tesseract_environment_python _tesseract_command_language_python
#     _tesseract_motion_planners_python _tesseract_motion_planners_simple_python
#     _tesseract_motion_planners_trajopt_python _tesseract_motion_planners_ompl_python
#     _tesseract_motion_planners_descartes_python _tesseract_time_parameterization_python
#     _tesseract_visualization_python _tesseract_srdf_python)
#     endif()

#   add_test (NAME python-tests
#   COMMAND ${PYTHON_EXECUTABLE} -m pytest -p no:cacheprovider
#   WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
#   )
  
#   find_package(tesseract_support REQUIRED)
#   if (WIN32)
#   set_tests_properties(python-tests PROPERTIES ENVIRONMENT "TESSERACT_SUPPORT_DIR=${TESSERACT_SUPPORT_DIR}")
#   else()
#   set_tests_properties(python-tests PROPERTIES ENVIRONMENT "TESSERACT_SUPPORT_DIR=${TESSERACT_SUPPORT_DIR}")
#   endif()
# endif()
  
configure_file(cmake/tesseract_csharp.csproj ${CMAKE_CURRENT_BINARY_DIR}/tesseract_csharp.csproj)