/*
 * File: rt_rand.c
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

#include "rt_rand.h"

/*
 * Uniform random number generator (random number between 0 and 1)
 *
 * #define IA      16807                      magic multiplier = 7^5
 * #define IM      2147483647                 modulus = 2^31-1
 * #define IQ      127773                     IM div IA
 * #define IR      2836                       IM modulo IA
 * #define S       4.656612875245797e-10      reciprocal of 2^31-1
 *
 * test = IA * (seed % IQ) - IR * (seed/IQ)
 * seed = test < 0 ? (test + IM) : test
 * return (seed*S)
 */
real_T rt_Urand(uint32_T *seed)        /* pointer to a running seed */
{
  uint32_T hi = *seed / 127773U;
  uint32_T lo = *seed % 127773U;
  int32_T test = (16807 * lo) - (2836 * hi);/* never overflows      */
  *seed = ((test < 0) ? (uint32_T)(test + 2147483647) : (uint32_T)test);
  return ((real_T) (*seed * 4.656612875245797e-10));
}                                      /* end rt_Urand */

/*
 * Normal (Gaussian) random number generator also known as mlUrandn in
 * MATLAB V4.
 */
real_T rt_NormalRand(uint32_T *seed)
{
  real_T sr, si, t;
  do {
    sr = (2.0 * rt_Urand(seed)) - 1.0;
    si = (2.0 * rt_Urand(seed)) - 1.0;
    t = (sr * sr) + (si * si);
  } while (t > 1.0);

  return(sr * sqrt((-2.0 * log(t)) / t));
}                                      /* end rt_NormalRand */

/*
 * File trailer for Real-Time Workshop generated code.
 *
 * [EOF]
 */
