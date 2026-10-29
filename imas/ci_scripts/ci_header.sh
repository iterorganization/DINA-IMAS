#!/bin/bash

# SET UP ENVIRONMENT FOR COMPILATION
shopt -s expand_aliases

# # THE HOME AND USER ENVIRONMENT VARIABLES DO NOT EXIST IN BAMBOO!!! (NEEDED BY KEPLER)
# if [ -z "$HOME" ]; then
#   export HOME=/root/
# fi
# 
# if [ -z "$USER" ]; then
#   export USER=root
# fi

module purge 2> /dev/null


if [ -z "$TOOLCHAIN" ]; then
  export TOOLCHAIN=foss
  #export TOOLCHAIN=intel
fi

if [ -z "$BUILD" ]; then
  export BUILD=2023b
  #export BUILD=2025b
fi

if [ -z "$TARGET" ]; then
  #export TARGET=RELEASE
  export TARGET=DEBUG
fi



if [ "$TOOLCHAIN" == "intel" ]; then
  echo 'Using toolchain INTEL'
  
  #AL5
  #module load IMAS/3.39.0-intel-2023b
  #module load IMAS/3.42.0-intel-2023b
  

  if [ "$BUILD" == "2023b" ]; then
    echo 'Using build 2023b'
    export FC=ifort
    export CC=icc
    #module load IMAS-AL-Fortran/5.4.0-intel-2023b-DD-3.42.0

    #module load IMAS-AL-Python/5.4.0-intel-2023b-DD-3.42.0
    
    #module load IMAS-Core/5.7.1-intel-2023b
    
    module load IMAS-Data-Dictionary/3.42.2-GCCcore-13.2.0
    module load IMAS-Python/2.3.0-intel-2023b
    module load PySide6/6.6.2-GCCcore-13.2.0
    module load matplotlib/3.8.2-iimkl-2023b
    
    module load IMAS-Fortran/5.6.0-intel-2023b-DD-3.42.2
    module load XMLlib/3.3.2-intel-compilers-2023.2.1
    module load iWrap/2.0.0-intel-2023b
  fi
  
  if [ "$BUILD" == "2025b" ]; then
    echo 'Using build 2025b'
    export FC=ifx
    export CC=icx
    
    #module load IMAS-Core/5.7.1-intel-2025b
  
    module load IMAS-Fortran/5.6.0-intel-2025b-DD-3.42.2
    module load XMLlib/3.3.2-intel-compilers-2025.2.0
    module load iWrap/2.0.0-intel-2025b
  
    module load IMAS-Data-Dictionary/3.42.2-GCCcore-14.3.0
    module load IMAS-Python/2.3.0-intel-2025b
    module load PySide6/6.9.3-GCCcore-14.3.0
    module load matplotlib/3.10.5-iimkl-2025b
  fi
fi

if [ "$TOOLCHAIN" == "foss" ]; then
  echo 'Using toolchain FOSS (gfortran)'
  
  export FC=gfortran
  export CC=gcc

  #AL5
  #module load IMAS/3.39.0-foss-2023b
  #module load IMAS/3.42.0-foss-2023b
  
  if [ "$BUILD" == "2023b" ]; then
    echo 'Using build 2023b'
    #module load IMAS-AL-Fortran/5.4.0-foss-2023b-DD-3.42.0

    #module load IMAS-AL-Python/5.4.0-foss-2023b-DD-3.42.0
    
    #module load IMAS-Core/5.7.1-foss-2023b
    
    module load IMAS-Data-Dictionary/3.42.2-GCCcore-13.2.0
    module load IMAS-Python/2.3.0-foss-2023b
    module load PySide6/6.6.2-GCCcore-13.2.0
    module load matplotlib/3.8.2-gfbf-2023b
    
    module load IMAS-Fortran/5.6.0-foss-2023b-DD-3.42.2
    module load XMLlib/3.3.2-GCC-13.2.0
    module load iWrap/2.0.0-foss-2023b
  fi
  
  if [ "$BUILD" == "2025b" ]; then
    echo 'Using build 2025b'
    
    #module load IMAS-Core/5.7.1-foss-2025b

    module load IMAS-Fortran/5.6.0-foss-2025b-DD-3.42.2
    module load XMLlib/3.3.2-GCC-14.3.0  
    module load iWrap/2.0.0-foss-2025b
  
    module load IMAS-Data-Dictionary/3.42.2-GCCcore-14.3.0
    module load IMAS-Python/2.3.0-foss-2025b
    module load PySide6/6.9.3-GCCcore-14.3.0
    module load matplotlib/3.10.5-gfbf-2025b
  fi
fi

#module load Viz/2.8.0-foss-2023b

#module load TotalView


export DINA_ROOT=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )/../.." &> /dev/null && pwd)
export GIT_URL=$(git remote get-url origin)
export GIT_COMMIT_ID=$(git rev-parse --verify HEAD)
export GIT_VERSION=$(git describe --tags --abbrev=0)


# Common compiler flags
F90FLAGS="-fPIC -w"
FCFLAGS="-fPIC -w"
CFLAGS=" -fPIC -w"

# Compiler-specific flags
case "$FC" in
    ifort|ifx)
        FCFLAGS+=" -extend-source -nod-lines -save -init=zero -real-size 64"
        F90FLAGS+=" -fpp"
        F90FLAGS+=" -real-size 64 -assume no2underscores -extend_source -mcmodel=medium -Wl,--no-relax"
        ;;

    gfortran)
        FCFLAGS+=" -ffixed-line-length-none -fd-lines-as-comments -fno-automatic -freal-4-real-8"
        F90FLAGS+=" -cpp"
        F90FLAGS+=" -freal-4-real-8 -fno-second-underscore -ffree-line-length-none -mcmodel=medium -Wl,--no-relax"
        ;;

    *)
        echo "Error: Unsupported Fortran compiler: $FC" >&2
        exit 1
        ;;
esac

F90FLAGS+=" -D'GIT_URL=\"${GIT_URL}\"'"
F90FLAGS+=" -D'GIT_COMMIT_ID=\"${GIT_COMMIT_ID}\"'"
F90FLAGS+=" -D'GIT_VERSION=\"${GIT_VERSION}\"'"



# Disable advertisement of icx
if [[ "$CC" == "icc" ]]; then
  CFLAGS+=" -diag-disable=10441"
fi


# Debug flags
DEBUG="-g -O0"

if [[ "$TARGET" == "DEBUG" ]]; then
    FCFLAGS+=" $DEBUG"
    F90FLAGS+=" $DEBUG"
    CFLAGS+=" $DEBUG"
fi




export FCFLAGS
export F90FLAGS
export CFLAGS



export PYTHONPATH=${HOME}/IWRAP_ACTORS:${PYTHONPATH}
export PYTHONPATH=${DINA_ROOT}/tools/pyutil:${PYTHONPATH}



module list
#-t

echo TOOLCHAIN=$TOOLCHAIN
echo TARGET=$TARGET
echo DINA_ROOT=$DINA_ROOT
echo GIT_URL=$GIT_URL
echo GIT_COMMIT_ID=$GIT_COMMIT_ID
echo GIT_VERSION=$GIT_VERSION
