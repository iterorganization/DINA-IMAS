#!/bin/bash
#
# BUILD XMLLIB AND IMAS-FORTRAN FOR THE GITHUB ACTIONS CI
# =======================================================
#
# Builds the IMAS dependencies of DINA that are not available from conda-forge
# in the required flavour, and installs them into a single prefix that the
# workflow caches:
#
#   - XMLlib       (autotools, provides xmllib.pc)
#   - IMAS-Fortran (CMake, provides al-fortran.pc), generated for the Data
#                  Dictionary version used by DINA. The conda-forge
#                  imas-fortran package is only built for DD 4.x.
#
# IMAS-Core (al-core.pc), the compilers and the build tools come from the
# conda environment described in .github/ci/environment.yml, which must be
# active.
#
# USAGE:
#   build_deps.sh <install-prefix>
#
# ENVIRONMENT VARIABLES (required):
#   XMLLIB_VERSION        - XMLlib git tag
#   IMAS_FORTRAN_VERSION  - IMAS-Fortran git tag
#   DD_VERSION            - IMAS Data Dictionary version (PyPI imas-data-dictionary)
#
set -euo pipefail

PREFIX=${1:?Usage: $0 <install-prefix>}
: "${XMLLIB_VERSION:?}" "${IMAS_FORTRAN_VERSION:?}" "${DD_VERSION:?}"
: "${CONDA_PREFIX:?A conda environment must be active}"

SRC_DIR=$(mktemp -d)
trap 'rm -rf "${SRC_DIR}"' EXIT
mkdir -p "${PREFIX}"

export PKG_CONFIG_PATH="${PREFIX}/lib/pkgconfig:${CONDA_PREFIX}/lib/pkgconfig${PKG_CONFIG_PATH:+:${PKG_CONFIG_PATH}}"

# The CI runners have 4 cores
JOBS=4

echo "::group::XMLlib ${XMLLIB_VERSION}"
git clone --depth 1 --branch "${XMLLIB_VERSION}" \
    https://github.com/iterorganization/XMLlib.git "${SRC_DIR}/XMLlib"
pushd "${SRC_DIR}/XMLlib"
./bootstrap
# configure.ac only adds the gfortran-specific flags when FC is exactly
# 'gfortran', not the conda-prefixed compiler name
./configure --prefix="${PREFIX}" FC=gfortran CC=gcc CXX=g++
make -j "${JOBS}"
make install
popd
echo "::endgroup::"

echo "::group::IMAS-Fortran ${IMAS_FORTRAN_VERSION} (DD ${DD_VERSION})"
git clone --depth 1 --branch "${IMAS_FORTRAN_VERSION}" \
    https://github.com/iterorganization/IMAS-Fortran.git "${SRC_DIR}/IMAS-Fortran"
# With AL_DOWNLOAD_DEPENDENCIES=OFF:
#  - IMAS-Core is found with pkg-config (al-core, from conda);
#  - the Data Dictionary is pip-installed (imas_data_dictionary==DD_VERSION)
#    together with saxonche into a venv in the build directory.
# Optimisation is disabled: CI only compiles and links against IMAS-Fortran,
# and at -O3 gfortran needs >15 minutes for some of the large generated
# sources (e.g. gyrokinetics_local_validate.f90).
cmake -G Ninja \
    -S "${SRC_DIR}/IMAS-Fortran" \
    -B "${SRC_DIR}/IMAS-Fortran/build" \
    -D CMAKE_BUILD_TYPE=Release \
    -D CMAKE_Fortran_FLAGS_RELEASE="-O0" \
    -D CMAKE_INSTALL_PREFIX="${PREFIX}" \
    -D CMAKE_Fortran_COMPILER=gfortran \
    -D CMAKE_C_COMPILER=gcc \
    -D CMAKE_CXX_COMPILER=g++ \
    -D Python_EXECUTABLE="$(command -v python)" \
    -D AL_DOWNLOAD_DEPENDENCIES=OFF \
    -D AL_DEVELOPMENT_LAYOUT=OFF \
    -D DD_VERSION="${DD_VERSION}" \
    -D AL_PLUGINS=OFF \
    -D AL_TESTS=OFF \
    -D AL_EXAMPLES=OFF \
    -D AL_HLI_DOCS=OFF
cmake --build "${SRC_DIR}/IMAS-Fortran/build" --parallel "${JOBS}"
cmake --install "${SRC_DIR}/IMAS-Fortran/build"
echo "::endgroup::"

echo "Installed pkg-config modules:"
pkg-config --modversion xmllib al-fortran
