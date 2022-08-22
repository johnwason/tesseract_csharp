# Tesseract C#

**WARNING: Incomplete work in progress!**

This repository contains early development work on Tesseract bindings for C\# using SWIG. It uses the SWIG .i files from  the `tesseract_python` package, and slightly modifies the behavior so they can be used for C\#

This code is completely untested, and may not work at all!

Building requires setting up the environment to build Tesseract Python, and installing the dotnet SDK for Ubuntu.

To build the C\# native and managed libraries:

```
mkdir src
cd src
git clone --branch swig_reuse https://github.com/johnwason/tesseract_python-1.git
git clone https://github.com/johnwason/tesseract_csharp.git
vcs import --input tesseract_python-1/dependencies.rosinstall
cd ..
colcon build --packages-up-to tesseract_process_managers  --cmake-args -DCMAKE_BUILD_TYPE=Debug -DTESSERACT_ENABLE_EXAMPLES=OFF
colcon build --packages-select tesseract_csharp --cmake-force-configure  --cmake-args -DCMAKE_BUILD_TYPE=Debug -DTESSERACT_ENABLE_EXAMPLES=OFF -DTESSERACT_PYTHON_SWIG_DIR=`pwd`/src/tesseract_python-1/tesseract_python/swig
dotnet build build/tesseract_csharp/tesseract_csharp.csproj
```

The build also works on Windows.