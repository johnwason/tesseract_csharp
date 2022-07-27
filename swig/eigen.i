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

namespace Eigen
{
    class MatrixXd
    {
    public:
        MatrixXd(size_t rows, size_t cols);
        size_t rows();
        size_t cols();
        %extend
        {
            double get(size_t n, size_t m)
            {
                return (*$self)(n,m);
            }

            double set(size_t n, size_t m, double val)
            {
                return (*$self)(n,m) = val;
            }
        }

    };
}

// ----------------------------------------------------------------------------
// Macro to create the typemap for Eigen classes
// ----------------------------------------------------------------------------

%define %eigen_typemaps(CLASS, EIGENMAT)
 //%naturalvar CLASS;
 //%typemap(ctype) CLASS "Eigen::MatrixXd";
  %typemap(cstype) CLASS "MatrixXd"
  %typemap(imtype, out="global::System.IntPtr") CLASS "global::System.Runtime.InteropServices.HandleRef"
 %typemap(csin) CLASS "MatrixXd.getCPtr($csinput)"
 %typemap(csout, excode=SWIGEXCODE) CLASS {
    MatrixXd ret = new MatrixXd($imcall, true);$excode
    return ret;
  }
%typemap(csvarout, excode=SWIGEXCODE2) CLASS %{
    get {
      MatrixXd ret = new MatrixXd($imcall, true);$excode
      return ret;
    } 
  %}

  %typemap(cstype) CLASS & "MatrixXd"
  %typemap(imtype, out="global::System.IntPtr") CLASS & "global::System.Runtime.InteropServices.HandleRef"
 %typemap(csin) CLASS & "MatrixXd.getCPtr($csinput)"
 %typemap(csout, excode=SWIGEXCODE) CLASS & {
    MatrixXd ret = new MatrixXd($imcall, true);$excode
    return ret;
  }
  %typemap(csvarout, excode=SWIGEXCODE2) CLASS & %{
    get {
      MatrixXd ret = new MatrixXd($imcall, $owner);$excode
      return ret;
    } 
  %}

  %typemap(cstype) CLASS const& "MatrixXd"
  %typemap(imtype, out="global::System.IntPtr") CLASS const& "global::System.Runtime.InteropServices.HandleRef"
 %typemap(csout, excode=SWIGEXCODE) CLASS const& {
    MatrixXd ret = new MatrixXd($imcall, true);$excode
    return ret;
  }
 %typemap(csin) CLASS const&  "MatrixXd.getCPtr($csinput)"
  %typemap(cstype) CLASS const "MatrixXd" 
  %typemap(imtype, out="global::System.IntPtr") CLASS const "global::System.Runtime.InteropServices.HandleRef"
 %typemap(csin) CLASS const "MatrixXd.getCPtr($csinput)"
 %typemap(csout, excode=SWIGEXCODE) CLASS const {
    MatrixXd ret = new MatrixXd($imcall, true);$excode
    return ret;
  }

 
 
 %typemap(cstype)  Eigen::Ref<const CLASS > const&  "MatrixXd"
 %typemap(imtype, out="global::System.IntPtr") Eigen::Ref<const CLASS > const& "global::System.Runtime.InteropServices.HandleRef"
 %typemap(csin)  Eigen::Ref<const CLASS > const& "MatrixXd.getCPtr($csinput)"
//  %typemap(csout, excode=SWIGEXCODE) const Eigen::Ref<const CLASS >& const {
//     MatrixXd ret = new MatrixXd($imcall, true);$excode
//     return ret;
//   }

  

// Argout: const & (Disabled and prevents calling of the non-const typemap)
%typemap(argout) const CLASS & ""

%typemap(in, numinputs=0) CLASS & (Eigen::MatrixXd* argp ) {
  $1 = &temp;
}

// In: (nothing: no constness)
%typemap(in) CLASS (Eigen::MatrixXd* argp)
{
  // Eigen in: CLASS
   argp = (Eigen::MatrixXd*)$input; 
   if (!argp) {
     SWIG_CSharpSetPendingExceptionArgument(SWIG_CSharpArgumentNullException, "Attempt to dereference null $1_type", 0);
     return $null;
   }
   $1 = *argp;
}
// In: const&
%typemap(in) CLASS const& (Eigen::MatrixXd* argp, CLASS temp)
{
  // Eigen in: const& CLASS
  argp = (Eigen::MatrixXd*)$input;
  if (!$1) {
    SWIG_CSharpSetPendingExceptionArgument(SWIG_CSharpArgumentNullException, "$1_type type is null", 0);
    return $null;
  }
  temp = *argp;
  $1 = &temp;
}
// In: MatrixBase const&
%typemap(in, fragment="Eigen_Fragments") Eigen::MatrixBase< CLASS > const& (Eigen::MatrixXd* argp)
{
  // Eigen in: MatrixBase const& CLASS
  argp = (Eigen::MatrixXd*)$input;
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
    // Eigen in: CLASS
  $result = new Eigen::MatrixXd($1);
}
// Out: const
%typemap(out) CLASS const
{
    // Eigen in: CLASS const
  $result = new Eigen::MatrixXd($1);
}
// Out: const&
%typemap(out, fragment="Eigen_Fragments") CLASS const&
{
    // Eigen in: CLASS const&
  $result = new Eigen::MatrixXd(*$1);
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

%typemap(in) const Eigen::Ref<const CLASS >& (Eigen::MatrixXd* argp, CLASS temp)
{
  argp = (Eigen::MatrixXd*)$input;
  if (!$1) {
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

%enddef

