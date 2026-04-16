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


if [ -z "$TARGET" ]; then
  #export TARGET=RELEASE
  export TARGET=DEBUG
fi



if [ "$TOOLCHAIN" == "intel" ]; then
# INTEL
  echo 'Using toolchain INTEL'
  
  export FC=ifort
  #export CC=icx
  export CC=icc

  #AL4
  #module load IMAS/3.39.0-4.11.10-foss-2023b

  #AL5
  module load IMAS/3.39.0-intel-2023b
  
  #module load mpich2/3.1.3-intel
  module load XMLlib/3.3.2-intel-compilers-2023.2.1
else
# GFORTRAN
  echo 'Using toolchain FOSS'
  
  export FC=gfortran
  export CC=gcc

  #AL4
  #module load IMAS/3.39.0-4.11.10-foss-2023b

  #AL5
  module load IMAS/3.39.0-foss-2023b

  #module load mpich2/3.1.3-gnu
  module load XMLlib/3.3.2-GCC-13.2.0
fi


#module load FC2K/4.14.2-Java-11
#FC2K/4.14.2-Java-21

module load iWrap

module load Viz/2.8.0-foss-2023b

#module load TotalView


export DINA_ROOT=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )/../.." &> /dev/null && pwd)
export GIT_URL=$(git remote get-url origin)
export GIT_COMMIT_ID=$(git rev-parse --verify HEAD)
export GIT_VERSION=$(git describe --tags --abbrev=0)


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
