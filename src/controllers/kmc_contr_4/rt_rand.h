/*
 * File: rt_rand.h
 *
 * Real-Time Workshop code generated for Simulink model t15_2.
 *
 * Model version                        : 1.1128
 * Real-Time Workshop file version      : 7.4  (R2009b)  29-Jun-2009
 * Real-Time Workshop file generated on : Thu Mar 24 12:39:33 2016
 * TLC version                          : 7.4 (Jul 14 2009)
 * C/C++ source code generated on       : Thu Mar 24 12:39:34 2016
 *
 * Target selection: ert_shrlib.tlc
 * Embedded hardware selection: 32-bit Generic
 * Emulation hardware selection:
 *    Differs from embedded hardware (MATLAB Host)
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#ifndef RTW_HEADER_rt_rand_h_
#define RTW_HEADER_rt_rand_h_
#include <math.h>
#include "rtwtypes.h"
# define MAXSEED                       2147483646                /* 2^31-2 */
# define SEED0                         1144108930                /* Seed #6, starting from seed = 1 */
# define RT_BIT16                      32768                     /* 2^15   */

extern real_T rt_Urand(uint32_T *seed);
extern real_T rt_NormalRand(uint32_T *seed);

#endif                                 /* RTW_HEADER_rt_rand_h_ */

/*
 * File trailer for Real-Time Workshop generated code.
 *
 * [EOF]
 */
