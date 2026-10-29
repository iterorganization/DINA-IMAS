/*
 * Copyright 1990-2013 The MathWorks, Inc.
 *
 * File: simstruc.h
 *
 * Abstract:
 *      Data structures and access methods for S-functions.
 *
 *      A Simulink model is an S-function.  The SimStruct contains all entry
 *      points within the S-function (e.g. mdlOutputs) as well any data
 *      associated with the S-function.
 *
 *      This file contains details of SimStruct (Simulink data structure)
 *      which is used to store attributes of the model such as pointers to
 *      storage vectors.
 *
 *      Multiple SimStructs are, in general, used by a model. These SimStruct's
 *      are arranged as a "tree". The "root" SimStruct is used by
 *      the Simulink model. There is one child SimStruct for each S-function
 *      block with in the model.
 *
 *      The SimStruct can be used in three environments:
 *        o With MATLAB/Simulink (MATLAB_MEX_FILE)
 *        o With Real-Time Workshop in non-real-time (NRT)
 *        o With Real-Time Workshop in real-time (RT)
 *
 * Defines:
 *      One of the following must be defined.
 *        MATLAB_MEX_FILE    - Must be defined when compiling as a MEX file,
 *                             otherwise must not be defined.
 *        NRT                - Define if creating non-real-time executable
 *        RT                 - Define if creating real-time executable.
 *
 *        See ENVIRONMENT MACROS section below for more info.
 *
 *      Defines which must be declared by the Real-Time Workshop
 *      generated model source.
 *        Simulink_NAME="name"
 *        NSAMPLE_TIMES=n
 *
 *      Defines for use with the Real-Time Workshop (these are configured
 *	by the template makefile, do not add directly to make command):
 *        MULTITASKING       - Optional (use MT for a synonym).
 *        NUMST=n            - Number of sample times in the root SimStruct.
 *        TID01EQ=1 or 0     - Optional. Only define to 1 if sample time task
 *                             id's 0 and 1 have equal rates.
 * =============================================================================
 */

#ifndef __SIMSTRUC__
#define __SIMSTRUC__

/*===========================================================================*
 * BEGIN SECTION
 * LIST OF KEY DEFINES CONTROLLING CONDITIONAL COMPILATION
 *
 * Simstruc properties such as definitions, access methods, etc.
 * are conditionally compiled depending on "who" is using the simstruc
 * and in what mode.
 *
 * This section list all the key #define macros controlling the inclusion/
 * exclusion of features, definitions, etc.
 *
 * Typically, this section only assigns a default value (such as false).
 * The final value is adjusted in a subsequent section.
 *===========================================================================*/

/*=======================================================*
 * MODE: SINGLE-TASKING OR MULTI-TASKING
 */
#define RT

#define SS_MULTITASKING (0)

/*=======================================================*
 * MODE: SIMULATION OR GENERATED CODE
 *
 * The following #defines determine whether the simstruc is used in "normal"
 * Simulink simulation or in Real Time Workshop generated code.
 *
 * This is designed to be a mutually exclusive set.
 * One and only one should be defined to be true.
 */
#define SS_SIM (0)
#define SS_RTW (0)

/*=======================================================*
 * MODE: WHO IS USING THE SIMSTRUC
 *
 * The following #defines determine "who" is using the simstruc.
 *
 * This is designed to be a mutually exclusive set.
 * One and only one should be defined to be true.
 */
#define SS_SFCN_LEVEL_1         (0)
#define SS_SFCN_NORMAL          (0)
#define SS_GENERATED_S_FUNCTION (0)
#define SS_SL_INTERNAL          (0)
#define SS_RTW_INTERNAL         (0)
#define SS_SHARED_MODULE        (0)

/*=======================================================*
 * MODE: GENERATED CODE IS REAL-TIME OR NON-REAL-TIME
 *
 * Both can be false, but both can't be true
 */
#define SS_RT  (0)
#define SS_NRT (0)

/*=======================================================*
 * MODE: ENFORCE NDEBUG
 */
#define SS_NDEBUG (0)

/*=======================================================*
 * MODE: ENVIRONMENT HAS STANDARD IO AVAILABLE
 */
#define SS_HAVESTDIO (0)

/*=======================================================*
 * MODE: TID_EQUALS_SAMPLE_TIME_INDEX -
 *     The model will function correctly if this define is false, however if
 *     this define is true the model's performance may be increased depending
 *     upon whether or not the model has fast to slow rate transitions.
 */
#define TID_EQUALS_SAMPLE_TIME_INDEX (0)

/*=======================================================*
 * MODE: TID01EQ == 1
 */
#define SS_TID01EQ_EQUAL_ONE (0)

/*===========================================================================*
 * END SECTION
 * LIST OF KEY DEFINES CONTROLLING CONDITIONAL COMPILATION
 *===========================================================================*/

#ifndef _SIMSTRUCT
#  define _SIMSTRUCT
   /*
    * Use incomplete type for function prototypes within SimStruct itself
    */
   typedef struct SimStruct_tag SimStruct;
#endif

/*=================*
 * Nested includes *
 *=================*/
#include <limits.h>
#include <string.h>
#include "tmwtypes.h"
#include "simstruc_types.h"
#include "solver_zc.h"

#include "stdio.h"

/*===========================================================================*
 * BEGIN SECTION
 * DETERMINE FINAL VALUES OF KEY DEFINES CONTROLLING CONDITIONAL COMPILATION
 *===========================================================================*/

/*====================================*
 * Model reference sim target is an RTW generated
 * S-Function (from the point view of Simstruct).
 */
# if defined(MDL_REF_SIM_TGT)

#include "slMdlrefSfcnBridge.h"
#include "slLogLoadBlocksSfcnBridge.h"
#include "slClientServerAPIBridge.h"

#  undef  MATLAB_MEX_FILE
#  define MATLAB_MEX_FILE          (1)

#  undef  RTW_GENERATED_S_FUNCTION
#  define RTW_GENERATED_S_FUNCTION (1)

# endif

/*====================================*
 * Determine => MODE: SINGLE-TASKING OR MULTI-TASKING
 *
 * This must come after the inclusion of simstruc_types.h
 */
#if defined(MULTITASKING)
# undef  SS_MULTITASKING
# define SS_MULTITASKING     (1)
#endif

/*====================================*
 * Determine => MODE: SIMULATION OR GENERATED CODE
 */
#if defined(MATLAB_MEX_FILE) || defined(SL_INTERNAL) || defined(FIPXT_SHARED_MODULE)
# undef  SS_SIM
# define SS_SIM (1)
#else
# undef  SS_RTW
# define SS_RTW (1)
#endif

/*====================================*
 * Determine => MODE: WHO IS USING THE SIMSTRUC
 */
#if !defined(S_FUNCTION_LEVEL)
# if defined(S_FUNCTION_NAME)
#   define S_FUNCTION_LEVEL 1  /* Backwards compatibility old S-functions */
# else
#   define S_FUNCTION_LEVEL 2
# endif
#endif

#if S_FUNCTION_LEVEL != 1 && S_FUNCTION_LEVEL != 2
#  error Invalid S_FUNCTION_LEVEL
#endif

#if defined(RTW_GENERATED_S_FUNCTION)
  /*
   * Used by RTW Generated S Function, ex  s-fcn target.
   * This flag is independent of how the
   * s-function is built (i.e., it is a #define in the code, not a build
   * flag).  It is true when building the s-function for use with simulink and
   * when building the s-function for use with RTW.
   */
# undef  SS_GENERATED_S_FUNCTION
# define SS_GENERATED_S_FUNCTION (1)

#elif S_FUNCTION_LEVEL == 1
  /*
   * Used with any LEVEL 1 s-function (user written) including:
   *  o build for use with a normal simulation (via mex command)
   *  o build for use with rtw (grt)
   */
# undef  SS_SFCN_LEVEL_1
# define SS_SFCN_LEVEL_1   (1)

#elif defined(S_FUNCTION_NAME)
  /*
   * Used with any s-function (user written) including:
   *  o build for use with a normal simulation (via mex command)
   *  o build for use with rtw (grt)
   */
# undef  SS_SFCN_NORMAL
# define SS_SFCN_NORMAL    (1)

#elif defined(SL_INTERNAL) || defined(RSIM_WITH_SL_SOLVER)
  /*
   * Used internally by Simulink (simulink.dll).
   */
# undef  SS_SL_INTERNAL
# define SS_SL_INTERNAL    (1)

#elif defined(RT) || defined(NRT)
  /*
   * Used in "root" model of generated code, but not in
   * non-inlined, s-functions being compiled for use with the
   * generated code (i.e., rt_main and model.c have access, but
   * sfunc.c does not).
   */
# undef  SS_RTW_INTERNAL
# define SS_RTW_INTERNAL   (1)

#elif defined(FIPXT_SHARED_MODULE)
  /*
   * Used in shared module (such as a dll) that needs to be able to
   * use some feature of the simstruc.
   */
/*
 * Currently, shared module will be treated as if they are
 * normal sfunctions.
 *
# undef  SS_SHARED_MODULE
# define SS_SHARED_MODULE  (1)
*/
# undef  SS_SFCN_NORMAL
# define SS_SFCN_NORMAL    (1)

#elif defined(MATLAB_MEX_FILE)
  /*  Used in mex function that is NOT an S-Function mex
   */
/*
 * Currently, plain mex functions will be treated as if they are
 * normal sfunctions.
 *
# undef  SS_MEX
# define SS_MEX  (1)
*/
# undef  SS_SFCN_NORMAL
# define SS_SFCN_NORMAL    (1)

#else
# error Unrecognized use.
#endif

/*=======================================================*
 * Determine => MODE: GENERATED CODE IS REAL-TIME OR NON-REAL-TIME
 */
#if defined(RT)
# undef  SS_RT
# define SS_RT     (1)
#endif
#if defined(NRT)
# undef  SS_NRT
# define SS_NRT    (1)
#endif

/*=======================================================*
 * Determine => MODE: ENFORCE NDEBUG
 */
#if defined(NDEBUG)
# undef  SS_NDEBUG
# define SS_NDEBUG (1)
#endif

/*=======================================================*
 * Determine => MODE: ENVIRONMENT HAS STANDARD IO AVAILABLE
 */
#if defined(HAVESTDIO)
# undef  SS_HAVESTDIO
# define SS_HAVESTDIO (1)
#endif

/*=======================================================*
 * Determine => MODE: TID_EQUALS_SAMPLE_TIME_INDEX -
 */
#if SS_SL_INTERNAL
# undef  TID_EQUALS_SAMPLE_TIME_INDEX
# define TID_EQUALS_SAMPLE_TIME_INDEX (1)
#else
# if defined(NUMST) && defined(NSAMPLE_TIMES)
#  if NUMST < NSAMPLE_TIMES
#    error NUMST specified incorrectly
#  elif NUMST == NSAMPLE_TIMES
#    undef  TID_EQUALS_SAMPLE_TIME_INDEX
#    define TID_EQUALS_SAMPLE_TIME_INDEX    (1)
#  endif
# endif
#endif

/*=======================================================*
 * Determine => MODE: TID01EQ == 1
 */
#if defined(TID01EQ)
# if TID01EQ == 1
#  undef  SS_TID01EQ_EQUAL_ONE
#  define SS_TID01EQ_EQUAL_ONE (1)
# endif
#endif

/*===========================================================================*
 * END SECTION
 * DETERMINE FINAL VALUES OF KEY DEFINES CONTROLLING CONDITIONAL COMPILATION
 *===========================================================================*/


/*===========================================================================*
 * BEGIN SECTION
 * CHECK PROPER USAGE
 *
 * Issue errors if incompatible modes have been selected
 *===========================================================================*/

#if (defined(RT) + defined(NRT) + defined(MATLAB_MEX_FILE) + defined(SL_INTERNAL) + defined(FIPXT_SHARED_MODULE) != 1)
# error Must define one of RT, NRT, MATLAB_MEX_FILE, SL_INTERNAL, or FIPXT_SHARED_MODULE
# if defined(RT)
#  error defined(RT)
# endif
# if defined(NRT)
#  error defined(NRT)
# endif
# if defined(MATLAB_MEX_FILE)
#  error defined(MATLAB_MEX_FILE)
# endif
# if defined(SL_INTERNAL)
#  error defined(SL_INTERNAL)
# endif
# if defined(FIPXT_SHARED_MODULE)
#  error defined(FIPXT_SHARED_MODULE)
# endif
#endif

#if (defined(NRT) && SS_MULTITASKING)
# error NRT does not support MULTITASKING
#endif

#if (SS_SIM && SS_MULTITASKING)
# error MATLAB/Simulink does not support MULTITASKING
#endif

/*===========================================================================*
 * END SECTION
 * CHECK PROPER USAGE
 *
 * Issue errors if incompatible modes have been selected
 *===========================================================================*/


/*===========================================================================*
 * BEGIN SECTION
 * DETERMINE GROUP DEFINES
 *
 * Group defines are derived from the "KEY DEFINES" listed and determined
 * in previous sections.
 *===========================================================================*/

#if ( SS_SFCN_LEVEL_1 || SS_SFCN_NORMAL || SS_GENERATED_S_FUNCTION )
# define SS_SFCN     (1)
#else
# define SS_SFCN     (0)
#endif


#define SS_SFCN_FOR_SIM (0)
#define SS_SFCN_FOR_RTW (0)
#if SS_SFCN
# if SS_SIM
  /*
   * Used for s-functions (user written or s-fcn target) that are being
   * compiled for use with simulink.dll (i.e., for a regular sim).  Includes:
   *      o build for use with normal simulation (via mex command)
   *
   *  but does not include:
   *
   *      o build for use with rtw (grt)
   */
#  undef  SS_SFCN_FOR_SIM
#  define SS_SFCN_FOR_SIM (1)
# else
#  undef  SS_SFCN_FOR_RTW
#  define SS_SFCN_FOR_RTW (1)
# endif
#endif

/*===========================================================================*
 * END SECTION
 * DETERMINE GROUP DEFINES
 *
 * Group defines are derived from the "KEY DEFINES" listed and determined
 * in previous sections.
 *===========================================================================*/

/*
 * Include headers for MATLAB API function prototypes (e.g. mxGetPr)
 */
#if SS_SL_INTERNAL
# if defined(RSIM_WITH_SL_SOLVER)
   /*
    * Run-time interface for Real-Time Workshop RSIM Full target.
    */
#  include "rt_matrx.h"
# else
   /*
    * Using within Simulink itself
    */
#  include <stdlib.h>
#  include <stdarg.h>
#  include "matrix.h"
# endif

#elif SS_SFCN_FOR_SIM
  /*
   * Used in simulation by sfunction
   */
# include <stdlib.h>
# include <stdarg.h>
# include "mex.h"
# if !defined(S_FUNCTION_NAME)
#   define _S_FUNCTION_NAME_NOT_DEFINED_BEFORE_SIMSTRUCT
# endif
#elif SS_SFCN_FOR_RTW
  /*
   * Used in RTW by sfunction
   */
# include "rt_matrx.h" /* S-function is being used with Real-Time Workshop */
#elif SS_RTW_INTERNAL
  /*
   * Run-time interface for Real-Time Workshop
   */
# if !defined(TYPEDEF_MX_ARRAY)
#  define TYPEDEF_MX_ARRAY
    typedef real_T mxArray;
# endif
#else
  /*
   * Error
   */
# error Unhandled case
#endif

#if defined(ENABLE_SLEXEC_SSBRIDGE)
  /*
   * Prototypes of functions exported from slexec_ssbridge module
   */
#  include "slexec_ssbridge.h"
#endif

/*===========================================================================*
 *===========================================================================*
 *===========================================================================*
 * WARNING: For maintainability:
 *
 * Conditional Compilation below this point should only depend on
 *    KEY DEFINES
 * or
 *    GROUP DEFINES
 * that where determined in the sections above.
 *
 * In particular, #if and #elif should only depend on the KEY DEFINES and/or
 * GROUP DEFINES.
 *
 * All the KEY DEFINES and GROUP DEFINES always have definitions.  Therefore,
 * the preprocessor directives defined(), #ifdef, and #ifndef are not needed
 * below, and their use indicates a likely maintainability problem.  The
 * only exception is the use of #ifndef in the standard technique for guarding
 * against multiple inclusion and multiple definition.
 *===========================================================================*
 *===========================================================================*
 *===========================================================================*/


/*===============================*
 * Defines for S-function blocks *
 *===============================*/

/*
 * DYNAMICALLY_SIZED - Specify for sizes entries that inherit their values
 * from the block that drives them.
 * SIMSTRUCT_VERSION - An integer which is the sizeof the SimStruct times
 * 10000 plus the version times 100. When updating version numbers within the
 * Matlab image, increment both level 1 and level 2 S-functions. Level 1
 * version cannot be in range 220 to 229.  This was the level 2 version in
 * Simulink 2.20 (R10)
 *
 * DYNAMIC_DIMENSION - Specify for input/output port dimension entries that
 * the port inherits its dimension from the block that drives it.
 */

#define ALWAYS_NEEDED          (0)
#define CONDITIONALLY_NEEDED   (1)
#define NEVER_NEEDED           (2)

#define ALWAYS_REFRESHED          (0)
#define CONDITIONALLY_REFRESHED   (1)
#define NEVER_REFRESHED           (2)

#define SIMSTRUCT_VERSION_LEVEL1     (sizeof(SimStruct)*10000 + 214)
#define SIMSTRUCT_VERSION_LEVEL2     (sizeof(SimStruct)*10000 + 229)

#include "sl_common_types_def.h"

#if SS_SL_INTERNAL
#if defined(RSIM_WITH_SL_SOLVER)
# define DISABLED_VARIABLE_NEXT_TIME  rtMinusInf
#else
# define DISABLED_VARIABLE_NEXT_TIME (utGetMinusInf())
#endif
#endif

#define ssSampleAndOffsetAreTriggered(st,ot) \
((st == INHERITED_SAMPLE_TIME) && (ot == INHERITED_SAMPLE_TIME))
#define ssSampleAndOffsetAreTriggeredOrAsync(st,ot) \
((st == INHERITED_SAMPLE_TIME) && (ot <= INHERITED_SAMPLE_TIME))

/*
 * Task ID's ordering
 *      Continuous task
 *      Continuous but fixed in minor step task
 *      Discrete task 1
 *         ...
 *      Discrete task N
 *      Variable sample time task(s), offset is instance number.
 *
 * If continuous task is present then it's task ID is 0, otherwise the
 * first discrete task ID will be 0 if it is present, etc.
 * All blocks with varying sample times have same sample task period of -2,
 * and the offset is the instance number.
 *
 * The triggered blocks are not in the sample time table and have a task ID
 * of -1.
 */

#define CONSTANT_TID            (-2)
#define GENERIC_ASYNC_TID       (-3)

/*==========================================================================*
 * PropagationPassType - used to distinguish for pass initialization
 * If you add or update PropagationPassType, update simulink/sl_types_compile.hpp too
 *==========================================================================*/
#ifndef _PROPAGATIONPASSTYPE
# define _PROPAGATIONPASSTYPE
    typedef enum {
        DIMENSION_PROPAGATION,
        TYPE_PROPAGATION,
        COMPLEX_PROPAGATION
    } PropagationPassType;
#endif

typedef enum {
    SIM_PAUSE,
    SIM_CONTINUE
} ssSimStatusChangeType;

/*===============================================*
 * General defines used only by the macros below *
 *===============================================*/


/*
 * Conversion routines for frame data storage
 */
#define NEG1_2BITS '\x03'
#define CONV_BITS2INT(val) \
          ( (((val) & 2U) != 0U) ? FRAME_INHERITED : (((val) & 1U) != 0U) ? FRAME_YES : FRAME_NO )
#define CONV_INT2BITS(val) \
          ( ((val) == FRAME_INHERITED) ? (NEG1_2BITS) : ((val) & 1U) )

/*
 * Conversion routines for dimensions mode storage
 */
#define CONV_BITS2DIMSMODE(val) \
          ( (((val) & 2U) != 0) ? INHERIT_DIMS_MODE : (((val) & 1U) != 0U) ? VARIABLE_DIMS_MODE : FIXED_DIMS_MODE )
#define CONV_DIMSMODE2BITS(val) \
          ( ((val) == INHERIT_DIMS_MODE) ? (NEG1_2BITS) : ((val) & 1U) )

/*
 * Conversion routines for bus mode storage
 */
#define CONV_BITS2BUSMODE(val) \
          ( (((val) & 2U) != 0) ? SL_INHERIT_BUS_MODE : (((val) & 1U) != 0U) ? SL_BUS_MODE : SL_NON_BUS_MODE )
#define CONV_BUSMODE2BITS(val) \
          ( ((val) == SL_INHERIT_BUS_MODE) ? (NEG1_2BITS) : ((val) & 1U) )

/*=================================================================*
 * Defines used by Simulink.c when calling the S-function routines *
 *=================================================================*/
#if SS_SL_INTERNAL || SS_SFCN_FOR_SIM
# define SS_CALL_MDL_INITIALIZE_SAMPLE_TIMES        101
# define SS_CALL_MDL_INITIALIZE_CONDITIONS          102
# define SS_CALL_MDL_GET_TIME_OF_NEXT_VAR_HIT       103
# define SS_CALL_MDL_OUTPUTS                        104
# define SS_CALL_MDL_UPDATE                         105
# define SS_CALL_MDL_DERIVATIVES                    106
# define SS_CALL_MDL_TERMINATE                      107
# define SS_CALL_MDL_ZERO_CROSSINGS                 108
# define SS_CALL_MDL_GET_INPUT_PORT_WIDTH           109
# define SS_CALL_MDL_GET_OUTPUT_PORT_WIDTH          110
# define SS_CALL_MDL_SET_WORK_WIDTHS                111
# define SS_CALL_MDL_CHECK_PARAMETERS               112
# define SS_CALL_MDL_SET_INPUT_PORT_DATA_TYPE       113
# define SS_CALL_MDL_SET_OUTPUT_PORT_DATA_TYPE      114
# define SS_CALL_MDL_SET_INPUT_PORT_WIDTH           115
# define SS_CALL_MDL_SET_OUTPUT_PORT_WIDTH          116
# define SS_CALL_MDL_START                          117
# define SS_CALL_MDL_PROCESS_PARAMETERS             118
# define SS_CALL_MDL_RTW                            119
# define SS_CALL_MDL_SET_INPUT_PORT_COMPLEX_SIGNAL  120
# define SS_CALL_MDL_SET_OUTPUT_PORT_COMPLEX_SIGNAL 121
# define SS_CALL_MDL_SET_INPUT_PORT_SAMPLE_TIME     122
# define SS_CALL_MDL_SET_OUTPUT_PORT_SAMPLE_TIME    123
# define SS_CALL_RTW_GENERATED_ENABLE               124
# define SS_CALL_RTW_GENERATED_DISABLE              125
# define SS_CALL_MDL_SET_INPUT_PORT_DIMENSION_INFO  126
# define SS_CALL_MDL_SET_OUTPUT_PORT_DIMENSION_INFO 127
# define SS_CALL_MDL_SET_INPUT_PORT_FRAME_DATA      128
# define SS_CALL_MDL_PROJECTION                     129
# define SS_CALL_MDL_JACOBIAN                       130
# define SS_CALL_MDL_SET_DEFAULT_PORT_DIMENSION_INFO  131
# define SS_CALL_MDL_SET_DEFAULT_PORT_DATA_TYPES      132
# define SS_CALL_MDL_SET_DEFAULT_PORT_COMPLEX_SIGNALS 133
# define SS_CALL_MDL_EXT_MODE_EXEC                    134
# define SS_CALL_MDL_RTWCG                            135
# define SS_CALL_MDL_MASSMATRIX                       136
# define SS_CALL_MDL_FORCINGFUNCTION                  137
/*       UNUSED                                      138 */
# define SS_CALL_MDL_ENABLE                           139
# define SS_CALL_MDL_DISABLE                          140
# define SS_CALL_MDL_SIM_STATUS_CHANGE                141
# define SS_CALL_MDL_INITIALIZE_PROPAGATION_PASS      142
# define SS_CALL_MDL_CONSTRAINTS                      143
# define SS_CALL_MDL_GET_SIM_STATE                    144
# define SS_CALL_MDL_SET_SIM_STATE                    145
# define SS_CALL_MDL_INIT_SYSTEM_MATRICES             146
# define SS_CALL_MDL_FINALIZE_ALL_DIMS                147
# define SS_CALL_MDL_JACOBIANIRJC                     148
#endif

/*=================================================================*
 * Defines for use by External Mode during simulation              *
 *=================================================================*/
#ifndef ExtModeLogBlockMeth_def
#define ExtModeLogBlockMeth_def
typedef enum {
    /*
     * Called when the user request the trigger to be armed (i.e., after
     * the 'arm trigger' button is pressed and the trigger arm message
     * has successfully been handed off to ext_comm).
     */
    EXTLOGTASK_TRIG_ARM,

    /*
     * Called when the first point of a one-shot arrives.
     */
    EXTLOGTASK_INIT_EVENT,

    /*
     * Definitions:
     *  one-shot:    one buffer of data collected when the trigger fires.
     *  normal-mode: a series of one-shots
     *
     * When in normal mode, each buffer in the series, except for the last
     * buffer is consider to be an 'intermediate' buffer.  When the final
     * point of an intermediate buffer has arrived on the host, the
     * EXTLOGTASK_TERM_INTERMEDIATE_ONESHOT method is called.  When the
     * final point of the last buffer of the series arrives, the
     * EXTLOGTASK_TERM_SESSION is called.
     *
     * Note that when not in normal mode, the
     * EXTLOGTASK_TERM_INTERMEDIATE_ONESHOT method is never called.
     *
     * Also see EXTLOGTASK_TERM_SESSION.
     */
    EXTLOGTASK_TERM_INTERMEDIATE_ONESHOT,

    /*
     * Called when:
     *  o In normal mode and the last point of the last buffer in a one-shot
     *    series has arrived (i.e., this is the end of the current log session).
     *
     *  o When in one-shot mode and the final point arrives (again this is the
     *    end of the logging session since the one and only buffer has been
     *    acquired).
     *
     *  See comments for: EXTLOGTASK_TERM_INTERMEDIATE_ONESHOT
     */
    EXTLOGTASK_TERM_SESSION

} ExtModeLogBlockMeth;
#endif

/*==================================*
 * Structures with in the SimStruct *
 *==================================*/

typedef struct ssSparseMatrixInfo_tag {
    int_T   mRows;                  /* number of rows   */
    int_T   nCols;                  /* number of cols   */
    int_T   nzMax;                  /* size of *pr, *ir */
    int_T   *Ir;                    /* row indices      */
    int_T   *Jc;                    /* column offsets   */
    real_T  *Pr;                    /* nonzero entries  */
} ssSparseMatrixInfo;


/* For Backward compatibility with R12Lcs */
#define  SS_UNORIENTED_OR_COL_VECT     SS_1_D_OR_COL_VECT
#define  SS_UNORIENTED_OR_ROW_VECT     SS_1_D_OR_ROW_VECT
#define  SS_UNORIENTED_ROW_OR_COL_VECT SS_1_D_ROW_OR_COL_VECT
#define  SS_UNORIENTED_VECT            SS_1_D_VECT

/*
 * _ssSizes - valid in all SimStruct's. There is one sizes for a level-1
 * S-function and another sizes for a level 2 S-function.
 */

struct _ssSizes {
  int_T numContStates;     /* number of continuous states                    */
  int_T numDiscStates;     /* number of discrete states                      */
  union {
    int_T numOutputPorts;  /* number of output ports for S-functions         */
    int_T numY;            /* Length of the external output vector for models
                              i.e. the sum of the widths of the outports.
                              For level 1 S-functions, this is the output
                              port width.                                    */
  } out;
  union {
    int_T numInputPorts;   /* number of input ports for S-functions          */
    int_T numU;            /* Length of the external input vector for models
                              i.e. the sum of the widths of the inports.
                              For level 1 S-functions, this is the input
                              port width.                                    */
  } in;
  int_T mexApiInt1;          /* reserved for use by Simulink mex api         */

  int_T sysDirFeedThrough; /* Not used by s-functions - only for root models */


  int_T numSampleTimes;    /* # of different sample times and/or time offsets*/
  int_T numSFcnParams;     /* number of external matrices passed in          */

                           /* -------- Work vectors ------------------------ */
  int_T numIWork;          /* size of integer work vector                    */
  int_T numRWork;          /* size of real_T precision work vector           */
  int_T numPWork;          /* size of pointer work vector                    */

                           /* -------- Block counts ------------------------ */
  int_T numBlocks;         /* number of Blocks in the model                  */
  int_T numSFunctions;     /* number of S-Functions                          */

                           /* -------- Model bookkeeping ------------------- */
  int_T numBlockIO;        /* number of block outputs                        */
  int_T numBlockParams;    /* number of block parameters                     */
  uint32_T checksums[4];   /* Checksums  of model                            */

                           /* -------- Version ----------------------------- */
  int32_T simStructVer;    /* SimStruct version                              */

                           /* -------- Zero Crossings ---------------------- */
  int_T numNonsampledZCs;  /* number of non-sampled zero crossings            */
  int_T numZCEvents;       /* number of zero crossing events                 */

                           /* -------- Modes ------------------------------- */
  int_T numModes;          /* number of modes                                */

                           /* -------- Configuration options --------------- */
  uint32_T options;        /* General options                                */


                           /* -------- Vector Sizes In Bytes  -------------- */

  int_T sizeofY;           /* Sizeof of external input, Y, in bytes          */
  int_T sizeofU;           /* Sizeof of external input, U, in bytes          */
  int_T sizeofBlockIO;     /* size of block outputs (number of bytes)        */

  int_T sizeofGlobalBlockIO; /* size of the global block outputs in bytes*/

  int_T numDWork;          /* size of data type work vectors                 */
  int_T sizeofDWork;       /* Size of data type work vector. Depends on
                              dwork data types, complex signals, and
                              num dworks.                                    */
  int_T RTWGeneratedSFcn;  /* Flag which is set for rtw generated s-function */
                           /* Remove once all dstates are changed to dworks  */
                           /* ------------- Reserved ------------------------*/
  struct {
      unsigned int hasMdlDimensionsFcn: 1;  /* uses width or dimension method*/
      unsigned int usesNumPorts:        1;  /* used for distinguishing between
                                               union fields in. and out. */
      unsigned int vectMode:            4;  /* used in set dimension methods */
      unsigned int blockReduction:      1;  /* used to request blk reduction */
      unsigned int treatAsAtomic:       1;  /* used to treat block as atomic
                                               subsystem */
      unsigned int rtwcg:               1;  /* supports CGIR */
      unsigned int needAbsoluteTime:    1;
      unsigned int explicitFCSSCtrl:    1; /* used for explicit fcncall orig */

      unsigned int modelRefTsInhSupLevel: 2; /* used for determining if a model
                                             * can inherit a sample time when it
                                             * is used as a block*/
      unsigned int needElapseTime:       1;
      unsigned int hasSubFunctions:      1;
      unsigned int callsOutputInInit:    1;
      /* mdlProjection may be present, but we may not want to call it */
      unsigned int disableMdlProjection: 1;

      unsigned int modelRefNormalModeSupport: 2;
      unsigned int simStateCompliance: 4;
      unsigned int simStateVisibility: 1;
      /* Use JacobianFcn in places of SlvrJacobianFcn */
      unsigned int disableMdlSlvrJacobian :1;

      /* Used to check if rapid accelerator is active */
      unsigned int isRapidAcceleratorActive :1;
      unsigned int isConcurrentTasks        :1;

      unsigned int usesCustomCodeFcns : 1;
      unsigned int crlReplacementEnabled :1;
      /* prevent lint warning about bit fields greater than 16 bits */
      unsigned int reserved:          3; /* remainder are reserved        */
  } flags;

  int_T numJacobianNzMax;  /* number of nonzero elements in sparse Jacobian  */

  void       *rtModel;       /* rtModel pointer */
  const void *constBlockIO;  /* Pointer to invariant signals */

  /*
   * The funky statements below were necessitated because we originally
   * had 5 reserved integer fields. In order to get a (void *) field
   * we need one int on certain platforms and two on others. To
   * overcome this, we have the definition below.
   *
   * Note that there is only ONE remaining reserved int (for alpha
   * anyway, there are 3 on other platforms i.e. the ones where
   * sizeof(int) = sizeof(void*) )
   *
   * In order to use it, there will need to be added some appropriate
   * pre-processor definitions to keep from attempting to instantiate
   * an array of length 0.
   *
   * The problem is that on alpha sizeof(void *) = 64 and
   * sizeof(int) = 32 so we have:
   *   4 - 2*sizeof(void *)/sizeof(int) = 4 - 2*64/32 = 0
   */
  int  reservedForFuture[5 - 2*sizeof(void *)/sizeof(int)];
};

#define SIZES_LENGTH  (sizeof(struct _ssSizes)/sizeof(int_T))

/*
 * _ssPortInfo (S->portInfo), this is only used by level 2 S-functions.
 *
 */

typedef const void      * const * InputPtrsType;

typedef const real_T    * const * InputRealPtrsType;
typedef const real32_T  * const * InputReal32PtrsType;
typedef const int8_T    * const * InputInt8PtrsType;
typedef const uint8_T   * const * InputUInt8PtrsType;
typedef const int16_T   * const * InputInt16PtrsType;
typedef const uint16_T  * const * InputUInt16PtrsType;
typedef const int32_T   * const * InputInt32PtrsType;
typedef const uint32_T  * const * InputUInt32PtrsType;
typedef const boolean_T * const * InputBooleanPtrsType;

typedef void *                 OutputVectType;

#define GET_DATA_TYPE(dt)            ((dt) & 0xFFFF)
#define GET_COMPLEX_SIGNAL(dt)       (((dt) & 0x10000) != 0)


/*
 * Auxiliary DWork structure for S-Functions, one for each dwork.
 */
struct _ssDWorkAuxRecord {
    char_T           *rtwIdentifier;
    int_T            rtwStorageClass;
    char_T           *rtwTypeQualifier;
    struct {
        unsigned int DisableBoundsChecking:  1; /* disable bounds check    */
        unsigned int ExtModeUpload:          1; /* upload dwork in extmode */
        unsigned int rtwIdMustResolveToSignalObject: 2;
                                 /* identifier must resolve to signal object
                                  * 0U: Try resolve (implicit signal resolution)
                                  * 1U: Must resolve
                                  * 2U: Must not resolve */
        unsigned int rtwIdDoneResolve:       1; /* done resolving identifier */
        unsigned int ensureResetForSizeVary: 1; /* ensure reset for size change */
        unsigned int minMaxCheckpoint:       2; /* remainder are reserved    */
        unsigned int optimizeInIR:           1; /* convert to local if correct */
        unsigned int reserved7:              7; /* remainder are reserved    */
        unsigned int reserved16:            16; /* remainder are reserved  */
    } flags;
    int_T            icPrmIdxPlus1;             /* block IC parameter (if
                                                 * there is) mapped to this
                                                 * dwork; 0 for none
                                                 */
    int_T            bitFieldWidth;
    int_T            unusedInts[2];

    void             *resolvedSignalObject;
    void             *unusedPtrs[3];
};

/* Registration returns 1 for success and 0 for failure */
typedef int_T (*_ssRegNumInputPortsFcn) (void * arg1, int_T nInputPorts);
typedef int_T (*_ssRegNumOutputPortsFcn) (void * arg1, int_T nOutputPorts);

typedef int_T (*_ssSetInputPortDimensionInfoFcn)  (SimStruct        *arg1,
                                                   int_T            port,
                                                   const DimsInfo_T *dimsInfo);
typedef int_T (*_ssSetOutputPortDimensionInfoFcn) (SimStruct        *arg1,
                                                   int_T            port,
                                                   const DimsInfo_T *dimsInfo);


struct _ssPortInputs {
    int_T          width;               /* Number of elements in input
                                           port                          */
    int_T          directFeedThrough;   /* Direct feedthrough for input
                                           port                          */
    DTypeId        dataTypeId;          /* Data type of input port.      */
    CSignal_T      complexSignal;       /* Complex signal (-1=either,
                                           0=no, or 1=yes)?              */
    union {
        const void   *vect;
        InputPtrsType ptrs;
    } signal;                           /* Inputs for level 2 S-functions */

    int_T          connected;           /* Are there signals entering
                                           the input port of the Sfcn?   */
    struct {
        unsigned int overWritable       :  1;
        unsigned int optimOpts          :  2;
        unsigned int frameData          :  2;
        unsigned int contiguity         :  1;
        unsigned int acceptExprInRTW    :  1;
        unsigned int cinId              :  2;
        unsigned int nonDerivPort       :  1;
        unsigned int dimensionsMode     :  2;
        unsigned int busMode            :  2;
        unsigned int optimizeInIR       :  1;
        unsigned int reserved1          :  1;
        unsigned int reserved16         :  16;
    } attributes;

    real_T         sampleTime;          /* Sample and offset time when   */
    real_T         offsetTime;          /* block specifies port based ts */
    int_T          *dims;               /* port dimensions               */
    int_T          bufferDstPort;

    int_T          sampleTimeIndex;     /* Sample time index when using
                                           port based sample times       */
    int_T          numDims;             /* port number of dimensions     */
};

struct _ssPortOutputs {
    int_T          width;               /* Number of elements in output
                                           port                          */
    DTypeId        dataTypeId;          /* Data type of outputs          */
    CSignal_T      complexSignal;       /* Complex signal (-1=either,
                                           0=no, or 1=yes)?              */
    void           *signalVect;         /* Output signal                 */
    int_T          connected;           /* Are the signals leaving the
                                           Sfcn driving other blocks?    */
    struct {
        unsigned int optimOpts       :  2;
        unsigned int frameData       :  2;
        unsigned int cToMergeBlk     :  1;
        unsigned int constOutputExprInRTW   :  1;
        unsigned int outputExprInRTW :  1;
        unsigned int trivialOutputExprInRTW :  1;
        unsigned int okToMerge       :  2;
        unsigned int cecId           :  2;
        unsigned int nonContPort     :  1;
        unsigned int dimensionsMode  :  2;
        unsigned int fedByBlockWithModesNoZCs : 1;
        unsigned int busMode         :  2;
        unsigned int optimizeInIR    :  1;
        unsigned int reserved13      : 13;
    } attributes;

    real_T         sampleTime;          /* Sample and offset time when   */
    real_T         offsetTime;          /* block specifies port based ts */
    int_T          *dims;               /* port dimensions               */
    int_T          sampleTimeIndex;     /* Sample time index when using
                                           port based sample times       */
    int_T          icPrmIdxPlus1;       /* block IC parameter (if
                                         * there is) mapped to this
                                         * port; 0 for none
                                         */
    int_T          numDims;             /* port number of dimensions     */
};

struct _ssPortInfo {

    _ssRegNumInputPortsFcn  regNumInputPortsFcn;
    void                    *regNumInputPortsFcnArg;
    _ssRegNumOutputPortsFcn regNumOutputPortsFcn;
    void                    *regNumOutputPortsFcnArg;

    struct _ssPortInputs    *inputs;    /* Info for each input port of blk  */
    struct _ssPortOutputs   *outputs;   /* Info for each output port of blk */
};



typedef struct ssContextMemoryInfo_tag {
    void* base;
    size_t size;
} ssContextMemoryInfo;

/* Masks for determining the parameter attributes (see ssSfcnParams struct). */
#define SFCNPARAM_NOT_TUNABLE     (1 << 0x0)
#define SFCNPARAM_TUNABLE         (1 << 0x1)
#define SFCNPARAM_SIMONLY_TUNABLE (1 << 0x2)
#define SFCNPARAM_CLEAR_TUNABLE (~(SFCNPARAM_NOT_TUNABLE | SFCNPARAM_TUNABLE |\
                                  SFCNPARAM_SIMONLY_TUNABLE))

struct _ssSFcnParams {
    int_T         dlgNum;      /* Number of S-function parameters passed in   */
    mxArray       **dlgParams; /* The S-function parameters                   */
    uint_T        *dlgAttribs; /* Disable parameter changes during simulation?*/

    /* union preserves the memory map of the Simstruc; the size of an integer
     * is always less than or equal to that of a pointer
     */
    union {
        int_T     numRtp;
        void      *placeholder;
    } numRtp;
    ssParamRec **rtp;
};


struct _ssWork {
  int_T                     *iWork;       /* integer work vector             */
  real_T                    *rWork;       /* real work vector                */
  void                      **pWork;      /* pointer work vector             */
  int_T                     *modeVector;  /* mode work vector                */
  void                      *userData;    /* User/application specific data  */

  union {
    struct _ssDWorkRecord *sfcn;
    void                  *root;
  }                          dWork;      /* data type work vector            */

  struct _ssDWorkAuxRecord  *dWorkAux;
  void                      *reservedForFuture[1];
};


/*
 * Input port variable dimensions information.
 */
struct _ssInPortVarDims {
    const int  *portVarDims;
    void       *reserved[8];
};

/*
 * Output port variable dimensions information.
 */
struct _ssOutPortVarDims {
    int  *portVarDims;
    void *reserved[8];
};

/*
 * The _ssPortInfo2 structure is used by S-function blocks to store port
 * variable dimensions information
 */
struct _ssPortInfo2 {
    struct _ssInPortVarDims  *inputs;
    struct _ssOutPortVarDims *outputs;
    void *reserved[8];
};

/*
 * The _ssBlkInfo structure can be used by S-function blocks to determine
 * status about the model in which they reside.
 */
struct _ssBlkInfo2 {
    void  *rtwSfcnInfo;   /* Used only in RTW by the S-function     */
    void* unused;
    struct _ssPortInfo2 *portInfo2;
    void  *reservedPtrs[14];
    int_T reserved[16];
};

struct _ssBlkInfo {
  int_T        inputConnected;  /* Is input connected to a non-virtual block? */
  int_T        outputConnected; /* Is output connected to a non-virtual block?*/
  const char_T *placementGroup; /* Name of group to place block in. Only
                                   applies to sources and sinks. Blocks with
                                   same group name will appear adjacent in
                                   the sorted list.                          */

  void         *block;          /* The owner slBlock * of the s-function     */

  struct _ssBlkInfo2 *blkInfo2;  /* More block info                           */

  int_T        absTolOffset_Obsolete;     /* Offset from the root SimStruct absTol     */
  int_T        reservedForFutureInt;
};

/*==================================================================*
 * Mode of simulation - single vs multi-tasking. Note, variable       *
 * step solvers ignore this property and are always single-tasking   *
 *==================================================================*/
typedef enum {
    GEN_FCN_SET_NUM_RUN_TIME_PARAMS,
    GEN_FCN_REG_RUN_TIME_PARAM,
    GEN_FCN_UPDATE_RUN_TIME_PARAM,
    GEN_FCN_REG_ALL_TUNE_PRM_AS_RTP,
    GEN_FCN_UPDATE_ALL_TUNE_PRM_AS_RTP,
    GENFCNFIXPT_DIMS_SUM_IN,
    GENFCNFIXPT_DIMS_SUM_OUT,
    GENFCNFIXPT_DIMS_SUM_DEFAULT,
    GENFCNFIXPT_DIMS_PROD_IN,
    GENFCNFIXPT_DIMS_PROD_OUT,
    GENFCNFIXPT_DIMS_PROD_DEFAULT,
    GENFCNFIXPT_DIMS_MPSWITCH_IN,
    GENFCNFIXPT_DIMS_MPSWITCH_OUT,
    GENFCNFIXPT_DIMS_LOGIC_IN,
    GENFCNFIXPT_DIMS_LOGIC_OUT,
    GENFCNFIXPT_DIMS_LOGIC_DEFAULT,
    GENFCNFIXPT_DIMS_GAIN_IN,
    GENFCNFIXPT_DIMS_GAIN_OUT,
    GENFCNFIXPT_DIMS_GAIN_DEFAULT,
    GENFCNFIXPT_LICENSE,
    GEN_FCN_IS_RTPARAM_TUNABLE,
    GEN_FCN_GET_BLOCK_HANDLE,
    GEN_FCN_REGISTER_DATA_STORE_FROM_NAME,
    GEN_FCN_READ_FROM_DATA_STORE,
    GEN_FCN_WRITE_TO_DATA_STORE,
    GEN_FCN_REGISTER_NUM_DATA_STORE,
    GEN_FCN_COMPUTE_INPUT,
    GEN_FCN_GET_DATATYPEOVERRIDE,
    GEN_FCN_GET_MINMAXLOG,
    GEN_FCN_GET_MINMAXARCHIVE,
    GEN_FCN_REG_CONST_RUN_TIME_PARAM,
    GEN_FCN_SF_INLINABLE,
    GEN_FCN_REG_AND_CNV_RUN_TIME_PARAM,
    GEN_FCN_UPDATE_AND_CNV_RUN_TIME_PARAM,
    GEN_FCN_SET_ZERO_BASED_IN_PORT,
    GEN_FCN_SET_ZERO_BASED_OUT_PORT,
    GEN_FCN_SET_ONE_BASED_IN_PORT,
    GEN_FCN_SET_ONE_BASED_OUT_PORT,
    GEN_FCN_SET_MODELREF_UNUSED,
    GEN_FCN_CHK_MODELREF_SOLVER_MODE,
    GEN_FCN_REGISTER_TYPE_FROM_NAMED_OBJECT,
    GEN_FCN_REGISTER_TYPE_FROM_PARAMETER,
    GEN_FCN_SET_MODELREF_STORAGE_CLASSES,
    GEN_FCN_SET_MODELREF_STORAGE_TYPE_QUALIFIERS,
    GEN_FCN_SET_MODELREF_IDENTIFIERS,
    GEN_FCN_SET_MODELREF_TEST_POINTS,
    GEN_FCN_CREATE_RUN_TIME_PARAM_FROM_DATA,
    GEN_FCN_UPDATE_RUN_TIME_PARAM_FROM_DATA,
    GEN_FCN_FULL_REG_AND_CNV_RUN_TIME_PARAM,
    GEN_FCN_SET_NUM_MODELREF_INTFPARAM_ARGS,
    GEN_FCN_REG_MODELREF_INTFPARAM_ARG,
    GEN_FCN_GET_MODELREF_INTFPARAM_ARG_DATA,
    GEN_FCN_SET_DATA_ALIGNMENT,
    GEN_FCN_SET_ASYNC_TIMER_ATTRIBUTES,
    GEN_FCN_SET_ASYNC_TASK_PRIORITIES,
    GEN_FCN_SET_NUM_MODELREF_INTFPARAM_GLOBALS,
    GEN_FCN_REG_MODELREF_INTFPARAM_GLOBAL,
    GEN_FCN_GET_MODELREF_INTFPARAM_GLOBAL_DATA,
    GEN_FCN_GET_ELAPSE_TIME,
    GEN_FCN_GET_ELAPSE_TIME_COUNTER_DTYPE,
    GEN_FCN_GET_ELAPSE_TIME_COUNTER,
    GEN_FCN_GET_ELAPSE_TIME_RESOLUTION,
    GEN_FCN_COMPUTE_OUTPUT,
    GEN_FCN_SET_OUTPUT_OVERWRITE_INPUT_IDX,
    GEN_FCN_SET_MODELMAPPINGINFO,
    GEN_FCN_SET_SF_INIT_OUTPUT,
    GEN_FCN_GET_PRODHWDEVICEINFO,
    GEN_FCN_CHK_MODELREF_SOLVER_TYPE,
    GEN_FCN_CHK_MODELREF_SOLVER_NAME,
    GEN_FCN_CHK_MODELREF_FIXED_STEP,
    GEN_FCN_CHK_MODELREF_START_TIME,
    GEN_FCN_CHK_MODELREF_STOP_TIME,
    GEN_FCN_REG_MODELREF_MDL_INFO,
    GEN_FCN_SET_MODELREF_TO_FILES,
    GEN_FCN_SET_MODELREF_FROM_FILES,
    GEN_FCN_REG_MODELREF_CHILD_MODEL,
    GEN_FCN_SET_BUS_PROPAGATION,
    GEN_FCN_SET_BUS_SOURCE_PORT,
    GEN_FCN_SET_BUS_INPORTS,
    GEN_FCN_GET_PARAM_NAME,
    GEN_FCN_SET_BUS_OUTPUT_OBJECT_NAME,
    GEN_FCN_SET_BUS_OUTPUT_AS_STRUCT,
    GEN_FCN_SET_NONITERATOR_ASSIGNMENT_BLOCK,
    GEN_FCN_COMPUTE_STATEFLOW_SYMBOL_NAME,
    GEN_FCN_SET_OPTIMIZE_MODELREF_INIT_CODE,
    GEN_FCN_REG_MDL_INFO,
    GEN_FCN_SET_BUS_INPUT_AS_STRUCT,
    GEN_FCN_UNUSED,
    GEN_FCN_SET_TIME_SOURCE,
    GEN_FCN_SET_MODELREF_PORT_RESOLVED_TO_SIGNAL_OBJECTS,
    GEN_FCN_CHK_MODELREF_HARDWARE_SETTINGS,
    GEN_FCN_CHK_MODELREF_LIFE_SPAN,
    GEN_FCN_ENABLE_FCN_IS_TRIVIAL,
    GEN_FCN_DISABLE_FCN_IS_TRIVIAL,
    GEN_FCN_SET_ASYNC_TIMER_DATA_TYPE,
    GEN_FCN_GET_CONTEXT_SYS_PTR,
    GEN_FCN_GET_CONTEXT_TID,
    GEN_FCN_SET_OUTPUT_FCN_CALLED_MULTIPLE,
    GEN_FCN_SET_NOT_MULTIPLE_INLINEABLE,
    GEN_FCN_GET_DATA_STORE_ADDR,
    GEN_FCN_REGISTER_TYPE_FROM_EXPR,
    GEN_FCN_REGISTER_TYPE_FROM_EXPR_NO_ERROR,
    GEN_FCN_GET_ZCSIGNAL_ZCEVENTS,
    GEN_FCN_REG_MODELREF_NONCONTSIGS,
    GEN_FCN_CHK_MODELREF_VSOLVER_OPTS,
    GEN_FCN_SET_INPUTS_NEED_ADDRESS,
    GEN_FCN_SET_INPUT_DIMS_MODE,
    GEN_FCN_SET_OUTPUT_DIMS_MODE,
    GEN_FCN_REG_SET_INPUT_DIMS_MODE_MTH,
    GEN_FCN_READ_FROM_DATA_STORE_ELEM,
    GEN_FCN_WRITE_TO_DATA_STORE_ELEM,
    GEN_FCN_GET_DATA_STORE_INFO,
    GEN_FCN_MODELREF_SET_FUNDAMENTAL_SAMPLE_TIME_INFO,
    GEN_FCN_CHK_MODELREF_SOLVER_TYPE_EARLY,
    GEN_FCN_SET_MODELREF_INLINED_VARS,
    GEN_FCN_SET_INPUT_DIMS_SAMEAS_OUTPUT,
    GEN_FCN_CHECK_SFCN_PARAM_VALUE_ATTRIBS,
    GEN_FCN_SET_EXPORTS_FUNCTION_CALLS,
    GEN_FCN_SET_EXPORTED_OUTPUT_FCN,
    GEN_FCN_SET_EXPORTED_ENABLE_FCN,
    GEN_FCN_SET_EXPORTED_DISABLE_FCN,
    GEN_FCN_SET_INPORT_LATCHED,
    GEN_FCN_SET_ALLOW_MORE_THAN_2D_SIGS,
    GEN_FCN_DEST_FCSS_ENABLED,
    GEN_FCN_SET_CURR_OUTPUT_DIMS,
    GEN_FCN_GET_SIM_STATUS,
    GEN_FCN_MODELREF_SET_TRIGGER_TS_TYPE_INFO,
    GEN_FCN_SET_STATE_ATTR,
    GEN_FCN_GET_STATE_ATTR,
    GEN_FCN_SET_INPUT_BUS_MODE,
    GEN_FCN_SET_OUTPUT_BUS_MODE,
    GEN_FCN_REG_SET_INPUT_BUS_MODE_MTH,
    GEN_FCN_REG_MDLREF_DWORK_TYPE,
    GEN_FCN_PRUN_TRAILING_DIMS,
    GEN_FCN_SET_SIGS_ALLOW_BIG_LONG,
    GEN_FCN_GET_MDLREF_TYPE,
    GEN_FCN_SET_MODELREF_INPUT_SIGNAL_DESIGN_MIN,
    GEN_FCN_SET_MODELREF_INPUT_SIGNAL_DESIGN_MAX,
    GEN_FCN_SET_MODELREF_OUTPUT_SIGNAL_DESIGN_MIN,
    GEN_FCN_SET_MODELREF_OUTPUT_SIGNAL_DESIGN_MAX,
    GEN_FCN_SET_JACOBIAN_FLAG,
    GEN_FCN_SET_OUTPUT_PORT_DISCRETE_VALUED_OUTPUT,
    GEN_FCN_SET_OUTPUT_IC_ATTRIBUTES,
    GEN_FCN_SET_MODELREF_CONSISTENT_OUTPORT_INIT,
    GEN_FCN_SET_SUPPORT_RUNTIME_MODEL_API,
    GEN_FCN_SET_SUPPORT_DATATYPE_BEYOND_32_BITS_IN_RTW,
    GEN_FCN_SET_FXPU32_BITREGION_COMPLIANT,
    GEN_FCN_GET_FXPU32_BITREGION_COMPLIANT,
    GEN_FCN_SET_COMP_VARSIZE_COMPUTE_TYPE,
    GEN_FCN_ADD_DIMS_DEPEND_RULE,
    GEN_FCN_GET_TIME_RESOLUTION,
    GEN_FCN_GET_RTWCG_SUPPORT,
    GEN_FCN_SET_ARRAYSCOPE_TO_LOCAL,
    GEN_FCN_ADD_VARDIMS_RUNTIME_CHECKER,
    GEN_FCN_SET_ASYNC_TASK_PRIORITIES_EL,
    GEN_FCN_SET_ASYNC_TIMER_RESOLUTION_EL,
    GEN_FCN_SET_ASYNC_TIMER_DATA_TYPE_EL,
    GEN_FCN_SET_TIME_SOURCE_EL,
    GEN_FCN_SET_MODELREF_OUTPUT_BIO_UPDATED_IN_ANOTHER_CTX,
    GEN_FCN_REG_MODELREF_SET_DIMS_DEPEND_RULES,
    GEN_FCN_REG_MODELREF_FINALIZE_DIMS_MTH,
    GEN_FCN_REGISTER_DATA_MIN_MAX_PRM_INDICES,
    GEN_FCN_CHECK_DWORK_RANGE,
    GEN_FCN_ACCEL_CALL_SET_DIMS,
    GEN_FCN_GET_STATEFLOW_SUBCHART_SIMSTRUCT,
    GEN_FCN_GET_STATEFLOW_SUBCHART_SYS_INST_INDICES,
    GEN_FCN_GET_DATATYPE_CHECKSUM,
    GEN_FCN_REG_CODE_VARIANT_FCNCALL,
    GEN_FCN_EVAL_CODE_VARIANT_FCNCALL,
    GEN_FCN_CHECK_STRUCTPARAM_CHECKSUM,
    GEN_FCN_GET_PARAM_DATATYPE,
    GEN_FCN_GET_SIMULATIONTYPE,
    GEN_FCN_GET_NET_SLOPE_VIA_DIVISION,
    GEN_FCN_SET_MODELREF_ALLOW_IN_STATE_ENABLED_SS,
    GEN_FCN_CHK_MODELREF_OPTIM_SETTINGS,
    GEN_FCN_GET_IS_INPORT_ELEMENT_CONTINUOUS,
    GEN_FCN_SET_IS_INPORT_USEDFOR_CONT_ZC,
    GEN_FCN_CREATE_AND_ADD_ZCSIGNAL_INFO,
    GEN_FCN_SET_ZCSIGNAL_NAME,
    GEN_FCN_GET_ZCSIGNAL_NAME,
    GEN_FCN_SET_ZCSIGNAL_WIDTH,
    GEN_FCN_GET_ZCSIGNAL_WIDTH,
    GEN_FCN_SET_ZCSIGNAL_ZCEVENT_TYPE,
    GEN_FCN_GET_ZCSIGNAL_ZCEVENT_TYPE,
    GEN_FCN_SET_ZCSIGNAL_TYPE,
    GEN_FCN_GET_ZCSIGNAL_TYPE,
    GEN_FCN_SET_ZCSIGNAL_ZCTOL,
    GEN_FCN_GET_ZCSIGNAL_ZCTOL,
    GEN_FCN_SET_ZCSIGNAL_NEEDS_EVENT_NOTIFICATION,
    GEN_FCN_GET_ZCSIGNAL_NEEDS_EVENT_NOTIFICATION,
    GEN_FCN_GET_NUM_ZCSIGNALS,
    GEN_FCN_GET_ZCSIGNAL_VECTOR,
    GEN_FCN_SET_ZCSIGNAL_ISZCELEMEMT_DISC,
    GEN_FCN_GET_ZCSIGNAL_ISZCELEMEMT_DISC,
    GEN_FCN_CLONE_AND_ADD_ZCSIGNAL_INFO,
    GEN_FCN_DATA_STORE_LOG_UPDATE,
    GEN_FCN_SET_STATES_MODIFIED_ONLY_IN_UPDATE,
    GEN_FCN_SUP_MULTI_EXEC_INSTANCES,
    GEN_FCN_REQUEST_IIS_NUM_ITER_DWORK,
    GEN_FCN_GET_STATEFLOW_RTWCONTEXT,
    GEN_FCN_GET_NUM_FCNCALL_DEST,
    GEN_FCN_GET_NUM_VARIANT_CONDITIONS,
    GEN_FCN_MODELREF_SET_TRIGGER_TYPE,
    GEN_FCN_SET_REQUIRED_STACK_SIZE,
    GEN_FCN_ACCEL_COPY_STATE_CACHE_FOR_IIS,
    GEN_FCN_REG_AUTOSAR_CLIENT_BLOCK,
    GEN_FCN_REG_MODELREF_GLOBAL_VARUSAGE,
    GEN_FCN_SET_MODELREF_STATE_INSIDE_FOREACH,
    GEN_FCN_CALL_DEFAULT_JACOBIAN,
    GEN_FCN_CONFIG_DEFAULT_JACOBIAN,
    GEN_FCN_SET_DATA_MIN_MAX_VALUES,
    GEN_FCN_LOGGER_CREATE_DATASET_DESCRIPT,
    GEN_FCN_LOGGER_ADD_ELEMENT_DESCRIPT,
    GEN_FCN_LOGGER_ADD_TIMESERIES_DESCRIPT,
    GEN_FCN_LOGGER_CREATE_DATASET_FROM_DESCRIPT,
    GEN_FCN_LOGGER_ADD_ELEMENT_PROP,
    GEN_FCN_LOGGER_UPDATE_LOGVAR,
    GEN_FCN_SET_HAS_PAR_FOREACH_SS,
    GEN_FCN_GET_DATATYPEOVERRIDEAPPLIESTO,
    GEN_FCN_READ_FROM_DATA_STORE_REGION,
    GEN_FCN_WRITE_TO_DATA_STORE_REGION,
    GEN_FCN_UPDATE_DATA_STORE_DIAGNOSTICS,
    GEN_FCN_GET_DATA_STORE_DIAGNOSTICS_STATUS,
    GEN_FCN_CREATE_MEM_REGION_DESC,
    GEN_FCN_SET_FLAT_MEM_SUB_REGION_DESC,
    GEN_FCN_DESTROY_MEM_REGION_DESC,
    GEN_FCN_GET_ZC_CONTROL_DISABLED,
    GEN_FCN_LOGGER_CREATE_VALUES_DESCIPT,
    GEN_FCN_LOGGER_SUPPORTS_SIGNAL_LOGGING,
    GEN_FCN_SET_ACCEPTS_FCNCALL_INPUTS,
    GEN_FCN_MODELREF_INIT_DATA_PORT_GROUP,
    GEN_FCN_MODELREF_PORT_GROUP_ADD_DATA_INPUT_PORT,
    GEN_FCN_MODELREF_PORT_GROUP_ADD_DATA_OUTPUT_PORT,
    GEN_FCN_MODELREF_PORT_GROUP_ADD_SRC_PORT_GROUP,
    GEN_FCN_MODELREF_INIT_NEW_FCNCALL_PORT_GROUP,
    GEN_FCN_MODELREF_FCNCALL_PORT_GROUP_SET_FCNCALL_INPUT,
    GEN_FCN_MODELREF_FCNCALL_PORT_GROUP_ADD_LATCHED_INPUT,
    GEN_FCN_MODELREF_FCNCALL_PORT_GROUP_SET_ASYNC_PRIORITY,
    GEN_FCN_MODELREF_FCNCALL_PORT_GROUP_SET_ASYNC_TID,
    GEN_FCN_GET_REG_SUBMODELS_MDLINFO,
    GEN_FCN_MODELREF_FCNCALL_PORT_GROUP_SET_HAS_ENABLE,
    GEN_FCN_MODELREF_FCNCALL_PORT_GROUP_SET_HAS_DISABLE,
    GEN_FCN_GET_BLK_SUPPORT_CONCURRENT_TASKS,
    GEN_FCN_SET_BLK_SUPPORT_CONCURRENT_TASKS,
    GEN_FCN_CHK_MODELREF_CONCURRETNT_TASK_SUPPORT,
    GEN_FCN_ACCEL_CALL_MODEL_FCNCALL_INPUT,
    GEN_FCN_MDLREF_SIGNAL_LOGGING_SAVE_FORMAT,
    GEN_FCN_REG_MODELREF_CONSTANT_VALUED_OUTPUT_CHECKSUM,
    GEN_FCN_MODELREF_FCNCALL_PORT_GROUP_SET_HAS_ASYNC_PRIORITY,
    GEN_FCN_MODELREF_FCNCALL_PORT_GROUP_SET_NEED_ABS_TIME,
    GEN_FCN_SET_HAS_VARIANT_MODEL_OR_SS,
    GEN_FCN_MODELREF_FCNCALL_PORT_GROUP_ADD_DATAINPUT_WITH_MULTIDSTS,
    GEN_FCN_MODELREF_HAS_ENABLE_PORT,
    GEN_FCN_SET_INPUT_PORT_IS_MESSAGE,
    GEN_FCN_SET_OUTPUT_PORT_IS_MESSAGE,
    GEN_FCN_SEND_MESSAGE,
    GEN_FCN_RECEIVE_MESSAGE,
    GEN_FCN_CHK_MESSAGE_INPUT,
    GEN_FCN_NO_MESSAGE_ON_INPUTS,
    GEN_FCN_CHK_MESSAGE_OUTPUT,
    GEN_FCN_CHK_MODELREF_FRAME_UPGRADE_DIAGNOSTICS,
    GEN_FCN_MODELREF_RATE_GROUPED,
    GEN_FCN_GET_SIZE_OF_PARAMS,
    GEN_FCN_MODELREF_REQUIRE_RESET_FOR_VARSIZE,
    GEN_FCN_MODELREF_FCNCALL_PORT_GROUP_SET_IS_ASYNC,
    GEN_FCN_MODELREF_MAKE_ROOT_OUTPORT_FCNCALL_OUTPUT,
    GEN_FCN_MODELREF_MAKE_ROOT_OUTPORT_FCNCALL_ENABLE,
    GEN_FCN_MODELREF_MAKE_ROOT_OUTPORT_FCNCALL_DISABLE,
    GEN_FCN_MULTI_INS_NO_SUPPORT_MESSAGE,
    GEN_FCN_MODELREF_REGISTER_SIM_FCN_CALL_OUTPUT,
    GEN_FCN_GET_STRICT_SINGLE,
    GEN_FCN_MODELREF_INPUT_ADD_FCNCALL_IN_ARG,
    GEN_FCN_MODELREF_INPUT_ADD_FCNCALL_OUT_ARG,
    GEN_FCN_MODELREF_INPUT_ADD_FCNCALL_STATUS_ARG,
    GEN_FCN_MODELREF_OUTPUT_ADD_FCNCALL_IN_ARG,
    GEN_FCN_MODELREF_OUTPUT_ADD_FCNCALL_OUT_ARG,
    GEN_FCN_MODELREF_OUTPUT_ADD_FCNCALL_STATUS_ARG,
    GEN_FCN_MODELREF_REGISTER_SIM_TARGET_FCN_CALL_METHOD,
    GEN_FCN_MODELREF_REGISTER_SIMULINK_ACCELERATOR_FCN_CALL_METHOD,
    GEN_FCN_SET_VARIABLE_SAMPLE_TIME_UID,
    GEN_FCN_SET_VARTS_MDLREF_SUPPORT,
    GEN_FCN_IS_SF_OUTPUT_DRIVING_COND_SUBSYS,
    GEN_FCN_FILE_LOGGING_MANAGER_ADD_ELEMENT,
    GEN_FCN_FILE_LOGGING_MANAGER_REMOVE_ELEMENT,
    GEN_FCN_SET_MODELREF_IS_EXPORTFCN_DIAGRAM,
    GEN_FCN_SET_OUTPUT_PORT_ISMSG,
    GEN_FCN_SET_INPUT_PORT_ISMSG,
    GEN_FCN_SET_INPUT_PORT_MSGQ_LEN,
    GEN_FCN_SET_INPUT_PORT_MSGQ_POLICY,
    GEN_FCN_SEND_MSG,
    GEN_FCN_NUM_RX_MSGS,
    GEN_FCN_POP_MSG,
    GEN_FCN_PEEK_MSG,
    GEN_FCN_RELEASE_MSG,
    GEN_FCN_CHK_MODELREF_DATA_DICTIONARY,
    GEN_FCN_REGISTER_STATEFLOW_AUTO_ENUM_INFO,
    GEN_FCN_MODELREF_SET_NUM_ASYNC_TS,
    GEN_FCN_MODELREF_SET_UNION_TS_CONTAINED_TS,
    GEN_FCN_SET_RUN_TIME_PARAM_ACCESSED_BY_ADDRESS
} GenFcnType;

#if SS_SL_INTERNAL || SS_SFCN_FOR_SIM
  /* following return 1 on success and 0 on failure */
  typedef int_T (*_WriteRTWStrFcn)(              void         *writeRTWFcnArg,
                                                 const char_T *str);

  typedef int_T (*_WriteRTWNameValuePairFcn)(    void         *writeRTWFcnArg,
                                                 int_T        type,
                                                 const char_T *name,
                                                 const void   *value,
                                                 DTypeId      dataTypeId,
                                                 int_T        nRows,
                                                 int_T        nCols);

  typedef int_T (*_WriteRTWParameterFcn)(        void         *writeRTWFcnArg,
                                                 int_T        type,
                                                 const char_T *name,
                                                 const char_T *str,
                                                 const void   *value,
                                                 DTypeId      dataTypeId,
                                                 int_T        nRows,
                                                 int_T        nCols);

  typedef void  (*_AccelRunBlockFcn)(            SimStruct *S,
                                                 int sysidx,
                                                 int blkidx,
                                                 int enumFunction);

  typedef int_T  (*_GenericFcn)     (            SimStruct  *S,
                                                 GenFcnType type,
                                                 int_T      arg1,
                                                 void       *arg2);
#endif

#if SS_SL_INTERNAL || SS_SFCN_FOR_SIM
  /*
   * The following return error string on failure, NULL on success.
   * See <matlabroot>/simulink/src/barplot.c for an example of using
   * these functions.
   */

  /*
   * Returns an array of output port pointers corresponding to the selected
   * signals in the window that the s-function block resides (i.e., the signals
   * whose lines have selection handles).  There are two options that can
   * be passed to this function (sigSetOpt):
   *    SIGSET_GRAPH: return only the selected signals in the window in
   *                  which the s-function resides.
   *    SIGSET_GRAPH_N_CHILDREN: return selected signals in the window in
   *                             which the s-function resides and all
   *                             children windows.
   */
  typedef const char *(*SelectedSignalsFcn)(
      const void      *voidBlock,
      const int       sigSetOpt,
      void            ***voidOutPortObjs,   /* the ports           */
      int             *outnPortObjs);       /* the number of ports */

  /*
   * Given an array of output ports, create a signal list so that the signal
   * data may be accessed (also see sigmapdef.h).  Return an error string on
   * failure or NULL on success.
   */
  typedef const char *(*SigListCreateFcn)(
      const void         *voidBlock,
      const int          nPorts,
      void               **voidPortObjs,
      const unsigned int excludeFlags,
      void               **voidOutSigList);

  /*
   * Destroy a signal list.
   */
  typedef void (*SigListDestroyFcn)(void *voidSigList);

  /*
   * Access into Simulink memory manager's free function.  Used to destroy
   * objects that were created by calling into Simulink (e.g., ssCall..).  This
   * function is accessed via the ssCallGenericDestroyFcn macro.
   */
  typedef void (*utFreeFcn)(void *ptr);

  /*
   * Given a pointer to a port, return it's name (signal label).
   */
  typedef const char *(*GetPortNameFcn)(void *voidPortObj);

  /*
   * Given a signal list, detect and alert users to any signals that
   * are not available for viewing.
   */
  typedef void (*SigListUnavailSigAlertFcn)(void *voidSigList);

  /*
   * Given a port, unselect it's line.
   */
  typedef void (*UnselectSigFcn)(void *voidPortObj);

  /*
   * Given a SigList return ....
   */

  /* number of regions comprising the 'listIdx-th' signal in the list */
  typedef int (*SigListGetNumRegionsFcn)(void *voidSigList, int idx);

  /* a pointer to the first region of the 'listIdx-th'signal in the list */
  typedef void* (*SigListGetFirstRegFcn)(void *voidSigList, int idx);

  /* the total num of elements comprising the 'listIdx-th' signal in the list */
  typedef int (*SigListGetNumElementsFcn)(void *voidSigList, int idx);

  /* true if the signal is a tie wrap (see sigmapdef.h) */
  typedef int (*SigListGetIfTieWrapFcn)(void *voidSigList, int idx);

typedef struct _SignalAccess_tag {
    SelectedSignalsFcn        SelectedSignals;
    SigListCreateFcn          SigListCreate;
    SigListDestroyFcn         SigListDestroy;
    SigListUnavailSigAlertFcn SigListUnavailSigAlert;

    SigListGetNumRegionsFcn   SigListGetNumRegions;
    SigListGetFirstRegFcn     SigListGetFirstReg;
    SigListGetNumElementsFcn  SigListGetNumElements;
    SigListGetIfTieWrapFcn    SigListGetIfTieWrap;

    utFreeFcn utFree;

    GetPortNameFcn GetPortName;
    UnselectSigFcn UnselectSig;
} SignalAccess;
#endif

/*
 * Call into the s-functions external mode fcn - if it exists.  Returns
 * error string on failure, NULL on success.
 */
typedef const char *(*SFunExtModeFcn)(SimStruct *S, const ExtModeLogBlockMeth);

/*
 * Non-continuous (sample time != 0) signals driving derivative ports
 * (e.g. integrand input port of an integrator block) need to be tracked
 * in order to determine when to reset variable step solvers.
 */
typedef struct {
    int   sizeInBytes;
    char  *pCurrVal;
    char  *pPrevVal;
} ssNonContDerivSigInfo;

#if defined(RTW_GENERATED_S_FUNCTION) || SS_SL_INTERNAL
typedef struct ssNonContDerivSigFeedingOutports_tag {
    int sizeInBytes;
    char *currVal;
    struct ssNonContDerivSigFeedingOutports_tag *next;
} ssNonContDerivSigFeedingOutports;
#endif

/*
 * The _ssMdlInfo structure is "valid" in the root SimStruct only.  All child
 * SimStruct's point to the root SimStruct mdlInfo field.  Care must be taken
 * to use the correct mapping of tid's when accessing some of mdlInfo fields
 * (e.g. t, sample hits, sample times, etc). from child SimStruct's (use macros
 * below).
 */

struct _ssMdlInfo {
  SS_SimMode  simMode;         /* This field indicates
                                  whether or not we are running a simulation
                                  or generating the model.rtw file */

  time_T      *t;              /* The current time for each task. This is
                                  of dimension sizes.numSampleTimes         */

  int_T       *sampleHits;     /* sample hits - does tid have a hit?  This is
                                  of dimension sizes.numSampleTimes         */

  time_T      tStart;          /* Model execution start time                 */
  time_T      tFinal;          /* Final model execution stop time            */
  time_T      timeOfLastOutput;/* Time of last model "output"                */

  time_T      minStepSize;     /* variable step-size is always >= minStepSize */

  void        *timingData;     /* Data used by execution or simulation engine*/

  SimTimeStep simTimeStep;     /* Simulation time step "mode"                */

  int_T       stopRequested;   /* True if a "stop" has been requested        */
  int_T       logOutput;       /* Log output?                                */

  time_T      *outputTimes;    /* Times at which to log data                 */
  uint_T      outputTimesIndex;/* Where we are in the OutputTimes vector     */
  uint_T      numOutputTimes;  /* Length of OutputTimes                      */
  int_T       outputTimesOnly; /* Save [t,x,y] & continuous blocks at
                                  specified times only?                      */

  int_T       obsoletedNeedOutputAtTPlusTol;

  const char_T *solverName;    /* Name of solver/integration algorithm       */
  int_T       variableStepSolver;/* true=variable or false=fixed step solver */
  void        *solverData;     /* Work area for solver                       */
  time_T      solverStopTime;  /* Solver stop time                           */
  time_T      stepSize;        /* The integration step size                  */
  int_T       solverNeedsReset;/* Do we need to reset the integrator?        */
  struct {
      unsigned int zcCacheNeedsReset    : 1; /* recompute zc value left?     */
      unsigned int derivCacheNeedsReset : 1; /* recompute derivatives?       */
      unsigned int blkStateChange       : 1; /* did blk state change?        */
      unsigned int reserved_1           : 1; /* was skip intg phase (<=R12)  */
      unsigned int forceSfcnExceptionHandling : 1; /* add exception handling *
                                                    *for all S-function calls*/
      unsigned int inlineParameters   :1; /* is inline parameters selected
                                           * for the model?       */
      unsigned int solverAssertCheck    :1; /* true if consistency checking
                                               is enabled and active        */
      unsigned int minStepViolatedError :1; /* what to do if the solver step
                                             * size is less than the min step
                                             * size: 0 => warn 1 => error */
      unsigned int reservedone          :1; /* was to do for consecutive zc
                                             * error/warning
                                             * 0 => warn 1         => error */
      unsigned int noZCStateUpdate      :1; /* set when blocks shouldn't    */
                                            /* previous zc state due to     */
                                            /* algebraic loop solving, etc. */
      unsigned int computingJacobian  :1;   /* 1 when computing Jacobian    */
                                            /* for use in ODE solver        */
      unsigned int solverCheckingCIC  :1;   /* 1 -- ODE solver checks if it */
                                            /* has consistent initial conds */
                                            /*  |M*xdot - f| is 'small'     */
      unsigned int errorStatusIsMsg     : 1; /* 1 SimStruct_tag errorStatus is
                                              * void*,
                                              * otherwise is const char*    */
      unsigned int timeTweakWarn         :1; /* whether to warn when time is tweaked*/
      unsigned int solverRequestingReset :1; /* e.g, step ended at discontinuity */
      unsigned int firstInitCondCalled   :1; /* initCond Has been called at least once  */
      unsigned int sparseSlvrJacobian    :1;
      unsigned int frameUpgradeWarn      :1;
      unsigned int outputMethodComputed  :1;
      unsigned int reserved15           :13; /* remainder are reserved      */
  } mdlFlags;
  int_T       maxNumMinSteps;  /* Max number of steps taken at minimum       */
  int_T       solverRefineFactor;   /* state & output refinement factor      */
  real_T      solverRelTol;    /* Integration relative tolerance             */
    real_T      *solverAbsTol_Obsolete; /* OBSOLETE: abs tol for each continuous state */

  time_T      maxStepSize;     /* variable StepSize is always <= MaxStepSize */
  int_T       solverMaxOrder;  /* Maximum order for ode15s                   */
  time_T      fixedStepSize;   /* Step size for fixed-step integrators       */

  int_T                  numNonContDerivSigInfos;
  ssNonContDerivSigInfo* nonContDerivSigInfos;
  uint8_T*             solverAbsTolControl_Obsolete; /* Solver abs tol control
                                                      * Obsoleted */
  rtTimingBridge*   timingBridge;

  RTWLogInfo        *rtwLogInfo; /* Logging data structure for RTW         */
  ssSolverInfo      *solverInfo; /* Solver information */

  void              *unused[2];
  void              *mexApiVoidPtr1; /* reserved for use by Simulink mex api */

  int_T solverExtrapolationOrder; /* Extrapolation order for ODE14x          */
  int_T solverNumberNewtonIterations; /* Number of iterations for ODE14x     */

  /*
   * External mode object
   */
  RTWExtModeInfo *extModeInfo;

  /* Base addresses of Block Outputs vector for the whole model   */

  void              *blockIO;      /* block inputs/outputs                   */

  int               *blockIOVarDims; /* block I/O variable dims */

  /* Parameter vectors for use with Real-Time Workshop */

  real_T *defaultParam;       /* Default parameter vector.                   */
                              /* Note: DefaultParam points to global storage;
                               *  common to all instances of this model.
                               *  Used only by Accelerator to point to model
                               *  wide info.
                               */
  const void   *mappingInfo;  /* Used by RTW for providing external access
                                 to the parameters, block I/O, etc vectors   */


#if SS_SL_INTERNAL || SS_SFCN_FOR_SIM
  /*
   * Function pointers used in mdlRTW which write fields in the model.rtw file.
   */
    _WriteRTWStrFcn             writeRTWStrFcn;
    _WriteRTWNameValuePairFcn   writeRTWNameValuePairFcn;
    _WriteRTWParameterFcn       writeRTWParameterFcn;

    void                        *writeRTWFcnArg;

    _AccelRunBlockFcn           accelRunBlock;
    void                        *bdRefPtr;

    _GenericFcn                 genericFcn;

    void                        *reservedForFutureMLFcns[1];
    void                        *reservedForFutureMLArgs[4];
#endif

  int_T   mexApiInt2;                    /* for use by Simulink mex api */
  char_T  reservedString[32];            /* IMPORTANT:
                                            Keep it fixed at 32 characters
                                            as it is needed for backward
                                            compatibility */


   _ssSetInputPortDimensionInfoFcn    regInputPortDimsInfo;
   _ssSetOutputPortDimensionInfoFcn   regOutputPortDimsInfo;

#if SS_SL_INTERNAL || SS_SFCN_FOR_SIM
  SignalAccess       *signalAccess;
  slDataTypeAccess   *dataTypeAccess;
  void               *reservedForFutureVoid[2];
#endif

  void *reservedForXPC;

# if SS_MULTITASKING || SS_SL_INTERNAL || SS_SFCN_FOR_SIM
  int_T       *perTaskSampleHits; /* Matrix of dimension number of sample times
                                     by number of sample times giving sample
                                     hits as viewed in each task. Used by
                                     ssIsSpecialSampleHit within MEX files. */
# endif

  SolverMode   solverMode;          /* Simulation solver mode */
  RTWGenMode   rtwgenMode;
  int_T        reservedForFutureInt[2];

  real_T       mexApiReal1;         /* reserved for use by Simulink mex api */
  real_T       mexApiReal2;         /* reserved for use by Simulink mex api */

  real_T*     timeOfNextSampleHit;
  real_T     *varNextHitTimesList;
  boolean_T  *tNextWasAdjusted;
  real_T     *reservedDoubleVect[1];


}; /* end struct _ssMdlInfo */


/* returns 1 on success and 0 on failure */
typedef ssFcnCallErr_T (*SysOutputFcn) (void *, int_T, int_T);

#define SS_FCNCALL_NO_ERR ((ssFcnCallErr_T)1)
#define SS_FCNCALL_ERR    ((ssFcnCallErr_T)0)

struct _ssCallSys {
  int_T                *outputs; /* Which output elements call a system    */
  void                 **args1;  /* 1st Argument(s) for system output fcn  */
  int_T                *args2;   /* 2nd Argument(s) for system output fcn  */
  SysOutputFcn         *fcns;    /* System output functions                */
};


/*------------------------ (S)->states.modelMethods2->resolveCBK ------------*/

/* callback function support type        *
 * returns 1 on success and 0 on failure */
typedef int_T (*_ResolveVarFcn)( const SimStruct *S,
				 const char *,
				 mxArray **);

/* callback structure */
struct _ssResolveCBK {
  _ResolveVarFcn       Resolver; /* Resolver function                */
  void 		       *_slBlock; /* Block context for resolver fcn   */
};


/* callback access methods */
# define ssGetResolveMLVarCallbackStruct(S) \
          ((ssGetModelMethods2(S))->resolveCBK)
# define ssSetResolveMLVarCallbackFcn(S,val) \
          (ssGetResolveMLVarCallbackStruct(S)).Resolver = (val)
# define ssSetResolveMLVarCallbackContext(S,val) \
          (ssGetResolveMLVarCallbackStruct(S))._slBlock = (val)
# define ssResolveMLVarWithCallback(S,Var,mat) \
           (((ssGetResolveMLVarCallbackStruct(S)).Resolver != NULL) ? \
           (*(ssGetResolveMLVarCallbackStruct(S)).Resolver)(S, Var, mat) : \
           (1))

/*---------------------------------------------------------------------------*/

typedef DTypeId         (*OldRegisterDataType)(void *, const char_T *);
typedef int_T           (*SetDataTypeSize) (void *, DTypeId, int_T );
typedef int_T           (*GetDataTypeSize) (void *, DTypeId);
typedef int_T           (*SetDataTypeZero) (void *, DTypeId, void *);
typedef const void *    (*GetDataTypeZero) (void *, DTypeId);
typedef const char_T *  (*GetDataTypeName) (void *, DTypeId);
typedef int_T           (*SetNumDWork)     (SimStruct *, int_T);


struct _ssRegDataType {
    void                *arg1;          /* 1st Argument for Register Data Type  */
    OldRegisterDataType registerFcn;    /* Register Data Type Function          */
    SetDataTypeSize     setSizeFcn;     /* Set Data Type Size Function          */
    GetDataTypeSize     getSizeFcn;     /* Get Data Type Size Function          */

    SetDataTypeZero     setZeroFcn;     /* Set Data Type Zero representation    */
    GetDataTypeZero     getZeroFcn;     /* Get Data Type Zero representation    */

    GetDataTypeName     getNameFcn;     /* Get Data Type Name Function          */
    GetDataTypeId       getIdFcn;       /* Get Data Type Id   Function          */

    SetNumDWork         setNumDWorkFcn; /* Set num data type work vector        */
};

/* Access the model's boolean data type enabled flag */
typedef boolean_T      (*StrictBooleanCheckEnabled) (void *);

/*
 * Access to Simulink's data type conversion function.
 */
typedef boolean_T (*ConvertBuiltInDTypeFcn)(
    int        nVals,            /* num vals to convert (*2 if complex)       */
    boolean_T  satOnIntOverFlow, /* sat on overflow?                          */
    boolean_T  doDiff,           /* check for loss of info during conversion? */
    const int  dt1,              /* original data type                        */
    const void *v1,              /* vals to convert                           */
    const int  dt2,              /* destination data type                     */
    void       *v2);             /* out: the converted values                 */


struct _ssStInfo {
  time_T    *sampleTimes;       /* Sampling periods in seconds               */
  time_T    *offsetTimes;       /* Task delay for discrete systems
                                   (0 <= OffsetTime < SampleTime)            */
  time_T    tNext;              /* Time of next hit for M,MEX S-functions    */
  int_T     tNextTid;           /* For M,MEX S-fcns, negative if not present */
  int_T     *sampleTimeTaskIDs; /* Maps local sample time index to the
                                   root SimStruct task ID (root sti)         */
};



/*
 * Level 2 S-function methods:
 *
 * [mdlInitializePropagationPassFcn] - Optional routine. Perform any
 *                                 necessary initialization before the
 *                                 specified propagation pass begins.
 *=> mdlInitializeSizes         -  Initialize SimStruct sizes array
 *   [mdlSetInputPortWidth]     -  Optional routine. Check and set input and
 *                                 optionally other port widths.  Can
 *                                 only be in a C MEX S-function.
 *   [mdlSetOutputPortWidth]    -  Optional routine. Check and set output
 *                                 and optionally other port widths. Can
 *                                 only be in a C MEX S-function.
 *   [mdlSetInputPortFrameData] -  Optional routine. Check and set input and
 *                                 optionally other frame data.  Can
 *                                 only be in a C MEX S-function.
 *=> mdlInitializeSampleTimes   -  Initialize sample times.
 *   [mdlSetWorkWidths]         -  Optional routine. Set the state, iwork,
 *                                 rwork, pwork, etc sizes. Can only be in a
 *                                 C MEX S-function.
 *
 *   [mdlRTW]                   -  Optional routine.  Only called when
 *                                 generating code to add information to the
 *                                 model.rtw file which is used by the
 *                                 Real-Time Workshop.
 *
 *   <<End mdl function calls when generating code by the Real-Time Workshop>>
 *
 *   [mdlInitializeConditions]  -  Initialize model parameters (usually
 *                                 states). Will not be called if your
 *                                 S-function does not have an initialize
 *                                 conditions routine.
 *   [mdlStart]                 -  Optional routine. Perform actions such
 *                                 as allocating memory and attaching to pwork
 *                                 elements.  Can only be in a C MEX
 *                                 S-function.
 *   [mdlCheckParameters]       -  Optional routine. Will be called at
 *                                 any time during the simulation loop when
 *                                 parameters change. Can only be used in a
 *                                 C MEX S-function.
 *   [mdlExtModeExec]           -  Optional routine. Will be called during
 *                                 external mode simulation loop to run the
 *                                 C Mex S-function block.
 *   SimulationLoop:
 *        [mdlProcessParameters]   -  Optional routine. Called during
 *                                    simulation after parameters have been
 *                                    changed and verified to be okay by
 *                                    mdlCheckParameters. The processing is
 *                                    done at the "top" of the simulation loop
 *                                    when it is safe to process the changed
 *                                    parameters. Can only be used in a C MEX
 *                                    S-function.
 *        [mdlGetTimeOfNextVarHit] -  Optional routine. If your S-function
 *                                    has a variable step sample time, then
 *                                    this routine will be called.
 *        [mdlInitializeConditions] -  Optional routine. Only called if your
 *                                    S-function resides in an enabled
 *                                    subsystem configured to reset states,
 *                                    and the subsystem has just enabled.
 *     => mdlOutputs               -  Major output call (usually updates
 *                                    output signals).
 *        [mdlUpdate]              -  Update the discrete states, etc.
 *        [mdlDerivatives]         -  Compute the derivatives.
 *   EndLoop
 *   mdlTerminate               -  End of model housekeeping - free memory,
 *                                 etc.
 */

typedef void (*mdlInitializeSizesFcn)(SimStruct *S);

typedef void (*mdlInitializePropagationPassFcn)(SimStruct *S, PropagationPassType passType);

typedef void (*mdlSetInputPortWidthFcn)(SimStruct *S, int_T portIdx,
                                        int_T width);
typedef void (*mdlSetOutputPortWidthFcn)(SimStruct *S, int_T portIdx,
                                         int_T width);

typedef int_T (*mdlGetInputPortWidthLevel1Fcn)(SimStruct *S,
                                               int_T outputWidth);
typedef int_T (*mdlGetOutputPortWidthLevel1Fcn)(SimStruct *S,
                                                int_T inputWidth);

typedef void (*mdlSetInputPortDimensionsFcn)(SimStruct        *S,
                                             int_T            portIdx,
                                             const DimsInfo_T *dimsInfo);

typedef void (*mdlSetOutputPortDimensionsFcn)(SimStruct        *S,
                                              int_T            portIdx,
                                              const DimsInfo_T *dimsInfo);

typedef void (*mdlSetDefaultPortDimensionsFcn)(SimStruct *S);

typedef void  (*mdlSetInputPortDataTypeFcn)(SimStruct *S,
                                            int_T     portIdx,
                                            DTypeId   inputPortDataType);
typedef void  (*mdlSetOutputPortDataTypeFcn)(SimStruct *S,
                                             int_T     portIdx,
                                             DTypeId   outputPortDataType);
typedef void (*mdlSetDefaultPortDataTypesFcn)(SimStruct *S);

typedef void  (*mdlSetInputPortComplexSignalFcn)(SimStruct *S,
                                                 int_T      portIdx,
                                                 CSignal_T  iPortComplexSignal);
typedef void  (*mdlSetOutputPortComplexSignalFcn)(SimStruct *S,
                                                  int_T      portIdx,
                                                  CSignal_T oPortComplexSignal);
typedef void (*mdlSetDefaultPortComplexSignalsFcn)(SimStruct *S);

typedef void (*mdlSetInputPortFrameDataFcn)(SimStruct *S,
                                            int_T     portIdx,
                                            Frame_T   iPortFrameData);

typedef void  (*RTWGeneratedEnableFcn)(SimStruct *S);
typedef void  (*RTWGeneratedDisableFcn)(SimStruct *S);

typedef void  (*mdlEnableFcn)(SimStruct *S);
typedef void  (*mdlDisableFcn)(SimStruct *S);

typedef void (*mdlInitializeSampleTimesFcn)(SimStruct *S);

typedef void (*mdlSetInputPortSampleTimeFcn)(SimStruct *S,
                                             int       portIdx,
                                             real_T    sampleTime,
                                             real_T    offsetTime);
typedef void (*mdlSetOutputPortSampleTimeFcn)(SimStruct *S,
                                              int       portIdx,
                                              real_T    sampleTime,
                                              real_T    offsetTime);
typedef void  (*mdlSetWorkWidthsFcn)(SimStruct *S);
typedef void  (*mdlRTWFcn)(SimStruct *S);

typedef void (*mdlInitializeConditionsFcn)(SimStruct *S);
typedef void (*mdlInitializeConditionsLevel1Fcn)(real_T *x0, SimStruct *S);

typedef void (*mdlStartFcn)(SimStruct *S);

typedef void (*mdlInitSystemMatricesFcn)(SimStruct *S);

typedef void  (*mdlCheckParametersFcn)(SimStruct *S);
typedef void (*mdlProcessParametersFcn)(SimStruct *S);

typedef void (*mdlExtModeExecFcn)(SimStruct *S);

typedef void (*mdlGetTimeOfNextVarHitFcn)(SimStruct *S);

typedef void (*mdlOutputsFcn)(SimStruct *S, int_T tid);
typedef void (*mdlOutputsLevel1Fcn)(real_T *y, const real_T *x,
                                    const real_T *u,
                                    SimStruct *S, int_T tid);

typedef void (*mdlUpdateFcn)(SimStruct *S, int_T tid);
typedef void (*mdlUpdateLevel1Fcn)(real_T *x, const real_T *u, SimStruct *S,
                                   int_T tid);

typedef void (*mdlDerivativesFcn)(SimStruct *S);
typedef void (*mdlDerivativesLevel1Fcn)(real_T *dx, const real_T *x,
                                        const real_T *u,
                                        SimStruct *S, int_T tid);

typedef void (*mdlJacobianFcn)(SimStruct *S);
typedef void (*mdlJacobianIrJcFcn)(SimStruct *S);

typedef void (*mdlProjectionFcn)(SimStruct *S);

typedef void RTWCGInterface;

typedef void (*mdlRTWCGFcn)(SimStruct *S, RTWCGInterface *iObj);

typedef void (*mdlZeroCrossingsFcn)(SimStruct *S);

typedef void (*mdlTerminateFcn)(SimStruct *S);

typedef void (*mdlMassMatrixFcn)(SimStruct *S);

struct _ssMassMatrixInfo {
    ssMatrixType        type;           /* SS_MATRIX_***, ...                  */
    ssSparseMatrixInfo  info;           /* Ir,Jc,Pr, etc.                      */
};

typedef void (*mdlForcingFunctionFcn)(SimStruct *S);

typedef void (*mdlConstraintsFcn)(SimStruct *S);

struct _ssConstraintsInfo {
    int_T              numConstraints;  /* length of the constraints vector    */
    real_T             *constraints;    /* constraints vector                  */
    mdlConstraintsFcn  mdlConstraints;  /* function evaluating the constraints */
};

typedef void (*mdlSimStatusChangeFcn)(SimStruct *S, ssSimStatusChangeType  mEvent);

struct _ssSFcnModelMethods {

    mdlInitializeSizesFcn               mdlInitializeSizes;

    mdlGetInputPortWidthLevel1Fcn       mdlGetInputPortWidthLevel1;
    mdlGetOutputPortWidthLevel1Fcn      mdlGetOutputPortWidthLevel1;

    union {
        mdlSetInputPortWidthFcn             mdlSetInputPortWidth;
        mdlSetInputPortDimensionsFcn        mdlSetInputPortDims;
    } mdlSetInputPortDimensions;

    union{
        mdlSetOutputPortWidthFcn            mdlSetOutputPortWidth;
        mdlSetOutputPortDimensionsFcn       mdlSetOutputPortDims;
    } mdlSetOutputPortDimensions;


    mdlSetInputPortDataTypeFcn          mdlSetInputPortDataType;
    mdlSetOutputPortDataTypeFcn         mdlSetOutputPortDataType;

    mdlInitializeSampleTimesFcn         mdlInitializeSampleTimes;

    mdlSetInputPortSampleTimeFcn        mdlSetInputPortSampleTime;
    mdlSetOutputPortSampleTimeFcn       mdlSetOutputPortSampleTime;
    mdlSetWorkWidthsFcn                 mdlSetWorkWidths;
    mdlRTWFcn                           mdlRTW;

    union {
        mdlInitializeConditionsFcn        level2;
        mdlInitializeConditionsLevel1Fcn  level1;
    } mdlInitializeConditions;

    mdlStartFcn                         mdlStart;
 
    mdlCheckParametersFcn               mdlCheckParameters;
    mdlProcessParametersFcn             mdlProcessParameters;

    mdlGetTimeOfNextVarHitFcn           mdlGetTimeOfNextVarHit;

    union {
        mdlOutputsFcn                     level2;
        mdlOutputsLevel1Fcn               level1;
    } mdlOutputs;

    union {
        mdlUpdateFcn                      level2;
        mdlUpdateLevel1Fcn                level1;
    } mdlUpdate;

    union {
        mdlDerivativesFcn                 level2;
        mdlDerivativesLevel1Fcn           level1;
    } mdlDerivatives;
    mdlZeroCrossingsFcn               mdlZeroCrossings;

    mdlTerminateFcn                     mdlTerminate;

    union {
        mdlSetInputPortComplexSignalFcn   mdlSetInputPortComplexSignal;
        RTWGeneratedEnableFcn             mdlEnable;

    } fcnInEnable;

    union {
        mdlSetOutputPortComplexSignalFcn  mdlSetOutputPortComplexSignal;
        RTWGeneratedDisableFcn            mdlDisable;

    } fcnOutDisable;

}; /* _ssSFcnModelMethods */

#if  SS_SL_INTERNAL || SS_SFCN_FOR_SIM
typedef mxArray* (*mdlGetSimStateFcn)(SimStruct* S);
typedef void (*mdlSetSimStateFcn)(SimStruct* S, const mxArray* in);
#endif

struct _ssSFcnModelMethods3 {

    /* Embedding the structure -- massMatrix.type and *
     * massMatrix.info.nzMax must be always available */
    struct _ssMassMatrixInfo massMatrix;
    mdlInitSystemMatricesFcn mdlInitSystemMatrices;

    int_T numSlvrJacobianNzmax;
    SparseHeader*       slvrJacobianMatrix;
    mdlJacobianIrJcFcn  mdlJacobianIrJc;
    void   *reservedForFuture;
};

struct _ssSFcnModelMethods2 {

    mdlProjectionFcn             mdlProjection;

    mdlJacobianFcn               mdlJacobian;

    mdlSetInputPortFrameDataFcn  mdlSetInputPortFrameData;

    StrictBooleanCheckEnabled    strictBooleanCheckEnabledFcn;

    /* Default dimensions, data types, and complex signals functions */
    mdlSetDefaultPortDimensionsFcn     mdlSetDefaultPortDimensions;
    mdlSetDefaultPortDataTypesFcn      mdlSetDefaultPortDataTypes;
    mdlSetDefaultPortComplexSignalsFcn mdlSetDefaultPortComplexSignals;

    /* Reserved for model methods */
    ConvertBuiltInDTypeFcn ConvertBuiltInDType;

    /* Callback for S-function to resolve a variable from MATLAB workspace *
     *  using hierarchical scoping                                         */
    struct _ssResolveCBK         resolveCBK;

    SFunExtModeFcn extModeLogFcn;

    mdlExtModeExecFcn mdlExtModeExec;

    mdlRTWCGFcn mdlRTWCG;

    mdlMassMatrixFcn    mdlMassMatrix;  /* function evaluating the MassMatrix  */

    void* unused;

    mdlForcingFunctionFcn     mdlForcingFunction;

    mdlEnableFcn              mdlEnable;
    mdlDisableFcn             mdlDisable;
    mdlSimStatusChangeFcn     mdlSimStatusChange;

    mdlInitializePropagationPassFcn mdlInitializePropagationPass;

    struct _ssConstraintsInfo *constraintsInfo;

    struct _ssSFcnModelMethods3 *modelMethods3;
};

/* AlreadyWarned flag for blocks */
#define ssSetAlreadyWarnedFlag(S) \
          (S)->states.flags.alreadyWarned = 1
#define ssGetAlreadyWarnedFlag(S) \
          (S)->states.flags.alreadyWarned

typedef real_T const * const * UPtrsType;

struct _ssStatesInfo2 {
    ZCSigState *prevZCSigState;      /* Used for detecting zc events     */
    real_T     *absTol;   /* abs tol for each continuous state          */
    uint8_T    *absTolControl;
    void *reservedForFutureUse[6]; /* Reserved pointers */
};


struct _ssStates {
    union {
        void       *vect;                 /* not const because of SL1.3 compat*/
        UPtrsType  uPtrs;
    } U;                                  /* Inputs for level 1 S-functions   */

    void            *Y;                   /* Output for level 1 S-functions   */

    real_T          *contStates;          /* Continuous state vector          */
    real_T          *discStates;          /* Discrete state vector            */

    struct {
        unsigned int alreadyWarned:       1;  /* Flag used by a block to
                                               * determine if a warning has
                                               * already been thrown for this
                                               * block */
        /* prevent lint warnings about bit fields greater than 16 bits */
        unsigned int reserved15:         15;
        unsigned int reserved16:         16;
    } flags;

    int_T           reserved2;

    real_T          *dX;                  /* Derivative vector                */
    boolean_T       *contStateDisabled;   /* Entry for each cont state        */
    struct _ssStatesInfo2 *statesInfo2;      /* Auxiliary information about states  */
    real_T          *nonsampledZCs;       /* Non-sampled zero crossing signals */
    ZCDirection     *nonsampledZCDirs;    /* Non-sampled zc directions          */

    SparseHeader    *jacobian;		/* struct containing system Jacobian  */
    struct _ssSFcnModelMethods2 *modelMethods2;
    int_T           reservedSize;
};



/*===========*
 * SimStruct *
 *===========*/

struct SimStruct_tag {

  const char_T           *modelName;  /* Name of the Simulink model/Sfunc    */

  const char_T           *path;       /* Full "Simulink path" to this s-fcn  */

  SimStruct              *parent;     /* Parent SimStruct                    */
  SimStruct              *root;       /* Root level SimStruct                */

  union {
	const char_T* str;                  /* Execution status. Setting to non-NULL
                                         during any mdlFunction will stop the
                                         simulation and the "status" message
                                         will be displayed.                  */
	void*  msg;
  } errorStatus;

  struct _ssSizes        sizes;        /* Sizes (returned when flag==0)      */

  struct _ssPortInfo     portInfo;    /* Input and output port properties
                                         such as width and direct feedthrough
                                         setting.                            */

  struct _ssSFcnParams   sfcnParams;  /* S-function parameters passed in
                                         P1,...,Pn                           */

  struct _ssStates       states;      /* Input, output, state, derivative,
                                         etc. vectors                        */

  struct _ssWork         work;        /* Various work areas (rwork, iwork,
                                         pwork, user data, block I/O,
                                         block params, etc.)                 */

  struct _ssBlkInfo      blkInfo;     /* Information about S-function blocks */

  struct _ssMdlInfo      *mdlInfo;    /* Model-wide info. All children
                                         SimStruct point to root mdlInfo     */

  struct _ssCallSys      callSys;     /* For use when S-function calls a
                                         "function-call" subsystems          */

  struct _ssRegDataType  regDataType; /* For Registering Data type           */

  struct _ssStInfo       stInfo;      /* Sample time, offset time, etc.      */

  struct {
      struct _ssSFcnModelMethods sFcn; /* For S-functions                    */
  } modelMethods;

  struct SimStruct_tag   **sFunctions;/* SimStruct's for S-Functions
                                         referenced via S-Function blocks.
                                         Used only with RT and NRT.          */
};



/*======================================*
 * SimStruct Get and Set Access methods *
 *======================================*/

/*-------------------------------- S->modelName -----------------------------*/

/*
 * ModelName - This is the name of the S-function. When the SimStruct
 *   is being used with the Real-Time Workshop, then the "root" SimStruct
 *   model name corresponds to the name of the Simulink model.
 */
#define ssGetModelName(S) \
          (S)->modelName                                  /* (const char_T*) */
#define _ssSetModelName(S, name) \
          (S)->modelName = (name)
#if !SS_SFCN
#define ssSetModelName(S,name) _ssSetModelName(S,name)
#else
#define ssSetModelName(S,name) ssSetModelName_cannot_be_used_in_SFunctions
#endif

/*-------------------------------- S->path ----------------------------------*/
/*
 * Path - This is the full path to the S-function. When the SimStruct
 *   is being used with the Real-Time Workshop, then the "root" SimStruct
 *   path corresponds to the name of the Simulink model.
 */
#define ssGetPath(S) \
          (S)->path                                       /* (const char_T*) */
#define _ssSetPath(S, pathPtr) \
          (S)->path = (pathPtr)
#if !SS_SFCN
#define ssSetPath(S,pathPtr) _ssSetPath(S,pathPtr)
#else
#define ssSetPath(S,pathPtr) ssSetPath_cannot_be_used_in_SFunctions
#endif

/*-------------------------------- S->parent --------------------------------*/
/*
 * ParentSS - There is one SimStruct for each S-function in your model.
 *   There is also a SimStruct for the model itself. The SimStruct's are
 *   arranged as a tree with the model SimStruct as the root. The ParentSS
 *   field is used to get at the model SimStruct. User written S-functions
 *   should not use the ssGetParentSS macro directly.
 */
#define ssGetParentSS(S) \
          (S)->parent                                     /*   (SimStruct *) */
#define _ssSetParentSS(S,parentSS) \
          (S)->parent = (parentSS)
#if !SS_SFCN
#define ssSetParentSS(S,parentSS) _ssSetParentSS(S,parentSS)
#else
#define ssSetParentSS(S,parentSS) ssSetParentSS_cannot_be_used_in_SFunctions
#endif

/*-------------------------------- S->root ----------------------------------*/
/*
 * RootSS - This is the "root" SimStruct corresponding to the Simulink
 *   model.
 */
#define ssGetRootSS(S) \
          (S)->root                                       /*   (SimStruct *) */
#define _ssSetRootSS(S,rootSS) \
          (S)->root = (rootSS)
#if !SS_SFCN
#define ssSetRootSS(S,rootSS) _ssSetRootSS(S,rootSS)
#else
#define ssSetRootSS(S,rootSS) ssSetRootSS_cannot_be_used_in_SFunctions
#endif


/*-------------------------------- S->errorStatus ---------------------------*/

/* ErrorStatus - For improved performance and error handling, your S-function
 *   should do:
 *      ssSetErrorStatus(S, "error message");
 *      return;
 *   as opposed to calling mexErrMsgTxt.
 *
 *   Be careful when using ssSetErrorStatus in your S-function. Sometimes you
 *   may wish to use sprintf to format the message. In this case, you
 *   need to allocate memory for the message as opposed to using the stack.
 *   macros _ss[SG]et_slErrMsg and _ssIsErrorStatusAslErrMsg
 *   are intended for internal use only
 */

#define ssGetErrorStatus(S) \
          ssGetRootSS(S)->errorStatus.str                  /* (const char_T*) */
#define ssSetErrorStatus(S, string) \
       { ssGetRootSS(S)->mdlInfo->mdlFlags.errorStatusIsMsg = 0U; \
        ssGetRootSS(S)->errorStatus.str = (string); }

#define _ssGetErrorStatus(S) \
       ( ssGetRootSS(S)->mdlInfo->mdlFlags.errorStatusIsMsg == 1U ? \
       NULL : ssGetRootSS(S)->errorStatus.str )
#define _ssGet_slErrMsg(S) \
       ( ssGetRootSS(S)->mdlInfo->mdlFlags.errorStatusIsMsg == 0U ? \
       NULL : ssGetRootSS(S)->errorStatus.msg )
#define _ssSet_slErrMsg(S, msg_arg) \
        { ssGetRootSS(S)->mdlInfo->mdlFlags.errorStatusIsMsg = 1U; \
        ssGetRootSS(S)->errorStatus.msg = (msg_arg); }
#define _ssIsErrorStatusAslErrMsg(S) \
        ( ssGetRootSS(S)->mdlInfo->mdlFlags.errorStatusIsMsg == 1U )

/*-------------------------------- S->sizes ---------------------------------*/

/* SizesPtr - This is an integer pointer of length SIZES_LENGTH. The
 *   fields in the sizes pointers are defined in the _ssSizes structure
 *   (above).
 */
#define ssGetSizesPtr(S) \
          ((int_T *)&(S)->sizes)                          /*   (int_T *)     */

/* NumContStates - This is the number of continuous states within your
 *   S-function. The root SimStruct contains the number of continuous states
 *   within the model itself (including all blocks and S-functions).
 */
#define ssGetNumContStates(S) \
          (S)->sizes.numContStates                        /*   (int_T)       */
#define ssSetNumContStates(S,nContStates) \
          (S)->sizes.numContStates = (nContStates)

/* NumDiscStates - This is the number of discrete states within your
 *   S-function. The root SimStruct contains the number of discrete states
 *   within the model itself (including all blocks and S-functions).
 */
#define ssGetNumDiscStates(S) \
          (S)->sizes.numDiscStates                        /*   (int_T)       */
#define ssSetNumDiscStates(S,nDiscStates) \
          (S)->sizes.numDiscStates = (nDiscStates)

/* NumTotalStates - This is the number of continuous plus discrete states
 *   within your S-function. The root SimStruct contains the number of
 *   continuous plus discrete states within the model itself (including all
 *   blocks and S-functions).
 */
#if SS_SFCN_LEVEL_1 || !SS_SFCN
# define ssGetNumTotalStates(S) \
          (ssGetNumContStates(S) + ssGetNumDiscStates(S)) /*   (int_T)       */
#endif


/* NumOutputPorts - This is the number of the output ports of your
 * S-function block.
 */
#if !SS_SFCN_LEVEL_1

# define _ssGetNumOutputPorts(S) \
      ((ssGetSfcnUsesNumPorts(S) == 1)? \
       ((S)->sizes.out.numOutputPorts) : 0)                         /*(int_T) */

# if !SS_SL_INTERNAL
# define ssGetNumOutputPorts(S) \
          (S)->sizes.out.numOutputPorts                   /*   (int_T)       */
# endif

# define _ssSetNumOutputPorts(S,nOutputPorts) \
          (S)->sizes.out.numOutputPorts = (nOutputPorts)

# if SS_SFCN_FOR_SIM
#   define ssSetNumOutputPorts(S,nOutputPorts) \
          (*(S)->portInfo.regNumOutputPortsFcn)( \
            (S)->portInfo.regNumOutputPortsFcnArg,nOutputPorts)
# elif SS_SFCN_FOR_RTW
    /* RTW S-function block */
#   define ssSetNumOutputPorts(S,nOutputPorts) \
            ((_ssSetNumOutputPorts(S,nOutputPorts)) >= 0)
# elif SS_SL_INTERNAL || SS_RTW_INTERNAL
    /* Simulink or RTW model/run-time interface code */
#   define ssSetNumOutputPorts(S, nOutputPorts) \
            ((_ssSetNumOutputPorts(S,nOutputPorts)) >= 0)
# endif

# define ssSetPortInfoForOutputs(S,ptr) \
             (S)->portInfo.outputs = (ptr)
# define ssGetPortInfoForOutputs(S) \
             (S)->portInfo.outputs
#endif


/* NumInputPorts - This is the number of the input ports of your
 * S-function block.
 */
#if !SS_SFCN_LEVEL_1
# define _ssGetNumInputPorts(S) \
      ((ssGetSfcnUsesNumPorts(S) == 1)? \
       ((S)->sizes.in.numInputPorts) : 0)                          /*(int_T) */

# if !SS_SL_INTERNAL
# define ssGetNumInputPorts(S) \
          (S)->sizes.in.numInputPorts                     /*   (int_T)       */
# endif

# define _ssSetNumInputPorts(S,nInputPorts) \
          (S)->sizes.in.numInputPorts = (nInputPorts)
# if SS_SFCN_FOR_SIM
#   define ssSetNumInputPorts(S,nInputPorts) \
          (*(S)->portInfo.regNumInputPortsFcn)( \
            (S)->portInfo.regNumInputPortsFcnArg,nInputPorts)
# elif SS_SFCN_FOR_RTW
      /* RTW S-function block */
#   define ssSetNumInputPorts(S,nInputPorts) \
             ((_ssSetNumInputPorts(S,nInputPorts)) >= 0)
# elif SS_SL_INTERNAL || SS_RTW_INTERNAL
    /* Simulink or RTW model/run-time interface code */
#   define ssSetNumInputPorts(S, nInputPorts) \
             ((_ssSetNumInputPorts(S,nInputPorts)) >= 0)
# endif

# define ssSetPortInfoForInputs(S,ptr) \
             (S)->portInfo.inputs = (ptr)
# define ssGetPortInfoForInputs(S) \
             (S)->portInfo.inputs
#endif

#if SS_SL_INTERNAL || SS_RTW_INTERNAL || SS_GENERATED_S_FUNCTION

 /* NumY, SizeofY - This is the length of the root output
  * vector, Y, which is the sum of all the widths of the root outport blocks.
  */
# define ssGetNumY(S) \
          (S)->sizes.out.numY                             /*   (int_T)       */
# define ssSetNumY(S,ny) \
          (S)->sizes.out.numY = (ny)

# define ssGetSizeofY(S) \
          (S)->sizes.sizeofY                              /*   (int_T)       */
# define ssSetSizeofY(S,nbytes) \
          (S)->sizes.sizeofY = (nbytes)

 /* NumU, SizeofU - This is the length of the root input
  * vector, U, which is the sum of all the widths of the root inport blocks.
  */
# define ssGetNumU(S) \
          (S)->sizes.in.numU                              /*   (int_T)       */
# define ssSetNumU(S,nu) \
          (S)->sizes.in.numU = (nu)

# define ssGetSizeofU(S) \
          (S)->sizes.sizeofU                              /*   (int_T)       */
# define ssSetSizeofU(S,nbytes) \
          (S)->sizes.sizeofU = (nbytes)

# define ssGetSizeofParams(S,result)    \
 _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_GET_SIZE_OF_PARAMS,0,(result))\
 _ssSafelyCallGenericFcnEnd

#endif

#if SS_RTW_INTERNAL
   /* for backwards compatibility with RTW run-time interface */
#  define ssGetNumInputs(S)           ssGetNumU(S)
#  define ssSetNumInputs(S,nInputs)   ssSetNumU(S,nInputs)
#  define ssGetNumOutputs(S)          ssGetNumY(S)
#  define ssSetNumOutputs(S,nOutputs) ssSetNumY(S,nOutputs)
#endif


#if SS_SFCN_LEVEL_1 || SS_GENERATED_S_FUNCTION
 /* NumOutputs - This is the size of the output port of your S-function.
  */
# define ssGetNumOutputs(S) \
          (S)->sizes.out.numY                             /*   (int_T)       */
# define ssSetNumOutputs(S,nOutputs) \
          (S)->sizes.out.numY = (nOutputs)

 /* NumInputs - This is the size of the input port of your S-function.
  */
# define ssGetNumInputs(S) \
          (S)->sizes.in.numU                              /*   (int_T)       */
# define ssSetNumInputs(S,nInputs) \
          (S)->sizes.in.numU = (nInputs)

#elif SS_SFCN_NORMAL

# define ssGetNumOutputs(S) \
          ssGetNumOutputs_cannot_be_used_in_level2_SFunctions
# define ssSetNumOutputs(S) \
          ssGetNumOutputs_cannot_be_used_in_level2_SFunctions
# define ssGetNumInputs(S) \
          ssGetNumInputs_cannot_be_used_in_level2_SFunctions
# define ssSetNumInputs(S) \
          ssSetNumInputs_cannot_be_used_in_level2_SFunctions

#else

# define ssGetNumOutputsLevel1(S) \
          (S)->sizes.out.numY                             /*   (int_T)       */
# define ssSetNumOutputsLevel1(S,nOutputs) \
          (S)->sizes.out.numY = (nOutputs)

# define ssGetNumInputsLevel1(S) \
          (S)->sizes.in.numU                              /*   (int_T)       */
# define ssSetNumInputsLevel1(S,nInputs) \
          (S)->sizes.in.numU = (nInputs)

#endif

#define ssGetMexApiInt1(S) \
          (S)->sizes.mexApiInt1                          /*   (int_T)       */
#define ssSetMexApiInt1(S,val) \
          (S)->sizes.mexApiInt1 = (val)

#if !SS_SFCN_NORMAL
 /* DirectFeedThrough - Does your Level 1 S-function use ssGetU (i.e. u
  *   argument)in mdlOutputs?  For the root SimStruct, this field indicates
  *   whether or not the external input vector is used when executing the
  *   Output function (i.e. MdlOutputs) for the model.
  */
# define ssIsDirectFeedThrough(S) \
         (S)->sizes.sysDirFeedThrough                    /*   (int_T)       */
# define ssSetDirectFeedThrough(S,dirFeed) \
         (S)->sizes.sysDirFeedThrough = (dirFeed)

#else
# define ssIsDirectFeedThrough(S) \
         ssIsDirectFeedThrough_cannot_be_used_in_level2_SFunctions
# define ssSetDirectFeedThrough(S,dirFeed) \
         ssSetDirectFeedThrough_cannot_be_used_in_level2_SFunctions
#endif

/* NumBlockIO - Number of elements in the model-wide Block IO vector. Only
 *   valid for the root SimStruct. S-function blocks should not use this
 *   field (i.e. set it to 0).
 */
#define ssGetNumBlockIO(S) \
          (S)->sizes.numBlockIO                           /*   (int_T)       */
#define ssSetNumBlockIO(S,nBlockIO) \
          (S)->sizes.numBlockIO = (nBlockIO)

/* NumBlockParams - Number of parameter elements in the model-wide parameter
 *   vector. Only valid for the root SimStruct. S-function blocks should not
 *   use this field (i.e. set it to 0).
 */
#define ssGetNumBlockParams(S) \
          (S)->sizes.numBlockParams                       /*   (int_T)       */
#define ssSetNumBlockParams(S,nBlockParams) \
          (S)->sizes.numBlockParams = (nBlockParams)

/* Checksum fields - The checksum fields are primarily used by the root
 *   SimStruct to maintain consistency between Simulink external mode and
 *   the code generated from the Real-Time Workshop. In general, user
 *   written S-function should not use this field.
 */
#define ssGetChecksums(S) (S)->sizes.checksums

#define ssSetChecksumVal(S,idx,val)  \
          (S)->sizes.checksums[idx] = (val)
#define ssGetChecksumVal(S,idx)  \
          (S)->sizes.checksums[idx]

#define ssGetChecksum0(S) \
          (S)->sizes.checksums[0]                         /*   (uint32_T)    */
#define ssSetChecksum0(S,val) \
          (S)->sizes.checksums[0] = (val)

#define ssGetChecksum1(S) \
          (S)->sizes.checksums[1]                         /*   (uint32_T)    */
#define ssSetChecksum1(S,val) \
          (S)->sizes.checksums[1] = (val)

#define ssGetChecksum2(S) \
          (S)->sizes.checksums[2]                         /*   (uint32_T)    */
#define ssSetChecksum2(S,val) \
          (S)->sizes.checksums[2] = (val)

#define ssGetChecksum3(S) \
          (S)->sizes.checksums[3]                         /*   (uint32_T)    */
#define ssSetChecksum3(S,val) \
          (S)->sizes.checksums[3] = (val)

/* RWork - This is the size of the real work vector of your S-function.
 *   The root SimStruct contains the total number of real work elements
 *   used within the model.
 */
#define ssGetNumRWork(S) \
          (S)->sizes.numRWork                             /*   (int_T)       */
#define ssSetNumRWork(S,nRWork) \
          (S)->sizes.numRWork = (nRWork)

/* IWork - This is the size of the integer work vector of your S-function.
 *   The root SimStruct contains the total number of integer work elements
 *   used within the model.w
 */
#define ssGetNumIWork(S) \
          (S)->sizes.numIWork                             /*   (int_T)       */
#define ssSetNumIWork(S,nIWork) \
          (S)->sizes.numIWork = (nIWork)

/* PWork - This is the size of the pointer work vector of your S-function.
 *   The root SimStruct contains the total number of pointer work elements
 *   used within the model.
 */
#define ssGetNumPWork(S) \
          (S)->sizes.numPWork                             /*   (int_T)       */
#define ssSetNumPWork(S,nPWork) \
          (S)->sizes.numPWork = (nPWork)

/* NumSFcnParams - This is the number of expected parameters your S-function
 *   block expects. This field is not used by the root SimStruct.
 */
#define ssGetNumSFcnParams(S) \
          (S)->sizes.numSFcnParams                        /*   (int_T)       */
#define ssSetNumSFcnParams(S,nSFcnParams) \
          (S)->sizes.numSFcnParams = (nSFcnParams)

/* NumSampleTimes - This is the number of sample times your S-function has.
 *   The root SimStruct contains the total number of sample times within
 *   the model.
 */
#define ssGetNumSampleTimes(S) \
          (S)->sizes.numSampleTimes                       /*   (int_T)       */
#define ssSetNumSampleTimes(S,nSampleTimes) \
          (S)->sizes.numSampleTimes = (nSampleTimes)

/* NumSFunctions - This field is used by the root SimStruct to keep track
 *   of the number of child SimStruct's corresponding to S-function blocks.
 *   This field should not be used by S-function blocks (i.e. should be 0).
 */
#define ssGetNumSFunctions(S) \
          (S)->sizes.numSFunctions                        /*   (int_T)       */
#define ssSetNumSFunctions(S,nSFunctions) \
          (S)->sizes.numSFunctions = (nSFunctions)

/* NumBlocks - This field is used by the root SimStruct to keep track of
 *   the number of non-virtual blocks within the model. This field should
 *   not be used by S-function blocks (i.e. should be 0).
 */
#define ssGetNumBlocks(S) \
          (S)->sizes.numBlocks                            /*   (int_T)       */
#define ssSetNumBlocks(S,nBlocks) \
          (S)->sizes.numBlocks = (nBlocks)

/* Version - This field should not be used by S-function blocks directly.
 *   The the simulink.c include file at the bottom of your S-function block
 *   uses this field. It is also used by root SimStruct for versioning.
 */
#define ssGetVersion(S) \
          (S)->sizes.simStructVer                         /*   (int_T)       */
#define ssSetVersion(S,ver) \
          (S)->sizes.simStructVer = (int32_T) (ver)

#define ssGetSFcnLevel(S) \
          ((S)->sizes.simStructVer == (int32_T) SIMSTRUCT_VERSION_LEVEL2? 2: 1)

/* NumNonsampledZCs - This is the number of non-sampled zero crossings your
 *   S-function has. The root SimStruct contains the total number of non-sampled
 *   zero crossings within your model.
 */
#define ssGetNumNonsampledZCs(S) \
          (S)->sizes.numNonsampledZCs                     /*   (int_T)       */
#define ssSetNumNonsampledZCs(S,nNonsampledZCs) \
          (S)->sizes.numNonsampledZCs = (nNonsampledZCs)


/* NumZCEvents - This is the number of zero crossing events within your model.
 *   This field is not for use by S-functions (i.e. should be 0).
 */
#define ssGetNumZCEvents(S) \
          (S)->sizes.numZCEvents                          /*   (int_T)       */
#define ssSetNumZCEvents(S,nZCEvents) \
          (S)->sizes.numZCEvents = (nZCEvents)

/*
 * NumModes - This is the number of mode vector elements within your
 *   S-function. In the root SimStruct, this field contains the total
 *   number of mode vector elements within your model.
 */
#define ssGetNumModes(S) \
          (S)->sizes.numModes                             /*   (int_T)       */
#define ssSetNumModes(S,n) \
          (S)->sizes.numModes = (n)

/* SizeofBlockIO - This is the size of the block I/O vector in bytes.
 *  These should not be used by S-functions (accelerated models need to
 *  set the size though).
 */
#define ssGetSizeofBlockIO(S) \
          (S)->sizes.sizeofBlockIO                        /*   (int_T)       */
#define ssSetSizeofBlockIO(S,n) \
          (S)->sizes.sizeofBlockIO = (n)

/* SizeofGlobalBlockIO - This is the size of the global block I/O
 * vector in bytes. This is the size of rtB in the generated code.
 *  These should not be used by S-functions (accelerated models need to
 *  set the size though).
 */
#define ssGetSizeofGlobalBlockIO(S) \
          (S)->sizes.sizeofGlobalBlockIO                        /*   (int_T)       */
#define ssSetSizeofGlobalBlockIO(S,n) \
          (S)->sizes.sizeofGlobalBlockIO = (n)

/* DWork - This is the number of the data type work vector of your S-function.
 *   The root SimStruct contains the total number of data type work vectors
 *   used within the model.
 */
#define ssGetNumDWork(S) \
          (S)->sizes.numDWork                             /*   (int_T)       */
#define _ssSetNumDWork(S,nDWork) \
          ((S)->sizes.numDWork = (nDWork))

/* SizeofDWork - This is the size of the data type work vector in bytes.
 *  These should not be used by S-functions (accelerated models need to
 *  set the size though).
 */
#define ssGetSizeofDWork(S) \
          (S)->sizes.sizeofDWork                     /*   (int_T)       */
#define ssSetSizeofDWork(S,n) \
          (S)->sizes.sizeofDWork = (n)

/* RTWGeneratedSFcn - This is the flag which is set for rtw generated
 * s-function.  Can be removed once all dstates are changed to dworks
 */
#define ssGetRTWGeneratedSFcn(S) \
          (S)->sizes.RTWGeneratedSFcn                /*   (int_T)       */
#define ssSetRTWGeneratedSFcn(S,n) \
          (S)->sizes.RTWGeneratedSFcn = (n)

/* HasMdlDimensionsFcn - This is the flag which is set if the block
 * has mdlSetInput(output)PortDimensions function. Not for use by S-functions.
 */
#define ssGetSfcnHasMdlDimensionsFcn(S) \
          (S)->sizes.flags.hasMdlDimensionsFcn     /*   (unsigned int_T: 1) */
#define _ssSetSfcnHasMdlDimensionsFcn(S,n) \
          (S)->sizes.flags.hasMdlDimensionsFcn = (n)

/* usesNumPorts - This flag is set by ssSetNumInputPorts and
 * ssSetNumOutputPorts when S is used in Simulink.
 * Not for use by S-functions.
 */
#define ssGetSfcnUsesNumPorts(S) \
          (S)->sizes.flags.usesNumPorts     /*   (unsigned int_T: 1) */
#define _ssSetSfcnUsesNumPorts(S,n) \
          (S)->sizes.flags.usesNumPorts = (n)

/* VectMode - This flag is used in Simulink set port dimension methods.
 * See ssVectorMode typedef for valid settings.
 */
#define ssGetVectorMode(S) \
          (S)->sizes.flags.vectMode          /*   (unsigned int_T: 4) */
#define ssSetVectorMode(S,n) \
          (S)->sizes.flags.vectMode = (n)

/* BlockReduction - Specify that this block should be eliminated from the
 * compiled model.  Note that Simulink may not honor this setting, in which
 * case the block will remain in the model.  After blocks have been
 * considered for elimination, ssGetBlockReduction will return whether or
 * not the block was eliminated.
 */
#define ssGetBlockReduction(S) \
          (S)->sizes.flags.blockReduction     /*   (unsigned int_T: 1) */
#define ssSetBlockReduction(S,n) \
          (S)->sizes.flags.blockReduction = (n)
/*
 * ss(Set|Get)TreatAsAtomic - This macro is NOT to be used by
 *                            custom S-Functions.
 */
#define ssGetTreatAsAtomic(S) \
          (S)->sizes.flags.treatAsAtomic     /*   (unsigned int_T: 1) */
#define ssSetTreatAsAtomic(S,n) \
          (S)->sizes.flags.treatAsAtomic = (n)
/*
 * ss(Set|Get)HasSubFunctions - This macro is NOT to be used by
 *                              custom S-Functions.
 */
#define ssGetHasSubFunctions(S) \
          (S)->sizes.flags.hasSubFunctions     /*   (unsigned int_T: 1) */
#define ssSetHasSubFunctions(S,n) \
          (S)->sizes.flags.hasSubFunctions = (n)

/*
 * ss(Set|Get)CallsOutputInInitFcn - This macro is NOT to be used by
 *                                    custom S-Functions.
 */
#define ssGetCallsOutputInInitFcn(S) \
          (S)->sizes.flags.callsOutputInInit     /*   (unsigned int_T: 1) */
#define ssSetCallsOutputInInitFcn(S,n) \
          (S)->sizes.flags.callsOutputInInit = (n)

/* RTWCG - Block supports CGIR code generation for RTW (instead of TLC).
 */
#define ssGetRTWCG(S) \
          (S)->sizes.flags.rtwcg     /*   (unsigned int_T: 1) */
#define ssSetRTWCG(S,n) \
          (S)->sizes.flags.rtwcg = (n)

/* Block need absolute time. If block requiring absolute does not
 * set this flag. Obsolete absolute time will be used. Obsolete absolute
 * timer cannot support fixed pt blocks.
 */
#define ssGetNeedAbsoluteTime(S) \
          (S)->sizes.flags.needAbsoluteTime /*   (unsigned int_T: 1) */
#define ssSetNeedAbsoluteTime(S,n) \
          (S)->sizes.flags.needAbsoluteTime = (n)

#define ssGetNeedElapseTime(S) \
          (S)->sizes.flags.needElapseTime /*   (unsigned int_T: 1) */
#define ssSetNeedElapseTime(S,n) \
          (S)->sizes.flags.needElapseTime = (n)

/*
 * mdlProjection may be present but S-Fcn may not want to call it
 */
#define ssSetDisableMdlProjection(S,boolVal) \
           ((S)->sizes.flags.disableMdlProjection = (boolVal) ? 1U : 0U)

#define ssIsMdlProjectionDisabled(S) \
           ((S)->sizes.flags.disableMdlProjection == 1U)

/*
 * mdlSlvrJacobian may be present but S-Fcn may want to call default
   method
 */
#define ssSetDisableMdlSlvrJacobian(S,boolVal) \
           ((S)->sizes.flags.disableMdlSlvrJacobian = (boolVal) ? 1U : 0U)

#define ssIsMdlSlvrJacobianDisabled(S) \
           ((S)->sizes.flags.disableMdlSlvrJacobian == 1U)

/*
 * Query to see if rapid accelerator is active
 * Note that rapid accelerator simulation can have
 * simulation mode != rapid hence we need this query
 */
#define ssSetIsRapidAcceleratorActive(S,boolVal)                        \
    ((!ssGetParentSS(S)) ?                                              \
     ((S)->sizes.flags.isRapidAcceleratorActive = (boolVal) ? 1U : 0U) : \
     0)

#define ssIsRapidAcceleratorActive(S)                                   \
    ((!ssGetParentSS(S)) ?                                               \
     ((S)->sizes.flags.isRapidAcceleratorActive == 1U) :                \
     ((ssGetParentSS(S))->sizes.flags.isRapidAcceleratorActive == 1U))

/*
 * ss(S|G)etExplicitFCSSCtrl
 */
#define ssGetExplicitFCSSCtrl(S) \
          (S)->sizes.flags.explicitFCSSCtrl     /*   (unsigned int_T: 1) */
#define ssSetExplicitFCSSCtrl(S,n) \
          (S)->sizes.flags.explicitFCSSCtrl = (n)

#define ssGetModelReferenceNormalModeSupport(S) \
          (ssModelReferenceNormalModeSupport)\
          ((S)->sizes.flags.modelRefNormalModeSupport)
#define ssSetModelReferenceNormalModeSupport(S, n) \
          (S)->sizes.flags.modelRefNormalModeSupport = (n)

/* Method to register that an S-function uses the LibSystemOutputCustomCode 
 * or LibSystemUpdateCustomCode methods in TLC either directly or indirectly 
 */
#define ssGetUsingTLCCustomCodeFunctions(S) \
    (S)->sizes.flags.usesCustomCodeFcns
#define ssSetUsingTLCCustomCodeFunctions(S,val) \
    (S)->sizes.flags.usesCustomCodeFcns = (val)   

/* Method to register that an S-function block can participate in 
 * CRL based block replacement 
 */
#define ssGetCrlReplacementEnabled(S) \
    (S)->sizes.flags.crlReplacementEnabled
#define ssSetCrlReplacementEnabled(S,val) \
    (S)->sizes.flags.crlReplacementEnabled = (val)


/* PortBasedSampleTimeBlockIsTriggered
 *   This macro is for use during calls to mdlOutputs and mdlUpdate
 *   If the first sample time is inherited at that point then the block
 *   must be triggered (sample and offset both -1)
 */
#define ssGetPortBasedSampleTimeBlockIsTriggered(S) \
  ((S)->stInfo.sampleTimes[0] == INHERITED_SAMPLE_TIME)

/* ------------------------------- S->portInfo ------------------------------*/

/* BEGIN long level 1 exclusion */
#if !SS_SFCN_LEVEL_1

# if SS_SL_INTERNAL || SS_SFCN_FOR_SIM
#  define ssSetRegInputPortDimensionInfoFcn(S,fcn) \
             (S)->mdlInfo->regInputPortDimsInfo = (fcn)
#  define ssGetRegInputPortDimensionInfoFcn(S) \
             ((S)->mdlInfo->regInputPortDimsInfo)
#  define ssSetRegOutputPortDimensionInfoFcn(S,fcn) \
             (S)->mdlInfo->regOutputPortDimsInfo = (fcn)
#  define ssGetRegOutputPortDimensionInfoFcn(S) \
             ((S)->mdlInfo->regOutputPortDimsInfo)
# endif

/*********************
 * Input Port Width  *
 *********************/
/* InputPortWidth - Input port width for level 2 s-functions which can
 *  have multiple ports. Each port must have a non-zero positive width or
 *  it can be specified as DYNAMICALLY_SIZED during the set. Latter get
 *  will return the resolved size for use during simulation.
 */
# define ssGetInputPortWidth(S,port) \
          (S)->portInfo.inputs[(port)].width              /*   (int_T)       */
# define ssSetInputPortWidth(S,port,val) \
          (S)->portInfo.inputs[(port)].width = (val)

/***********************************
 * Input Port Number of Dimensions *
 ***********************************/
# define ssGetInputPortNumDimensions(S,port) \
          ((S)->portInfo.inputs[(port)].numDims)           /*   (int_T) */

# define _ssSetInputPortNumDimensions(S,port,val) \
{\
    (S)->portInfo.inputs[(port)].numDims = (val);\
    if(val == 1) { \
        (S)->portInfo.inputs[(port)].dims = \
                        &((S)->portInfo.inputs[(port)].width);\
    }\
}

/*************************
 * Input Port Dimensions *
 *************************/
/*  ssGetInputPortDimensionSize returns the size of a specified
 *  dimension at the input port. If the dimension index is greater
 *  than or equal to the number of input port dimensions,
 *  ssGetInputPortDimensionSize returns 1.
 */
# define ssGetInputPortDimensionSize(S,port,dIdx) \
         ((dIdx) < ssGetInputPortNumDimensions((S),(port)) ? \
                  (S)->portInfo.inputs[(port)].dims[(dIdx)] : 1)

/* ssGetInputPortDimensions returns the pointer to the dimension
 * size array for the input port
 */
# define ssGetInputPortDimensions(S,port) \
         ((S)->portInfo.inputs[(port)].dims)

/* Do not make a copy. S-function port dimension = Ptr. */
# define _ssSetInputPortDimensionsPtr(S,port,ptr) \
{\
   (S)->portInfo.inputs[(port)].dims = (ptr);\
}

/*
 * Copy 'd' to S-function port dimensions. It is assumed that
 * port has enough storage/memory to store the dimensions.
 */
# define _ssCopyInputPortDimensions(S,port,d) \
{\
    int nn = ssGetInputPortNumDimensions(S,port);\
    if(nn >= 1){\
        (void)memcpy(ssGetInputPortDimensions(S,port),d, \
                     nn*sizeof(int_T)); \
    }\
}


/************************************************************
 * Input Port Width/Number of Dimensions/Dimensions Methods *
 ************************************************************/
# if SS_SL_INTERNAL || SS_SFCN_FOR_SIM
#   define ssSetInputPortDimensionInfo(S,port,val) \
       (((ssGetRegInputPortDimensionInfoFcn(S)) != NULL ) ? \
        (ssGetRegInputPortDimensionInfoFcn(S))(S,port,val) : \
        (1))
# else /* RTW S-function block */
#   define  ssSetInputPortDimensionInfo(S,port,val) (1)
# endif


/* Matrix dimensions */
# if SS_SL_INTERNAL || SS_SFCN_FOR_SIM
#   define ssSetInputPortMatrixDimensions(S,port,val1,val2) \
       (_ssSetInputPortMatrixDimensions(S,port,val1,val2))
# else /* RTW S-function block */
#   define ssSetInputPortMatrixDimensions(S,port,val1,val2) (1)
# endif

/* Vector dimensions */
# if SS_SL_INTERNAL || SS_SFCN_FOR_SIM
#   define ssSetInputPortVectorDimension(S,port,val) \
       (_ssSetInputPortVectorDimension(S,port,val))
# else /* RTW S-function block */
#   define ssSetInputPortVectorDimension(S,port,val) (1)
# endif

/*
 * Set/Get flag that specifies if an S-function can handle
 * N-D signals
 */
# if SS_SL_INTERNAL || SS_SFCN_FOR_SIM
#   define ssAllowSignalsWithMoreThan2D(S)           \
           _ssSafelyCallGenericFcnStart(S)(S,        \
                GEN_FCN_SET_ALLOW_MORE_THAN_2D_SIGS, \
                1,NULL)\
           _ssSafelyCallGenericFcnEnd
# else
#   define ssAllowSignalsWithMoreThan2D(S)
# endif

/*
 * Set flag that specifies if an S-function can handle
 * Big Long signal
 * ssAllowSignalsHandleBigLong(S) is deprecated.
 * Please use ssFxpSetU32BitRegionCompliant defined in fixedpoint.h instead
 */
# if SS_SL_INTERNAL || SS_SFCN_FOR_SIM
#   define ssAllowSignalsHandleBigLong(S)           \
           _ssSafelyCallGenericFcnStart(S)(S,       \
                GEN_FCN_SET_SIGS_ALLOW_BIG_LONG,    \
                1,NULL)\
           _ssSafelyCallGenericFcnEnd
# else
#   define ssAllowSignalsHandleBigLong(S)
# endif

# if SS_SL_INTERNAL || SS_SFCN_FOR_SIM
#   define ssSetSupportDataTypeBeyond32BitsInRTW(S, val)           \
           _ssSafelyCallGenericFcnStart(S)(S,       \
                GEN_FCN_SET_SUPPORT_DATATYPE_BEYOND_32_BITS_IN_RTW,   \
                val,NULL)\
           _ssSafelyCallGenericFcnEnd
# else
#   define ssSetSupportDataTypeBeyond32BitsInRTW(S, val)
# endif


/***************************
 * END of width/dimensions *
 ***************************/
# define ssGetInputPortSignalWhenNeeded(S,port) \
          ((S)->portInfo.inputs[(port)].attributes.cinId)
# define ssSetInputPortSignalWhenNeeded(S,port,val) \
          (S)->portInfo.inputs[(port)].attributes.cinId = (val)

# define ssGetOutputPortSignalWhenRefreshed(S,port) \
          ((S)->portInfo.outputs[(port)].attributes.cecId)
# define ssSetOutputPortSignalWhenRefreshed(S,port,val) \
          (S)->portInfo.outputs[(port)].attributes.cecId = (val)

 /* InputPortFrameData -  For each input port or your S-function block, this
  *   is whether or not the incoming signal is frame data, where (-1=either,
  *   0=no, 1=yes).
  */
# define ssGetInputPortFrameData(S,port) \
          CONV_BITS2INT((S)->portInfo.inputs[(port)].attributes.frameData)
# define ssSetInputPortFrameData(S,port,val) \
          (S)->portInfo.inputs[(port)].attributes.frameData = \
          CONV_INT2BITS(val)

 /* InputPortDirectFeedthrough -  port width for level 2 s-functions which can
  *  have multiple ports.
  */
# define ssGetInputPortDirectFeedThrough(S,port) \
          (S)->portInfo.inputs[(port)].directFeedThrough  /*   (int_T)       */

# if SS_SFCN_FOR_SIM && !SS_NDEBUG

#ifdef __cplusplus
extern "C" {
#endif
extern void _ssSetInputPortDirectFeedThroughFcn(const SimStruct *S, int port,
                                             int dirFeed);
#ifdef __cplusplus
}
#endif

# define ssSetInputPortDirectFeedThrough(S,port,dirFeed) \
         _ssSetInputPortDirectFeedThroughFcn(S,port,dirFeed)
#else
# define ssSetInputPortDirectFeedThrough(S,port,dirFeed) \
          (S)->portInfo.inputs[(port)].directFeedThrough = (dirFeed)
#endif

 /* InputDataType - For each input port of your S-function block, this is the
  *   data type. If no data types is specified, then the default is real_T.
  */
# define ssGetInputPortDataType(S,port) \
          (S)->portInfo.inputs[(port)].dataTypeId         /*     (DTypeId)   */
# define ssSetInputPortDataType(S,port,dTypeId) \
          ((S)->portInfo.inputs[(port)].dataTypeId = (dTypeId))

 /* InputComplexSignal - For each input port or your S-function block, this is
  *   whether or not the incoming signal is complex, where (-1=either, 0=no,
  *   1=yes).
  */
# define ssGetInputPortComplexSignal(S,port) \
          (S)->portInfo.inputs[(port)].complexSignal      /*   (CSignal_T)    */
# define ssSetInputPortComplexSignal(S,port,val) \
          (S)->portInfo.inputs[(port)].complexSignal = (val)

 /* InputPortSignalPtrs - This is the pointers to the signal vector for each
  *    input port. This is the default method for accessing the S-Function's
  *    input signals. It is a *bad* error to use this macro if the S-Function
  *    specifies ssSetInputPortRequiredContiguous as true. In that case, use
  *    ssGetInputPortSignal().
  *
  *    The following code demonstrates the use of ssGetInputPortSignalPtrs() :
  *
  *       nInputPorts = ssGetNumInputPorts(S);
  *       for (i = 0; i < nInputPorts; i++) {
  *         InputPtrsType u  = ssGetInputPortSignalPtrs(S,i);
  *         int_T         nu = ssGetInputPortWidth(S,i);
  *         for (j = 0; j < nu; j++) {
  *           UseInputInSomeFunction(*u[i]);
  *         }
  *       }
  *
  *    If you know that the input's are always real_T's signals, then the
  *    ssGetInputPortSignalPtrs line in the above code snippet would be:
  *
  *         InputRealPtrsType u = ssGetInputPortRealSignalPtrs(S,i);
  *
  */
# if SS_SFCN_FOR_SIM && !SS_NDEBUG
#  ifdef __cplusplus
    extern "C" {
#  endif
    extern InputPtrsType _ssGetInputPortSignalPtrsFcn(const SimStruct *S,
                                                      int ip);
#  ifdef __cplusplus
    }
#  endif
#   define ssGetInputPortSignalPtrs(S,ip) _ssGetInputPortSignalPtrsFcn(S,ip)
#   define ssGetInputPortRealSignalPtrs(S,ip) \
        ((InputRealPtrsType)_ssGetInputPortSignalPtrsFcn(S,ip))
# else
#  define ssGetInputPortSignalPtrs(S,ip) \
     ( (S)->portInfo.inputs[(ip)].signal.ptrs )      /* (InputPtrsType) */
#  define ssGetInputPortRealSignalPtrs(S,ip) \
     ( (InputRealPtrsType) ssGetInputPortSignalPtrs(S,ip) )
# endif

# define _ssSetInputPortSignalPtrs(S,ip,ptr) \
    (S)->portInfo.inputs[(ip)].signal.ptrs = (ptr)
# if !SS_SFCN
#   define ssSetInputPortSignalPtrs(S,ip,ptr) \
      _ssSetInputPortSignalPtrs(S,ip,ptr)
# else
#   define ssSetInputPortSignalPtrs(S,ip,ptr) \
      ssSetInputPortSignalPtrs_cannot_be_used_in_SFunctions
# endif


 /* InputPortSignal: This macro returns the address of the signal on the
  *    specified input port of the S-Function. In order to use this macro for
  *    accessing the input port signal you need to set the attribute
  *    ssSetInputPortRequiredContiguous to true. If not, this macro returns an
  *    invalid pointer.
  *
  *    The following code demonstrates the use of ssGetInputPortSignal() :
  *
  *       nInputPorts = ssGetNumInputPorts(S);
  *       for (i = 0; i < nInputPorts; i++) {
  *           int_T nu = ssGetInputPortWidth(S,i);
  *
  *           if ( ssGetInputPortRequiredContiguous(S,i) ) {
  *
  *               const void *u = ssGetInputPortSignal(S,i);
  *               UseInputVectorInSomeFunction(u, nu);
  *
  *           } else {
  *
  *               InputPtrsType u  = ssGetInputPortSignalPtrs(S,i);
  *               for (j = 0; j < nu; j++) {
  *                   UseInputInSomeFunction(*u[j]);
  *               }
  *           }
  *       }
  *
  *    If you know that the input's are always real_T's signals, then the
  *    ssGetInputPortSignal line in the above code snippet would be:
  *
  *         const real_T *u = ssGetInputPortRealSignal(S,i);
  *
  */
# if SS_SFCN_FOR_SIM && !SS_NDEBUG
#  ifdef __cplusplus
    extern "C" {
#  endif
    extern const void *_ssGetInputPortSignalFcn(const SimStruct *S, int ip);
#  ifdef __cplusplus
   }
#  endif
#   define ssGetInputPortSignal(S,ip) _ssGetInputPortSignalFcn(S,ip)
#   define ssGetInputPortRealSignal(S,ip) \
        ((const real_T *)_ssGetInputPortSignalFcn(S,ip))
# else
#  define ssGetInputPortSignal(S,ip) \
     ( (S)->portInfo.inputs[(ip)].signal.vect )       /* (const void *) */
#  define ssGetInputPortRealSignal(S,ip) \
     ( (const real_T *) ssGetInputPortSignal(S,ip) )
# endif

# define _ssSetInputPortSignal(S,ip,ptr) \
          (S)->portInfo.inputs[(ip)].signal.vect = (ptr)
# if !SS_SFCN
#   define ssSetInputPortSignal(S,ip,ptr) \
          _ssSetInputPortSignal(S,ip,ptr)
# else
#   define ssSetInputPortSignal(S,ip,ptr) \
          ssSetInputPortSignal_cannot_be_used_in_SFunctions
# endif


 /* InputPortConnected - Is the input connected to a non-virtual block (i.e.
  *   are there signals entering the S-function block)?
  */
# define ssGetInputPortConnected(S,port) \
          (S)->portInfo.inputs[(port)].connected              /* (int_T) */
# define _ssSetInputPortConnected(S,port,val) \
          (S)->portInfo.inputs[(port)].connected = (val)
# if !SS_SFCN
#   define ssSetInputPortConnected(S,port,val) \
            _ssSetInputPortConnected(S,port,val)
# else
#   define ssSetInputPortConnected(S,port,val) \
            ssSetInputPortConnected_cannot_be_used_in_SFunctions
# endif

 /* InputPortAcceptExprInRTW - Specify that the input port signal can be
  * and expression in RTW.  This allows the block to fold an upstream
  * calculation into its own.
  */
# define ssGetInputPortAcceptExprInRTW(S,port) \
       ((S)->portInfo.inputs[(port)].attributes.acceptExprInRTW == 1U)
# define ssSetInputPortAcceptExprInRTW(S,port,val) \
       ((S)->portInfo.inputs[(port)].attributes.acceptExprInRTW = \
        (val) ? 1U : 0U)

#if defined(RTW_GENERATED_S_FUNCTION) || SS_SL_INTERNAL
 /* InputPortIsNotDerivPort - Specify that the input port signal is not
  * used in mdlDerivative function.  By default this will be false for all input
  * ports when the blocks has continuous states.  This setting is used
  * to determine what noncontinuous signals to track during simulation.
  */
# define ssGetInputPortIsNotDerivPort(S,port) \
       ((S)->portInfo.inputs[(port)].attributes.nonDerivPort == 1U)
# define ssSetInputPortIsNotDerivPort(S,port,val) \
       ((S)->portInfo.inputs[(port)].attributes.nonDerivPort = \
        (val) ? 1U : 0U)
#endif

 /* InputPortOverWritable - Is the memory occupied by the signals driving this
  *   input port over writable by (one of the) output ports of the sfunction?
  *
  */
# define ssGetInputPortOverWritable(S,port) \
       ((S)->portInfo.inputs[(port)].attributes.overWritable == 1U)
# define ssSetInputPortOverWritable(S,port,val) \
       ((S)->portInfo.inputs[(port)].attributes.overWritable = (val) ? 1U : 0U)

 /*
  * This macro is obsolete, please use ssS(G)etInputPortOptimOpts
  *
  *  InputPortReusable - If this is set to false (which is the default value),
  *  then the memory allocated to the signals driving this input port are both
  *  globally visible and persistent. However, if this is set to true then this
  *  signal may be reused by other block outputs (and hence its value will not
  *  be persistent). For finer control use ssSetInputPortOptimOpts
  *
  */
# if SS_SFCN_NORMAL
# define ssGetInputPortReusable(S,port) \
         ( (S)->portInfo.inputs[(port)].attributes.optimOpts !=  \
                                                    SS_NOT_REUSABLE_AND_GLOBAL )

#  if SS_SFCN_FOR_SIM && !SS_NDEBUG
#ifdef __cplusplus
    extern "C" {
#endif
extern void _ssSetInputPortReusableFcn(SimStruct *S, int port, int val);
#ifdef __cplusplus
    }
#endif
#  define ssSetInputPortReusable(S,port,val) \
         _ssSetInputPortReusableFcn(S,port,val)
#  else
#  define ssSetInputPortReusable(S,port,val) \
         ( (S)->portInfo.inputs[(port)].attributes.optimOpts = \
                    (val) ? SS_REUSABLE_AND_LOCAL : SS_NOT_REUSABLE_AND_GLOBAL )
#  endif

# endif


 /* InputPortOptimOpts - This macro allows finer control over the re-usability
  * and identifier scope of the input port signal.
  *
  */
# define ssGetInputPortOptimOpts(S,port) \
       ( (S)->portInfo.inputs[(port)].attributes.optimOpts )
# define ssSetInputPortOptimOpts(S,port,val) \
       ( (S)->portInfo.inputs[(port)].attributes.optimOpts = (val) )


/* InputPortOptimizeInIR - This macro allows S-Functions that use the code
 * generation intermediate representation (CGIR) to generate code, to enable
 * optimizations on for the input port that would otherwise be disabled by
 * default. For example, the macro should be used if a S-Function set its
 * input port conservatively as global, because it is accessed in both the
 * output and the update function. It is possible for CGIR to safely optimize
 * the port signal if output and update get combined.
 */
# define ssGetInputPortOptimizeInIR(S,port) \
    ( (S)->portInfo.inputs[(port)].attributes.optimizeInIR )
# define ssSetInputPortOptimizeInIR(S,port,val) \
    ( (S)->portInfo.inputs[(port)].attributes.optimizeInIR = (val) )


 /* InputPortBufferDstPort - If an input port and some output port on an
  *   S-Function are *not* test points, and in addition,  if this input port is
  *   over-writable, then one of the "untest-pointed" output ports of this
  *   S-Function might reuse the same buffer as the input port! If this happens,
  *   then after compilation, the following macro returns the index of the
  *   output port that reuses the specified input port's buffer. If none of the
  *   S-Function's output ports reuse this input port buffer, then this macro
  *   returns INVALID_PORT_IDX ( = -1).
  */
# define ssGetInputPortBufferDstPort(S,port) \
          ((S)->portInfo.inputs[(port)].bufferDstPort)             /* (int_T) */
# define _ssSetInputPortBufferDstPort(S,port,val) \
          (S)->portInfo.inputs[(port)].bufferDstPort = (val)
# if !SS_SFCN
#   define ssSetInputPortBufferDstPort(S,port,val) \
            _ssSetInputPortBufferDstPort(S,port,val)
# else
#   define ssSetInputPortBufferDstPort(S,port,val) \
            ssSetInputPortBufferDstPort_cannot_be_used_in_SFunctions
# endif

 /* InputPortSampleTime/InputPortOffsetTime - The sample and offset time of
  *   the input port. This should only be used when PORT_BASED_SAMPLE_TIMES
  *   have been specified for ssSetNumSampleTimes in mdlInitializeSizes.
  * InputPortSampleTimeIndex - index of the sample time for the port to
  *   be used in mdlOutputs, mdlUpdate when checking for sample hits.
  */
# define ssGetInputPortSampleTime(S,port) \
          ((S)->portInfo.inputs[(port)].sampleTime)         /* (real_T)      */
# define ssSetInputPortSampleTime(S,port,val) \
          (S)->portInfo.inputs[(port)].sampleTime = (val)   /* (real_T)      */
# define ssGetInputPortOffsetTime(S,port) \
          ((S)->portInfo.inputs[(port)].offsetTime)         /* (real_T)      */
# define ssSetInputPortOffsetTime(S,port,val) \
          (S)->portInfo.inputs[(port)].offsetTime = (val)   /* (real_T)      */

# define ssGetInputPortSampleTimeIndex(S,port) \
          (S)->portInfo.inputs[(port)].sampleTimeIndex      /* (int_T)       */
# define _ssSetInputPortSampleTimeIndex(S,port,idx) \
          (S)->portInfo.inputs[(port)].sampleTimeIndex = (idx) /* (int_T)   */
# if !SS_SFCN
#   define ssSetInputPortSampleTimeIndex(S,port,idx) \
            _ssSetInputPortSampleTimeIndex(S,port,idx)
# else
#   define ssSetInputPortSampleTimeIndex(S,port,idx) \
            ssSetInputPortSampleTimeIndex_cannot_be_used_in_SFunctions
# endif


 /* InputPortRequiredContiguous - If this flag is set to true (the default
  *   value is false), then the S-Function input signal's starting address
  *   should be accessed via ssGetInputPortSignal(), and then you can "walk"
  *   this pointer from 0 to portWidth-1 to read the values of the input
  *   signal elements. The S-Function can set the value of this attribute
  *   as early as in mdlInitializeSizes() method and at the latest in
  *   mdlSetWorkWidths() method. If this attribute is set any later than the
  *   mdlSetWorkWidths() method, say in mdlStart() or mdlOutputs(), horrible
  *   things will happen.
  *
  * Notes:
  *   As mentioned above, the default setting for this flag is false,
  *   hence, the default method of accessing the input signals of a
  *   Level-2 S-Function is using ssGetInputSignalPtrs().
  */
# define ssGetInputPortRequiredContiguous(S,port) \
   ((S)->portInfo.inputs[(port)].attributes.contiguity != 0)
# define ssSetInputPortRequiredContiguous(S,port,val) \
   (S)->portInfo.inputs[(port)].attributes.contiguity = ((val)!=0)


/*********************
 * Output Port Width  *
 *********************/
/* OutputPortWidth - Output port width for level 2 s-functions which can
 *  have multiple ports. Each port must have a non-zero positive width or
 *  it can be specified as DYNAMICALLY_SIZED during the set. Latter get
 *  will return the resolved size for use during simulation.
 */
# define ssGetOutputPortWidth(S,port) \
          (S)->portInfo.outputs[(port)].width             /*   (int_T)       */
# define ssSetOutputPortWidth(S,port,val) \
          (S)->portInfo.outputs[(port)].width = (val)

/***********************************
 * Output Port Number of Dimensions *
 ***********************************/
# define ssGetOutputPortNumDimensions(S,port) \
          ((S)->portInfo.outputs[(port)].numDims)           /*   (int_T) */

# define _ssSetOutputPortNumDimensions(S,port,val) \
{\
    (S)->portInfo.outputs[(port)].numDims = (val);\
    if(val == 1){\
       (S)->portInfo.outputs[(port)].dims = \
            &((S)->portInfo.outputs[(port)].width);\
    }\
}

/*************************
 * Output Port Dimensions *
 *************************/
/* ssGetOutputPortDimensionSize returns the size of a specific
 * dimension at the output port. If the dimension index is greater
 * than or equal to the number of input port dimensions,
 * ssGetOutputPortDimensionSize returns 1.
 */
# define ssGetOutputPortDimensionSize(S,port,dIdx) \
         ((dIdx) < ssGetOutputPortNumDimensions((S),(port)) ? \
                  (S)->portInfo.outputs[(port)].dims[(dIdx)] : 1)

/* ssGetOutputPortDimensions returns the pointer to the dimension
 * size array for the output port
 */
# define ssGetOutputPortDimensions(S,port) \
         ((S)->portInfo.outputs[(port)].dims)

/* Do not make a copy. S-function port dimension = Ptr. */
# define _ssSetOutputPortDimensionsPtr(S,port,ptr) \
{\
   (S)->portInfo.outputs[(port)].dims = (ptr);\
}

/*
 * Copy 'd' to S-function port dimensions. It is assumed that
 * port has enough storage/memory to store the dimensions.
 */
# define _ssCopyOutputPortDimensions(S,port,d) \
{\
    int nn = ssGetOutputPortNumDimensions(S,port);\
    if(nn >= 1){\
        (void)memcpy(ssGetOutputPortDimensions(S,port),d, \
                     nn*sizeof(int_T)); \
    }\
}

/************************************************************
 * Output Port Width/Number of Dimensions/Dimensions Methods *
 ************************************************************/
#if SS_SL_INTERNAL || SS_SFCN_FOR_SIM
#  define ssSetOutputPortDimensionInfo(S,port,val) \
      (((ssGetRegOutputPortDimensionInfoFcn(S)) != NULL ) ? \
       (ssGetRegOutputPortDimensionInfoFcn(S))(S,port,val) : \
       (1))
#else /* RTW S-function block */
#  define  ssSetOutputPortDimensionInfo(S,port,val) (1)
#endif

/* Matrix */
#if SS_SL_INTERNAL || SS_SFCN_FOR_SIM
#  define ssSetOutputPortMatrixDimensions(S,port,val1,val2) \
      (_ssSetOutputPortMatrixDimensions(S,port,val1,val2))
#else /* RTW S-function block */
#  define ssSetOutputPortMatrixDimensions(S,port,val1,val2) (1)
#endif

/* Vector */
#if SS_SL_INTERNAL || SS_SFCN_FOR_SIM
#  define ssSetOutputPortVectorDimension(S,port,val) \
     (_ssSetOutputPortVectorDimension(S,port,val))
#else /* RTW S-function block */
#  define ssSetOutputPortVectorDimension(S,port,val) (1)
#endif

/* ssPruneNDMatrixSingletonDimensions removes all trailing
 * singleton dimensions in the dimInfo structure. The function
 * modifies the number of dimensions in the dimInfo structure,
 * but does not change the dimension size array in dimInfo
 */
# if SS_SL_INTERNAL || SS_SFCN_FOR_SIM
#define ssPruneNDMatrixSingletonDims(S,dimInfo) \
 _ssSafelyCallGenericFcnStart(S)(S,GEN_FCN_PRUN_TRAILING_DIMS, \
                                 0,(void *)dimInfo)\
 _ssSafelyCallGenericFcnEnd
# else
#define ssPruneNDMatrixSingletonDims(S,dimInfo)
# endif

/***************************
 * END of width/dimensions *
 ***************************/

 /* OutputPortFrameData - For each input port or your S-function block, this
  *   is whether or not the outgoing signal is frame data, where (-1=either,
  *   0=no, 1=yes).
  */
# define ssGetOutputPortFrameData(S,port) \
          CONV_BITS2INT((S)->portInfo.outputs[(port)].attributes.frameData)
# define ssSetOutputPortFrameData(S,port,val) \
   (S)->portInfo.outputs[(port)].attributes.frameData = \
            CONV_INT2BITS(val)

 /*
  * This macro is obsolete, please use ssS(G)etOutputPortOptimOpts
  *
  * OutputPortReusable - If this is set to false (which is the default value),
  *  then the memory allocated to this output port is both globally visible,
  *  and persistent. However, if you set this to true in the mdlInitializeSizes
  *  function then the memory allocated for this signal may be reused by other
  *  block outputs (hence its value will not be persistent).
  *  For finer control use ssSetOutputPortOptimOpts
  */
# if SS_SFCN_NORMAL
# define ssGetOutputPortReusable(S,port) \
         ( (S)->portInfo.outputs[(port)].attributes.optimOpts != \
                                                    SS_NOT_REUSABLE_AND_GLOBAL )

#  if SS_SFCN_FOR_SIM && !SS_NDEBUG
#ifdef __cplusplus
    extern "C" {
#endif
extern void _ssSetOutputPortReusableFcn(SimStruct *S, int port, int val);
#ifdef __cplusplus
    }
#endif
#  define ssSetOutputPortReusable(S,port,val) \
         _ssSetOutputPortReusableFcn(S,port,val)
#  else
#  define ssSetOutputPortReusable(S,port,val) \
         ((S)->portInfo.outputs[(port)].attributes.optimOpts = \
                    (val) ? SS_REUSABLE_AND_LOCAL : SS_NOT_REUSABLE_AND_GLOBAL )
#  endif

# endif

 /* OutputPortOptimOpts - This macro gives finer control for the S-Function to
  * specify the reusability and identifier scope of the output port signal
  * separately.
  */
# define ssGetOutputPortOptimOpts(S,port) \
       ( (S)->portInfo.outputs[(port)].attributes.optimOpts )
# define ssSetOutputPortOptimOpts(S,port,val) \
       ( (S)->portInfo.outputs[(port)].attributes.optimOpts = (val) )


/* OutputPortOptimizeInIR - This macro allows S-Functions that use the code
 * generation intermediate representation (CGIR) to generate code, to enable
 * optimizations on for the output port that would otherwise be disabled by
 * default. For example, the macro should be used if a S-Function set its
 * output port conservatively as global, because it is accessed in both the
 * output and the update function. It is possible for CGIR to safely optimize
 * the port signal if output and update get combined.
 */
# define ssGetOutputPortOptimizeInIR(S,port) \
    ( (S)->portInfo.outputs[(port)].attributes.optimizeInIR )
# define ssSetOutputPortOptimizeInIR(S,port,val) \
    ( (S)->portInfo.outputs[(port)].attributes.optimizeInIR = (val) )


 /* OutputPortBeingMerged - If this output port signal of the S-Function is
  * being merged with other signals (this happens if the S-Function block
  * output port is directly or via connection type blocks is connected to a
  * Merge block), then the macro below will return "true". This macro will
  * return the correct answer in and after the S-Function's mdlSetWorkWidths()
  * method.
  */
# define ssGetOutputPortBeingMerged(S,port) \
         ( (S)->portInfo.outputs[(port)].attributes.cToMergeBlk == 1U )
# define _ssSetOutputPortBeingMerged(S,port,val) \
         (S)->portInfo.outputs[(port)].attributes.cToMergeBlk = (val) ? 1U : 0U
# if !SS_SFCN
#   define ssSetOutputPortBeingMerged(S,port,val) \
           _ssSetOutputPortBeingMerged(S,port,val)
# else
#   define ssSetOutputPortBeingMerged(S,port,val) \
            ssSetOutputPortBeingMerged_cannot_be_used_in_SFunctions
# endif

 /* OutputPortConstOutputExprInRTW - Specify that the output signal is a constant
  * expression in RTW (versus a statement).  This allows a downstream block
  * to fold the expression into its calculation no matter how many destinations
  * the block has.  Note that Simulink may not honor this setting, in which case
  * the block must produce a statement.
  */
# define ssGetOutputPortConstOutputExprInRTW(S,port) \
   ((S)->portInfo.outputs[(port)].attributes.constOutputExprInRTW == 1U)
# define ssSetOutputPortConstOutputExprInRTW(S,port,val) \
   ((S)->portInfo.outputs[(port)].attributes.constOutputExprInRTW = (val) ? \
   ((S)->portInfo.outputs[(port)].attributes.trivialOutputExprInRTW = \
    (S)->portInfo.outputs[(port)].attributes.outputExprInRTW = 1U) : 0U)


 /* OutputPortTrivialOutputExprInRTW - Specify that the output signal is a trivial
  * expression in RTW (versus a statement).  This allows a downstream block
  * to fold the expression into its calculation no matter how many destinations
  * the block has.  Note that Simulink may not honor this setting, in which case
  * the block must produce a statement.
  */
# define ssGetOutputPortTrivialOutputExprInRTW(S,port) \
   ((S)->portInfo.outputs[(port)].attributes.trivialOutputExprInRTW == 1U)
# define ssSetOutputPortTrivialOutputExprInRTW(S,port,val) \
   ((S)->portInfo.outputs[(port)].attributes.trivialOutputExprInRTW = (val) ? \
   ((S)->portInfo.outputs[(port)].attributes.outputExprInRTW = 1U) : \
   ((S)->portInfo.outputs[(port)].attributes.constOutputExprInRTW = 0U))

 /* OutputPortOutputExprInRTW - Specify that the output signal is an expression
  * in RTW (versus a statement).  This allows a downstream block to fold
  * the expression into its calculation.  Note that Simulink may not honor
  * this setting, in which case the block must produce a statement.
  */
# define ssGetOutputPortOutputExprInRTW(S,port) \
   ((S)->portInfo.outputs[(port)].attributes.outputExprInRTW == 1U)
# define ssSetOutputPortOutputExprInRTW(S,port,val) \
   ((S)->portInfo.outputs[(port)].attributes.outputExprInRTW = (val) ? 1U : \
   ((S)->portInfo.outputs[(port)].attributes.trivialOutputExprInRTW = \
    (S)->portInfo.outputs[(port)].attributes.constOutputExprInRTW = 0U))

#if defined(RTW_GENERATED_S_FUNCTION) || SS_SL_INTERNAL
 /* OutputPortIsNonContinuous - Specify that the output port signal is
  * noncontinuous (i.e. has a discontinuity even if the sample time is
  * continuous).  This setting is used to determine what noncontinuous
  * signals to track during simulation.  It is false by default.
  */
# define ssGetOutputPortIsNonContinuous(S,port) \
       ( (S)->portInfo.outputs[(port)].attributes.nonContPort )
# define ssSetOutputPortIsNonContinuous(S,port,val) \
       ( (S)->portInfo.outputs[(port)].attributes.nonContPort = \
         (val) ? 1U : 0U)

/*
 * Specify that the output port is being driven by a block
 * with modes but no zero-crossings.  We need this for model
 * reference to determine if DerivCacheNeedsReset is true.
 */
# define ssGetOutputPortIsFedByBlockWithModesNoZCs(S,port) \
       ( (S)->portInfo.outputs[(port)].attributes.fedByBlockWithModesNoZCs )
# define ssSetOutputPortIsFedByBlockWithModesNoZCs(S,port,val) \
       ( (S)->portInfo.outputs[(port)].attributes.fedByBlockWithModesNoZCs = \
         (val) ? 1U : 0U)
#endif

 /* OutputDataType - For each output port of your S-function block, this is the
  *   data type. If no data types is specified, then the default is real_T.
  */
# define ssGetOutputPortDataType(S,port) \
          (S)->portInfo.outputs[(port)].dataTypeId          /* (DTypeId)     */
# define ssSetOutputPortDataType(S,port,dTypeId) \
          ((S)->portInfo.outputs[(port)].dataTypeId= (dTypeId))

typedef enum {
    SS_DATA_DESC_OUTPUT,
    SS_DATA_DESC_INPUT,
    SS_DATA_DESC_RTP,
    SS_DATA_DESC_DWORK
} SSDataDescType;

#define ssRegisterDataMinMaxPrmIndices(S,dataDescType,dataIdx,prmMinIdx,prmMaxIdx)    \
    { \
        int _moreArgs[3] = { (int) (dataDescType), (prmMinIdx), (prmMaxIdx) }; \
        _ssSafelyCallGenericFcnStart(S)((S),                            \
            GEN_FCN_REGISTER_DATA_MIN_MAX_PRM_INDICES, (dataIdx), _moreArgs) \
        _ssSafelyCallGenericFcnEnd; \
    }

/*
 * Register dialog parameters indexed as prmMinIdx and prmMaxIdx as design
 * minimum and maximum for the output port of index portIdx.
 */
#define ssRegisterOutputPortMinMaxPrmIndices(S,portIdx,prmMinIdx,prmMaxIdx)        \
    ssRegisterDataMinMaxPrmIndices((S),SS_DATA_DESC_OUTPUT,(portIdx),(prmMinIdx),(prmMaxIdx))


/*
 * Set the output port min/max values.  This is used by Stateflow and other S-Functions
 * in which min/max values are not Parameters with indices.  In case of Stateflow,
 * the min/max values are data properties.
 * This API and ssRegisterOutputPortMinMaxPrmIndices() are mutually exclusive!
 */
typedef struct outputPortMinMaxStruct_t {
    int    dataDescType;
    double designMin;
    double designMax;
} outputPortMinMaxStruct;

#define ssSetOutputPortMinMaxValues(S,portIdx,minValue,maxValue) \
    { \
        outputPortMinMaxStruct _moreArgs = { (int)(SS_DATA_DESC_OUTPUT), minValue, maxValue }; \
        _ssSafelyCallGenericFcnStart(S)((S),  \
            GEN_FCN_SET_DATA_MIN_MAX_VALUES, (portIdx), (void*) &_moreArgs) \
        _ssSafelyCallGenericFcnEnd; \
    }


 /* OutputComplexSignal - For each input port or your S-function block, this is
  *   whether or not the outgoing signal is complex, where (-1=either, 0=no,
  *   1=yes).
  */
# define ssGetOutputPortComplexSignal(S,port) \
          (S)->portInfo.outputs[(port)].complexSignal         /* (CSignal_T)  */
# define ssSetOutputPortComplexSignal(S,port,val) \
          (S)->portInfo.outputs[(port)].complexSignal = (val)

 /* OutputPortSignal - This is the pointers to the signal vector for each
  *   output port.  For example to write to all outputs with int16_T data
  *   type:
  *       nOutputPorts = ssGetNumOutputPorts(S);
  *       for (i = 0; i < nOutputPorts; i++) {
  *         int16_T  *y = (int16_T *)ssGetOutputPortSignal(S,i);
  *         int_T ny    = ssGetOutputPortWidth(S,i);
  *         for (j = 0; j < ny; j++) {
  *           SomeFunctionToFillInOutput(y[j]);
  *         }
  *       }
  *   If you know that the output is always a real_T, then the
  *   ssGetOutputPortSignal line would be:
  *       real_T *y  = ssGetOutputPortRealSignal(S,i);
  */
# define ssGetOutputPortSignal(S,port) \
           (S)->portInfo.outputs[(port)].signalVect       /* (void *)        */
# define ssGetOutputPortRealSignal(S,port) \
           ((real_T*)(S)->portInfo.outputs[ \
                                     (port)].signalVect)  /* (real_T*)       */
# define _ssSetOutputPortSignal(S,port,vect) \
           (S)->portInfo.outputs[(port)].signalVect = (vect)
# if !SS_SFCN
#   define ssSetOutputPortSignal(S,port,vect) \
           _ssSetOutputPortSignal(S,port,vect)
# else
#   define ssSetOutputPortSignal(S,port,vect) \
           ssSetOutputPortSignal_cannot_be_used_in_SFunctions
# endif

 /* OutputPortConnected - Is the output connected to a non-virtual block (i.e.
  *   are the signals leaving the S-function block driving other blocks)?
  */
# define ssGetOutputPortConnected(S,port) \
          (S)->portInfo.outputs[(port)].connected             /* (int_T) */
# define _ssSetOutputPortConnected(S,port,val) \
          (S)->portInfo.outputs[(port)].connected = (val)
# if !SS_SFCN
#   define ssSetOutputPortConnected(S,port,val) \
            _ssSetOutputPortConnected(S,port,val)
# else
#   define ssSetOutputPortConnected(S,port,val) \
            ssSetOutputPortConnected_cannot_be_used_in_SFunctions
# endif

 /* OutputPortSampleTime/OutputPortOffsetTime - The sample and offset time of
  *   the output port. This should only be used when PORT_BASED_SAMPLE_TIMES
  *   have been specified for ssSetNumSampleTimes in mdlInitializeSizes.
  * OutputPortSampleTimeIndex - index of the sample time for the port to
  *   be used in mdlOutputs, mdlUpdate when checking for sample hits.
  */
# define ssGetOutputPortSampleTime(S,port) \
          ((S)->portInfo.outputs[(port)].sampleTime)        /* (real_T)      */
# define ssSetOutputPortSampleTime(S,port,val) \
          (S)->portInfo.outputs[(port)].sampleTime = (val)  /* (real_T)      */
# define ssGetOutputPortOffsetTime(S,port) \
          ((S)->portInfo.outputs[(port)].offsetTime)        /* (real_T)      */
# define ssSetOutputPortOffsetTime(S,port,val) \
          (S)->portInfo.outputs[(port)].offsetTime = (val)  /* (real_T)      */

# define ssGetOutputPortSampleTimeIndex(S,port) \
          (S)->portInfo.outputs[(port)].sampleTimeIndex     /* (int_T)       */
# define _ssSetOutputPortSampleTimeIndex(S,port,idx) \
          (S)->portInfo.outputs[(port)].sampleTimeIndex = (idx) /* (int_T)   */
# if !SS_SFCN
#   define ssSetOutputPortSampleTimeIndex(S,port,idx) \
            _ssSetOutputPortSampleTimeIndex(S,port,idx)
# else
#   define ssSetOutputPortSampleTimeIndex(S,port,idx) \
            ssSetOutputPortSampleTimeIndex_cannot_be_used_in_SFunctions
# endif

/*
 * Routines to allow the S-function to map a block IC parameter to
 * its output port.
 */
#define ssGetOutputPortInitialOutputParamIdx(S,port) \
          ((S)->portInfo.outputs[(port)].icPrmIdxPlus1 - 1)
#define ssSetOutputPortInitialOutputParamIdx(S,port,val) \
          (S)->portInfo.outputs[(port)].icPrmIdxPlus1 = ((int_T) val + 1)

 /*
  * Routines to setup the fcn and arg which allow the S-function to register
  * the input/output port properties.
  */
# define ssSetRegNumInputPortsFcn(S,fcn) \
            (S)->portInfo.regNumInputPortsFcn = fcn
# define ssSetRegNumInputPortsFcnArg(S,arg) \
            (S)->portInfo.regNumInputPortsFcnArg = arg
# define ssSetRegNumOutputPortsFcn(S,fcn) \
            (S)->portInfo.regNumOutputPortsFcn = fcn
# define ssSetRegNumOutputPortsFcnArg(S,arg) \
            (S)->portInfo.regNumOutputPortsFcnArg = arg
#endif
/* END long level 1 exclusion */



/*
 * Set any S-function options which must be OR'd together.
 * For example:  ssSetOptions(S, SS_OPTION_EXCEPTION_FREE_CODE |
 *                              SS_OPTION_DISCRETE_VALUED_OUTPUT);
 *
 * The available options are:
 * SS_OPTION_EXCEPTION_FREE_CODE - if your S-function does not use
 *   mexErrMsgTxt, mxCalloc, or any other routines which can throw an
 *   exception when called, you can set this option for improved
 *   performance.
 *
 * SS_OPTION_RUNTIME_EXCEPTION_FREE_CODE - Similar to
 *   SS_OPTION_EXCEPTION_FREE_CODE except it only applies to the "run-time"
 *   routines: mdlGetTimeOfNextVarHit, mdlOutputs, mdlUpdate, and
 *   mdlDerivatives.
 *
 * SS_OPTION_DISCRETE_VALUED_OUTPUT - This should be specified if your
 *   S-function has a discrete valued outputs.  This is checked when
 *   your S-function is placed within an algebraic loop. If your S-function
 *   has discrete valued outputs, then its outputs will not be assigned
 *   algebraic variables.
 *
 * SS_OPTION_PLACE_ASAP - This is used to specify that your S-function
 *   should be placed as soon as possible. This is typically used by
 *   devices connecting to hardware.
 *
 * SS_OPTION_ALLOW_INPUT_SCALAR_EXPANSION - This is used to specify
 *   that the input to your S-function input ports can be either 1 or
 *   the size specified by the port which is usually referred to as
 *   the block width.
 *
 * SS_OPTION_DISALLOW_CONSTANT_SAMPLE_TIME - This is used to disable
 *   your S-function block from inheriting a constant sample time.
 *
 * SS_OPTION_ASYNCHRONOUS - This option applies only to S-functions that
 *   have no input ports during code generation and 1 output port.
 *   During simulation, the S-function may have an input port to provide
 *   a condition on which to execute. The output port must be configured to
 *   perform function calls on every element.  If any of these requirements
 *   are not met, the SS_OPTION_ASYNCHRONOUS is ignored.  Use this option
 *   when driving function-call subsystems that will be attached to
 *   asynchronous tasks. Specifying this
 *     1) Informs Simulink that there is no implied data dependency involving
 *        the data sources or destinations of the function-call subsystem called
 *        by the S-function.
 *     2) Causes the function-call subsystem attached to the S-function to be
 *        colored cyan indicating that it does not execute at a periodic rate.
 *     3) Enables additional checks to verify that the model is
 *        constructed correctly:
 *          a) Simulink validates that the appropriate asynchronous rate
 *             transition blocks reside between the (cyan) function-call
 *             subsystem and period tasks exists. You can always directly
 *             read & write from the function-call subsys by using a block
 *             similar to the 'vxlib/Asynchronous Support/Rate Transition'
 *             block that has no computational overhead (look at the Tag value
 *             on the Outport block within the Rate Transition masked
 *             subsystem). Safe task transitions between period and
 *             asynchronous tasks are created by using the
 *             SS_OPTION_ASYNC_RATE_TRANSITION.
 *             See the 'vxlib/Asynchronous Support' library.
 *          b) For data transfers between two asynchronously executed (cycan)
 *             function-call subsystem, Simulink validates that the appropriate
 *             asynchronous task transition blocks exits.
 *             See the 'vxlib/Asynchronous Support' library.
 *
 * SS_OPTION_ASYNCHRONOUS_INTERRUPT - This option is very similar to
 *   SS_OPTION_ASYNCHRONOUS. This option adds the restriction that the
 *   this S-function and the destination function-call subsystem cannot reside
 *   in conditionally executed subsystems. This option should be used when the
 *   destination function-call subsystem is going to be directly attached to an
 *   interrupt. This added restriction is useful to prevent conceptual modeling
 *   errors. Specifically, if an function-call subsystem resides within an
 *   enabled subsystem, you would assume that it will only execute occur when
 *   the enable signal is > 0, but this would not be the behavior if the
 *   function-call subsystem were to be attached to an interrupt. Therefore
 *   this option prevents this possible source of confusion.
 *   Note, during simulation (and not code generation), Simulink allows the
 *   S-function to reside in a conditionally executed subsystem. See the
 *   VxWorks interrupt block for an example - in simulation we use a
 *   triggered subsystem to simulate the interrupt and during code generation
 *   the trigger port is removed.
 *
 *
 * SS_OPTION_ASYNCHRONOUS_CUSTOM - Similar to SS_OPTION_ASYNCHRONOUS, except
 *   items 3a, 3b are removed.
 *
 * SS_OPTION_ASYNC_RATE_TRANSITION - Use this when your s-function converts a
 *   guarantees data integrity when transferring data to/from an
 *   asynchronously executed function-call subsystem. There are two types
 *   of data transfers: periodic to asynchronous task transitions or
 *   asynchronous to asynchronous task transitions. An asynchronously executed
 *   function-call subsystem is a function-call subsystem driven by an
 *   S-function with the SS_OPTION_ASYNCHRONOUS specified.
 *
 *   Within Simulink, two classes of 'asynchronous rate transitions' are
 *   defined:
 *   1) Read-write pairs. In this scenario, two blocks (using a technique
 *      such as double buffering) ensure data integrity in a multitasking
 *      environment. When creating the read-write pair of blocks, the
 *      S-functions for these blocks should set SS_OPTION_ASYNC_RATE_TRANSITION.
 *      Furthermore, the Mask Type for the read block, must include
 *      the string 'read' and the write block must include the string 'write'.
 *      For example, in the VxWorks library, we have the
 *        Asynchronous Rate Transition (Reader)
 *        Asynchronous Rate Transition (Writer)
 *      pairs.
 *   2) A single (protected or unprotected) block such as the
 *      VxWorks, Unprotected Asynchronous Rate Transition block.
 *      To create a single Protected Rate Transition block, you
 *      need to create a block like:
 *        +-------------------+
 *        |     +-------+     |
 *        | O-->| S-fcn |-->O |--->
 *        |     +-------+     |
 *        +-------------------+
 *      where the outport has a Tag value set to AsyncRateTransition
 *      and the S-function provides the code for the protected
 *      transition. Note, this S-function should not set the
 *      SS_OPTION_ASYNC_RATE_TRANSITION.
 *
 *
 * SS_OPTION_RATE_TRANSITION - Use this while your S-function is behaving
 *   as a unit delay or ZOH. This option is only supported for these two
 *   operations. A unit delay operation is identified by the presence
 *   of mdlUpdate and if not present then the operation is ZOH.
 *
 * SS_OPTION_NONSTANDARD_PORT_WIDTHS - If your S-function has mdl
 *   set input/output port routines with dynamically sized ports and the port
 *   widths don't follow the standard rules of scalar expansion or
 *   vector collapsing, then you may need to set this flag for Simulink.
 *   This usually occurs when the output width is not 1 and not equal to the
 *   maximum of the input widths.
 *
 * SS_OPTION_PORT_SAMPLE_TIMES_ASSIGNED - Use this when you have
 *   registered multiple sample times (ssSetNumSampleTimes > 1) to
 *   specify the rate at when each input and output port is running at.
 *   The simulation engine needs this information when checking for
 *   illegal rate transitions.
 *
 * SS_OPTION_SFUNCTION_INLINED_FOR_RTW - Set this if you have a .tlc file
 *   for your S-function and do not have a mdlRTW method. Setting option
 *   has no effect if you have a mdlRTW method. This option is like an
 *   assertion. During code generation, if this option is set and
 *   Real-Time Workshop cannot locate the TLC-file for the S-function,
 *   Real-Time Workshop will generate and error. If this option is not present
 *   and Real-Time Workshop locates a TLC-file for the S-function, it will be
 *   used.
 *
 * SS_OPTION_ALLOW_PARTIAL_DIMENSIONS_CALL - Use this if the block can
 *   handle partially known dimensions in the mdlSetInputPortDimensionInfo
 *   or mdlSetOutputPortDimensionInfo methods.  By default, Simulink
 *   calls mdlSetInput(Output)PortDimensionInfo methods, if the
 *   candidate port dimensions are fully known. That is, when the number of
 *   dimensions and dimensions are known. If this flag is set, Simulink may
 *   call mdlSetInput(Output)PortDimensionInfo with partial dimension
 *   information.  As an example, the methods may be called when the port
 *   width is known, but the actual dimensions are unknown.
 *
 *
 * SS_OPTION_ADA_S_FUNCTION - Used to interface with Ada Coded S-functions.
 *   Not relevant for C-Mex S-Functions.
 *
 * SS_OPTION_FORCE_NONINLINED_FCNCALL - Use this flag if the block requires
 *   that all function-call subsystems that it calls should be generated as
 *   procedures instead of possibly being generated as inlined code.
 *
 * SS_OPTION_USE_TLC_WITH_ACCELERATOR -  Use this to force the Accelerator
 *   to use the TLC inlining code for a S-function which will speed up
 *   execution of the S-function.  By default, the Accelerator will use
 *   the mex version of the S-function even though a TLC file for the
 *   S-function exists. This option should not be set for device driver
 *   blocks (A/D) or when there is an incompatibility between running the
 *   mex Start/InitializeConditions functions together with the TLC
 *   Outputs/Update/Derivatives.
 *
 * SS_OPTION_SIM_VIEWING_DEVICE - This s-function is a SimViewingDevice.  As
 *   long as it meets the other requirement for this type of block (no states,
 *   no outputs, etc), it will be considered to be an external mode block
 *   (show up in the external mode gui and no code is generated for it).
 *   During an external mode simulation, this block is run on the host only.
 *
 * SS_OPTION_SIM_INPUT_DEVICE - Mark this s-function as a SimInputDevice.  When
 *   this option is set and this s-function registered an mdlExtModeExec fcn,
 *   then it will be run in external mode.
 *
 * SS_OPTION_CALL_TERMINATE_ON_EXIT - Use this to force a call to mdlTerminate
 *   when (a) the S-function block has finished mdlWorkWidths, or (b) the
 *   S-function block is being destroyed.
 *
 * SS_OPTION_REQ_INPUT_SAMPLE_TIME_MATCH - Use this to option to specify
 *   that the input signal sample time(s) match the sample time assigned
 *   to the block input port. For example:
 *
 *      .-----------.           .---------------------------.
 *      |  src (.1) |---------->|  port based Ts S-fcn with |
 *      `-----------'           |  input Ts = 1             |
 *                              `---------------------------'
 *
 *   will generate an error if this option is set. If the block (or input port)
 *   sample time is inherited, then there will be no error generated.
 *
 * SS_OPTION_NONVOLATILE - Use this option to specify whether this s-function
 *   has side effects.  Set this option to request that Simulink remove
 *   this block if it is not needed (dead code).
 *
 * SS_OPTION_CAN_BE_CALLED_CONDITIONALLY - Use this option if the s-function
 *   can be called conditionally by other blocks.
 *
 * SS_OPTION_ALLOW_PORT_SAMPLE_TIME_IN_TRIGSS - Use this to specify that
 *   your port based sample time S-Function can handle being placed in a
 *   triggered like subsystem (e.g. triggered, function call, for, while).
 *   During sample time propagation use the macro ssSampleAndOffsetAreTriggered
 *   to determine if the sample and offset times correspond to the block
 *   being in a triggered subsystem. If the block is triggered, all port
 *   sample times must be either triggered or constant.
 *
 * SS_OPTION_ALLOW_CONSTANT_PORT_SAMPLE_TIME - Use this option to specify
 *   that your port-based sample time S-Function can handle constant sample
 *   times. This option is required whether the S-Function is going to
 *   originate the constant sample time or can have one propagated to it.
 *
 * SS_OPTION_WORKS_WITH_CODE_REUSE - Use this option to specify that your
 *   S-Function will work in a system that is being reused in RTW
 *   generated code.  If this option is not set, then the system that
 *   this S-Function lives in will not be reused.
 *
 * SS_OPTION_SUPPORTS_ALIAS_DATA_TYPES - This is used to state whether
 *   or not this block supports alias data types
 *
 * SS_OPTION_NO_INFLUENCE_ON_DEFAULT_MDL_DIMS - When dimensions propagation
 * to converge to a set of dimensions, blocks are queried individually
 * to setup their default dimensions. In the case of the S-function, this is
 * done by calling the mdlSetDefaultPortDimensions function. If the S-function
 * has no clear means of identifying a default set of dimensions, please
 * use this flag to postpone calls to mdlSetDefaultPortDimensions.
 */
#if SS_SFCN_LEVEL_1 || !SS_SFCN
# define SS_OPTION_USING_ssGetUPtrs              0x00000001
#endif

#define SS_OPTION_EXCEPTION_FREE_CODE            0x00000002
#define SS_OPTION_DISCRETE_VALUED_OUTPUT         0x00000004

#if !SS_SFCN_LEVEL_1
# define SS_OPTION_PLACE_ASAP                    0x00000008
# define SS_OPTION_ALLOW_INPUT_SCALAR_EXPANSION  0x00000010
# define SS_OPTION_DISALLOW_CONSTANT_SAMPLE_TIME 0x00000020
# define SS_OPTION_ASYNCHRONOUS                  0x00000040
# define SS_OPTION_ASYNC_RATE_TRANSITION         0x00000080
# define SS_OPTION_RUNTIME_EXCEPTION_FREE_CODE   0x00000100
# define SS_OPTION_RATE_TRANSITION               0x00000200
# define SS_OPTION_NONSTANDARD_PORT_WIDTHS       0x00000400
# define SS_OPTION_PORT_SAMPLE_TIMES_ASSIGNED    0x00000800
# define SS_OPTION_SFUNCTION_INLINED_FOR_RTW     0x00001000
                                          /* !!! 0x00002000 used below !!! */
# define SS_OPTION_ALLOW_PARTIAL_DIMENSIONS_CALL 0x00004000
# define SS_OPTION_NO_INFLUENCE_ON_DEFAULT_MDL_DIMS  0x00008000
# define SS_OPTION_ADA_S_FUNCTION                0x00010000
# define SS_OPTION_FORCE_NONINLINED_FCNCALL      0x00020000
                                          /* !!! 0x00040000 used below !!! */
# define SS_OPTION_USE_TLC_WITH_ACCELERATOR      0x00080000
# define SS_OPTION_SIM_VIEWING_DEVICE            0x00100000
# define SS_OPTION_CALL_TERMINATE_ON_EXIT        0x00200000
# define SS_OPTION_REQ_INPUT_SAMPLE_TIME_MATCH   0x00400000
# define SS_OPTION_ASYNCHRONOUS_CUSTOM           0x00800000
# define SS_OPTION_NONVOLATILE                   0x01000000
# define SS_OPTION_CAN_BE_CALLED_CONDITIONALLY   0x02000000
# define SS_OPTION_ALLOW_PORT_SAMPLE_TIME_IN_TRIGSS 0x04000000
# define SS_OPTION_ALLOW_CONSTANT_PORT_SAMPLE_TIME 0x08000000
# define SS_OPTION_ASYNCHRONOUS_INTERRUPT        0x10000000
# define SS_OPTION_WORKS_WITH_CODE_REUSE         0x20000000
# define SS_OPTION_SUPPORTS_ALIAS_DATA_TYPES     0x40000000
# define SS_OPTION_SIM_INPUT_DEVICE              0x80000000
#endif

/*
 * SS_OPTION_SUPPORTS_MULTITASKING is a flag for Simulink and is *not* to
 * be used by S-functions.
 */
#define SS_OPTION_SUPPORTS_MULTITASKING          0x00002000

/*
 * SS_OPTION_PROPAGATE_COMPOSITE_SYSTEM is a flag for Simulink and is *not*
 * to be used by S-functions.
 */
#define SS_OPTION_PROPAGATE_COMPOSITE_SYSTEM     0x00040000

#define SS_HAVEOPT(S,opt) ((ssGetOptions(S) & opt) != 0)

#define ssGetOptions(S) \
          (S)->sizes.options                      /*   (uint_T)      */
#define ssSetOptions(S,opts) \
          (S)->sizes.options = (opts)


#define ssGetRTModel(S) (S)->sizes.rtModel
#define ssSetRTModel(S, rtm) (S)->sizes.rtModel = ((void *)(rtm))

/*-------------------------------- S->sfcnParams ---------------------------*/

/* Macros for manipulating dialog parameters */

/*
 * ssGetSFcnParamsCount is provided for use by S-functions to determine
 * the number of parameters entered by the user in the S-function dialog box.
 */
#define ssGetSFcnParamsCount(S) \
          (S)->sfcnParams.dlgNum                          /*   (int_T)       */
#define _ssSetSFcnParamsCount(S,n) \
          (S)->sfcnParams.dlgNum = (n)
#if !SS_SFCN
#define ssSetSFcnParamsCount(S,n) _ssSetSFcnParamsCount(S,n)
#else
#define ssSetSFcnParamsCount(S,n) \
          ssSetSFcnParamsCount_cannot_be_used_in_SFunctions
#endif


/* SFcnParams - This is a list of MyArray pointers corresponding to the
 *   S-function parameters supplied to your S-function. This is not
 *   used by the root SimStruct.
 */
#define _ssGetSFcnParamsPtr(S) \
          (S)->sfcnParams.dlgParams                       /*   (mxArray **)  */
/* GCC 4.X issues warning when using conventional C-style cast in C++ code */
#ifdef __cplusplus
#define ssGetSFcnParamsPtr(S) \
          (const_cast<const mxArray **>(_ssGetSFcnParamsPtr(S)))     /* (const mxArray **) */
#else
#define ssGetSFcnParamsPtr(S) \
          ((const mxArray **) _ssGetSFcnParamsPtr(S))     /* (const mxArray **) */
#endif
#define _ssSetSFcnParamsPtr(S,ptr) \
          (S)->sfcnParams.dlgParams = (ptr)
#if !SS_SFCN
#define ssSetSFcnParamsPtr(S,ptr) _ssSetSFcnParamsPtr(S,ptr)
#else
#define ssSetSFcnParamsPtr(S,ptr) \
         ssSetSFcnParamsPtr_cannot_be_used_in_SFunctions
#endif

/* Use ssGetSFcnParam(S,index) to access S-function parameters from within
 * S-functions. The index starts at 0, which corresponds to the (index+1)'th
 * parameter.
 */
#define _ssGetSFcnParam(S,index) \
          (S)->sfcnParams.dlgParams[index]                /*   (mxArray *)   */
#define ssGetSFcnParam(S,index) \
          ((const mxArray *) _ssGetSFcnParam(S,index))    /* (const mxArray *) */
#define _ssSetSFcnParam(S,index,mat) \
          (S)->sfcnParams.dlgParams[index] = (mat)
#if !SS_SFCN
#define ssSetSFcnParam(S,index,mat) _ssSetSFcnParam(S,index,mat)
#else
#define ssSetSFcnParam(S,index,mat) ssSetSFcnParam_cannot_be_used_in_SFunctions
#endif

#if SS_SL_INTERNAL || SS_SFCN_FOR_SIM
/*
 * ssGetSFcnParamName(S, paramNumber, &busName)
 * This can be used to get the name of any parameter specified on the dialog of the
 * s-function block.
 */
#define ssGetSFcnParamName(S, pIdx, result) \
 _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_GET_PARAM_NAME, pIdx, (result))\
 _ssSafelyCallGenericFcnEnd
#else
#define ssGetSFcnParamName(S, pIdx, result)
#endif

#define ssGetSFcnParamDataType(S,index,result) \
{ _ssSafelyCallGenericFcnStart(S) \
        (S, GEN_FCN_GET_PARAM_DATATYPE, (index), (result)) \
      _ssSafelyCallGenericFcnEnd; \
}

/* ssSetSFcnParamTunable - This should be used by S-function blocks
 *   to specify when a parameter is tunable or not tunable.
 */
#if SS_SL_INTERNAL || SS_SFCN_FOR_SIM
# define ssSetSFcnParamNotTunable(S,index) \
          (S)->sfcnParams.dlgAttribs[index] = \
            ((S)->sfcnParams.dlgAttribs[index] | SFCNPARAM_NOT_TUNABLE)
#else /* RT or NRT */
# define ssSetSFcnParamNotTunable(S,index) /* do nothing */
#endif
/*
 * ssSetSFcnParamTunable
 */
#if SS_SL_INTERNAL || SS_SFCN_FOR_SIM
# define ssSetSFcnParamTunable(S,index,val) \
  (S)->sfcnParams.dlgAttribs[index] = (((ssParamTunability)val) == SS_PRM_TUNABLE) ? \
    (((S)->sfcnParams.dlgAttribs[index] & SFCNPARAM_CLEAR_TUNABLE) \
         | SFCNPARAM_TUNABLE) : \
    ((((ssParamTunability)val) == SS_PRM_SIM_ONLY_TUNABLE) ? \
    (((S)->sfcnParams.dlgAttribs[index] & SFCNPARAM_CLEAR_TUNABLE) \
         | SFCNPARAM_SIMONLY_TUNABLE) : \
    (((S)->sfcnParams.dlgAttribs[index] & SFCNPARAM_CLEAR_TUNABLE) \
         | SFCNPARAM_NOT_TUNABLE))
#else /* RT or NRT */
# define ssSetSFcnParamTunable(S, index, boolval) /* do nothing */
#endif

# define ssGetSFcnParamTunable(S,index) \
          ((S)->sfcnParams.dlgAttribs[index] & SFCNPARAM_TUNABLE)

# define ssGetSFcnParamSimOnlyTunable(S,index) \
          ((S)->sfcnParams.dlgAttribs[index] & SFCNPARAM_SIMONLY_TUNABLE)

#if SS_SL_INTERNAL || (SS_SIM && SS_GENERATED_S_FUNCTION)
# define ssGetSFcnParamsNotTunable(S,index) \
          ((S)->sfcnParams.dlgAttribs[index] & SFCNPARAM_NOT_TUNABLE)

# define ssGetSFcnParamAttribsPtr(S) \
          (S)->sfcnParams.dlgAttribs
# define ssSetSFcnParamAttribsPtr(S,ptr) \
          (S)->sfcnParams.dlgAttribs = (ptr)
#endif


/* Macros for checking values entered for S-Function parameters */
# define _ssCacheSFcnParamValueAttribs(pName, dtId, nDims, dimsPtr, cplx) \
     ssParamRec locPI; \
     locPI.name             = pName; \
     locPI.nDimensions      = nDims; \
     locPI.dimensions       = dimsPtr; \
     locPI.complexSignal    = cplx; \
     locPI.dataTypeId       = dtId; \
     locPI.data             = NULL; \
     locPI.dataAttributes   = NULL; \
     locPI.nDlgParamIndices = 0; \
     locPI.dlgParamIndices  = NULL; \
     locPI.transformed      = RTPARAM_NOT_TRANSFORMED; \
     locPI.outputAsMatrix   = false;

#define ssCheckSFcnParamValueAttribs(S,pIdx,pName,dtId,nDims,dimsPtr,cplx) \
   { \
      _ssCacheSFcnParamValueAttribs(pName, dtId, nDims, dimsPtr, cplx) \
      if (!_ssSafelyCallGenericFcnStart(S)(S, \
GEN_FCN_CHECK_SFCN_PARAM_VALUE_ATTRIBS, pIdx, &locPI) \
      _ssSafelyCallGenericFcnEnd) return; \
   }


/* ======================================================================
 *  Macros for manipulating run-time parameters.
 * ======================================================================
 * The most commonly used macros are:
 * - ssSetNumRunTimeParams
 *   ==> To set the number of run-time parameters (before registering run-time parameters)
 *
 * - ssRegAllTunableParamsAsRunTimeParams
 *   ==> To register all tunable SFcnParams as run-time parameters (in mdlSetWorkWidths)
 * - ssRegDlgParamAsRunTimeParam
 *   ==> To register specific SFcnParam as a run-time parameter (in mdlSetWorkWidths)
 *       This macro will perform data type conversion if necessary
 *
 * - ssUpdateAllTunableParamsAsRunTimeParams
 * - ssUpdateDlgParamAsRunTimeParam
 *   ==> To update values of run-time parameters during simulation (in mdlProcessParameters)
 */
#define ssGetNumRunTimeParams(S) (S)->sfcnParams.numRtp.numRtp

#define _ssSetNumRunTimeParams(S, num) \
         (S)->sfcnParams.numRtp.numRtp = (num)

#define _ssSafelyCallGenericFcnStart(S) \
       (((S)->mdlInfo->genericFcn==NULL) ? 0 : ((*(S)->mdlInfo->genericFcn)
#define _ssSafelyCallGenericFcnEnd ))

#if SS_SFCN
#  if SS_RTW
#   define ssSetNumRunTimeParams(S, num) _ssSetNumRunTimeParams(S, num)
#  else
#   define ssSetNumRunTimeParams(S, num) \
       _ssSafelyCallGenericFcnStart(S)(S, GEN_FCN_SET_NUM_RUN_TIME_PARAMS,num,NULL)\
       _ssSafelyCallGenericFcnEnd
#  endif
#endif

#define ssGetRunTimeParamInfo(S, idx) (S)->sfcnParams.rtp[idx]

#define _ssSetRunTimeParamInfo(S, idx, p) (S)->sfcnParams.rtp[idx] = (p)

#if SS_SFCN
#  if SS_RTW
#    define ssSetRunTimeParamInfo(S, idx, p) _ssSetRunTimeParamInfo(S, idx, p)
#  else
#    define ssSetRunTimeParamInfo(S, idx, p) \
       _ssSafelyCallGenericFcnStart(S)(S, GEN_FCN_REG_RUN_TIME_PARAM, idx,(void *)p)\
       _ssSafelyCallGenericFcnEnd
#    define ssSetConstRunTimeParamInfo(S, idx, p) \
       _ssSafelyCallGenericFcnStart(S)(S, GEN_FCN_REG_CONST_RUN_TIME_PARAM, \
                                   idx,(void *)p)\
       _ssSafelyCallGenericFcnEnd
#  endif
#endif

#if SS_SFCN && SS_SIM
#    define ssSetStateflowIsInlinable(S, p) \
       _ssSafelyCallGenericFcnStart(S)(S, GEN_FCN_SF_INLINABLE, p, NULL)\
       _ssSafelyCallGenericFcnEnd
#endif

#if SS_SFCN && SS_SIM
#    define ssSetOutputFcnCalledMultiple(S, p) \
       _ssSafelyCallGenericFcnStart(S)(S, \
          GEN_FCN_SET_OUTPUT_FCN_CALLED_MULTIPLE, p, NULL)\
       _ssSafelyCallGenericFcnEnd
#endif

#if SS_SFCN && SS_SIM
#    define ssSetNotMultipleInlinable(S, p) \
       _ssSafelyCallGenericFcnStart(S)(S, \
          GEN_FCN_SET_NOT_MULTIPLE_INLINEABLE, p, NULL)\
       _ssSafelyCallGenericFcnEnd
#endif

typedef struct _ssRTPFromDataInfoWithConv_tag {
    void       *data;
    int        nDataDims;            /* data dimension number       */
    int        *dataDims;            /* data dimensions             */
    DTypeId    dataTypeId;           /* CANNOT be DYNAMICALLY_TYPED */
    CSignal_T  dataComplexity;       /* CANNOT be COMPLEX_INHERITED */
    boolean_T  dataIsConst;          /* constant run-time prm?      */
    int        numParams;            /* number dlg prms, could be 0 */
    int        *paramIndices;        /* dlg prms, could be NULL     */
    int        rtpIndex;             /* run-time prm index          */
    const char *rtpName;             /* run-time prm name           */
    DTypeId    rtpDataTypeId;        /* user-specified rtp datatype */
    CSignal_T  rtpComplexity;        /* user-specified rtp complex  */
} ssRTPFromDataInfoWithConv;

typedef struct _ssRTPDataInfo_tag {
    void       *data;                /* data pointer                */
    DTypeId    dataTypeId;           /* CANNOT be DYNAMICALLY_TYPED */
    CSignal_T  dataComplexity;       /* CANNOT be COMPLEX_INHERITED */
} ssRTPDataInfo;

typedef struct _ssRTPRegInfoWithType_tag {
    int dlgIdx;
    int rtIdx;
    const char* name;
    int dtId;
} ssRTPRegInfoWithType;

typedef struct _ssRTPRegInfoWithTypeComp_tag {
    int dlgIdx;
    int rtIdx;
    const char* name;
    int dtId;
    CSignal_T complexity;
} ssRTPRegInfoWithTypeComp;




typedef struct _ssTimerInfo_tag {
    double clockTickStepSize;
    int_T  clockTickDtype;
    slTimeSource timeSource;
} ssTimerInfo;

#if SS_SFCN && SS_SIM
# define ssUpdateRunTimeParamInfo(S, idx, p) \
    _ssSafelyCallGenericFcnStart(S)(S,GEN_FCN_UPDATE_RUN_TIME_PARAM,idx,(void *)p)\
    _ssSafelyCallGenericFcnEnd

# define ssUpdateRunTimeParamData(S,idx,d) ((S)->sfcnParams.rtp[idx])->data=(d)


# define ssRegDlgParamAsRunTimeParamFull(S, dlgIdxArg, rtIdxArg, nameArg, dtIdArg, compArg) \
 { ssRTPRegInfoWithTypeComp _slConvTypeAndRegParamInfo; \
   _slConvTypeAndRegParamInfo.dlgIdx = (dlgIdxArg); \
   _slConvTypeAndRegParamInfo.rtIdx = (rtIdxArg); \
   _slConvTypeAndRegParamInfo.name = (nameArg); \
   _slConvTypeAndRegParamInfo.dtId = (dtIdArg); \
   _slConvTypeAndRegParamInfo.complexity = (compArg); \
   _ssSafelyCallGenericFcnStart(S) \
   (S,GEN_FCN_FULL_REG_AND_CNV_RUN_TIME_PARAM,0, \
     (void *)&_slConvTypeAndRegParamInfo)\
   _ssSafelyCallGenericFcnEnd; \
 }

# define ssRegDlgParamAsRunTimeParam(S, dlgIdxArg, rtIdxArg, nameArg, dtIdArg) \
 { ssRTPRegInfoWithType _slConvTypeAndRegParamInfo; \
   _slConvTypeAndRegParamInfo.dlgIdx = (dlgIdxArg); \
   _slConvTypeAndRegParamInfo.rtIdx = (rtIdxArg); \
   _slConvTypeAndRegParamInfo.name = (nameArg); \
   _slConvTypeAndRegParamInfo.dtId = (dtIdArg); \
   _ssSafelyCallGenericFcnStart(S) \
   (S,GEN_FCN_REG_AND_CNV_RUN_TIME_PARAM,0, \
     (void *)&_slConvTypeAndRegParamInfo)\
   _ssSafelyCallGenericFcnEnd; \
 }

/*
 * Register dialog parameters indexed as rtpMinIdx and rtpMaxIdx as design
 * minimum and maximum for the run-time parameter of index rtpIdx.
 */
# define ssRegisterRunTimeParamMinMaxPrmIndices(S,rtpIdx,rtpMinIdx,rtpMaxIdx) \
    ssRegisterDataMinMaxPrmIndices((S),SS_DATA_DESC_RTP,(rtpIdx),(rtpMinIdx),(rtpMaxIdx))

# define ssUpdateDlgParamAsRunTimeParam(S, rtIdxArg) \
 { _ssSafelyCallGenericFcnStart(S) \
   (S,GEN_FCN_UPDATE_AND_CNV_RUN_TIME_PARAM,(rtIdxArg),NULL) \
   _ssSafelyCallGenericFcnEnd; \
 }

# define ssCreateRunTimeParamFromData(S, _data, _nDataDims, _dataDims, \
    _dataTypeId, _dataComplexity, _dataIsConst, _numParams, _paramIndices, \
    _RTPIndex, _RTPName, _RTPDataTypeId, _RTPComplexity) \
 { ssRTPFromDataInfoWithConv   _slConvInfoRTPFromData; \
   _slConvInfoRTPFromData.data           = (_data); \
   _slConvInfoRTPFromData.nDataDims      = (_nDataDims); \
   _slConvInfoRTPFromData.dataDims       = (_dataDims); \
   _slConvInfoRTPFromData.dataTypeId     = (_dataTypeId); \
   _slConvInfoRTPFromData.dataComplexity = (_dataComplexity); \
   _slConvInfoRTPFromData.dataIsConst    = (_dataIsConst); \
   _slConvInfoRTPFromData.numParams      = (_numParams); \
   _slConvInfoRTPFromData.paramIndices   = (_paramIndices); \
   _slConvInfoRTPFromData.rtpIndex       = (_RTPIndex); \
   _slConvInfoRTPFromData.rtpName        = (_RTPName); \
   _slConvInfoRTPFromData.rtpDataTypeId  = (_RTPDataTypeId); \
   _slConvInfoRTPFromData.rtpComplexity  = (_RTPComplexity); \
   _ssSafelyCallGenericFcnStart(S) \
   (S,GEN_FCN_CREATE_RUN_TIME_PARAM_FROM_DATA,0,(void *)&_slConvInfoRTPFromData)\
   _ssSafelyCallGenericFcnEnd; \
 }

# define ssUpdateRunTimeParamFromData(S, _rtIdxArg, _data, _dataTypeId, _dataComplexity) \
 { ssRTPDataInfo _slRTPDataInfo; \
   _slRTPDataInfo.data = (_data); \
   _slRTPDataInfo.dataTypeId = (_dataTypeId); \
   _slRTPDataInfo.dataComplexity = (_dataComplexity); \
   _ssSafelyCallGenericFcnStart(S) \
   (S,GEN_FCN_UPDATE_RUN_TIME_PARAM_FROM_DATA,(_rtIdxArg), \
     (void *)&_slRTPDataInfo) \
   _ssSafelyCallGenericFcnEnd; \
 }

# define ssRegAllTunableParamsAsRunTimeParams(S, nms) \
 _ssSafelyCallGenericFcnStart(S)(S,GEN_FCN_REG_ALL_TUNE_PRM_AS_RTP,0, \
                                   (void *)nms)\
 _ssSafelyCallGenericFcnEnd
# define ssUpdateAllTunableParamsAsRunTimeParams(S) \
 _ssSafelyCallGenericFcnStart(S)(S,GEN_FCN_UPDATE_ALL_TUNE_PRM_AS_RTP,0,NULL)\
 _ssSafelyCallGenericFcnEnd

/* 
 * Internal use only.
 *
 * Indicate that the given run-time parameter needs to be accessed in 
 * the generated code by address. Unaddressable expression
 * will be collapsed. This macro can only be used for run-time parameters that 
 * has an one-on-one mapping with a dialog parameter.
 * This macro should only be called at the beginning of mdlStart.
 */ 
# define ssSetRunTimeParamAccessedByAddress(S,rtpIdx)             \
 _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_SET_RUN_TIME_PARAM_ACCESSED_BY_ADDRESS,(rtpIdx),NULL) \
 _ssSafelyCallGenericFcnEnd

/* Result is an int * */
# define _ssIsRunTimeParamTunable(S,rtPIdx,result) \
 _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_IS_RTPARAM_TUNABLE,(rtPIdx),(result))\
 _ssSafelyCallGenericFcnEnd

/* Result is a double * */
# define _ssGetSFuncBlockHandle(S, result) \
 _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_GET_BLOCK_HANDLE,0,(result))\
 _ssSafelyCallGenericFcnEnd

# define ssSetSFInitOutput(S, val) \
 _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_SET_SF_INIT_OUTPUT,(val),NULL)\
 _ssSafelyCallGenericFcnEnd

#endif

#if SS_SIM
# define ssSetRequiredStackSize(S, val)                                 \
 _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_SET_REQUIRED_STACK_SIZE,(val),NULL)\
 _ssSafelyCallGenericFcnEnd
#else
# define ssSetRequiredStackSize(S, val) \
 ssSetRequiredStackSize_cannot_be_used_in_RTW
#endif

#if SS_SL_INTERNAL || SS_RTW_INTERNAL
# define ssGetRunTimeParamsPtr(S) (S)->sfcnParams.rtp
# define ssSetRunTimeParamsPtr(S, ptr) (S)->sfcnParams.rtp = (ptr)
#endif

#if SS_SIM
  # define ssComputeInput(S, pIdx) \
     _ssSafelyCallGenericFcnStart(S)(S,GEN_FCN_COMPUTE_INPUT,pIdx,NULL)\
     _ssSafelyCallGenericFcnEnd
#else
  # define ssComputeInput(S, pIdx) \
     ssComputeInput_cannot_be_used_in_RTW
#endif

#if SS_SIM
  # define ssComputeOutput(S, pIdx) \
     _ssSafelyCallGenericFcnStart(S)(S,GEN_FCN_COMPUTE_OUTPUT,pIdx,NULL)\
     _ssSafelyCallGenericFcnEnd
#else
  # define ssComputeOutput(S, pIdx) \
     ssComputeOutput_cannot_be_used_in_RTW
#endif

/* Result is a pointer to boolean_T */
#if SS_SIM
# define ssGetDestFCSSEnabled(S, pIdx, result) \
     _ssSafelyCallGenericFcnStart(S)(S,GEN_FCN_DEST_FCSS_ENABLED,pIdx,result)\
     _ssSafelyCallGenericFcnEnd
#else
# define ssGetDestFCSSEnabled(S, dataPtr) \
     ssGetDestFCSSEnabled_cannot_be_used_in_RTW
#endif

#if SS_SFCN
# define ssSetAsyncTimerAttributes(S, _clockTickStepSize) \
 { ssTimerInfo _slTimerInfo; \
   _slTimerInfo.clockTickStepSize= (_clockTickStepSize); \
   _ssSafelyCallGenericFcnStart(S) \
   (S,GEN_FCN_SET_ASYNC_TIMER_ATTRIBUTES,0, \
     (void *)&_slTimerInfo) \
   _ssSafelyCallGenericFcnEnd; \
 }
# define ssSetAsyncTimerResolutionEl(S, _clockTickStepSize, el)     \
 { ssTimerInfo _slTimerInfo; \
   _slTimerInfo.clockTickStepSize= (_clockTickStepSize); \
   _ssSafelyCallGenericFcnStart(S) \
   (S,GEN_FCN_SET_ASYNC_TIMER_RESOLUTION_EL,el, \
     (void *)&_slTimerInfo) \
   _ssSafelyCallGenericFcnEnd; \
 }


# define ssSetAsyncTimerDataType(S, _clockTickDataType) \
 { ssTimerInfo _slTimerInfo; \
   _slTimerInfo.clockTickDtype   = (_clockTickDataType); \
   _ssSafelyCallGenericFcnStart(S) \
   (S,GEN_FCN_SET_ASYNC_TIMER_DATA_TYPE,0, \
     (void *)&_slTimerInfo) \
   _ssSafelyCallGenericFcnEnd; \
 }
# define ssSetAsyncTimerDataTypeEl(S, _clockTickDataType, el)      \
 { ssTimerInfo _slTimerInfo; \
   _slTimerInfo.clockTickDtype   = (_clockTickDataType); \
   _ssSafelyCallGenericFcnStart(S) \
(S,GEN_FCN_SET_ASYNC_TIMER_DATA_TYPE_EL,el, \
     (void *)&_slTimerInfo) \
   _ssSafelyCallGenericFcnEnd; \
 }

# define ssSetTimeSource(S, timeSource) \
   _ssSafelyCallGenericFcnStart(S) (S, \
GEN_FCN_SET_TIME_SOURCE, timeSource, NULL) \
   _ssSafelyCallGenericFcnEnd

# define ssSetTimeSourceEl(S, _timeSource, el) \
 { ssTimerInfo _slTimerInfo; \
   _slTimerInfo.timeSource = (_timeSource); \
   _ssSafelyCallGenericFcnStart(S) \
   (S, GEN_FCN_SET_TIME_SOURCE_EL, el, \
      (void *)&_slTimerInfo)\
       _ssSafelyCallGenericFcnEnd; \
 }
#endif

# define ssGetElapseTime(S, dataPtr) \
     _ssSafelyCallGenericFcnStart(S)(S, \
GEN_FCN_GET_ELAPSE_TIME, 0, (double *)dataPtr) \
     _ssSafelyCallGenericFcnEnd

# define ssGetElapseTimeCounter(S, dataPtr) \
     _ssSafelyCallGenericFcnStart(S)(S, \
GEN_FCN_GET_ELAPSE_TIME_COUNTER, 0, (int *)dataPtr) \
     _ssSafelyCallGenericFcnEnd

# define ssGetElapseTimeCounterDtype(S, dataPtr) \
     _ssSafelyCallGenericFcnStart(S)(S, \
GEN_FCN_GET_ELAPSE_TIME_COUNTER_DTYPE, 0, (int *)dataPtr) \
     _ssSafelyCallGenericFcnEnd

# define ssGetElapseTimeResolution(S, dataPtr) \
     _ssSafelyCallGenericFcnStart(S)(S, \
GEN_FCN_GET_ELAPSE_TIME_RESOLUTION, 0, (double *)dataPtr) \
     _ssSafelyCallGenericFcnEnd

#if SS_SFCN && SS_SIM
# define ssGetTimeResolution(S, sti, dataPtr) \
     _ssSafelyCallGenericFcnStart(S)(S, \
GEN_FCN_GET_TIME_RESOLUTION,sti, (double *)dataPtr) \
     _ssSafelyCallGenericFcnEnd
#else
# define ssGetTimeResolution(S, sti, dataPtr) \
    ssGetTimeResolution_cannot_be_used_in_RTW
#endif

#if SS_SFCN
# define ssSetAsyncTaskPriorities(S,width, str) \
     _ssSafelyCallGenericFcnStart(S)(S,\
GEN_FCN_SET_ASYNC_TASK_PRIORITIES,width,str)\
     _ssSafelyCallGenericFcnEnd
# define ssSetAsyncTaskPrioritiesEl(S,_priority, el)     \
    { int priority = _priority; \
     _ssSafelyCallGenericFcnStart(S)(S,  \
GEN_FCN_SET_ASYNC_TASK_PRIORITIES_EL,el,              \
      (void *)&(priority))                              \
     _ssSafelyCallGenericFcnEnd; \
    }
#endif

#if SS_SFCN && SS_SIM
  # define ssSetOutputPortOverwritesInputPort(S, pIdx, val)\
   { int inpIdx = val; \
     _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_SET_OUTPUT_OVERWRITE_INPUT_IDX,(pIdx),(&inpIdx))\
     _ssSafelyCallGenericFcnEnd; \
   }
#endif
#if SS_SFCN && SS_SIM
  # define ssSetZeroBasedIndexInputPort(S, pIdx) \
     _ssSafelyCallGenericFcnStart(S)(S,GEN_FCN_SET_ZERO_BASED_IN_PORT,pIdx,NULL)\
     _ssSafelyCallGenericFcnEnd
#endif

#if SS_SFCN && SS_SIM
  # define ssSetZeroBasedIndexOutputPort(S, pIdx) \
     _ssSafelyCallGenericFcnStart(S)(S, GEN_FCN_SET_ZERO_BASED_OUT_PORT,pIdx,NULL)\
     _ssSafelyCallGenericFcnEnd
#endif

#if SS_SFCN && SS_SIM
  # define ssSetOneBasedIndexInputPort(S, pIdx) \
     _ssSafelyCallGenericFcnStart(S)(S,GEN_FCN_SET_ONE_BASED_IN_PORT,pIdx,NULL)\
     _ssSafelyCallGenericFcnEnd
#endif

#if SS_SFCN && SS_SIM
  # define ssSetOneBasedIndexOutputPort(S, pIdx) \
     _ssSafelyCallGenericFcnStart(S)(S, GEN_FCN_SET_ONE_BASED_OUT_PORT,pIdx,NULL)\
     _ssSafelyCallGenericFcnEnd
#endif

#if SS_SIM
 #define ssSetEnableFcnIsTrivial(S, trivial) \
   _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_ENABLE_FCN_IS_TRIVIAL,(trivial),NULL)\
   _ssSafelyCallGenericFcnEnd
#else
 #define ssSetEnableFcnIsTrivial(S, trivial) \
  ssSetEnableFcnIsTrivial_cannot_be_used_in_RTW
#endif

#if SS_SIM
 #define ssSetDisableFcnIsTrivial(S, trivial) \
   _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_DISABLE_FCN_IS_TRIVIAL,(trivial),NULL)\
   _ssSafelyCallGenericFcnEnd
#else
 #define ssSetDisableFcnIsTrivial(S, trivial) \
  ssSetDisableFcnIsTrivial_cannot_be_used_in_RTW
#endif

/* The owner s-function block pointer. This needs to be defined before the bus support
 * macros below as ssGetOwnerBlock is used there.
 */
#if SS_SL_INTERNAL || SS_SFCN_FOR_SIM
# if !SS_SFCN_LEVEL_1
#  define ssGetOwnerBlock(S) ((S)->blkInfo.block)
# endif
# if !SS_SFCN
#  define ssSetOwnerBlock(S,block) (S)->blkInfo.block = (block)
# else
#  define ssSetOwnerBlock(S,block) \
          ssSetOwnerBlock_cannot_be_used_in_SFunctions
# endif
#endif

/*
 * Set/Get flag that specifies if an S-function supports
 * multiple execution instances
 */
# if (SS_SL_INTERNAL || SS_SFCN_FOR_SIM) && defined(ssGetOwnerBlock)
# define ssSupportsMultipleExecInstances(S, value)     \
{  if (ssGetOwnerBlock(S) != NULL) { \
       boolean_T val = value;       \
       _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_SUP_MULTI_EXEC_INSTANCES, 0, &val)\
       _ssSafelyCallGenericFcnEnd; \
   }\
}
# else
#   define ssSupportsMultipleExecInstances(S, value)
# endif

/*
 * Register a custom message for not supporting multiple instances.
 * Input msg is a pointer to a char array string.
 */
# if (SS_SL_INTERNAL || SS_SFCN_FOR_SIM)
# define ssRegisterMsgForNotSupportingMultiExecInst(S, msg) \
    { \
    _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_MULTI_INS_NO_SUPPORT_MESSAGE, 0, \
                                    (void *)msg) \
     _ssSafelyCallGenericFcnEnd; \
    }
# else
# define ssRegisterMsgForNotSupportingMultiExecInst(S, _msg)
# endif

/*
 * Set/Get flag that specifies if an S-function supports
 * multiple execution instances
 */
# if defined (RTW_GENERATED_S_FUNCTION)
#   if SS_SFCN_FOR_SIM && defined(ssGetOwnerBlock)
#     define ssHasStateInsideForEachSS(S, value)     \
{  if (ssGetOwnerBlock(S) != NULL) { \
       boolean_T val = value;                                              \
       _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_SET_MODELREF_STATE_INSIDE_FOREACH, 0, &val)\
       _ssSafelyCallGenericFcnEnd; \
   } \
}
#  else
#    define ssHasStateInsideForEachSS(S, value)
#  endif
# endif

# if (SS_SL_INTERNAL || SS_SFCN_FOR_SIM)
# define ssSetWarnForFrameUpgrade(S) ((S)->mdlInfo->mdlFlags.frameUpgradeWarn = 1U)
# define _ssGetWarnForFrameUpgrade(S) ((S)->mdlInfo->mdlFlags.frameUpgradeWarn == 1U)
#endif

/*======================================================================*
 * BUS support for S-Functions
 *======================================================================*/

/*
 * APIS for bus support via bus expansion. In this case,
 * the s-function block is expanded under the hood into an individual
 * s-function for each signal in the bus and then the outputs re-bused
 * to output a bus.
 *
 * Need to set_param(gcb, 'EnableBusSupport', 'on') for the S-Function block
 *
 * 1) ssSetBusPropagationSupported(S, true)
 *    This indicates that bus expansion is desired.
 *
 * 2) ssSetBusSourcePort(S, portNumber)
 *    This indicates that the bus coming into port number (0-based) of the
 *    block will supply the structure of the outgoing bus. This bus is also
 *    used for getting signal names, signal propagation etc. It is the
 *    defining bus for this block.
 *    Example: Say for the switch block, this would be set to 0.
 *
 * 3) ssSetBusInputPorts(S, int number, int* numbers)
 *    This indicates the ports of the blocks that accept buses. The bus
 *    expansion routine then checks to verify that the incoming buses at these
 *    inports are identical in terms of signal names and compiled attributes
 *    for successful expansion.
 *    Example: For the switch block this is [0 2], so "number" is set to 2
 *             and "numbers" is an array of ints of length 2 with values
 *             numbers[0] = 0; numbers[1] = 2;
 */
#define ssSetBusPropagationSupported(S, value)\
{    boolean_T tmp = value;\
 _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_SET_BUS_PROPAGATION, 0, &tmp)\
 _ssSafelyCallGenericFcnEnd;\
}

#define ssSetBusSourcePort(S, port)\
{    int tmp = port;\
 _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_SET_BUS_SOURCE_PORT, 0, &tmp)\
 _ssSafelyCallGenericFcnEnd;\
}

#define ssSetBusInputPorts(S, numInports, value)\
 _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_SET_BUS_INPORTS, numInports, value)\
 _ssSafelyCallGenericFcnEnd

/*
 * APIS for bus support via bus objects. In this case, the s-function outputs
 * a bus as defined by a bus object (which can be a parameter). The output
 * function should implement the bus output consistent with the bus object.
 *
 * Need to set_param(gcb, 'EnableBusSupport', 'on') for the S-Function block
 *
 * 1)  ssSetBusOutputObjectName(S, int_T portNumber, char* busName)
 *     This specifies the bus object that defines the bus coming out of the
 *     s-function block at output number (0-based) of the block.
 *
 * 2)  ssSetBusInputAsStruct(S, int_T portNumber, boolean_T val)
 *     This specifies if the input bus as specified by the bus object should
 *     be converted to non-virtual if necessary. By setting it to true, an auto-
 *     conversion block is inserted behind the scenes to convert a virtual
 *     bus input to a non-virtual bus
 *
 * 3)  ssSetBusOutputAsStruct(S, int_T portNumber, boolean_T val)
 *     This specifies if the output bus as specified by the bus object should
 *     emerge as a structure (non-virtual) or a virtual bus. By setting it to false,
 *     a Signal Conversion block is automatically inserted behind the scenes to
 *     output a virtual bus.
 *
 *     --------------------------------------------------------------------------
 *     The next set of macros can be used to obtain information for a specific element
 *     of a bus object given the data type index of the bus object and the appropriate
 *     bus element index within the bus object. The data type index of the bus object
 *     is the index returned by Simulink when the bus object was registered in
 *     mdlInitializeSizes() (using ssRegisterTypeFromParameter() for example)
 *     --------------------------------------------------------------------------
 *
 * 4)  ssGetNumBusElements(S, int_T busTypeID)
 *     Get the number of bus elements in the specified bus object. The bus data type
 *     is passed in as the second argument.
 *
 * 5)  ssGetBusElementOffset(S, int_T busTypeID, int_T elemIdx)
 *     Obtain the offset in bytes (int_T) from the start of the bus data type to
 *     the specified bus element. The bus data type is passed in as the second
 *     argument and the bus element index (zero based index) is passed in as the
 *     third argument.
 *
 * 6)  ssGetBusElementDataType(S, int_T busTypeID, int_T elemIdx)
 *     Obtain the data type index (int_T) for the specified bus element. The bus data
 *     type is passed in as the second argument and the bus element index (zero based
 *     index) is passed in as the third argument.
 *
 * 7)  ssGetBusElementComplexSignal(S, int_T busTypeID, int_T elemIdx)
 *     Obtain the complexity (CSignal_T) of the specified bus element. The bus
 *     data type is passed in as the second argument and the bus element index (zero
 *     based index) is passed in as the third argument.
 *
 * 8)  ssGetBusElementNumDimensions(S, int_T busTypeID, int_T elemIdx)
 *     Obtain the number of signal dimensions (int_T) for the specified bus element.
 *     The bus data type is passed in as the second argument and the bus element index
 *     (zero based index) is passed in as the third argument.
 *
 * 9)  ssGetBusElementDimensions(S, int_T busTypeID, int_T elemIdx)
 *     Obtain the dimensions (const int_T*) for the specified bus element. Use in combination
 *     with ssGetBusElementNumDimensions() above to iterate over the integer array
 *     returned by this macro. The bus data type is passed in as the second argument
 *     and the bus element index (zero based index) is passed in as the third argument.
 *
 * 10) ssGetBusElementDimensionsMode(S, int_T busTypeID, int_T elemIdx)
 *     Obtain the dimensions mode (DimensionsMode_T) for the specified bus element.
 *     The bus data type is passed in as the second argument and the bus element index
 *     (zero based index) is passed in as the third argument.
 *
 * 11) ssGetBusElementName(S, int_T busTypeId, int_T elemIdx)
 *     Get the name (const char*) of the specified bus element. The bus data type is passed
 *     in as the second argument and the bus element index (zero based index) is
 *     passed in as the third argument.
 *
 * 12) ssIsDataTypeABus(S, int_T typeID)
 *     Determine if the data type ID passed in is a bus signal. A Boolean_T value is
 *     returned.
 *
 * 13) ssGetBusElementMin(S, int_T busTypeID, int_T elemIdx)
 *     Obtain the minimum (real_T) for the specified bus element.
 *     The bus data type is passed in as the second argument and the bus element index
 *     (zero based index) is passed in as the third argument.
 *
 * 14) ssGetBusElementMax(S, int_T busTypeID, int_T elemIdx)
 *     Obtain the maximum (real_T) for the specified bus element.
 *     The bus data type is passed in as the second argument and the bus element index
 *     (zero based index) is passed in as the third argument.
 */

#if SS_SL_INTERNAL || SS_SFCN_FOR_SIM

#define ssSetBusOutputObjectName(S, pIdx, name) \
 _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_SET_BUS_OUTPUT_OBJECT_NAME, pIdx, name)\
 _ssSafelyCallGenericFcnEnd

/* Use of ssSetBusObjectName is not recommended. Please use ssSetBusOutputObjectName instead. */
#define ssSetBusObjectName(S, pIdx, name) \
 (ssSetBusOutputObjectName((S), (pIdx), (name)))

#define ssSetBusInputAsStruct(S, pIdx, value) \
{    boolean_T tmp = value;\
 _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_SET_BUS_INPUT_AS_STRUCT, pIdx, &tmp)\
 _ssSafelyCallGenericFcnEnd;\
}

#define ssSetBusOutputAsStruct(S, pIdx, value) \
{    boolean_T tmp = value;\
 _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_SET_BUS_OUTPUT_AS_STRUCT, pIdx, &tmp)\
 _ssSafelyCallGenericFcnEnd;\
}

#define ssGetNumBusElements(S, busTypeID) \
 (dtaGetDataTypeNumElements(ssGetDataTypeAccess(S), ssGetPath(S), (busTypeID)))

#define ssGetBusElementOffset(S, busTypeID, elemIdx) \
 (dtaGetDataTypeElementOffset(ssGetDataTypeAccess(S), ssGetPath(S), (busTypeID), (elemIdx)))

#define ssGetBusElementDataType(S, busTypeID, elemIdx) \
 (dtaGetDataTypeElementDataType(ssGetDataTypeAccess(S), ssGetPath(S), (busTypeID), (elemIdx)))

#define ssGetBusElementComplexSignal(S, busTypeID, elemIdx) \
 (dtaGetDataTypeElementSignalType(ssGetDataTypeAccess(S), ssGetPath(S), (busTypeID), (elemIdx)))

#define ssGetBusElementNumDimensions(S, busTypeID, elemIdx) \
 (dtaGetDataTypeElementNumDimensions(ssGetDataTypeAccess(S), ssGetPath(S), (busTypeID), (elemIdx)))

#define ssGetBusElementDimensions(S, busTypeID, elemIdx) \
 (dtaGetDataTypeElementDimensions(ssGetDataTypeAccess(S), ssGetPath(S), (busTypeID), (elemIdx)))

#define ssGetBusElementDimensionsMode(S, busTypeID, elemIdx) \
 (dtaGetDataTypeElementDimensionsMode(ssGetDataTypeAccess(S), ssGetPath(S), (busTypeID), (elemIdx)))

#define ssGetBusElementName(S, busTypeID, elemIdx) \
 (dtaGetDataTypeElementName(ssGetDataTypeAccess(S), ssGetPath(S), (busTypeID), (elemIdx)))

#define ssIsDataTypeABus(S, typeID) \
 (dtaGetDataTypeIsBus(ssGetDataTypeAccess(S), ssGetPath(S), typeID))

#define ssGetBusElementMin(S, busTypeID, elemIdx) \
 (dtaGetDataTypeElementMin(ssGetDataTypeAccess(S), ssGetPath(S), (busTypeID), (elemIdx)))

#define ssGetBusElementMax(S, busTypeID, elemIdx) \
 (dtaGetDataTypeElementMax(ssGetDataTypeAccess(S), ssGetPath(S), (busTypeID), (elemIdx)))

#else
#define ssSetBusOutputObjectName(S, pIdx, name)
#define ssSetBusObjectName(S, pIdx, name)
#define ssSetBusInputAsStruct(S, pIdx, value)
#define ssSetBusOutputAsStruct(S, pIdx, value)

#define ssGetNumBusElements(S, busTypeID) \
 ssGetNumBusElements_cannot_be_used_in_RTW

#define ssGetBusElementOffset(S, busTypeID, elemIdx) \
 ssGetBusElementOffset_cannot_be_used_in_RTW

#define ssGetBusElementDataType(S, busTypeID, elemIdx) \
 ssGetBusElementDataType_cannot_be_used_in_RTW

#define ssGetBusElementComplexSignal(S, busTypeID, elemIdx) \
 ssGetBusElementComplexSignal_cannot_be_used_in_RTW

#define ssGetBusElementNumDimensions(S, busTypeID, elemIdx) \
 ssGetBusElementNumDimensions_cannot_be_used_in_RTW

#define ssGetBusElementDimensions(S, busTypeID, elemIdx) \
 ssGetBusElementDimensions_cannot_be_used_in_RTW

#define ssGetBusElementDimensionsMode(S, busTypeID, elemIdx) \
 ssGetBusElementDimensionsMode_cannot_be_used_in_RTW

#define ssGetBusElementName(S, busTypeID, elemIdx) \
 ssGetBusElementName_cannot_be_used_in_RTW

#define ssIsDataTypeABus(S, typeID) \
 ssIsDataTypeABus_cannot_be_used_in_RTW

#define ssGetBusElementMin(S, busTypeID, elemIdx) \
  ssGetBusElementMin_cannot_be_used_in_RTW

#define ssGetBusElementMax(S, busTypeID, elemIdx) \
  ssGetBusElementMax_cannot_be_used_in_RTW
#endif

/*
 * NOTE:
 *     The following bus mode related macros are currently not used
 */
typedef void (*mdlSetInputPortBusModeFcn)(SimStruct *S,
                                          int_T     portIdx,
                                          BusMode_T dimsMode);

#define ssRegMdlSetInputPortBusModeFcn(S, fcn) \
   {\
    mdlSetInputPortBusModeFcn _mdlBusModeFcn = fcn; \
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_REG_SET_INPUT_BUS_MODE_MTH, 0, \
                                        (void *)_mdlBusModeFcn) \
    _ssSafelyCallGenericFcnEnd; \
   }

#define ssGetInputPortBusMode(S, pIdx) \
  CONV_BITS2BUSMODE((S)->portInfo.inputs[(pIdx)].attributes.busMode)

#define ssGetOutputPortBusMode(S, pIdx) \
  CONV_BITS2BUSMODE((S)->portInfo.outputs[(pIdx)].attributes.busMode)

#if SS_SL_INTERNAL || SS_SFCN_FOR_SIM
#ifdef ssGetOwnerBlock
#define ssSetInputPortBusMode(S, pIdx, value) \
{ \
    if (ssGetOwnerBlock(S) != NULL) { \
        BusMode_T val = value; \
        _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_SET_INPUT_BUS_MODE, pIdx, &val)\
        _ssSafelyCallGenericFcnEnd; \
    } \
 }

#define ssSetOutputPortBusMode(S, pIdx, value) \
{ \
    if (ssGetOwnerBlock(S) != NULL) { \
       BusMode_T val = value; \
       _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_SET_OUTPUT_BUS_MODE, pIdx, &val)\
       _ssSafelyCallGenericFcnEnd; \
    } \
}
#else
#define ssSetInputPortBusMode(S, pIdx, value)
#define ssSetOutputPortBusMode(S, pIdx, value)
#endif
#else
#define ssSetInputPortBusMode(S, pIdx, value)
#define ssSetOutputPortBusMode(S, pIdx, value)
#endif

/* ============================================================================
 * API to specify that output port is discrete valued
 * ============================================================================*/
#if SS_SL_INTERNAL || SS_SFCN_FOR_SIM

#define ssSetOutputPortDiscreteValuedOutput(S, pIdx, value) \
{  boolean_T tmp = value;\
 _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_SET_OUTPUT_PORT_DISCRETE_VALUED_OUTPUT, pIdx, &tmp)   \
 _ssSafelyCallGenericFcnEnd;\
}

#else
#define ssSetOutputPortDiscreteValuedOutput(S, pIdx, value)
#endif


/* ============================================================================
 * API to identify output ports that can serve as IC source.
 * ==========================================================================*/

#if defined(RTW_GENERATED_S_FUNCTION) || SS_SL_INTERNAL || defined(SS_XPC_SFCN) || SS_SFCN
typedef struct _ssICAttribs_tag {
    boolean_T computeInStart;
    boolean_T computeInFirstInitialize;
    boolean_T computeInDisable;
} _ssICAttribs;
# define ssSetOutputPortICAttributes(S, pIdx, value1, value2, value3) \
 {  _ssICAttribs val = {value1, value2, value3}; \
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_SET_OUTPUT_IC_ATTRIBUTES, pIdx, &val)\
    _ssSafelyCallGenericFcnEnd; \
 }
#endif

/* ============================================================================
 * API to identify output ports whose block I/O buffer is updated in an
 * execution context other than the root context of the model reference block.
 * ==========================================================================*/

#if defined(RTW_GENERATED_S_FUNCTION) || SS_SL_INTERNAL
# define ssSetModelRefOutputBlkIOUpdatedInAnotherExecContext(S, pIdx, value) \
 {  boolean_T val = value; \
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_SET_MODELREF_OUTPUT_BIO_UPDATED_IN_ANOTHER_CTX, pIdx, &val)\
    _ssSafelyCallGenericFcnEnd; \
 }
#endif

/* ============================================================================
 * API to identify model reference block compiled with consistent outport
 * initialization feature.
 * ==========================================================================*/

#if defined(RTW_GENERATED_S_FUNCTION) || SS_SL_INTERNAL
# define ssSetModelReferenceConsistentOutportInitialization(S, value) \
 {  boolean_T val = value; \
    _ssSafelyCallGenericFcnStart(S)( \
        (S), GEN_FCN_SET_MODELREF_CONSISTENT_OUTPORT_INIT, 0, &val)\
    _ssSafelyCallGenericFcnEnd; \
 }
#endif

/* ============================================================================
 * API to identify model reference block that is referencing a scheduling
 * diagram.
 * ==========================================================================*/

#if defined(RTW_GENERATED_S_FUNCTION) || SS_SL_INTERNAL
# define ssSetModelRefIsExportFcnDiagram(S, value) \
 {  boolean_T val = value; \
    _ssSafelyCallGenericFcnStart(S)( \
        (S), GEN_FCN_SET_MODELREF_IS_EXPORTFCN_DIAGRAM, 0, &val)\
    _ssSafelyCallGenericFcnEnd; \
 }
#endif

/* ============================================================================
 * API to declare model reference block that can be placed inside state enabled
 * subsystem.
 * ==========================================================================*/

#if defined(RTW_GENERATED_S_FUNCTION) || SS_SL_INTERNAL
# define ssSetModelReferenceAllowInStateEnabledSubsystem(S, value) \
 {  boolean_T val = value; \
    _ssSafelyCallGenericFcnStart(S)( \
        (S), GEN_FCN_SET_MODELREF_ALLOW_IN_STATE_ENABLED_SS, 0, &val)\
    _ssSafelyCallGenericFcnEnd; \
 }
#endif

/*
 * Set flag that specifies if an S-function is strictly updating its states in
 * mdlUpdate.
 */
# if SS_SL_INTERNAL || SS_SFCN_FOR_SIM
#   define ssSetStatesModifiedOnlyInUpdate(S, value)       \
 {  boolean_T val = value; \
    _ssSafelyCallGenericFcnStart(S)( \
        (S), GEN_FCN_SET_STATES_MODIFIED_ONLY_IN_UPDATE, 0, &val)\
    _ssSafelyCallGenericFcnEnd; \
 }
# else
#   define ssSetStatesModifiedOnlyInUpdate(S, value)
# endif

# if (SS_SL_INTERNAL || SS_SFCN_FOR_SIM) && defined(ssGetOwnerBlock)
# define ssSetModelRefHasParforForEachSS(S, _setting) \
{  if (ssGetOwnerBlock(S) != NULL) { \
       boolean_T val = _setting; \
       _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_SET_HAS_PAR_FOREACH_SS,0,&val) \
       _ssSafelyCallGenericFcnEnd; \
   }\
}
# else
#   define ssSetModelRefHasParforForEachSS(S, _setting)
# endif

# if (SS_SL_INTERNAL || SS_SFCN_FOR_SIM)
# define ssSetModelRefHasVariantModelOrSubsystem(S, _setting) \
{ \
    boolean_T val = _setting; \
    _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_SET_HAS_VARIANT_MODEL_OR_SS,0,&val) \
    _ssSafelyCallGenericFcnEnd; \
}
# else
#   define ssSetModelRefHasVariantModelOrSubsystem(S, _setting)
# endif

/* ============================================================================
 * Variable dimensions APIs
 * ==========================================================================*/

#define ssGetInputPortDimensionsMode(S, pIdx) \
  CONV_BITS2DIMSMODE((S)->portInfo.inputs[(pIdx)].attributes.dimensionsMode)

#if SS_SL_INTERNAL || SS_SFCN_FOR_SIM
# define ssSetInputPortDimensionsMode(S, pIdx, value) \
 {  DimensionsMode_T val = value; \
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_SET_INPUT_DIMS_MODE, pIdx, &val)\
    _ssSafelyCallGenericFcnEnd; \
 }
#else
# define ssSetInputPortDimensionsMode(S, pIdx, value)
#endif

#define ssGetOutputPortDimensionsMode(S, pIdx) \
  CONV_BITS2DIMSMODE((S)->portInfo.outputs[(pIdx)].attributes.dimensionsMode)

#if SS_SL_INTERNAL || SS_SFCN_FOR_SIM
#define ssSetOutputPortDimensionsMode(S, pIdx, value) \
 {  DimensionsMode_T val = value; \
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_SET_OUTPUT_DIMS_MODE, pIdx, &val)\
    _ssSafelyCallGenericFcnEnd; \
 }
#else
#define ssSetOutputPortDimensionsMode(S, pIdx, value)
#endif

#define ssGetCurrentInputPortDimensions(S, pIdx, dIdx) \
  (S)->blkInfo.blkInfo2->portInfo2->inputs[(pIdx)].portVarDims[(dIdx)]

#define ssGetCurrentOutputPortDimensions(S, pIdx, dIdx) \
  (S)->blkInfo.blkInfo2->portInfo2->outputs[(pIdx)].portVarDims[(dIdx)]

#define ssGetCurrentInputPortWidth(S, portIdx) \
    _ssGetCurrentInputPortWidth(S, portIdx)

#define ssGetCurrentOutputPortWidth(S, portIdx)\
    _ssGetCurrentOutputPortWidth(S, portIdx)

#define _ssSetCurrentOutputPortDimensions(S, pIdx, dIdx, val) \
    (S)->blkInfo.blkInfo2->portInfo2->outputs[(pIdx)].portVarDims[(dIdx)] = (val)

struct _ssVarDimsIdxVal_tag {
    int dIdx;
    int dVal;
};

#if SS_SL_INTERNAL || SS_SFCN_FOR_SIM
#define ssSetCurrentOutputPortDimensions(S, pIdx, _dIdx, _val) \
   {\
    struct _ssVarDimsIdxVal_tag dIdxVal; dIdxVal.dIdx = _dIdx; dIdxVal.dVal = _val; \
       _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_SET_CURR_OUTPUT_DIMS, pIdx, &dIdxVal)\
       _ssSafelyCallGenericFcnEnd; \
   }
#else
#define ssSetCurrentOutputPortDimensions(S, pIdx, dIdx, val) \
    _ssSetCurrentOutputPortDimensions(S, pIdx, dIdx, val)
#endif

typedef void (*mdlSetInputPortDimensionsModeFcn)(SimStruct        *S,
                                                 int_T            portIdx,
                                                 DimensionsMode_T dimsMode);

#if SS_SL_INTERNAL || SS_SFCN_FOR_SIM
#  define ssRegMdlSetInputPortDimensionsModeFcn(S, fcn) \
   {\
    mdlSetInputPortDimensionsModeFcn _mdlDimsModeFcn = fcn; \
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_REG_SET_INPUT_DIMS_MODE_MTH, 0, \
                                        (void *)_mdlDimsModeFcn) \
    _ssSafelyCallGenericFcnEnd; \
   }
#else
# define ssRegMdlSetInputPortDimensionsModeFcn(S, fcn)
#endif

#if SS_SL_INTERNAL || SS_SFCN_FOR_SIM
#define ssSetInputPortDimsSameAsOutputPortDims(S, inpIdx, outIdx) \
  { int val = outIdx; \
     _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_SET_INPUT_DIMS_SAMEAS_OUTPUT,(inpIdx),(&val))\
     _ssSafelyCallGenericFcnEnd; \
  }
#else
#define ssSetInputPortDimsSameAsOutputPortDims(S, inpIdx, outIdx)
#endif

#if SS_SL_INTERNAL || SS_SFCN_FOR_SIM
#define ssSetSignalSizesComputeType(S, type) \
  {  _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_SET_COMP_VARSIZE_COMPUTE_TYPE,(type), 0)\
     _ssSafelyCallGenericFcnEnd; \
  }
#else
#define ssSetSignalSizesComputeType(S, type)
#endif

#define ssGetDWorkRequireResetForSignalSize(S,index) \
    (SS_VariableSizeStateResetType)((S)->work.dWorkAux[(index)].flags.ensureResetForSizeVary)

#define ssSetDWorkRequireResetForSignalSize(S,index,n) \
    (S)->work.dWorkAux[index].flags.ensureResetForSizeVary = (unsigned int)(n)

#if SS_SL_INTERNAL || SS_SFCN_FOR_SIM
#define ssSetModelRefRequireResetForSignalSize(S, val) \
  {  _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_MODELREF_REQUIRE_RESET_FOR_VARSIZE,(val), 0)\
     _ssSafelyCallGenericFcnEnd; \
  }
#else
#define ssSetModelRefRequireResetForSignalSize(S, type)
#endif

#ifndef _DIMSDEPENDINFO_T
#define _DIMSDEPENDINFO_T

/* Set the current dimension of output port outIdx based on the dims dependent rule ruleIdx */
typedef void (*SetOutputDimsFcn)(SimStruct *S, int outIdx, int *inps, int numInps);
/*
 * RTWCG function of setting the current dimension of output port outIdx based
 * on the dims dependent rule ruleIdx
 */
typedef void (*SetOutputDimsRTWCGFcn) (SimStruct *S, void *rtwBlk, int oIdx, int*inps, int nInputs);

typedef struct {
    int              *inputs;           /* index to inputs whose dims affect the output dims*/
    int              numInputs;         /* number of inputs affect the output dims */
    SetOutputDimsFcn setOutputDimsFcn;  /* function to update the output dims
                                           based on the dims of inputs*/
    SetOutputDimsRTWCGFcn setOutputDimsRTWCGFcn;
                                        /* RTWCG function to update output dims
                                           based on the dims of inputs */
} DimsDependInfo_T;

#endif

#if SS_SFCN_FOR_SIM
#define ssAddOutputDimsDependencyRule(S, outIdx, ruleInfo) \
  {  _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_ADD_DIMS_DEPEND_RULE,(outIdx),(ruleInfo))\
     _ssSafelyCallGenericFcnEnd; \
  }
#else
#define ssAddOutputDimsDependencyRule(S, outIdx, ruleInfo)
#endif


typedef void (*SetOutputDimsRuleFcn)(SimStruct *S, int outIdx, int ruleIdx);

typedef struct {
    int                  numRules;
    int                  *numInpsRule;
    int                  *inpIndices;
    SetOutputDimsRuleFcn setOutputDimsRuleFcn;
} MdlRefOutDimsInfo_T;

typedef void (*MdlRefFinalizeDimsFcn)(SimStruct *S);

typedef struct {
    MdlRefFinalizeDimsFcn finalizeDimsFcn;
} MdlRefFinalizeDimsInfo_T;

typedef struct {
    int _sysIdx;
    int _blkIdx;
    int _outIdx;
    int _ruleIdx;
} VarDimsAccelSetDims_T;

typedef struct {
    int _sysIdx;
    int _blkIdx;
    int _portIdx;
    int _tid;
    int _function;
} ModelBlockFcnCallInput_T;

typedef struct {
    const char *name;
    const uint32_T **elements;
} DataTypeChecksumInfo_T;

#if SS_SFCN && SS_SIM

#define ssRegMdlRefSetOutputDimsMethods(S, outIdx, ruleInfo) \
    { _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_REG_MODELREF_SET_DIMS_DEPEND_RULES,(outIdx),(ruleInfo))\
      _ssSafelyCallGenericFcnEnd; \
    }

#define ssRegMdlRefFinalizeDimsMethod(S, finalizeDimsFcnPtr) \
    { MdlRefFinalizeDimsInfo_T info; \
      info.finalizeDimsFcn = finalizeDimsFcnPtr; \
      _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_REG_MODELREF_FINALIZE_DIMS_MTH,0,&info) \
      _ssSafelyCallGenericFcnEnd; \
    }

#define ssAddVariableSizeSignalsRuntimeChecker(S, checker_type) \
    { _ssSafelyCallGenericFcnStart(S)((S),     \
                                      GEN_FCN_ADD_VARDIMS_RUNTIME_CHECKER,\
                                      (checker_type), NULL) \
      _ssSafelyCallGenericFcnEnd;              \
    }

#define ssCallAccelSetDims(S, sysIdx, blkIdx, outIdx, ruleIdx)   \
    { VarDimsAccelSetDims_T accelSetDimsInfo;    \
      accelSetDimsInfo._sysIdx  = sysIdx; \
      accelSetDimsInfo._blkIdx  = blkIdx; \
      accelSetDimsInfo._outIdx  = outIdx; \
      accelSetDimsInfo._ruleIdx = ruleIdx; \
      _ssSafelyCallGenericFcnStart(S)((S),                              \
                                      GEN_FCN_ACCEL_CALL_SET_DIMS,      \
                                      0, &accelSetDimsInfo)                  \
      _ssSafelyCallGenericFcnEnd;        \
    }


#define ssCallAccelModelBlockFcnCallInput(S, sysIdx, blkIdx, portIdx, tid, function) \
    { ModelBlockFcnCallInput_T accelModelBlockFcnCallInfo;    \
      accelModelBlockFcnCallInfo._sysIdx   = sysIdx; \
      accelModelBlockFcnCallInfo._blkIdx   = blkIdx; \
      accelModelBlockFcnCallInfo._portIdx  = portIdx; \
      accelModelBlockFcnCallInfo._tid      = tid; \
      accelModelBlockFcnCallInfo._function = function; \
      _ssSafelyCallGenericFcnStart(S)((S),                              \
                                      GEN_FCN_ACCEL_CALL_MODEL_FCNCALL_INPUT,      \
                                      0, &accelModelBlockFcnCallInfo)                  \
      _ssSafelyCallGenericFcnEnd;        \
    }

#define ssCallAccelCopyCacheForIIS(S, sysIdx, fromCache) \
    { _ssSafelyCallGenericFcnStart(S)((S),     \
                                      GEN_FCN_ACCEL_COPY_STATE_CACHE_FOR_IIS,\
                                      sysIdx, fromCache) \
      _ssSafelyCallGenericFcnEnd;              \
    }

#define ssCallGetDataTypeChecksum(S, dtName, els) \
    { DataTypeChecksumInfo_T chksumInfo; \
      chksumInfo.name = dtName;          \
      chksumInfo.elements = els;         \
      _ssSafelyCallGenericFcnStart(S)((S),                             \
                                      GEN_FCN_GET_DATATYPE_CHECKSUM,   \
                                      0, &chksumInfo)                  \
      _ssSafelyCallGenericFcnEnd;        \
    }

#define ssCheckStructParamChecksum(S, index, chksum) \
    { _ssSafelyCallGenericFcnStart(S)((S),                                \
                                      GEN_FCN_CHECK_STRUCTPARAM_CHECKSUM, \
                                      (index), (chksum))                  \
      _ssSafelyCallGenericFcnEnd;                                         \
    }

#define ssCallSetRegCodeVariantFcnCall(S, numParams, paramIdxs) \
    { _ssSafelyCallGenericFcnStart(S)((S),                                \
                                      GEN_FCN_REG_CODE_VARIANT_FCNCALL,   \
                                      numParams, paramIdxs)               \
      _ssSafelyCallGenericFcnEnd;        \
    }

#define ssCallSetRegAutosarClientBlock(S, isClientBlock) \
    { _ssSafelyCallGenericFcnStart(S)((S),                                \
                                      GEN_FCN_REG_AUTOSAR_CLIENT_BLOCK,   \
                                      isClientBlock, NULL)                   \
      _ssSafelyCallGenericFcnEnd;        \
    }

#define ssCallGetNumVariantConditions(S, conditionIndex, result)          \
    { _ssSafelyCallGenericFcnStart(S)((S),                                \
                                      GEN_FCN_GET_NUM_VARIANT_CONDITIONS, \
                                      conditionIndex, result)             \
      _ssSafelyCallGenericFcnEnd;        \
    }

#define ssCallGetEvalCodeVariantFcnCall(S, numParams, paramIdxs)     \
    { _ssSafelyCallGenericFcnStart(S)((S),                                \
                                      GEN_FCN_EVAL_CODE_VARIANT_FCNCALL,  \
                                      numParams, paramIdxs)                \
      _ssSafelyCallGenericFcnEnd;        \
    }

#endif

#define _ssGetBlkInfo2PortInfo2Ptr(S) \
   (S)->blkInfo.blkInfo2->portInfo2

#define _ssSetBlkInfo2PortInfo2Ptr(S, ptr) \
   (S)->blkInfo.blkInfo2->portInfo2 = (ptr)

#define _ssSetPortInfo2ForInputs(S, ptr) \
   (S)->blkInfo.blkInfo2->portInfo2->inputs = (ptr)

#define _ssGetPortInfo2ForInputs(S) \
   (S)->blkInfo.blkInfo2->portInfo2->inputs

#define _ssSetPortInfo2ForOutputs(S, ptr) \
   (S)->blkInfo.blkInfo2->portInfo2->outputs = (ptr)

#define _ssGetPortInfo2ForOutputs(S) \
   (S)->blkInfo.blkInfo2->portInfo2->outputs

#define _ssSetInputPortVariableDimsPtr(S,pIdx,uDims) \
   (S)->blkInfo.blkInfo2->portInfo2->inputs[(pIdx)].portVarDims = (uDims)

#define _ssSetOutputPortVariableDimsPtr(S,pIdx,yDims) \
   (S)->blkInfo.blkInfo2->portInfo2->outputs[(pIdx)].portVarDims = (yDims)

#if !SS_SFCN

#define _ssSetBlockIOVarDims(S, ptr) \
   (S)->mdlInfo->blockIOVarDims = (ptr)

#define _ssGetBlockIOVarDims(S) \
   (S)->mdlInfo->blockIOVarDims
#endif

/*============================================================================*/

/*
 * Data Store API
 *
 * This API is for internal MathWorks use only and is not intended for use
 * by user written S-functions. Accessing Data Stores is not
 * yet supported for user written S-functions. This API WILL change in
 * a future release.
 */

#if SS_SFCN && SS_SIM
# define ssSetNumDataStores(S, numDataStores) \
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_REGISTER_NUM_DATA_STORE, (numDataStores), NULL)\
    _ssSafelyCallGenericFcnEnd
#endif


typedef enum {
  SS_READER_ONLY,
  SS_WRITER_ONLY,
  SS_READER_AND_WRITER
} SS_ReaderOrWriter;

typedef struct {
    const char        *name;
    SS_ReaderOrWriter readerOrWriter;
    boolean_T         elementAccess;
    boolean_T         expectGlobal;
    boolean_T         *success;
} SFcnDataStoreNameInfo;

#if SS_SFCN && SS_SIM
# define ssRegisterGlobalDataStoreFromName(S, dsmIdx, dsmName, dsmReadOrWrite, dsmElemAccess, dsmSuccess) \
   {\
    SFcnDataStoreNameInfo locPI;\
    locPI.name = dsmName;\
    locPI.readerOrWriter = dsmReadOrWrite;\
    locPI.elementAccess = dsmElemAccess; \
    locPI.expectGlobal = true;\
    locPI.success = dsmSuccess;\
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_REGISTER_DATA_STORE_FROM_NAME, dsmIdx, &locPI)\
    _ssSafelyCallGenericFcnEnd; \
   }
#endif

#if SS_SFCN && SS_SIM
# define ssRegisterDataStoreFromName(S, dsmIdx, dsmName, dsmReadOrWrite, dsmElemAccess, dsmSuccess) \
   {\
    SFcnDataStoreNameInfo locPI;\
    locPI.name = dsmName;\
    locPI.readerOrWriter = dsmReadOrWrite;\
    locPI.elementAccess = dsmElemAccess; \
    locPI.expectGlobal = false;\
    locPI.success = dsmSuccess;\
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_REGISTER_DATA_STORE_FROM_NAME, dsmIdx, &locPI)\
    _ssSafelyCallGenericFcnEnd; \
   }
#endif

/* The dsmInfo in ssGetDataStoreInfo is of type SFcnDataStoreInfo */
typedef struct {
    double      sample_time;
    double      offset_time;
    int         dataTypeId;
    int         numDims;
    int         *dims;
    int         complex;
} SFcnDataStoreInfo;
#if SS_SFCN && SS_SIM
# define ssGetDataStoreInfo(S, dsmIdx, dsmInfo)\
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_GET_DATA_STORE_INFO, dsmIdx, dsmInfo)\
    _ssSafelyCallGenericFcnEnd
#endif

typedef struct {
    const char *bpath;
    void       *addr;
} SFcnDataStoreBPathAddr;
/* Structure for passing data store info into Simulink */

#if SS_SFCN && SS_SIM
/* Note that the dsmBPath must be persistent and constant
 * i.e. inside Simulink the pointer is cached, we do not make a deep copy
 */
# define ssReadFromDataStoreWithPath(S, dsmIdx, dsmBPath, dataAddr) \
   {\
    SFcnDataStoreBPathAddr locPI;\
    locPI.bpath = dsmBPath;\
    locPI.addr = dataAddr;\
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_READ_FROM_DATA_STORE, dsmIdx, &locPI)\
    _ssSafelyCallGenericFcnEnd; \
   }
# define ssReadFromDataStore(S, dsmIdx, dataAddr) \
 ssReadFromDataStoreWithPath(S, dsmIdx, NULL, dataAddr)
#endif

typedef struct {
    const char *bpath;
    const void *addr;
} SFcnDataStoreBPathConstAddr;

#if SS_SFCN && SS_SIM
/* Note that the dsmBPath must be persistent and constant
 * i.e. inside Simulink the pointer is cached, we do not make a deep copy
 */
# define ssWriteToDataStoreWithPath(S, dsmIdx, dsmBPath, dataAddr) \
   {\
    SFcnDataStoreBPathConstAddr locPI;\
    locPI.bpath = dsmBPath;\
    locPI.addr = dataAddr;\
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_WRITE_TO_DATA_STORE, dsmIdx, &locPI)\
    _ssSafelyCallGenericFcnEnd; \
   }
# define ssWriteToDataStore(S, dsmIdx, dataAddr) \
 ssWriteToDataStoreWithPath(S, dsmIdx, NULL, dataAddr)
#endif


#if SS_SFCN && SS_SIM

/* Update Data Store Memory logs after writing data.
 */
# define ssUpdateDataStoreLog(S, dsmIdx) \
{\
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_DATA_STORE_LOG_UPDATE, dsmIdx, NULL)\
    _ssSafelyCallGenericFcnEnd; \
}

#endif

/* Typedef used by Message Receive ports
 */
typedef struct {
    void **msgDataPtr;
} SlMsgReceiveData;

#if SS_SFCN && SS_SIM
/* Set input port is receiving message
 */
# define ssSetInputPortIsMessage(S, pIdx) \
{\
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_SET_INPUT_PORT_ISMSG, pIdx, NULL)\
    _ssSafelyCallGenericFcnEnd; \
}
#else
# define ssSetInputPortIsMessage(S, pIdx) ssSetInputPortIsMessage_cannot_be_used_in_RTW
#endif

#if SS_SFCN && SS_SIM
/* Set output port is sending message
 */
# define ssSetOutputPortIsMessage(S, pIdx) \
{\
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_SET_OUTPUT_PORT_ISMSG, pIdx, NULL)\
    _ssSafelyCallGenericFcnEnd; \
}
#else
# define ssSetOutputPortIsMessage(S, pIdx) ssSetOutputPortIsMessage_cannot_be_used_in_RTW
#endif

#if SS_SFCN && SS_SIM
/* Set input (receive) port message queue length
 */
# define ssSetInputPortMessageQueueLength(S, pIdx, qLen)     \
{\
    int _locQLen = qLen; \
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_SET_INPUT_PORT_MSGQ_LEN, pIdx, &_locQLen)\
    _ssSafelyCallGenericFcnEnd; \
}
#else
# define ssSetInputPortMessageQueueLength(S, pIdx, qLen) ssSetInputPortMessageQueueLength_cannot_be_used_in_RTW
#endif

#if SS_SFCN && SS_SIM
/* Set input (receive) port message queue length
 */
# define ssSetInputPortMessageQueuePolicy(S, pIdx, qPol)     \
{\
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_SET_INPUT_PORT_MSGQ_POLICY, pIdx, qPol)\
    _ssSafelyCallGenericFcnEnd; \
}
#else
# define ssSetInputPortMessageQueuePolicy(S, pIdx, qPol) ssSetInputPortMessageQueuePolicy_cannot_be_used_in_RTW
#endif

#if SS_SFCN && SS_SIM
/* Output port send message
 */
# define ssOutputPortSendMessage(S, pIdx, msgData)     \
{\
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_SEND_MSG, pIdx, msgData) \
    _ssSafelyCallGenericFcnEnd; \
}
#else
# define ssOutputPortSendMessage(S, pIdx, msgData) ssOutputPortSendMessage_cannot_be_used_in_RTW
#endif

#if SS_SFCN && SS_SIM
/* Input port get number of received messages
 */
# define ssInputPortNumReceivedMessages(S, pIdx, result)  \
{\
    _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_NUM_RX_MSGS, pIdx, result) \
    _ssSafelyCallGenericFcnEnd; \
}
#else
# define ssInputPortNumReceivedMessages(S, pIdx, result) ssInputPortNumReceivedMessages_cannot_be_used_in_RTW
#endif

#if SS_SFCN && SS_SIM
/* Input port pop first received message
 */
# define ssInputPortPopReceivedMessage(S, pIdx, result)  \
{\
    SlMsgReceiveData _rxDataPtrHolder = {result}; \
    _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_POP_MSG, pIdx, &_rxDataPtrHolder) \
    _ssSafelyCallGenericFcnEnd; \
}
#else
# define ssInputPortPopReceivedMessage(S, pIdx, result) ssInputPortPopReceivedMessage_cannot_be_used_in_RTW
#endif

#if SS_SFCN && SS_SIM
/* Input port peek (without popping) first received message
 */
# define ssInputPortPeekReceivedMessage(S, pIdx, result)  \
{\
    SlMsgReceiveData _rxDataPtrHolder = {result}; \
    _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_PEEK_MSG, pIdx, &_rxDataPtrHolder) \
    _ssSafelyCallGenericFcnEnd; \
}
#else
# define ssInputPortPeekReceivedMessage(S, pIdx, result) ssInputPortPeekReceivedMessage_cannot_be_used_in_RTW
#endif

#if SS_SFCN && SS_SIM
/* Release data of received message once it has been read
 */
#define ssReleaseMessageData(S, msgData) \
{\
    _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_RELEASE_MSG, 0, msgData) \
    _ssSafelyCallGenericFcnEnd; \
}
#else
# define ssReleaseMessageData(S, msgData) ssReleaseMessageData_cannot_be_used_in_RTW
#endif

typedef struct {
    const char* enumName;
    const char* checksum;
    const char* sidString;
    const char* modelName;
} SimStructStateflowAutoEnumInfo;


#if SS_SFCN && SS_SIM
/* 
 */
#define ssRegisterStateflowAutoEnumInfo(S, _enumName, _checksum, _sidString, _modelName) \
{\
    SimStructStateflowAutoEnumInfo _info; \
    _info.enumName = _enumName; \
    _info.checksum = _checksum; \
    _info.sidString = _sidString; \
    _info.modelName = _modelName; \
    _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_REGISTER_STATEFLOW_AUTO_ENUM_INFO, 0, &_info) \
    _ssSafelyCallGenericFcnEnd; \
}
#else
#define ssRegisterStateflowAutoEnumInfo(S, enumName, checksum, sidString, modelName) ssRegisterStateflowAutoEnumInfo_cannot_be_used_in_RTW
#endif

/* Remember: storage is column major order if accessing element of a matrix */
typedef struct {
    const char *bpath;
    void       *addr;
    int         elem;
} SFcnDataStoreBPathAddrElem;

#if SS_SFCN && SS_SIM
/* Note that the dsmBPath must be persistent and constant
 * i.e. inside Simulink the pointer is cached, we do not make a deep copy
 */
# define ssReadFromDataStoreElementWithPath(S, dsmIdx, dsmBPath, dataAddr,dsmElem) \
   {\
    SFcnDataStoreBPathAddrElem locPI;\
    locPI.bpath = dsmBPath;\
    locPI.addr = dataAddr;\
    locPI.elem = dsmElem;\
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_READ_FROM_DATA_STORE_ELEM,dsmIdx, &locPI)\
    _ssSafelyCallGenericFcnEnd; \
   }
# define ssReadFromDataStoreElement(S, dsmIdx, dataAddr,dsmElem) \
 ssReadFromDataStoreElementWithPath(S, dsmIdx, NULL, dataAddr,dsmElem)
#endif

typedef struct {
    const char *bpath;
    const void *addr;
    int         elem;
} SFcnDataStoreBPathConstAddrElem;

#if SS_SFCN && SS_SIM
/* Note that the dsmBPath must be persistent and constant
 * i.e. inside Simulink the pointer is cached, we do not make a deep copy
 */
# define ssWriteToDataStoreElementWithPath(S, dsmIdx, dsmBPath, dataAddr,dsmElem) \
   {\
    SFcnDataStoreBPathConstAddrElem locPI;\
    locPI.bpath = dsmBPath;\
    locPI.addr = dataAddr;\
    locPI.elem = dsmElem;\
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_WRITE_TO_DATA_STORE_ELEM, dsmIdx, &locPI)\
    _ssSafelyCallGenericFcnEnd; \
   }
# define ssWriteToDataStoreElement(S, dsmIdx, dataAddr,dsmElem) \
 ssWriteToDataStoreElementWithPath(S, dsmIdx, NULL, dataAddr,dsmElem)
#endif


typedef struct {
    char      *name;
    char      *dataTypeName;
    boolean_T expectGlobal;
    int       *idx;
    void      **addr;
} SFcnDataStoreNameAddrIdx;

#if SS_SFCN && SS_SIM
# define ssGetSFcnDataStoreNameAddrIdx(S, dsmName, dsmAddr, dsmIdx) \
   {\
     SFcnDataStoreNameAddrIdx locPI; \
     locPI.name = dsmName; \
     locPI.dataTypeName = NULL;\
     locPI.expectGlobal = false; \
     locPI.idx = dsmIdx;\
     locPI.addr = dsmAddr; \
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_GET_DATA_STORE_ADDR, 0, &locPI)\
    _ssSafelyCallGenericFcnEnd; \
   }
#endif

#if SS_SFCN && SS_SIM
# define ssGetSFcnGlobalDataStoreNameAddrIdx(S, dsmName, dsmDTName, dsmAddr, dsmIdx) \
   {\
     SFcnDataStoreNameAddrIdx locPI; \
     locPI.name = dsmName; \
     locPI.dataTypeName = dsmDTName;\
     locPI.expectGlobal = true; \
     locPI.idx = dsmIdx;\
     locPI.addr = dsmAddr; \
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_GET_DATA_STORE_ADDR, 0, &locPI)\
    _ssSafelyCallGenericFcnEnd; \
   }
#endif

/* Region-wise memory access API */
typedef enum {
    MEM_REGION_SELECT_ALL = 0,
    MEM_REGION_STARTIDX_INCR_ENDIDX,
    MEM_REGION_VECTOR,
    MEM_REGION_VECTOR_FLATIDX
} SFcnMemRegionIndexMode_T;

typedef struct {
    SFcnMemRegionIndexMode_T indexMode;
    int                      numIndices;
    int                      *indices;
} SFcnSubMemRegionIndexInfo;

typedef struct {
    int         	      busElementIdx;
    int     		      numDims;
    SFcnSubMemRegionIndexInfo *subMemRegionIndexInfos;
} SFcnSubMemRegionInfo;

typedef struct {
    int                  numSubMemRegions;
    SFcnSubMemRegionInfo *subMemRegionInfos;
    /* Following fields for Simulink use only */
    boolean_T            cacheSlMemRootRegion;
    void                 *slMemRootRegion;
    char                 *memRegionExpr;
} SFcnMemRegionInfo;

typedef struct {
    const char        *bpath;
    void              *addr;
    SFcnMemRegionInfo *regionDescriptor;
} SFcnDataStoreMemRegionArg;

typedef struct {
    const char        *bpath;
    const void        *addr;
    SFcnMemRegionInfo *regionDescriptor;
} SFcnDataStoreMemRegionConstArg;

typedef struct {
    int               busElemIdx;
    int               numFlatElems;
    int               *flatElemIndices;
    SFcnMemRegionInfo *regionDescriptor;
} SFcnDataStoreFlatSubMemRegionArg;

typedef struct {
    const char *bpath;
    int        startOffset;
    int        endOffset;
    boolean_T  doRead; /* true: updates diagnostics for read operations,
                          false: updates diagnostics for write operations */
} SFcnDataStoreUpdateMemRegionArg;

/* APIs to create/destroy region descriptors */
#if SS_SFCN && SS_SIM
# define ssMemRegionCreateDescriptor(S, numSubMemRegions, memRegionDescriptor) \
   {\
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_CREATE_MEM_REGION_DESC, numSubMemRegions, (void *)memRegionDescriptor) \
    _ssSafelyCallGenericFcnEnd; \
   }

# define ssMemRegionSetFlatSubElement(S, memRegionDescriptor, subRegionIdx, busElementIdx, numFlatIdx, flatIdxs) \
   {\
    SFcnDataStoreFlatSubMemRegionArg locPI;\
    locPI.regionDescriptor = memRegionDescriptor;\
    locPI.busElemIdx = busElementIdx;\
    locPI.numFlatElems = numFlatIdx;\
    locPI.flatElemIndices = flatIdxs;\
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_SET_FLAT_MEM_SUB_REGION_DESC, subRegionIdx, &locPI) \
    _ssSafelyCallGenericFcnEnd; \
   }

# define ssMemRegionDestroyDescriptor(S, memRegionDescriptor) \
   {\
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_DESTROY_MEM_REGION_DESC, 0, (void *)memRegionDescriptor) \
    _ssSafelyCallGenericFcnEnd; \
   }
#endif

/* APIs to perform region-wise read/write */
#if SS_SFCN && SS_SIM
# define ssReadFromDataStoreRegionWithPath(S, dsmIdx, dsmBPath, dataAddr, dsmRegionDescriptor) \
   {\
    SFcnDataStoreMemRegionArg locPI;\
    locPI.bpath = dsmBPath;\
    locPI.addr = dataAddr;\
    locPI.regionDescriptor = dsmRegionDescriptor;\
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_READ_FROM_DATA_STORE_REGION, dsmIdx, &locPI)\
    _ssSafelyCallGenericFcnEnd; \
   }
# define ssReadFromDataStoreRegion(S, dsmIdx, dataAddr, dsmRegionDescriptor) \
    ssReadFromDataStoreRegionWithPath(S, dsmIdx, NULL, dataAddr, dsmRegionDescriptor)
#endif

#if SS_SFCN && SS_SIM
# define ssWriteToDataStoreRegionWithPath(S, dsmIdx, dsmBPath, dataAddr, dsmRegionDescriptor) \
   {\
    SFcnDataStoreMemRegionConstArg locPI;\
    locPI.bpath = dsmBPath;\
    locPI.addr = dataAddr;\
    locPI.regionDescriptor = dsmRegionDescriptor;\
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_WRITE_TO_DATA_STORE_REGION, dsmIdx, &locPI)\
    _ssSafelyCallGenericFcnEnd; \
   }
# define ssWriteToDataStoreRegion(S, dsmIdx, dataAddr, dsmRegionDescriptor) \
    ssWriteToDataStoreRegionWithPath(S, dsmIdx, NULL, dataAddr, dsmRegionDescriptor)
#endif

/* API to notify Simulink of region-wise read/write */
#if SS_SFCN && SS_SIM
# define ssUpdateDataStoreRegionDiagnostics(S, dsmIdx, dsmBPath, startOffset, endOffset, doRead) \
   {\
    SFcnDataStoreUpdateMemRegionArg locPI;\
    locPI.bpath = dsmBPath;\
    locPI.startOffset = startOffset;\
    locPI.endOffset = endOffset;\
    locPI.doRead = doRead;\
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_UPDATE_DATA_STORE_DIAGNOSTICS, dsmIdx, &locPI)\
    _ssSafelyCallGenericFcnEnd; \
   }
#endif

/* API to detect if read/write diagnostics are ON on a given data store memory */
#if SS_SFCN && SS_SIM
# define ssGetDataStoreRWDiagnosticsStatus(S, dsmIdx, dsmDiagStatus)  \
   {\
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_GET_DATA_STORE_DIAGNOSTICS_STATUS, dsmIdx, dsmDiagStatus)\
    _ssSafelyCallGenericFcnEnd; \
   }
#endif

/* end  Data Store API (internal Simulink use only) */
/*============================================================================*/

#if SS_SFCN && SS_SIM
#define ssGetRegSubmodelsMdlinfo(S, result) \
    {   \
        _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_GET_REG_SUBMODELS_MDLINFO, 0, result) \
        _ssSafelyCallGenericFcnEnd;      \
    }
#endif

#if SS_SFCN && SS_SIM
#define ssSetInputPortsNeedAddress(S, val) \
     _ssSafelyCallGenericFcnStart(S)(S,GEN_FCN_SET_INPUTS_NEED_ADDRESS, 0, val)\
     _ssSafelyCallGenericFcnEnd
#endif

#if SS_SFCN && SS_SIM
#define ssSetModelRefInlinedVars(S, num, val) \
     _ssSafelyCallGenericFcnStart(S)(S,GEN_FCN_SET_MODELREF_INLINED_VARS, num, val)\
     _ssSafelyCallGenericFcnEnd
#endif

/* ================== APIs for zero crossing =================================*/

typedef struct {
    int_T        _regionIdx;
    int_T        _regionElIdx;
    boolean_T    _result;
}_ssRegionElementIdxInfo;

#ifdef __cplusplus
extern "C" {
#endif

extern boolean_T ssGetIsZeroCrossControlDisabled(SimStruct *S);
extern void ssSetIsInputPortUsedForContZcSignal(SimStruct *S, int_T pIdx, boolean_T value);
extern void ssSetZcSignalIsZcElementDisc(SimStruct *S, int_T zcsIdx, int_T zcsElIdx, boolean_T value);
extern void ssSetZcSignalName(SimStruct *S, int_T zcsIdx, char* name);
extern void ssSetZcSignalWidth(SimStruct *S, int_T zcsIdx, int_T width);
extern void ssSetZcSignalZcEventType(SimStruct *S, int_T zcsIdx, slZcEventType zcEventType);
extern void ssSetZcSignalType(SimStruct *S, int_T zcsIdx, slZcSignalType zcSignalType);
extern void ssSetZcSignalZcTol(SimStruct *S, int_T zcsIdx,  double zcTol);
extern void ssSetZcSignalNeedsEventNotification(SimStruct *S, int_T zcsIdx, boolean_T needsEventNotification);

extern         int_T  ssCreateAndAddZcSignalInfo(SimStruct *S);
extern         int_T  ssCloneAndAddZcSignalInfo(SimStruct *S, int_T zcsIdx);
extern         int_T  ssGetNumZcSignals(SimStruct *S);

extern      double*   ssGetZcSignalVector(SimStruct *S, int_T zcsIdx);
extern const char*    ssGetZcSignalName(SimStruct *S, int_T zcsIdx);
extern       int_T    ssGetZcSignalWidth(SimStruct *S, int_T zcsIdx);
extern slZcEventType  ssGetZcSignalZcEventType(SimStruct *S, int_T zcsIdx);
extern slZcEventType* ssGetZcSignalZcEvents(SimStruct *S, int_T zcsIdx);
extern slZcSignalType ssGetZcSignalType(SimStruct *S, int_T zcsIdx);
extern double         ssGetZcSignalZcTol(SimStruct *S, int_T zcsIdx);
extern boolean_T      ssGetZcSignalNeedsEventNotification(SimStruct *S,

                                                          int_T zcsIdx);
extern boolean_T      ssGetZcSignalIsZcElementDisc(SimStruct *S,
                                                   int_T zcsIdx,
                                                   int_T zcsElIdx);

extern boolean_T      ssGetIsInputPortElementContinuous(SimStruct *S,
                                                        int_T pIdx,
                                                        int_T eIdx);
#ifdef __cplusplus
}
#endif

/* ================================================================= */

typedef enum {
    MDLREF_UNKNOWN = 0,
    MDLREF_ACCEL_SIM,
    MDLREF_NORMAL_SIM,
    MDLREF_RTW
} ssMdlRefType;

#if SS_SFCN && SS_SIM
# ifdef ssGetOwnerBlock
#   define ssGetModelReferenceType(S, val) \
    { \
     *(val) = MDLREF_UNKNOWN; \
     if (!((ssGetOwnerBlock(S) == NULL) && (ssGetParentSS(S) != NULL))) \
     { \
        _ssSafelyCallGenericFcnStart(S)(S,GEN_FCN_GET_MDLREF_TYPE, 0, val)\
        _ssSafelyCallGenericFcnEnd; \
     } \
    }
# endif
#else
# define ssGetModelReferenceType(S, val) \
     ssGetModelReferenceType_cannot_be_used_in_RTW
#endif


/* =======================================
 * Model reference definitions and macros.
 * =======================================*/

/* Model info types */
typedef enum {
    MDL_INFO_ID_PARAM = 0,
    MDL_INFO_ID_SIGNAL,
    MDL_INFO_ID_STATE,
    MDL_INFO_ID_DSM,
    MDL_INFO_ID_GLOBAL_DSM,
    MDL_INFO_ID_DATA_TYPE,
    MDL_INFO_ID_CMPLX_DATA_TYPE,
    MDL_INFO_ID_MODEL,
    MDL_INFO_ID_FCNNAME,
    MDL_INFO_ID_GRPFCNNAME,
    MDL_INFO_ID_CSC,
    MDL_INFO_ID_IMPORTED_CSC,
    MDL_INFO_SUBSYS_FILENAME,
    MDL_INFO_MODEL_FILENAME,
    MDL_INFO_ID_MACHINE_EXPORTED,
    MDL_INFO_NAME_GLOBAL_DSM,
    MDL_INFO_NAME_MDLREF_DWORK,
    MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT,
    MDL_INFO_ID_ENUMTYPE_STRING,
    MDL_INFO_ID_MODEL_FCN_ARGNAME,
    MDL_INFO_ID_MODEL_FCN_NAME,
    MDL_INFO_ID_MODEL_CLASS_NAME,
    MDL_INFO_ID_MODEL_CLASS_NAMESPACE,
    MDL_INFO_ID_AUTOSAR_RTE_FCN_NAME,
    MDL_INFO_ID_RESERVED,
    MDL_INFO_ID_VARIANT,
    NumMdlInfoType
} MdlInfoType;

/* Structure for mdl info from reference models */
typedef struct {
    const char  *id;               /* identifier associated with info */
    MdlInfoType infoType;          /* info type                       */
    boolean_T   extra_bool;        /* boolean value for arbitrary use */
    int_T       extra_int;         /* int value for arbitrary use     */
    const void  *extra_voidp;      /* pointer for arbitrary use       */
} RegMdlInfo;

/* Structure for set of mdl info from reference models */
typedef struct {
    char *modelName;          /* model name                      */
    RegMdlInfo *modelInfo;    /* info                            */
    int        numModelInfo;  /* number of records               */
} ModelRefMdlInfoSet;

/* Structure for referenced models info. mrBlk  is NULL when this structure
 * is registered by model reference accelerated target.
 */
typedef struct {
    char       *name;
    char       *path;
    boolean_T  isSingleInst;
} MdlRefChildMdlRec;

/* Structure for referenced models solver info */
typedef struct {
    int_T   zcControl;
    int_T   maxOrder;
    real_T  relTol;
    real_T  maxStepSize;
    real_T  minStepSize;
    real_T  initStepSize;
} ModelRefChildSolverInfo;

/* Structure for interface parameter information */
typedef struct ModelRefIntfParamInfo_tag {
    const char       *name;
    boolean_T        isUsed;
    int_T            nDims;
    int_T            *dims;
    boolean_T        isComplex;
    DTypeId          dTypeId;
    uint32_T         *dtChecksum;
    const char       *dtName;
    boolean_T        dtIsAnonymous;
} ModelRefIntfParamInfo;

/* Only used in MODELREF S-functions */
typedef enum {
    SS_OK_TO_MERGE_AUTO  = 0,  /* default */
    SS_OK_TO_MERGE,
    SS_NOT_OK_TO_MERGE,
    SS_OK_TO_MERGE_CONDITIONAL
} ssOkToMergeFlag;

# define ssGetOutputPortOkToMerge(S,port) \
      ((ssOkToMergeFlag)((S)->portInfo.outputs[(port)].attributes.okToMerge))

#if !SS_SFCN_LEVEL_1
# if SS_SIM
#  define _ssMdlInfoInit(name, infoTypeUsed, b, i, vp) \
     RegMdlInfo locPI; \
     locPI.id = name; \
     locPI.infoType = infoTypeUsed; \
     locPI.extra_bool = b; \
     locPI.extra_int = i; \
     locPI.extra_voidp = vp; \

#  define ssRegMdlInfo(S, id, infoType, b, i, vp) \
   { \
      _ssMdlInfoInit(id, infoType, b, i, vp) \
      if (!_ssSafelyCallGenericFcnStart(S) \
          (S, GEN_FCN_REG_MDL_INFO, 0, &locPI) \
          _ssSafelyCallGenericFcnEnd) return; \
   }
# else
#  define ssRegMdlInfo(S, id, infoType, b, i, vp)
# endif
#endif

typedef enum {
    SS_MDLREF_FUND_SAMPLETYPE_INFO_STR = 0,
    SS_MDLREF_FUND_SAMPLETYPE_INFO_VAL
} _ssMdlRefFundamentalSampleTimeInfoType;

#if SS_SFCN && SS_SIM
# define ssSetModelRefFundamentalSampleTimeInfo(S, fIdx, str) \
     _ssSafelyCallGenericFcnStart(S)(S,\
GEN_FCN_MODELREF_SET_FUNDAMENTAL_SAMPLE_TIME_INFO,(int)fIdx,(void *)str)\
     _ssSafelyCallGenericFcnEnd

# define ssSetModelRefTriggerTsTypeInfo(S, str) \
     _ssSafelyCallGenericFcnStart(S)(S,\
GEN_FCN_MODELREF_SET_TRIGGER_TS_TYPE_INFO,0,(void *)str)\
     _ssSafelyCallGenericFcnEnd

#define ssSetModelRefTriggerType(S, str) \
     _ssSafelyCallGenericFcnStart(S)(S,\
GEN_FCN_MODELREF_SET_TRIGGER_TYPE,0,(void *)str)\
     _ssSafelyCallGenericFcnEnd

#define ssSetModelRefHasEnablePort(S, val) \
     _ssSafelyCallGenericFcnStart(S)(S,\
GEN_FCN_MODELREF_HAS_ENABLE_PORT, val, NULL)\
     _ssSafelyCallGenericFcnEnd

#endif

typedef void (*ssModelRefSimTargetFunctionCallMethod)(void);
typedef void (*ssModelRefSimulinkAcceleratorFunctionCallMethod)(SimStruct *);

typedef enum {
    SS_MODELREF_FCNCALL_OUTPUT,
    SS_MODELREF_FCNCALL_ENABLE,
    SS_MODELREF_FCNCALL_DISABLE
} ModelRefFcnCallMethodType;


typedef struct _ModelRefSimTargetFunctionCallMethodInfo_tag {
    const char* key;
    ssModelRefSimTargetFunctionCallMethod method;
    ModelRefFcnCallMethodType type;
} ssModelRefSimTargetFunctionCallMethodInfo;

typedef struct _ModelRefSimulinkAcceleratorFunctionCallMethodInfo_tag {
    int sysIndex;
    int blkIndex;
    int portNum;
    ssModelRefSimulinkAcceleratorFunctionCallMethod method;
    ModelRefFcnCallMethodType type;
} ssModelRefSimulinkAcceleratorFunctionCallMethodInfo;

#if SS_SFCN && SS_SIM

#define ssSetModelRefSimFcnCallOutputInfo(S, srcKey, dstPrt) \
    _ssSafelyCallGenericFcnStart(S)((S),                                \
        GEN_FCN_MODELREF_REGISTER_SIM_FCN_CALL_OUTPUT, (dstPrt), (srcKey)) \
    _ssSafelyCallGenericFcnEnd;


#define ssSetModelRefSimTargetFcnCallMethod(S, srcKey, fcnPtr, fcnType) \
    { \
      ssModelRefSimTargetFunctionCallMethodInfo _fcnInfo; \
      _fcnInfo.key    = (srcKey); \
      _fcnInfo.method = (fcnPtr); \
      _fcnInfo.type   = (fcnType); \
      _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_MODELREF_REGISTER_SIM_TARGET_FCN_CALL_METHOD, \
                                      -1, &_fcnInfo) \
      _ssSafelyCallGenericFcnEnd; \
    }

#define ssSetModelRefSimulinkAcceleratorFcnCallMethod(S, sysIdx, blkIdx, portNumber, fcnPtr, fcnType) \
    { \
      ssModelRefSimulinkAcceleratorFunctionCallMethodInfo _fcnInfo; \
      _fcnInfo.sysIndex = (sysIdx); \
      _fcnInfo.blkIndex = (blkIdx); \
      _fcnInfo.method   = (fcnPtr); \
      _fcnInfo.type     = (fcnType); \
      _fcnInfo.portNum  = (portNumber); \
      _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_MODELREF_REGISTER_SIMULINK_ACCELERATOR_FCN_CALL_METHOD, \
                                      -1, &_fcnInfo) \
      _ssSafelyCallGenericFcnEnd; \
    }

# define ssSetOutputPortOkToMerge(S,port,val) \
    (S)->portInfo.outputs[(port)].attributes.okToMerge = (ssOkToMergeFlag)(val)

#define ssRegMdlRefDWorkType(S, type) \
_ssSafelyCallGenericFcnStart(S)(S, GEN_FCN_REG_MDLREF_DWORK_TYPE, 0, type)\
_ssSafelyCallGenericFcnEnd


/* Names of the ToFile's for a submodel*/
#define ssSetModelRefToFiles(S,num,str) \
_ssSafelyCallGenericFcnStart(S)(S, GEN_FCN_SET_MODELREF_TO_FILES, num, str)\
_ssSafelyCallGenericFcnEnd

#define ssFileLoggingManagerAddElement(S, ptr) \
_ssSafelyCallGenericFcnStart(S)(S, GEN_FCN_FILE_LOGGING_MANAGER_ADD_ELEMENT, 0, ptr)\
_ssSafelyCallGenericFcnEnd

#define ssFileLoggingManagerRemoveElement(S, ptr) \
_ssSafelyCallGenericFcnStart(S)(S, GEN_FCN_FILE_LOGGING_MANAGER_REMOVE_ELEMENT, 0, ptr)\
_ssSafelyCallGenericFcnEnd

/* Names of the FromFile's for a submodel*/
#define ssSetModelRefFromFiles(S,num,str) \
_ssSafelyCallGenericFcnStart(S)(S, GEN_FCN_SET_MODELREF_FROM_FILES, num, str)\
_ssSafelyCallGenericFcnEnd

# define ssSetModelRefInputSignalDesignMin(S,num,valPtr) \
     _ssSafelyCallGenericFcnStart(S)(S,\
GEN_FCN_SET_MODELREF_INPUT_SIGNAL_DESIGN_MIN,num,valPtr)\
     _ssSafelyCallGenericFcnEnd

# define ssSetModelRefInputSignalDesignMax(S,num,valPtr) \
     _ssSafelyCallGenericFcnStart(S)(S,\
GEN_FCN_SET_MODELREF_INPUT_SIGNAL_DESIGN_MAX,num,valPtr)\
     _ssSafelyCallGenericFcnEnd

# define ssSetModelRefOutputSignalDesignMin(S,num,valPtr) \
     _ssSafelyCallGenericFcnStart(S)(S,\
GEN_FCN_SET_MODELREF_OUTPUT_SIGNAL_DESIGN_MIN,num,valPtr)\
     _ssSafelyCallGenericFcnEnd

# define ssSetModelRefOutputSignalDesignMax(S,num,valPtr) \
     _ssSafelyCallGenericFcnStart(S)(S,\
GEN_FCN_SET_MODELREF_OUTPUT_SIGNAL_DESIGN_MAX,num,valPtr)\
     _ssSafelyCallGenericFcnEnd

# define ssSetModelRefPortRTWStorageClasses(S, str) \
     _ssSafelyCallGenericFcnStart(S)(S,\
GEN_FCN_SET_MODELREF_STORAGE_CLASSES,0,str)\
     _ssSafelyCallGenericFcnEnd

# define ssSetModelRefPortRTWStorageTypeQualifiers(S, str) \
     _ssSafelyCallGenericFcnStart(S)(S,\
GEN_FCN_SET_MODELREF_STORAGE_TYPE_QUALIFIERS,0,str)\
     _ssSafelyCallGenericFcnEnd

# define ssSetModelRefPortResolvedToSignalObjects(S, str) \
     _ssSafelyCallGenericFcnStart(S)(S,\
GEN_FCN_SET_MODELREF_PORT_RESOLVED_TO_SIGNAL_OBJECTS,0,str)\
     _ssSafelyCallGenericFcnEnd

# define ssSetModelRefPortRTWIdentifiers(S, str) \
     _ssSafelyCallGenericFcnStart(S)(S,\
GEN_FCN_SET_MODELREF_IDENTIFIERS,0,str)\
     _ssSafelyCallGenericFcnEnd

# define ssSetModelRefPortRTWTestPoints(S, str) \
     _ssSafelyCallGenericFcnStart(S)(S,\
GEN_FCN_SET_MODELREF_TEST_POINTS,0,str)\
     _ssSafelyCallGenericFcnEnd

# define ssSetModelMappingInfoPtr(S, ptr) \
     _ssSafelyCallGenericFcnStart(S)(S,\
GEN_FCN_SET_MODELMAPPINGINFO,0,ptr)\
     _ssSafelyCallGenericFcnEnd

# define ssSetNumModelRefParamArgs(S, nParams) \
     _ssSafelyCallGenericFcnStart(S)(S, \
GEN_FCN_SET_NUM_MODELREF_INTFPARAM_ARGS, nParams, NULL) \
     _ssSafelyCallGenericFcnEnd

# define ssSetNumModelRefGlobalParams(S, nParams) \
     _ssSafelyCallGenericFcnStart(S)(S, \
GEN_FCN_SET_NUM_MODELREF_INTFPARAM_GLOBALS, nParams, NULL) \
     _ssSafelyCallGenericFcnEnd

# define _ssMdlInfoSetInit(name, info, num) \
     ModelRefMdlInfoSet locPI; \
     locPI.modelName = (name); \
     locPI.modelInfo = (info); \
     locPI.numModelInfo = (num); \

# define ssRegModelRefMdlInfo(S, name, info, num) \
   { \
      _ssMdlInfoSetInit((name), (info), (num)) \
      if (!_ssSafelyCallGenericFcnStart(S) \
          (S, GEN_FCN_REG_MODELREF_MDL_INFO, 0, &locPI) \
          _ssSafelyCallGenericFcnEnd) return; \
   }

# define ssRegModelRefChildModel(S, numMdls,modelList) \
_ssSafelyCallGenericFcnStart(S)(S,\
          GEN_FCN_REG_MODELREF_CHILD_MODEL,numMdls,modelList)\
      _ssSafelyCallGenericFcnEnd

# define _ssModelRefIntfParamInfoInit(id, used, numDims, dimsPtr, cplx, dtId) \
     ModelRefIntfParamInfo locPI; \
     locPI.name = id; \
     locPI.isUsed = used; \
     locPI.nDims = numDims; \
     locPI.dims = dimsPtr; \
     locPI.isComplex = cplx; \
     locPI.dTypeId = dtId; \
     locPI.dtChecksum = NULL; \
     locPI.dtName = NULL; \
     locPI.dtIsAnonymous = 0;

# define _ssModelRefIntfStructParamInfoInit(id, used, numDims, dimsPtr, cplx, dtchksum, \
                                            dtname, dtanonymous) \
     ModelRefIntfParamInfo locPI; \
     locPI.name = id; \
     locPI.isUsed = used; \
     locPI.nDims = numDims; \
     locPI.dims = dimsPtr; \
     locPI.isComplex = cplx; \
     locPI.dTypeId = INVALID_DTYPE_ID; \
     locPI.dtChecksum = dtchksum; \
     locPI.dtName = dtname; \
     locPI.dtIsAnonymous = dtanonymous;

# define ssRegModelRefParamArg(S, pIdx, id, used, numDims, dimsPtr, cplx, dtId) \
   { \
      _ssModelRefIntfParamInfoInit( \
               id, used, numDims, dimsPtr, cplx, dtId) \
         if (!_ssSafelyCallGenericFcnStart(S)(S, \
GEN_FCN_REG_MODELREF_INTFPARAM_ARG, pIdx, &locPI) \
         _ssSafelyCallGenericFcnEnd) return; \
   }

# define ssRegModelRefStructParamArg(S, pIdx, id, used, numDims, dimsPtr, cplx, dtChecksum, \
                                     dtName, dtIsAnonymous) \
   { \
      _ssModelRefIntfStructParamInfoInit( \
          id, used, numDims, dimsPtr, cplx, dtChecksum, dtName, dtIsAnonymous) \
         if (!_ssSafelyCallGenericFcnStart(S)(S, \
GEN_FCN_REG_MODELREF_INTFPARAM_ARG, pIdx, &locPI) \
         _ssSafelyCallGenericFcnEnd) return; \
   }

# define ssRegModelRefGlobalVarUsage(S, numVars, varList)        \
     _ssSafelyCallGenericFcnStart(S)(S, \
       GEN_FCN_REG_MODELREF_GLOBAL_VARUSAGE, numVars, varList) \
     _ssSafelyCallGenericFcnEnd


# define ssRegModelRefScaledDoubleParamArg(S, pIdx, id, used, numDims, dimsPtr, cplx, \
                          isSigned, nBits, fracSlope, fixSlope, bias, override) \
   { \
     DTypeId fixptDTId = ssRegisterDataTypeFxpScaledDouble(S, \
       isSigned, nBits, (double) fracSlope, fixSlope, (double) bias, override); \
     if (fixptDTId == INVALID_DTYPE_ID) return; \
     ssRegModelRefParamArg(S, pIdx, id, used, numDims, dimsPtr, cplx, fixptDTId); \
   }

# define ssRegModelRefFixptParamArg(S, pIdx, id, used, numDims, dimsPtr, cplx, \
       isSigned, nBits, fracSlope, fixSlope, bias, override) \
   { \
     DTypeId fixptDTId = ssRegisterDataTypeFxpFSlopeFixExpBias(S, \
       isSigned, nBits, (double) fracSlope, fixSlope, (double) bias, override); \
     if (fixptDTId == INVALID_DTYPE_ID) return; \
     ssRegModelRefParamArg(S, pIdx, id, used, numDims, dimsPtr, cplx, fixptDTId); \
   }

# define ssGetModelRefParamArgData(S, pIdx, dataPtr) \
     _ssSafelyCallGenericFcnStart(S)(S, \
GEN_FCN_GET_MODELREF_INTFPARAM_ARG_DATA, pIdx, (void *)dataPtr) \
     _ssSafelyCallGenericFcnEnd

# define ssRegModelRefGlobalParam(S, pIdx, id, numDims, dimsPtr, cplx, dtId) \
   { \
      _ssModelRefIntfParamInfoInit( \
               id, 1 /* isUsed */, numDims, dimsPtr, cplx, dtId) \
         if (!_ssSafelyCallGenericFcnStart(S)(S, \
GEN_FCN_REG_MODELREF_INTFPARAM_GLOBAL, pIdx, &locPI) \
         _ssSafelyCallGenericFcnEnd) return; \
   }

# define ssRegModelRefStructGlobalParam(S, pIdx, id, numDims, dimsPtr, cplx, dtChecksum, \
                                        dtName, dtIsAnonymous ) \
   { \
      _ssModelRefIntfStructParamInfoInit( \
          id, 1 /* isUsed */, numDims, dimsPtr, cplx, dtChecksum, dtName, dtIsAnonymous) \
         if (!_ssSafelyCallGenericFcnStart(S)(S, \
GEN_FCN_REG_MODELREF_INTFPARAM_GLOBAL, pIdx, &locPI) \
         _ssSafelyCallGenericFcnEnd) return; \
   }

# define ssRegModelRefConstantValuedOutputChecksum(S, portIdx, checksum)  \
   { \
       _ssSafelyCallGenericFcnStart(S)(S, GEN_FCN_REG_MODELREF_CONSTANT_VALUED_OUTPUT_CHECKSUM, \
                                       portIdx, checksum) \
           _ssSafelyCallGenericFcnEnd;              \
   }


# define ssRegModelRefScaledDoubleGlobalParam(S, pIdx, id, numDims, dimsPtr, cplx, \
                          isSigned, nBits, fracSlope, fixSlope, bias, override) \
   { \
     DTypeId fixptDTId = ssRegisterDataTypeFxpScaledDouble(S, \
       isSigned, nBits, (double) fracSlope, fixSlope, (double) bias, override); \
     if (fixptDTId == INVALID_DTYPE_ID) return; \
     ssRegModelRefGlobalParam(S, pIdx, id, numDims, dimsPtr, cplx, fixptDTId); \
   }

# define ssRegModelRefFixptGlobalParam(S, pIdx, id, numDims, dimsPtr, cplx, \
       isSigned, nBits, fracSlope, fixSlope, bias, override) \
   { \
     DTypeId fixptDTId = ssRegisterDataTypeFxpFSlopeFixExpBias(S, \
       isSigned, nBits, (double) fracSlope, fixSlope, (double) bias, override); \
     if (fixptDTId == INVALID_DTYPE_ID) return; \
     ssRegModelRefGlobalParam(S, pIdx, id, numDims, dimsPtr, cplx, fixptDTId); \
   }

# define ssGetModelRefGlobalParamData(S, pIdx, dataPtr) \
     _ssSafelyCallGenericFcnStart(S)(S, \
GEN_FCN_GET_MODELREF_INTFPARAM_GLOBAL_DATA, pIdx, (void *)dataPtr) \
     _ssSafelyCallGenericFcnEnd

/* Does an assignment block live in this model?*/
#define ssSetNonIteratorAssignmentBlock(S, str) \
_ssSafelyCallGenericFcnStart(S)(S, \
GEN_FCN_SET_NONITERATOR_ASSIGNMENT_BLOCK, 0, str)\
_ssSafelyCallGenericFcnEnd

/* Does this model optimize init code for modelref? */
#define ssSetOptimizeModelRefInitCode(S, val) \
_ssSafelyCallGenericFcnStart(S)(S, \
 GEN_FCN_SET_OPTIMIZE_MODELREF_INIT_CODE, val, NULL)\
_ssSafelyCallGenericFcnEnd

#endif

#define ssGetModelReferenceSampleTimeInheritanceRule(S) \
          (S)->sizes.flags.modelRefTsInhSupLevel
#define ssSetModelReferenceSampleTimeInheritanceRule(S,n) \
          (S)->sizes.flags.modelRefTsInhSupLevel = (n)
#define ssSetModelReferenceSampleTimeDefaultInheritance(S)\
          (S)->sizes.flags.modelRefTsInhSupLevel = \
USE_DEFAULT_FOR_DISCRETE_INHERITANCE
#define ssSetModelReferenceSampleTimeDisallowInheritance(S)\
          (S)->sizes.flags.modelRefTsInhSupLevel = \
DISALLOW_SAMPLE_TIME_INHERITANCE

#define ssGetSimStateCompliance(S) \
    ((ssSimStateCompliance)((S)->sizes.flags.simStateCompliance))

#define ssSetSimStateCompliance(S, set)   \
    (S)->sizes.flags.simStateCompliance = (set)

#define ssGetSimStateVisibility(S) \
    ((S)->sizes.flags.simStateVisibility)

#define ssSetSimStateVisibility(S, vis)   \
    (S)->sizes.flags.simStateVisibility = (vis)

/*-------------------------------- S->states --------------------------------*/

/* U - This is the input to your S-function providing you have not specified
 *   the SS_OPTION_USING_ssGetUPtrs. For the root SimStruct this
 *   is the external input vector.
 */
#if SS_SFCN_LEVEL_1 && SS_SIM && !SS_NDEBUG
   extern void *_ssGetUFcn(const SimStruct *S);
#  define _ssGetU(S) ((real_T*)_ssGetUFcn(S))
#else
#  define _ssGetU(S) \
          ((real_T*)(S)->states.U.vect)             /* (const real_T *) */
#endif

#if !SS_SFCN_NORMAL
# define ssGetU(S) \
          _ssGetU(S)
# define _ssSetU(S,u) \
          (S)->states.U.vect = (u)
#endif
#if !SS_SFCN
# define ssSetU(S,u) _ssSetU(S,u)
#else
# define ssSetU(S,u) ssSetU_cannot_be_used_in_SFunctions
#endif

#if !SS_SFCN
# define ssGetExternalU(S) \
          ((S)->states.U.vect)
#endif


/* UPtrs - This returns an array of input pointers (UPtrsType) to your
 *   S-function block. This should only be used when using the
 *   SS_OPTION_USING_ssGetUPtrs (level 1 S-functions only).
 */
#if !SS_SFCN_NORMAL
# define ssGetUPtrs(S) \
          (S)->states.U.uPtrs                            /* (UPtrsType)      */
# define _ssSetUPtrs(S,uptrs) \
          (S)->states.U.uPtrs = (uptrs)
#endif
#if !SS_SFCN
# define ssSetUPtrs(S,uptrs) _ssSetUPtrs(S,uptrs)
#else
# define ssSetUPtrs(S,uptrs) ssSetUPtrs_cannot_be_used_in_SFunctions
#endif


/* Y - This is the output vector for your S-function block. For the root
 *   SimStruct, this is the external output vector. The length of this
 *   vector is ssGetNumOutputs.
 */
#define _ssGetY(S) \
           ((real_T *)((S)->states.Y))                   /*   (real_T *)    */

#if !SS_SFCN_NORMAL
# define ssGetY(S) \
           _ssGetY(S)
# define _ssSetY(S,y) \
          (S)->states.Y = ((void *)(y))
#endif
#if !SS_SFCN
# define ssSetY(S,y) _ssSetY(S,y)
#else
# define ssSetY(S,y) ssSetY_cannot_be_used_in_SFunctions
#endif


#if !SS_SFCN
# define ssGetExternalY(S) \
          (S)->states.Y
#endif



#if SS_SFCN_LEVEL_1
 /* X - This is the state vector for your S-function block. The length of
  *  vector is ssGetNumTotalStates. The first part of the vector
  *  is for the continuous state elements consisting of ssGetNumContStates
  *  and the second part of the vector is the discrete state elements
  *  consisting of ssGetNumDiscStates. For the root model, SimStruct, this
  *  contains the states of all blocks with in the model.
  */
# define ssGetX(S) \
          (S)->states.contStates                          /*   (real_T *)    */
# define _ssSetX(S,x) \
          (S)->states.contStates = (x)

#else

/*
 * ContStates - continuous state vector for your S-function. There is
 *   no guarantee that if you have both continuous and discrete states
 *   that they will be contiguous
 */
# define ssGetContStates(S) \
          (S)->states.contStates                          /*   (real_T *)    */
# define _ssSetContStates(S,contX) \
          (S)->states.contStates = (contX)
# if !SS_SFCN
#   define ssGetX(S)                ssGetContStates(S)
#   define ssSetContStates(S,contX) _ssSetContStates(S,contX)
# else
#   define ssSetContStates(S,x) ssSetContStates_cannot_be_used_in_SFunctions
# endif

/*
 * DiscStates - discrete state vector for your S-function.
 */
# define ssGetDiscStates(S)      ((S)->states.discStates) /*   (real_T *)    */

# define ssGetRealDiscStates(S)  ssGetDiscStates(S)       /*   (real_T *)    */

# define _ssSetDiscStates(S,discX) \
          (S)->states.discStates = (discX)
# if !SS_SFCN
#   define ssSetDiscStates(S,discX) _ssSetDiscStates(S,discX)
# else
#   define ssSetDiscStates(S,x) ssSetDiscStates_cannot_be_used_in_SFunctions
# endif

#endif


/* dX - This is the continuous state derivative vector for your S-function
 *  block. The length of this vector is ssGetNumContStates. This pointer
 *  changes as the solver evaluates different integration stages to compute
 *  the integral. For the root model SimStruct, this contains the derivatives
 *  for all continuous states of all blocks with in the model.
 */
#define ssGetdX(S) \
          (S)->states.dX                                  /*   (real_T *)    */
#define _ssSetdX(S,dx) \
          (S)->states.dX = (dx)
#if !SS_SFCN
#define ssSetdX(S,dx) _ssSetdX(S,dx)
#else
#define ssSetdX(S,dx) ssSetdX_cannot_be_used_in_SFunctions
#endif


/* slvrJacobian */
/* mdlSlvrJacobian was removed for R2012b) */
/* slvrJacobian - This struct contains the slvrJacobian matrix for your S-function
 *   block.  The size of this matrix is (nxc + ny) x (nxc + nu).
 *   All of the storage involved will be allocated automatically, provided
 *   that nzmax is set to the correct value (or a number larger than the
 *   correct value).  Setting nzmax == -1 will construct a full matrix.  It
 *   is then your responsibility to fill in correct values for *pr, *ir, *jc.
 */


#define ssGetSlvrJacobianNzMax(S) \
    ((S)->states.modelMethods2->modelMethods3->numSlvrJacobianNzmax)
#define ssSetSlvrJacobianNzMax(S,n) \
    ((S)->states.modelMethods2->modelMethods3->numSlvrJacobianNzmax = (n))

#define ssGetSlvrJacobianHeader(S) \
    ((S)->states.modelMethods2->modelMethods3->slvrJacobianMatrix)
#define _ssSetSlvrJacobianHeader(S,p) \
    ((S)->states.modelMethods2->modelMethods3->slvrJacobianMatrix  = (p))

#if !SS_SFCN
#define ssSetSlvrJacobianHeader(S,p) _ssSetSlvrJacobianHeader(S,p)
#else
#define ssSetSlvrJacobianHeader(S,p) ssSetSlvrJacobianHeader_cannot_be_used_in_SFunctions
#endif

#define ssGetSlvrJacobianPr(S) \
    ((S)->states.modelMethods2->modelMethods3->slvrJacobianMatrix->Pr )
#define _ssSetSlvrJacobianPr(S,pr) \
    ((S)->states.modelMethods2->modelMethods3->slvrJacobianMatrix->Pr = (pr))

#if !SS_SFCN
#define ssSetSlvrJacobianPr(S,pr) _ssSetSlvrJacobianPr(S,pr)
#else
#define ssSetSlvrJacobianPr(S,pr) ssSetSlvrJacobian_cannot_be_used_in_SFunctions
#endif

#define ssGetSlvrJacobianIr(S) \
    ((S)->states.modelMethods2->modelMethods3->slvrJacobianMatrix->Ir)
#define _ssSetSlvrJacobianIr(S,ir) \
    ((S)->states.modelMethods2->modelMethods3->slvrJacobianMatrix->Ir = (ir))
#if !SS_SFCN
#define ssSetSlvrJacobianIr(S,ir) _ssSetSlvrJacobianIr(S,ir)
#else
#define ssSetSlvrJacobianIr(S,ir) ssSetSlvrJacobianIr_cannot_be_used_in_SFunctions
#endif

#define ssGetSlvrJacobianJc(S) \
    ((S)->states.modelMethods2->modelMethods3->slvrJacobianMatrix->Jc)
#define _ssSetSlvrJacobianJc(S,jc) \
    ((S)->states.modelMethods2->modelMethods3->slvrJacobianMatrix->Jc = (jc))
#if !SS_SFCN
#define ssSetSlvrJacobianJc(S,jc) _ssSetSlvrJacobianJc(S,jc)
#else
#define ssSetSlvrJacobianJc(S,jc) ssSetSlvrJacobianJc_cannot_be_used_in_SFunctions
#endif

#define ssGetSlvrJacobianM(S) \
    ((S)->states.modelMethods2->modelMethods3->slvrJacobianMatrix->mRows)
#define _ssSetSlvrJacobianM(S,m) \
    ((S)->states.modelMethods2->modelMethods3->slvrJacobianMatrix->mRows )
#if !SS_SFCN
#define ssSetSlvrJacobianM(S,m) _ssSetSlvrJacobianM(S,m)
#else
#define ssSetSlvrJacobianM(S,m) ssSetSlvrJacobianM_cannot_be_used_in_SFunctions
#endif

#define ssGetSlvrJacobianN(S) \
    ((S)->states.modelMethods2->modelMethods3->slvrJacobianMatrix->nCols)
#define _ssSetSlvrJacobianN(S,n) \
    ((S)->states.modelMethods2->modelMethods3->slvrJacobianMatrix->nCols = (n))
#if !SS_SFCN
#define ssSetSlvrJacobianN(S,n) _ssSetSlvrJacobianN(S,n)
#else
#define ssSetSlvrJacobianN(S,n) ssSetSlvrJacobianN_cannot_be_used_in_SFunctions
#endif


/* Jacobian - This struct contains the Jacobian matrix for your S-function
 *   block.  The size of this matrix is (nxc + nxd + ny) x (nxc + ndx + nu).
 *   All of the storage involved will be allocated automatically, provided
 *   that nzmax is set to the correct value (or a number larger than the
 *   correct value).  Setting nzmax == -1 will construct a full matrix.  It
 *   is then your responsibility to fill in correct values for *pr, *ir, *jc.
 *   The values for *ir and *jc should be initialized in function mdlJacobianIrJc.
 */
#define ssGetJacobianNzMax(S) \
          (S)->sizes.numJacobianNzMax                 /*   (int_T)    */
#define ssSetJacobianNzMax(S,n) \
          (S)->sizes.numJacobianNzMax = (n)

#define ssGetJacobianHeader(S) \
          (S)->states.jacobian                        /* (SparseHeader *) */
#define _ssSetJacobianHeader(S,p) \
          (S)->states.jacobian = (p)
#if !SS_SFCN
#define ssSetJacobianHeader(S,p) _ssSetJacobianHeader(S,p)
#else
#define ssSetJacobianHeader(S,p) ssSetJacobianHeader_cannot_be_used_in_SFunctions
#endif

#define ssGetJacobianPr(S) \
          (S)->states.jacobian->Pr                 /*   (real_T *)    */
#define _ssSetJacobianPr(S,pr) \
          (S)->states.jacobian->Pr = (pr)
#if !SS_SFCN
#define ssSetJacobianPr(S,pr) _ssSetJacobianPr(S,pr)
#else
#define ssSetJacobianPr(S,pr) ssSetJacobian_cannot_be_used_in_SFunctions
#endif

#define ssGetJacobianIr(S) \
          (S)->states.jacobian->Ir                 /*   (int_T *)    */
#define _ssSetJacobianIr(S,ir) \
          (S)->states.jacobian->Ir = (ir)
#if !SS_SFCN
#define ssSetJacobianIr(S,ir) _ssSetJacobianIr(S,ir)
#else
#define ssSetJacobianIr(S,ir) ssSetJacobianIr_cannot_be_used_in_SFunctions
#endif

#define ssGetJacobianJc(S) \
          (S)->states.jacobian->Jc                 /*   (int_T *)    */
#define _ssSetJacobianJc(S,jc) \
          (S)->states.jacobian->Jc = (jc)
#if !SS_SFCN
#define ssSetJacobianJc(S,jc) _ssSetJacobianJc(S,jc)
#else
#define ssSetJacobianJc(S,jc) ssSetJacobianJc_cannot_be_used_in_SFunctions
#endif

#define ssGetJacobianM(S) \
          (S)->states.jacobian->mRows                 /*   (int_T *)    */
#define _ssSetJacobianM(S,m) \
          (S)->states.jacobian->mRows = (m)
#if !SS_SFCN
#define ssSetJacobianM(S,m) _ssSetJacobianM(S,m)
#else
#define ssSetJacobianM(S,m) ssSetJacobianM_cannot_be_used_in_SFunctions
#endif

#define ssGetJacobianN(S) \
          (S)->states.jacobian->nCols                 /*   (int_T *)    */
#define _ssSetJacobianN(S,n) \
          (S)->states.jacobian->nCols = (n)
#if !SS_SFCN
#define ssSetJacobianN(S,n) _ssSetJacobianN(S,n)
#else
#define ssSetJacobianN(S,n) ssSetJacobianN_cannot_be_used_in_SFunctions
#endif

typedef enum {
       SS_JACOBIAN_NOT_SUPPORTED=0,
       SS_JACOBIAN_EXACT,
       SS_JACOBIAN_CUSTOMIZED
} SFcnJacobianType;

#define _ssSetJacobianTypeAndMsg(S, type, msg)\
{\
    _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_SET_JACOBIAN_FLAG, type, msg)\
        _ssSafelyCallGenericFcnEnd;\
}

#define ssSetJacobianTypeAndMsg(S, type, msg) _ssSetJacobianTypeAndMsg(S, type, msg)
#define ssSetJacobianType(S, type) _ssSetJacobianTypeAndMsg(S, type, NULL)

#define ssCallDefaultJacobianMethod(S) \
{\
    _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_CALL_DEFAULT_JACOBIAN, 0,NULL) \
     _ssSafelyCallGenericFcnEnd;\
}

#define ssConfigDefaultJacobian(S) \
{\
    ssSetJacobianNzMax(S, -1); \
    _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_CONFIG_DEFAULT_JACOBIAN, 0,NULL) \
    _ssSafelyCallGenericFcnEnd;\
}


/* SupportRunTimeModelAPI - Runtime model API refers to the model function with
'outputs', 'derivs' and 'update' command. If the S-function block writes to
any persistent memory during mdlOutputs function, e.g., either dWork or a
persistent variable, it is likely that these block may need to set this
flag to false.

Similarly, if the S-function block writes to any persistent memory other than dX
in the mdlDerivatives, or if the S-function block writes to any persistent memory
other than the discrete states in mdlUpdate, it is likely that this flag needs
to be set to false.

The default value for the flag is true.
 */
#define ssSetSupportRunTimeModelAPI(S, arg)\
{\
    _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_SET_SUPPORT_RUNTIME_MODEL_API,arg, NULL)\
        _ssSafelyCallGenericFcnEnd;\
}
/* MassMatrix - This struct contains the MassMatrix for your S-function
 *   block.  The size of this matrix is nx x nx.
 *   All of the storage involved will be allocated automatically, provided
 *   that nzmax is set to the correct value (or a number larger than the
 *   correct value).
 */

#define ssGetMassMatrixType(S) \
          (S)->states.modelMethods2->modelMethods3->massMatrix.type    /*   (ssMatrixType)  */
#define ssSetMassMatrixType(S,t) \
          (S)->states.modelMethods2->modelMethods3->massMatrix.type = (t)

#define ssGetMassMatrixNzMax(S) \
          (S)->states.modelMethods2->modelMethods3->massMatrix.info.nzMax   /*   (int_T)    */
#define ssSetMassMatrixNzMax(S,n) \
          (S)->states.modelMethods2->modelMethods3->massMatrix.info.nzMax = (n)

#define ssGetMassMatrixIr(S) \
          (S)->states.modelMethods2->modelMethods3->massMatrix.info.Ir     /*   (int_T *)    */
#define _ssSetMassMatrixIr(S,ir) \
          (S)->states.modelMethods2->modelMethods3->massMatrix.info.Ir = (ir)
#if !SS_SFCN
#define ssSetMassMatrixIr(S,ir) _ssSetMassMatrixIr(S,ir)
#else
#define ssSetMassMatrixIr(S,ir) ssSetMassMatrixIr_cannot_be_used_in_SFunctions
#endif

#define ssGetMassMatrixJc(S) \
          (S)->states.modelMethods2->modelMethods3->massMatrix.info.Jc     /*   (int_T *)    */
#define _ssSetMassMatrixJc(S,jc) \
          (S)->states.modelMethods2->modelMethods3->massMatrix.info.Jc = (jc)
#if !SS_SFCN
#define ssSetMassMatrixJc(S,jc) _ssSetMassMatrixJc(S,jc)
#else
#define ssSetMassMatrixJc(S,jc) ssSetMassMatrixJc_cannot_be_used_in_SFunctions
#endif

#define ssGetMassMatrixPr(S) \
          (S)->states.modelMethods2->modelMethods3->massMatrix.info.Pr     /*   (real_T *)    */
#define _ssSetMassMatrixPr(S,pr) \
          (S)->states.modelMethods2->modelMethods3->massMatrix.info.Pr = (pr)
#if !SS_SFCN
#define ssSetMassMatrixPr(S,pr) _ssSetMassMatrixPr(S,pr)
#else
#define ssSetMassMatrixPr(S,pr) ssSetMassMatrix_cannot_be_used_in_SFunctions
#endif


/* Constraints - This struct contains the Constraints info
 *   for your S-function block.
 */
#define _ssGetConstraintsInfo(S) \
          (S)->states.modelMethods2->constraintsInfo     /* (_ssConstraintsInfo *) */
#if !SS_SFCN
#define ssGetConstraintsInfo(S) _ssGetConstraintsInfo(S)
#else
#define ssGetConstraintsInfo(S) ssGetConstraintsInfo_cannot_be_used_in_SFunctions
#endif

#define _ssSetConstraintsInfo(S,p) \
          (S)->states.modelMethods2->constraintsInfo = (p)
#if !SS_SFCN
#define ssSetConstraintsInfo(S,p) _ssSetConstraintsInfo(S,p)
#else
#define ssSetConstraintsInfo(S,p) ssSetConstraintsInfo_cannot_be_used_in_SFunctions
#endif

#define _ssSetConstraints(S,p) \
          (S)->states.modelMethods2->constraintsInfo->constraints = (p)
#if !SS_SFCN
#define ssSetConstraints(S,p) _ssSetConstraints(S,p)
#else
#define ssSetConstraints(S,p) ssSetConstraints_cannot_be_used_in_SFunctions
#endif

/* These are only used in command line model API, they do nothing in the generated code */
/* The constraintInfo data structure is not created/present in generated code           */
#if SS_SL_INTERNAL || SS_SFCN_FOR_SIM
# define ssSetNumConstraints(S,n) \
          (S)->states.modelMethods2->constraintsInfo->numConstraints = (n)
# define ssGetNumConstraints(S) \
          (S)->states.modelMethods2->constraintsInfo->numConstraints    /*  (int_T)     */
# define ssGetConstraints(S) \
          (S)->states.modelMethods2->constraintsInfo->constraints       /*  (real_T *)  */
#else /* RT or NRT */
# define ssSetNumConstraints(S,n) /* do nothing */
# define ssGetNumConstraints(S)   -1    /* silently return invalid value */
# define ssGetConstraints(S)      NULL  /* silently return invalid value */
#endif


/* ContStateDisabled - This vector is of length ssGetNumContStates and
 *   is a boolean vector indicating whether or not the states in your
 *   S-function block should be integrated. Generally this should not
 *   be modified by your S-function. It will automatically be set and
 *   cleared when your block is within an enabled subsystem during
 *   disables and enables of the subsystem block. For the root model
 *   SimStruct, this contains the boolean values for all continuous states
 *   with in the model.
 */
#define ssGetContStateDisabled(S) \
          (S)->states.contStateDisabled                   /* (boolean_T *) */
#define _ssSetContStateDisabled(S,ptr) \
          (S)->states.contStateDisabled = (ptr)
#if !SS_SFCN
#define ssSetContStateDisabled(S,ptr) _ssSetContStateDisabled(S,ptr)
#else
#define ssSetContStateDisabled(S,ptr) \
          ssSetContStateDisabled_cannot_be_used_in_SFunctions
#endif

/*  Auxiliary state related information
 *
 */

#if (SS_GENERATED_S_FUNCTION || SS_SL_INTERNAL || SS_RTW_INTERNAL)
#define ssSetStatesInfo2(S,ptr) ((S)->states.statesInfo2) = (ptr)
#define ssGetStatesInfo2(S) ((S)->states.statesInfo2)
#endif

/* PrevZCSigState - This vector is of length ssGetNumZCEvents. It is
 *   provided for the root model SimStruct. S-function must specify
 *   NumZCEvents as 0.
 */
#define _ssGetPrevZCSigState(S) \
    ((S)->states.statesInfo2)->prevZCSigState                      /* (int_T *)       */
#if !SS_SFCN
#define ssGetPrevZCSigState(S) _ssGetPrevZCSigState(S)
#else
#define ssGetPrevZCSigState(S) \
          ssGetPrevZCSigState_cannot_be_used_in_SFunctions
#endif
#define _ssSetPrevZCSigState(S,ptr) \
    ((S)->states.statesInfo2)->prevZCSigState = (ptr)
#if !SS_SFCN
#define ssSetPrevZCSigState(S,ptr) _ssSetPrevZCSigState(S,ptr)
#else
#define ssSetPrevZCSigState(S,ptr) \
          ssSetPrevZCSigState_cannot_be_used_in_SFunctions
#endif

/* NonsampledZCs - This is vector is of length ssGetNumNonsampledZCs and
 *  is the vector for the nonsampled zero crossings in your S-function.
 *  The mdlZeroCrossings method is used to fill in the nonsampled
 *  zero crossings. For the root SimStruct, this vector contains all
 *  nonsampled zero crossings in the model.
 */
#define ssGetNonsampledZCs(S) \
          (S)->states.nonsampledZCs                       /*   (real_T *)    */
#define _ssSetNonsampledZCs(S,ptr) \
          (S)->states.nonsampledZCs = (ptr)
#if !SS_SFCN || SS_GENERATED_S_FUNCTION
#define ssSetNonsampledZCs(S,ptr) _ssSetNonsampledZCs(S,ptr)
#else
#define ssSetNonsampledZCs(S,ptr) \
          ssSetNonsampledZCs_cannot_be_used_in_SFunctions
#endif

/* NonsampledZCDirs - This is the zero crossing direction for the nonsampled
 *  zero crossings. It is of length ssGetNumNonsampledZCs. The default
 *  is ANY_ZERO_CROSSING.
 */
#define ssGetNonsampledZCDirs(S) \
          (S)->states.nonsampledZCDirs                    /* (ZCDirection*)  */
#define _ssSetNonsampledZCDirs(S,ptr) \
          (S)->states.nonsampledZCDirs = (ptr)
#if !SS_SFCN
#define ssSetNonsampledZCDirs(S,ptr) _ssSetNonsampledZCDirs(S,ptr)
#else
#define ssSetNonsampledZCDirs(S,ptr) \
          ssSetNonsampledZCDirs_cannot_be_used_in_SFunctions
#endif

#define ssSetModelMethods2(S,ptr) (S)->states.modelMethods2 = (ptr)
#define ssGetModelMethods2(S) (S)->states.modelMethods2

#define ssSetModelMethods3(S,ptr) ((S)->states.modelMethods2)->modelMethods3 = (ptr)
#define ssGetModelMethods3(S) ((S)->states.modelMethods2)->modelMethods3

/*
 * External Mode Function
 */
#if SS_SFCN_FOR_SIM
# define ssSetExternalModeFcn(S, fcn) \
    (S)->states.modelMethods2->extModeLogFcn = (fcn)
#endif

#if SS_SL_INTERNAL
/*
 * Call into the s-functions external mode fcn - if it exists.  Returns
 * error string on failure, NULL on success.
 */
# define ssCallExternalModeFcn(S, meth)                             \
    ((S)->states.modelMethods2->extModeLogFcn != NULL) ?             \
        (S)->states.modelMethods2->extModeLogFcn((S),(meth)): NULL
#endif

/*-------------------------------- S->work ----------------------------------*/


/* IWork - This is the integer work vector of length ssGetNumIWork for your
 *   S-function. For the root SimStruct, this is the integer work vector
 *   for all blocks in the model.
 */
#define ssGetIWork(S) \
          (S)->work.iWork                                 /*   (int_T *)     */
#define _ssSetIWork(S,iwork) \
          (S)->work.iWork = (iwork)
#if !SS_SFCN
#define ssSetIWork(S,iwork) _ssSetIWork(S,iwork)
#else
#define ssSetIWork(S,iwork) ssSetIWork_cannot_be_used_in_SFunctions
#endif

#define ssGetIWorkValue(S,iworkIdx) \
          (S)->work.iWork[iworkIdx]                       /*   (int_T)       */
#define ssSetIWorkValue(S,iworkIdx,iworkValue) \
          (S)->work.iWork[iworkIdx] = (iworkValue)

/* RWork - This is the real work vector of length ssGetNumRWork for your
 *   S-function. For the root SimStruct, this is the real work vector
 *   for all blocks in the model.
 */
#define ssGetRWork(S) \
          (S)->work.rWork                                 /*   (real_T *)    */
#define _ssSetRWork(S,rwork) \
          (S)->work.rWork = (rwork)
#if !SS_SFCN
#define ssSetRWork(S,rwork) _ssSetRWork(S,rwork)
#else
#define ssSetRWork(S,rwork) ssSetRWork_cannot_be_used_in_SFunctions
#endif

#define ssGetRWorkValue(S,rworkIdx) \
          (S)->work.rWork[rworkIdx]                       /*   (real_T)      */
#define ssSetRWorkValue(S,rworkIdx,rworkValue) \
          (S)->work.rWork[rworkIdx] = (rworkValue)

/* PWork - This is the pointer work vector of length ssGetNumPWork for your
 *   S-function. For the root SimStruct, this is the pointer work vector
 *   for all blocks in the model.
 */
#define ssGetPWork(S) \
          (S)->work.pWork                                 /*   (void **)     */
#define _ssSetPWork(S,pwork) \
          (S)->work.pWork = (pwork)
#if !SS_SFCN
#define ssSetPWork(S,pwork) _ssSetPWork(S,pwork)
#else
#define ssSetPWork(S,pwork) ssSetPWork_cannot_be_used_in_SFunctions
#endif

#define ssGetPWorkValue(S,pworkIdx) \
          (S)->work.pWork[pworkIdx]                       /*   (void *)      */
#define ssSetPWorkValue(S,pworkIdx,pworkValue) \
          (S)->work.pWork[pworkIdx] = (pworkValue)


/*
 * DWork - This is the data type work vector of length ssGetNumDWork for the
 *         S-Function. User written S-Functions should not access this array
 *         directly, they should use the macros (see below) to get/set the
 *         specific fields of the dWork structure.
 */
#if !SS_SFCN || SS_GENERATED_S_FUNCTION
#define ssGetSFcnDWork(S) \
          ((S)->work.dWork.sfcn)                       /* (_ssDWorkRecord *) */
#define ssSetSFcnDWork(S,dwork) \
          (S)->work.dWork.sfcn = (dwork)
#define ssGetSFcnDWorkAux(S) \
          ((S)->work.dWorkAux)                    /* (_ssDWorkAuxRecord *) */
#define ssSetSFcnDWorkAux(S,dworkAux) \
          (S)->work.dWorkAux = (dworkAux)
#endif

/*
 * Get the DWork data array
 */
#define ssGetDWork(S,index) \
          ((S)->work.dWork.sfcn[(index)].array)             /*   (void *)  */
#define _ssSetDWork(S,index, addr) \
          (S)->work.dWork.sfcn[index].array = (addr)
#if !SS_SFCN
#define ssSetDWork(S,index,dwork) _ssSetDWork(S,index,dwork)
#else
#define ssSetDWork(S,index,dwork) ssSetDWork_cannot_be_used_in_SFunctions
#endif


/*
 * Get the DWork width.
 */
#define ssGetDWorkWidth(S,index) \
          ((S)->work.dWork.sfcn[(index)].width)               /* (int_T)  */
#define ssSetDWorkWidth(S,index,val) \
          (S)->work.dWork.sfcn[index].width = (val)
/*
 * Get the DWork data type.
 */
#define ssGetDWorkDataType(S,index) \
          ((S)->work.dWork.sfcn[(index)].dataTypeId)          /* (DTypeId) */
#define ssSetDWorkDataType(S,index,val) \
          (S)->work.dWork.sfcn[index].dataTypeId = (val)

/*
 * Register dialog parameters indexed as prmMinIdx and prmMaxIdx as design
 * minimum and maximum for the DWork of index dworkIdx.
 */
#define ssRegisterDWorkMinMaxPrmIndices(S,dworkIdx,prmMinIdx,prmMaxIdx) \
    ssRegisterDataMinMaxPrmIndices((S),SS_DATA_DESC_DWORK,(dworkIdx),(prmMinIdx),(prmMaxIdx))

/*
 * Specify when the DWork minimum and maximum range checking should be
 * performed.
 */
typedef enum {
    DWORK_MIN_MAX_CHECKING_USER_INITIATED    = 0x0,
    DWORK_MIN_MAX_CHECKING_OUTPUT_ONLY       = 0x1,
    DWORK_MIN_MAX_CHECKING_UPDATE_ONLY       = 0x2,
    DWORK_MIN_MAX_CHECKING_OUTPUT_AND_UPDATE = 0x3
} DWorkMinMaxCheckpoint;
#define ssGetDWorkMinMaxCheckpoint(S,dworkIdx) \
    ((S)->work.dWorkAux[(dworkIdx)].flags.minMaxCheckpoint)
#define ssSetDWorkMinMaxCheckpoint(S,dworkIdx,checkpoint) \
    (S)->work.dWorkAux[(dworkIdx)].flags.minMaxCheckpoint = (checkpoint)

/*
 * Perform explicit range checking of the DWork against the associated
 * design minimum and maximum
 */
#define ssCheckDWorkRange(S,dworkIdx) \
    {                                 \
        _ssSafelyCallGenericFcnStart(S)(S, \
            GEN_FCN_CHECK_DWORK_RANGE, (dworkIdx), NULL) \
        _ssSafelyCallGenericFcnEnd; \
    }

/*
 * Get the DWork complex signal.
 */
#define ssGetDWorkComplexSignal(S,index) \
          ((S)->work.dWork.sfcn[(index)].complexSignal)     /* (CSignal_T) */
#define ssSetDWorkComplexSignal(S,index,val) \
          (S)->work.dWork.sfcn[index].complexSignal = (val)
/*
 * Get the DWork name.
 */
#define ssGetDWorkName(S,index) \
          ((S)->work.dWork.sfcn[(index)].name)                  /* (char_T *) */
#define ssSetDWorkName(S,index,val) \
          (S)->work.dWork.sfcn[index].name = val
/*
 * G(S)et the DWork "UsedAsDState" attribute.
 */
#define ssGetDWorkUsedAsDState(S,index) \
        ( (S)->work.dWork.sfcn[(index)].usedAs == SS_DWORK_USED_AS_DSTATE )
#define ssSetDWorkUsedAsDState(S,index,val) \
          (S)->work.dWork.sfcn[(index)].usedAs = ( (val) ? \
             SS_DWORK_USED_AS_DSTATE : ((S)->work.dWork.sfcn[(index)].usedAs) )

/*
 * G(S)et the DWork "UsageType".
 */
#define ssGetDWorkUsageType(S,index) \
        (S)->work.dWork.sfcn[(index)].usedAs
#define ssSetDWorkUsageType(S,index,val) \
          (S)->work.dWork.sfcn[(index)].usedAs = val

/* DWorkOptimizeInIR - This macro allows S-Functions that use the code
 * generation intermediate representation (CGIR) to generate code, to enable
 * optimizations that would otherwise be disabled by default. For example,
 * the macro should be used if a S-Function set its DWork conservatively as
 * global, because it is accessed in both the
 * output and the update function. It is possible for CGIR to safely optimize
 * the DWork if output and update get combined.
 */
#define ssGetDWorkOptimizeInIR(S,index) \
    ((S)->work.dWorkAux[(index)].flags.optimizeInIR)
#define ssSetDWorkOptimizeInIR(S,index,val) \
    (S)->work.dWorkAux[(index)].flags.optimizeInIR = val

/*
 * G(S)et the DWork "disable bounds checking" attribute.
 *
 *   Currently not supported.
 */
#define ssGetDWorkDisableBoundsChecking(S,index)   ( 0 )

/*
 * G(S)et the DWork "upload dwork in extmode" attribute.
 */
#define ssGetDWorkExtModeUpload(S,index) \
          (S)->work.dWorkAux[index].flags.ExtModeUpload       /* (unsigned int_T: 1) */
#define ssSetDWorkExtModeUpload(S,index,n) \
          (S)->work.dWorkAux[index].flags.ExtModeUpload = (n) /* (unsigned int_T: 1) */

/*
 * G(S)et the DWork "upload dwork in extmode" attribute.
 */
#define ssGetDWorkExtModeUpload(S,index) \
          (S)->work.dWorkAux[index].flags.ExtModeUpload       /* (unsigned int_T: 1) */
#define ssSetDWorkExtModeUpload(S,index,n) \
          (S)->work.dWorkAux[index].flags.ExtModeUpload = (n) /* (unsigned int_T: 1) */

/*
 * Get the DWork RTW identifier.
 */
#define ssGetDWorkRTWIdentifier(S,index) \
          ((S)->work.dWorkAux[(index)].rtwIdentifier)       /* (char_T *) */
#define ssSetDWorkRTWIdentifier(S,index,val) \
          (S)->work.dWorkAux[index].rtwIdentifier = val

/*
 * Get the DWork rtwIdMustResolveToSignalObject attribute.
 */
#define ssGetDWorkRTWIdentifierMustResolveToSignalObject(S,index) \
          ((S)->work.dWorkAux[(index)].flags.rtwIdMustResolveToSignalObject)
                                                   /* (unsigned int_T: 2) */
#define ssSetDWorkRTWIdentifierMustResolveToSignalObject(S,index,n) \
          (S)->work.dWorkAux[index].flags.rtwIdMustResolveToSignalObject = (n)

/*
 * Get the DWork RTW storage class.
 */
#define ssGetDWorkRTWStorageClass(S,index) \
          ((S)->work.dWorkAux[(index)].rtwStorageClass) /* RTWStorageType */
#define ssSetDWorkRTWStorageClass(S,index,val) \
          (S)->work.dWorkAux[index].rtwStorageClass = val

/*
 * Get the DWork RTW type qualifier.
 */
#define ssGetDWorkRTWTypeQualifier(S,index) \
          ((S)->work.dWorkAux[(index)].rtwTypeQualifier)    /* (char_T *) */
#define ssSetDWorkRTWTypeQualifier(S,index,val) \
          (S)->work.dWorkAux[index].rtwTypeQualifier = val

/*
 * Routines to allow the S-function to map a block IC parameter to its dwork.
 */
#define ssGetDWorkInitialConditionParamIdx(S,index) \
          ((S)->work.dWorkAux[(index)].icPrmIdxPlus1 - 1)
#define ssSetDWorkInitialConditionParamIdx(S,index,val) \
          (S)->work.dWorkAux[index].icPrmIdxPlus1 = ((int_T) val + 1)

/*
 * Routines to allow the S-function to map a dwork to a bit-field
 */
#define ssGetDWorkBitFieldWidth(S,index) \
          ((S)->work.dWorkAux[(index)].bitFieldWidth)
#define ssSetDWorkBitFieldWidth(S,index,val) \
          (S)->work.dWorkAux[index].bitFieldWidth = ((int_T) val)

/*
 * RootDWork - For use by Simulink/RTW. User written S-Functions should not use
 *             this macro.
 *
 */
#if !SS_SFCN || SS_GENERATED_S_FUNCTION
#  define ssGetRootDWork(S) \
          ((S)->work.dWork.root)
#  define ssSetRootDWork(S,val) \
          (S)->work.dWork.root = (val)
#endif



/* ModeVector - This is the mode vector of length ssGetNumModes for your
 *   S-function. For the root SimStruct, this is the mode vector
 *   for all blocks in the model.
 */
#define ssGetModeVector(S) \
          (S)->work.modeVector                            /*   (int_T *)     */
#define _ssSetModeVector(S,vect) \
          (S)->work.modeVector = (vect)
#if !SS_SFCN
#define ssSetModeVector(S,vect) _ssSetModeVector(S,vect)
#else
#define ssSetModeVector(S,vect) ssSetModeVector_cannot_be_used_in_SFunctions
#endif

#define ssGetModeVectorValue(S,idx) \
          (S)->work.modeVector[idx]                       /*   (int_T)       */
#define ssSetModeVectorValue(S,idx,val) \
          (S)->work.modeVector[idx] = (val)

/* UserData - This is a void pointer to which you can attach a data object
 *   for your S-function.
 */
#define ssGetUserData(S) \
          (S)->work.userData                              /*   (void *)      */
#define ssSetUserData(S,userDataPtr) \
          (S)->work.userData = (userDataPtr)

/*-------------------------------- S->blkInfo -------------------------------*/

/* InputConnected - True/false are any inputs to the S-function connected
 *   to non-virtual blocks?
 */
#if SS_SFCN_LEVEL_1 || SS_SL_INTERNAL
# define ssGetInputConnected(S) \
          (S)->blkInfo.inputConnected                    /* (int_T)      */
# define _ssSetInputConnected(S,setting) \
          (S)->blkInfo.inputConnected = (setting)
#else
# define ssGetInputConnected(S) \
          ssGetInputConnected_cannot_be_used_in_Level2_SFunctions
#endif

#if !SS_SFCN
# define ssSetInputConnected(S,setting) _ssSetInputConnected(S,setting)
#else
# define ssSetInputConnected(S,setting) \
         ssSetInputConnected_cannot_be_used_in_SFunctions
#endif


/* OutputConnected - True/false are any outputs of the S-function connected
 *   to non-virtual blocks?
 */
#define ssGetOutputConnected(S) \
          (S)->blkInfo.outputConnected                   /* (int_T)      */
#define _ssSetOutputConnected(S,setting) \
          (S)->blkInfo.outputConnected = (setting)
#if !SS_SFCN
#define ssSetOutputConnected(S,setting) _ssSetOutputConnected(S,setting)
#else
#define ssSetOutputConnected(S,setting) \
          ssSetOutputConnected_cannot_be_used_in_SFunctions
#endif

/* PlacementGroup - This is an advanced features for S-functions which
 *   can be applied to source (i.e. no input port) or sink (i.e. no output
 *   port) S-function. Any S-functions which the same placement group
 *   will be placed adjacent to each other in the sorted list.
 */
#define ssGetPlacementGroup(S) \
          (S)->blkInfo.placementGroup                    /* (const char_T *) */
#define ssSetPlacementGroup(S,name) \
          (S)->blkInfo.placementGroup = (name)


/*----------------------------------------------------------------------------*/


#define ssSetBlkInfo2Ptr(S,ptr) (S)->blkInfo.blkInfo2 = (ptr)
#define ssGetBlkInfo2Ptr(S)     (S)->blkInfo.blkInfo2

#define ssSetRTWSfcnInfo(S,ptr) \
          ((S)->blkInfo.blkInfo2)->rtwSfcnInfo = ((void *)ptr)
#define ssGetRTWSfcnInfo(S) \
          ((S)->blkInfo.blkInfo2)->rtwSfcnInfo

/*-------------------------------- S->mdlInfo -------------------------------*/
#define ssGetMdlInfoPtr(S) \
          (S)->mdlInfo                              /* (struct _ssMdlInfo *) */
#define _ssSetMdlInfoPtr(S,ptr) \
          (S)->mdlInfo = (ptr)
#if !SS_SFCN
#define ssSetMdlInfoPtr(S,ptr) _ssSetMdlInfoPtr(S,ptr)
#else
#define ssSetMdlInfoPtr(S,ptr) ssSetMdlInfoPtr_cannot_be_used_in_SFunctions
#endif

#define ssGetSimMode(S) \
          (S)->mdlInfo->simMode                           /* (SS_SimMode)    */
#define _ssSetSimMode(S,mode) \
          (S)->mdlInfo->simMode = (mode)
#if !SS_SFCN
#define ssSetSimMode(S,mode) _ssSetSimMode(S,mode)
#else
#define ssSetSimMode(S,mode) ssSetSimMode_cannot_be_used_in_SFunctions
#endif

#define ssGetSimStatus(S, result) \
  {\
       _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_GET_SIM_STATUS, 0, result)\
       _ssSafelyCallGenericFcnEnd; \
   }

#define ssGetRTWCGSupport(S, result) \
  {\
       _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_GET_RTWCG_SUPPORT, 0,result)\
       _ssSafelyCallGenericFcnEnd; \
  }

#define ssSetStateAttr(S, pMxa) \
  {\
       _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_SET_STATE_ATTR,0,pMxa)\
       _ssSafelyCallGenericFcnEnd; \
   }

#define ssGetStateAttr(S, ppMxa) \
  {\
       _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_GET_STATE_ATTR,0,ppMxa)\
       _ssSafelyCallGenericFcnEnd; \
   }



#if !SS_SFCN && SS_SIM
#define ssSetRTWGenMode(S, mode) (S)->mdlInfo->rtwgenMode = (mode)
#define ssGetRTWGenMode(S)       ((S)->mdlInfo->rtwgenMode)
#endif

#if SS_SIM
#define ssRTWGenIsAccelerator(S) \
  (ssGetSimMode(S)     == SS_SIMMODE_RTWGEN && \
   ((S)->mdlInfo->rtwgenMode == SS_RTWGEN_ACCELERATOR))
#else
#define ssRTWGenIsAccelerator(S) (false)
#endif

#if SS_SIM
#define ssIsExternalSim(S) \
  (ssGetSimMode(S)     == SS_SIMMODE_EXTERNAL && \
   ((S)->mdlInfo->rtwgenMode == SS_RTWGEN_RTW_CODE))
#else
#define ssIsExternalSim(S) (false)
#endif

#if SS_SIM
#define ssRTWGenIsModelReferenceSimTarget(S) \
  (ssGetSimMode(S)     == SS_SIMMODE_RTWGEN && \
   ((S)->mdlInfo->rtwgenMode == SS_RTWGEN_MODELREFERENCE_SIM_TARGET))
#else
#define ssRTWGenIsModelReferenceSimTarget(S) (false)
#endif

#if SS_SIM
#define ssRTWGenIsModelReferenceRTWTarget(S) \
  (ssGetSimMode(S)     == SS_SIMMODE_RTWGEN && \
   ((S)->mdlInfo->rtwgenMode == SS_RTWGEN_MODELREFERENCE_RTW_TARGET))
#else
#define ssRTWGenIsModelReferenceRTWTarget(S) (false)
#endif

#if SS_SIM
#define ssRTWGenIsCodeGen(S) \
  (ssGetSimMode(S)     == SS_SIMMODE_RTWGEN && \
   (((S)->mdlInfo->rtwgenMode == SS_RTWGEN_RTW_CODE) || \
   ((S)->mdlInfo->rtwgenMode == SS_RTWGEN_MODELREFERENCE_SIM_TARGET) || \
   ((S)->mdlInfo->rtwgenMode == SS_RTWGEN_MODELREFERENCE_RTW_TARGET)))
#else
#define ssRTWGenIsCodeGen(S)     (false)
#endif

#if !defined(ENABLE_SLEXEC_SSBRIDGE)
#define ssGetTPtr(S) \
        (S)->mdlInfo->t                                 /*   (time_T *)    */
#define _ssSetTPtr(S,t_ptr) \
          (S)->mdlInfo->t = (t_ptr)
#endif
#if !SS_SFCN
#define ssSetTPtr(S,t_ptr) _ssSetTPtr(S,t_ptr)
#else
#define ssSetTPtr(S,t_ptr) ssSetTPtr_cannot_be_used_in_SFunctions
#endif

#if !defined(ENABLE_SLEXEC_SSBRIDGE)
#define ssGetT(S) \
          (S)->mdlInfo->t[0]                              /*   (time_T)      */
#define _ssSetT(S,time) \
          (S)->mdlInfo->t[0] = (time)
#endif
#if !SS_SFCN
#define ssSetT(S,time) _ssSetT(S,time)
#else
#define ssSetT(S,time) ssSetT_cannot_be_used_in_SFunctions
#endif

#if !defined(ENABLE_SLEXEC_SSBRIDGE)
#define ssGetTaskTime(S,sti) \
          (S)->mdlInfo->t[ssIsTIDInStInfo(S,sti) ? \
                          ssGetSampleTimeTaskID(S,sti) : 0]   /*  (time_T)   */
#define _ssSetTaskTime(S,sti,time) \
          (S)->mdlInfo->t[sti]=(time)
#endif
#if !SS_SFCN
#define ssSetTaskTime(S,sti,time) _ssSetTaskTime(S,sti,time)
#else
#define ssSetTaskTime(S,sti,time) ssSetTaskTime_cannot_be_used_in_SFunctions
#endif

#if !defined(ENABLE_SLEXEC_SSBRIDGE)
#define ssGetSampleHitPtr(S) \
          (S)->mdlInfo->sampleHits                        /*   (int_T *) */
#define _ssSetSampleHit(S, sti, v) \
        (S)->mdlInfo->sampleHits[sti] = (v)
#define _ssSetSampleHitPtr(S,ptr) \
          (S)->mdlInfo->sampleHits = (ptr)
#endif
#if !SS_SFCN
#define ssSetSampleHitPtr(S,ptr) _ssSetSampleHitPtr(S,ptr)
#else
#define ssSetSampleHitPtr(S,ptr) ssSetSampleHitPtr_cannot_be_used_in_SFunctions
#endif

#define ssGetTStart(S) \
          (S)->mdlInfo->tStart                            /*   (time_T)      */
#define _ssSetTStart(S,tstart) \
          (S)->mdlInfo->tStart = (tstart)
#if !SS_SFCN
#define ssSetTStart(S,tstart) _ssSetTStart(S,tstart)
#else
#define ssSetTStart(S,tstart) ssSetTStart_cannot_be_used_in_SFunctions
#endif

#define ssGetTFinal(S) \
          (S)->mdlInfo->tFinal                            /*   (time_T)      */
#define _ssSetTFinal(S,tfinal) \
          (S)->mdlInfo->tFinal = (tfinal)
#if !SS_SFCN
#define ssSetTFinal(S,tfinal) _ssSetTFinal(S,tfinal)
#else
#define ssSetTFinal(S,tfinal) ssSetTFinal_cannot_be_used_in_SFunctions
#endif

/* TimeOfLastOutput - This is reserved for use by RTW and Simulink. However,
 *   S-function can look at this within their continuous task. It is
 *   the time of the last output for the model - not the s-function
 *   itself.
 */
#define ssGetTimeOfLastOutput(S) \
          (S)->mdlInfo->timeOfLastOutput                  /*   (time_T)      */
#define _ssSetTimeOfLastOutput(S,tlast) \
          (S)->mdlInfo->timeOfLastOutput = (tlast)
#if !SS_SFCN
#define ssSetTimeOfLastOutput(S,tlast) _ssSetTimeOfLastOutput(S,tlast)
#else
#define ssSetTimeOfLastOutput(S,tlast) \
          ssSetTimeOfLastOutput_cannot_be_used_in_SFunctions
#endif

#define _ssGetTimingData(S) \
          (S)->mdlInfo->timingData                        /*   (void *)      */
#if !SS_SFCN
#define ssGetTimingData(S) _ssGetTimingData(S)
#else
#define ssGetTimingData(S) ssGetTimingData_cannot_be_used_in_SFunctions
#endif
#define _ssSetTimingData(S,d) \
          (S)->mdlInfo->timingData = (d)
#if !SS_SFCN
#define ssSetTimingData(S,d) _ssSetTimingData(S,d)
#else
#define ssSetTimingData(S,d) ssSetTimingData_cannot_be_used_in_SFunctions
#endif

/*
 * TimingBridge is introduced in R14. This provides access to the timing
 * information which is stored in different data structures in Simulink
 * and the various RTW code formats.
 */
#define ssGetTimingBridge(S) \
        ( (S)->mdlInfo->timingBridge )
#if !SS_SFCN
#define ssSetTimingBridge(S, d) \
        (S)->mdlInfo->timingBridge = (d)
#else
#define ssSetTimingBridge(S,d) ssSetTimingBridge_cannot_be_used_in_SFunctions
#endif

#if !defined(ENABLE_SLEXEC_SSBRIDGE)

#define ssGetClockTick(S, sti) \
    ( *( (S)->mdlInfo->timingBridge->clockTick[ssGetSampleTimeTaskID(S, sti)]  ) )

#define ssGetClockTickH(S, sti) \
    ( *( (S)->mdlInfo->timingBridge->clockTickH[ssGetSampleTimeTaskID(S, sti)] ) )

#endif


#define ssIsMinorTimeStep(S) \
          ((S)->mdlInfo->simTimeStep == MINOR_TIME_STEP)  /*  (int_T)    */

#define ssIsMajorTimeStep(S) \
          ((S)->mdlInfo->simTimeStep == MAJOR_TIME_STEP)  /*  (int_T)    */

#define ssGetSimTimeStep(S) \
          (S)->mdlInfo->simTimeStep                       /*  (SimTimeStep)  */
#define _ssSetSimTimeStep(S,stepType) \
          (S)->mdlInfo->simTimeStep = (stepType)
#if !SS_SFCN
#define ssSetSimTimeStep(S,stepType) _ssSetSimTimeStep(S,stepType)
#else
#define ssSetSimTimeStep(S,stepType) \
          ssSetSimTimeStep_cannot_be_used_in_SFunctions
#endif

#if !defined(ENABLE_SLEXEC_SSBRIDGE)
#define ssGetStopRequested(S) \
          (S)->mdlInfo->stopRequested                     /*   (int_T)   */
#define ssSetStopRequested(S,val) \
          (S)->mdlInfo->stopRequested = (val)
#endif

#define ssGetLogOutput(S) \
          (S)->mdlInfo->logOutput                         /*    (int_T)  */
#define _ssSetLogOutput(S,setting) \
          (S)->mdlInfo->logOutput = setting
#if !SS_SFCN
#define ssSetLogOutput(S,setting) _ssSetLogOutput(S,setting)
#else
#define ssSetLogOutput(S,setting) ssSetLogOutput_cannot_be_used_in_SFunctions
#endif

#define _ssGetOutputTimes(S) \
          (S)->mdlInfo->outputTimes                       /*   (time_T*)     */
#if !SS_SFCN
#define ssGetOutputTimes(S) _ssGetOutputTimes(S)
#else
#define ssGetOutputTimes(S) ssGetOutputTimes_cannot_be_used_in_SFunctions
#endif
#define _ssSetOutputTimes(S,ptr) \
          (S)->mdlInfo->outputTimes = (ptr)
#if !SS_SFCN
#define ssSetOutputTimes(S,ptr) _ssSetOutputTimes(S,ptr)
#else
#define ssSetOutputTimes(S,ptr) ssSetOutputTimes_cannot_be_used_in_SFunctions
#endif

#define _ssGetNextOutputTime(S) \
          (S)->mdlInfo->outputTimes[ \
             (S)->mdlInfo->outputTimesIndex]              /*   (time_T)      */
#if !SS_SFCN
#define ssGetNextOutputTime(S) _ssGetNextOutputTime(S)
#else
#define ssGetNextOutputTime(S) ssGetNextOutputTime_cannot_be_used_in_SFunctions
#endif

#define _ssGetOutputTimesIndex(S) \
          (S)->mdlInfo->outputTimesIndex                  /*   (int_T)       */
#if !SS_SFCN
#define ssGetOutputTimesIndex(S) _ssGetOutputTimesIndex(S)
#else
#define ssGetOutputTimesIndex(S) \
          ssGetOutputTimesIndex_cannot_be_used_in_SFunctions
#endif
#define _ssSetOutputTimesIndex(S,index) \
          (S)->mdlInfo->outputTimesIndex = (index)
#if !SS_SFCN
#define ssSetOutputTimesIndex(S,index) _ssSetOutputTimesIndex(S,index)
#else
#define ssSetOutputTimesIndex(S,index) \
          ssSetOutputTimesIndex_cannot_be_used_in_SFunctions
#endif

#define _ssGetNumOutputTimes(S) \
          (S)->mdlInfo->numOutputTimes                    /*   (int_T)       */
#if !SS_SFCN
#define ssGetNumOutputTimes(S) _ssGetNumOutputTimes(S)
#else
#define ssGetNumOutputTimes(S) ssGetNumOutputTimes_cannot_be_used_in_SFunctions
#endif
#define _ssSetNumOutputTimes(S,n) \
          (S)->mdlInfo->numOutputTimes = (n)
#if !SS_SFCN
#define ssSetNumOutputTimes(S,n) _ssSetNumOutputTimes(S,n)
#else
#define ssSetNumOutputTimes(S,n) \
          ssSetNumOutputTimes_cannot_be_used_in_SFunctions
#endif

#define _ssGetOutputTimesOnly(S) \
          (S)->mdlInfo->outputTimesOnly                   /*   (int_T)   */
#if !SS_SFCN
#define ssGetOutputTimesOnly(S) _ssGetOutputTimesOnly(S)
#else
#define ssGetOutputTimesOnly(S) \
          ssGetOutputTimesOnly_cannot_be_used_in_SFunctions
#endif
#define _ssSetOutputTimesOnly(S,setting) \
          (S)->mdlInfo->outputTimesOnly = (setting)
#if !SS_SFCN
#define ssSetOutputTimesOnly(S,setting) _ssSetOutputTimesOnly(S,setting)
#else
#define ssSetOutputTimesOnly(S,setting) \
          ssSetOutputTimesOnly_cannot_be_used_in_SFunctions
#endif

#define _ssGetNeedOutputAtTPlusTol(S) \
          (S)->mdlInfo->obsoletedNeedOutputAtTPlusTol         /*   (int_T)   */
#if !SS_SFCN
#define ssGetNeedOutputAtTPlusTol(S) _ssGetNeedOutputAtTPlusTol(S)
#else
#define ssGetNeedOutputAtTPlusTol(S) \
          ssGetNeedOutputAtTPlusTol_cannot_be_used_in_SFunctions
#endif

#define ssGetSolverName(S) \
          (S)->mdlInfo->solverName                        /*   (char_T *)    */
#define _ssSetSolverName(S,name) \
          (S)->mdlInfo->solverName = (name)
#if !SS_SFCN
#define ssSetSolverName(S,name) _ssSetSolverName(S,name)
#else
#define ssSetSolverName(S,name) ssSetSolverName_cannot_be_used_in_SFunctions
#endif

#define ssIsVariableStepSolver(S) \
          (S)->mdlInfo->variableStepSolver               /*   (int_T *)  */
#define _ssSetVariableStepSolver(S,s) \
          (S)->mdlInfo->variableStepSolver = (s)
#if !SS_SFCN
#define ssSetVariableStepSolver(S,s) _ssSetVariableStepSolver(S,s)
#else
#define ssSetVariableStepSolver(S,s) \
          ssSetVariableStepSolver_cannot_be_used_in_SFunctions
#endif

#define _ssGetSolverData(S) \
          (S)->mdlInfo->solverData                        /*   (void *)      */
#if !SS_SFCN
#define ssGetSolverData(S) _ssGetSolverData(S)
#else
#define ssGetSolverData(S) ssGetSolverData_cannot_be_used_in_SFunctions
#endif
#define _ssSetSolverData(S,solverDataPtr) \
          (S)->mdlInfo->solverData = (solverDataPtr)
#if !SS_SFCN
#define ssSetSolverData(S,solverDataPtr) _ssSetSolverData(S,solverDataPtr)
#else
#define ssSetSolverData(S,solverDataPtr) \
          ssSetSolverData_cannot_be_used_in_SFunctions
#endif

# define ssGetSolverStopTime(S) \
          (S)->mdlInfo->solverStopTime                    /*   (time_T)      */
# define _ssSetSolverStopTime(S,stoptime) \
          (S)->mdlInfo->solverStopTime = (stoptime)
#if !SS_SFCN
#define ssSetSolverStopTime(S,stoptime) _ssSetSolverStopTime(S,stoptime)
#else
#define ssSetSolverStopTime(S,stoptime) \
          ssSetSolverStopTime_cannot_be_used_in_SFunctions
#endif

#define ssGetStepSize(S) \
          (S)->mdlInfo->stepSize                          /*   (time_T)      */
#define _ssSetStepSize(S,size) \
          (S)->mdlInfo->stepSize=(size)
#if !SS_SFCN
#define ssSetStepSize(S,size) _ssSetStepSize(S,size)
#else
#define ssSetStepSize(S,size) ssSetStepSize_cannot_be_used_in_SFunctions
#endif

#if !defined(ENABLE_SLEXEC_SSBRIDGE)
#define ssGetSolverNeedsReset(S) \
          (S)->mdlInfo->solverNeedsReset                  /*  (int_T)    */
#define ssSetSolverNeedsReset(S) \
          (S)->mdlInfo->solverNeedsReset = ((int_T)1)
#define _ssClearSolverNeedsReset(S) \
          (S)->mdlInfo->solverNeedsReset = ((int_T)0)
#endif
#if !SS_SFCN
#define ssClearSolverNeedsReset(S) _ssClearSolverNeedsReset(S)
#else
#define ssClearSolverNeedsReset(S) \
          ssClearSolverNeedsReset_cannot_be_used_in_SFunctions
#endif

#define ssIsSolverRequestingReset(S) \
           ((S)->mdlInfo->mdlFlags.solverRequestingReset == 1U)
#define _ssSetSolverRequestingReset(S,boolVal) \
           (S)->mdlInfo->mdlFlags.solverRequestingReset = \
                 ((boolVal) ? 1U : 0U)
#if !SS_SFCN
#define ssSetSolverRequestingReset(S,boolVal) _ssSetSolverRequestingReset(S,boolVal)
#else
#define ssSetSolverRequestingReset(S,boolVal) \
          ssSetSolverRequestingReset_cannot_be_used_in_SFunctions
#endif

#define ssIsSolverCheckingCIC(S) \
           ((S)->mdlInfo->mdlFlags.solverCheckingCIC == 1U)
#define _ssSetSolverCheckingCIC(S,boolVal) \
           (S)->mdlInfo->mdlFlags.solverCheckingCIC = \
                 ((boolVal) ? 1U : 0U)
#if !SS_SFCN
#define ssSetSolverCheckingCIC(S,boolVal) _ssSetSolverCheckingCIC(S,boolVal)
#else
#define ssSetSolverCheckingCIC(S,boolVal) \
          ssSetSolverCheckingCIC_cannot_be_used_in_SFunctions
#endif


#define ssGetZCCacheNeedsReset(S) \
          (S)->mdlInfo->mdlFlags.zcCacheNeedsReset        /*  (uint_T)    */
#define ssSetZCCacheNeedsReset(S,setting) \
          (S)->mdlInfo->mdlFlags.zcCacheNeedsReset = (setting)

#define ssGetDerivCacheNeedsReset(S) \
          (S)->mdlInfo->mdlFlags.derivCacheNeedsReset     /*  (uint_T)    */
#define ssSetDerivCacheNeedsReset(S,setting) \
          (S)->mdlInfo->mdlFlags.derivCacheNeedsReset = (setting)

#define _ssGetForceSfcnExceptionHandling(S) \
           ((S)->mdlInfo->mdlFlags.forceSfcnExceptionHandling == 1U)
#define _ssSetForceSfcnExceptionHandling(S,boolVal) \
           (S)->mdlInfo->mdlFlags.forceSfcnExceptionHandling = \
                 ((boolVal) ? 1U : 0U)

#define ssIsComputingJacobian(S) \
           ((S)->mdlInfo->mdlFlags.computingJacobian == 1U)
#define _ssSetComputingJacobian(S,boolVal) \
           (S)->mdlInfo->mdlFlags.computingJacobian = \
                 ((boolVal) ? 1U : 0U)
#define ssIsSolverComputingJacobian(S) ssIsComputingJacobian(S)

#if !SS_SFCN
#define ssSetComputingJacobian(S,boolVal) _ssSetComputingJacobian(S,boolVal)
#else
#define ssSetComputingJacobian(S,boolVal) \
          ssSetComputingJacobian_cannot_be_used_in_SFunctions
#endif

#define ssIsSparseSlvrJacobian(S)                       \
    ((S)->mdlInfo->mdlFlags.sparseSlvrJacobian == 1U)
#define _ssSetSparseSlvrJacobian(S,boolVal)             \
    (S)->mdlInfo->mdlFlags.sparseSlvrJacobian =         \
        ((boolVal) ? 1U : 0U)
#if !SS_SFCN
#define ssSetSparseSlvrJacobian(S,boolVal) _ssSetSparseSlvrJacobian(S,boolVal)
#else
#define ssSetSparseSlvrJacobian(S,boolVal)                      \
    ssSetSparseSlvrJacobian_cannot_be_used_in_SFunctions
#endif

#define ssIsOutputMethodComputed(S) \
           ((S)->mdlInfo->mdlFlags.outputMethodComputed == 1U)
#define _ssSetOutputMethodComputed(S,boolVal) \
           (S)->mdlInfo->mdlFlags.outputMethodComputed = ((boolVal) ? 1U : 0U)
#define ssIsSolverOutputMethodComputed(S) ssIsOutputMethodComputed(S)

#if !SS_SFCN
#define ssSetOutputMethodComputed(S,boolVal) _ssSetOutputMethodComputed(S,boolVal)
#else
#define ssSetOutputMethodComputed(S,boolVal) \
          ssSetOutputMethodComputed_cannot_be_used_in_SFunctions
#endif


#define ssGetInlineParameters(S) \
           ((S)->mdlInfo->mdlFlags.inlineParameters == 1U)
#define _ssSetInlineParameters(S,boolVal) \
           (S)->mdlInfo->mdlFlags.inlineParameters = \
                 ((boolVal) ? 1U : 0U)

#define ssGetNoZCStateUpdate(S) \
          (S)->mdlInfo->mdlFlags.noZCStateUpdate      /*  (int_T)    */
#define _ssSetNoZCStateUpdate(S) \
          ((S)->mdlInfo->mdlFlags.noZCStateUpdate = 1U)
#define _ssClearNoZCStateUpdate(S) \
          ((S)->mdlInfo->mdlFlags.noZCStateUpdate = 0U)
#if !SS_SFCN
#define ssClearNoZCStateUpdate(S) _ssClearNoZCStateUpdate(S)
#define ssSetNoZCStateUpdate(S) _ssSetNoZCStateUpdate(S)
#else
#define ssClearNoZCStateUpdate(S) \
          ssClearNoZCStateUpdate_cannot_be_used_in_SFunctions
#define ssSetNoZCStateUpdate(S) \
          ssSetNoZCStateUpdate_cannot_be_used_in_SFunctions
#endif

#if !SS_SFCN
#define ssSetInlineParameters(S,boolVal) _ssSetInlineParameters(S,boolVal)
#else
#define ssSetInlineParameters(S,boolVal) \
          ssSetInlineParameters_cannot_be_used_in_SFunctions
#endif

/* solver assert check to be used by accelerator only */
#define _ssGetSolverAssertCheck(S) \
           ((S)->mdlInfo->mdlFlags.solverAssertCheck == 1U)
#define _ssSetSolverAssertCheck(S,boolVal) \
           (S)->mdlInfo->mdlFlags.solverAssertCheck = \
                 ((boolVal) ? 1U : 0U)

#define ssGetBlkStateChange(S) \
          (S)->mdlInfo->mdlFlags.blkStateChange           /*  (uint_T)    */
#define ssSetBlkStateChange(S) \
          (S)->mdlInfo->mdlFlags.blkStateChange = 1U
#define ssClearBlkStateChange(S) \
          (S)->mdlInfo->mdlFlags.blkStateChange = 0U

#define ssGetSolverRefineFactor(S) \
          (S)->mdlInfo->solverRefineFactor                /*   (int_T)       */
#define _ssSetSolverRefineFactor(S,fact) \
          (S)->mdlInfo->solverRefineFactor = (fact)
#if !SS_SFCN
#define ssSetSolverRefineFactor(S,fact) _ssSetSolverRefineFactor(S,fact)
#else
#define ssSetSolverRefineFactor(S,fact) \
          ssSetSolverRefineFactor_cannot_be_used_in_SFunctions
#endif

#define ssGetSolverRelTol(S) \
          (S)->mdlInfo->solverRelTol                      /*   (real_T)      */
#define _ssSetSolverRelTol(S,rtol) \
          (S)->mdlInfo->solverRelTol = (rtol)
#if !SS_SFCN
#define ssSetSolverRelTol(S,rtol) _ssSetSolverRelTol(S,rtol)
#else
#define ssSetSolverRelTol(S,rtol) \
          ssSetSolverRelTol_cannot_be_used_in_SFunctions
#endif

#define ssGetSolverMaxOrder(S) \
          (S)->mdlInfo->solverMaxOrder                    /*   (int_T)       */
#define _ssSetSolverMaxOrder(S,maxOrder) \
          (S)->mdlInfo->solverMaxOrder = (maxOrder)
#if !SS_SFCN
#define ssSetSolverMaxOrder(S,maxOrder) _ssSetSolverMaxOrder(S,maxOrder)
#else
#define ssSetSolverMaxOrder(S,maxOrder) \
          ssSetSolverMaxOrder_cannot_be_used_in_SFunctions
#endif


#define ssGetSolverExtrapolationOrder(S) \
          (S)->mdlInfo->solverExtrapolationOrder          /*    (int_T)       */
#define _ssSetSolverExtrapolationOrder(S,extrapOrder) \
          (S)->mdlInfo->solverExtrapolationOrder = (extrapOrder)
#if !SS_SFCN
#define ssSetSolverExtrapolationOrder(S,extrapOrder) \
          _ssSetSolverExtrapolationOrder(S,extrapOrder)
#else
#define ssSetSolverExtrapolationOrder(S,extrapOrder) \
          ssSetSolverExtrapolationOrder_cannot_be_used_in_SFunctions
#endif

#define ssGetSolverNumberNewtonIterations(S) \
          (S)->mdlInfo->solverNumberNewtonIterations          /*    (int_T)   */
#define _ssSetSolverNumberNewtonIterations(S,numIter) \
          (S)->mdlInfo->solverNumberNewtonIterations = (numIter)
#if !SS_SFCN
#define ssSetSolverNumberNewtonIterations(S,numIter) \
          _ssSetSolverNumberNewtonIterations(S,numIter)
#else
#define ssSetSolverNumberNewtonIterations(S,numIter) \
          ssSetSolverNumberNewtonIterations_cannot_be_used_in_SFunctions
#endif


/* ssGetSolverMode - This can return SOLVER_MODE_AUTO in mdlInitializeSizes.
 *   However, in mdlSetWorkWidths and any methods called after mdlSetWorkWidths,
 *   solver mode will be either SOLVER_MODE_SINGLETASKING or
 *   SOLVER_MODE_MULTITASKING.
 */
#define ssGetSolverMode(S) \
          (S)->mdlInfo->solverMode                       /*   (SolverMode)   */
#define _ssSetSolverMode(S,mode) \
          (S)->mdlInfo->solverMode=(mode)

#if !SS_SFCN
#define ssSetSolverMode(S,mode) _ssSetSolverMode(S,mode)
#else
#define ssSetSolverMode(S,mode) ssSetSolverMode_cannot_be_used_in_SFunctions
#endif


#define ssGetMaxStepSize(S) \
          (S)->mdlInfo->maxStepSize                       /*   (time_T)      */
#define _ssSetMaxStepSize(S,size) \
          (S)->mdlInfo->maxStepSize=(size)
#if !SS_SFCN
#define ssSetMaxStepSize(S,size) _ssSetMaxStepSize(S,size)
#else
#define ssSetMaxStepSize(S,size) ssSetMaxStepSize_cannot_be_used_in_SFunctions
#endif

#define ssGetMinStepSize(S) \
          (S)->mdlInfo->minStepSize                       /*   (time_T)      */
#define _ssSetMinStepSize(S,size) \
          (S)->mdlInfo->minStepSize=(size)
#if !SS_SFCN
#define ssSetMinStepSize(S,size) _ssSetMinStepSize(S,size)
#else
#define ssSetMinStepSize(S,size) ssSetMinStepSize_cannot_be_used_in_SFunctions
#endif

#define ssGetMinStepViolatedError(S) \
        ( (S)->mdlInfo->mdlFlags.minStepViolatedError == 1U )
#define _ssSetMinStepViolatedError(S, val) \
        (S)->mdlInfo->mdlFlags.minStepViolatedError = (val) ? 1U : 0U;

#define ssGetTimeTweakWarn(S) \
        ( (S)->mdlInfo->mdlFlags.timeTweakWarn == 1U )
#define _ssSetTimeTweakWarn(S, val) \
        (S)->mdlInfo->mdlFlags.timeTweakWarn = (val) ? 1U : 0U;

#if !SS_SFCN
#define ssSetTimeTweakWarn(S,val) _ssSetTimeTweakWarn(S,val)
#else
#define ssSetTimeTweakWarn(S,size) ssSetTimeTweakWarn_cannot_be_used_in_SFunctions
#endif
#if !SS_SFCN
#define ssSetMinStepViolatedError(S,val) \
        _ssSetMinStepViolatedError(S,val)
#else
#define ssSetMinStepViolatedError(S,val) \
        ssSetMinStepViolatedError_cannot_be_used_in_SFunctions
#endif

#define ssGetConsecutiveZCsError(S) \
        (ssGetSolverConsecutiveZCsError(S) == 2 )
#define _ssSetConsecutiveZCsError(S, val) \
        ssSetSolverConsecutiveZCsError(S, val + 1)
#if !SS_SFCN
#define ssSetConsecutiveZCsError(S,val) \
        _ssSetConsecutiveZCsError(S,val)
#else
#define ssSetConsecutiveZCsError(S,val) \
        ssSetConsecutiveZCsError_cannot_be_used_in_SFunctions
#endif

#define ssGetMaxNumMinSteps(S) \
          (S)->mdlInfo->maxNumMinSteps                    /*   (in_T)        */
#define _ssSetMaxNumMinSteps(S,num) \
          (S)->mdlInfo->maxNumMinSteps=(num)
#if !SS_SFCN
#define ssSetMaxNumMinSteps(S,num) _ssSetMaxNumMinSteps(S,num)
#else
#define ssSetMaxNumMinSteps(S,min) ssSetMaxNumMinSteps_cannot_be_used_in_SFunctions
#endif


#define ssGetFixedStepSize(S) \
          (S)->mdlInfo->fixedStepSize                     /*   (time_T)      */
#define _ssSetFixedStepSize(S,size) \
          (S)->mdlInfo->fixedStepSize=(size)
#if !SS_SFCN
#define ssSetFixedStepSize(S,size) _ssSetFixedStepSize(S,size)
#else
#define ssSetFixedStepSize(S,size) \
          ssSetFixedStepSize_cannot_be_used_in_SFunctions
#endif

#if SS_MULTITASKING || SS_SL_INTERNAL || SS_SFCN_FOR_SIM

#if !defined(ENABLE_SLEXEC_SSBRIDGE)
# define ssGetPerTaskSampleHitsPtr(S) \
          (S)->mdlInfo->perTaskSampleHits                 /*   (int_T *) */

# define _ssSetPerTaskSampleHitsPtr(S, hitsMatrix) \
          (S)->mdlInfo->perTaskSampleHits = (hitsMatrix)
#endif
# if !SS_SFCN
# define ssSetPerTaskSampleHitsPtr(S, hitsMatrix) \
           _ssSetPerTaskSampleHitsPtr(S, hitsMatrix)
# else
# define ssSetPerTaskSampleHitsPtr(S, hitsMatrix) \
           ssSetPerTaskSampleHitsPtr_cannot_be_used_in_SFunctions
# endif

#endif

#if !defined(ENABLE_SLEXEC_SSBRIDGE)
#define ssGetSolverIsAtLeftPostOfContZcEvent(S) \
        ((S)->mdlInfo->solverInfo->isAtLeftPostOfContZcEvent == 1U)

#define ssGetSolverIsAtRightPostOfContZcEvent(S) \
        ((S)->mdlInfo->solverInfo->isAtRightPostOfContZcEvent == 1U)
#endif

#if !SS_SFCN || SS_GENERATED_S_FUNCTION

# define ssSetSolverInfo(S,ptr) \
         (S)->mdlInfo->solverInfo = (ptr)
# define ssGetSolverInfo(S) \
         ((S)->mdlInfo->solverInfo)

#define ssSetSolverZcSignalVector(S, ptr) \
        ssGetSolverInfo(S)->zcSignalVector = (ptr)
#define ssGetSolverZcSignalVector(S) \
        (ssGetSolverInfo(S)->zcSignalVector)

#define ssSetSolverZcEventsVector(S, ptr) \
        ssGetSolverInfo(S)->zcEventsVector = (ptr)
#define ssGetSolverZcEventsVector(S) \
        (ssGetSolverInfo(S)->zcEventsVector)

#define _ssGetSolverZcEventsVector(S) ssGetSolverZcEventsVector(S)
#define _ssSetSolverZcEventsVector(S, ptr) ssSetSolverZcEventsVector(S, ptr)


#define ssSetSolverZcSignalAttrib(S, ptr) \
        ssGetSolverInfo(S)->zcSignalAttrib = (ptr)
#define ssGetSolverZcSignalAttrib(S) \
        (ssGetSolverInfo(S)->zcSignalAttrib)

#define ssSetSolverZcSignalVectorLength(S, n) \
        ssGetSolverInfo(S)->zcSignalVectorLength = (n)
#define ssGetSolverZcSignalVectorLength(S) \
        (ssGetSolverInfo(S)->zcSignalVectorLength)

#define ssSetSolverFoundContZcEvents(S, val) \
        ssGetSolverInfo(S)->foundContZcEvents = (val)
#define ssGetSolverFoundContZcEvents(S) \
        (ssGetSolverInfo(S)->foundContZcEvents)

#define ssSetSolverIsAtLeftPostOfContZcEvent(S, val) \
        ssGetSolverInfo(S)->isAtLeftPostOfContZcEvent = (val)

#define ssSetSolverIsAtRightPostOfContZcEvent(S, val) \
        ssGetSolverInfo(S)->isAtRightPostOfContZcEvent = (val)

#define ssSetSolverZcPrevStateVector(S, val) \
        ssSetPrevZCSigState(S, val)
#define ssGetSolverZcPrevStateVector(S) \
        ssGetPrevZCSigState(S)

#define _ssGetSolverZcPrevStateVector(S) _ssGetPrevZCSigState(S)
#define _ssSetSolverZcPrevStateVector(S, ptr)_ssSetPrevZCSigState(S, ptr)

#define ssSetSolverAdaptiveZcDetection(S, val) \
        ssGetSolverInfo(S)->adaptiveZcDetection = (val)
#define ssGetSolverAdaptiveZcDetection(S) \
        (ssGetSolverInfo(S)->adaptiveZcDetection)

#define ssSetSolverNumZcSignals(S, n) \
        ssGetSolverInfo(S)->numZcSignals = (n)
#define ssGetSolverNumZcSignals(S) \
        (ssGetSolverInfo(S)->numZcSignals)

#define ssSetSolverStateProjection(S, val) \
        ssGetSolverInfo(S)->stateProjection = (val)
#define ssGetSolverStateProjection(S) \
        (ssGetSolverInfo(S)->stateProjection)

#define ssSetSolverMassMatrixType(S, val) \
        ssGetSolverInfo(S)->massMatrixType  = (val)
#define ssGetSolverMassMatrixType(S) \
        (ssGetSolverInfo(S)->massMatrixType )

#define ssSetSolverMassMatrixNzMax(S, val) \
        ssGetSolverInfo(S)->massMatrixNzMax  = (val)
#define ssGetSolverMassMatrixNzMax(S) \
        (ssGetSolverInfo(S)->massMatrixNzMax )

#define ssSetSolverMassMatrixIr(S, val) \
        ssGetSolverInfo(S)->massMatrixIr  = (val)
#define ssGetSolverMassMatrixIr(S) \
        (ssGetSolverInfo(S)->massMatrixIr )

#define ssSetSolverMassMatrixJc(S, val) \
        ssGetSolverInfo(S)->massMatrixJc  = (val)
#define ssGetSolverMassMatrixJc(S) \
        (ssGetSolverInfo(S)->massMatrixJc )

#define ssSetSolverMassMatrixPr(S, val) \
        ssGetSolverInfo(S)->massMatrixPr  = (val)
#define ssGetSolverMassMatrixPr(S) \
        (ssGetSolverInfo(S)->massMatrixPr )

#define ssSetSolverConsistencyChecking(S, val) \
        ssGetSolverInfo(S)->consistencyChecking = (val)
#define ssGetSolverConsistencyChecking(S) \
        (ssGetSolverInfo(S)->consistencyChecking)

#define ssSetSolverRobustResetMethod(S, val) \
        ssGetSolverInfo(S)->robustResetMethod = (val)
#define ssGetSolverRobustResetMethod(S) \
        (ssGetSolverInfo(S)->robustResetMethod)

#define _ssSetSolverUpdateJacobianAtReset(S, val)                           \
        ssGetSolverInfo(S)->updateJacobianAtReset = (val)
#define ssSetSolverUpdateJacobianAtReset(S) \
        _ssSetSolverUpdateJacobianAtReset(S,(boolean_T)(1))  /* sticky */
#define ssGetSolverUpdateJacobianAtReset(S) \
        (ssGetSolverInfo(S)->updateJacobianAtReset)  /* boolean_T */

#define ssSetSolverZcThreshold(S,val) \
        ssGetSolverInfo(S)->zcThreshold = (val)
#define ssGetSolverZcThreshold(S) \
        ssGetSolverInfo(S)->zcThreshold

#define ssSetSolverZeroCrossAlgorithm(S,val) \
        ssGetSolverInfo(S)->zeroCrossAlgorithm = (val)
#define ssGetSolverZeroCrossAlgorithm(S) \
        ssGetSolverInfo(S)->zeroCrossAlgorithm

#define ssSetSolverConsecutiveZCsStepRelTol(S,val) \
        ssGetSolverInfo(S)->solverConsecutiveZCsStepRelTol = (val)
#define ssGetSolverConsecutiveZCsStepRelTol(S) \
        ssGetSolverInfo(S)->solverConsecutiveZCsStepRelTol

#define ssSetSolverMaxConsecutiveZCs(S, val) \
        ssGetSolverInfo(S)->solverMaxConsecutiveZCs = (val)
#define ssGetSolverMaxConsecutiveZCs(S) \
        ssGetSolverInfo(S)->solverMaxConsecutiveZCs

#define ssSetSolverMaxConsecutiveMinStep(S, val) \
        ssGetSolverInfo(S)->solverMaxConsecutiveMinStep = (val)
#define ssGetSolverMaxConsecutiveMinStep(S) \
        ssGetSolverInfo(S)->solverMaxConsecutiveMinStep

#define ssSetSolverShapePreserveControl(S, val) \
        ssGetSolverInfo(S)->solverShapePreserveControl = (val)
#define ssGetSolverShapePreserveControl(S) \
        ssGetSolverInfo(S)->solverShapePreserveControl

#define ssSetSolverJacobianMethodControl(S, val) \
        ssGetSolverInfo(S)->solverJacobianMethodControl = (val)
#define ssGetSolverJacobianMethodControl(S) \
        ssGetSolverInfo(S)->solverJacobianMethodControl

#define ssGetSolverConsecutiveZCsError(S) \
        ssGetSolverInfo(S)->consecutiveZCsError
#define ssSetSolverConsecutiveZCsError(S, val) \
        ssGetSolverInfo(S)->consecutiveZCsError = (val)

#define ssGetSolverMaskedZcDiagnostic(S) \
        ssGetSolverInfo(S)->maskedZcDiagnostic
#define ssSetSolverMaskedZcDiagnostic(S, val) \
        ssGetSolverInfo(S)->maskedZcDiagnostic = (val)

#define ssGetSolverIgnoredZcDiagnostic(S) \
        ssGetSolverInfo(S)->ignoredZcDiagnostic
#define ssSetSolverIgnoredZcDiagnostic(S, val) \
        ssGetSolverInfo(S)->ignoredZcDiagnostic = (val)


/* Support old name RTWSolverInfo */

# define ssGetRTWSolverInfo(S)     ssGetSolverInfo(S)
# define ssSetRTWSolverInfo(S,ptr) ssSetSolverInfo(S,ptr)

#endif

#if !SS_SFCN
/*
 * The following logging macros are for use by the Real-Time Workshop and
 * should not be used by S-functions.
 */
# define ssSetRTWLogInfo(S,ptr) \
         (S)->mdlInfo->rtwLogInfo = (ptr)                  /* (RTWLogInfo *)  */

# define ssGetRTWLogInfo(S) \
         (S)->mdlInfo->rtwLogInfo                          /* (RTWLogInfo *)  */

/* Maintained for xPC */
# define ssGetLogT(S) rtliGetLogT((S)->mdlInfo->rtwLogInfo)
# define ssGetLogX(S) rtliGetLogX((S)->mdlInfo->rtwLogInfo)
# define ssGetLogY(S) rtliGetLogY((S)->mdlInfo->rtwLogInfo)

#endif /* !SS_SFCN */


#if !SS_SFCN
/*
 * The following external mode macros are for use by the Real-Time Workshop and
 * should not be used by S-functions.
 */
# define ssSetRTWExtModeInfo(S,ptr) \
         (S)->mdlInfo->extModeInfo = (ptr)

# define ssGetRTWExtModeInfo(S) \
         (S)->mdlInfo->extModeInfo

#endif /* !SS_SFCN */


/* BlockIO vector - used by the Real-Time Workshop and Simulink. This
 *  is starting address of the block input/output vector. All non-virtual
 *  output ports have a slot into which they write their output.
 *
 *  User written S-functions should not access this field.
 */
#define _ssGetBlockIO(S) \
         ((real_T *)((S)->mdlInfo->blockIO))             /*  (real_T *)       */
#if !SS_SFCN
#define ssGetBlockIO(S) _ssGetBlockIO(S)
#else
#define ssGetBlockIO(S) ssGetBlockIO_cannot_be_used_in_SFunctions
#endif
#define _ssSetBlockIO(S,io) \
          (S)->mdlInfo->blockIO = ((void *)(io))
#if !SS_SFCN
#define ssSetBlockIO(S,io) _ssSetBlockIO(S,io)
#else
#define ssSetBlockIO(S,io) ssSetBlockIO_cannot_be_used_in_SFunctions
#endif

/* ReservedForXPC
 *
 *  User written S-functions should not access this field.
 */
#define _ssGetReservedForXPC(S) \
         ((S)->mdlInfo->reservedForXPC)
#if !SS_SFCN
#define ssGetReservedForXPC(S) _ssGetReservedForXPC(S)
#else
#define ssGetReservedForXPC(S) ssGetReservedForXPC_cannot_be_used_in_SFunctions
#endif

#define _ssSetReservedForXPC(S,rxpc) \
         (S)->mdlInfo->reservedForXPC = ((void *)(rxpc))
#if !SS_SFCN
#define ssSetReservedForXPC(S,rxpc) _ssSetReservedForXPC(S,rxpc)
#else
#define ssSetReservedForXPC(S,rxpc) ssSetReservedForXPC_cannot_be_used_in_SFunctions
#endif

/* ConstBlockIO vector - used by the Real-Time Workshop.
 *
 *  User written S-functions should not access this field.
 */
#define _ssGetConstBlockIO(S) \
         ((const void *)((S)->sizes.constBlockIO)) /* (const void *) */
#if !SS_SFCN
#define ssGetConstBlockIO(S) _ssGetConstBlockIO(S)
#else
#define ssGetConstBlockIO(S) ssGetConstBlockIO_cannot_be_used_in_SFunctions
#endif
#define _ssSetConstBlockIO(S,io) \
          (S)->sizes.constBlockIO = ((const void *)(io))
#if !SS_SFCN
#define ssSetConstBlockIO(S,io) _ssSetConstBlockIO(S,io)
#else
#define ssSetConstBlockIO(S,io) ssSetConstBlockIO_cannot_be_used_in_SFunctions
#endif

#if !defined(ENABLE_SLEXEC_SSBRIDGE)
#if !SS_SFCN || defined(RTW_GENERATED_S_FUNCTION)
#define ssGetTimeOfNextSampleHitPtr(S) \
         (S)->mdlInfo->timeOfNextSampleHit
#endif

#if !SS_SFCN
#define ssSetTimeOfNextSampleHitPtr(S, ptr) \
         (S)->mdlInfo->timeOfNextSampleHit = (ptr)
#endif
#endif

/* varNextHitTimesList vector - used by Simulink.
 *
 *  User written S-functions should not access this field.
 */
#if !defined(ENABLE_SLEXEC_SSBRIDGE)
#define _ssGetVarNextHitTime(S,i) \
         ((real_T)((S)->mdlInfo->varNextHitTimesList[(i)]))
#endif
#if !SS_SFCN
#define ssGetVarNextHitTime(S,i) _ssGetVarNextHitTime(S,i)
#else
#define ssGetVarNextHitTime(S,i) ssGetVarNextHitTime_cannot_be_used_in_SFunctions
#endif
#if !defined(ENABLE_SLEXEC_SSBRIDGE)
#define _ssSetVarNextHitTime(S,i,value) \
          (S)->mdlInfo->varNextHitTimesList[(i)] = (value)
#endif
#if  !SS_SFCN
#define ssSetVarNextHitTime(S,i,value) _ssSetVarNextHitTime(S,i,value)
#else
#define ssSetVarNextHitTime(S,i,value) ssSetVarNextHitTime_cannot_be_used_in_SFunctions
#endif

#if !defined(ENABLE_SLEXEC_SSBRIDGE)
#define ssGetVarNextHitTimesListPtr(S) \
          (S)->mdlInfo->varNextHitTimesList /* (real_T *) */

#define _ssSetVarNextHitTimesListPtr(S,listPtr) \
          (S)->mdlInfo->varNextHitTimesList = ((real_T *)(listPtr))
#endif
#if !SS_SFCN
#define ssSetVarNextHitTimesListPtr(S,listPtr) _ssSetVarNextHitTimesListPtr(S,listPtr)
#else
#define ssSetVarNextHitTimesListPtr(S,listPtr) ssSetVarNextHitTimesListPtr_cannot_be_used_in_SFunctions
#endif

/* tNextWasAdjusted vector - used by Simulink.
 *
 *  User written S-functions should not access this field.
 */
#if !defined(ENABLE_SLEXEC_SSBRIDGE)
#define ssGetTNextWasAdjusted(S, sti) \
        ((S)->mdlInfo->tNextWasAdjusted[sti]) /* (boolean_T) */
#if !SS_SFCN
#define _ssSetTNextWasAdjusted(S, sti, val) \
        (S)->mdlInfo->tNextWasAdjusted[sti] = (val)
#define ssSetTNextWasAdjustedPtr(S, ptr) \
    (S)->mdlInfo->tNextWasAdjusted = (ptr)
#endif
#endif

#define _ssGetDefaultParam(S) \
          (S)->mdlInfo->defaultParam                      /*   (real_T *)    */
#if !SS_SFCN || SS_GENERATED_S_FUNCTION
#define ssGetDefaultParam(S) _ssGetDefaultParam(S)
#else
#define ssGetDefaultParam(S) ssGetDefaultParam_cannot_be_used_in_SFunctions
#endif

/*
 * ssSetDefaultParam - Used by the Real-Time Workshop. This contains
 * a pointer to all the model's parameters.
 */

#define _ssSetDefaultParam(S,paramVector) \
          (S)->mdlInfo->defaultParam = (paramVector)
#if !SS_SFCN
#define ssSetDefaultParam(S,paramVector) _ssSetDefaultParam(S,paramVector)
#else
#define ssSetDefaultParam(S,paramVector) \
          ssSetDefaultParam_cannot_be_used_in_SFunctions
#endif

#define _ssGetDefaultParamValue(S,paramIdx) \
          (S)->mdlInfo->defaultParam[paramIdx]            /*   (real_T)      */
#if !SS_SFCN
#define ssGetDefaultParamValue(S,paramIdx) _ssGetDefaultParamValue(S,paramIdx)
#else
#define ssGetDefaultParamValue(S,paramIdx) \
          ssGetDefaultParamValue_cannot_be_used_in_SFunctions
#endif
#define _ssSetDefaultParamValue(S,paramIdx,paramValue) \
          (S)->mdlInfo->defaultParam[paramIdx] = (paramValue)
#if !SS_SFCN
#define ssSetDefaultParamValue(S,paramIdx,paramValue) \
          _ssSetDefaultParamValue(S,paramIdx,paramValue)
#else
#define ssSetDefaultParamValue(S,paramIdx,paramValue) \
          ssSetDefaultParamValue_cannot_be_used_in_SFunctions
#endif

/*
 * ssSetModelMappingInfo - Used by the Real-Time Workshop. This contains
 * a pointer to all the model's mapping information which is used by
 * external applications to "probe" the models, parameter, block I/O, etc
 * vectors.
 */

#define _ssSetModelMappingInfo(S,mapInfo) \
          (S)->mdlInfo->mappingInfo = (void *) (mapInfo)
#if !SS_SFCN || SS_GENERATED_S_FUNCTION
#define ssSetModelMappingInfo(S,mapInfo) _ssSetModelMappingInfo(S,mapInfo)
#else
#define ssSetModelMappingInfo(S,paramVector) \
          ssSetModelMappingInfo_cannot_be_used_in_SFunctions
#endif

#define _ssGetModelMappingInfo(S) \
          (S)->mdlInfo->mappingInfo                      /*   (void*)    */
#if !SS_SFCN || SS_GENERATED_S_FUNCTION
#define ssGetModelMappingInfo(S) _ssGetModelMappingInfo(S)
#else
#define ssGetModelMappingInfo(S) \
          ssGetModelMappingInfo_cannot_be_used_in_SFunctions
#endif

#if !SS_SFCN || SS_GENERATED_S_FUNCTION
#define ssGetContextSysRanBCPtr(S, ptr) \
   _ssSafelyCallGenericFcnStart(S) (S, \
    GEN_FCN_GET_CONTEXT_SYS_PTR, 0, (ptr)) \
   _ssSafelyCallGenericFcnEnd
#else
#define ssGetContextSysRanBCPtr(S) \
          ssGetContextSysRanBCPtr_cannot_be_used_in_SFunctions
#endif

#if !SS_SFCN || SS_GENERATED_S_FUNCTION
#define ssGetContextSysTid(S, tid) \
   _ssSafelyCallGenericFcnStart(S) (S, \
    GEN_FCN_GET_CONTEXT_TID, 0, (tid)) \
   _ssSafelyCallGenericFcnEnd
#else
#define ssGetContextSysTid(S) \
          ssGetContextSysTid_cannot_be_used_in_SFunctions
#endif

# define ssCallAccelRunBlock(S,sysIdx,blkIdx,function) \
    (*(S)->mdlInfo->accelRunBlock)(S, sysIdx, blkIdx, function); 

# define _ssSetAccelRunBlockFcn(S,fcn) \
          (S)->mdlInfo->accelRunBlock = (fcn)
# define _ssSetBdRefPtr(S,ptr) \
          (S)->mdlInfo->bdRefPtr = ((void *) ptr)
# define _ssGetBdRefPtr(S) \
          (S)->mdlInfo->bdRefPtr                        /*   (void*)    */

#if !SS_SFCN
# define ssSetAccelRunBlockFcn(S,fcn) _ssSetAccelRunBlockFcn(S,fcn)
# define ssSetBdRefPtr(S,ptr) _ssSetBdRefPtr(S,ptr)
# define ssGetBdRefPtr(S) _ssGetBdRefPtr(S)
#else
# define ssSetAccelRunBlockFcn(S,fcn) \
          ssSetAccelRunBlockFcn_cannot_be_used_in_SFunctions
# define ssSetBdRefPtr(S,ptr) \
          ssSetBdRefPtr_cannot_be_used_in_SFunctions
# define ssGetBdRefPtr(S) \
          ssGetBdRefPtr_cannot_be_used_in_SFunctions
#endif

#if SS_SL_INTERNAL
# define ssSetWriteRTWStrFcn(S,fcn) \
          (S)->mdlInfo->writeRTWStrFcn = (fcn)
# define ssSetWriteRTWNameValuePairFcn(S,fcn) \
          (S)->mdlInfo->writeRTWNameValuePairFcn = (fcn)
# define ssSetWriteRTWParameterFcn(S,fcn) \
          (S)->mdlInfo->writeRTWParameterFcn = (fcn)
# define ssSetWriteRTWFcnArg(S,fcnarg) \
          (S)->mdlInfo->writeRTWFcnArg = (fcnarg)
# define ssSetGenericFcn(S,fcn) \
          (S)->mdlInfo->genericFcn = (fcn)
#endif

#if SS_SFCN_FOR_SIM

#ifdef __cplusplus
extern "C" {
#endif

  extern DTypeId ssGetDTypeIdFromMxArray(const mxArray *m);

  extern int_T ssWriteRTWStr(               SimStruct *S,
                                            const char_T *str);

  extern int_T ssWriteRTWNameValuePair(     SimStruct    *S,
                                            int_T        type,
                                            const char_T *name,
                                            const void   *value, ...);

  extern int_T ssWriteRTWParamSettings(     SimStruct *S,
                                            int_T nParams, ...);

  extern int_T ssWriteRTWParameters(        SimStruct *S,
                                            int_T nParams, ...);

  extern int_T ssWriteRTWWorkVect(          SimStruct *S,
                                            const char_T *vectName,
                                            int_T nNames, ...);

# define ssWriteRTWStrParam(S,n,v) \
         ssWriteRTWNameValuePair(S,SSWRITE_VALUE_QSTR,n,v)
# define ssWriteRTWStrVectParam(S,n,v,len) \
         ssWriteRTWNameValuePair(S,SSWRITE_VALUE_VECT_STR,n,v,len)
# define ssWriteRTWScalarParam(S,n,v,dt) \
         ssWriteRTWNameValuePair(S,SSWRITE_VALUE_DTYPE_NUM,n,v,dt)
# define ssWriteRTWVectParam(S,n,v,dt,len) \
         ssWriteRTWNameValuePair(S,SSWRITE_VALUE_DTYPE_VECT,n,v,dt,len)
# define ssWriteRTW2dMatParam(S,n,v,dt,nr,nc) \
         ssWriteRTWNameValuePair(S,SSWRITE_VALUE_DTYPE_2DMAT,n,v,dt,nr,nc)

extern int_T ssWriteRTWMxVectParam(SimStruct    *S,
                                   const char_T *name,
                                   const void   *rVal,
                                   const void   *iVal,
                                   int_T        dtInfo,
                                   int_T        numEl);

extern int_T ssWriteRTWMx2dMatParam(SimStruct    *S,
                                    const char_T *name,
                                    const void   *rVal,
                                    const void   *iVal,
                                    int_T        dtInfo,
                                    int_T        nRows,
                                    int_T        nCols);

extern int_T _ssSetInputPortMatrixDimensions(SimStruct *S, int_T port,
                                           int_T m, int_T n);
extern int_T _ssSetOutputPortMatrixDimensions(SimStruct *S, int_T port,
                                            int_T m, int_T n);
extern int_T _ssSetInputPortVectorDimension(SimStruct *S, int_T port, int_T m);
extern int_T _ssSetOutputPortVectorDimension(SimStruct *S, int_T port, int_T m);
extern int_T ssIsRunTimeParamTunable(SimStruct *S, const int_T rtPIdx);
extern double ssGetSFuncBlockHandle(SimStruct *S);
extern int_T _ssGetCurrentInputPortWidth( SimStruct *S, int_T pIdx);
extern int_T _ssGetCurrentOutputPortWidth(SimStruct *S, int_T pIdx);
extern int_T _ssGetCallSystemNumFcnCallDestinations(SimStruct *S, int_T elemIdx);

#ifdef __cplusplus
}
#endif

#endif


/*
 * Signal Access.
 */
#if SS_SL_INTERNAL
# define ssSetSignalAccess(S, ptr) \
    (S)->mdlInfo->signalAccess = (ptr)

# define ssGetSignalAccess(S) ((S)->mdlInfo->signalAccess)

# define ssSetSelectedSignalsFcn(S,fcn) \
          (S)->mdlInfo->signalAccess->SelectedSignals = (fcn)

# define ssSetSigListCreateFcn(S,fcn) \
          (S)->mdlInfo->signalAccess->SigListCreate = (fcn)

# define ssSetSigListDestroyFcn(S,fcn) \
          (S)->mdlInfo->signalAccess->SigListDestroy = (fcn)

# define ssSetSigListUnavailSigAlertFcn(S,fcn) \
          (S)->mdlInfo->signalAccess->SigListUnavailSigAlert = (fcn)

# define ssSetGenericDestroyFcn(S,fcn) \
          (S)->mdlInfo->signalAccess->utFree = (fcn)

# define ssSetGetPortNameFcn(S,fcn) \
          (S)->mdlInfo->signalAccess->GetPortName = (fcn)

# define ssSetUnselectSigFcn(S,fcn) \
          (S)->mdlInfo->signalAccess->UnselectSig = (fcn)

# define ssSetSigListGetNumRegionsFcn(S,fcn) \
          (S)->mdlInfo->signalAccess->SigListGetNumRegions = (fcn)

# define ssSetSigListGetFirstRegFcn(S,fcn) \
          (S)->mdlInfo->signalAccess->SigListGetFirstReg = (fcn)

# define ssSetSigListGetNumElementsFcn(S,fcn) \
          (S)->mdlInfo->signalAccess->SigListGetNumElements = (fcn)

# define ssSetSigListGetIfTieWrapFcn(S,fcn) \
          (S)->mdlInfo->signalAccess->SigListGetIfTieWrap = (fcn)
#endif

#if SS_SL_INTERNAL || SS_SFCN_FOR_SIM

#define ssCallSelectedSignalsFcn(                                     \
    S,voidBlock,sigSetOpt,voidOutPortObjs,outnPortObjs)               \
        (S)->mdlInfo->signalAccess->SelectedSignals(                  \
            (voidBlock),(sigSetOpt),(voidOutPortObjs),(outnPortObjs))

#define ssCallSigListCreateFcn(                                     \
    S,voidBlock,nPorts,voidPortObjs,excludeFlags,voidOutSigList)    \
        (S)->mdlInfo->signalAccess->SigListCreate(                  \
            (voidBlock),(nPorts),(voidPortObjs),(excludeFlags),(voidOutSigList))

#define ssCallSigListDestroyFcn(S,voidSigList) \
        (S)->mdlInfo->signalAccess->SigListDestroy((voidSigList))

#define ssCallSigListUnavailSigAlertFcn(S,voidSigList) \
        (S)->mdlInfo->signalAccess->SigListUnavailSigAlert((voidSigList))

#define ssCallGenericDestroyFcn(S,ptr) \
        (S)->mdlInfo->signalAccess->utFree((ptr))

#define ssCallGetPortNameFcn(S,voidPortObj) \
        (S)->mdlInfo->signalAccess->GetPortName((voidPortObj))

#define ssCallUnselectSigFcn(S,voidPortObj) \
        (S)->mdlInfo->signalAccess->UnselectSig((voidPortObj))

#define ssCallSigListGetNumRegionsFcn(S, voidSigList, idx) \
        (S)->mdlInfo->signalAccess->SigListGetNumRegions((voidSigList), (idx))

#define ssCallSigListGetFirstRegFcn(S, voidSigList, idx) \
        (S)->mdlInfo->signalAccess->SigListGetFirstReg((voidSigList), (idx))

#define ssCallSigListGetNumElementsFcn(S, voidSigList, idx) \
        (S)->mdlInfo->signalAccess->SigListGetNumElements((voidSigList), (idx))

#define ssCallSigListGetIfTieWrapFcn(S, voidSigList, idx) \
        (S)->mdlInfo->signalAccess->SigListGetIfTieWrap((voidSigList), (idx))
#endif

/*
 * Data type Access.
 */
#if !SS_SFCN_LEVEL_1

# if SS_SL_INTERNAL
#define ssSetDataTypeAccess(S, dta) \
  (S)->mdlInfo->dataTypeAccess = (dta)

#define dtaGetDataTypeTable(dta) \
  ((dta)->dataTypeTable)
#define dtaSetDataTypeTable(dta, table) \
  (dta)->dataTypeTable = (table)

#define dtaGetRegisterDataTypeFcn(dta) \
  ((dta)->registerFcn)
#define dtaSetRegisterDataTypeFcn(dta, fcn) \
  (dta)->registerFcn = (fcn)

#define dtaGetRegisterDataTypeFcnWithCheck(dta) \
  ((dta)->registerFcnWithCheck)
#define dtaSetRegisterDataTypeFcnWithCheck(dta, fcn) \
  (dta)->registerFcnWithCheck = (fcn)

#define dtaGetNumDataTypesFcn(dta) \
  ((dta)->getNumDataTypesFcn)
#define dtaSetGetNumDataTypesFcn(dta, fcn) \
  (dta)->getNumDataTypesFcn = (fcn)

#define dtaGetDataTypeIdFcn(dta) \
  ((dta)->getIdFcn)
#define dtaSetGetDataTypeIdFcn(dta, fcn) \
  (dta)->getIdFcn = (fcn)

#define dtaGetGetGenericDTAIntProp(dta) \
  ((dta)->getGenericDTAIntProp)
#define dtaSetGetGenericDTAIntProp(dta, fcn) \
  (dta)->getGenericDTAIntProp = (fcn)
#define dtaGetSetGenericDTAIntProp(dta) \
  ((dta)->setGenericDTAIntProp)
#define dtaSetSetGenericDTAIntProp(dta, fcn) \
  (dta)->setGenericDTAIntProp = (fcn)

#define dtaGetGetGenericDTAIntElemProp(dta) \
  ((dta)->getGenericDTAIntElemProp)
#define dtaSetGetGenericDTAIntElemProp(dta, fcn) \
  (dta)->getGenericDTAIntElemProp = (fcn)
#define dtaGetSetGenericDTAIntElemProp(dta) \
  ((dta)->setGenericDTAIntElemProp)
#define dtaSetSetGenericDTAIntElemProp(dta, fcn) \
  (dta)->setGenericDTAIntElemProp = (fcn)

#define dtaGetGetGenericDTARealElemProp(dta) \
  ((dta)->getGenericDTARealElemProp)
#define dtaSetGetGenericDTARealElemProp(dta, fcn) \
  (dta)->getGenericDTARealElemProp = (fcn)
#define dtaGetSetGenericDTARealElemProp(dta) \
  ((dta)->setGenericDTARealElemProp)
#define dtaSetSetGenericDTARealElemProp(dta, fcn) \
  (dta)->setGenericDTARealElemProp = (fcn)

#define dtaGetGetGenericDTAVoidProp(dta) \
  ((dta)->getGenericDTAVoidProp)
#define dtaSetGetGenericDTAVoidProp(dta, fcn) \
  (dta)->getGenericDTAVoidProp = (fcn)
#define dtaGetSetGenericDTAVoidProp(dta) \
  ((dta)->setGenericDTAVoidProp)
#define dtaSetSetGenericDTAVoidProp(dta, fcn) \
  (dta)->setGenericDTAVoidProp = (fcn)

#define dtaGetGetGenericDTAVoidElemProp(dta) \
  ((dta)->getGenericDTAVoidElemProp)
#define dtaSetGetGenericDTAVoidElemProp(dta, fcn) \
  (dta)->getGenericDTAVoidElemProp = (fcn)
#define dtaGetSetGenericDTAVoidElemProp(dta) \
  ((dta)->setGenericDTAVoidElemProp)
#define dtaSetSetGenericDTAVoidElemProp(dta, fcn) \
  (dta)->setGenericDTAVoidElemProp = (fcn)

#define dtaGetGetConvertBetweenFcn(dta) \
  ((dta)->getConvertBetweenFcn)
#define dtaSetGetConvertBetweenFcn(dta, fcn) \
  (dta)->getConvertBetweenFcn = (fcn)
#define dtaGetSetConvertBetweenFcn(dta) \
  ((dta)->setConvertBetweenFcn)
#define dtaSetSetConvertBetweenFcn(dta, fcn) \
  (dta)->setConvertBetweenFcn = (fcn)

#define dtaGetGetGenericDTAUnaryFcnGW(dta) \
  ((dta)->getGenericDTAUnaryFcnGW)
#define dtaSetGetGenericDTAUnaryFcnGW(dta, fcn) \
  (dta)->getGenericDTAUnaryFcnGW = (fcn)
#define dtaGetSetGenericDTAUnaryFcnGW(dta) \
  ((dta)->setGenericDTAUnaryFcnGW)
#define dtaSetSetGenericDTAUnaryFcnGW(dta, fcn) \
  (dta)->setGenericDTAUnaryFcnGW = (fcn)

#define dtaGetGetGenericDTABinaryFcnGW(dta) \
  ((dta)->getGenericDTABinaryFcnGW)
#define dtaSetGetGenericDTABinaryFcnGW(dta, fcn) \
  (dta)->getGenericDTABinaryFcnGW = (fcn)
#define dtaGetSetGenericDTABinaryFcnGW(dta) \
  ((dta)->setGenericDTABinaryFcnGW)
#define dtaSetSetGenericDTABinaryFcnGW(dta, fcn) \
  (dta)->setGenericDTABinaryFcnGW = (fcn)

#define dtaSetGetDTADiagnostic(dta, fcn) \
  (dta)->getGenericDTADiagnostic = (fcn)

#endif

/* Fixed-Point license manager access*/

#if SS_SIM
#define ssSetFixedPointLicenseAccess(S,idx,d) \
    _ssSafelyCallGenericFcnStart(S)(S,GENFCNFIXPT_LICENSE,idx,(void*)d)\
    _ssSafelyCallGenericFcnEnd
#endif

# if SS_SIM
#define ssGetDataTypeAccess(S) \
  ((S)->mdlInfo->dataTypeAccess)
# else
   #define ssGetDataTypeAccess(S) \
    ssGetDataTypeAccess_cannot_be_used_in_RTW
# endif

# if SS_SIM
#  define dtaGetErrorString(dta) \
    ((dta) != NULL ? \
    (dta)->errorString : \
    NULL)
# else
#  define dtaGetErrorString(dta) \
    dtaGetErrorString_cannot_be_used_in_RTW
# endif

# if SS_SIM
#  define dtaSetErrorString(dta, string) \
    ((dta) != NULL ? \
    (dta)->errorString = (string) : \
    0)
# else
#  define dtaSetErrorString(dta, string) \
    dtaSetErrorString_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaRegisterDataTypeWithCheck(dta, blockPath, name, idptr) \
   ((dta) != NULL ? \
   (dta)->registerFcnWithCheck((dta)->dataTypeTable, (blockPath), (name), idptr) : \
   NULL)
# else
#  define dtaRegisterDataTypeWithCheck(dta, blockPath, name, idptr) \
    dtaRegisterDataType_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaRegisterDataType(dta, blockPath, name) \
   ((dta) != NULL ? \
   (dta)->registerFcn((dta)->dataTypeTable, (blockPath), (name)) : \
   INVALID_DTYPE_ID)
# else
#  define dtaRegisterDataType(dta, blockPath, name) \
    dtaRegisterDataType_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaGetNumDataTypes(dta) \
   ((dta) != NULL ? \
   (dta)->getNumDataTypesFcn((dta)->dataTypeTable) : \
   INVALID_NUM_DTYPES)
# else
#  define dtaGetNumDataTypes(dta) \
    dtaGetNumDataTypes_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaGetDataTypeId(dta, name) \
   ((dta) != NULL ? \
   (dta)->getIdFcn((dta)->dataTypeTable, (name)) : \
   INVALID_DTYPE_ID)
# else
#  define dtaGetDataTypeId(dta, name) \
    dtaGetDataTypeId_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaGetDataTypeName(dta, blockPath, id) \
   ((dta) != NULL ? \
   (dta)->getGenericDTAVoidProp((dta)->dataTypeTable, (blockPath), (id), \
     GEN_DTA_VOID_PROP_NAME) : \
   NULL)
# else
#  define dtaGetDataTypeName(dta, blockPath, id) \
    dtaGetDataTypeName_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaGetDataTypeSize(dta, blockPath, id) \
   ((dta) != NULL ? \
   (dta)->getGenericDTAIntProp((dta)->dataTypeTable, (blockPath), (id), \
     GEN_DTA_INT_PROP_SIZE) : \
   INVALID_DTYPE_SIZE)
# else
#  define dtaGetDataTypeSize(dta, blockPath, id) \
    dtaGetDataTypeSize_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaSetDataTypeSize(dta, blockPath, id, size) \
   ((dta) != NULL ? \
   (dta)->setGenericDTAIntProp((dta)->dataTypeTable, (blockPath), (id), \
     (size), GEN_DTA_INT_PROP_SIZE) : \
   0)
# else
#  define dtaSetDataTypeSize(dta, blockPath, id, size) \
    dtaSetDataTypeSize_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaGetDataTypeStorageId(dta, blockPath, id) \
   ((dta) != NULL ? \
   (dta)->getGenericDTAIntProp((dta)->dataTypeTable, (blockPath), (id), \
     GEN_DTA_INT_PROP_STORAGE_ID) : \
   INVALID_DTYPE_ID)
# else
#  define dtaGetDataTypeStorageId(dta, blockPath, id) \
    dtaGetDataTypeStorageId_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaSetDataTypeStorageId(dta, blockPath, id, storageId) \
   ((dta) != NULL ? \
   (dta)->setGenericDTAIntProp((dta)->dataTypeTable, (blockPath), (id), \
     (storageId), GEN_DTA_INT_PROP_STORAGE_ID) : \
   0)
# else
#  define dtaSetDataTypeStorageId(dta, blockPath, id, storageId) \
    dtaSetDataTypeStorageId_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaGetDataTypeIdAliasedTo(dta, blockPath, id) \
   ((dta) != NULL ? \
   (dta)->getGenericDTAIntProp((dta)->dataTypeTable, (blockPath), (id), \
     GEN_DTA_INT_PROP_ID_ALIASED_TO) : \
   INVALID_DTYPE_ID)
# else
#  define dtaGetDataTypeIdAliasedTo(dta, blockPath, id) \
    dtaGetDataTypeIdAliasedTo_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaSetDataTypeIdAliasedTo(dta, blockPath, id, idAliasedTo) \
   ((dta) != NULL ? \
   (dta)->setGenericDTAIntProp((dta)->dataTypeTable, (blockPath), (id), \
     (idAliasedTo), GEN_DTA_INT_PROP_ID_ALIASED_TO) : \
   0)
# else
#  define dtaSetDataTypeIdAliasedTo(dta, blockPath, id, idAliasedTo) \
    dtaSetDataTypeIdAliasedTo_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaGetDataTypeIdAliasedThruTo(dta, blockPath, id) \
   ((dta) != NULL ? \
   (dta)->getGenericDTAIntProp((dta)->dataTypeTable, (blockPath), (id), \
     GEN_DTA_INT_PROP_ID_ALIASED_THRU_TO) : \
   INVALID_DTYPE_ID)
# else
#  define dtaGetDataTypeIdAliasedThruTo(dta, blockPath, id) \
    dtaGetDataTypeIdAliasedThruTo_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaGetDataTypeZero(dta, blockPath, id) \
   ((dta) != NULL ? \
   (dta)->getGenericDTAVoidProp((dta)->dataTypeTable, (blockPath), (id), \
     GEN_DTA_VOID_PROP_ZERO) : \
   NULL)
# else
#  define dtaGetDataTypeZero(dta, blockPath, id) \
    dtaGetDataTypeZero_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaSetDataTypeZero(dta, blockPath, id, zero) \
   ((dta) != NULL ? \
   (dta)->setGenericDTAVoidProp((dta)->dataTypeTable, (blockPath), (id), \
     (zero), GEN_DTA_VOID_PROP_ZERO) : \
   0)
# else
#  define dtaSetDataTypeZero(dta, blockPath, id, zero) \
    dtaSetDataTypeZero_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaGetDataTypeProperties(dta, blockPath, id) \
   ((dta) != NULL ? \
   (dta)->getGenericDTAVoidProp((dta)->dataTypeTable, (blockPath), (id), \
     GEN_DTA_VOID_PROP_PROPERTIES) : \
   NULL)
# else
#  define dtaGetDataTypeProperties(dta, blockPath, id) \
    dtaGetDataTypeProperties_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaSetDataTypeProperties(dta, blockPath, id, properties) \
   ((dta) != NULL ? \
   (dta)->setGenericDTAVoidProp((dta)->dataTypeTable, (blockPath), (id), \
     (properties), GEN_DTA_VOID_PROP_PROPERTIES) : \
   0)
# else
#  define dtaSetDataTypeProperties(dta, blockPath, id, properties) \
    dtaSetDataTypeProperties_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaGetDataTypeObject(dta, blockPath, id) \
   ((dta) != NULL ? \
   (dta)->getGenericDTAVoidProp((dta)->dataTypeTable, (blockPath), (id), \
     GEN_DTA_VOID_PROP_OBJECT) : \
   NULL)
# else
#  define dtaGetDataTypeObject(dta, blockPath, id) \
    dtaGetDataTypeObject_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaGetDataTypeCGType(dta, blockPath, id) \
   ((dta) != NULL ? \
   (dta)->getGenericDTAVoidProp((dta)->dataTypeTable, (blockPath), (id), \
     GEN_DTA_VOID_PROP_CGTYPE) : \
   NULL)
# else
#  define dtaGetDataTypeCGType(dta, blockPath, id) \
    dtaGetDataTypeCGType_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaGetDataTypePropertiesSize(dta, blockPath, id) \
   ((dta) != NULL ? \
   (dta)->getGenericDTAIntProp((dta)->dataTypeTable, (blockPath), (id), \
     GEN_DTA_INT_PROP_PROPERTIES_SIZE) : \
   INVALID_DTYPE_SIZE)
# else
#  define dtaGetDataTypePropertiesSize(dta, blockPath, id) \
    dtaGetDataTypePropertiesSize_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaSetDataTypePropertiesSize(dta, blockPath, id, size) \
   ((dta) != NULL ? \
   (dta)->setGenericDTAIntProp((dta)->dataTypeTable, (blockPath), (id), \
     (size), GEN_DTA_INT_PROP_PROPERTIES_SIZE) : \
   0)
# else
#  define dtaSetDataTypePropertiesSize(dta, blockPath, id, size) \
    dtaSetDataTypePropertiesSize_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaGetDataTypeNumElements(dta, blockPath, id) \
   ((dta) != NULL ? \
   (dta)->getGenericDTAIntProp((dta)->dataTypeTable, (blockPath), (id), \
     GEN_DTA_INT_PROP_NUM_ELEMENTS) : \
   -1)
# else
#  define dtaGetDataTypeNumElements(dta, blockPath, id) \
    dtaGetDataTypeNumElements_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaGetDataTypeIsBus(dta, blockPath, id) \
   ((dta) != NULL ? \
   (dta)->getGenericDTAIntProp((dta)->dataTypeTable, (blockPath), (id), \
     GEN_DTA_INT_PROP_IS_BUS) : \
   -1)
# else
#  define dtaGetDataTypeIsBus(dta, blockPath, id) \
    dtaGetDataTypeIsBus_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaGetDataTypeIsBusWithVarDimsElement(dta, blockPath, id) \
   ((dta) != NULL ? \
   (dta)->getGenericDTAIntProp((dta)->dataTypeTable, (blockPath), (id), \
     GEN_DTA_INT_PROP_IS_BUS_WITH_VARDIMS_ELEMENT) : \
   -1)
# else
#  define dtaGetDataTypeIsBusWithVarDimsElement(dta, blockPath, id) \
    dtaGetDataTypeIsBusWithVarDimsElement_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaGetDataTypeVarDimsSize(dta, blockPath, id) \
   ((dta) != NULL ? \
   (dta)->getGenericDTAIntProp((dta)->dataTypeTable, (blockPath), (id), \
     GEN_DTA_INT_PROP_VARDIMS_SIZE) : \
   INVALID_DTYPE_SIZE)
# else
#  define dtaGetDataTypeVarDimsSize(dta, blockPath, id) \
    dtaGetDataTypeVarDimsSize_cannot_be_used_in_RTW
# endif

# if SS_SIM
#  define dtaGetDataTypeElementDataType(dta, blockPath, id, eIdx) \
   ((dta) != NULL ? \
   (dta)->getGenericDTAIntElemProp((dta)->dataTypeTable, (blockPath), (id), \
     (eIdx), GEN_DTA_INT_PROP_ELEMENT_DATA_TYPE) : \
   INVALID_DTYPE_ID)
# else
#  define dtaGetDataTypeElementDataType(dta, blockPath, id, eIdx) \
    dtaGetDataTypeElementDataType_cannot_be_used_in_RTW
# endif

# if SS_SIM
#  define dtaGetDataTypeElementSignalType(dta, blockPath, id, eIdx) \
   ((dta) != NULL ? \
   (dta)->getGenericDTAIntElemProp((dta)->dataTypeTable, (blockPath), (id), \
     (eIdx), GEN_DTA_INT_PROP_ELEMENT_SIGNAL_TYPE) : \
   INVALID_DTYPE_ID)
# else
#  define dtaGetDataTypeElementSignalType(dta, blockPath, id, eIdx) \
    dtaGetDataTypeElementSignalType_cannot_be_used_in_RTW
# endif

# if SS_SIM
#  define dtaGetDataTypeElementOffset(dta, blockPath, id, eIdx) \
   ((dta) != NULL ? \
   (dta)->getGenericDTAIntElemProp((dta)->dataTypeTable, (blockPath), (id), \
     (eIdx), GEN_DTA_INT_PROP_ELEMENT_OFFSET) : \
   -1)
# else
#  define dtaGetDataTypeElementOffset(dta, blockPath, id, eIdx) \
    dtaGetDataTypeElementOffset_cannot_be_used_in_RTW
# endif

# if SS_SIM
#  define dtaGetDataTypeElementNumDimensions(dta, blockPath, id, eIdx) \
   ((dta) != NULL ? \
   (dta)->getGenericDTAIntElemProp((dta)->dataTypeTable, (blockPath), (id), \
     (eIdx), GEN_DTA_INT_PROP_ELEMENT_NUM_DIMENSIONS) : \
   -1)
# else
#  define dtaGetDataTypeElementNumDimensions(dta, blockPath, id, eIdx) \
    dtaGetDataTypeElementNumDimensions_cannot_be_used_in_RTW
# endif

# if SS_SIM
#  define dtaGetDataTypeElementDimensionsMode(dta, blockPath, id, eIdx) \
   ((dta) != NULL ? \
   (dta)->getGenericDTAIntElemProp((dta)->dataTypeTable, (blockPath), (id), \
     (eIdx), GEN_DTA_INT_PROP_ELEMENT_DIMENSIONS_MODE) : \
   -1)
# else
#  define dtaGetDataTypeElementDimensionsMode(dta, blockPath, id, eIdx) \
    dtaGetDataTypeElementDimensionsMode_cannot_be_used_in_RTW
# endif

# if SS_SIM
#  define dtaGetDataTypeElementVarDimsOffset(dta, blockPath, id, eIdx) \
   ((dta) != NULL ? \
   (dta)->getGenericDTAIntElemProp((dta)->dataTypeTable, (blockPath), (id), \
     (eIdx), GEN_DTA_INT_PROP_ELEMENT_VARDIMS_OFFSET) : \
   -1)
# else
#  define dtaGetDataTypeElementVarDimsOffset(dta, blockPath, id, eIdx) \
    dtaGetDataTypeElementVarDimsOffset_cannot_be_used_in_RTW
# endif

# if SS_SIM
#  define dtaGetDataTypeElementName(dta, blockPath, id, eIdx) \
   ((dta) != NULL ? \
   (dta)->getGenericDTAVoidElemProp((dta)->dataTypeTable, (blockPath), (id), \
     (eIdx), GEN_DTA_VOID_PROP_ELEMENT_NAME) : \
   "")
# else
#  define dtaGetDataTypeElementName(dta, blockPath, id, eIdx) \
    dtaGetDataTypeElementName_cannot_be_used_in_RTW
# endif

# if SS_SIM
#  define dtaGetDataTypeElementDimensions(dta, blockPath, id, eIdx) \
   ((dta) != NULL ? \
   (dta)->getGenericDTAVoidElemProp((dta)->dataTypeTable, (blockPath), (id), \
     (eIdx), GEN_DTA_VOID_PROP_ELEMENT_DIMENSIONS) : \
   NULL)
# else
#  define dtaGetDataTypeElementDimensions(dta, blockPath, id, eIdx) \
    dtaGetDataTypeElementDimensions_cannot_be_used_in_RTW
# endif

# if SS_SIM
#  define dtaGetDataTypeElementMin(dta, blockPath, id, eIdx) \
   ((dta) != NULL ? \
   (dta)->getGenericDTARealElemProp((dta)->dataTypeTable, (blockPath), (id), \
     (eIdx), GEN_DTA_REAL_PROP_ELEMENT_MIN) : \
    -(mxGetInf()))
# else
#  define dtaGetDataTypeElementMin(dta, blockPath, id, eIdx) \
    dtaGetDataTypeElementMin_cannot_be_used_in_RTW
# endif

# if SS_SIM
#  define dtaGetDataTypeElementMax(dta, blockPath, id, eIdx) \
   ((dta) != NULL ? \
   (dta)->getGenericDTARealElemProp((dta)->dataTypeTable, (blockPath), (id), \
     (eIdx), GEN_DTA_REAL_PROP_ELEMENT_MAX) : \
    mxGetInf())
# else
#  define dtaGetDataTypeElementMax(dta, blockPath, id, eIdx) \
    dtaGetDataTypeElementMax_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaGetDataTypeIsEnumType(dta, blockPath, id) \
   ((dta) != NULL ? \
   (dta)->getGenericDTAIntProp((dta)->dataTypeTable, (blockPath), (id), \
     GEN_DTA_INT_PROP_IS_ENUMTYPE) : \
   -1)
# else
#  define dtaGetDataTypeIsEnumType(dta, blockPath, id) \
    dtaGetDataTypeIsEnumType_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaGetEnumTypeNumStrings(dta, blockPath, id) \
  ((dta) != NULL ? \
   (dta)->getGenericDTAIntProp((dta)->dataTypeTable, (blockPath), (id), \
     GEN_DTA_INT_PROP_ENUMTYPE_NUMSTRINGS) : \
   -1)
# else
#  define dtaGetEnumTypeNumStrings(dta, blockPath, id, eIdx) \
    dtaGetEnumTypeNumStrings_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaGetEnumTypeIndexOfDefault(dta, blockPath, id) \
   ((dta) != NULL ? \
   (dta)->getGenericDTAIntProp((dta)->dataTypeTable, (blockPath), (id), \
     GEN_DTA_INT_PROP_ENUMTYPE_INDEX_OF_DEFAULT) : \
   -1)
# else
#  define dtaGetEnumTypeIndexOfDefault(dta, blockPath, id) \
    dtaGetEnumTypeIndexOfDefault_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaGetEnumTypeAddPrefix(dta, blockPath, id) \
  ((dta) != NULL ? \
   (dta)->getGenericDTAIntProp((dta)->dataTypeTable, (blockPath), (id), \
     GEN_DTA_INT_PROP_ENUMTYPE_ADD_TYPENAME_AS_PREFIX) : \
   -1)
# else
#  define dtaGetEnumTypeAddPrefix(dta, blockPath, id) \
    dtaGetEnumTypeAddPrefix_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaGetEnumTypeStorageId(dta, blockPath, id) \
  ((dta) != NULL ? \
   (dta)->getGenericDTAIntProp((dta)->dataTypeTable, (blockPath), (id), \
     GEN_DTA_INT_PROP_STORAGE_ID) : \
   -1)
# else
#  define dtaGetEnumTypeStorageId(dta, blockPath, id) \
    dtaGetEnumTypeStorageId_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaGetEnumTypeIndexFromValue(dta, blockPath, id, eValue) \
  ((dta) != NULL ? \
   (dta)->getGenericDTAIntElemProp((dta)->dataTypeTable, (blockPath), (id), \
     (eValue), GEN_DTA_INT_PROP_ENUMTYPE_INDEX_FROM_VALUE) : \
   -1)
# else
#  define dtaGetEnumTypeIndexFromValue(dta, blockPath, id, eValue) \
    dtaGetEnumTypeIndexFromValue_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaGetEnumTypeValueFromIndex(dta, blockPath, id, eIdx) \
  ((dta) != NULL ? \
   (dta)->getGenericDTAIntElemProp((dta)->dataTypeTable, (blockPath), (id), \
     (eIdx), GEN_DTA_INT_PROP_ENUMTYPE_VALUE_FROM_INDEX) : \
   -1)
# else
#  define dtaGetEnumTypeValueFromIndex(dta, blockPath, id, eIdx) \
    dtaGetEnumTypeValueFromIndex_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaGetEnumTypeStringFromValue(dta, blockPath, id, eIdx) \
  ((dta) != NULL ? \
   (dta)->getGenericDTAVoidElemProp((dta)->dataTypeTable, (blockPath), (id), \
     (eIdx), GEN_DTA_VOID_PROP_ENUMTYPE_STRING_FROM_VALUE) : \
   NULL)
# else
#  define dtaGetEnumTypeStringFromValue(dta, blockPath, id, eIdx) \
    dtaGetEnumTypeStringFromValue_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaGetEnumTypeStringFromIndex(dta, blockPath, id, eIdx) \
  ((dta) != NULL ? \
   (dta)->getGenericDTAVoidElemProp((dta)->dataTypeTable, (blockPath), (id), \
     (eIdx), GEN_DTA_VOID_PROP_ENUMTYPE_STRING_FROM_INDEX) : \
   NULL)
# else
#  define dtaGetEnumTypeStringFromIndex(dta, blockPath, id, eIdx) \
    dtaGetEnumTypeStringFromIndex_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaGetConvertBetweenFcn(dta, blockPath, id) \
  ((dta) != NULL ? \
  (dta)->getConvertBetweenFcn((dta)->dataTypeTable, (blockPath), (id)) : \
  NULL)
# else
#  define dtaGetConvertBetweenFcn(dta, blockPath, id) \
    dtaGetConvertBetweenFcn_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaSetConvertBetweenFcn(dta, blockPath, id, fcn) \
  ((dta) != NULL ? \
  (dta)->setConvertBetweenFcn((dta)->dataTypeTable, (blockPath), (id), (fcn)) : \
  0)
# else
#  define dtaSetConvertBetweenFcn(dta, blockPath, id, fcn) \
   dtaSetConvertBetweenFcn_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaCallConvertBetweenForSrcId(dta, blockPath, dstId, srcId, numEls, u, options, y) \
  (dtaGetConvertBetweenFcn((dta), (blockPath), (srcId)) != NULL ? \
  dtaGetConvertBetweenFcn((dta), (blockPath), (srcId)) \
  ((dta), (blockPath), (dstId), (srcId), (numEls), (u), (options), (y)) : \
  0)
# else
#  define dtaCallConvertBetweenForSrcId(dta, blockPath, dstId, srcId, numEls, u, options, y) \
    dtaCallConvertBetweenForSrcId_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaCallConvertBetweenForDstId(dta, blockPath, dstId, srcId, numEls, u, options, y) \
  (dtaGetConvertBetweenFcn((dta), (blockPath), (dstId)) != NULL ? \
  dtaGetConvertBetweenFcn((dta), (blockPath), (dstId)) \
  ((dta), (blockPath), (dstId), (srcId), (numEls), (u), (options), (y)) : \
  0)
# else
#  define dtaCallConvertBetweenForDstId(dta, blockPath, dstId, srcId, numEls, u, options, y) \
    dtaCallConvertBetweenForDstId_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaGetIsPositiveFcn(dta, blockPath, id) \
  ((dta) != NULL ? \
  (dta)->getGenericDTAUnaryFcnGW((dta)->dataTypeTable, (blockPath), (id), \
    GEN_DTA_UNARY_FCN_IS_POSITIVE) : \
  NULL)
# else
#  define dtaGetIsPositiveFcn(dta, blockPath, id) \
    dtaGetIsPositiveFcn_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaSetIsPositiveFcn(dta, blockPath, id, fcn) \
  ((dta) != NULL ? \
  (dta)->setGenericDTAUnaryFcnGW((dta)->dataTypeTable, (blockPath), (id), (fcn), \
  GEN_DTA_UNARY_FCN_IS_POSITIVE) : \
  0)
# else
#  define dtaSetIsPositiveFcn(dta, blockPath, id, fcn) \
    dtaSetIsPositiveFcn_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaCallIsPositive(dta, blockPath, id, numEls, u, options, y) \
  (dtaGetIsPositiveFcn((dta), (blockPath), (id)) != NULL ? \
  dtaGetIsPositiveFcn((dta), (blockPath), (id)) \
  ((dta), (blockPath), (id), (numEls), (u), (options), (y)) : \
  0)
# else
#  define dtaCallIsPositive(dta, blockPath, id, numEls, u, options, y) \
    dtaCallIsPositive_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaGetIsNegativeFcn(dta, blockPath, id) \
  ((dta) != NULL ? \
  (dta)->getGenericDTAUnaryFcnGW((dta)->dataTypeTable, (blockPath), (id), \
  GEN_DTA_UNARY_FCN_IS_NEGATIVE) : \
  NULL)
# else
#  define dtaGetIsNegativeFcn(dta, blockPath, id) \
    dtaGetIsNegativeFcn_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaSetIsNegativeFcn(dta, blockPath, id, fcn) \
  ((dta) != NULL ? \
  (dta)->setGenericDTAUnaryFcnGW((dta)->dataTypeTable, (blockPath), (id), (fcn), \
  GEN_DTA_UNARY_FCN_IS_NEGATIVE) : \
  0)
# else
#  define dtaSetIsNegativeFcn(dta, blockPath, id, fcn) \
    dtaSetIsNegativeFcn_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaCallIsNegative(dta, blockPath, id, numEls, u, options, y) \
  (dtaGetIsNegativeFcn((dta), (blockPath), (id)) != NULL ? \
  dtaGetIsNegativeFcn((dta), (blockPath), (id)) \
  ((dta), (blockPath), (id), (numEls), (u), (options), (y)) : \
  0)
# else
#  define dtaCallIsNegative(dta, blockPath, id, numEls, u, options, y) \
    dtaCallIsNegative_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaGetGreaterThanFcn(dta, blockPath, id) \
  ((dta) != NULL ? \
  (dta)->getGenericDTABinaryFcnGW((dta)->dataTypeTable, (blockPath), (id), \
  GEN_DTA_BINARY_FCN_GREATER_THAN) : \
  NULL)
# else
#  define dtaGetGreaterThanFcn(dta, blockPath, id) \
    dtaGetGreaterThanFcn_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaSetGreaterThanFcn(dta, blockPath, id, fcn) \
  ((dta) != NULL ? \
  (dta)->setGenericDTABinaryFcnGW((dta)->dataTypeTable, (blockPath), (id), (fcn), \
  GEN_DTA_BINARY_FCN_GREATER_THAN) : \
  0)
# else
#  define dtaSetGreaterThanFcn(dta, blockPath, id, fcn) \
    dtaSetGreaterThanFcn_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaCallGreaterThan(dta, blockPath, id, numEls, u1, u2, options, y) \
  (dtaGetGreaterThanFcn((dta), (blockPath), (id)) != NULL ? \
  dtaGetGreaterThanFcn((dta), (blockPath), (id)) \
  ((dta), (blockPath), (id), (numEls), (u1), (u2), (options), (y)) : \
  0)
# else
#  define dtaCallGreaterThan(dta, blockPath, id, numEls, u1, u2, options, y) \
    dtaCallGreaterThan_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaGetGreaterEqualFcn(dta, blockPath, id) \
  ((dta) != NULL ? \
  (dta)->getGenericDTABinaryFcnGW((dta)->dataTypeTable, (blockPath), (id), \
  GEN_DTA_BINARY_FCN_GREATER_EQUAL) : \
  NULL)
# else
#  define dtaGetGreaterEqualFcn(dta, blockPath, id) \
    dtaGetGreaterEqualFcn_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaSetGreaterEqualFcn(dta, blockPath, id, fcn) \
  ((dta) != NULL ? \
  (dta)->setGenericDTABinaryFcnGW((dta)->dataTypeTable, (blockPath), (id), (fcn), \
  GEN_DTA_BINARY_FCN_GREATER_EQUAL) : \
  0)
# else
#  define dtaSetGreaterEqualFcn(dta, blockPath, id, fcn) \
    dtaSetGreaterEqualFcn_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaCallGreaterEqual(dta, blockPath, id, numEls, u1, u2, options, y) \
  (dtaGetGreaterEqualFcn((dta), (blockPath), (id)) != NULL ? \
  dtaGetGreaterEqualFcn((dta), (blockPath), (id)) \
  ((dta), (blockPath), (id), (numEls), (u1), (u2), (options), (y)) : \
  0)
# else
#  define dtaCallGreaterEqual(dta, blockPath, id, numEls, u1, u2, options, y) \
    dtaCallGreaterEqual_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaGetDataOverflowDiagnostic(dta, blockPath, result) \
   ((dta) != NULL ? \
   (dta)->getGenericDTADiagnostic((dta)->dataTypeTable, (blockPath), \
     GEN_DTA_DATA_OVERFLOW, (result)) : 0)
# else
#  define dtaGetDataOverflowDiagnostic(dta, blockPath, result) \
    dtaGetDataOverflowDiagnostic_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaGetInt32ToFloatDiagnostic(dta, blockPath, result) \
   ((dta) != NULL ? \
   (dta)->getGenericDTADiagnostic((dta)->dataTypeTable, (blockPath), \
     GEN_DTA_INT32_TO_FLOAT, (result)) : 0)
# else
#  define dtaGetInt32ToFloatDiagnostic(dta, blockPath, result) \
    dtaGetInt32ToFloatDiagnostic_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaGetParameterOverflowDiagnostic(dta, blockPath, result) \
   ((dta) != NULL ? \
   (dta)->getGenericDTADiagnostic((dta)->dataTypeTable, (blockPath), \
     GEN_DTA_PARAMETER_OVERFLOW, (result)) : 0)
# else
#  define dtaGetParameterOverflowDiagnostic(dta, blockPath, result) \
    dtaGetParameterOverflowDiagnostic_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaGetParameterUnderflowDiagnostic(dta, blockPath, result) \
   ((dta) != NULL ? \
   (dta)->getGenericDTADiagnostic((dta)->dataTypeTable, (blockPath), \
     GEN_DTA_PARAMETER_UNDERFLOW, (result)) : 0)
# else
#  define dtaGetParameterUnderflowDiagnostic(dta, blockPath, result) \
    dtaGetParameterUnderflowDiagnostic_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaGetParameterPrecisionLossDiagnostic(dta, blockPath, result) \
   ((dta) != NULL ? \
   (dta)->getGenericDTADiagnostic((dta)->dataTypeTable, (blockPath), \
     GEN_DTA_PARAMETER_PRECISION_LOSS, (result)) : 0)
# else
#  define dtaGetParameterPrecisionLossDiagnostic(dta, blockPath, result) \
    dtaGetPrecisionLossDiagnostic_cannot_be_used_in_RTW
# endif

# if SS_SIM
#define dtaGetParameterDowncastDiagnostic(dta, blockPath, result) \
   ((dta) != NULL ? \
   (dta)->getGenericDTADiagnostic((dta)->dataTypeTable, (blockPath), \
     GEN_DTA_PARAMETER_DOWNCAST, (result)) : 0)
# else
#  define dtaGetParameterDowncastDiagnostic(dta, blockPath, result) \
    dtaGetParameterDowncastDiagnostic_cannot_be_used_in_RTW
# endif

#endif

/*
 * User-defined datatypes
 */

#if !SS_SFCN_LEVEL_1
# if SS_SIM
   typedef struct _ssRegisterTypeFromNameType_tag {
      const char *name;
      int        *dataTypeId;
   } ssRegisterTypeFromNameType;
#  define ssRegisterTypeFromExpr(S, n, id) \
    { ssRegisterTypeFromNameType _slRegisterTypeFromNameInfo; \
     _slRegisterTypeFromNameInfo.name = (n); \
     _slRegisterTypeFromNameInfo.dataTypeId = (id); \
     _ssSafelyCallGenericFcnStart(S)\
     (S,GEN_FCN_REGISTER_TYPE_FROM_EXPR,0, \
       (void *)&_slRegisterTypeFromNameInfo) \
     _ssSafelyCallGenericFcnEnd; \
    }
#  define ssRegisterTypeFromExprNoError(S, n, id) \
    { ssRegisterTypeFromNameType _slRegisterTypeFromNameInfo; \
     _slRegisterTypeFromNameInfo.name = (n); \
     _slRegisterTypeFromNameInfo.dataTypeId = (id); \
     _ssSafelyCallGenericFcnStart(S)\
     (S,GEN_FCN_REGISTER_TYPE_FROM_EXPR_NO_ERROR,0, \
       (void *)&_slRegisterTypeFromNameInfo) \
     _ssSafelyCallGenericFcnEnd; \
    }
#  define ssRegisterTypeFromParameter(S, idx, id) \
    { _ssSafelyCallGenericFcnStart(S)\
     (S,GEN_FCN_REGISTER_TYPE_FROM_PARAMETER,(idx),(id)) \
      _ssSafelyCallGenericFcnEnd; \
    }
#  define ssRegisterTypeFromNamedObject(S, n, id) \
    { ssRegisterTypeFromNameType _slRegisterTypeFromNameInfo; \
     _slRegisterTypeFromNameInfo.name = (n); \
     _slRegisterTypeFromNameInfo.dataTypeId = (id); \
     _ssSafelyCallGenericFcnStart(S)\
     (S,GEN_FCN_REGISTER_TYPE_FROM_NAMED_OBJECT,0, \
       (void *)&_slRegisterTypeFromNameInfo) \
     _ssSafelyCallGenericFcnEnd; \
    }
# else
#  define ssRegisterTypeFromExpr(S, name, id)
#  define ssRegisterTypeFromExprNoError(S, name, id)
#  define ssRegisterTypeFromNamedObject(S, name, id)
#  define ssRegisterTypeFromParameter(S, idx, id)
# endif

#endif

/*
 * mexApiInt2/MexApiReal1/MexApiReal2
 * used by the mex api (simulink.c)
 */
#define ssGetMexApiInt2(S) \
          (S)->mdlInfo->mexApiInt2                     /*   (int_T)       */
#define ssSetMexApiInt2(S,val) \
          (S)->mdlInfo->mexApiInt2 = (val)

#define ssGetMexApiReal1(S) \
          (S)->mdlInfo->mexApiReal1                       /*   (real_T)      */
#define ssSetMexApiReal1(S,val) \
          (S)->mdlInfo->mexApiReal1 = (val)               /*   (real_T)      */

#define ssGetMexApiReal2(S) \
          (S)->mdlInfo->mexApiReal2                       /*   (real_T)      */
#define ssSetMexApiReal2(S,val) \
          (S)->mdlInfo->mexApiReal2 = (val)               /*   (real_T)      */

#define ssGetMexApiVoidPtr1(S) \
          (S)->mdlInfo->mexApiVoidPtr1                    /*   (void *)      */
#define ssSetMexApiVoidPtr1(S,val) \
          (S)->mdlInfo->mexApiVoidPtr1 = (void *)(val)

/*
 * Set data alignment
 */
#define ssSetDataAlignment(S, num) \
   _ssSafelyCallGenericFcnStart(S)(S,GEN_FCN_SET_DATA_ALIGNMENT,num,NULL) \
   _ssSafelyCallGenericFcnEnd

/*---------------------------- get system level setting ---------------------*/

#include "sl_prodhwdevicetype.h"

/* Get whether net slope corrections can use division
 */
#define ssGetNetSlopeViaDivision(S, result) \
          _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_GET_NET_SLOPE_VIA_DIVISION, 0, result)\
          _ssSafelyCallGenericFcnEnd

/* Get whether use strict single or double upcasting when necessary
 */
#define ssGetSupportStrictSingle(S, result) \
          _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_GET_STRICT_SINGLE, 0, result)\
          _ssSafelyCallGenericFcnEnd

/*================================================*
 * Running simulation type                        *
 *================================================*/

#define ssGetSimType(S, result) \
          _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_GET_SIMULATIONTYPE, 0, result)\
          _ssSafelyCallGenericFcnEnd

/* get the double override setting of current system
 */
#define ssGetDataTypeOverride(S, result) \
          _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_GET_DATATYPEOVERRIDE, 0, result)\
          _ssSafelyCallGenericFcnEnd

/* get the datatype override applies to setting of current system
 */
#define ssGetDataTypeOverrideAppliesTo(S, result) \
          _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_GET_DATATYPEOVERRIDEAPPLIESTO, 0, result)\
          _ssSafelyCallGenericFcnEnd


/* The term Doubles-Override is outdated and misleading.
 * Instead, the terms Data-Type-Override and Scaled-Doubles should be used
 * as appropriate.
 * The follow definition is provided for backwards compatibility
 */
#define ssGetDblOverride(S, result) (ssGetDataTypeOverride((S), (result)))

#define ssGetMinMaxOverflowLogging(S, result) \
          _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_GET_MINMAXLOG, 0, result)\
          _ssSafelyCallGenericFcnEnd

#define ssGetMinMaxOverflowArchiveMode(S, result) \
          _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_GET_MINMAXARCHIVE, 0, result)\
          _ssSafelyCallGenericFcnEnd

#define ssGetProdHWDeviceInfo(S, result) \
          _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_GET_PRODHWDEVICEINFO, 0, result)\
          _ssSafelyCallGenericFcnEnd

/*---------------------------- S->callSys  ----------------------------------*/

#define _ssSetSFcnExportsFunctionCalls(S) \
  _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_SET_EXPORTS_FUNCTION_CALLS, \
                                  0, (void *)NULL) \
  _ssSafelyCallGenericFcnEnd

#define ssSetAcceptsFcnCallInputs(S) \
  _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_SET_ACCEPTS_FCNCALL_INPUTS, \
                                  0, (void *)NULL) \
  _ssSafelyCallGenericFcnEnd

/*
 * ssExportOutputFcn,
 * ssExportEnableFcn,
 * ssExportDisableFcn -
 *   S-functions which export function calls use this in
 *   mdlInitializeSizes to specify the custom user functions
 *   which are exported to Simulink by means of the input ports
 *   of the S-function.
 */
#if defined(SS_SFCN) && defined(S_FUNCTION_EXPORTS_FUNCTION_CALLS)

#define ssExportOutputFcn(S, pIdx, oFcn) \
  { SysOutputFcn _oFcn = (SysOutputFcn)oFcn; \
  _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_SET_EXPORTED_OUTPUT_FCN, \
                                  (pIdx), (void *)&_oFcn) \
  _ssSafelyCallGenericFcnEnd; \
  }

#define ssExportEnableFcn(S, pIdx, oFcn) \
  { SysOutputFcn _oFcn = (SysOutputFcn)oFcn; \
  _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_SET_EXPORTED_ENABLE_FCN, \
                                  (pIdx), (void *)&_oFcn) \
  _ssSafelyCallGenericFcnEnd; \
  }

#define ssExportDisableFcn(S, pIdx, oFcn) \
  { SysOutputFcn _oFcn = (SysOutputFcn)oFcn; \
  _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_SET_EXPORTED_DISABLE_FCN, \
                                  (pIdx), (void *)&_oFcn) \
  _ssSafelyCallGenericFcnEnd; \
  }

#define ssInportIsLatched(S, pIdx) \
  _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_SET_INPORT_LATCHED, \
                                  (pIdx), NULL) \
  _ssSafelyCallGenericFcnEnd

#endif


/*
 * ssSetCallSystemOutput -
 *   S-functions should use this in mdlInitializeSampleTimes to specify
 *   which output port elements of the first output port are connected
 *   to function-call subsystems. The S-function can then execute
 *   the function-call subsystems via ssCallSystemWithTID
 */
#define ssGetCallSystemOutputPtr(S) \
          (S)->callSys.outputs                            /* (int_T*)    */
#define _ssSetCallSystemOutputPtr(S,ptr) \
          (S)->callSys.outputs = (ptr)
#if !SS_SFCN
#define ssSetCallSystemOutputPtr(S,ptr) _ssSetCallSystemOutputPtr(S,ptr)
#else
#define ssSetCallSystemOutputPtr(S,ptr) \
          ssSetCallSystemOutputPtr_cannot_be_used_in_SFunctions
#endif

#define ssGetCallSystemOutput(S,element) \
          (S)->callSys.outputs[element]                   /* (int_T)     */
#define ssSetCallSystemOutput(S,element) \
          (S)->callSys.outputs[element]=((int_T)1)

/*
 * ssGetCallSystemNumFcnCallDestinations:
 *   Return number of fcn-call destinations called by S-function's
 *   first output port and elemIdx-th element
 */
/* GenericFcn implementation */
#define ssGetNumFcnCallDestinations(S, elemIdx, result)                     \
{                                                                     \
     _ssSafelyCallGenericFcnStart(S)(S,                               \
                                     GEN_FCN_GET_NUM_FCNCALL_DEST, \
                                     elemIdx,result)                  \
     _ssSafelyCallGenericFcnEnd;                                      \
 }

/* APIs that bring back return values */
#define ssGetCallSystemNumFcnCallDestinations(S, elemIdx)  \
    _ssGetCallSystemNumFcnCallDestinations(S, elemIdx)

/*
 * ssCallSystemWithTID -
 *  This is used by S-function blocks to execute a function-call subsystem
 *  which are attached to the first output port of your S-function block.
 *  For blocks with multiple output ports, all "function-call's" must
 *  be performed on the first output port.
 */
#if SS_RT
#ifdef __cplusplus
extern "C" {
#endif
    extern int_T rt_CallSys(SimStruct *S, int_T element, int_T tid);
#ifdef __cplusplus
}
#endif
# define ssCallSystemWithTid(S,element,tid)          \
    (((S)->callSys.fcns[(element)] != NULL) ?        \
     rt_CallSys((S),(element),(tid)):1)
#ifdef __cplusplus
extern "C" {
#endif
    extern int_T rt_EnableSys(SimStruct *S, int_T element, int_T tid);
#ifdef __cplusplus
}
#endif
# define ssEnableSystemWithTid(S,element,tid)                           \
    (((S)->callSys.fcns[ssGetOutputPortWidth((S),0)+(element)] != NULL || \
      (S)->callSys.fcns[2*ssGetOutputPortWidth((S),0)+(element)] != NULL) ? \
     rt_EnableSys((S),(element),(tid)):1)
#ifdef __cplusplus
extern "C" {
#endif
    extern int_T rt_DisableSys(SimStruct *S, int_T element, int_T tid);
#ifdef __cplusplus
}
#endif
# define ssDisableSystemWithTid(S,element,tid)                          \
    (((S)->callSys.fcns[3*ssGetOutputPortWidth((S),0)+(element)] != NULL) ? \
     rt_DisableSys((S),(element),(tid)):1)
#else /* #if SS_RT */
# define ssCallSystemWithTid(S,element,tid)   \
    (((S)->callSys.fcns[(element)] != NULL) ? \
     ((*(S)->callSys.fcns[(element)])         \
      ((S)->callSys.args1[(element)],                   \
       (S)->callSys.args2[(element)], (tid)) ?          \
      (ssGetErrorStatus(S) == NULL) : (0)) : (1))

#if defined(RSIM_WITH_SL_SOLVER)
# define ssEnableSystemWithTid(S,element,tid)                           \
    ((((S)->callSys.fcns[ssGetOutputPortWidth((S),0)+(element)] != NULL) ? \
      ((*(S)->callSys.fcns[ssGetOutputPortWidth((S),0)+(element)]) (    \
          (S)->callSys.args1[(element)],                                \
          (S)->callSys.args2[(element)], (tid)) ?                       \
       (ssGetErrorStatus(S) == NULL) : (0)) : (1)) &                    \
     (((S)->callSys.fcns[2*ssGetOutputPortWidth((S),0)+(element)] != NULL) ? \
      ((*(S)->callSys.fcns[2*ssGetOutputPortWidth((S),0)+(element)]) (  \
          (S)->callSys.args1[(element)],                                \
          (S)->callSys.args2[(element)], (tid)) ?                       \
       (ssGetErrorStatus(S) == NULL) : (0))  : (1)))

# define ssDisableSystemWithTid(S,element,tid)                          \
    (((S)->callSys.fcns[3*ssGetOutputPortWidth((S),0)+(element)] != NULL) ? \
     ((*(S)->callSys.fcns[3*ssGetOutputPortWidth((S),0)+(element)]) (   \
         (S)->callSys.args1[(element)],                                 \
         (S)->callSys.args2[(element)], (tid)) ?                        \
      (ssGetErrorStatus(S) == NULL) : (0))  : (1))
#else /* #if defined(RSIM_WITH_SL_SOLVER) */
# define ssEnableSystemWithTid(S,element,tid)                           \
    (((S)->callSys.fcns[ssGetOutputPortWidth((S),0)+(element)] != NULL) ? \
     ((*(S)->callSys.fcns[ssGetOutputPortWidth((S),0)+(element)]) (     \
         (S)->callSys.args1[(element)],                                 \
         (S)->callSys.args2[(element)], (tid)) ?                        \
      (ssGetErrorStatus(S) == NULL) : (0))  : (1))

# define ssDisableSystemWithTid(S,element,tid)                          \
    (((S)->callSys.fcns[2*ssGetOutputPortWidth((S),0)+(element)] != NULL) ? \
     ((*(S)->callSys.fcns[2*ssGetOutputPortWidth((S),0)+(element)]) (   \
         (S)->callSys.args1[(element)],                                 \
         (S)->callSys.args2[(element)], (tid)) ?                        \
      (ssGetErrorStatus(S) == NULL) : (0))  : (1))
#endif /* #if defined(RSIM_WITH_SL_SOLVER) */
#endif /* #if SS_RT */


/*
 * ssCallSystem -
 *  Provided for backwards compatibility. Here, tid is hardcoded is 0.
 */
#define ssCallSystem(S,element) ssCallSystemWithTid(S,element,0)

#define _ssSetCallSystemOutputArg1List(S,list) \
          (S)->callSys.args1 = (list)

#define _ssSetCallSystemOutputArg2List(S,list) \
          (S)->callSys.args2 = (list)

#define _ssSetCallSystemOutputFcnList(S,list) \
          (S)->callSys.fcns = (list)

#if SS_SL_INTERNAL || SS_RTW || SS_GENERATED_S_FUNCTION
 /*
  * The following cannot be used in S-functions
  */
# define ssGetCallSystemOutputArg1List(S) \
          (S)->callSys.args1                              /* (void**)        */
# define ssSetCallSystemOutputArg1List(S,list) \
         _ssSetCallSystemOutputArg1List(S,list)

# define ssGetCallSystemOutputArg2List(S) \
          (S)->callSys.args2                              /* (int_T*)        */
# define ssSetCallSystemOutputArg2List(S,list) \
          _ssSetCallSystemOutputArg2List(S,list)

# define ssGetCallSystemOutputFcnList(S) \
          (S)->callSys.fcns                               /* (SysOutputFcn*) */
# define ssSetCallSystemOutputFcnList(S,list) \
          _ssSetCallSystemOutputFcnList(S,list)
#else
#define ssSetCallSystemOutputArg1List(S,list) \
          ssSetCallSystemOutputArg1List_cannot_be_used_in_SFunctions
#define ssSetCallSystemOutputArg2List(S,list) \
          ssSetCallSystemOutputArg2List_cannot_be_used_in_SFunctions
#define ssSetCallSystemOutputFcnList(S,list) \
          ssSetCallSystemOutputFcnList_cannot_be_used_in_SFunctions
#endif

#if defined(RTW_GENERATED_S_FUNCTION) || SS_SL_INTERNAL
# define ssModelRefInitDataPortGroup(S) \
 {  _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_MODELREF_INIT_DATA_PORT_GROUP, 0, NULL) \
    _ssSafelyCallGenericFcnEnd; \
 }

# define ssModelRefPortGroupAddDataInputPort(S, value) \
 {  int_T val = value; \
     _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_MODELREF_PORT_GROUP_ADD_DATA_INPUT_PORT, 0, &val) \
    _ssSafelyCallGenericFcnEnd; \
 }

# define ssModelRefPortGroupAddDataOutputPort(S, value)        \
 {  int_T val = value; \
    _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_MODELREF_PORT_GROUP_ADD_DATA_OUTPUT_PORT, 0 , &val)        \
    _ssSafelyCallGenericFcnEnd; \
 }

# define ssModelRefPortGroupAddSrcPortGroup(S, value) \
 {  int_T val = value; \
     _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_MODELREF_PORT_GROUP_ADD_SRC_PORT_GROUP, 0, &val) \
    _ssSafelyCallGenericFcnEnd; \
 }

# define ssModelRefInitNewFcnCallPortGroup(S) \
 {  _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_MODELREF_INIT_NEW_FCNCALL_PORT_GROUP, 0, NULL)    \
    _ssSafelyCallGenericFcnEnd; \
 }

# define ssModelRefFcnCallPortGroupSetFcnCallInputPort(S, value) \
 {  int_T val = value; \
     _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_MODELREF_FCNCALL_PORT_GROUP_SET_FCNCALL_INPUT, 0, &val) \
    _ssSafelyCallGenericFcnEnd; \
 }

# define ssModelRefFcnCallPortGroupAddLatchedDataInputPort(S, value) \
 {  int_T val = value; \
     _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_MODELREF_FCNCALL_PORT_GROUP_ADD_LATCHED_INPUT, 0, &val) \
    _ssSafelyCallGenericFcnEnd; \
 }

# define ssModelRefFcnCallPortGroupAddDataInputPortWithMultiDsts(S, value) \
 {  int_T val = value; \
     _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_MODELREF_FCNCALL_PORT_GROUP_ADD_DATAINPUT_WITH_MULTIDSTS, 0, &val) \
    _ssSafelyCallGenericFcnEnd; \
 }

# define ssModelRefFcnCallPortGroupSetHasAsyncTaskPriority(S, value) \
 {  boolean_T val = value; \
     _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_MODELREF_FCNCALL_PORT_GROUP_SET_HAS_ASYNC_PRIORITY, 0, &val) \
    _ssSafelyCallGenericFcnEnd; \
 }

# define ssModelRefFcnCallPortGroupSetAsyncTaskPriority(S, value) \
 {  int_T val = value; \
     _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_MODELREF_FCNCALL_PORT_GROUP_SET_ASYNC_PRIORITY, 0, &val) \
    _ssSafelyCallGenericFcnEnd; \
 }

# define ssModelRefFcnCallPortGroupSetAsyncTid(S, value) \
 {  int_T val = value; \
     _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_MODELREF_FCNCALL_PORT_GROUP_SET_ASYNC_TID, 0, &val) \
    _ssSafelyCallGenericFcnEnd; \
 }

# define ssModelRefFcnCallPortGroupSetIsAsync(S, value) \
 {  boolean_T val = value; \
     _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_MODELREF_FCNCALL_PORT_GROUP_SET_IS_ASYNC, 0, &val) \
    _ssSafelyCallGenericFcnEnd; \
 }

# define ssSetNumAsyncTs(S, numAsyncTs) \
 { \
     _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_MODELREF_SET_NUM_ASYNC_TS, (numAsyncTs), NULL) \
     _ssSafelyCallGenericFcnEnd; \
 }

# define ssSetUnionTsContainedTs(S, unionTs, containedTs) \
 { \
     int tmpContainedTs = (containedTs); \
     _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_MODELREF_SET_UNION_TS_CONTAINED_TS, (unionTs), &tmpContainedTs) \
     _ssSafelyCallGenericFcnEnd; \
 }

# define ssModelRefMakeRootOutportFcnCall(S, port, model, type)      \
 { \
    _ssSafelyCallGenericFcnStart(S)((S), (type), (port), (model))  \
    _ssSafelyCallGenericFcnEnd; \
 }

# define ssModelRefMakeRootOutportFcnCallOutput(S, port, model) \
    ssModelRefMakeRootOutportFcnCall((S), (port), (model), GEN_FCN_MODELREF_MAKE_ROOT_OUTPORT_FCNCALL_OUTPUT)

# define ssModelRefMakeRootOutportFcnCallEnable(S, port, model) \
    ssModelRefMakeRootOutportFcnCall((S), (port), (model), GEN_FCN_MODELREF_MAKE_ROOT_OUTPORT_FCNCALL_ENABLE)

# define ssModelRefMakeRootOutportFcnCallDisable(S, port, model) \
    ssModelRefMakeRootOutportFcnCall((S), (port), (model), GEN_FCN_MODELREF_MAKE_ROOT_OUTPORT_FCNCALL_DISABLE)

# define ssModelRefFcnCallPortGroupSetHasEnableMethod(S, value) \
 {  boolean_T val = value; \
     _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_MODELREF_FCNCALL_PORT_GROUP_SET_HAS_ENABLE, 0, &val) \
    _ssSafelyCallGenericFcnEnd; \
 }

# define ssModelRefFcnCallPortGroupSetHasDisableMethod(S, value) \
 {  boolean_T val = value; \
     _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_MODELREF_FCNCALL_PORT_GROUP_SET_HAS_DISABLE, 0, &val) \
    _ssSafelyCallGenericFcnEnd; \
 }

# define ssModelRefFcnCallPortGroupSetNeedAbsoluteTime(S, value) \
 {  boolean_T val = value; \
     _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_MODELREF_FCNCALL_PORT_GROUP_SET_NEED_ABS_TIME, 0, &val) \
    _ssSafelyCallGenericFcnEnd; \
 }

# define ssModelRefInputPortAddFcnCallInputArg(S, pIdx, value)        \
 { \
    _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_MODELREF_INPUT_ADD_FCNCALL_IN_ARG, (pIdx), (value)) \
    _ssSafelyCallGenericFcnEnd; \
 }

# define ssModelRefInputPortAddFcnCallOutputArg(S, pIdx, value)       \
 { \
    _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_MODELREF_INPUT_ADD_FCNCALL_OUT_ARG, (pIdx), (value)) \
    _ssSafelyCallGenericFcnEnd; \
 }

# define ssModelRefInputPortAddFcnCallStatusArg(S, value)       \
 { \
 _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_MODELREF_INPUT_ADD_FCNCALL_STATUS_ARG, (pIdx), (value)) \
    _ssSafelyCallGenericFcnEnd; \
 }

# define ssModelRefOutputPortAddFcnCallInputArg(S, pIdx, value)   \
 { \
    _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_MODELREF_OUTPUT_ADD_FCNCALL_IN_ARG, (pIdx), (value)) \
    _ssSafelyCallGenericFcnEnd; \
 }

# define ssModelRefOutputPortAddFcnCallOutputArg(S, pIdx, value)  \
 { \
    _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_MODELREF_OUTPUT_ADD_FCNCALL_OUT_ARG, (pIdx), (value)) \
    _ssSafelyCallGenericFcnEnd; \
 }

# define ssModelRefOutputPortAddFcnCallStatusArg(S, value)  \
 { \
     _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_MODELREF_OUTPUT_ADD_FCNCALL_STATUS_ARG, (pIdx), (value)) \
    _ssSafelyCallGenericFcnEnd; \
 }

#endif

#define ssGetBlkSupportConcurrentTasks(S,result) \
    {  _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_GET_BLK_SUPPORT_CONCURRENT_TASKS, 0, (result)) \
            _ssSafelyCallGenericFcnEnd;                                 \
    }

#define ssSetBlkSupportConcurrentTasks(S, value)                                                                        \
    {  int_T val = value; \
       _ssSafelyCallGenericFcnStart(S)((S), GEN_FCN_SET_BLK_SUPPORT_CONCURRENT_TASKS, 0, (&val)) \
            _ssSafelyCallGenericFcnEnd;                                 \
    }
#if SS_SIM
#define ssGetConcurrentTasks(S)      \
    ((S)->sizes.flags.isConcurrentTasks == 1U)

#define ssSetConcurrentTasks(S,boolVal)                        \
    ((S)->sizes.flags.isConcurrentTasks = (boolVal) ? 1U : 0U)
#else
#define ssGetConcurrentTasks(S)   ssGetConcurrentTasks_cannot_be_used_in_RTW

#define ssSetConcurrentTasks(S)   ssSetConcurrentTasks_cannot_be_used_in_RTW

#endif

/*---------------------------- S->regDataType  ------------------------------*/

#if !SS_SFCN
/*
 * The following cannot be used in S-functions
 */
# define ssGetDataTypeFcnsArg1(S) \
          (S)->regDataType.arg1                           /* (void*)        */
# define ssSetDataTypeFcnsArg1(S,ptr1) \
          (S)->regDataType.arg1 = ((void *)(ptr1))

# define ssGetRegisterDataTypeFcn(S) \
          (S)->regDataType.registerFcn                 /* (RegisterDataType) */
# define ssSetRegisterDataTypeFcn(S,val) \
          (S)->regDataType.registerFcn = (val)

# define ssGetDataTypeSizeFcn(S) \
          (S)->regDataType.getSizeFcn                  /* (GetDataTypeSize) */
# define ssSetGetDataTypeSizeFcn(S,val) \
          (S)->regDataType.getSizeFcn = (val)

# define ssGetSetDataTypeSizeFcn(S) \
          (S)->regDataType.setSizeFcn                  /* (SetDataTypeSize) */
# define ssSetDataTypeSizeFcn(S,val) \
          (S)->regDataType.setSizeFcn = (val)

# define ssGetDataTypeZeroFcn(S) \
          (S)->regDataType.getZeroFcn                  /* (GetDataTypeZero) */
# define ssSetGetDataTypeZeroFcn(S,val) \
          (S)->regDataType.getZeroFcn = (val)

# define ssGetSetDataTypeZeroFcn(S) \
          (S)->regDataType.setZeroFcn                  /* (SetDataTypeZero) */
# define ssSetDataTypeZeroFcn(S,val) \
          (S)->regDataType.setZeroFcn = (val)

# define ssGetDataTypeNameFcn(S) \
          (S)->regDataType.getNameFcn                  /* (GetDataTypeName) */
# define ssSetGetDataTypeNameFcn(S,val) \
          (S)->regDataType.getNameFcn = (val)

# define ssGetDataTypeIdFcn(S) \
          (S)->regDataType.getIdFcn                    /* (GetDataTypeId) */
# define ssSetGetDataTypeIdFcn(S,val) \
          (S)->regDataType.getIdFcn = (val)

# define ssGetSetNumDWorkFcn(S) \
          (S)->regDataType.setNumDWorkFcn              /* (SetNumDWork)     */
# define ssSetNumDWorkFcn(S,val) \
          (S)->regDataType.setNumDWorkFcn = (val)

# define ssStrictBooleanCheckEnabledFcn(S) \
          (S)->states.modelMethods2->strictBooleanCheckEnabledFcn /* (StrictBooleanCheckEnabledFcn) */
# define ssSetStrictBooleanCheckEnabledFcn(S,val) \
          (S)->states.modelMethods2->strictBooleanCheckEnabledFcn = (val)

# define ssSetConvertBuiltInDTypeFcn(S,fcn) \
          (S)->states.modelMethods2->ConvertBuiltInDType = (fcn)

#endif

#if !SS_SFCN_LEVEL_1

#if SS_SIM
#define ssRegisterDataType(S,name) \
         (((S)->regDataType.registerFcn != NULL) ? \
         (*(S)->regDataType.registerFcn)((S)->regDataType.arg1,(name)): \
         (INVALID_DTYPE_ID))
#else
# define ssRegisterDataType(S,name) ssRegisterDataType_cannot_be_used_in_RTW
#endif

#if SS_SIM
#define ssGetNumDataTypes(S) (dtaGetNumDataTypes(ssGetDataTypeAccess(S)))
#else
# define ssGetNumDataTypes(S) ssGetNumDataTypes_cannot_be_used_in_RTW
#endif

#if SS_SIM
#define ssSetDataTypeSize(S,id,size) \
         (((S)->regDataType.setSizeFcn != NULL) ? \
         (*(S)->regDataType.setSizeFcn)((S)->regDataType.arg1,(id),(size)): \
          (0))
#else
# define ssSetDataTypeSize(S,id,size) ssSetDataTypeSize_cannot_be_used_in_RTW
#endif

#if SS_SIM
#define ssGetDataTypeSize(S,id) \
         (((S)->regDataType.getSizeFcn != NULL) ? \
         (*(S)->regDataType.getSizeFcn)((S)->regDataType.arg1,(id)): \
         (INVALID_DTYPE_SIZE))
#else
# define ssGetDataTypeSize(S,id) ssGetDataTypeSize_cannot_be_used_in_RTW
#endif

#if SS_SIM
#define ssSetDataTypeZero(S,id, zero) \
         (((S)->regDataType.setZeroFcn != NULL) ? \
         (*(S)->regDataType.setZeroFcn)((S)->regDataType.arg1,(id),(zero)): \
         (0))
#else
# define ssSetDataTypeZero(S,id, zero) ssSetDataTypeZero_cannot_be_used_in_RTW
#endif

#if SS_SIM
#define ssGetDataTypeZero(S,id) \
         (((S)->regDataType.getZeroFcn != NULL) ? \
         (*(S)->regDataType.getZeroFcn)((S)->regDataType.arg1,(id)): \
         (NULL))
#else
# define ssGetDataTypeZero(S,id) ssGetDataTypeZero_cannot_be_used_in_RTW
#endif

#if SS_SIM
#define ssGetDataTypeProperties(S, id) \
  (dtaGetDataTypeProperties(ssGetDataTypeAccess(S), (S)->path, (id)))
#else
# define ssGetDataTypeProperties(S, id) ssGetDataTypeProperties_cannot_be_used_in_RTW
#endif

#if SS_SIM
#define ssSetDataTypeProperties(S, id, properties) \
  dtaSetDataTypeProperties(ssGetDataTypeAccess(S), (S)->path, (id), (properties))
#else
# define ssSetDataTypeProperties(S, id, properties) \
    ssSetDataTypeProperties_cannot_be_used_in_RTW
#endif

#if SS_SIM
#define ssGetDataTypePropertiesSize(S, id) \
  (dtaGetDataTypePropertiesSize(ssGetDataTypeAccess(S), (S)->path, (id)))
#else
# define ssGetDataTypePropertiesSize(S, id) \
    ssGetDataTypePropertiesSize_cannot_be_used_in_RTW
#endif

#if SS_SIM
#define ssSetDataTypePropertiesSize(S, id, size) \
  dtaSetDataTypePropertiesSize(ssGetDataTypeAccess(S), (S)->path, (id), (size))
#else
# define ssSetDataTypePropertiesSize(S, id, size) \
    ssSetDataTypePropertiesSize_cannot_be_used_in_RTW
#endif

#if SS_SIM
#define ssStrictBooleanCheckEnabled(S) \
        (((S)->states.modelMethods2->strictBooleanCheckEnabledFcn != NULL) ? \
        (*(S)->states.modelMethods2->strictBooleanCheckEnabledFcn)((S)->regDataType.arg1): \
         (false))
#else
# define ssStrictBooleanCheckEnabled(S) \
    ssStrictBooleanCheckEnabled_cannot_be_used_in_RTW
#endif

/*  ssCallConvertBuiltInDType
 *  Options:
 *      satOnIntOverFlow:
 *          If true, saturate.  If false, the conversion is undefined when
 *          values are out of range (platform dependent conversion).
 *      doDiff:
 *          If true, compare original values and converted values and return
 *          true if they are different (e.g., value was saturated, etc).  If
 *          doDiff is false, this function always returns true.
 */
#if SS_SIM
#define ssCallConvertBuiltInDType(S,nVals,satOnIntOverFlow,doDiff,dt1,v1,dt2,v2)  \
    (S)->states.modelMethods2->ConvertBuiltInDType(nVals,satOnIntOverFlow,doDiff, \
        dt1,v1,dt2,v2)
#else
# define ssCallConvertBuiltInDType(S,nVals,satOnIntOverFlow,doDiff,dt1,v1,dt2,v2)  \
    ssCallConvertBuiltInDType_cannot_be_used_in_RTW
#endif

#if SS_SIM
#define ssGetDataTypeName(S,id) \
         (((S)->regDataType.getNameFcn != NULL) ? \
         (*(S)->regDataType.getNameFcn)((S)->regDataType.arg1,(id)): \
         (NULL))
#else
# define ssGetDataTypeName(S,id) ssGetDataTypeName_cannot_be_used_in_RTW
#endif

#if SS_SIM
#define ssGetDataTypeId(S,name) \
         (((S)->regDataType.getIdFcn != NULL) ? \
         (*(S)->regDataType.getIdFcn)((S)->regDataType.arg1,(name)): \
         (INVALID_DTYPE_ID))
#else
# define ssGetDataTypeId(S,name) ssGetDataTypeId_cannot_be_used_in_RTW
#endif

#if SS_SFCN
#  if SS_SIM
#    define ssSetNumDWork(S,num) \
       (((S)->regDataType.setNumDWorkFcn != NULL) ? \
        (*(S)->regDataType.setNumDWorkFcn)((S),(num)) : (0))
#  else /* RTW non-TLC S-function */
#    define ssSetNumDWork(S,num) ((_ssSetNumDWork(S,num)) >= -1)
#  endif
#else /* Simulink or RTW run-time interface code */
#  define ssSetNumDWork(S,num) ((_ssSetNumDWork(S,num)) >= -1)
#endif


#if SS_SIM
#define ssGetDataTypeStorageId(S, id) \
  (dtaGetDataTypeStorageId(ssGetDataTypeAccess(S), (S)->path, (id)))
#else
# define ssGetDataTypeStorageId(S, id) ssGetDataTypeStorageId_cannot_be_used_in_RTW
#endif

#if SS_SIM
#define ssSetDataTypeStorageId(S, id, storageId) \
  dtaSetDataTypeStorageId(ssGetDataTypeAccess(S), (S)->path, (id), (storageId))
#else
# define ssSetDataTypeStorageId(S, id, storageId) \
    ssSetDataTypeStorageId_cannot_be_used_in_RTW
#endif

#if SS_SIM
#define ssGetDataTypeIdAliasedTo(S, id) \
  (dtaGetDataTypeIdAliasedTo(ssGetDataTypeAccess(S), (S)->path, (id)))
#else
# define ssGetDataTypeIdAliasedTo(S, id) ssGetDataTypeIdAliasedTo_cannot_be_used_in_RTW
#endif

#if SS_SIM
#define ssSetDataTypeIdAliasedTo(S, id, idAliasedTo) \
  dtaSetDataTypeIdAliasedTo(ssGetDataTypeAccess(S), (S)->path, (id), (idAliasedTo))
#else
# define ssSetDataTypeIdAliasedTo(S, id, idAliasedTo) \
    ssSetDataTypeIdAliasedTo_cannot_be_used_in_RTW
#endif

#if SS_SIM
#define ssGetDataTypeIdAliasedThruTo(S, id) \
  (dtaGetDataTypeIdAliasedThruTo(ssGetDataTypeAccess(S), (S)->path, (id)))
#else
# define ssGetDataTypeIdAliasedThruTo(S, id) ssGetDataTypeIdAliasedThruTo_cannot_be_used_in_RTW
#endif

#if SS_SIM
#define ssGetConvertBetweenFcn(S, id) \
  (dtaGetConvertBetweenFcn(ssGetDataTypeAccess(S), (S)->path, (id)))
#else
# define ssGetConvertBetweenFcn(S, id) ssGetConvertBetweenFcn_cannot_be_used_in_RTW
#endif

#if SS_SIM
#define ssSetConvertBetweenFcn(S, id, fcn) \
  dtaSetConvertBetweenFcn(ssGetDataTypeAccess(S), (S)->path, (id), (fcn))
#else
# define ssSetConvertBetweenFcn(S, id, fcn) ssSetConvertBetweenFcn_cannot_be_used_in_RTW
#endif

#if SS_SIM
#define ssCallConvertBetweenForSrcId(S, dstId, srcId, numEls, u, options, y) \
  (ssGetConvertBetweenFcn((S), (srcId)) != NULL ? \
  ssGetConvertBetweenFcn((S), (srcId)) \
  (ssGetDataTypeAccess(S), (S)->path, (dstId), (srcId), (numEls), (u), (options), (y)) : \
  0)
#else
# define ssCallConvertBetweenForSrcId(S, dstId, srcId, numEls, u, options, y) \
    ssCallConvertBetweenForSrcId_cannot_be_used_in_RTW
#endif

#if SS_SIM
#define ssCallConvertBetweenForDstId(S, dstId, srcId, numEls, u, options, y) \
  (ssGetConvertBetweenFcn((S), (dstId)) != NULL ? \
  ssGetConvertBetweenFcn((S), (dstId)) \
  (ssGetDataTypeAccess(S), (S)->path, (dstId), (srcId), (numEls), (u), (options), (y)) : \
  0)
#else
# define ssCallConvertBetweenForDstId(S, dstId, srcId, numEls, u, options, y) \
    ssCallConvertBetweenForDstId_cannot_be_used_in_RTW
#endif


#if SS_SIM
#define ssGetIsPositiveFcn(S, id) \
  (dtaGetIsPositiveFcn(ssGetDataTypeAccess(S), (S)->path, (id)))
#else
# define ssGetIsPositiveFcn(S, id) ssGetIsPositiveFcn_cannot_be_used_in_RTW
#endif

#if SS_SIM
#define ssSetIsPositiveFcn(S, id, fcn) \
  dtaSetIsPositiveFcn(ssGetDataTypeAccess(S), (S)->path, (id), (fcn))
#else
# define ssSetIsPositiveFcn(S, id, fcn) ssSetIsPositiveFcn_cannot_be_used_in_RTW
#endif

#if SS_SIM
#define ssCallIsPositive(S, id, numEls, u, options, y) \
  (ssGetIsPositiveFcn((S), (id)) != NULL ? \
  ssGetIsPositiveFcn((S), (id)) \
  (ssGetDataTypeAccess(S), (S)->path, (id), (numEls), (u), (options), (y)) : \
  0)
#else
# define ssCallIsPositive(S, id, numEls, u, options, y) \
    ssCallIsPositive_cannot_be_used_in_RTW
#endif


#if SS_SIM
#define ssGetIsNegativeFcn(S, id) \
  (dtaGetIsNegativeFcn(ssGetDataTypeAccess(S), (S)->path, (id)))
#else
# define ssGetIsNegativeFcn(S, id) ssGetIsNegativeFcn_cannot_be_used_in_RTW
#endif

#if SS_SIM
#define ssSetIsNegativeFcn(S, id, fcn) \
  dtaSetIsNegativeFcn(ssGetDataTypeAccess(S), (S)->path, (id), (fcn))
#else
# define ssSetIsNegativeFcn(S, id, fcn) ssSetIsNegativeFcn_cannot_be_used_in_RTW
#endif

#if SS_SIM
#define ssCallIsNegative(S, id, numEls, u, options, y) \
  (ssGetIsNegativeFcn((S), (id)) != NULL ? \
  ssGetIsNegativeFcn((S), (id)) \
  (ssGetDataTypeAccess(S), (S)->path, (id), (numEls), (u), (options), (y)) : \
  0)
#else
# define ssCallIsNegative(S, id, numEls, u, options, y) \
    ssCallIsNegative_cannot_be_used_in_RTW
#endif


#if SS_SIM
#define ssGetGreaterThanFcn(S, id) \
  (dtaGetGreaterThanFcn(ssGetDataTypeAccess(S), (S)->path, (id)))
#else
# define ssGetGreaterThanFcn(S, id) ssGetGreaterThanFcn_cannot_be_used_in_RTW
#endif

#if SS_SIM
#define ssSetGreaterThanFcn(S, id, fcn) \
  dtaSetGreaterThanFcn(ssGetDataTypeAccess(S), (S)->path, (id), (fcn))
#else
# define ssSetGreaterThanFcn(S, id, fcn) ssSetGreaterThanFcn_cannot_be_used_in_RTW
#endif

#if SS_SIM
#define ssCallGreaterThan(S, id, numEls, u1, u2, options, y) \
  (ssGetGreaterThanFcn((S), (id)) != NULL ? \
  ssGetGreaterThanFcn((S), (id)) \
  (ssGetDataTypeAccess(S), (S)->path, (id), (numEls), (u1), (u2), (options), (y)) : \
  0)
#else
# define ssCallGreaterThan(S, id, numEls, u1, u2, options, y) \
    ssCallGreaterThan_cannot_be_used_in_RTW
#endif


#if SS_SIM
#define ssGetGreaterEqualFcn(S, id) \
  (dtaGetGreaterEqualFcn(ssGetDataTypeAccess(S), (S)->path, (id)))
#else
# define ssGetGreaterEqualFcn(S, id) ssGetGreaterEqualFcn_cannot_be_used_in_RTW
#endif

#if SS_SIM
#define ssSetGreaterEqualFcn(S, id, fcn) \
  dtaSetGreaterEqualFcn(ssGetDataTypeAccess(S), (S)->path, (id), (fcn))
#else
# define ssSetGreaterEqualFcn(S, id, fcn) ssSetGreaterEqualFcn_cannot_be_used_in_RTW
#endif

#if SS_SIM
#define ssCallGreaterEqual(S, id, numEls, u1, u2, options, y) \
  (ssGetGreaterEqualFcn((S), (id)) != NULL ? \
  ssGetGreaterEqualFcn((S), (id)) \
  (ssGetDataTypeAccess(S), (S)->path, (id), (numEls), (u1), (u2), (options), (y)) : \
  0)
#else
# define ssCallGreaterEqual(S, id, numEls, u1, u2, options, y) \
    ssCallGreaterEqual_cannot_be_used_in_RTW
#endif

#endif /* NOT level 1 S-function */

/*-------------------------------- S->stInfo --------------------------------*/
#define ssGetSampleTimePtr(S) \
          (S)->stInfo.sampleTimes                         /*   (time_T *)    */
#define ssSetSampleTimePtr(S,ptr) \
          (S)->stInfo.sampleTimes = (ptr)

#define ssGetSampleTime(S,sti) \
          (S)->stInfo.sampleTimes[sti]                    /*   (time_T)      */
#define ssSetSampleTime(S,sti,t) \
          (S)->stInfo.sampleTimes[sti] = (t)

#define ssGetOffsetTimePtr(S) \
          (S)->stInfo.offsetTimes                         /*   (time_T *)    */
#define ssSetOffsetTimePtr(S,ptr) \
          (S)->stInfo.offsetTimes = (ptr)

#define ssGetOffsetTime(S,sti) \
          (S)->stInfo.offsetTimes[sti]                    /*   (time_T)      */
#define ssSetOffsetTime(S,sti,t) \
          (S)->stInfo.offsetTimes[sti] = (t)

#define ssGetTNext(S) \
          (S)->stInfo.tNext                               /*   (time_T)      */
#define ssSetTNext(S,tnext) \
          (S)->stInfo.tNext = (tnext)

/*-------------------- For Variable Sample Time Unique ID -------------------*/
#if defined(RTW_GENERATED_S_FUNCTION)
#define ssSetVariableSampleTimeUID(S, sti, val)                          \
     _ssSafelyCallGenericFcnStart(S)(S,GEN_FCN_SET_VARIABLE_SAMPLE_TIME_UID, sti, val)\
     _ssSafelyCallGenericFcnEnd
#endif

/* Only the S-Functions need to call the ssSupportVarTsInMdlRef*/
# if (SS_SL_INTERNAL || SS_SFCN_FOR_SIM) && defined(ssGetOwnerBlock)
#define ssSupportVarTsInMdlRef(S, flag)  \
{ if (ssGetOwnerBlock(S) != NULL) {      \
          boolean_T val = flag;          \
          _ssSafelyCallGenericFcnStart(S)(S,GEN_FCN_SET_VARTS_MDLREF_SUPPORT, val, NULL)\
          _ssSafelyCallGenericFcnEnd;    \
    } \
}
#else
#define ssSupportVarTsInMdlRef(S, flag)
#endif

/* The following macro, ssSetTimeOfNextVarHit, will not work in non-inlined
 * S-functions in rapid accelerator or rsim. When using this advanced
 * and undocumented feature, TLC will be required in order to support
 * Rapid Accelerator simulation mode or Simulink Coder code generation
 * (rsim target).
 */
#if SS_SL_INTERNAL || SS_SFCN_FOR_SIM
#if defined(RTW_GENERATED_S_FUNCTION)
#define ssSetTimeOfNextVarHit(S,stIndex,tNext) \
    { _ssSetVarNextHitTime(ssGetRootSS(S),(int)(ssGetOffsetTime(ssGetRootSS(S),stIndex)),tNext); \
             ssSetTNext(S,tNext);}
#else
#define ssSetTimeOfNextVarHit(S,stIndex,tNext) \
    { _ssSetVarNextHitTime(ssGetRootSS(S),(int)(ssGetOffsetTime(ssGetRootSS(S), \
             ssGetSampleTimeTaskID(S, stIndex))),tNext); \
             ssSetTNext(S,tNext);}
#endif
#endif

#define _ssSetSampleTimeTaskIDPtr(S,tids) \
          (S)->stInfo.sampleTimeTaskIDs = (tids)

#define ssIsTIDInStInfo(S,tid) \
        (((tid) >= 0) && \
         ((tid) < (ssGetParentSS(S) ? \
                   ssGetNumSampleTimes(ssGetParentSS(S)) : \
                   ssGetNumSampleTimes(S))) && \
         (ssGetSampleTimeTaskID(S,tid) < ssGetNumRootSampleTimes(S)))

#if !SS_SFCN || SS_GENERATED_S_FUNCTION || defined(USE_RTMODEL)
/*
 * The following are not for use in S-functions
 */
# define ssGetTNextTid(S) \
          (S)->stInfo.tNextTid                            /*   (int_T)   */
# define ssSetTNextTid(S,setting) \
          (S)->stInfo.tNextTid = (setting)
# define ssGetSampleTimeTaskIDPtr(S) \
          (S)->stInfo.sampleTimeTaskIDs                   /*   (int_T *)     */
# define ssSetSampleTimeTaskIDPtr(S,tids) \
          _ssSetSampleTimeTaskIDPtr(S,tids)
#else
# define ssSetSampleTimeTaskIDPtr(S,tids)\
          ssSetSampleTimeTaskIDPtr_cannot_be_used_in_SFunctions
#endif

#if SS_SL_INTERNAL
#  define ssGetSampleTimeTaskID(S,sti) \
            (S)->stInfo.sampleTimeTaskIDs[sti]         /*   (int_T)       */
#elif TID_EQUALS_SAMPLE_TIME_INDEX
#  define ssGetSampleTimeTaskID(S,sti) (sti)           /*   (int_T)       */
#else
#    define ssGetSampleTimeTaskID(S, sti) \
            (S)->stInfo.sampleTimeTaskIDs[sti]         /*   (int_T)       */
#endif

#define _ssSetSampleTimeTaskID(S,sti,tid) \
          (S)->stInfo.sampleTimeTaskIDs[sti] = (tid)
#if !SS_SFCN
#define ssSetSampleTimeTaskID(S,sti,tid) _ssSetSampleTimeTaskID(S,sti,tid)
#else
#define ssSetSampleTimeTaskID(S,sti,tid) \
          ssSetSampleTimeTaskID_cannot_be_used_in_SFunctions
#endif

/*--------------------------- S->modelMethods.sFcn --------------------------*/
/*
 * Macros are used to call an S-function block methods. These should not
 * be used by an S-function directly.
 */
#define ssSetmdlInitializeSizes(S,initSizes) \
         (S)->modelMethods.sFcn.mdlInitializeSizes = (initSizes)
#define sfcnInitializeSizes(S) \
         (*(S)->modelMethods.sFcn.mdlInitializeSizes)(S)
#if SS_SL_INTERNAL || SS_SFCN_FOR_SIM
# define ssGetmdlInitializePropagationPass(S) \
    ((S)->states.modelMethods2)->mdlInitializePropagationPass
# define ssSetmdlInitializePropagationPass(S,mdlInitializePropagationPass) \
{\
    ((S)->states.modelMethods2)->mdlInitializePropagationPass =        \
        (mdlInitializePropagationPass);\
     _ssSetSfcnHasMdlDimensionsFcn(S,1);\
}
# define sfcnInitializePropagationPass(S, passType) \
    (*((S)->states.modelMethods2)->mdlInitializePropagationPass)(S, passType)


# define ssGetmdlGetInputPortWidthLevel1(S) \
         (S)->modelMethods.sFcn.mdlGetInputPortWidthLevel1
# define ssSetmdlGetInputPortWidthLevel1(S,getInputPortWidth) \
         (S)->modelMethods.sFcn.mdlGetInputPortWidthLevel1 =(getInputPortWidth)
# define sfcnGetInputPortWidthLevel1(S, outputPortWidth) \
         (*(S)->modelMethods.sFcn.mdlGetInputPortWidthLevel1)(S, \
            outputPortWidth)

# define ssGetmdlGetOutputPortWidthLevel1(S) \
         (S)->modelMethods.sFcn.mdlGetOutputPortWidthLevel1
# define ssSetmdlGetOutputPortWidthLevel1(S,getOutputPortWidth) \
         (S)->modelMethods.sFcn.mdlGetOutputPortWidthLevel1 = \
            (getOutputPortWidth)
# define sfcnGetOutputPortWidthLevel1(S, inputPortWidth) \
         (*(S)->modelMethods.sFcn.mdlGetOutputPortWidthLevel1)(S, \
            inputPortWidth)

# define ssGetmdlSetInputPortWidth(S) \
  ((ssGetSfcnHasMdlDimensionsFcn(S))? NULL: \
    ((S)->modelMethods.sFcn.mdlSetInputPortDimensions.mdlSetInputPortWidth))

# define ssSetmdlSetInputPortWidth(S,setInputPortWidth) \
{\
     (S)->modelMethods.sFcn.mdlSetInputPortDimensions.mdlSetInputPortWidth = \
         (setInputPortWidth);\
     _ssSetSfcnHasMdlDimensionsFcn(S,0);\
}

# define sfcnSetInputPortWidth(S, portIdx, width) \
     (*(S)->modelMethods.sFcn.mdlSetInputPortDimensions.mdlSetInputPortWidth) \
      (S, portIdx, width)

# define ssGetmdlSetOutputPortWidth(S) \
     ((ssGetSfcnHasMdlDimensionsFcn(S))? NULL: \
       (S)->modelMethods.sFcn.mdlSetOutputPortDimensions.mdlSetOutputPortWidth)

# define ssSetmdlSetOutputPortWidth(S,setOutputPortWidth) \
{\
     (S)->modelMethods.sFcn.mdlSetOutputPortDimensions.mdlSetOutputPortWidth = \
          (setOutputPortWidth);\
     _ssSetSfcnHasMdlDimensionsFcn(S,0);\
}

# define sfcnSetOutputPortWidth(S, portIdx, width) \
    (*(S)->modelMethods.sFcn.mdlSetOutputPortDimensions.mdlSetOutputPortWidth)\
    (S, portIdx, width)

# define ssGetmdlSetInputPortDimensions(S) \
    ((ssGetSfcnHasMdlDimensionsFcn(S))? \
     ((S)->modelMethods.sFcn.mdlSetInputPortDimensions.mdlSetInputPortDims) : \
      NULL)

# define ssSetmdlSetInputPortDimensions(S,setInputPortDimensions) \
{\
     (S)->modelMethods.sFcn.mdlSetInputPortDimensions.mdlSetInputPortDims = \
        (setInputPortDimensions);\
     _ssSetSfcnHasMdlDimensionsFcn(S,1);\
}
# define sfcnSetInputPortDimensionInfo(S, portIdx, dimsInfo) \
         (*(S)->modelMethods.sFcn.mdlSetInputPortDimensions.mdlSetInputPortDims)(S, portIdx, dimsInfo)

# define ssGetmdlSetOutputPortDimensions(S) \
   ((ssGetSfcnHasMdlDimensionsFcn(S))? \
     ((S)->modelMethods.sFcn.mdlSetOutputPortDimensions.mdlSetOutputPortDims): \
     NULL)

# define ssSetmdlSetOutputPortDimensions(S,setOutputPortDimensions) \
{\
     (S)->modelMethods.sFcn.mdlSetOutputPortDimensions.mdlSetOutputPortDims = \
        (setOutputPortDimensions);\
     _ssSetSfcnHasMdlDimensionsFcn(S,1);\
}

# define sfcnSetOutputPortDimensionInfo(S, portIdx, dimsInfo) \
         (*(S)->modelMethods.sFcn.mdlSetOutputPortDimensions.mdlSetOutputPortDims)(S, portIdx, dimsInfo)

# define ssGetmdlSetDefaultPortDimensions(S) \
    ((S)->states.modelMethods2)->mdlSetDefaultPortDimensions
# define ssSetmdlSetDefaultPortDimensions(S,setDefaultPortDimensions) \
    ((S)->states.modelMethods2)->mdlSetDefaultPortDimensions =        \
                                             setDefaultPortDimensions
# define sfcnSetDefaultPortDimensionInfo(S) \
    (*((S)->states.modelMethods2)->mdlSetDefaultPortDimensions)(S)

# define ssGetmdlSetInputPortDataType(S) \
         (S)->modelMethods.sFcn.mdlSetInputPortDataType
# define ssSetmdlSetInputPortDataType(S,setInputPortDataType) \
         (S)->modelMethods.sFcn.mdlSetInputPortDataType = \
            (setInputPortDataType)
# define sfcnSetInputPortDataType(S, portIdx, inputPortDataType) \
         (*(S)->modelMethods.sFcn.mdlSetInputPortDataType)(S,portIdx, \
           inputPortDataType)

# define ssGetmdlSetOutputPortDataType(S) \
         (S)->modelMethods.sFcn.mdlSetOutputPortDataType
# define ssSetmdlSetOutputPortDataType(S,setOutputPortDataType) \
         (S)->modelMethods.sFcn.mdlSetOutputPortDataType = \
           (setOutputPortDataType)
# define sfcnSetOutputPortDataType(S, portIdx, outputPortDataType) \
         (*(S)->modelMethods.sFcn.mdlSetOutputPortDataType)(S, \
           portIdx, outputPortDataType)

# define ssGetmdlSetDefaultPortDataTypes(S) \
    ((S)->states.modelMethods2)->mdlSetDefaultPortDataTypes
# define ssSetmdlSetDefaultPortDataTypes(S,setDefaultPortDataTypes) \
    ((S)->states.modelMethods2)->mdlSetDefaultPortDataTypes =        \
                                             setDefaultPortDataTypes
# define sfcnSetDefaultPortDataTypes(S) \
    (*((S)->states.modelMethods2)->mdlSetDefaultPortDataTypes)(S)

# define ssGetmdlSetInputPortComplexSignal(S) \
         (S)->modelMethods.sFcn.fcnInEnable.mdlSetInputPortComplexSignal
# define ssSetmdlSetInputPortComplexSignal(S,setInputPortComplexSignal) \
         (S)->modelMethods.sFcn.fcnInEnable.mdlSetInputPortComplexSignal = \
            (setInputPortComplexSignal)
# define sfcnSetInputPortComplexSignal(S, portIdx, val) \
         (*(S)->modelMethods.sFcn.fcnInEnable.mdlSetInputPortComplexSignal)\
         (S, portIdx, val)

# define ssGetmdlSetOutputPortComplexSignal(S) \
         (S)->modelMethods.sFcn.fcnOutDisable.mdlSetOutputPortComplexSignal
# define ssSetmdlSetOutputPortComplexSignal(S,setOutputPortComplexSignal) \
         (S)->modelMethods.sFcn.fcnOutDisable.mdlSetOutputPortComplexSignal = \
            (setOutputPortComplexSignal)
# define sfcnSetOutputPortComplexSignal(S, portIdx, val) \
         (*(S)->modelMethods.sFcn.fcnOutDisable.mdlSetOutputPortComplexSignal)\
            (S, portIdx, val)

# define ssGetmdlSetDefaultPortComplexSignals(S) \
    ((S)->states.modelMethods2)->mdlSetDefaultPortComplexSignals
# define ssSetmdlSetDefaultPortComplexSignals(S,setDefaultPortComplexSignals) \
    ((S)->states.modelMethods2)->mdlSetDefaultPortComplexSignals =        \
                                             setDefaultPortComplexSignals
# define sfcnSetDefaultPortComplexSignals(S) \
    (*((S)->states.modelMethods2)->mdlSetDefaultPortComplexSignals)(S)

# define ssGetmdlSetInputPortFrameData(S) \
         ((S)->states.modelMethods2)->mdlSetInputPortFrameData
# define ssSetmdlSetInputPortFrameData(S,setInputPortFrameData) \
         ((S)->states.modelMethods2)->mdlSetInputPortFrameData = \
          (setInputPortFrameData)
# define sfcnSetInputPortFrameData(S, portIdx, frameData) \
         (*((S)->states.modelMethods2)->mdlSetInputPortFrameData) \
           (S, portIdx, frameData)

#endif

# define _ssGetRTWGeneratedEnable(S) \
         (S)->modelMethods.sFcn.fcnInEnable.mdlEnable
# define _ssSetRTWGeneratedEnable(S,setEnable) \
         (S)->modelMethods.sFcn.fcnInEnable.mdlEnable = (setEnable)
# define _sfcnRTWGeneratedEnable(S) \
         (*(S)->modelMethods.sFcn.fcnInEnable.mdlEnable)(S)

# define _ssGetRTWGeneratedDisable(S) \
         (S)->modelMethods.sFcn.fcnOutDisable.mdlDisable
# define _ssSetRTWGeneratedDisable(S,setDisable) \
         (S)->modelMethods.sFcn.fcnOutDisable.mdlDisable = (setDisable)
# define _sfcnRTWGeneratedDisable(S) \
         (*(S)->modelMethods.sFcn.fcnOutDisable.mdlDisable)(S)

#if !SS_SFCN || SS_GENERATED_S_FUNCTION
# define ssGetRTWGeneratedEnable(S) \
         _ssGetRTWGeneratedEnable(S)
# define ssSetRTWGeneratedEnable(S,setEnable) \
         _ssSetRTWGeneratedEnable(S,setEnable)
# define sfcnRTWGeneratedEnable(S) \
         _sfcnRTWGeneratedEnable(S)

# define ssGetRTWGeneratedDisable(S) \
         _ssGetRTWGeneratedDisable(S)
# define ssSetRTWGeneratedDisable(S,setDisable) \
         _ssSetRTWGeneratedDisable(S,setDisable)
# define sfcnRTWGeneratedDisable(S) \
         _sfcnRTWGeneratedDisable(S)

#else
  /* User S-Functions */
# define ssGetRTWGeneratedEnable(S) \
         ssGetRTWGeneratedEnable_cannot_be_used_in_SFunctions
# define ssSetRTWGeneratedEnable(S,setEnable) \
         ssGetRTWGeneratedEnable_cannot_be_used_in_SFunctions
# define sfcnRTWGeneratedEnable(S) \
         sfcnRTWGeneratedEnable_cannot_be_used_in_SFunctions

# define ssGetRTWGeneratedDisable(S) \
         ssGetRTWGeneratedDisable_cannot_be_used_in_SFunctions
# define ssSetRTWGeneratedDisable(S,setDisable) \
         ssSetRTWGeneratedDisable_cannot_be_used_in_SFunctions
# define sfcnRTWGeneratedDisable(S) \
         sfcnRTWGeneratedDisable_cannot_be_used_in_SFunctions
#endif

#define ssSetmdlInitializeSampleTimes(S,initSampleTimes) \
         (S)->modelMethods.sFcn.mdlInitializeSampleTimes = \
           (initSampleTimes)
#define sfcnInitializeSampleTimes(S) \
         (*(S)->modelMethods.sFcn.mdlInitializeSampleTimes)(S)

#if SS_SL_INTERNAL || SS_SFCN_FOR_SIM

# define ssGetmdlSetInputPortSampleTime(S) \
         (S)->modelMethods.sFcn.mdlSetInputPortSampleTime
# define ssSetmdlSetInputPortSampleTime(S,fcn) \
         (S)->modelMethods.sFcn.mdlSetInputPortSampleTime = (fcn)
# define sfcnSetInputPortSampleTime(S, portIdx, sampleTime, offsetTime) \
         (*(S)->modelMethods.sFcn.mdlSetInputPortSampleTime)\
            (S, portIdx, sampleTime, offsetTime)

# define ssGetmdlSetOutputPortSampleTime(S) \
         (S)->modelMethods.sFcn.mdlSetOutputPortSampleTime
# define ssSetmdlSetOutputPortSampleTime(S,fcn) \
         (S)->modelMethods.sFcn.mdlSetOutputPortSampleTime = (fcn)
# define sfcnSetOutputPortSampleTime(S, portIdx, sampleTime, offsetTime) \
         (*(S)->modelMethods.sFcn.mdlSetOutputPortSampleTime)\
            (S, portIdx, sampleTime, offsetTime)

# define ssGetmdlSetWorkWidths(S) \
         (S)->modelMethods.sFcn.mdlSetWorkWidths
# define ssSetmdlSetWorkWidths(S,setWorkWidths) \
         (S)->modelMethods.sFcn.mdlSetWorkWidths = (setWorkWidths)
# define sfcnSetWorkWidths(S) \
         (*(S)->modelMethods.sFcn.mdlSetWorkWidths)(S)

# define ssGetmdlRTW(S) \
         (S)->modelMethods.sFcn.mdlRTW
# define ssSetmdlRTW(S,rtw) \
         (S)->modelMethods.sFcn.mdlRTW = (rtw)
# define sfcnRTW(S) \
         (*(S)->modelMethods.sFcn.mdlRTW)(S)
#endif

# define ssGetmdlEnable(S) \
         ((S)->states.modelMethods2)->mdlEnable
# define ssSetmdlEnable(S,enab) \
         ((S)->states.modelMethods2)->mdlEnable = (enab)
# define sfcnEnable(S) \
         ((S)->states.modelMethods2)->mdlEnable ? \
          (*((S)->states.modelMethods2)->mdlEnable)((S)) : (void)(S);

# define ssGetmdlDisable(S) \
         ((S)->states.modelMethods2)->mdlDisable
# define ssSetmdlDisable(S,disab) \
         ((S)->states.modelMethods2)->mdlDisable = (disab)
# define sfcnDisable(S) \
         ((S)->states.modelMethods2)->mdlDisable ? \
         (*((S)->states.modelMethods2)->mdlDisable)((S)) : (void)(S);

#define ssSetmdlInitializeConditions(S,initConds) \
         (S)->modelMethods.sFcn.mdlInitializeConditions.level2 = \
           (initConds)
#define ssGetmdlInitializeConditions(S) \
         (S)->modelMethods.sFcn.mdlInitializeConditions.level2

#define sfcnInitializeConditions(S) \
         (*(S)->modelMethods.sFcn.mdlInitializeConditions.level2)(S)

#define ssSetmdlInitializeConditionsLevel1(S,initConds) \
         (S)->modelMethods.sFcn.mdlInitializeConditions.level1 = \
           (initConds)
#define sfcnInitializeConditionsLevel1(x0, S) \
         (*(S)->modelMethods.sFcn.mdlInitializeConditions.level1)(x0,S)

#define ssGetmdlStart(S) \
         (S)->modelMethods.sFcn.mdlStart
#define ssSetmdlStart(S,start) \
         (S)->modelMethods.sFcn.mdlStart = (start)
#define sfcnStart(S) \
         (*(S)->modelMethods.sFcn.mdlStart)(S)

#define ssSetmdlInitSystemMatrices(S,initSystemMatrices) \
         ((S)->states.modelMethods2->modelMethods3)->\
                      mdlInitSystemMatrices = (initSystemMatrices)
#define ssGetmdlInitSystemMatrices(S) \
         ((S)->states.modelMethods2->modelMethods3)->\
                      mdlInitSystemMatrices
#define sfcnInitSystemMatrices(S) \
    (*(((S)->states.modelMethods2)->modelMethods3)->\
                      mdlInitSystemMatrices) (S)

#define ssGetmdlJacobianIrJc(S) \
    ((S)->states.modelMethods2->modelMethods3)->mdlJacobianIrJc
#define ssSetmdlJacobianIrJc(S,JacobianIrJc) \
    ((S)->states.modelMethods2->modelMethods3)->mdlJacobianIrJc = (JacobianIrJc)
#define sfcnJacobianIrJc(S) \
    (*(((S)->states.modelMethods2)->modelMethods3)->mdlJacobianIrJc)(S)
 

#if SS_SL_INTERNAL || SS_SFCN_FOR_SIM
# define ssGetmdlCheckParameters(S) \
         (S)->modelMethods.sFcn.mdlCheckParameters
# define ssSetmdlCheckParameters(S,checkParameters) \
         (S)->modelMethods.sFcn.mdlCheckParameters = (checkParameters)
# define sfcnCheckParameters(S) \
         (*(S)->modelMethods.sFcn.mdlCheckParameters)(S)

# define ssGetmdlProcessParameters(S) \
         (S)->modelMethods.sFcn.mdlProcessParameters
# define ssSetmdlProcessParameters(S,fcnptr) \
         (S)->modelMethods.sFcn.mdlProcessParameters = (fcnptr)
# define sfcnProcessParameters(S) \
          (*(S)->modelMethods.sFcn.mdlProcessParameters)(S)
#endif

# define ssGetmdlExtModeExec(S) \
         ((S)->states.modelMethods2)->mdlExtModeExec
# define ssSetmdlExtModeExec(S,extModeExec) \
         ((S)->states.modelMethods2)->mdlExtModeExec = (extModeExec)
# define sfcnExtModeExec(S) \
         (*((S)->states.modelMethods2)->mdlExtModeExec)(S)

#if !SS_RT  || defined(RSIM_WITH_SL_SOLVER)
# define ssSetmdlGetTimeOfNextVarHit(S,getTimeOfNextVarHit) \
         (S)->modelMethods.sFcn.mdlGetTimeOfNextVarHit = (getTimeOfNextVarHit)
# define sfcnGetTimeOfNextVarHit(S) \
         (*(S)->modelMethods.sFcn.mdlGetTimeOfNextVarHit)(S)
#endif

#define ssSetmdlOutputs(S,outputs) \
         (S)->modelMethods.sFcn.mdlOutputs.level2 = (outputs)
#define sfcnOutputs(S, tid) \
         (*(S)->modelMethods.sFcn.mdlOutputs.level2)(S,tid)

#define ssSetmdlOutputsLevel1(S,outputs) \
         (S)->modelMethods.sFcn.mdlOutputs.level1 = (outputs)
#define sfcnOutputsLevel1(y, x, u, S, tid) \
         (*(S)->modelMethods.sFcn.mdlOutputs.level1)(y,x,u,S,tid)

#define ssSetmdlUpdate(S,update) \
         (S)->modelMethods.sFcn.mdlUpdate.level2 = (update)
#define ssGetmdlUpdate(S) \
         (S)->modelMethods.sFcn.mdlUpdate.level2
#define sfcnUpdate(S, tid) \
         (*(S)->modelMethods.sFcn.mdlUpdate.level2)(S,tid)

#define ssSetmdlUpdateLevel1(S,update) \
         (S)->modelMethods.sFcn.mdlUpdate.level1 = (update)
#define sfcnUpdateLevel1(x, u, S, tid) \
         (*(S)->modelMethods.sFcn.mdlUpdate.level1)(x,u,S,tid)

#define ssSetmdlDerivatives(S,derivs) \
         (S)->modelMethods.sFcn.mdlDerivatives.level2 = (derivs)
#define ssGetmdlDerivatives(S) \
         (S)->modelMethods.sFcn.mdlDerivatives.level2
#define sfcnDerivatives(S) \
         (*(S)->modelMethods.sFcn.mdlDerivatives.level2)(S)

#define ssSetmdlDerivativesLevel1(S,derivs) \
         (S)->modelMethods.sFcn.mdlDerivatives.level1 = (derivs)
#define sfcnDerivativesLevel1(dx, x, u, S, tid) \
         (*(S)->modelMethods.sFcn.mdlDerivatives.level1)(dx,x,u,S,tid)

#if !SS_RT
# define ssSetmdlZeroCrossings(S,zeroCrossings) \
         (S)->modelMethods.sFcn.mdlZeroCrossings = (zeroCrossings)
# define sfcnZeroCrossings(S) \
         (*(S)->modelMethods.sFcn.mdlZeroCrossings)(S)
#endif

#define ssSetmdlTerminate(S,terminate) \
         (S)->modelMethods.sFcn.mdlTerminate = (terminate)
#define sfcnTerminate(S) \
         (*(S)->modelMethods.sFcn.mdlTerminate)(S)

#define ssSetmdlProjection(S,projection) \
         ((S)->states.modelMethods2)->mdlProjection = (projection)
#define ssGetmdlProjection(S) \
         ((S)->states.modelMethods2)->mdlProjection
#define sfcnProjection(S) \
         (*((S)->states.modelMethods2)->mdlProjection) (S)

#define ssSetmdlMassMatrix(S,massMatrixFcn) \
         ((S)->states.modelMethods2)->mdlMassMatrix = (massMatrixFcn)
#define ssGetmdlMassMatrix(S) \
         ((S)->states.modelMethods2)->mdlMassMatrix
#define sfcnMassMatrix(S) \
         (*((S)->states.modelMethods2)->mdlMassMatrix) (S)

#define ssSetmdlForcingFunction(S,forcingFunction) \
         ((S)->states.modelMethods2)->mdlForcingFunction = (forcingFunction)
#define ssGetmdlForcingFunction(S) \
         ((S)->states.modelMethods2)->mdlForcingFunction
#define sfcnForcingFunction(S) \
         (*((S)->states.modelMethods2)->mdlForcingFunction) (S)

#define ssSetmdlConstraints(S,constraintsFcn) \
         (((S)->states.modelMethods2)->constraintsInfo)->mdlConstraints = (constraintsFcn)
#define ssGetmdlConstraints(S) \
         (((S)->states.modelMethods2)->constraintsInfo)->mdlConstraints
#define sfcnConstraints(S) \
         (*((S)->states.modelMethods2)->constraintsInfo->mdlConstraints) (S)

#define ssSetmdlRTWCG(S,rtwcg) \
         ((S)->states.modelMethods2)->mdlRTWCG = (rtwcg)
#define ssGetmdlRTWCG(S) \
         ((S)->states.modelMethods2)->mdlRTWCG
#define sfcnRTWCG(S,iObj) \
         (*((S)->states.modelMethods2)->mdlRTWCG) ((S),(iObj))

#if SS_SL_INTERNAL || SS_SFCN_FOR_SIM
#define ssSetmdlJacobian(S,jacobian) \
         ((S)->states.modelMethods2)->mdlJacobian = (jacobian)
#define ssGetmdlJacobian(S) \
         ((S)->states.modelMethods2)->mdlJacobian
#define sfcnJacobian(S) \
         (*((S)->states.modelMethods2)->mdlJacobian) (S)

#define ssSetmdlSimStatusChange(S,simStatusChange) \
         ((S)->states.modelMethods2)->mdlSimStatusChange = (simStatusChange)
#define ssGetmdlSimStatusChange(S) \
         ((S)->states.modelMethods2)->mdlSimStatusChange
#define sfcnSimStatusChange(S,simStatusChange) \
         (*((S)->states.modelMethods2)->mdlSimStatusChange) (S, (simStatusChange))

#endif


#if SS_SL_INTERNAL

typedef void (*voidFcnIntType)(int);
typedef void (*voidFcnVoidType)(void);
typedef void (*voidFcnVoidStarType)(void*,void*);

#define ssSetModelOutputs(S, fcn) \
        (S)->modelMethods.sFcn.mdlOutputs.level2 = (mdlOutputsFcn)(fcn)
#define ssRunModelOutputs(S, tid) \
        (*((voidFcnIntType)((S)->modelMethods.sFcn.mdlOutputs.level2)))(tid)


#define ssSetModelUpdate(S, fcn) \
        (S)->modelMethods.sFcn.mdlUpdate.level2 = (mdlUpdateFcn)(fcn)
#define ssRunModelUpdate(S, tid) \
        (*((voidFcnIntType)((S)->modelMethods.sFcn.mdlUpdate.level2)))(tid)


#define ssSetModelLogData(S, fcn) \
      (S)->mdlInfo->rtwLogInfo->mdlLogData = (voidFcnVoidStarType)(fcn)
#define ssRunModelLogData(S,tp) \
      (*((S)->mdlInfo->rtwLogInfo->mdlLogData))((S)->mdlInfo->rtwLogInfo,tp)


# define ssSetModelDerivatives(S, fcn) \
         (S)->modelMethods.sFcn.mdlDerivatives.level2 = (mdlDerivativesFcn)(fcn)
# define ssRunModelDerivatives(S) \
         (*((voidFcnVoidType)((S)->modelMethods.sFcn.mdlDerivatives.level2)))()


# define ssSetModelProjection(S, fcn) \
         (S)->states.modelMethods2->mdlProjection = (mdlProjectionFcn)(fcn)
# define ssRunModelProjection(S) \
         (*((voidFcnVoidType)((S)->states.modelMethods2->mdlProjection)))()


# define ssSetModelForcingFunction(S, fcn) \
         (S)->states.modelMethods2->mdlForcingFunction = (mdlForcingFunctionFcn)(fcn)
# define ssRunModelForcingFunction(S) \
         (*((voidFcnVoidType)((S)->states.modelMethods2->mdlForcingFunction)))()


# define ssSetModelMassMatrix(S, fcn) \
         (S)->states.modelMethods2->mdlMassMatrix = (mdlMassMatrixFcn)(fcn)
# define ssRunModelMassMatrix(S) \
         (*((voidFcnVoidType)((S)->states.modelMethods2->mdlMassMatrix)))()

# define ssSetModelInitSystemMatrices(S, fcn) \
         ((S)->states.modelMethods2->modelMethods3)->mdlInitSystemMatrices = (mdlInitSystemMatricesFcn)(fcn)
# define ssRunModelInitSystemMatrices(S) \
         (*((voidFcnVoidType)(((S)->states.modelMethods2)->mdlInitSystemMatrices)))()

# define ssSetModelRTWCG(S, fcn) \
         (S)->states.modelMethods2->mdlRTWCG = (mdlRTWCGFcn)(fcn)
# define ssRunModelRTWCG(S,iObj) \
         (*((voidFcnVoidType)((S)->states.modelMethods2->mdlRTWCG)))((iObj))


# define ssSetModelZeroCrossings(S, fcn) \
         (S)->modelMethods.sFcn.mdlZeroCrossings = (mdlZeroCrossingsFcn)(fcn)
# define ssRunModelZeroCrossings(S) \
         (*((voidFcnVoidType)((S)->modelMethods.sFcn.mdlZeroCrossings)))()


#define ssGetNumNonContDerivSigInfos(S) \
        ((S)->mdlInfo->numNonContDerivSigInfos)
#define ssSetNumNonContDerivSigInfos(S, n) \
        (S)->mdlInfo->numNonContDerivSigInfos = (n)


#define ssGetNonContDerivSigInfos(S) \
        ((S)->mdlInfo->nonContDerivSigInfos)
#define ssSetNonContDerivSigInfos(S, p) \
        (S)->mdlInfo->nonContDerivSigInfos = (p)

#endif

/*-------------------------------- S->sFunctions ----------------------------*/

#define _ssGetSFunctions(S) \
          (S)->sFunctions                               /* (SimStruct **)    */
#define _ssSetSFunctions(S,SFunPtr) \
          (S)->sFunctions = (SFunPtr)
#if !SS_SFCN
#define ssSetSFunctions(S,SFunPtr) _ssSetSFunctions(S,SFunPtr)
#else
#define ssSetSFunctions(S,SFunPtr) ssSetSFunctions_cannot_be_used_in_SFunctions
#endif

#define ssGetSFunction(S,sfun) \
          ((S)->sFunctions[sfun])                       /* (SimStruct *)     */
#define _ssSetSFunction(S,sfunid,simStruc) \
          (S)->sFunctions[sfunid] = (simStruc)
#if !SS_SFCN
#define ssSetSFunction(S,sfunid,simStruc) _ssSetSFunction(S,sfunid,simStruc)
#else
#define ssSetSFunction(S,sfunid,simStruc) \
          ssSetSFunction_cannot_be_used_in_SFunctions
#endif

/*==============================*
 * Miscellaneous access methods *
 *==============================*/

#if !defined(ENABLE_SLEXEC_SSBRIDGE)

/*------------------------- ssIsContinuousTask ------------------------------*/

#if SS_SL_INTERNAL || SS_SFCN_FOR_SIM
#if RSIM_WITH_SOLVER_MULTITASKING
#if SS_TID01EQ_EQUAL_ONE
#define ssIsContinuousTask(S, tid) \
           ((tid) <= 1)
#else
# define ssIsContinuousTask(S,tid) \
           ((tid) == 0)
#endif
#else
 /*
  * During simulation, tid passed to S-functions is always 0 even in
  * multitasking mode
  */
# define ssIsContinuousTask(S,tid) (((tid) == 0) && (S)->mdlInfo->sampleHits[0])
#endif
#elif SS_TID01EQ_EQUAL_ONE
#define ssIsContinuousTask(S, tid) \
           ((tid) <= 1)
#else
# define ssIsContinuousTask(S,tid) \
           ((tid) == 0)
#endif

#define ssIsAsyncTID(S,sti) \
           (ssGetSampleTimeTaskID(S,sti) >= \
            ssGetNumRootSampleTimes(S))

/*-------------------------- ssIsSampleHit ----------------------------------*/
#if SS_MULTITASKING || RSIM_WITH_SOLVER_MULTITASKING

#define ssIsSampleHit(S,sti,tid) \
            (!ssIsTIDInStInfo(S,sti) || \
            (ssGetSampleTimeTaskID(S,sti) == (tid)))

#else

# define ssIsSampleHit(S,sti,tid) \
            (((tid) != CONSTANT_TID) && \
             (!ssIsTIDInStInfo(S,sti) || \
             (ssIsMajorTimeStep(S) && \
              (ssGetSampleHitPtr(S))[ssGetSampleTimeTaskID(S,sti)])))

#endif

/*------------------------- ssSetSampleHitInTask ----------------------------*/
#if SS_MULTITASKING || SS_SL_INTERNAL || SS_SFCN_FOR_SIM
# define _ssSetSampleHitInTask(S, task_j, task_i, hit) \
            (S)->mdlInfo->perTaskSampleHits[(task_j) + \
              ((task_i) * (ssGetNumSampleTimes(S)))] = (hit)
# if !SS_SFCN
# define ssSetSampleHitInTask(S, task_j, task_i, hit) \
           _ssSetSampleHitInTask(S, task_j, task_i, hit)
# else
#define ssSetSampleHitInTask(S, task_j, task_i, hit) \
           ssSetSampleHitInTask_cannot_be_used_in_SFunctions
# endif
#endif

/*----------------------- ssIsSpecialSampleHit ------------------------------*/

#if SS_MULTITASKING || SS_SL_INTERNAL || SS_SFCN_FOR_SIM
/*
 * The ssIsSpecialSampleHit(S, my_sti, promoted_sti, tid) macro will be
 * "true" if the block is executing in a major time step in context of a
 * promoted sample time (promoted_sti) and we have a sample hit in the
 * original task (my_sti) which translates to:
 *    1) tid == tid_for(promoted_sti). It is required that this macro be
 *       invoked with in a ssIsSampleHit(S,promoted_sti,tid) to guarantee this
 *       case.
 *    2) Must be major time step.
 *    3) my_sti (the block's sti) has a sample hit at the current point in
 *       time.
 * Valid usage in an S-function would be:
 *	if (ssIsSampleHit(S, promoted_sti)) {
 *        if (ssIsSpecialSampleHit(S, my_sti, promoted_sti, tid)) {
 *        }
 *      }
 * providing promoted_sti is not the continuous task. If promoted_sti is
 * the continuous task, then the following must be used:
 *	if (ssIsContinuousTask(S, promoted_sti)) {
 *        if (ssIsSpecialSampleHit(S, my_sti, promoted_sti, tid)) {
 *        }
 *      }
 *
 * Note, failure to wrap ssIsSpecialSampleHit() within ssIsSampleHit() or
 * ssIsContinuousTask will result in unexpected behavior.
 */
#define ssIsSampleHitInTask(S, my_sti, tid) \
            (ssGetPerTaskSampleHitsPtr(S))[ \
              ssGetSampleTimeTaskID(S,my_sti) + \
                ((tid) * (ssGetNumRootSampleTimes(S)))]

#  define ssIsSpecialSampleHit(S, my_sti, promoted_sti, tid) \
            (ssIsMajorTimeStep(S) && ssIsSampleHitInTask(S, my_sti, \
             ssGetSampleTimeTaskID(S,promoted_sti)))
#else
#  define ssIsSpecialSampleHit(S, my_sti, promoted_sti, tid) \
            ssIsSampleHit(S, my_sti, tid)
#endif

#endif /* !defined(ENABLE_SLEXEC_SSBRIDGE)  */

#define ssGetNumRootSampleTimes(S) ssGetNumSampleTimes(ssGetRootSS(S))

/* --------------set/get methods for firstInitCondCalled-------------------- */
#define _ssSetFirstInitCondCalled(S, val) \
    (ssGetRootSS(S)->mdlInfo->mdlFlags).firstInitCondCalled = (val)

#if !SS_SFCN
#define ssSetFirstInitCondCalled(S) _ssSetFirstInitCondCalled(S, 1U)
#define ssClearFirstInitCondCalled(S) _ssSetFirstInitCondCalled(S, 0U)
#else
#define ssSetFirstInitCondCalled(S) \
        ssSetFirstInitCondCalled_cannot_be_used_in_SFunctions
#define ssClearFirstInitCondCalled(S) \
        ssClearFirstInitCondCalled_cannot_be_used_in_SFunctions
#endif

#define ssIsFirstInitCond(S) \
    !(ssGetRootSS(S)->mdlInfo->mdlFlags).firstInitCondCalled

/*------------------------ ssPrintf, ssWarning ------------------------------*/
#if !SS_SL_INTERNAL
#  if SS_SFCN_FOR_SIM

#    define SS_STDIO_AVAILABLE
#    define ssPrintf mexPrintf
     extern
#ifdef __cplusplus
     "C"
#endif
     void ssWarning(SimStruct *, const char *msg);
#  elif SS_HAVESTDIO  /* for Real-Time Workshop with stdio facilities */
#    include <stdio.h>
#    define SS_STDIO_AVAILABLE
#    define ssPrintf printf
#    define ssWarning(S,msg) \
              printf("Warning: block '%s': %s\n",ssGetPath(S),msg)
#  else  /* for Real-Time Workshop without stdio facilities */
     extern int rtPrintfNoOp(const char *fmt, ...);
#    undef SS_STDIO_AVAILABLE
#    define ssPrintf rtPrintfNoOp
#    define ssWarning(S,msg) /* do nothing */
#  endif
#endif



/*===========================================================================*
 * The following are for backward compatibility for user written S-functions *
 *===========================================================================*/

#if SS_SFCN_LEVEL_1

#define SS_OPTION_NOT_USING_mexErrMsgTxt     SS_OPTION_EXCEPTION_FREE_CODE

#define ssGetChecksum(S)                     ssGetChecksum0(S)
#define ssSetChecksum(S,val)                 ssSetChecksum0(S,val)

#define ssGetParamChecksum(S)                ssGetChecksum3(S)


/* Macros from Simulink 1.3, Simulink 2.0 */

# define ssGetStatus(S)                      ssGetErrorStatus(S)
# define ssSetStatus(S,msg)                  ssSetErrorStatus(S,msg)

# define ssGetSizes(S)                       ssGetSizesPtr(S)


# define ssGetNumScopes(S) (0.0/*no-op*/)
# define ssSetNumScopes(S,nScopes) /*do nothing*/

# define ssGetIntgStopTime(S)               ssGetSolverStopTime(S)
# define ssSetIntgStopTime(S,stoptime)      ssSetSolverStopTime(S,stoptime)

# define ssSetMinorTimeStep(S,b)      \
     ssSetSimTimeStep(S,((b)? MINOR_TIME_STEP, MAJOR_TIME_STEP))

# define ssGetPresentTimeEvent(S,sti)       ssGetTaskTime(S,sti)
# define ssSetPresentTimeEvent(rootS,sti,t) ssSetTaskTime(rootS,sti,t)

# define ssGetSampleHitEventPtr(S)          ssGetSampleHitPtr(S)
# define ssSetSampleHitEventPtr(S,ptr)      ssSetSampleHitPtr(S,ptr)

# define ssSetSampleHitEvent(S,sti,hit)     ssSetSampleHit(S,sti,hit)

# define ssGetSampleTimeEventPtr(S)         ssGetSampleTimePtr(S)
# define ssSetSampleTimeEventPtr(S,ptr)     ssSetSampleTimePtr(S,ptr)

# define ssGetSampleTimeEvent(S,sti)        ssGetSampleTime(S,sti)
# define ssSetSampleTimeEvent(S,sti,t)      ssSetSampleTime(S,sti,t)

# define ssGetOffsetTimeEventPtr(S)         ssGetOffsetTimePtr(S)
# define ssSetOffsetTimeEventPtr(S,ptr)     ssSetOffsetTimePtr(S,ptr)

# define ssGetOffsetTimeEvent(S,sti)        ssGetOffsetTime(S,sti)
# define ssSetOffsetTimeEvent(S,sti,t)      ssSetOffsetTime(S,sti,t)

# define ssIsSampleHitEvent(S,sti,tid)      ssIsSampleHit(S,sti,tid)

# define ssSetSampleHitEventInTask(rootS, task_j, task_i, hit) \
           ssSetSampleHitInTask(rootS, task_j, task_i, hit)

# define ssIsSpecialSampleHitEvent(S, my_sti, promoted_sti, tid) \
           ssIsSpecialSampleHit(S, my_sti, promoted_sti, tid)


# define ssGetNumInputArgs(S)              ssGetNumSFcnParams(S)
# define ssSetNumInputArgs(S,numInputArgs) ssSetNumSFcnParams(S,numInputArgs)

# define ssGetNumArgs(S)                   ssGetSFcnParamsCount(S)
# define ssSetNumArgs(S,numArgs)           ssSetSFcnParamsCount(S,numArgs)

# define ssGetArgPtr(S)                    ssGetSFcnParamsPtr(S)
# define ssSetArgPtr(S,args)               ssSetSFcnParamsPtr(S,args)

# define ssGetArg(S,argNum)                ssGetSFcnParam(S,argNum)
# define ssSetArg(S,argIdx,argMat)         ssSetSFcnParam(S,argIdx,argMat)

#endif


# define ssSetModelRefSignalLoggingSaveFormat(S, format) \
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_MDLREF_SIGNAL_LOGGING_SAVE_FORMAT, (int)format,NULL) \
     _ssSafelyCallGenericFcnEnd

/*===========================================================================*
 * Dataset Format Logging                                                    *
 *===========================================================================*/

typedef struct {
    void         *mmi;
    int_T        numRefModelPath;
    const char_T **refModelPath;
    const char_T *name;
    boolean_T    forObserver;
    void         **ppRet;
} SFcnLoggerCreateDatasetDescriptInfo;

typedef struct {
    int_T        hierInfoIdx;
    void         **ppRet;
} SFcnLoggerCreateValuesDescriptInfo;

typedef struct {
    void         **ppDatasetDesc;
    const char_T *className;
    const char_T *name;
    const char_T *bpath;
    const char_T *chartPath;
    int_T        portIdx;
    int_T        max_points;
    int_T        decimation_val;
    void         **ppValDesc;
    void         **ppRet;
} SFcnLoggerAddElementDescriptInfo;

typedef struct {
    void         **ppDatasetDesc;
    void         **ppElementDesc;
    const char_T *name;
    int_T        nDims;
    const int_T  *dims;
    DTypeId      dataType;
    boolean_T    complexity;
    SSLoggerInterpMethod interp;
} SFcnLoggerAddTimeseriesDescInfo;

typedef struct {
    void **ppDatasetDesc;
    void **ppRetElementArray;
    const char_T *busName;
} SFcnLoggerCreateDatasetFromDescptInfo;

typedef struct {
    const char  *propName;
    mxArray     *propVal;
    void        *pElement;
} SFcnLoggerAddElementPropInfo;

typedef struct {
    void   *pwork;
    real_T inputTime;
    const char *inputData;
} SFcnLoggerUpdateLogVarInfo;

#if SS_SFCN && SS_SIM

/** Determine if S-Function Signal Logging is Supported **/
#define ssLoggerSupportsDatasetSignalLogging(S, pFlag)  { \
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_LOGGER_SUPPORTS_SIGNAL_LOGGING, 0, pFlag)\
    _ssSafelyCallGenericFcnEnd; \
}

/** CREATION STEP 1:  Create a dataset description **/
#define ssLoggerCreateDatasetDescription(S, datasetName, ppSetDesc) \
    _ssLoggerCreateDatasetDescriptWithMMI(S, NULL, 0, NULL, datasetName, ppSetDesc)

#define ssLoggerGetSignalLoggingDatasetDescription(S, ppSetDesc) \
    _ssLoggerCreateDatasetDescriptWithMMI(S, NULL, 0, NULL, NULL, ppSetDesc)

/** For sil/pil logging (start) - Use refPath to specify relative path inside the component **/
#define ssLoggerCreateMdlRefDatasetDescription(S, nRefModelPath, refPath, datasetName, ppSetDesc) \
    _ssLoggerCreateDatasetDescriptWithMMI(S, NULL, nRefModelPath, refPath, datasetName, ppSetDesc)

#define ssLoggerGetMdlRefSignalLoggingDatasetDescription(S, nRefModelPath, refPath, ppSetDesc) \
    _ssLoggerCreateDatasetDescriptWithMMI(S, NULL, nRefModelPath, refPath, NULL, ppSetDesc)

#define ssObserverGetMdlRefObserverDatasetDescription(S, nRefModelPath, refPath, ppSetDesc) \
    _ssCreateObserverDatasetDescriptWithMMI(S, NULL, nRefModelPath, refPath, ppSetDesc)

/** For sil/pil logging (end) **/

#define _ssLoggerCreateDatasetDescriptWithMMI(S, \
                                              modelMappingInfo, \
                                              nRefModelPath, \
                                              refPath, \
                                              datasetName, \
                                              ppSetDesc) { \
    SFcnLoggerCreateDatasetDescriptInfo info; \
    info.mmi = modelMappingInfo; \
    info.numRefModelPath = nRefModelPath; \
    info.refModelPath = refPath; \
    info.name = datasetName; \
    info.forObserver = false; \
    info.ppRet = ppSetDesc; \
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_LOGGER_CREATE_DATASET_DESCRIPT, 0, &info)\
    _ssSafelyCallGenericFcnEnd; \
}

#define _ssCreateObserverDatasetDescriptWithMMI(S, \
    modelMappingInfo, \
    nRefModelPath, \
    refPath, \
    ppSetDesc) { \
    SFcnLoggerCreateDatasetDescriptInfo info; \
    info.mmi = modelMappingInfo; \
    info.numRefModelPath = nRefModelPath; \
    info.refModelPath = refPath; \
    info.name = NULL; \
    info.forObserver = true; \
    info.ppRet = ppSetDesc; \
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_LOGGER_CREATE_DATASET_DESCRIPT, 0, &info)\
    _ssSafelyCallGenericFcnEnd; \
}
    
/** CREATION STEP 2 (optional):  Create values description (i.e. bus) **/
#define ssLoggerCreateBusValuesDescription(S, \
                                           busHierInfoIdx, \
                                           ppValuesDesc) { \
    SFcnLoggerCreateValuesDescriptInfo info; \
    info.hierInfoIdx = busHierInfoIdx; \
    info.ppRet = ppValuesDesc; \
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_LOGGER_CREATE_VALUES_DESCIPT, 0, &info)\
    _ssSafelyCallGenericFcnEnd; \
}


/** CREATION STEP 3:  Add element descriptions to dataset description **/
#define ssLoggerAddSignalDescription(S, \
                                     ppSetDesc, \
                                     elementName, \
                                     blockPath, \
                                     portIndex, \
                                     maxPoints, \
                                     decimation, \
                                     ppElementDesc) { \
    SFcnLoggerAddElementDescriptInfo info; \
    info.ppDatasetDesc = ppSetDesc; \
    info.className = NULL; \
    info.name = elementName; \
    info.bpath = blockPath; \
    info.chartPath = NULL; \
    info.portIdx = portIndex; \
    info.max_points = maxPoints; \
    info.decimation_val = decimation; \
    info.ppValDesc = NULL; \
    info.ppRet = ppElementDesc; \
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_LOGGER_ADD_ELEMENT_DESCRIPT, 0, &info)\
    _ssSafelyCallGenericFcnEnd; \
}


#define ssLoggerAddGenericElementDescription(S, \
                                             ppSetDesc, \
                                             elementClassName, \
                                             elementName, \
                                             blockPath, \
                                             maxPoints, \
                                             decimation, \
                                             ppElementDesc) { \
    SFcnLoggerAddElementDescriptInfo info; \
    info.ppDatasetDesc = ppSetDesc; \
    info.className = elementClassName; \
    info.name = elementName; \
    info.bpath = blockPath; \
    info.chartPath = NULL; \
    info.portIdx = -1; \
    info.max_points = maxPoints; \
    info.decimation_val = decimation; \
    info.ppValDesc = NULL; \
    info.ppRet = ppElementDesc; \
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_LOGGER_ADD_ELEMENT_DESCRIPT, 0, &info)\
    _ssSafelyCallGenericFcnEnd; \
}

#define ssLoggerAddSignalDescriptionWithValuesDescription(S, \
                                                          ppSetDesc, \
                                                          elementName, \
                                                          blockPath, \
                                                          portIndex, \
                                                          maxPoints, \
                                                          decimation, \
                                                          ppValueDesc, \
                                                          ppElementDesc) { \
    SFcnLoggerAddElementDescriptInfo info; \
    info.ppDatasetDesc = ppSetDesc; \
    info.className = NULL; \
    info.name = elementName; \
    info.bpath = blockPath; \
    info.chartPath = NULL; \
    info.portIdx = portIndex; \
    info.max_points = maxPoints; \
    info.decimation_val = decimation; \
    info.ppValDesc = ppValueDesc; \
    info.ppRet = ppElementDesc; \
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_LOGGER_ADD_ELEMENT_DESCRIPT, 0, &info)\
    _ssSafelyCallGenericFcnEnd; \
}

#define ssLoggerAddGenericElementDescriptionWithValuesDescription(S, \
                                                                  ppSetDesc, \
                                                                  elementClassName, \
                                                                  elementName, \
                                                                  blockPath, \
                                                                  maxPoints, \
                                                                  decimation, \
                                                                  ppValueDesc, \
                                                                  ppElementDesc) { \
    SFcnLoggerAddElementDescriptInfo info; \
    info.ppDatasetDesc = ppSetDesc; \
    info.className = elementClassName; \
    info.name = elementName; \
    info.bpath = blockPath; \
    info.chartPath = NULL; \
    info.portIdx = -1; \
    info.max_points = maxPoints; \
    info.decimation_val = decimation; \
    info.ppValDesc = ppValueDesc; \
    info.ppRet = ppElementDesc; \
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_LOGGER_ADD_ELEMENT_DESCRIPT, 0, &info)\
    _ssSafelyCallGenericFcnEnd; \
}

#define ssLoggerAddStateflowElementDescription(S, \
                                               ppSetDesc, \
                                               elementClassName, \
                                               elementName, \
                                               blockPath, \
                                               chartElementPath, \
                                               ppValueDesc, \
                                               ppElementDesc) { \
    SFcnLoggerAddElementDescriptInfo info; \
    info.ppDatasetDesc = ppSetDesc; \
    info.className = elementClassName; \
    info.name = elementName; \
    info.bpath = blockPath; \
    info.chartPath = chartElementPath; \
    info.portIdx = -1; \
    info.max_points = 0; \
    info.decimation_val = 0; \
    info.ppValDesc = ppValueDesc; \
    info.ppRet = ppElementDesc; \
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_LOGGER_ADD_ELEMENT_DESCRIPT, 0, &info)\
    _ssSafelyCallGenericFcnEnd; \
}

/** CREATION STEP 4:  Add timeseries description to a dataset element description **/
#define ssLoggerAddTimeseriesDescriptionWithInterpolation(S, \
                                         ppSetDesc, \
                                         ppElementDescript, \
                                         timeseriesName, \
                                         signalNdims, \
                                         signalDims, \
                                         signalDataType, \
                                         signalComplexity, \
                                         interpMethod) { \
    SFcnLoggerAddTimeseriesDescInfo info; \
    info.ppDatasetDesc = ppSetDesc; \
    info.ppElementDesc = ppElementDescript; \
    info.name = timeseriesName; \
    info.nDims = signalNdims; \
    info.dims = signalDims; \
    info.dataType = signalDataType; \
    info.complexity = signalComplexity; \
    info.interp     = interpMethod; \
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_LOGGER_ADD_TIMESERIES_DESCRIPT, 0, &info)\
    _ssSafelyCallGenericFcnEnd; \
}

#define ssLoggerAddTimeseriesDescription(S, \
                                         ppSetDesc, \
                                         ppElementDescript, \
                                         timeseriesName, \
                                         signalNdims, \
                                         signalDims, \
                                         signalDataType, \
                                         signalComplexity) \
    ssLoggerAddTimeseriesDescriptionWithInterpolation(S,ppSetDesc, \
        ppElementDescript,timeseriesName,signalNdims,signalDims, \
        signalDataType,signalComplexity,SS_LINEAR_INTERPOLATION);

/* CREATION STEP 4:  Construct variable from description */
#define ssLoggerCreateElementFromDescription(S, \
                                             ppSetDesc, \
                                             elementPtrArray) { \
    SFcnLoggerCreateDatasetFromDescptInfo info; \
    info.ppDatasetDesc = ppSetDesc; \
    info.ppRetElementArray = elementPtrArray; \
    info.busName = NULL; \
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_LOGGER_CREATE_DATASET_FROM_DESCRIPT, 0, &info)\
    _ssSafelyCallGenericFcnEnd; \
}

#define ssLoggerCreateElementFromDescriptionForBus(S, \
                                                   ppSetDesc,   \
                                                   busObjName, \
                                                   elementPtrArray) {   \
    SFcnLoggerCreateDatasetFromDescptInfo info; \
    info.ppDatasetDesc = ppSetDesc; \
    info.ppRetElementArray = elementPtrArray; \
    info.busName = busObjName; \
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_LOGGER_CREATE_DATASET_FROM_DESCRIPT, 0, &info)\
    _ssSafelyCallGenericFcnEnd; \
}

/** CREATION STEP 5 (optional):  Add additional properties to generic element **/
# define ssLoggerAddElementProperty(S, \
                                    elementPtr, \
                                    propertyName, \
                                    propertyVal) {\
    SFcnLoggerAddElementPropInfo info; \
    info.propName = propertyName; \
    info.propVal = propertyVal; \
    info.pElement = elementPtr; \
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_LOGGER_ADD_ELEMENT_PROP, 0, &info)\
    _ssSafelyCallGenericFcnEnd; \
}

/** UPDATE **/
# define ssLoggerUpdateTimeseries(S, \
                                  elementPtr, \
                                  timeseriesIdx, \
                                  timeVal, \
                                  dataPtr) {\
    SFcnLoggerUpdateLogVarInfo info; \
    info.pwork = elementPtr; \
    info.inputTime = timeVal; \
    info.inputData = dataPtr; \
    _ssSafelyCallGenericFcnStart(S)((S),GEN_FCN_LOGGER_UPDATE_LOGVAR, timeseriesIdx, &info)\
    _ssSafelyCallGenericFcnEnd; \
}

#endif

/*
 * API specific to Simulink solver that needs to be accessed in
 * Rapid accelerator and RSIM
 */

#include "simulink_solver_api.h"

/*
 * Include rtModel definitions if in RTW and using rtModel
 */
#ifdef USE_RTMODEL
# include "sfcn_bridge.h"
#endif

#endif  /* __SIMSTRUC__ */
/* EOF: simstruc.h */

/* LocalWords:  SimStruct's NRT NSAMPLE NUMST sfunc sfunctions RSIM sfunction Fxp
 * LocalWords:  elif ID's EXTLOGTASK ONESHOT ir Lcs dworks dstates fcncall DWork
 * LocalWords:  SlvrJacobianFcn extmode DTypeId SIGSET sigmapdef th th'signal
 * LocalWords:  tid's zc intg conds nd resolveCBK vals sti iwork rwork pwork
 * LocalWords:  nzMax compat SG et AslErrMsg RWork IWork PWork SFunctions untest
 * LocalWords:  versioning NonsampledZCs SlvrJacobian FCSSCtrl fixedpoint CSignal
 * LocalWords:  OptimOpts reusability ny OR'd mxCalloc vxlib ASYNC cycan VxWorks
 * LocalWords:  Async ZOH TRIGSS dlg prms rtp datatype async APIS ints ABus dsm
 * LocalWords:  BPath mrBlk MODELREF submodel modelref UPtrs slvr nxc jc nxd ndx
 * LocalWords:  nx Prev Nonsampled ZCs nonsampled Dirs DState CStates Optim Asl
 * LocalWords:  SINGLETASKING XPC call's DType DerivPort Deriv slexec ssbridge
 * LocalWords:  upcasting rsim sil pil
 */

