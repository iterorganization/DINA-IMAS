#!/bin/bash

# SET UP ENVIRONMENT FOR COMPILATION
. /usr/share/Modules/init/sh
# module use /work/imas/etc/attic
module use /work/imas/etc/modulefiles
module use /work/imas/etc/modules/all




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

#module load IMAS/3.30.0-4.8.6
module load IMAS

# Fixed memory leak in PyUAL
#module use -p /home/ITER/hoeneno/public/imas/etc/modulefiles 
#module load IMAS/3.30.0-4.8.6-1-g11197651

#module load IMAS/3.29.0-4.8.4
# module load IMAS/3.26.0-4.5.0

# KEPLER ENVIRONMENT VARIABLES

# module load kepler/2.5p2-2.1.3
# export KEPLER_DIR=~/Keplerdir
# #module load Keplerdir/my2.5p2-2.1.3
# # KEPLERMODULE=Keplerdir/my2.5p2-2.1.3
# # module load $KEPLERMODULE
# KEPLERMODULE=my2.5p2-2.1.3
# module load Keplerdir/$KEPLERMODULE

# Using Kepler
#KEPLERVERSON=Kepler/2.5p4-3.0.6
#module load $KEPLERVERSON

# module load Keplerdir/$KEPLERMODULE

#KEPLERMODULE=MY2.5p4-3.0.6
#if kepler_avail 2> /dev/null | grep -q $KEPLERMODULE; then
#   echo kepler_load $KEPLERMODULE
#   kepler_load $KEPLERMODULE
#else
#   echo "run bash ci_build.sh keplerinstall"
#   #return
#fi


module load FC2K


# export _JAVA_OPTIONS="-Xss20m -Xms1g -Xmx4g" #stack size
#module load MATLAB/2018a

imasdb test

module load TotalView

export _JAVA_OPTIONS="-Xss20m -Xms1g -Xmx4g" #stack size

#module load PyQt5

module load Viz 
#module load Viz/2.4.2-intel-2018a-Python-3.6.4

export PYTHONPATH=${VIZ_HOME}:${PYTHONPATH}

# # FOR PYUAL (PYTHON WORKFLOWS)
# export PYTHONPATH=/work/imas/core/pyual:$PYTHONPATH
# 
# # CHOOSE THE COMPILER 0=GFORTRAN (DEFAULT IF VARIABLE IS NOT SET), 1=INTEL
# if [ -z "$FCOMPILER" ]; then
#     echo 'FCOMPILER not set'
#     echo '=> Use gfortran as default'
#     export FCOMPILER=gfortran
# else
#    if [ "$FCOMPILER" == "ifort" ]; then
#       echo '$FCOMPILER set to intel'
#     else
#       echo '$FCOMPILER set to gfortran'
#     fi
# fi
# 
# # INTEL
# if [ "$FCOMPILER" == "ifort" ]; then
#   module load intel/12.0.2
#   module load mpich2/3.1.3-intel
#   module load xmllib/2.0.0-imas-3.7.4-intel-12.0.2
#   OBJ=obj_ifort
# else
# # GFORTRAN
#   module load mpich2/3.1.3-gnu
#   module load xmllib/2.0.0-imas-3.7.4-GCC-4.8.3
#   OBJ=obj_gfortran
# fi

module list


