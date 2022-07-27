/**
 * @file tesseract_environment_csharp.i
 * @brief The tesseract_common_csharp SWIG master file.
 *
 * @author John Wason
 * @date July 26, 2022
 * @version TODO
 * @bug No known bugs
 *
 * @copyright Copyright (c) 2022, Wason Technology, LLC
 *
 * @par License
 * Software License Agreement (Apache License)
 * @par
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0
 * @par
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

 %module(directors="1") tesseract_environment_csharp

#pragma SWIG nowarn=473

%include "tesseract_swig_include.i"
%include "tesseract_std_function.i"

%import "tesseract_kinematics_csharp.i"
%import "tesseract_collision_csharp.i"
%import "tesseract_srdf_csharp.i"
%import "tesseract_state_solver_csharp.i"

tesseract_csimports( "using global::tesseract_common;\nusing global::tesseract_geometry;\nusing global::tesseract_scene_graph;\nusing global::tesseract_srdf;\nusing global::tesseract_state_solver;\nusing global::tesseract_collision;\nusing global::tesseract_kinematics;" );

%include <tesseract_environment_python.i>