/**
 * @file eigen_types.i
 * @brief Eigen typemaps used by Tesseract
 *
 * @author John Wason
 * @date December 10, 2019
 * @version TODO
 * @bug No known bugs
 *
 * @copyright Copyright (c) 2019, Wason Technology, LLC
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

// namespace Eigen
// {
//   template <typename T> class Ref;
//   class MatrixXd;
// }

// %feature("valuewrapper") Eigen::Ref<Eigen::MatrixXd>;
// %template() Eigen::Ref<Eigen::MatrixXd>;

%define %eigen_d_typemaps(CLASS)
%eigen_typemaps(%arg(CLASS), MatrixXd)
%enddef

%define %eigen_i_typemaps(CLASS)
%eigen_typemaps(%arg(CLASS), MatrixXi)
%enddef

%eigen_d_typemaps(Eigen::Vector2d);
%eigen_d_typemaps(Eigen::Vector3d);
%eigen_d_typemaps(Eigen::Vector4d);
%eigen_d_typemaps(Eigen::VectorXd);
%eigen_d_typemaps(Eigen::MatrixXd);
%eigen_d_typemaps(%arg(Eigen::Matrix3Xd));
//%eigen_u_typemaps(%arg(Eigen::Matrix<uint32_t,3,Eigen::Dynamic>));
%eigen_d_typemaps(%arg(Eigen::Matrix<double, Eigen::Dynamic, Eigen::Dynamic, Eigen::RowMajor>));
%eigen_i_typemaps(Eigen::VectorXi);
%eigen_d_typemaps(Eigen::Matrix3d);
%eigen_d_typemaps(Eigen::Matrix4d);
