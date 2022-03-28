/*
 * File: rt_look1d.c
 *
 * Code generated for Simulink model 't15_2'.
 *
 * Model version                  : 1.1137
 * Simulink Coder version         : 8.5 (R2013b) 08-Aug-2013
 * C/C++ source code generated on : Wed Feb 28 17:00:10 2018
 *
 * Target selection: ert_shrlib.tlc
 * Embedded hardware selection: 32-bit Generic
 * Emulation hardware selection:
 *    Differs from embedded hardware (MATLAB Host)
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include "rt_look1d.h"

/* 1D lookup routine for data type of real_T. */
real_T rt_Lookup(const real_T *x, int_T xlen, real_T u, const real_T *y)
{
  int_T idx = rt_GetLookupIndex(x, xlen, u);
  real_T num = y[idx+1] - y[idx];
  real_T den = x[idx+1] - x[idx];

  /* Due to the way the binary search is implemented
     in rt_look.c (rt_GetLookupIndex), den cannot be
     0.  Equivalently, m cannot be inf or nan. */
  real_T m = num/den;
  return (y[idx] + (m * (u - x[idx])));
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
