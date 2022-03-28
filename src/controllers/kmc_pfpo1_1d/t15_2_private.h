/*
 * File: t15_2_private.h
 *
 * Code generated for Simulink model 't15_2'.
 *
 * Model version                  : 1.1155
 * Simulink Coder version         : 8.5 (R2013b) 08-Aug-2013
 * C/C++ source code generated on : Sun Apr 11 18:58:01 2021
 *
 * Target selection: ert_shrlib.tlc
 * Embedded hardware selection: 32-bit Generic
 * Emulation hardware selection:
 *    Differs from embedded hardware (MATLAB Host)
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#ifndef RTW_HEADER_t15_2_private_h_
#define RTW_HEADER_t15_2_private_h_
#include "rtwtypes.h"

/* Private macros used by the generated code to access rtModel */
#ifndef rtmSetTFinal
# define rtmSetTFinal(rtm, val)        ((rtm)->Timing.tFinal = (val))
#endif

#ifndef rtmGetTPtr
# define rtmGetTPtr(rtm)               ((rtm)->Timing.t)
#endif

#ifndef rtmSetTPtr
# define rtmSetTPtr(rtm, val)          ((rtm)->Timing.t = (val))
#endif

#ifndef __RTWTYPES_H__
#error This file requires rtwtypes.h to be included
#else
#ifdef TMWTYPES_PREVIOUSLY_INCLUDED
#error This file requires rtwtypes.h to be included before tmwtypes.h
#endif                                 /* TMWTYPES_PREVIOUSLY_INCLUDED */
#endif                                 /* __RTWTYPES_H__ */

extern real_T rt_urand_Upu32_Yd_f_pw_snf(uint32_T *u);
void BINARYSEARCH_real_T(uint32_T *piLeft, uint32_T *piRght, real_T u, const
  real_T *pData, uint32_T iHi);
void LookUp_real_T_real_T(real_T *pY, const real_T *pYData, real_T u, const
  real_T *pUData, uint32_T iHi);
extern void pf_lookup3(SimStruct *rts);
extern void read_volt(SimStruct *rts);
extern void read_control_data2(SimStruct *rts);
extern void read_gaps(SimStruct *rts);
extern void read_gaps_term(SimStruct *rts);
extern void read_tt_kavin2(SimStruct *rts);

#endif                                 /* RTW_HEADER_t15_2_private_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
