/**
 * @file eigen.i
 * @brief Eigen typemaps for C#
 *
 * @author John Wason
 * @date July 24, 2022
 * @version TODO
 * @bug No known bugs
 *
 * @copyright Copyright (c) 2020, Wason Technology, LLC
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

 %{
   #include <Eigen/Dense>
 %}

%define %eigen_matrix(NAME, T)

namespace Eigen
{
    class NAME
    {
    public:
        NAME(size_t rows, size_t cols);
        size_t rows();
        size_t cols();
        %extend
        {
            T get(size_t n, size_t m)
            {
                return (*$self)(n,m);
            }

            void set(size_t n, size_t m, T val)
            {
                (*$self)(n,m) = val;
            }
        }

    };

    
}
%enddef

%eigen_matrix(MatrixXd,double);
%eigen_matrix(MatrixXi,int);

// ----------------------------------------------------------------------------
// Macro to create the typemap for Eigen classes
// ----------------------------------------------------------------------------

%define %eigen_cstypes(TYPE, EIGENMAT)
  %typemap(cstype) TYPE "EIGENMAT"
  %typemap(imtype, out="global::System.IntPtr") TYPE "global::System.Runtime.InteropServices.HandleRef"
  %typemap(csin) TYPE "EIGENMAT.getCPtr($csinput)"
  %typemap(csout, excode=SWIGEXCODE) TYPE {
    EIGENMAT ret = new EIGENMAT($imcall, true);$excode
    return ret;
  }
  %typemap(csvarout, excode=SWIGEXCODE2) TYPE %{
    get {
      EIGENMAT ret = new EIGENMAT($imcall, true);$excode
      return ret;
    } 
  %}
%enddef

%define %eigen_typemaps(CLASS, EIGENMAT)

%eigen_cstypes(%arg(CLASS), EIGENMAT);
%eigen_cstypes(%arg(CLASS &), EIGENMAT);
%eigen_cstypes(%arg(CLASS const&), EIGENMAT);
%eigen_cstypes(%arg(CLASS const), EIGENMAT);
%eigen_cstypes(%arg(Eigen::Ref<const CLASS > const&), EIGENMAT);
%eigen_cstypes(%arg(std::shared_ptr<const CLASS> const&), EIGENMAT);

// Argout: const & (Disabled and prevents calling of the non-const typemap)
%typemap(argout) const CLASS & ""

%typemap(in, numinputs=0) CLASS & (Eigen::EIGENMAT* argp ) {
  $1 = &temp;
}

// In: (nothing: no constness)
%typemap(in) CLASS (Eigen::EIGENMAT* argp)
{
  // Eigen in: CLASS
   argp = (Eigen::EIGENMAT*)$input; 
   if (!argp) {
     SWIG_CSharpSetPendingExceptionArgument(SWIG_CSharpArgumentNullException, "Attempt to dereference null $1_type", 0);
     return $null;
   }
   $1 = *argp;
}
// In: const&
%typemap(in) CLASS const& (Eigen::EIGENMAT* argp, CLASS temp)
{
  // Eigen in: const& CLASS
  argp = (Eigen::EIGENMAT*)$input;
  if (!$1) {
    SWIG_CSharpSetPendingExceptionArgument(SWIG_CSharpArgumentNullException, "$1_type type is null", 0);
    return $null;
  }
  temp = *argp;
  $1 = &temp;
}
// In: MatrixBase const&
%typemap(in, fragment="Eigen_Fragments") Eigen::MatrixBase< CLASS > const& (Eigen::EIGENMAT* argp)
{
  // Eigen in: MatrixBase const& CLASS
  argp = (Eigen::EIGENMAT*)$input;
  if (!$1) {
    SWIG_CSharpSetPendingExceptionArgument(SWIG_CSharpArgumentNullException, "$1_type type is null", 0);
    return $null;
  }
  $1 = *argp;
}
// DISABLED FOR argout In: & (not yet implemented) 
/*%typemap(in, fragment="Eigen_Fragments") CLASS & (CLASS temp)
{
  // In: non-const&
  if (!ConvertFromNumpyToEigenMatrix<CLASS >(&temp, $input))
    SWIG_fail;
  $1 = &temp;
}*/

