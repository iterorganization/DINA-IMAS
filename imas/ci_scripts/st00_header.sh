#!/bin/bash
#
# MODULE LOADER SCRIPT FOR CI/CD
# ===============================
#
# This script loads environment modules based on the selected toolchain.
# Module versions can be configured via environment variables for easy CI integration.
#
# USAGE:
#   ./st00_header.sh
#
# ENVIRONMENT VARIABLES:
#   TARGET           - Target to use DEBUG or RELEASE
#   TOOLCHAIN        - Toolchain to use (default: foss)
#   FOSS_MODULES     - FOSS-specific modules (comma-separated)  
#   INTEL_MODULES    - Intel-specific modules (comma-separated)
#
set -e -o pipefail

echo "Loading modules..."

if test -f /etc/profile.d/modules.sh; then
    . /etc/profile.d/modules.sh
else
    . /usr/share/Modules/init/sh
fi
module purge

TOOLCHAIN=${TOOLCHAIN:-foss}

DEFAULT_FOSS_MODULES="iWrap/2.0.0-foss-2023b,XMLlib/3.3.2-GCC-13.2.0,IMAS-Fortran/5.6.0-foss-2023b-DD-3.42.2"
DEFAULT_INTEL_MODULES="iWrap/2.0.0-intel-2023b,IMAS-Fortran/5.6.0-intel-2023b-DD-3.42.2,XMLlib/3.3.2-intel-compilers-2023.2.1"

FOSS_MODULES_LIST="${FOSS_MODULES:-$DEFAULT_FOSS_MODULES}"
INTEL_MODULES_LIST="${INTEL_MODULES:-$DEFAULT_INTEL_MODULES}"

IFS=',' read -ra FOSS_MODULES <<< "$FOSS_MODULES_LIST"
IFS=',' read -ra INTEL_MODULES <<< "$INTEL_MODULES_LIST"

case "$TOOLCHAIN" in
    *foss*)
        echo "... foss toolchain"
        MODULES+=("${FOSS_MODULES[@]}")
        ;;
    *intel*)
        echo "... intel toolchain"
        MODULES+=("${INTEL_MODULES[@]}")
        ;;
    *)
        echo "... default toolchain"
        MODULES+=("${FOSS_MODULES[@]}")
        ;;
esac

echo "Modules to load:"
echo "${MODULES[@]}" | tr " " "\n"

module load "${MODULES[@]}"
echo "Done loading modules"

if [[ -z "${FC:-}" ]]; then
    if command -v ifort >/dev/null 2>&1; then
        export FC=ifort
	export CC=icc
    elif command -v ifx >/dev/null 2>&1; then
        export FC=ifx
	export CC=icx
    elif command -v gfortran >/dev/null 2>&1; then
        export FC=gfortran
	export CC=gcc
    else
        echo "ERROR: Could not find a supported Fortran compiler (ifort/ifx/gfortran). Please set FC explicitly." >&2
        return 1
    fi
fi


export TARGET="${TARGET:-DEBUG}"
export PYTHONPATH=${HOME}/IWRAP_ACTORS:${PYTHONPATH}
export PYTHONPATH=${DINA_ROOT}/tools/pyutil:${PYTHONPATH}

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



echo "TOOLCHAIN: $TOOLCHAIN"
echo "FC: $FC"
echo "TARGET: $TARGET"
echo "DINA_ROOT: $DINA_ROOT"
echo "GIT_URL: $GIT_URL"
echo "GIT_COMMIT_ID: $GIT_COMMIT_ID"
echo "GIT_VERSION: $GIT_VERSION"

