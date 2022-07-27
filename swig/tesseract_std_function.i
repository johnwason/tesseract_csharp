/**
 * @file tesseract_std_function.i
 * @brief std_function typemap macros to provide write only callback functions
 *
 * @author John Wason
 * @date December 8, 2020
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

// Inspired by https://stackoverflow.com/questions/32644268/how-to-use-swig-to-wrap-stdfunction-objects

%define %_formacro_2n(macro, arg1, arg2,...)macro(arg1, arg2)
#if #__VA_ARGS__ != "__fordone__"
,%_formacro_2n(macro, __VA_ARGS__)
#endif
%enddef

%define %formacro_2n(macro,...)%_formacro_2n(macro,__VA_ARGS__,__fordone__)%enddef

%define _tesseract_std_function_call_args(arg_type, arg_name) arg_type arg_name  %enddef
%define _tesseract_std_function_call_vars(arg_type, arg_name) arg_name  %enddef

%define %tesseract_std_function(Name, Namespace, Ret, ...)

%shared_ptr(Name##Base)
%feature("director") Name##Base;

class Name##Base
{
public:
    virtual Ret call( %formacro_2n(_tesseract_std_function_call_args,__VA_ARGS__) ) = 0;
    virtual ~Name##Base() {}     
};

%typemap(in) Namespace::Name (std::shared_ptr< Name##Base > temp1, std::shared_ptr< Name##Base > *smartarg = 0) {
    // tesseract_std_function %typemap(in)
    smartarg = (SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< Name##Base > *)$input;
    if (smartarg == NULL || !smartarg)
    {
      SWIG_CSharpSetPendingExceptionArgument(SWIG_CSharpArgumentNullException, "function must not be null", 0);
      return $null;
    }
    temp1 = *smartarg;
    $1 = [temp1]( %formacro_2n(_tesseract_std_function_call_args,__VA_ARGS__) ) { return temp1->call(  %formacro_2n(_tesseract_std_function_call_vars,__VA_ARGS__)  ); };
  
}

%typemap(in) Namespace::Name const & (std::shared_ptr< Name##Base > temp1, std::shared_ptr< Name##Base > *smartarg = 0, Namespace::Name temp2) {
   // tesseract_std_function %typemap(in)
    smartarg = (SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< Name##Base > *)$input;
    if (smartarg == NULL || !smartarg)
    {
      SWIG_CSharpSetPendingExceptionArgument(SWIG_CSharpArgumentNullException, "function must not be null", 0);
      return $null;
    }
    temp1 = *smartarg;
    temp2 = [temp1]( %formacro_2n(_tesseract_std_function_call_args,__VA_ARGS__) ) { return temp1->call(  %formacro_2n(_tesseract_std_function_call_vars,__VA_ARGS__)  ); };
    $1 = &temp2;
  
}

%typemap(out) Namespace::Name const &  {
    return $null;
}

%typemap(typecheck, precedence=SWIG_TYPECHECK_POINTER, equivalent="TYPE *", noblock=1)
                      Namespace::Name, Namespace::Name const & {
}

namespace Namespace
{
//using Name = ::Name##Base;
}

// %pythoncode %{

// class Name(Name##Base):
//   def __init__(self,fn):
//     super(Name,self).__init__()
//     self._fn = fn

//   def call(self,*args):
//     return self._fn(*args)
// %}

%enddef

%define %tesseract_std_function_noargs(Name, Namespace, Ret)

%shared_ptr(Name##Base)
%feature("director") Name##Base;


class Name##Base
{
public:
    virtual Ret call() = 0;
    virtual ~Name##Base() {}     
};


%typemap(in, canthrow=1) Namespace::Name (std::shared_ptr< Name##Base > temp1, std::shared_ptr< Name##Base > *smartarg = 0) {
    // tesseract_std_function %typemap(in)
    smartarg = (SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< Name##Base > *)$input;
    if (smartarg == NULL || !smartarg)
    {
      SWIG_CSharpSetPendingExceptionArgument(SWIG_CSharpArgumentNullException, "function must not be null", 0);
      return $null;
    }
    temp1 = *smartarg;
    $1 = [temp1]() { return temp1->call( ); };   

}

%typemap(out) Namespace::Name*  {
    // tesseract_std_function* %typemap(out)
    return $null;
}

namespace Namespace
{
//using Name = ::Name##Base;
}

%enddef

%define %tesseract_std_function_base(Name, Namespace, Ret, ...)

%{
class Name##Base
{
public:
    virtual Ret call( %formacro_2n(_tesseract_std_function_call_args,__VA_ARGS__) ) = 0;        
    virtual ~Name##Base() {}
};
%}

%enddef

%define %tesseract_std_function_noargs_base(Name, Namespace, Ret)

%{
class Name##Base
{
public:
    virtual Ret call() = 0;
    virtual ~Name##Base() {}    
};
%}



%enddef