// In: const* (not yet implemented)
%typemap(in) CLASS const*
{
  SWIG_CSharpSetPendingException(SWIG_CSharpInvalidOperationException, "The input typemap for const pointer is not yet implemented. Please report this problem to the developer.");
  return $null;
}
// In: * (not yet implemented)
%typemap(in) CLASS *
{
  SWIG_CSharpSetPendingException(SWIG_CSharpInvalidOperationException, "The input typemap for non-const pointer is not yet implemented. Please report this problem to the developer.");
  return $null;
}

// Out: (nothing: no constness)
%typemap(out) CLASS
{
    // Eigen out: CLASS
  $result = new Eigen::EIGENMAT($1);
}
// Out: const
%typemap(out) CLASS const
{
    // Eigen out: CLASS const
  $result = new Eigen::EIGENMAT($1);
}
// Out: const&
%typemap(out) CLASS const&
{
    // Eigen out: CLASS const&
  $result = new Eigen::EIGENMAT(*$1);
}
// Out: & (not yet implemented)
%typemap(out) CLASS &
{
  SWIG_CSharpSetPendingException(SWIG_CSharpInvalidOperationException, "The output typemap for non-const reference is not yet implemented. Please report this problem to the developer.");
  return $null;
}
// Out: const* (not yet implemented)
%typemap(out) CLASS const*
{
  SWIG_CSharpSetPendingException(SWIG_CSharpInvalidOperationException, "The output typemap for const pointer is not yet implemented. Please report this problem to the developer.");
  return $null;
}
// Out: * (not yet implemented)
%typemap(out) CLASS *
{
  SWIG_CSharpSetPendingException(SWIG_CSharpInvalidOperationException, "The output typemap for non-const pointer is not yet implemented. Please report this problem to the developer.");
  return $null;
}

%typemap(in) const Eigen::Ref<const CLASS >& (Eigen::EIGENMAT* argp, CLASS temp)
{
  argp = (Eigen::EIGENMAT*)$input;
  if (!argp) {
    SWIG_CSharpSetPendingExceptionArgument(SWIG_CSharpArgumentNullException, "$1_type type is null", 0);
    return $null;
  }
  temp = *argp;
  $1 = new Eigen::Ref<const CLASS>(temp);
}

%typemap(freearg) const Eigen::Ref<const CLASS >&
{
  if($1) delete $1;
}

// Argout: & (for returning values to in-out arguments)
// %typemap(argout, fragment="Eigen_Fragments") Eigen::Ref<CLASS >
// {
//   // Argout: Ref
//   PyObject* ret1 = $result;
//   PyObject* ret2;
//   if (!ConvertFromEigenToNumPyMatrix<CLASS >(&ret2, &temp$argnum))
//     SWIG_fail;
//   $result = PyTuple_Pack(2, ret1, ret2);
//   Py_DECREF(ret1);
//   Py_DECREF(ret2);
// }

%typemap(in, numinputs=0) Eigen::Ref<CLASS > (CLASS temp) {
  $1 = temp;
}

// Out: const&
%typemap(out) std::shared_ptr<const CLASS> const&
{
    // Eigen out:  std::shared_ptr<const CLASS> const&
  $result = new Eigen::EIGENMAT(*($1->get()));
}

%typemap(in) std::shared_ptr<const CLASS > (Eigen::EIGENMAT* argp)
{
  // Eigen in: std::shared_ptr<const CLASS >
  argp = (Eigen::EIGENMAT*)$input;
  if (!argp) {
    SWIG_CSharpSetPendingExceptionArgument(SWIG_CSharpArgumentNullException, "$1_type type is null", 0);
    return $null;
  }
  $1 = std::make_shared<CLASS>(*argp);
}


%enddef

