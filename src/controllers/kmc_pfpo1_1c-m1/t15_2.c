#if 1

# define t15_2_initialize t15_2_initialize_
# define t15_2_output t15_2_output_
# define t15_2_terminate t15_2_terminate_

#endif
/*
 * File: t15_2.c
 *
 * Code generated for Simulink model 't15_2'.
 *
 * Model version                  : 1.1159
 * Simulink Coder version         : 8.5 (R2013b) 08-Aug-2013
 * C/C++ source code generated on : Mon Nov 01 12:05:32 2021
 *
 * Target selection: ert_shrlib.tlc
 * Embedded hardware selection: 32-bit Generic
 * Emulation hardware selection:
 *    Differs from embedded hardware (MATLAB Host)
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include "t15_2.h"
#include "t15_2_private.h"
#include <float.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
//#include <Windows.h>

int kpr1, kpr =0;

kpr1=1;


/* Block signals (auto storage) */
BlockIO_t15_2 t15_2_B;

/* Block states (auto storage) */
D_Work_t15_2 t15_2_DWork;

/* External inputs (root inport signals with auto storage) */
ExternalInputs_t15_2 t15_2_U;

/* External outputs (root outports fed by signals with auto storage) */
ExternalOutputs_t15_2 t15_2_Y;

/* Real-time model */
RT_MODEL_t15_2 t15_2_M_;
RT_MODEL_t15_2 *const t15_2_M = &t15_2_M_;

/* Lookup Binary Search Utility BINARYSEARCH_real_T */
void BINARYSEARCH_real_T(uint32_T *piLeft, uint32_T *piRght, real_T u, const
  real_T *pData, uint32_T iHi)
{
  /* Find the location of current input value in the data table. */
  *piLeft = 0U;
  *piRght = iHi;
  if (u <= pData[0] ) {
    /* Less than or equal to the smallest point in the table. */
    *piRght = 0U;
  } else if (u >= pData[iHi] ) {
    /* Greater than or equal to the largest point in the table. */
    *piLeft = iHi;
  } else {
    uint32_T i;

    /* Do a binary search. */
    while (( *piRght - *piLeft ) > 1U ) {
      /* Get the average of the left and right indices using to Floor rounding. */
      i = (*piLeft + *piRght) >> 1;

      /* Move either the right index or the left index so that */
      /*  LeftDataPoint <= CurrentValue < RightDataPoint */
      if (u < pData[i] ) {
        *piRght = i;
      } else {
        *piLeft = i;
      }
    }
  }
}

/* Lookup Utility LookUp_real_T_real_T */
void LookUp_real_T_real_T(real_T *pY, const real_T *pYData, real_T u, const
  real_T *pUData, uint32_T iHi)
{
  uint32_T iLeft;
  uint32_T iRght;
  BINARYSEARCH_real_T( &(iLeft), &(iRght), u, pUData, iHi);

  {
    real_T lambda;
    if (pUData[iRght] > pUData[iLeft] ) {
      real_T num;
      real_T den;
      den = pUData[iRght];
      den = den - pUData[iLeft];
      num = u;
      num = num - pUData[iLeft];
      lambda = num / den;
    } else {
      lambda = 0.0;
    }

    {
      real_T yLeftCast;
      real_T yRghtCast;
      yLeftCast = pYData[iLeft];
      yRghtCast = pYData[iRght];
      yLeftCast += lambda * ( yRghtCast - yLeftCast );
      (*pY) = yLeftCast;
    }
  }
}

real_T rt_urand_Upu32_Yd_f_pw_snf(uint32_T *u)
{
  uint32_T lo;
  uint32_T hi;

  /* Uniform random number generator (random number between 0 and 1)

     #define IA      16807                      magic multiplier = 7^5
     #define IM      2147483647                 modulus = 2^31-1
     #define IQ      127773                     IM div IA
     #define IR      2836                       IM modulo IA
     #define S       4.656612875245797e-10      reciprocal of 2^31-1
     test = IA * (seed % IQ) - IR * (seed/IQ)
     seed = test < 0 ? (test + IM) : test
     return (seed*S)
   */
  lo = *u % 127773U * 16807U;
  hi = *u / 127773U * 2836U;
  if (lo < hi) {
    *u = 2147483647U - (hi - lo);
  } else {
    *u = lo - hi;
  }

  return (real_T)*u * 4.6566128752457969E-10;
}

/* Model step function */
void t15_2_step(void)
{
  real_T tmin;
  int32_T i;
  int32_T i_0;
  real_T u;
  real_T u_0;

  /* Level2 S-Function Block: '<S5>/S-Function1' (pf_lookup3) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[0];
    sfcnOutputs(rts, 0);
  }

  /* DataStoreWrite: '<S5>/Data Store Write' */
  memcpy(&t15_2_DWork.scr_data[0], &t15_2_B.SFunction1[0], 6500U * sizeof(real_T));

  /* Level2 S-Function Block: '<S5>/S-Function2' (read_volt) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[1];
    sfcnOutputs(rts, 0);
  }

  /* DataStoreWrite: '<S5>/Data Store Write1' */
  memcpy(&t15_2_DWork.volt[0], &t15_2_B.SFunction2[0], 10000U * sizeof(real_T));

  /* Level2 S-Function Block: '<S5>/S-Function' (read_control_data2) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[2];
    sfcnOutputs(rts, 0);
  }

  /* DataStoreWrite: '<S5>/Data Store Write10' */
  t15_2_DWork.c_a_tpl1_eob = t15_2_B.SFunction[10];

  /* DataStoreWrite: '<S5>/Data Store Write11' */
  t15_2_DWork.c_a_tpl2 = t15_2_B.SFunction[11];

  /* DataStoreWrite: '<S5>/Data Store Write12' */
  t15_2_DWork.c_a_tpl_min = t15_2_B.SFunction[12];

  /* DataStoreWrite: '<S5>/Data Store Write13' */
  t15_2_DWork.y0 = t15_2_B.SFunction[13];

  /* DataStoreWrite: '<S5>/Data Store Write14' */
  t15_2_DWork.c1_y0 = t15_2_B.SFunction[14];

  /* DataStoreWrite: '<S5>/Data Store Write15' */
  t15_2_DWork.c2_y0 = t15_2_B.SFunction[15];

  /* DataStoreWrite: '<S5>/Data Store Write16' */
  t15_2_DWork.t_tran2D = t15_2_B.SFunction[16];

  /* DataStoreWrite: '<S5>/Data Store Write17' */
  t15_2_DWork.max_VS_lim = t15_2_B.SFunction[6];

  /* DataStoreWrite: '<S5>/Data Store Write18' */
  t15_2_DWork.k_g4 = t15_2_B.SFunction[7];

  /* DataStoreWrite: '<S5>/Data Store Write2' */
  t15_2_DWork.c_a_tpl1 = t15_2_B.SFunction[9];

  /* DataStoreWrite: '<S5>/Data Store Write3' */
  t15_2_DWork.tcont2 = t15_2_B.SFunction[0];

  /* DataStoreWrite: '<S5>/Data Store Write4' */
  t15_2_DWork.Ip_div = t15_2_B.SFunction[2];

  /* DataStoreWrite: '<S5>/Data Store Write5' */
  t15_2_DWork.ref_ramp = t15_2_B.SFunction[3];

  /* DataStoreWrite: '<S5>/Data Store Write6' */
  t15_2_DWork.dtcont2 = t15_2_B.SFunction[1];

  /* DataStoreWrite: '<S5>/Data Store Write7' */
  t15_2_DWork.Ip_rd = t15_2_B.SFunction[4];

  /* DataStoreWrite: '<S5>/Data Store Write8' */
  t15_2_DWork.trd_ref = t15_2_B.SFunction[5];

  /* DataStoreWrite: '<S5>/Data Store Write9' */
  t15_2_DWork.Time_stop = t15_2_B.SFunction[8];

  /* Gain: '<S5>/Time s' incorporates:
   *  Inport: '<Root>/In1'
   */
  t15_2_B.Times = t15_2_P.Times_Gain * t15_2_U.In1[8];

  /* Memory: '<S5>/Memory2' */
  t15_2_B.Memory2 = t15_2_DWork.Memory2_PreviousInput;

  /* Gain: '<S5>/-1' incorporates:
   *  Inport: '<Root>/In1'
   */
  t15_2_B.u = t15_2_P.u_Gain * t15_2_U.In1[3];

  /* Switch: '<S5>/Ip<1e-4 ' */
  if (t15_2_B.u > t15_2_P.Ip1e4_Threshold) {
    t15_2_B.Ip1e4 = t15_2_B.Memory2;
  } else {
    t15_2_B.Ip1e4 = t15_2_B.Times;
  }

  /* End of Switch: '<S5>/Ip<1e-4 ' */

  /* Sum: '<S5>/Sum2' incorporates:
   *  Constant: '<S5>/Constant4'
   */
  t15_2_B.Sum2 = t15_2_B.Ip1e4 + t15_2_P.Constant4_Value_n;

  /* RelationalOperator: '<S5>/Relational Operator' */
  t15_2_B.RelationalOperator_cw = (t15_2_B.Times >= t15_2_B.Sum2);

  /* Stop: '<S5>/Stop Simulation' */
  if (t15_2_B.RelationalOperator_cw) {
    rtmSetStopRequested(t15_2_M, 1);
  }

  /* End of Stop: '<S5>/Stop Simulation' */

  /* DataStoreRead: '<S5>/Data Store Read1' */
  t15_2_B.DataStoreRead1 = t15_2_DWork.Time_stop;

  /* RelationalOperator: '<S5>/Relational Operator1' */
  t15_2_B.RelationalOperator1_c = (t15_2_B.Times >= t15_2_B.DataStoreRead1);

  /* Stop: '<S5>/Stop Simulation1' */
  if (t15_2_B.RelationalOperator1_c) {
    rtmSetStopRequested(t15_2_M, 1);
  }

  /* End of Stop: '<S5>/Stop Simulation1' */

  /* Gain: '<S14>/1e-6' incorporates:
   *  Inport: '<Root>/In1'
   */
  t15_2_B.e6 = t15_2_P.e6_Gain * t15_2_U.In1[3];

  /* Gain: '<S14>/1e-6   ' incorporates:
   *  Inport: '<Root>/In2'
   */
  for (i = 0; i < 15; i++) {
    t15_2_B.e6_m[i] = t15_2_U.In2[i + 6] * t15_2_P.e6_Gain_l;
  }

  /* End of Gain: '<S14>/1e-6   ' */

  /* Memory: '<S18>/Memory1' */
  t15_2_B.Memory1 = t15_2_DWork.Memory1_PreviousInput;

  /* DataStoreRead: '<S18>/Data Store Read1' */
  t15_2_B.DataStoreRead1_j = t15_2_DWork.RupRd[4];

  /* Gain: '<S18>/1e-3' */
  t15_2_B.e3 = t15_2_P.e3_Gain * t15_2_B.DataStoreRead1_j;

  /* DataStoreRead: '<S18>/Data Store Read2' */
  t15_2_B.DataStoreRead2 = t15_2_DWork.ntur[2];

  /* Product: '<S18>/Product1' */
  t15_2_B.Product1 = t15_2_B.e3 * t15_2_B.DataStoreRead2;

  /* RelationalOperator: '<S18>/Relational Operator' */
  t15_2_B.RelationalOperator = (t15_2_B.e6_m[2] < t15_2_B.Product1);

  /* Memory: '<S26>/Memory' */
  t15_2_B.Memory = t15_2_DWork.Memory_PreviousInput;

  /* Logic: '<S26>/Logical Operator' */
  t15_2_B.LogicalOperator = ((t15_2_B.RelationalOperator != 0.0) ||
    (t15_2_B.Memory != 0.0));

  /* Switch: '<S18>/switch1' */
  if (t15_2_B.LogicalOperator >= t15_2_P.switch1_Threshold) {
    t15_2_B.switch1 = t15_2_B.Memory1;
  } else {
    t15_2_B.switch1 = t15_2_B.Times;
  }

  /* End of Switch: '<S18>/switch1' */

  /* Sum: '<S18>/Add2' */
  t15_2_B.Add2 = t15_2_B.switch1 - t15_2_B.Times;

  /* DataStoreRead: '<S18>/Data Store Read' */
  t15_2_B.DataStoreRead = t15_2_DWork.RupRd[1];

  /* Product: '<S18>/Product' */
  t15_2_B.Product = t15_2_B.Add2 / t15_2_B.DataStoreRead;

  /* Sum: '<S18>/Add1' incorporates:
   *  Constant: '<S18>/Constant4'
   */
  t15_2_B.Add1 = t15_2_B.Product + t15_2_P.Constant4_Value_j;

  /* Saturate: '<S18>/1 0' */
  u = t15_2_B.Add1;
  tmin = t15_2_P.u_LowerSat;
  u_0 = t15_2_P.u_UpperSat;
  if (u >= u_0) {
    t15_2_B.u_h = u_0;
  } else if (u <= tmin) {
    t15_2_B.u_h = tmin;
  } else {
    t15_2_B.u_h = u;
  }

  /* End of Saturate: '<S18>/1 0' */

  /* Memory: '<S19>/Memory1' */
  t15_2_B.Memory1_f = t15_2_DWork.Memory1_PreviousInput_e;

  /* Switch: '<S19>/c_eob' */
  if (t15_2_B.u_h >= t15_2_P.c_eob_Threshold_j) {
    for (i = 0; i < 500; i++) {
      /* DataStoreRead: '<S19>/Data Store Read1' */
      t15_2_B.DataStoreRead1_if[i] = t15_2_DWork.scr_data[13 * i + 1];

      /* DataStoreRead: '<S19>/Data Store Read' */
      t15_2_B.DataStoreRead_j4[i] = t15_2_DWork.scr_data[13 * i];
    }

    /* Dynamic Look-Up Table Block: '<S19>/Ipref'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.Ipref), &t15_2_B.DataStoreRead1_if[0],
                         t15_2_B.Times, &t15_2_B.DataStoreRead_j4[0], 499U);
    t15_2_B.c_eob = t15_2_B.Ipref;
  } else {
    t15_2_B.c_eob = t15_2_B.Memory1_f;
  }

  /* End of Switch: '<S19>/c_eob' */

  /* Product: '<S19>/Divide6' */
  t15_2_B.Divide6 = t15_2_B.c_eob * t15_2_B.u_h;

  /* Sum: '<S14>/Add1' */
  t15_2_B.Add1_a = t15_2_B.e6 - t15_2_B.Divide6;

  /* Level2 S-Function Block: '<S21>/S-Function1' (read_gaps) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[3];
    sfcnOutputs(rts, 0);
  }

  /* Gain: '<S23>/1e2' incorporates:
   *  Inport: '<Root>/In1'
   *  Inport: '<Root>/In2'
   */
  t15_2_B.e2[0] = t15_2_P.e2_Gain * t15_2_U.In2[0];
  t15_2_B.e2[1] = t15_2_P.e2_Gain * t15_2_U.In2[1];
  t15_2_B.e2[2] = t15_2_P.e2_Gain * t15_2_U.In1[6];
  t15_2_B.e2[3] = t15_2_P.e2_Gain * t15_2_U.In2[3];
  t15_2_B.e2[4] = t15_2_P.e2_Gain * t15_2_U.In1[0];
  t15_2_B.e2[5] = t15_2_P.e2_Gain * t15_2_U.In1[5];

  /* Level2 S-Function Block: '<S44>/S-Function1' (read_gaps) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[4];
    sfcnOutputs(rts, 0);
  }

  /* Memory: '<S44>/Memory2' */
  t15_2_B.Memory2_n = t15_2_DWork.Memory2_PreviousInput_o;

  /* Switch: '<S44>/c_eob  1' */
  if (t15_2_B.u_h >= t15_2_P.c_eob1_Threshold) {
    for (i = 0; i < 50; i++) {
      /* Selector: '<S44>/Selector' */
      t15_2_B.Selector_o[i] = t15_2_B.SFunction1_j[(i << 1) + 1];

      /* Selector: '<S44>/Selector1' */
      t15_2_B.Selector1_d[i] = t15_2_B.SFunction1_j[i << 1];
    }

    /* Dynamic Look-Up Table Block: '<S44>/g1ref'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.g1ref), &t15_2_B.Selector_o[0],
                         t15_2_B.Times, &t15_2_B.Selector1_d[0], 49U);
    t15_2_B.c_eob1 = t15_2_B.g1ref;
  } else {
    t15_2_B.c_eob1 = t15_2_B.Memory2_n;
  }

  /* End of Switch: '<S44>/c_eob  1' */

  /* Memory: '<S44>/Memory1' */
  t15_2_B.Memory1_n = t15_2_DWork.Memory1_PreviousInput_l;

  /* Switch: '<S44>/c_eob  ' */
  if (t15_2_B.u_h >= t15_2_P.c_eob_Threshold_g) {
    t15_2_B.c_eob_g = t15_2_B.Times;
  } else {
    t15_2_B.c_eob_g = t15_2_B.Memory1_n;
  }

  /* End of Switch: '<S44>/c_eob  ' */

  /* Level2 S-Function Block: '<S50>/S-Function1' (read_gaps_term) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[5];
    sfcnOutputs(rts, 0);
  }

  /* Switch: '<S44>/c_eob' */
  if (t15_2_B.u_h >= t15_2_P.c_eob_Threshold_b) {
    t15_2_B.c_eob_k = t15_2_B.c_eob1;
  } else {
    /* SignalConversion: '<S50>/TmpSignal ConversionAtg1_term,refInport3' */
    t15_2_B.TmpSignalConversionAtg1_termref[0] = t15_2_B.c_eob1;
    for (i = 0; i < 49; i++) {
      /* Selector: '<S50>/Selector' */
      t15_2_B.Selector_k[i] = t15_2_B.SFunction1_pi[((1 + i) << 1) + 1];
      t15_2_B.TmpSignalConversionAtg1_termref[i + 1] = t15_2_B.Selector_k[i];
    }

    /* End of SignalConversion: '<S50>/TmpSignal ConversionAtg1_term,refInport3' */

    /* DataStoreRead: '<S50>/Data Store Read1' */
    t15_2_B.DataStoreRead1_br = t15_2_DWork.trd_ref;

    /* DataStoreRead: '<S50>/Data Store Read' */
    t15_2_B.DataStoreRead_f2 = t15_2_DWork.RupRd[1];
    for (i = 0; i < 50; i++) {
      /* Selector: '<S50>/Selector1' */
      t15_2_B.Selector1_n[i] = t15_2_B.SFunction1_pi[i << 1];

      /* Product: '<S50>/Divide6' */
      t15_2_B.Divide6_b[i] = t15_2_B.Selector1_n[i] * t15_2_B.DataStoreRead_f2 /
        t15_2_B.DataStoreRead1_br;

      /* Sum: '<S50>/Add2' */
      t15_2_B.Add2_l[i] = t15_2_B.c_eob_g + t15_2_B.Divide6_b[i];
    }

    /* Dynamic Look-Up Table Block: '<S50>/g1_term,ref'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.g1_termref),
                         &t15_2_B.TmpSignalConversionAtg1_termref[0],
                         t15_2_B.Times, &t15_2_B.Add2_l[0], 49U);
    t15_2_B.c_eob_k = t15_2_B.g1_termref;
  }

  /* End of Switch: '<S44>/c_eob' */

  /* Sum: '<S23>/Add2' */
  t15_2_B.Add2_d = t15_2_B.e2[0] - t15_2_B.c_eob_k;

  /* Level2 S-Function Block: '<S40>/S-Function1' (read_gaps) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[6];
    sfcnOutputs(rts, 0);
  }

  /* Memory: '<S40>/Memory2' */
  t15_2_B.Memory2_l = t15_2_DWork.Memory2_PreviousInput_b;

  /* Switch: '<S40>/c_eob  1' */
  if (t15_2_B.u_h >= t15_2_P.c_eob1_Threshold_l) {
    for (i = 0; i < 50; i++) {
      /* Selector: '<S40>/Selector' */
      t15_2_B.Selector_ln[i] = t15_2_B.SFunction1_g[(i << 1) + 1];

      /* Selector: '<S40>/Selector1' */
      t15_2_B.Selector1_c[i] = t15_2_B.SFunction1_g[i << 1];
    }

    /* Dynamic Look-Up Table Block: '<S40>/g2ref'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.g2ref), &t15_2_B.Selector_ln[0],
                         t15_2_B.Times, &t15_2_B.Selector1_c[0], 49U);
    t15_2_B.c_eob1_f = t15_2_B.g2ref;
  } else {
    t15_2_B.c_eob1_f = t15_2_B.Memory2_l;
  }

  /* End of Switch: '<S40>/c_eob  1' */

  /* Memory: '<S40>/Memory1' */
  t15_2_B.Memory1_fz = t15_2_DWork.Memory1_PreviousInput_n;

  /* Switch: '<S40>/c_eob  ' */
  if (t15_2_B.u_h >= t15_2_P.c_eob_Threshold_jy) {
    t15_2_B.c_eob_kp = t15_2_B.Times;
  } else {
    t15_2_B.c_eob_kp = t15_2_B.Memory1_fz;
  }

  /* End of Switch: '<S40>/c_eob  ' */

  /* Level2 S-Function Block: '<S46>/S-Function1' (read_gaps_term) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[7];
    sfcnOutputs(rts, 0);
  }

  /* Switch: '<S40>/c_eob' */
  if (t15_2_B.u_h >= t15_2_P.c_eob_Threshold_n) {
    t15_2_B.c_eob_i = t15_2_B.c_eob1_f;
  } else {
    /* SignalConversion: '<S46>/TmpSignal ConversionAtg2_term,refInport3' */
    t15_2_B.TmpSignalConversionAtg2_termref[0] = t15_2_B.c_eob1_f;
    for (i = 0; i < 49; i++) {
      /* Selector: '<S46>/Selector' */
      t15_2_B.Selector_a[i] = t15_2_B.SFunction1_h[((1 + i) << 1) + 1];
      t15_2_B.TmpSignalConversionAtg2_termref[i + 1] = t15_2_B.Selector_a[i];
    }

    /* End of SignalConversion: '<S46>/TmpSignal ConversionAtg2_term,refInport3' */

    /* DataStoreRead: '<S46>/Data Store Read1' */
    t15_2_B.DataStoreRead1_ju3 = t15_2_DWork.trd_ref;

    /* DataStoreRead: '<S46>/Data Store Read' */
    t15_2_B.DataStoreRead_ky = t15_2_DWork.RupRd[1];
    for (i = 0; i < 50; i++) {
      /* Selector: '<S46>/Selector1' */
      t15_2_B.Selector1_e2[i] = t15_2_B.SFunction1_h[i << 1];

      /* Product: '<S46>/Divide6' */
      t15_2_B.Divide6_mi[i] = t15_2_B.Selector1_e2[i] * t15_2_B.DataStoreRead_ky
        / t15_2_B.DataStoreRead1_ju3;

      /* Sum: '<S46>/Add2' */
      t15_2_B.Add2_o[i] = t15_2_B.c_eob_kp + t15_2_B.Divide6_mi[i];
    }

    /* Dynamic Look-Up Table Block: '<S46>/g2_term,ref'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.g2_termref),
                         &t15_2_B.TmpSignalConversionAtg2_termref[0],
                         t15_2_B.Times, &t15_2_B.Add2_o[0], 49U);
    t15_2_B.c_eob_i = t15_2_B.g2_termref;
  }

  /* End of Switch: '<S40>/c_eob' */

  /* Sum: '<S23>/Add1' */
  t15_2_B.Add1_l = t15_2_B.e2[1] - t15_2_B.c_eob_i;

  /* DataStoreRead: '<S23>/Data Store Read1' */
  t15_2_B.DataStoreRead1_jr = t15_2_DWork.RupRd[3];

  /* RelationalOperator: '<S23>/Relational Operator2' */
  t15_2_B.RelationalOperator2 = (t15_2_B.Times < t15_2_B.DataStoreRead1_jr);

  /* Level2 S-Function Block: '<S41>/S-Function1' (read_gaps) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[8];
    sfcnOutputs(rts, 0);
  }

  /* Memory: '<S41>/Memory2' */
  t15_2_B.Memory2_i = t15_2_DWork.Memory2_PreviousInput_e;

  /* Switch: '<S41>/c_eob  1' */
  if (t15_2_B.u_h >= t15_2_P.c_eob1_Threshold_l0) {
    for (i = 0; i < 50; i++) {
      /* Selector: '<S41>/Selector' */
      t15_2_B.Selector_pi[i] = t15_2_B.SFunction1_k[(i << 1) + 1];

      /* Selector: '<S41>/Selector1' */
      t15_2_B.Selector1_j[i] = t15_2_B.SFunction1_k[i << 1];
    }

    /* Dynamic Look-Up Table Block: '<S41>/g3ref'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.g3ref), &t15_2_B.Selector_pi[0],
                         t15_2_B.Times, &t15_2_B.Selector1_j[0], 49U);
    t15_2_B.c_eob1_fq = t15_2_B.g3ref;
  } else {
    t15_2_B.c_eob1_fq = t15_2_B.Memory2_i;
  }

  /* End of Switch: '<S41>/c_eob  1' */

  /* Memory: '<S41>/Memory1' */
  t15_2_B.Memory1_o = t15_2_DWork.Memory1_PreviousInput_e4;

  /* Switch: '<S41>/c_eob  ' */
  if (t15_2_B.u_h >= t15_2_P.c_eob_Threshold_m) {
    t15_2_B.c_eob_d = t15_2_B.Times;
  } else {
    t15_2_B.c_eob_d = t15_2_B.Memory1_o;
  }

  /* End of Switch: '<S41>/c_eob  ' */

  /* Level2 S-Function Block: '<S47>/S-Function1' (read_gaps_term) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[9];
    sfcnOutputs(rts, 0);
  }

  /* Switch: '<S41>/c_eob' */
  if (t15_2_B.u_h >= t15_2_P.c_eob_Threshold_je) {
    t15_2_B.c_eob_b = t15_2_B.c_eob1_fq;
  } else {
    /* SignalConversion: '<S47>/TmpSignal ConversionAtg3_term,refInport3' */
    t15_2_B.TmpSignalConversionAtg3_termref[0] = t15_2_B.c_eob1_fq;
    for (i = 0; i < 49; i++) {
      /* Selector: '<S47>/Selector' */
      t15_2_B.Selector_d[i] = t15_2_B.SFunction1_g0[((1 + i) << 1) + 1];
      t15_2_B.TmpSignalConversionAtg3_termref[i + 1] = t15_2_B.Selector_d[i];
    }

    /* End of SignalConversion: '<S47>/TmpSignal ConversionAtg3_term,refInport3' */

    /* DataStoreRead: '<S47>/Data Store Read1' */
    t15_2_B.DataStoreRead1_hgi = t15_2_DWork.trd_ref;

    /* DataStoreRead: '<S47>/Data Store Read' */
    t15_2_B.DataStoreRead_i4 = t15_2_DWork.RupRd[1];
    for (i = 0; i < 50; i++) {
      /* Selector: '<S47>/Selector1' */
      t15_2_B.Selector1_ee[i] = t15_2_B.SFunction1_g0[i << 1];

      /* Product: '<S47>/Divide6' */
      t15_2_B.Divide6_i[i] = t15_2_B.Selector1_ee[i] * t15_2_B.DataStoreRead_i4 /
        t15_2_B.DataStoreRead1_hgi;

      /* Sum: '<S47>/Add2' */
      t15_2_B.Add2_dp[i] = t15_2_B.c_eob_d + t15_2_B.Divide6_i[i];
    }

    /* Dynamic Look-Up Table Block: '<S47>/g3_term,ref'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.g3_termref),
                         &t15_2_B.TmpSignalConversionAtg3_termref[0],
                         t15_2_B.Times, &t15_2_B.Add2_dp[0], 49U);
    t15_2_B.c_eob_b = t15_2_B.g3_termref;
  }

  /* End of Switch: '<S41>/c_eob' */

  /* Sum: '<S23>/Add3' */
  t15_2_B.Add3 = t15_2_B.e2[2] - t15_2_B.c_eob_b;

  /* Product: '<S23>/Divide2' */
  t15_2_B.Divide2 = t15_2_B.RelationalOperator2 * t15_2_B.Add3;

  /* Level2 S-Function Block: '<S42>/S-Function1' (read_gaps) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[10];
    sfcnOutputs(rts, 0);
  }

  /* Memory: '<S42>/Memory2' */
  t15_2_B.Memory2_ib = t15_2_DWork.Memory2_PreviousInput_od;

  /* Switch: '<S42>/c_eob  1' */
  if (t15_2_B.u_h >= t15_2_P.c_eob1_Threshold_b) {
    for (i = 0; i < 50; i++) {
      /* Selector: '<S42>/Selector' */
      t15_2_B.Selector_h[i] = t15_2_B.SFunction1_h5[(i << 1) + 1];

      /* Selector: '<S42>/Selector1' */
      t15_2_B.Selector1_o[i] = t15_2_B.SFunction1_h5[i << 1];
    }

    /* Dynamic Look-Up Table Block: '<S42>/g4ref'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.g4ref), &t15_2_B.Selector_h[0],
                         t15_2_B.Times, &t15_2_B.Selector1_o[0], 49U);
    t15_2_B.c_eob1_o = t15_2_B.g4ref;
  } else {
    t15_2_B.c_eob1_o = t15_2_B.Memory2_ib;
  }

  /* End of Switch: '<S42>/c_eob  1' */

  /* Memory: '<S42>/Memory1' */
  t15_2_B.Memory1_oa = t15_2_DWork.Memory1_PreviousInput_p;

  /* Switch: '<S42>/c_eob  ' */
  if (t15_2_B.u_h >= t15_2_P.c_eob_Threshold_l) {
    t15_2_B.c_eob_ka = t15_2_B.Times;
  } else {
    t15_2_B.c_eob_ka = t15_2_B.Memory1_oa;
  }

  /* End of Switch: '<S42>/c_eob  ' */

  /* Level2 S-Function Block: '<S48>/S-Function1' (read_gaps_term) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[11];
    sfcnOutputs(rts, 0);
  }

  /* Switch: '<S42>/c_eob' */
  if (t15_2_B.u_h >= t15_2_P.c_eob_Threshold_h) {
    t15_2_B.c_eob_c = t15_2_B.c_eob1_o;
  } else {
    /* SignalConversion: '<S48>/TmpSignal ConversionAtg4_term,refInport3' */
    t15_2_B.TmpSignalConversionAtg4_termref[0] = t15_2_B.c_eob1_o;
    for (i = 0; i < 49; i++) {
      /* Selector: '<S48>/Selector' */
      t15_2_B.Selector_l[i] = t15_2_B.SFunction1_o[((1 + i) << 1) + 1];
      t15_2_B.TmpSignalConversionAtg4_termref[i + 1] = t15_2_B.Selector_l[i];
    }

    /* End of SignalConversion: '<S48>/TmpSignal ConversionAtg4_term,refInport3' */

    /* DataStoreRead: '<S48>/Data Store Read1' */
    t15_2_B.DataStoreRead1_ju = t15_2_DWork.trd_ref;

    /* DataStoreRead: '<S48>/Data Store Read' */
    t15_2_B.DataStoreRead_a0 = t15_2_DWork.RupRd[1];
    for (i = 0; i < 50; i++) {
      /* Selector: '<S48>/Selector1' */
      t15_2_B.Selector1_e[i] = t15_2_B.SFunction1_o[i << 1];

      /* Product: '<S48>/Divide6' */
      t15_2_B.Divide6_bs[i] = t15_2_B.Selector1_e[i] * t15_2_B.DataStoreRead_a0 /
        t15_2_B.DataStoreRead1_ju;

      /* Sum: '<S48>/Add2' */
      t15_2_B.Add2_mw[i] = t15_2_B.c_eob_ka + t15_2_B.Divide6_bs[i];
    }

    /* Dynamic Look-Up Table Block: '<S48>/g4_term,ref'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.g4_termref),
                         &t15_2_B.TmpSignalConversionAtg4_termref[0],
                         t15_2_B.Times, &t15_2_B.Add2_mw[0], 49U);
    t15_2_B.c_eob_c = t15_2_B.g4_termref;
  }

  /* End of Switch: '<S42>/c_eob' */

  /* Sum: '<S23>/Add4' */
  t15_2_B.Add4 = t15_2_B.e2[3] - t15_2_B.c_eob_c;

  /* DataStoreRead: '<S23>/Data Store Read' */
  t15_2_B.DataStoreRead_l = t15_2_DWork.t_tran2D;

  /* DataStoreRead: '<S23>/Data Store Read2' */
  t15_2_B.DataStoreRead2_h = t15_2_DWork.tcont2;

  /* MinMax: '<S23>/MinMax' */
  u = t15_2_B.DataStoreRead_l;
  tmin = t15_2_B.DataStoreRead2_h;
  if ((u >= tmin) || rtIsNaN(tmin)) {
    tmin = u;
  }

  t15_2_B.MinMax = tmin;

  /* End of MinMax: '<S23>/MinMax' */

  /* RelationalOperator: '<S23>/Relational Operator1' */
  t15_2_B.RelationalOperator1 = (t15_2_B.Times > t15_2_B.MinMax);

  /* Product: '<S23>/Divide12' */
  t15_2_B.Divide12 = t15_2_B.Add4 * t15_2_B.RelationalOperator1;

  /* Level2 S-Function Block: '<S45>/S-Function1' (read_gaps) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[12];
    sfcnOutputs(rts, 0);
  }

  /* Memory: '<S45>/Memory2' */
  t15_2_B.Memory2_h = t15_2_DWork.Memory2_PreviousInput_p;

  /* Switch: '<S45>/c_eob  1' */
  if (t15_2_B.u_h >= t15_2_P.c_eob1_Threshold_n) {
    for (i = 0; i < 50; i++) {
      /* Selector: '<S45>/Selector' */
      t15_2_B.Selector_e[i] = t15_2_B.SFunction1_d[(i << 1) + 1];

      /* Selector: '<S45>/Selector1' */
      t15_2_B.Selector1_i[i] = t15_2_B.SFunction1_d[i << 1];
    }

    /* Dynamic Look-Up Table Block: '<S45>/g5ref'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.g5ref), &t15_2_B.Selector_e[0],
                         t15_2_B.Times, &t15_2_B.Selector1_i[0], 49U);
    t15_2_B.c_eob1_oa = t15_2_B.g5ref;
  } else {
    t15_2_B.c_eob1_oa = t15_2_B.Memory2_h;
  }

  /* End of Switch: '<S45>/c_eob  1' */

  /* Memory: '<S45>/Memory1' */
  t15_2_B.Memory1_i = t15_2_DWork.Memory1_PreviousInput_j;

  /* Switch: '<S45>/c_eob  ' */
  if (t15_2_B.u_h >= t15_2_P.c_eob_Threshold_e) {
    t15_2_B.c_eob_m = t15_2_B.Times;
  } else {
    t15_2_B.c_eob_m = t15_2_B.Memory1_i;
  }

  /* End of Switch: '<S45>/c_eob  ' */

  /* Level2 S-Function Block: '<S51>/S-Function1' (read_gaps_term) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[13];
    sfcnOutputs(rts, 0);
  }

  /* Switch: '<S45>/c_eob' */
  if (t15_2_B.u_h >= t15_2_P.c_eob_Threshold_o) {
    t15_2_B.c_eob_i3 = t15_2_B.c_eob1_oa;
  } else {
    /* SignalConversion: '<S51>/TmpSignal ConversionAtg5_term,refInport3' */
    t15_2_B.TmpSignalConversionAtg5_termref[0] = t15_2_B.c_eob1_oa;
    for (i = 0; i < 49; i++) {
      /* Selector: '<S51>/Selector' */
      t15_2_B.Selector[i] = t15_2_B.SFunction1_ha[((1 + i) << 1) + 1];
      t15_2_B.TmpSignalConversionAtg5_termref[i + 1] = t15_2_B.Selector[i];
    }

    /* End of SignalConversion: '<S51>/TmpSignal ConversionAtg5_term,refInport3' */

    /* DataStoreRead: '<S51>/Data Store Read1' */
    t15_2_B.DataStoreRead1_f = t15_2_DWork.trd_ref;

    /* DataStoreRead: '<S51>/Data Store Read' */
    t15_2_B.DataStoreRead_lq = t15_2_DWork.RupRd[1];
    for (i = 0; i < 50; i++) {
      /* Selector: '<S51>/Selector1' */
      t15_2_B.Selector1[i] = t15_2_B.SFunction1_ha[i << 1];

      /* Product: '<S51>/Divide6' */
      t15_2_B.Divide6_m[i] = t15_2_B.Selector1[i] * t15_2_B.DataStoreRead_lq /
        t15_2_B.DataStoreRead1_f;

      /* Sum: '<S51>/Add2' */
      t15_2_B.Add2_fd[i] = t15_2_B.c_eob_m + t15_2_B.Divide6_m[i];
    }

    /* Dynamic Look-Up Table Block: '<S51>/g5_term,ref'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.g5_termref),
                         &t15_2_B.TmpSignalConversionAtg5_termref[0],
                         t15_2_B.Times, &t15_2_B.Add2_fd[0], 49U);
    t15_2_B.c_eob_i3 = t15_2_B.g5_termref;
  }

  /* End of Switch: '<S45>/c_eob' */

  /* Sum: '<S23>/Add5' */
  t15_2_B.Add5 = t15_2_B.c_eob_i3 - t15_2_B.e2[4];

  /* Level2 S-Function Block: '<S43>/S-Function1' (read_gaps) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[14];
    sfcnOutputs(rts, 0);
  }

  /* Memory: '<S43>/Memory2' */
  t15_2_B.Memory2_j = t15_2_DWork.Memory2_PreviousInput_n;

  /* Switch: '<S43>/c_eob  1' */
  if (t15_2_B.u_h >= t15_2_P.c_eob1_Threshold_l3) {
    for (i = 0; i < 50; i++) {
      /* Selector: '<S43>/Selector' */
      t15_2_B.Selector_n[i] = t15_2_B.SFunction1_m[(i << 1) + 1];

      /* Selector: '<S43>/Selector1' */
      t15_2_B.Selector1_h[i] = t15_2_B.SFunction1_m[i << 1];
    }

    /* Dynamic Look-Up Table Block: '<S43>/g6ref'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.g6ref), &t15_2_B.Selector_n[0],
                         t15_2_B.Times, &t15_2_B.Selector1_h[0], 49U);
    t15_2_B.c_eob1_m = t15_2_B.g6ref;
  } else {
    t15_2_B.c_eob1_m = t15_2_B.Memory2_j;
  }

  /* End of Switch: '<S43>/c_eob  1' */

  /* Memory: '<S43>/Memory1' */
  t15_2_B.Memory1_oo = t15_2_DWork.Memory1_PreviousInput_a;

  /* Switch: '<S43>/c_eob  ' */
  if (t15_2_B.u_h >= t15_2_P.c_eob_Threshold_o0) {
    t15_2_B.c_eob_i4 = t15_2_B.Times;
  } else {
    t15_2_B.c_eob_i4 = t15_2_B.Memory1_oo;
  }

  /* End of Switch: '<S43>/c_eob  ' */

  /* Level2 S-Function Block: '<S49>/S-Function1' (read_gaps_term) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[15];
    sfcnOutputs(rts, 0);
  }

  /* Switch: '<S43>/c_eob' */
  if (t15_2_B.u_h >= t15_2_P.c_eob_Threshold_lo) {
    t15_2_B.c_eob_l = t15_2_B.c_eob1_m;
  } else {
    /* SignalConversion: '<S49>/TmpSignal ConversionAtg6_term,refInport3' */
    t15_2_B.TmpSignalConversionAtg6_termref[0] = t15_2_B.c_eob1_m;
    for (i = 0; i < 49; i++) {
      /* Selector: '<S49>/Selector' */
      t15_2_B.Selector_p[i] = t15_2_B.SFunction1_ke[((1 + i) << 1) + 1];
      t15_2_B.TmpSignalConversionAtg6_termref[i + 1] = t15_2_B.Selector_p[i];
    }

    /* End of SignalConversion: '<S49>/TmpSignal ConversionAtg6_term,refInport3' */

    /* DataStoreRead: '<S49>/Data Store Read1' */
    t15_2_B.DataStoreRead1_m = t15_2_DWork.trd_ref;

    /* DataStoreRead: '<S49>/Data Store Read' */
    t15_2_B.DataStoreRead_hm = t15_2_DWork.RupRd[1];
    for (i = 0; i < 50; i++) {
      /* Selector: '<S49>/Selector1' */
      t15_2_B.Selector1_b[i] = t15_2_B.SFunction1_ke[i << 1];

      /* Product: '<S49>/Divide6' */
      t15_2_B.Divide6_f[i] = t15_2_B.Selector1_b[i] * t15_2_B.DataStoreRead_hm /
        t15_2_B.DataStoreRead1_m;

      /* Sum: '<S49>/Add2' */
      t15_2_B.Add2_m[i] = t15_2_B.c_eob_i4 + t15_2_B.Divide6_f[i];
    }

    /* Dynamic Look-Up Table Block: '<S49>/g6_term,ref'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.g6_termref),
                         &t15_2_B.TmpSignalConversionAtg6_termref[0],
                         t15_2_B.Times, &t15_2_B.Add2_m[0], 49U);
    t15_2_B.c_eob_l = t15_2_B.g6_termref;
  }

  /* End of Switch: '<S43>/c_eob' */

  /* Sum: '<S23>/Add6' */
  t15_2_B.Add6 = t15_2_B.e2[5] - t15_2_B.c_eob_l;

  /* Product: '<S23>/Divide1' */
  t15_2_B.Divide1 = t15_2_B.Add6 * t15_2_B.RelationalOperator1;

  /* Gain: '<S23>/1e-2' */
  t15_2_B.e2_l[0] = t15_2_P.e2_Gain_j * t15_2_B.Add2_d;
  t15_2_B.e2_l[1] = t15_2_P.e2_Gain_j * t15_2_B.Add1_l;
  t15_2_B.e2_l[2] = t15_2_P.e2_Gain_j * t15_2_B.Divide2;
  t15_2_B.e2_l[3] = t15_2_P.e2_Gain_j * t15_2_B.Divide12;
  t15_2_B.e2_l[4] = t15_2_P.e2_Gain_j * t15_2_B.Add5;
  t15_2_B.e2_l[5] = t15_2_P.e2_Gain_j * t15_2_B.Divide1;

  /* Memory: '<S29>/Memory2' */
  t15_2_B.Memory2_o = t15_2_DWork.Memory2_PreviousInput_e2;

  /* Switch: '<S29>/c_eob' */
  if (t15_2_B.u_h >= t15_2_P.c_eob_Threshold_d) {
    for (i = 0; i < 500; i++) {
      /* DataStoreRead: '<S29>/Data Store Read1' */
      t15_2_B.DataStoreRead1_gv[i] = t15_2_DWork.scr_data[13 * i + 2];

      /* DataStoreRead: '<S29>/Data Store Read' */
      t15_2_B.DataStoreRead_iz[i] = t15_2_DWork.scr_data[13 * i];
    }

    /* Dynamic Look-Up Table Block: '<S29>/I1'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.I1_l), &t15_2_B.DataStoreRead1_gv[0],
                         t15_2_B.Times, &t15_2_B.DataStoreRead_iz[0], 499U);
    t15_2_B.c_eob_im = t15_2_B.I1_l;
  } else {
    t15_2_B.c_eob_im = t15_2_B.Memory2_o;
  }

  /* End of Switch: '<S29>/c_eob' */

  /* Product: '<S29>/Divide1' */
  t15_2_B.Divide1_g = t15_2_B.c_eob_im * t15_2_B.u_h;

  /* Sum: '<S22>/Add3' */
  t15_2_B.Add3_n = t15_2_B.e6_m[0] - t15_2_B.Divide1_g;

  /* Memory: '<S32>/Memory2' */
  t15_2_B.Memory2_li = t15_2_DWork.Memory2_PreviousInput_nv;

  /* Switch: '<S32>/c_eob' */
  if (t15_2_B.u_h >= t15_2_P.c_eob_Threshold_p) {
    for (i = 0; i < 500; i++) {
      /* DataStoreRead: '<S32>/Data Store Read1' */
      t15_2_B.DataStoreRead1_bh[i] = t15_2_DWork.scr_data[13 * i + 3];

      /* DataStoreRead: '<S32>/Data Store Read' */
      t15_2_B.DataStoreRead_hg[i] = t15_2_DWork.scr_data[13 * i];
    }

    /* Dynamic Look-Up Table Block: '<S32>/I1'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.I1_oi), &t15_2_B.DataStoreRead1_bh[0],
                         t15_2_B.Times, &t15_2_B.DataStoreRead_hg[0], 499U);
    t15_2_B.c_eob_j = t15_2_B.I1_oi;
  } else {
    t15_2_B.c_eob_j = t15_2_B.Memory2_li;
  }

  /* End of Switch: '<S32>/c_eob' */

  /* Product: '<S32>/Divide1' */
  t15_2_B.Divide1_d = t15_2_B.c_eob_j * t15_2_B.u_h;

  /* Sum: '<S22>/Add1' */
  t15_2_B.Add1_f = t15_2_B.e6_m[1] - t15_2_B.Divide1_d;

  /* Memory: '<S33>/Memory2' */
  t15_2_B.Memory2_a = t15_2_DWork.Memory2_PreviousInput_h;

  /* Switch: '<S33>/c_eob' */
  if (t15_2_B.u_h >= t15_2_P.c_eob_Threshold_d3) {
    for (i = 0; i < 500; i++) {
      /* DataStoreRead: '<S33>/Data Store Read1' */
      t15_2_B.DataStoreRead1_fb[i] = t15_2_DWork.scr_data[13 * i + 4];

      /* DataStoreRead: '<S33>/Data Store Read' */
      t15_2_B.DataStoreRead_ku[i] = t15_2_DWork.scr_data[13 * i];
    }

    /* Dynamic Look-Up Table Block: '<S33>/I1'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.I1_h), &t15_2_B.DataStoreRead1_fb[0],
                         t15_2_B.Times, &t15_2_B.DataStoreRead_ku[0], 499U);
    t15_2_B.c_eob_n = t15_2_B.I1_h;
  } else {
    t15_2_B.c_eob_n = t15_2_B.Memory2_a;
  }

  /* End of Switch: '<S33>/c_eob' */

  /* Product: '<S33>/Divide1' */
  t15_2_B.Divide1_n = t15_2_B.c_eob_n * t15_2_B.u_h;

  /* Sum: '<S22>/Add2' */
  t15_2_B.Add2_a = t15_2_B.e6_m[2] - t15_2_B.Divide1_n;

  /* Memory: '<S34>/Memory2' */
  t15_2_B.Memory2_p = t15_2_DWork.Memory2_PreviousInput_l;

  /* Switch: '<S34>/c_eob' */
  if (t15_2_B.u_h >= t15_2_P.c_eob_Threshold_en) {
    for (i = 0; i < 500; i++) {
      /* DataStoreRead: '<S34>/Data Store Read1' */
      t15_2_B.DataStoreRead1_l[i] = t15_2_DWork.scr_data[13 * i + 5];

      /* DataStoreRead: '<S34>/Data Store Read' */
      t15_2_B.DataStoreRead_n5[i] = t15_2_DWork.scr_data[13 * i];
    }

    /* Dynamic Look-Up Table Block: '<S34>/I1'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.I1_n), &t15_2_B.DataStoreRead1_l[0],
                         t15_2_B.Times, &t15_2_B.DataStoreRead_n5[0], 499U);
    t15_2_B.c_eob_o = t15_2_B.I1_n;
  } else {
    t15_2_B.c_eob_o = t15_2_B.Memory2_p;
  }

  /* End of Switch: '<S34>/c_eob' */

  /* Product: '<S34>/Divide1' */
  t15_2_B.Divide1_h = t15_2_B.c_eob_o * t15_2_B.u_h;

  /* Sum: '<S22>/Add4' */
  t15_2_B.Add4_b = t15_2_B.e6_m[3] - t15_2_B.Divide1_h;

  /* Memory: '<S35>/Memory2' */
  t15_2_B.Memory2_o2 = t15_2_DWork.Memory2_PreviousInput_pa;

  /* Switch: '<S35>/c_eob' */
  if (t15_2_B.u_h >= t15_2_P.c_eob_Threshold_mf) {
    for (i = 0; i < 500; i++) {
      /* DataStoreRead: '<S35>/Data Store Read1' */
      t15_2_B.DataStoreRead1_bue[i] = t15_2_DWork.scr_data[13 * i + 6];

      /* DataStoreRead: '<S35>/Data Store Read' */
      t15_2_B.DataStoreRead_do[i] = t15_2_DWork.scr_data[13 * i];
    }

    /* Dynamic Look-Up Table Block: '<S35>/I1'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.I1_f), &t15_2_B.DataStoreRead1_bue[0],
                         t15_2_B.Times, &t15_2_B.DataStoreRead_do[0], 499U);
    t15_2_B.c_eob_e = t15_2_B.I1_f;
  } else {
    t15_2_B.c_eob_e = t15_2_B.Memory2_o2;
  }

  /* End of Switch: '<S35>/c_eob' */

  /* Product: '<S35>/Divide1' */
  t15_2_B.Divide1_p = t15_2_B.c_eob_e * t15_2_B.u_h;

  /* Sum: '<S22>/Add5' */
  t15_2_B.Add5_i = t15_2_B.e6_m[4] - t15_2_B.Divide1_p;

  /* Memory: '<S36>/Memory2' */
  t15_2_B.Memory2_hs = t15_2_DWork.Memory2_PreviousInput_j;

  /* Switch: '<S36>/c_eob' */
  if (t15_2_B.u_h >= t15_2_P.c_eob_Threshold_l0) {
    for (i = 0; i < 500; i++) {
      /* DataStoreRead: '<S36>/Data Store Read1' */
      t15_2_B.DataStoreRead1_az[i] = t15_2_DWork.scr_data[13 * i + 7];

      /* DataStoreRead: '<S36>/Data Store Read' */
      t15_2_B.DataStoreRead_oa[i] = t15_2_DWork.scr_data[13 * i];
    }

    /* Dynamic Look-Up Table Block: '<S36>/I1'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.I1_a), &t15_2_B.DataStoreRead1_az[0],
                         t15_2_B.Times, &t15_2_B.DataStoreRead_oa[0], 499U);
    t15_2_B.c_eob_f = t15_2_B.I1_a;
  } else {
    t15_2_B.c_eob_f = t15_2_B.Memory2_hs;
  }

  /* End of Switch: '<S36>/c_eob' */

  /* Product: '<S36>/Divide1' */
  t15_2_B.Divide1_nx = t15_2_B.c_eob_f * t15_2_B.u_h;

  /* Sum: '<S22>/Add6' */
  t15_2_B.Add6_a = t15_2_B.e6_m[5] - t15_2_B.Divide1_nx;

  /* Memory: '<S37>/Memory2' */
  t15_2_B.Memory2_at = t15_2_DWork.Memory2_PreviousInput_bt;

  /* Switch: '<S37>/c_eob' */
  if (t15_2_B.u_h >= t15_2_P.c_eob_Threshold_mb) {
    for (i = 0; i < 500; i++) {
      /* DataStoreRead: '<S37>/Data Store Read1' */
      t15_2_B.DataStoreRead1_gn[i] = t15_2_DWork.scr_data[13 * i + 8];

      /* DataStoreRead: '<S37>/Data Store Read' */
      t15_2_B.DataStoreRead_np[i] = t15_2_DWork.scr_data[13 * i];
    }

    /* Dynamic Look-Up Table Block: '<S37>/I1'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.I1_o), &t15_2_B.DataStoreRead1_gn[0],
                         t15_2_B.Times, &t15_2_B.DataStoreRead_np[0], 499U);
    t15_2_B.c_eob_cz = t15_2_B.I1_o;
  } else {
    t15_2_B.c_eob_cz = t15_2_B.Memory2_at;
  }

  /* End of Switch: '<S37>/c_eob' */

  /* Product: '<S37>/Divide1' */
  t15_2_B.Divide1_l = t15_2_B.c_eob_cz * t15_2_B.u_h;

  /* Sum: '<S22>/Add7' */
  t15_2_B.Add7 = t15_2_B.e6_m[6] - t15_2_B.Divide1_l;

  /* Memory: '<S38>/Memory2' */
  t15_2_B.Memory2_b = t15_2_DWork.Memory2_PreviousInput_i;

  /* Switch: '<S38>/c_eob' */
  if (t15_2_B.u_h >= t15_2_P.c_eob_Threshold_js) {
    for (i = 0; i < 500; i++) {
      /* DataStoreRead: '<S38>/Data Store Read1' */
      t15_2_B.DataStoreRead1_f0[i] = t15_2_DWork.scr_data[13 * i + 9];

      /* DataStoreRead: '<S38>/Data Store Read' */
      t15_2_B.DataStoreRead_o[i] = t15_2_DWork.scr_data[13 * i];
    }

    /* Dynamic Look-Up Table Block: '<S38>/I1'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.I1_i), &t15_2_B.DataStoreRead1_f0[0],
                         t15_2_B.Times, &t15_2_B.DataStoreRead_o[0], 499U);
    t15_2_B.c_eob_g2 = t15_2_B.I1_i;
  } else {
    t15_2_B.c_eob_g2 = t15_2_B.Memory2_b;
  }

  /* End of Switch: '<S38>/c_eob' */

  /* Product: '<S38>/Divide1' */
  t15_2_B.Divide1_m = t15_2_B.c_eob_g2 * t15_2_B.u_h;

  /* Sum: '<S22>/Add8' */
  t15_2_B.Add8 = t15_2_B.e6_m[7] - t15_2_B.Divide1_m;

  /* Memory: '<S39>/Memory2' */
  t15_2_B.Memory2_i2 = t15_2_DWork.Memory2_PreviousInput_iw;

  /* Switch: '<S39>/c_eob' */
  if (t15_2_B.u_h >= t15_2_P.c_eob_Threshold_h1) {
    for (i = 0; i < 500; i++) {
      /* DataStoreRead: '<S39>/Data Store Read1' */
      t15_2_B.DataStoreRead1_ce[i] = t15_2_DWork.scr_data[13 * i + 10];

      /* DataStoreRead: '<S39>/Data Store Read' */
      t15_2_B.DataStoreRead_m[i] = t15_2_DWork.scr_data[13 * i];
    }

    /* Dynamic Look-Up Table Block: '<S39>/I1'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.I1), &t15_2_B.DataStoreRead1_ce[0],
                         t15_2_B.Times, &t15_2_B.DataStoreRead_m[0], 499U);
    t15_2_B.c_eob_bq = t15_2_B.I1;
  } else {
    t15_2_B.c_eob_bq = t15_2_B.Memory2_i2;
  }

  /* End of Switch: '<S39>/c_eob' */

  /* Product: '<S39>/Divide1' */
  t15_2_B.Divide1_j = t15_2_B.c_eob_bq * t15_2_B.u_h;

  /* Sum: '<S22>/Add9' */
  t15_2_B.Add9 = t15_2_B.e6_m[8] - t15_2_B.Divide1_j;

  /* Memory: '<S30>/Memory2' */
  t15_2_B.Memory2_oz = t15_2_DWork.Memory2_PreviousInput_oh;

  /* Switch: '<S30>/c_eob' */
  if (t15_2_B.u_h >= t15_2_P.c_eob_Threshold_i) {
    for (i = 0; i < 500; i++) {
      /* DataStoreRead: '<S30>/Data Store Read1' */
      t15_2_B.DataStoreRead1_g4[i] = t15_2_DWork.scr_data[13 * i + 11];

      /* DataStoreRead: '<S30>/Data Store Read' */
      t15_2_B.DataStoreRead_bo[i] = t15_2_DWork.scr_data[13 * i];
    }

    /* Dynamic Look-Up Table Block: '<S30>/I1'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.I1_oj), &t15_2_B.DataStoreRead1_g4[0],
                         t15_2_B.Times, &t15_2_B.DataStoreRead_bo[0], 499U);
    t15_2_B.c_eob_kx = t15_2_B.I1_oj;
  } else {
    t15_2_B.c_eob_kx = t15_2_B.Memory2_oz;
  }

  /* End of Switch: '<S30>/c_eob' */

  /* Product: '<S30>/Divide1' */
  t15_2_B.Divide1_i = t15_2_B.c_eob_kx * t15_2_B.u_h;

  /* Sum: '<S22>/Add10' */
  t15_2_B.Add10 = t15_2_B.e6_m[9] - t15_2_B.Divide1_i;

  /* Memory: '<S31>/Memory2' */
  t15_2_B.Memory2_c = t15_2_DWork.Memory2_PreviousInput_nt;

  /* Switch: '<S31>/c_eob' */
  if (t15_2_B.u_h >= t15_2_P.c_eob_Threshold_pr) {
    for (i = 0; i < 500; i++) {
      /* DataStoreRead: '<S31>/Data Store Read1' */
      t15_2_B.DataStoreRead1_ov[i] = t15_2_DWork.scr_data[13 * i + 12];

      /* DataStoreRead: '<S31>/Data Store Read' */
      t15_2_B.DataStoreRead_c2[i] = t15_2_DWork.scr_data[13 * i];
    }

    /* Dynamic Look-Up Table Block: '<S31>/I1'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.I1_h0), &t15_2_B.DataStoreRead1_ov[0],
                         t15_2_B.Times, &t15_2_B.DataStoreRead_c2[0], 499U);
    t15_2_B.c_eob_dh = t15_2_B.I1_h0;
  } else {
    t15_2_B.c_eob_dh = t15_2_B.Memory2_c;
  }

  /* End of Switch: '<S31>/c_eob' */

  /* Product: '<S31>/Divide1' */
  t15_2_B.Divide1_a = t15_2_B.c_eob_dh * t15_2_B.u_h;

  /* Sum: '<S22>/Add11' */
  t15_2_B.Add11 = t15_2_B.e6_m[10] - t15_2_B.Divide1_a;

  /* DataStoreRead: '<S17>/Data Store Read1' */
  t15_2_B.DataStoreRead1_d = t15_2_DWork.Ip_div;

  /* RelationalOperator: '<S17>/Relational Operator' */
  t15_2_B.RelationalOperator_c = (t15_2_B.e6 > t15_2_B.DataStoreRead1_d);

  /* Memory: '<S25>/Memory' */
  t15_2_B.Memory_b = t15_2_DWork.Memory_PreviousInput_h;

  /* Logic: '<S25>/Logical Operator' */
  t15_2_B.LogicalOperator_f = ((t15_2_B.RelationalOperator_c != 0.0) ||
    (t15_2_B.Memory_b != 0.0));

  /* Switch: '<S17>/1' incorporates:
   *  Constant: '<S14>/Constant4'
   */
  if (t15_2_B.LogicalOperator_f >= t15_2_P._Threshold) {
    for (i = 0; i < 6; i++) {
      t15_2_B.u_g[i] = t15_2_B.e2_l[i];
    }

    t15_2_B.u_g[6] = t15_2_P.Constant4_Value_f;
    t15_2_B.u_g[7] = t15_2_B.Add1_a;
    t15_2_B.u_g[8] = t15_2_B.Add3_n;
    t15_2_B.u_g[9] = t15_2_B.Add1_f;
    t15_2_B.u_g[10] = t15_2_B.Add2_a;
    t15_2_B.u_g[11] = t15_2_B.Add4_b;
    t15_2_B.u_g[12] = t15_2_B.Add5_i;
    t15_2_B.u_g[13] = t15_2_B.Add6_a;
    t15_2_B.u_g[14] = t15_2_B.Add7;
    t15_2_B.u_g[15] = t15_2_B.Add8;
    t15_2_B.u_g[16] = t15_2_B.Add9;
    t15_2_B.u_g[17] = t15_2_B.Add10;
    t15_2_B.u_g[18] = t15_2_B.Add11;
    t15_2_B.u_g[19] = t15_2_P.Constant4_Value_f;
  } else {
    for (i = 0; i < 50; i++) {
      /* Selector: '<S21>/Selector' */
      t15_2_B.Selector_or[i] = t15_2_B.SFunction1_p[(i << 1) + 1];

      /* Selector: '<S21>/Selector1' */
      t15_2_B.Selector1_ip[i] = t15_2_B.SFunction1_p[i << 1];
    }

    /* Dynamic Look-Up Table Block: '<S21>/elong'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.elong), &t15_2_B.Selector_or[0],
                         t15_2_B.Times, &t15_2_B.Selector1_ip[0], 49U);

    /* Sum: '<S14>/Add2' incorporates:
     *  Inport: '<Root>/In1'
     */
    t15_2_B.Add2_g = t15_2_U.In1[2] - t15_2_B.elong;

    /* DataStoreRead: '<S24>/Data Store Read1' */
    t15_2_B.DataStoreRead1_ej = t15_2_DWork.k_g4;

    /* Product: '<S24>/Divide' incorporates:
     *  Constant: '<S24>/Constant1'
     *  Constant: '<S24>/Constant2'
     *  Constant: '<S24>/Constant4'
     */
    t15_2_B.Divide_g[0] = t15_2_B.e2_l[2] * t15_2_P.Constant4_Value;
    t15_2_B.Divide_g[1] = t15_2_B.e2_l[3] * t15_2_B.DataStoreRead1_ej;
    t15_2_B.Divide_g[2] = t15_2_B.e2_l[4] * t15_2_P.Constant1_Value;
    t15_2_B.Divide_g[3] = t15_2_B.e2_l[5] * t15_2_P.Constant2_Value;
    t15_2_B.u_g[0] = t15_2_B.Add2_g;
    t15_2_B.u_g[1] = t15_2_P.Constant4_Value_f;
    t15_2_B.u_g[2] = t15_2_B.Divide_g[0];
    t15_2_B.u_g[3] = t15_2_B.Divide_g[1];
    t15_2_B.u_g[4] = t15_2_B.Divide_g[2];
    t15_2_B.u_g[5] = t15_2_B.Divide_g[3];
    t15_2_B.u_g[6] = t15_2_P.Constant4_Value_f;
    t15_2_B.u_g[7] = t15_2_B.Add1_a;
    t15_2_B.u_g[8] = t15_2_B.Add3_n;
    t15_2_B.u_g[9] = t15_2_B.Add1_f;
    t15_2_B.u_g[10] = t15_2_B.Add2_a;
    t15_2_B.u_g[11] = t15_2_B.Add4_b;
    t15_2_B.u_g[12] = t15_2_B.Add5_i;
    t15_2_B.u_g[13] = t15_2_B.Add6_a;
    t15_2_B.u_g[14] = t15_2_B.Add7;
    t15_2_B.u_g[15] = t15_2_B.Add8;
    t15_2_B.u_g[16] = t15_2_B.Add9;
    t15_2_B.u_g[17] = t15_2_B.Add10;
    t15_2_B.u_g[18] = t15_2_B.Add11;
    t15_2_B.u_g[19] = t15_2_P.Constant4_Value_f;
  }

  /* End of Switch: '<S17>/1' */

  /* UnitDelay: '<S27>/UD' */
  t15_2_B.Uk1 = t15_2_DWork.UD_DSTATE;

  /* Sum: '<S27>/Diff' incorporates:
   *  Inport: '<Root>/In1'
   */
  t15_2_B.Diff = t15_2_U.In1[0] - t15_2_B.Uk1;

  /* UnitDelay: '<S28>/UD' */
  t15_2_B.Uk1_c = t15_2_DWork.UD_DSTATE_p;

  /* Sum: '<S28>/Diff' */
  t15_2_B.Diff_j = t15_2_B.Times - t15_2_B.Uk1_c;

  /* Product: '<S20>/Divide' */
  t15_2_B.Divide = t15_2_B.Diff / t15_2_B.Diff_j;

  /* DataStoreRead: '<S15>/Data Store Read' */
  t15_2_B.DataStoreRead_d = t15_2_DWork.c_a_tpl1_eob;

  /* Gain: '<S15>/ 1//15' */
  t15_2_B.u15 = t15_2_P.u15_Gain_o * t15_2_B.DataStoreRead_d;

  /* RelationalOperator: '<S68>/Compare' incorporates:
   *  Constant: '<S68>/Constant'
   */
  t15_2_B.Compare_i = (t15_2_B.u_h < t15_2_P.Constant_Value);

  /* DataStoreRead: '<S52>/Data Store Read' */
  t15_2_B.DataStoreRead_b = t15_2_DWork.ref_ramp;

  /* Memory: '<S52>/Memory3' */
  t15_2_B.Memory3 = t15_2_DWork.Memory3_PreviousInput;

  /* DataStoreRead: '<S69>/Data Store Read' */
  t15_2_B.DataStoreRead_f = t15_2_DWork.RupRd[2];

  /* Abs: '<S69>/Abs' */
  t15_2_B.Abs = fabs(t15_2_B.DataStoreRead_f);

  /* RelationalOperator: '<S69>/Relational Operator' */
  t15_2_B.RelationalOperator_b = (t15_2_B.e6 < t15_2_B.Abs);

  /* Logic: '<S52>/Logical Operator1' */
  t15_2_B.LogicalOperator1 = (t15_2_B.RelationalOperator_b && t15_2_B.Compare_i);

  /* Switch: '<S52>/switch1 ' */
  if (t15_2_B.LogicalOperator1 >= t15_2_P.switch1_Threshold_i) {
    t15_2_B.switch1_j = t15_2_B.Memory3;
  } else {
    t15_2_B.switch1_j = t15_2_B.Times;
  }

  /* End of Switch: '<S52>/switch1 ' */

  /* Sum: '<S52>/Subtract2' */
  t15_2_B.Subtract2 = t15_2_B.switch1_j - t15_2_B.Times;

  /* Product: '<S52>/Divide1' */
  t15_2_B.Divide1_b = 1.0 / t15_2_B.DataStoreRead_b * t15_2_B.Subtract2;

  /* Sum: '<S52>/Subtract1' incorporates:
   *  Constant: '<S52>/1'
   */
  t15_2_B.Subtract1 = t15_2_B.Divide1_b + t15_2_P._Value_cr;

  /* Saturate: '<S52>/Saturation1' */
  u = t15_2_B.Subtract1;
  tmin = t15_2_P.Saturation1_LowerSat_c;
  u_0 = t15_2_P.Saturation1_UpperSat_o;
  if (u >= u_0) {
    t15_2_B.Saturation1 = u_0;
  } else if (u <= tmin) {
    t15_2_B.Saturation1 = tmin;
  } else {
    t15_2_B.Saturation1 = u;
  }

  /* End of Saturate: '<S52>/Saturation1' */

  /* Memory: '<S52>/Memory1' */
  memcpy(&t15_2_B.Memory1_a[0], &t15_2_DWork.Memory1_PreviousInput_k[0], 11U *
         sizeof(real_T));

  /* Memory: '<S64>/Memory1' */
  t15_2_B.Memory1_nc = t15_2_DWork.Memory1_PreviousInput_a0;

  /* Switch: '<S64>/c_eob' */
  if (t15_2_B.u_h >= t15_2_P.c_eob_Threshold_c) {
    t15_2_B.c_eob_kh = t15_2_B.e6;
  } else {
    t15_2_B.c_eob_kh = t15_2_B.Memory1_nc;
  }

  /* End of Switch: '<S64>/c_eob' */

  /* Switch: '<S15>/c_eob' */
  if (t15_2_B.u_h >= t15_2_P.c_eob_Threshold_ov) {
    /* DataStoreRead: '<S15>/Data Store Read2' */
    t15_2_B.DataStoreRead2_l = t15_2_DWork.c_a_tpl2;

    /* Gain: '<S15>/ 1//15 ' */
    t15_2_B.u15_g = t15_2_P.u15_Gain * t15_2_B.DataStoreRead2_l;

    /* Product: '<S15>/Divide9' */
    t15_2_B.Divide9 = t15_2_B.e6 * t15_2_B.u15_g;

    /* Saturate: '<S15>/Saturation' */
    u = t15_2_B.Divide9;
    tmin = t15_2_P.Saturation_LowerSat;
    u_0 = t15_2_P.Saturation_UpperSat;
    if (u >= u_0) {
      t15_2_B.Saturation_p = u_0;
    } else if (u <= tmin) {
      t15_2_B.Saturation_p = tmin;
    } else {
      t15_2_B.Saturation_p = u;
    }

    /* End of Saturate: '<S15>/Saturation' */
    t15_2_B.c_eob_kz = t15_2_B.Saturation_p;
  } else {
    /* DataStoreRead: '<S64>/Data Store Read2' */
    t15_2_B.DataStoreRead2_la = t15_2_DWork.y0;

    /* Sum: '<S64>/Sum3' incorporates:
     *  Constant: '<S64>/2'
     */
    t15_2_B.Sum3_l = t15_2_P._Value - t15_2_B.DataStoreRead2_la;

    /* DataStoreRead: '<S64>/Data Store Read4' */
    t15_2_B.DataStoreRead4_e = t15_2_DWork.c2_y0;

    /* DataStoreRead: '<S64>/Data Store Read3' */
    t15_2_B.DataStoreRead3_k = t15_2_DWork.c1_y0;

    /* Sum: '<S64>/Sum2' */
    t15_2_B.Sum2_a = t15_2_B.DataStoreRead4_e - t15_2_B.DataStoreRead3_k;

    /* Product: '<S64>/Divide1' */
    t15_2_B.Divide1_c = 1.0 / t15_2_B.Sum2_a * t15_2_B.Sum3_l;

    /* Product: '<S64>/Divide6' */
    t15_2_B.Divide6_h = t15_2_B.c_eob_kh * t15_2_B.u_h;

    /* Sum: '<S64>/Sum' */
    t15_2_B.Sum = t15_2_B.Divide6_h - t15_2_B.DataStoreRead3_k;

    /* Product: '<S64>/Divide2' */
    t15_2_B.Divide2_h = t15_2_B.Sum * t15_2_B.Divide1_c;

    /* Sum: '<S64>/Sum1' */
    t15_2_B.Sum1_o = t15_2_B.Divide2_h + t15_2_B.DataStoreRead2_la;

    /* RelationalOperator: '<S84>/LowerRelop1' incorporates:
     *  Constant: '<S64>/1'
     */
    t15_2_B.LowerRelop1_f = (t15_2_B.Sum1_o > t15_2_P._Value_i);

    /* Switch: '<S84>/Switch2' incorporates:
     *  Constant: '<S64>/1'
     */
    if (t15_2_B.LowerRelop1_f) {
      t15_2_B.Switch2_d = t15_2_P._Value_i;
    } else {
      /* RelationalOperator: '<S84>/UpperRelop' */
      t15_2_B.UpperRelop_i = (t15_2_B.Sum1_o < t15_2_B.DataStoreRead2_la);

      /* Switch: '<S84>/Switch' */
      if (t15_2_B.UpperRelop_i) {
        t15_2_B.Switch_g = t15_2_B.DataStoreRead2_la;
      } else {
        t15_2_B.Switch_g = t15_2_B.Sum1_o;
      }

      /* End of Switch: '<S84>/Switch' */
      t15_2_B.Switch2_d = t15_2_B.Switch_g;
    }

    /* End of Switch: '<S84>/Switch2' */
    t15_2_B.c_eob_kz = t15_2_B.Switch2_d;
  }

  /* End of Switch: '<S15>/c_eob' */

  /* DataStoreRead: '<S75>/Data Store Read' */
  t15_2_B.DataStoreRead_i = t15_2_DWork.tcont2;

  /* RelationalOperator: '<S75>/Relational Operator' */
  t15_2_B.RelationalOperator_l = (t15_2_B.Times > t15_2_B.DataStoreRead_i);

  /* Product: '<S75>/Divide12' */
  for (i = 0; i < 20; i++) {
    t15_2_B.Divide12_n[i] = t15_2_B.u_g[i] * (real_T)
      t15_2_B.RelationalOperator_l;
  }

  /* End of Product: '<S75>/Divide12' */

  /* DiscreteStateSpace: '<S55>/Lim. contr.' */
  {
    {
      static const int_T colCidxRow0[47] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 23, 24, 25, 27, 28, 29, 30,
        31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 };

      const int_T *pCidx = &colCidxRow0[0];
      const real_T *pC0 = t15_2_P.Limcontr_C;
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *y0 = &t15_2_B.Limcontr[0];
      int_T numNonZero = 46;
      *y0 = (*pC0++) * xd[*pCidx++];
      while (numNonZero--) {
        *y0 += (*pC0++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colDidxRow0[17] = { 0, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12,
        13, 14, 15, 16, 17, 18 };

      const int_T *pDidx = &colDidxRow0[0];
      const real_T *pD0 = t15_2_P.Limcontr_D;
      const real_T *u = &t15_2_B.Divide12_n[0];
      real_T *y0 = &t15_2_B.Limcontr[0];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *y0 += (*pD0++) * u[*pDidx++];
      }
    }

    {
      static const int_T colCidxRow1[47] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 23, 24, 25, 27, 28, 29, 30,
        31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 };

      const int_T *pCidx = &colCidxRow1[0];
      const real_T *pC47 = &t15_2_P.Limcontr_C[47];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *y1 = &t15_2_B.Limcontr[1];
      int_T numNonZero = 46;
      *y1 = (*pC47++) * xd[*pCidx++];
      while (numNonZero--) {
        *y1 += (*pC47++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colDidxRow1[17] = { 0, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12,
        13, 14, 15, 16, 17, 18 };

      const int_T *pDidx = &colDidxRow1[0];
      const real_T *pD17 = &t15_2_P.Limcontr_D[17];
      const real_T *u = &t15_2_B.Divide12_n[0];
      real_T *y1 = &t15_2_B.Limcontr[1];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *y1 += (*pD17++) * u[*pDidx++];
      }
    }

    {
      static const int_T colCidxRow2[47] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 23, 24, 25, 27, 28, 29, 30,
        31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 };

      const int_T *pCidx = &colCidxRow2[0];
      const real_T *pC94 = &t15_2_P.Limcontr_C[94];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *y2 = &t15_2_B.Limcontr[2];
      int_T numNonZero = 46;
      *y2 = (*pC94++) * xd[*pCidx++];
      while (numNonZero--) {
        *y2 += (*pC94++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colDidxRow2[17] = { 0, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12,
        13, 14, 15, 16, 17, 18 };

      const int_T *pDidx = &colDidxRow2[0];
      const real_T *pD34 = &t15_2_P.Limcontr_D[34];
      const real_T *u = &t15_2_B.Divide12_n[0];
      real_T *y2 = &t15_2_B.Limcontr[2];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *y2 += (*pD34++) * u[*pDidx++];
      }
    }

    {
      static const int_T colCidxRow3[47] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 23, 24, 25, 27, 28, 29, 30,
        31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 };

      const int_T *pCidx = &colCidxRow3[0];
      const real_T *pC141 = &t15_2_P.Limcontr_C[141];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *y3 = &t15_2_B.Limcontr[3];
      int_T numNonZero = 46;
      *y3 = (*pC141++) * xd[*pCidx++];
      while (numNonZero--) {
        *y3 += (*pC141++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colDidxRow3[17] = { 0, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12,
        13, 14, 15, 16, 17, 18 };

      const int_T *pDidx = &colDidxRow3[0];
      const real_T *pD51 = &t15_2_P.Limcontr_D[51];
      const real_T *u = &t15_2_B.Divide12_n[0];
      real_T *y3 = &t15_2_B.Limcontr[3];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *y3 += (*pD51++) * u[*pDidx++];
      }
    }

    {
      static const int_T colCidxRow4[47] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 23, 24, 25, 27, 28, 29, 30,
        31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 };

      const int_T *pCidx = &colCidxRow4[0];
      const real_T *pC188 = &t15_2_P.Limcontr_C[188];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *y4 = &t15_2_B.Limcontr[4];
      int_T numNonZero = 46;
      *y4 = (*pC188++) * xd[*pCidx++];
      while (numNonZero--) {
        *y4 += (*pC188++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colDidxRow4[17] = { 0, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12,
        13, 14, 15, 16, 17, 18 };

      const int_T *pDidx = &colDidxRow4[0];
      const real_T *pD68 = &t15_2_P.Limcontr_D[68];
      const real_T *u = &t15_2_B.Divide12_n[0];
      real_T *y4 = &t15_2_B.Limcontr[4];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *y4 += (*pD68++) * u[*pDidx++];
      }
    }

    {
      static const int_T colCidxRow5[47] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 23, 24, 25, 27, 28, 29, 30,
        31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 };

      const int_T *pCidx = &colCidxRow5[0];
      const real_T *pC235 = &t15_2_P.Limcontr_C[235];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *y5 = &t15_2_B.Limcontr[5];
      int_T numNonZero = 46;
      *y5 = (*pC235++) * xd[*pCidx++];
      while (numNonZero--) {
        *y5 += (*pC235++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colDidxRow5[17] = { 0, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12,
        13, 14, 15, 16, 17, 18 };

      const int_T *pDidx = &colDidxRow5[0];
      const real_T *pD85 = &t15_2_P.Limcontr_D[85];
      const real_T *u = &t15_2_B.Divide12_n[0];
      real_T *y5 = &t15_2_B.Limcontr[5];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *y5 += (*pD85++) * u[*pDidx++];
      }
    }

    {
      static const int_T colCidxRow6[47] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 23, 24, 25, 27, 28, 29, 30,
        31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 };

      const int_T *pCidx = &colCidxRow6[0];
      const real_T *pC282 = &t15_2_P.Limcontr_C[282];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *y6 = &t15_2_B.Limcontr[6];
      int_T numNonZero = 46;
      *y6 = (*pC282++) * xd[*pCidx++];
      while (numNonZero--) {
        *y6 += (*pC282++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colDidxRow6[17] = { 0, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12,
        13, 14, 15, 16, 17, 18 };

      const int_T *pDidx = &colDidxRow6[0];
      const real_T *pD102 = &t15_2_P.Limcontr_D[102];
      const real_T *u = &t15_2_B.Divide12_n[0];
      real_T *y6 = &t15_2_B.Limcontr[6];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *y6 += (*pD102++) * u[*pDidx++];
      }
    }

    {
      static const int_T colCidxRow7[47] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 23, 24, 25, 27, 28, 29, 30,
        31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 };

      const int_T *pCidx = &colCidxRow7[0];
      const real_T *pC329 = &t15_2_P.Limcontr_C[329];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *y7 = &t15_2_B.Limcontr[7];
      int_T numNonZero = 46;
      *y7 = (*pC329++) * xd[*pCidx++];
      while (numNonZero--) {
        *y7 += (*pC329++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colDidxRow7[17] = { 0, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12,
        13, 14, 15, 16, 17, 18 };

      const int_T *pDidx = &colDidxRow7[0];
      const real_T *pD119 = &t15_2_P.Limcontr_D[119];
      const real_T *u = &t15_2_B.Divide12_n[0];
      real_T *y7 = &t15_2_B.Limcontr[7];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *y7 += (*pD119++) * u[*pDidx++];
      }
    }

    {
      static const int_T colCidxRow8[47] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 23, 24, 25, 27, 28, 29, 30,
        31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 };

      const int_T *pCidx = &colCidxRow8[0];
      const real_T *pC376 = &t15_2_P.Limcontr_C[376];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *y8 = &t15_2_B.Limcontr[8];
      int_T numNonZero = 46;
      *y8 = (*pC376++) * xd[*pCidx++];
      while (numNonZero--) {
        *y8 += (*pC376++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colDidxRow8[17] = { 0, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12,
        13, 14, 15, 16, 17, 18 };

      const int_T *pDidx = &colDidxRow8[0];
      const real_T *pD136 = &t15_2_P.Limcontr_D[136];
      const real_T *u = &t15_2_B.Divide12_n[0];
      real_T *y8 = &t15_2_B.Limcontr[8];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *y8 += (*pD136++) * u[*pDidx++];
      }
    }

    {
      static const int_T colCidxRow9[47] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 23, 24, 25, 27, 28, 29, 30,
        31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 };

      const int_T *pCidx = &colCidxRow9[0];
      const real_T *pC423 = &t15_2_P.Limcontr_C[423];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *y9 = &t15_2_B.Limcontr[9];
      int_T numNonZero = 46;
      *y9 = (*pC423++) * xd[*pCidx++];
      while (numNonZero--) {
        *y9 += (*pC423++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colDidxRow9[17] = { 0, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12,
        13, 14, 15, 16, 17, 18 };

      const int_T *pDidx = &colDidxRow9[0];
      const real_T *pD153 = &t15_2_P.Limcontr_D[153];
      const real_T *u = &t15_2_B.Divide12_n[0];
      real_T *y9 = &t15_2_B.Limcontr[9];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *y9 += (*pD153++) * u[*pDidx++];
      }
    }

    {
      static const int_T colCidxRow10[47] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 23, 24, 25, 27, 28, 29, 30,
        31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 };

      const int_T *pCidx = &colCidxRow10[0];
      const real_T *pC470 = &t15_2_P.Limcontr_C[470];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *y10 = &t15_2_B.Limcontr[10];
      int_T numNonZero = 46;
      *y10 = (*pC470++) * xd[*pCidx++];
      while (numNonZero--) {
        *y10 += (*pC470++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colDidxRow10[17] = { 0, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12,
        13, 14, 15, 16, 17, 18 };

      const int_T *pDidx = &colDidxRow10[0];
      const real_T *pD170 = &t15_2_P.Limcontr_D[170];
      const real_T *u = &t15_2_B.Divide12_n[0];
      real_T *y10 = &t15_2_B.Limcontr[10];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *y10 += (*pD170++) * u[*pDidx++];
      }
    }
  }

  /* DiscreteStateSpace: '<S55>/Curr. contr.' */
  {
    {
      static const int_T colCidxRow0[11] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

      const int_T *pCidx = &colCidxRow0[0];
      const real_T *pC0 = t15_2_P.Currcontr_C;
      const real_T *xd = &t15_2_DWork.Currcontr_DSTATE[0];
      real_T *y0 = &t15_2_B.Currcontr[0];
      int_T numNonZero = 10;
      *y0 = (*pC0++) * xd[*pCidx++];
      while (numNonZero--) {
        *y0 += (*pC0++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colCidxRow1[11] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

      const int_T *pCidx = &colCidxRow1[0];
      const real_T *pC11 = &t15_2_P.Currcontr_C[11];
      const real_T *xd = &t15_2_DWork.Currcontr_DSTATE[0];
      real_T *y1 = &t15_2_B.Currcontr[1];
      int_T numNonZero = 10;
      *y1 = (*pC11++) * xd[*pCidx++];
      while (numNonZero--) {
        *y1 += (*pC11++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colCidxRow2[11] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

      const int_T *pCidx = &colCidxRow2[0];
      const real_T *pC22 = &t15_2_P.Currcontr_C[22];
      const real_T *xd = &t15_2_DWork.Currcontr_DSTATE[0];
      real_T *y2 = &t15_2_B.Currcontr[2];
      int_T numNonZero = 10;
      *y2 = (*pC22++) * xd[*pCidx++];
      while (numNonZero--) {
        *y2 += (*pC22++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colCidxRow3[11] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

      const int_T *pCidx = &colCidxRow3[0];
      const real_T *pC33 = &t15_2_P.Currcontr_C[33];
      const real_T *xd = &t15_2_DWork.Currcontr_DSTATE[0];
      real_T *y3 = &t15_2_B.Currcontr[3];
      int_T numNonZero = 10;
      *y3 = (*pC33++) * xd[*pCidx++];
      while (numNonZero--) {
        *y3 += (*pC33++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colCidxRow4[11] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

      const int_T *pCidx = &colCidxRow4[0];
      const real_T *pC44 = &t15_2_P.Currcontr_C[44];
      const real_T *xd = &t15_2_DWork.Currcontr_DSTATE[0];
      real_T *y4 = &t15_2_B.Currcontr[4];
      int_T numNonZero = 10;
      *y4 = (*pC44++) * xd[*pCidx++];
      while (numNonZero--) {
        *y4 += (*pC44++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colCidxRow5[11] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

      const int_T *pCidx = &colCidxRow5[0];
      const real_T *pC55 = &t15_2_P.Currcontr_C[55];
      const real_T *xd = &t15_2_DWork.Currcontr_DSTATE[0];
      real_T *y5 = &t15_2_B.Currcontr[5];
      int_T numNonZero = 10;
      *y5 = (*pC55++) * xd[*pCidx++];
      while (numNonZero--) {
        *y5 += (*pC55++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colCidxRow6[11] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

      const int_T *pCidx = &colCidxRow6[0];
      const real_T *pC66 = &t15_2_P.Currcontr_C[66];
      const real_T *xd = &t15_2_DWork.Currcontr_DSTATE[0];
      real_T *y6 = &t15_2_B.Currcontr[6];
      int_T numNonZero = 10;
      *y6 = (*pC66++) * xd[*pCidx++];
      while (numNonZero--) {
        *y6 += (*pC66++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colCidxRow7[11] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

      const int_T *pCidx = &colCidxRow7[0];
      const real_T *pC77 = &t15_2_P.Currcontr_C[77];
      const real_T *xd = &t15_2_DWork.Currcontr_DSTATE[0];
      real_T *y7 = &t15_2_B.Currcontr[7];
      int_T numNonZero = 10;
      *y7 = (*pC77++) * xd[*pCidx++];
      while (numNonZero--) {
        *y7 += (*pC77++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colCidxRow8[11] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

      const int_T *pCidx = &colCidxRow8[0];
      const real_T *pC88 = &t15_2_P.Currcontr_C[88];
      const real_T *xd = &t15_2_DWork.Currcontr_DSTATE[0];
      real_T *y8 = &t15_2_B.Currcontr[8];
      int_T numNonZero = 10;
      *y8 = (*pC88++) * xd[*pCidx++];
      while (numNonZero--) {
        *y8 += (*pC88++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colCidxRow9[11] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

      const int_T *pCidx = &colCidxRow9[0];
      const real_T *pC99 = &t15_2_P.Currcontr_C[99];
      const real_T *xd = &t15_2_DWork.Currcontr_DSTATE[0];
      real_T *y9 = &t15_2_B.Currcontr[9];
      int_T numNonZero = 10;
      *y9 = (*pC99++) * xd[*pCidx++];
      while (numNonZero--) {
        *y9 += (*pC99++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colCidxRow10[11] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

      const int_T *pCidx = &colCidxRow10[0];
      const real_T *pC110 = &t15_2_P.Currcontr_C[110];
      const real_T *xd = &t15_2_DWork.Currcontr_DSTATE[0];
      real_T *y10 = &t15_2_B.Currcontr[10];
      int_T numNonZero = 10;
      *y10 = (*pC110++) * xd[*pCidx++];
      while (numNonZero--) {
        *y10 += (*pC110++) * xd[*pCidx++];
      }
    }
  }

  /* DataStoreRead: '<S55>/Data Store Read2' */
  memcpy(&t15_2_B.DataStoreRead2_p[0], &t15_2_DWork.ntur[0], 11U * sizeof(real_T));

  /* Switch: '<S52>/switch1' */
  if (t15_2_B.LogicalOperator1 >= t15_2_P.switch1_Threshold_d) {
    memcpy(&t15_2_B.switch1_l[0], &t15_2_B.Memory1_a[0], 11U * sizeof(real_T));
  } else {
    /* DataStoreRead: '<S76>/Data Store Read' */
    t15_2_B.DataStoreRead_iq = t15_2_DWork.tcont2;

    /* RelationalOperator: '<S76>/Relational Operator' */
    t15_2_B.RelationalOperator_o = (t15_2_B.Times > t15_2_B.DataStoreRead_iq);

    /* Switch: '<S76>/1' */
    if (t15_2_B.RelationalOperator_o) {
      /* DataStoreRead: '<S74>/Data Store Read1' */
      t15_2_B.DataStoreRead1_g5 = t15_2_DWork.dtcont2;

      /* DataStoreRead: '<S74>/Data Store Read' */
      t15_2_B.DataStoreRead_ny = t15_2_DWork.tcont2;

      /* Sum: '<S74>/Subtract3' */
      t15_2_B.Subtract3_h = t15_2_B.Times - t15_2_B.DataStoreRead_ny;

      /* Product: '<S74>/Divide2' */
      t15_2_B.Divide2_k = t15_2_B.Subtract3_h / t15_2_B.DataStoreRead1_g5;

      /* Saturate: '<S74>/Saturation1' */
      u = t15_2_B.Divide2_k;
      tmin = t15_2_P.Saturation1_LowerSat;
      u_0 = t15_2_P.Saturation1_UpperSat;
      if (u >= u_0) {
        t15_2_B.Saturation1_c = u_0;
      } else if (u <= tmin) {
        t15_2_B.Saturation1_c = tmin;
      } else {
        t15_2_B.Saturation1_c = u;
      }

      /* End of Saturate: '<S74>/Saturation1' */

      /* Product: '<S55>/Divide ' */
      for (i = 0; i < 11; i++) {
        t15_2_B.Divide_d[i] = t15_2_B.c_eob_kz * t15_2_B.Limcontr[i] *
          t15_2_B.Saturation1_c;
        t15_2_B.u_m[i] = t15_2_B.Divide_d[i];
      }

      /* End of Product: '<S55>/Divide ' */
    } else {
      /* Product: '<S55>/Divide2' */
      for (i = 0; i < 11; i++) {
        t15_2_B.Divide2_c[i] = t15_2_B.Currcontr[i] / t15_2_B.DataStoreRead2_p[i];
        t15_2_B.u_m[i] = t15_2_B.Divide2_c[i];
      }

      /* End of Product: '<S55>/Divide2' */
    }

    /* End of Switch: '<S76>/1' */
    memcpy(&t15_2_B.switch1_l[0], &t15_2_B.u_m[0], 11U * sizeof(real_T));
  }

  /* End of Switch: '<S52>/switch1' */

  /* Sum: '<S52>/Subtract3' incorporates:
   *  Constant: '<S52>/1'
   */
  t15_2_B.Subtract3 = t15_2_P._Value_cr - t15_2_B.Saturation1;

  /* DataStoreRead: '<S53>/Data Store Read1' */
  t15_2_B.DataStoreRead1_b = t15_2_DWork.c_cur_max;

  /* DataStoreRead: '<S66>/Data Store Read' */
  t15_2_B.DataStoreRead_ia = t15_2_DWork.RupRd[2];

  /* Abs: '<S66>/Abs' */
  t15_2_B.Abs_d = fabs(t15_2_B.DataStoreRead_ia);

  /* RelationalOperator: '<S66>/Relational Operator' */
  t15_2_B.RelationalOperator_j = (t15_2_B.e6 < t15_2_B.Abs_d);

  /* RelationalOperator: '<S85>/Compare' incorporates:
   *  Constant: '<S85>/Constant'
   */
  t15_2_B.Compare_h = (t15_2_B.u_h < t15_2_P.Constant_Value_e);

  /* Logic: '<S66>/Logical Operator2' */
  t15_2_B.LogicalOperator2 = (t15_2_B.RelationalOperator_j && t15_2_B.Compare_h);
  for (i = 0; i < 11; i++) {
    /* Product: '<S52>/Divide5' */
    t15_2_B.Divide5[i] = t15_2_B.Saturation1 * t15_2_B.switch1_l[i];

    /* Gain: '<S53>/1e3' */
    t15_2_B.e3_p[i] = t15_2_P.e3_Gain_f * t15_2_B.e6_m[i];

    /* Abs: '<S53>/Abs' */
    t15_2_B.Abs_k[i] = fabs(t15_2_B.e3_p[i]);

    /* DataStoreRead: '<S15>/Data Store Read1' */
    t15_2_B.DataStoreRead1_d2[i] = t15_2_DWork.Imax[i];

    /* DataStoreRead: '<S53>/Data Store Read2' */
    t15_2_B.DataStoreRead2_d[i] = t15_2_DWork.ntur[i];

    /* Product: '<S53>/Divide5' */
    t15_2_B.Divide5_j[i] = t15_2_B.DataStoreRead1_d2[i] *
      t15_2_B.DataStoreRead2_d[i];

    /* Sum: '<S53>/Sum2' */
    t15_2_B.Sum2_p[i] = t15_2_B.Divide5_j[i] - t15_2_B.Abs_k[i];

    /* Product: '<S53>/Divide3' */
    t15_2_B.Divide3[i] = t15_2_B.Divide5_j[i] * t15_2_B.DataStoreRead1_b;

    /* Sum: '<S53>/Sum1' */
    t15_2_B.Sum1[i] = t15_2_B.Divide5_j[i] - t15_2_B.Divide3[i];

    /* Product: '<S53>/Divide4' */
    t15_2_B.Divide4[i] = t15_2_B.Sum2_p[i] / t15_2_B.Sum1[i];

    /* Product: '<S53>/Divide1' */
    t15_2_B.Divide1_gh[i] = t15_2_B.Divide4[i] * t15_2_B.Divide4[i] *
      t15_2_B.Divide4[i];

    /* Saturate: '<S53>/Saturation' */
    u = t15_2_B.Divide1_gh[i];
    tmin = t15_2_P.Saturation_LowerSat_p;
    u_0 = t15_2_P.Saturation_UpperSat_k;
    if (u >= u_0) {
      u = u_0;
    } else {
      if (u <= tmin) {
        u = tmin;
      }
    }

    t15_2_B.Saturation[i] = u;

    /* End of Saturate: '<S53>/Saturation' */

    /* RelationalOperator: '<S70>/Compare' incorporates:
     *  Constant: '<S70>/Constant'
     */
    t15_2_B.Compare[i] = (uint8_T)(t15_2_B.Saturation[i] <
      t15_2_P.Constant_Value_n);

    /* Memory: '<S66>/Memory1' */
    t15_2_B.Memory1_h[i] = t15_2_DWork.Memory1_PreviousInput_i[i];

    /* Memory: '<S58>/Memory' */
    t15_2_B.Memory_g[i] = t15_2_DWork.Memory_PreviousInput_o[i];
  }

  /* DataStoreRead: '<S58>/Data Store Read' */
  t15_2_B.DataStoreRead_bl = t15_2_DWork.Ip_rd;

  /* RelationalOperator: '<S58>/Relational Operator1' */
  t15_2_B.RelationalOperator1_g = (t15_2_B.e6 < t15_2_B.DataStoreRead_bl);

  /* RelationalOperator: '<S77>/Compare' incorporates:
   *  Constant: '<S77>/Constant'
   */
  t15_2_B.Compare_i0 = (t15_2_B.u_h < t15_2_P.Constant_Value_i);

  /* DataStoreRead: '<S58>/Data Store Read1' */
  t15_2_B.DataStoreRead1_jv = t15_2_DWork.RupRd[2];

  /* Abs: '<S58>/Abs' */
  t15_2_B.Abs_l = fabs(t15_2_B.DataStoreRead1_jv);

  /* RelationalOperator: '<S58>/Relational Operator' */
  t15_2_B.RelationalOperator_h = (t15_2_B.e6 > t15_2_B.Abs_l);

  /* Logic: '<S58>/Logical Operator1' */
  t15_2_B.LogicalOperator1_i = (t15_2_B.RelationalOperator1_g &&
    t15_2_B.Compare_i0 && t15_2_B.RelationalOperator_h);

  /* Product: '<S15>/Divide2' */
  for (i = 0; i < 20; i++) {
    t15_2_B.Divide2_a[i] = t15_2_B.LogicalOperator1 * t15_2_B.u_g[i];
  }

  /* End of Product: '<S15>/Divide2' */

  /* DiscreteStateSpace: '<S15>/Div. contr.' */
  {
    {
      static const int_T colCidxRow0[20] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19 };

      const int_T *pCidx = &colCidxRow0[0];
      const real_T *pC0 = t15_2_P.Divcontr_C;
      const real_T *xd = &t15_2_DWork.Divcontr_DSTATE[0];
      real_T *y0 = &t15_2_B.Divcontr[0];
      int_T numNonZero = 19;
      *y0 = (*pC0++) * xd[*pCidx++];
      while (numNonZero--) {
        *y0 += (*pC0++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colDidxRow0[17] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        13, 14, 15, 16, 17, 18 };

      const int_T *pDidx = &colDidxRow0[0];
      const real_T *pD0 = t15_2_P.Divcontr_D;
      const real_T *u = &t15_2_B.Divide2_a[0];
      real_T *y0 = &t15_2_B.Divcontr[0];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *y0 += (*pD0++) * u[*pDidx++];
      }
    }

    {
      static const int_T colCidxRow1[20] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19 };

      const int_T *pCidx = &colCidxRow1[0];
      const real_T *pC20 = &t15_2_P.Divcontr_C[20];
      const real_T *xd = &t15_2_DWork.Divcontr_DSTATE[0];
      real_T *y1 = &t15_2_B.Divcontr[1];
      int_T numNonZero = 19;
      *y1 = (*pC20++) * xd[*pCidx++];
      while (numNonZero--) {
        *y1 += (*pC20++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colDidxRow1[17] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        13, 14, 15, 16, 17, 18 };

      const int_T *pDidx = &colDidxRow1[0];
      const real_T *pD17 = &t15_2_P.Divcontr_D[17];
      const real_T *u = &t15_2_B.Divide2_a[0];
      real_T *y1 = &t15_2_B.Divcontr[1];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *y1 += (*pD17++) * u[*pDidx++];
      }
    }

    {
      static const int_T colCidxRow2[20] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19 };

      const int_T *pCidx = &colCidxRow2[0];
      const real_T *pC40 = &t15_2_P.Divcontr_C[40];
      const real_T *xd = &t15_2_DWork.Divcontr_DSTATE[0];
      real_T *y2 = &t15_2_B.Divcontr[2];
      int_T numNonZero = 19;
      *y2 = (*pC40++) * xd[*pCidx++];
      while (numNonZero--) {
        *y2 += (*pC40++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colDidxRow2[17] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        13, 14, 15, 16, 17, 18 };

      const int_T *pDidx = &colDidxRow2[0];
      const real_T *pD34 = &t15_2_P.Divcontr_D[34];
      const real_T *u = &t15_2_B.Divide2_a[0];
      real_T *y2 = &t15_2_B.Divcontr[2];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *y2 += (*pD34++) * u[*pDidx++];
      }
    }

    {
      static const int_T colCidxRow3[20] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19 };

      const int_T *pCidx = &colCidxRow3[0];
      const real_T *pC60 = &t15_2_P.Divcontr_C[60];
      const real_T *xd = &t15_2_DWork.Divcontr_DSTATE[0];
      real_T *y3 = &t15_2_B.Divcontr[3];
      int_T numNonZero = 19;
      *y3 = (*pC60++) * xd[*pCidx++];
      while (numNonZero--) {
        *y3 += (*pC60++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colDidxRow3[17] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        13, 14, 15, 16, 17, 18 };

      const int_T *pDidx = &colDidxRow3[0];
      const real_T *pD51 = &t15_2_P.Divcontr_D[51];
      const real_T *u = &t15_2_B.Divide2_a[0];
      real_T *y3 = &t15_2_B.Divcontr[3];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *y3 += (*pD51++) * u[*pDidx++];
      }
    }

    {
      static const int_T colCidxRow4[5] = { 20, 21, 22, 23, 24 };

      const int_T *pCidx = &colCidxRow4[0];
      const real_T *pC80 = &t15_2_P.Divcontr_C[80];
      const real_T *xd = &t15_2_DWork.Divcontr_DSTATE[0];
      real_T *y4 = &t15_2_B.Divcontr[4];
      int_T numNonZero = 4;
      *y4 = (*pC80++) * xd[*pCidx++];
      while (numNonZero--) {
        *y4 += (*pC80++) * xd[*pCidx++];
      }
    }

    t15_2_B.Divcontr[4] += (t15_2_P.Divcontr_D[68])*t15_2_B.Divide2_a[12];

    {
      static const int_T colCidxRow5[20] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19 };

      const int_T *pCidx = &colCidxRow5[0];
      const real_T *pC85 = &t15_2_P.Divcontr_C[85];
      const real_T *xd = &t15_2_DWork.Divcontr_DSTATE[0];
      real_T *y5 = &t15_2_B.Divcontr[5];
      int_T numNonZero = 19;
      *y5 = (*pC85++) * xd[*pCidx++];
      while (numNonZero--) {
        *y5 += (*pC85++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colDidxRow5[17] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        13, 14, 15, 16, 17, 18 };

      const int_T *pDidx = &colDidxRow5[0];
      const real_T *pD69 = &t15_2_P.Divcontr_D[69];
      const real_T *u = &t15_2_B.Divide2_a[0];
      real_T *y5 = &t15_2_B.Divcontr[5];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *y5 += (*pD69++) * u[*pDidx++];
      }
    }

    {
      static const int_T colCidxRow6[20] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19 };

      const int_T *pCidx = &colCidxRow6[0];
      const real_T *pC105 = &t15_2_P.Divcontr_C[105];
      const real_T *xd = &t15_2_DWork.Divcontr_DSTATE[0];
      real_T *y6 = &t15_2_B.Divcontr[6];
      int_T numNonZero = 19;
      *y6 = (*pC105++) * xd[*pCidx++];
      while (numNonZero--) {
        *y6 += (*pC105++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colDidxRow6[17] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        13, 14, 15, 16, 17, 18 };

      const int_T *pDidx = &colDidxRow6[0];
      const real_T *pD86 = &t15_2_P.Divcontr_D[86];
      const real_T *u = &t15_2_B.Divide2_a[0];
      real_T *y6 = &t15_2_B.Divcontr[6];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *y6 += (*pD86++) * u[*pDidx++];
      }
    }

    {
      static const int_T colCidxRow7[20] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19 };

      const int_T *pCidx = &colCidxRow7[0];
      const real_T *pC125 = &t15_2_P.Divcontr_C[125];
      const real_T *xd = &t15_2_DWork.Divcontr_DSTATE[0];
      real_T *y7 = &t15_2_B.Divcontr[7];
      int_T numNonZero = 19;
      *y7 = (*pC125++) * xd[*pCidx++];
      while (numNonZero--) {
        *y7 += (*pC125++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colDidxRow7[17] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        13, 14, 15, 16, 17, 18 };

      const int_T *pDidx = &colDidxRow7[0];
      const real_T *pD103 = &t15_2_P.Divcontr_D[103];
      const real_T *u = &t15_2_B.Divide2_a[0];
      real_T *y7 = &t15_2_B.Divcontr[7];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *y7 += (*pD103++) * u[*pDidx++];
      }
    }

    {
      static const int_T colCidxRow8[20] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19 };

      const int_T *pCidx = &colCidxRow8[0];
      const real_T *pC145 = &t15_2_P.Divcontr_C[145];
      const real_T *xd = &t15_2_DWork.Divcontr_DSTATE[0];
      real_T *y8 = &t15_2_B.Divcontr[8];
      int_T numNonZero = 19;
      *y8 = (*pC145++) * xd[*pCidx++];
      while (numNonZero--) {
        *y8 += (*pC145++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colDidxRow8[17] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        13, 14, 15, 16, 17, 18 };

      const int_T *pDidx = &colDidxRow8[0];
      const real_T *pD120 = &t15_2_P.Divcontr_D[120];
      const real_T *u = &t15_2_B.Divide2_a[0];
      real_T *y8 = &t15_2_B.Divcontr[8];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *y8 += (*pD120++) * u[*pDidx++];
      }
    }

    {
      static const int_T colCidxRow9[20] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19 };

      const int_T *pCidx = &colCidxRow9[0];
      const real_T *pC165 = &t15_2_P.Divcontr_C[165];
      const real_T *xd = &t15_2_DWork.Divcontr_DSTATE[0];
      real_T *y9 = &t15_2_B.Divcontr[9];
      int_T numNonZero = 19;
      *y9 = (*pC165++) * xd[*pCidx++];
      while (numNonZero--) {
        *y9 += (*pC165++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colDidxRow9[17] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        13, 14, 15, 16, 17, 18 };

      const int_T *pDidx = &colDidxRow9[0];
      const real_T *pD137 = &t15_2_P.Divcontr_D[137];
      const real_T *u = &t15_2_B.Divide2_a[0];
      real_T *y9 = &t15_2_B.Divcontr[9];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *y9 += (*pD137++) * u[*pDidx++];
      }
    }

    {
      static const int_T colCidxRow10[20] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19 };

      const int_T *pCidx = &colCidxRow10[0];
      const real_T *pC185 = &t15_2_P.Divcontr_C[185];
      const real_T *xd = &t15_2_DWork.Divcontr_DSTATE[0];
      real_T *y10 = &t15_2_B.Divcontr[10];
      int_T numNonZero = 19;
      *y10 = (*pC185++) * xd[*pCidx++];
      while (numNonZero--) {
        *y10 += (*pC185++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colDidxRow10[17] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        13, 14, 15, 16, 17, 18 };

      const int_T *pDidx = &colDidxRow10[0];
      const real_T *pD154 = &t15_2_P.Divcontr_D[154];
      const real_T *u = &t15_2_B.Divide2_a[0];
      real_T *y10 = &t15_2_B.Divcontr[10];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *y10 += (*pD154++) * u[*pDidx++];
      }
    }
  }

  for (i = 0; i < 11; i++) {
    /* Switch: '<S58>/0.1' */
    if (t15_2_B.LogicalOperator1_i >= t15_2_P.u_Threshold) {
      t15_2_B.u_e[i] = t15_2_B.Memory_g[i];
    } else {
      /* Product: '<S15>/Divide' */
      t15_2_B.Divide_c[i] = t15_2_B.c_eob_kz * t15_2_B.Divcontr[i] *
        t15_2_B.Subtract3;
      t15_2_B.u_e[i] = t15_2_B.Divide_c[i];
    }

    /* End of Switch: '<S58>/0.1' */
  }

  /* Memory: '<S62>/Memory1' */
  t15_2_B.Memory1_ih = t15_2_DWork.Memory1_PreviousInput_an;

  /* DataStoreRead: '<S62>/Data Store Read' */
  t15_2_B.DataStoreRead_a = t15_2_DWork.Ip_rd;

  /* RelationalOperator: '<S62>/Relational Operator1' */
  t15_2_B.RelationalOperator1_k5 = (t15_2_B.e6 < t15_2_B.DataStoreRead_a);

  /* RelationalOperator: '<S81>/Compare' incorporates:
   *  Constant: '<S81>/Constant'
   */
  t15_2_B.Compare_l = (t15_2_B.u_h < t15_2_P.Constant_Value_n5);

  /* Logic: '<S62>/Logical Operator1' */
  t15_2_B.LogicalOperator1_m = (t15_2_B.RelationalOperator1_k5 &&
    t15_2_B.Compare_l);

  /* Switch: '<S62>/switch1' */
  if (t15_2_B.LogicalOperator1_m >= t15_2_P.switch1_Threshold_c) {
    t15_2_B.switch1_m = t15_2_B.Memory1_ih;
  } else {
    t15_2_B.switch1_m = t15_2_B.Times;
  }

  /* End of Switch: '<S62>/switch1' */

  /* Product: '<S15>/Divide13' */
  for (i = 0; i < 20; i++) {
    t15_2_B.Divide13[i] = t15_2_B.Divide2_a[i] * t15_2_B.LogicalOperator1_m;
  }

  /* End of Product: '<S15>/Divide13' */

  /* DiscreteStateSpace: '<S15>/Div_rd contr' */
  {
    {
      static const int_T colCidxRow0[15] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14 };

      const int_T *pCidx = &colCidxRow0[0];
      const real_T *pC0 = t15_2_P.Div_rdcontr_C;
      const real_T *xd = &t15_2_DWork.Div_rdcontr_DSTATE[0];
      real_T *y0 = &t15_2_B.Div_rdcontr[0];
      int_T numNonZero = 14;
      *y0 = (*pC0++) * xd[*pCidx++];
      while (numNonZero--) {
        *y0 += (*pC0++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colDidxRow0[18] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        12, 13, 14, 15, 16, 17, 18 };

      const int_T *pDidx = &colDidxRow0[0];
      const real_T *pD0 = t15_2_P.Div_rdcontr_D;
      const real_T *u = &t15_2_B.Divide13[0];
      real_T *y0 = &t15_2_B.Div_rdcontr[0];
      int_T numNonZero = 18;
      while (numNonZero--) {
        *y0 += (*pD0++) * u[*pDidx++];
      }
    }

    {
      static const int_T colCidxRow1[15] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14 };

      const int_T *pCidx = &colCidxRow1[0];
      const real_T *pC15 = &t15_2_P.Div_rdcontr_C[15];
      const real_T *xd = &t15_2_DWork.Div_rdcontr_DSTATE[0];
      real_T *y1 = &t15_2_B.Div_rdcontr[1];
      int_T numNonZero = 14;
      *y1 = (*pC15++) * xd[*pCidx++];
      while (numNonZero--) {
        *y1 += (*pC15++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colDidxRow1[18] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        12, 13, 14, 15, 16, 17, 18 };

      const int_T *pDidx = &colDidxRow1[0];
      const real_T *pD18 = &t15_2_P.Div_rdcontr_D[18];
      const real_T *u = &t15_2_B.Divide13[0];
      real_T *y1 = &t15_2_B.Div_rdcontr[1];
      int_T numNonZero = 18;
      while (numNonZero--) {
        *y1 += (*pD18++) * u[*pDidx++];
      }
    }

    {
      static const int_T colCidxRow2[15] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14 };

      const int_T *pCidx = &colCidxRow2[0];
      const real_T *pC30 = &t15_2_P.Div_rdcontr_C[30];
      const real_T *xd = &t15_2_DWork.Div_rdcontr_DSTATE[0];
      real_T *y2 = &t15_2_B.Div_rdcontr[2];
      int_T numNonZero = 14;
      *y2 = (*pC30++) * xd[*pCidx++];
      while (numNonZero--) {
        *y2 += (*pC30++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colDidxRow2[18] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        12, 13, 14, 15, 16, 17, 18 };

      const int_T *pDidx = &colDidxRow2[0];
      const real_T *pD36 = &t15_2_P.Div_rdcontr_D[36];
      const real_T *u = &t15_2_B.Divide13[0];
      real_T *y2 = &t15_2_B.Div_rdcontr[2];
      int_T numNonZero = 18;
      while (numNonZero--) {
        *y2 += (*pD36++) * u[*pDidx++];
      }
    }

    {
      static const int_T colCidxRow3[15] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14 };

      const int_T *pCidx = &colCidxRow3[0];
      const real_T *pC45 = &t15_2_P.Div_rdcontr_C[45];
      const real_T *xd = &t15_2_DWork.Div_rdcontr_DSTATE[0];
      real_T *y3 = &t15_2_B.Div_rdcontr[3];
      int_T numNonZero = 14;
      *y3 = (*pC45++) * xd[*pCidx++];
      while (numNonZero--) {
        *y3 += (*pC45++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colDidxRow3[18] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        12, 13, 14, 15, 16, 17, 18 };

      const int_T *pDidx = &colDidxRow3[0];
      const real_T *pD54 = &t15_2_P.Div_rdcontr_D[54];
      const real_T *u = &t15_2_B.Divide13[0];
      real_T *y3 = &t15_2_B.Div_rdcontr[3];
      int_T numNonZero = 18;
      while (numNonZero--) {
        *y3 += (*pD54++) * u[*pDidx++];
      }
    }

    {
      static const int_T colCidxRow4[15] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14 };

      const int_T *pCidx = &colCidxRow4[0];
      const real_T *pC60 = &t15_2_P.Div_rdcontr_C[60];
      const real_T *xd = &t15_2_DWork.Div_rdcontr_DSTATE[0];
      real_T *y4 = &t15_2_B.Div_rdcontr[4];
      int_T numNonZero = 14;
      *y4 = (*pC60++) * xd[*pCidx++];
      while (numNonZero--) {
        *y4 += (*pC60++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colDidxRow4[18] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        12, 13, 14, 15, 16, 17, 18 };

      const int_T *pDidx = &colDidxRow4[0];
      const real_T *pD72 = &t15_2_P.Div_rdcontr_D[72];
      const real_T *u = &t15_2_B.Divide13[0];
      real_T *y4 = &t15_2_B.Div_rdcontr[4];
      int_T numNonZero = 18;
      while (numNonZero--) {
        *y4 += (*pD72++) * u[*pDidx++];
      }
    }

    {
      static const int_T colCidxRow5[15] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14 };

      const int_T *pCidx = &colCidxRow5[0];
      const real_T *pC75 = &t15_2_P.Div_rdcontr_C[75];
      const real_T *xd = &t15_2_DWork.Div_rdcontr_DSTATE[0];
      real_T *y5 = &t15_2_B.Div_rdcontr[5];
      int_T numNonZero = 14;
      *y5 = (*pC75++) * xd[*pCidx++];
      while (numNonZero--) {
        *y5 += (*pC75++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colDidxRow5[18] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        12, 13, 14, 15, 16, 17, 18 };

      const int_T *pDidx = &colDidxRow5[0];
      const real_T *pD90 = &t15_2_P.Div_rdcontr_D[90];
      const real_T *u = &t15_2_B.Divide13[0];
      real_T *y5 = &t15_2_B.Div_rdcontr[5];
      int_T numNonZero = 18;
      while (numNonZero--) {
        *y5 += (*pD90++) * u[*pDidx++];
      }
    }

    {
      static const int_T colCidxRow6[15] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14 };

      const int_T *pCidx = &colCidxRow6[0];
      const real_T *pC90 = &t15_2_P.Div_rdcontr_C[90];
      const real_T *xd = &t15_2_DWork.Div_rdcontr_DSTATE[0];
      real_T *y6 = &t15_2_B.Div_rdcontr[6];
      int_T numNonZero = 14;
      *y6 = (*pC90++) * xd[*pCidx++];
      while (numNonZero--) {
        *y6 += (*pC90++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colDidxRow6[18] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        12, 13, 14, 15, 16, 17, 18 };

      const int_T *pDidx = &colDidxRow6[0];
      const real_T *pD108 = &t15_2_P.Div_rdcontr_D[108];
      const real_T *u = &t15_2_B.Divide13[0];
      real_T *y6 = &t15_2_B.Div_rdcontr[6];
      int_T numNonZero = 18;
      while (numNonZero--) {
        *y6 += (*pD108++) * u[*pDidx++];
      }
    }

    {
      static const int_T colCidxRow7[15] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14 };

      const int_T *pCidx = &colCidxRow7[0];
      const real_T *pC105 = &t15_2_P.Div_rdcontr_C[105];
      const real_T *xd = &t15_2_DWork.Div_rdcontr_DSTATE[0];
      real_T *y7 = &t15_2_B.Div_rdcontr[7];
      int_T numNonZero = 14;
      *y7 = (*pC105++) * xd[*pCidx++];
      while (numNonZero--) {
        *y7 += (*pC105++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colDidxRow7[18] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        12, 13, 14, 15, 16, 17, 18 };

      const int_T *pDidx = &colDidxRow7[0];
      const real_T *pD126 = &t15_2_P.Div_rdcontr_D[126];
      const real_T *u = &t15_2_B.Divide13[0];
      real_T *y7 = &t15_2_B.Div_rdcontr[7];
      int_T numNonZero = 18;
      while (numNonZero--) {
        *y7 += (*pD126++) * u[*pDidx++];
      }
    }

    {
      static const int_T colCidxRow8[15] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14 };

      const int_T *pCidx = &colCidxRow8[0];
      const real_T *pC120 = &t15_2_P.Div_rdcontr_C[120];
      const real_T *xd = &t15_2_DWork.Div_rdcontr_DSTATE[0];
      real_T *y8 = &t15_2_B.Div_rdcontr[8];
      int_T numNonZero = 14;
      *y8 = (*pC120++) * xd[*pCidx++];
      while (numNonZero--) {
        *y8 += (*pC120++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colDidxRow8[18] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        12, 13, 14, 15, 16, 17, 18 };

      const int_T *pDidx = &colDidxRow8[0];
      const real_T *pD144 = &t15_2_P.Div_rdcontr_D[144];
      const real_T *u = &t15_2_B.Divide13[0];
      real_T *y8 = &t15_2_B.Div_rdcontr[8];
      int_T numNonZero = 18;
      while (numNonZero--) {
        *y8 += (*pD144++) * u[*pDidx++];
      }
    }

    {
      static const int_T colCidxRow9[15] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14 };

      const int_T *pCidx = &colCidxRow9[0];
      const real_T *pC135 = &t15_2_P.Div_rdcontr_C[135];
      const real_T *xd = &t15_2_DWork.Div_rdcontr_DSTATE[0];
      real_T *y9 = &t15_2_B.Div_rdcontr[9];
      int_T numNonZero = 14;
      *y9 = (*pC135++) * xd[*pCidx++];
      while (numNonZero--) {
        *y9 += (*pC135++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colDidxRow9[18] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        12, 13, 14, 15, 16, 17, 18 };

      const int_T *pDidx = &colDidxRow9[0];
      const real_T *pD162 = &t15_2_P.Div_rdcontr_D[162];
      const real_T *u = &t15_2_B.Divide13[0];
      real_T *y9 = &t15_2_B.Div_rdcontr[9];
      int_T numNonZero = 18;
      while (numNonZero--) {
        *y9 += (*pD162++) * u[*pDidx++];
      }
    }

    {
      static const int_T colCidxRow10[15] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14 };

      const int_T *pCidx = &colCidxRow10[0];
      const real_T *pC150 = &t15_2_P.Div_rdcontr_C[150];
      const real_T *xd = &t15_2_DWork.Div_rdcontr_DSTATE[0];
      real_T *y10 = &t15_2_B.Div_rdcontr[10];
      int_T numNonZero = 14;
      *y10 = (*pC150++) * xd[*pCidx++];
      while (numNonZero--) {
        *y10 += (*pC150++) * xd[*pCidx++];
      }
    }

    {
      static const int_T colDidxRow10[18] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        12, 13, 14, 15, 16, 17, 18 };

      const int_T *pDidx = &colDidxRow10[0];
      const real_T *pD180 = &t15_2_P.Div_rdcontr_D[180];
      const real_T *u = &t15_2_B.Divide13[0];
      real_T *y10 = &t15_2_B.Div_rdcontr[10];
      int_T numNonZero = 18;
      while (numNonZero--) {
        *y10 += (*pD180++) * u[*pDidx++];
      }
    }
  }

  /* Switch: '<S66>/1' */
  if (t15_2_B.LogicalOperator2 >= t15_2_P._Threshold_f) {
    memcpy(&t15_2_B.u_o[0], &t15_2_B.Memory1_h[0], 11U * sizeof(real_T));
  } else {
    /* Sum: '<S62>/Subtract2' */
    t15_2_B.Subtract2_f = t15_2_B.switch1_m - t15_2_B.Times;

    /* DataStoreRead: '<S62>/Data Store Read1' */
    t15_2_B.DataStoreRead1_a = t15_2_DWork.ref_ramp;

    /* Product: '<S62>/Divide4' */
    t15_2_B.Divide4_p = 1.0 / t15_2_B.DataStoreRead1_a * t15_2_B.Subtract2_f;

    /* Sum: '<S62>/Subtract3' incorporates:
     *  Constant: '<S62>/1'
     */
    t15_2_B.Subtract3_m = t15_2_B.Divide4_p + t15_2_P._Value_n;

    /* Saturate: '<S62>/Saturation' */
    u = t15_2_B.Subtract3_m;
    tmin = t15_2_P.Saturation_LowerSat_o;
    u_0 = t15_2_P.Saturation_UpperSat_d;
    if (u >= u_0) {
      t15_2_B.Saturation_c = u_0;
    } else if (u <= tmin) {
      t15_2_B.Saturation_c = tmin;
    } else {
      t15_2_B.Saturation_c = u;
    }

    /* End of Saturate: '<S62>/Saturation' */

    /* Sum: '<S62>/Subtract1' incorporates:
     *  Constant: '<S62>/1'
     */
    t15_2_B.Subtract1_c = t15_2_P._Value_n - t15_2_B.Saturation_c;
    for (i = 0; i < 11; i++) {
      /* Product: '<S15>/Divide3' */
      t15_2_B.Divide3_p[i] = t15_2_B.Div_rdcontr[i] * t15_2_B.c_eob_kz *
        t15_2_B.Subtract1_c;

      /* Product: '<S15>/Divide1' */
      t15_2_B.Divide1_he[i] = t15_2_B.u_e[i] * t15_2_B.Saturation_c;

      /* Sum: '<S15>/Sum2' */
      t15_2_B.Sum2_gz[i] = t15_2_B.Divide1_he[i] + t15_2_B.Divide3_p[i];
      t15_2_B.u_o[i] = t15_2_B.Sum2_gz[i];
    }
  }

  /* End of Switch: '<S66>/1' */

  /* DataStoreRead: '<S73>/Data Store Read' */
  t15_2_B.DataStoreRead_ft = t15_2_DWork.RupRd[2];

  /* Abs: '<S73>/Abs' */
  t15_2_B.Abs_b = fabs(t15_2_B.DataStoreRead_ft);

  /* RelationalOperator: '<S73>/Relational Operator' */
  t15_2_B.RelationalOperator_jt = (t15_2_B.e6 < t15_2_B.Abs_b);

  /* RelationalOperator: '<S72>/Compare' incorporates:
   *  Constant: '<S72>/Constant'
   */
  t15_2_B.Compare_hs = (t15_2_B.e6 < t15_2_P.Constant_Value_a);

  /* Logic: '<S54>/Logical Operator2' */
  t15_2_B.LogicalOperator2_c = (t15_2_B.RelationalOperator_jt &&
    t15_2_B.Compare_hs);

  /* Sum: '<S54>/Subtract4' incorporates:
   *  Constant: '<S54>/1'
   */
  t15_2_B.Subtract4 = t15_2_P._Value_e - t15_2_B.LogicalOperator2_c;

  /* DiscreteStateSpace: '<S15>/Curr. term. contr' */
  {
    t15_2_B.Currtermcontr[0] = (t15_2_P.Currtermcontr_C[0])*
      t15_2_DWork.Currtermcontr_DSTATE[0];
    t15_2_B.Currtermcontr[1] = (t15_2_P.Currtermcontr_C[1])*
      t15_2_DWork.Currtermcontr_DSTATE[1];
    t15_2_B.Currtermcontr[2] = (t15_2_P.Currtermcontr_C[2])*
      t15_2_DWork.Currtermcontr_DSTATE[2];
    t15_2_B.Currtermcontr[3] = (t15_2_P.Currtermcontr_C[3])*
      t15_2_DWork.Currtermcontr_DSTATE[3];
    t15_2_B.Currtermcontr[4] = (t15_2_P.Currtermcontr_C[4])*
      t15_2_DWork.Currtermcontr_DSTATE[4];
    t15_2_B.Currtermcontr[5] = (t15_2_P.Currtermcontr_C[5])*
      t15_2_DWork.Currtermcontr_DSTATE[5];
    t15_2_B.Currtermcontr[6] = (t15_2_P.Currtermcontr_C[6])*
      t15_2_DWork.Currtermcontr_DSTATE[6];
    t15_2_B.Currtermcontr[7] = (t15_2_P.Currtermcontr_C[7])*
      t15_2_DWork.Currtermcontr_DSTATE[7];
    t15_2_B.Currtermcontr[8] = (t15_2_P.Currtermcontr_C[8])*
      t15_2_DWork.Currtermcontr_DSTATE[8];
    t15_2_B.Currtermcontr[9] = (t15_2_P.Currtermcontr_C[9])*
      t15_2_DWork.Currtermcontr_DSTATE[9];
    t15_2_B.Currtermcontr[10] = (t15_2_P.Currtermcontr_C[10])*
      t15_2_DWork.Currtermcontr_DSTATE[10];
  }

  for (i = 0; i < 11; i++) {
    /* Product: '<S15>/Divide4' */
    t15_2_B.Divide4_b[i] = t15_2_B.u_o[i] * t15_2_B.Subtract4;

    /* Product: '<S15>/Divide5' */
    t15_2_B.Divide5_d[i] = t15_2_B.Currtermcontr[i] * t15_2_B.Subtract3;
  }

  for (i = 0; i < 500; i++) {
    /* DataStoreRead: '<S86>/Data Store Read' */
    t15_2_B.DataStoreRead_c[i] = t15_2_DWork.volt[20 * i];

    /* Gain: '<S86>/0.001' */
    t15_2_B.u01[i] = t15_2_P.u01_Gain * t15_2_B.DataStoreRead_c[i];

    /* DataStoreRead: '<S86>/Data Store Read1' */
    t15_2_B.DataStoreRead1_dx[i] = t15_2_DWork.volt[20 * i + 1];

    /* DataStoreRead: '<S89>/Data Store Read' */
    t15_2_B.DataStoreRead_dx[i] = t15_2_DWork.volt[20 * i];

    /* Gain: '<S89>/0.001' */
    t15_2_B.u01_a[i] = t15_2_P.u01_Gain_k * t15_2_B.DataStoreRead_dx[i];

    /* DataStoreRead: '<S89>/Data Store Read1' */
    t15_2_B.DataStoreRead1_h[i] = t15_2_DWork.volt[20 * i + 2];

    /* DataStoreRead: '<S90>/Data Store Read' */
    t15_2_B.DataStoreRead_j[i] = t15_2_DWork.volt[20 * i];

    /* Gain: '<S90>/0.001' */
    t15_2_B.u01_i[i] = t15_2_P.u01_Gain_p * t15_2_B.DataStoreRead_j[i];

    /* DataStoreRead: '<S90>/Data Store Read1' */
    t15_2_B.DataStoreRead1_p[i] = t15_2_DWork.volt[20 * i + 3];

    /* DataStoreRead: '<S91>/Data Store Read' */
    t15_2_B.DataStoreRead_ck[i] = t15_2_DWork.volt[20 * i];

    /* Gain: '<S91>/0.001' */
    t15_2_B.u01_c[i] = t15_2_P.u01_Gain_pa * t15_2_B.DataStoreRead_ck[i];

    /* DataStoreRead: '<S91>/Data Store Read1' */
    t15_2_B.DataStoreRead1_g[i] = t15_2_DWork.volt[20 * i + 4];

    /* DataStoreRead: '<S92>/Data Store Read' */
    t15_2_B.DataStoreRead_h[i] = t15_2_DWork.volt[20 * i];

    /* Gain: '<S92>/0.001' */
    t15_2_B.u01_p[i] = t15_2_P.u01_Gain_l * t15_2_B.DataStoreRead_h[i];

    /* DataStoreRead: '<S92>/Data Store Read1' */
    t15_2_B.DataStoreRead1_bu[i] = t15_2_DWork.volt[20 * i + 5];

    /* DataStoreRead: '<S93>/Data Store Read' */
    t15_2_B.DataStoreRead_be[i] = t15_2_DWork.volt[20 * i];

    /* Gain: '<S93>/0.001' */
    t15_2_B.u01_o[i] = t15_2_P.u01_Gain_pt * t15_2_B.DataStoreRead_be[i];

    /* DataStoreRead: '<S93>/Data Store Read1' */
    t15_2_B.DataStoreRead1_i[i] = t15_2_DWork.volt[20 * i + 6];

    /* DataStoreRead: '<S94>/Data Store Read' */
    t15_2_B.DataStoreRead_e[i] = t15_2_DWork.volt[20 * i];

    /* Gain: '<S94>/0.001' */
    t15_2_B.u01_k[i] = t15_2_P.u01_Gain_kk * t15_2_B.DataStoreRead_e[i];

    /* DataStoreRead: '<S94>/Data Store Read1' */
    t15_2_B.DataStoreRead1_o[i] = t15_2_DWork.volt[20 * i + 7];

    /* DataStoreRead: '<S95>/Data Store Read' */
    t15_2_B.DataStoreRead_p[i] = t15_2_DWork.volt[20 * i];

    /* Gain: '<S95>/0.001' */
    t15_2_B.u01_d[i] = t15_2_P.u01_Gain_d * t15_2_B.DataStoreRead_p[i];

    /* DataStoreRead: '<S95>/Data Store Read1' */
    t15_2_B.DataStoreRead1_n[i] = t15_2_DWork.volt[20 * i + 8];

    /* DataStoreRead: '<S96>/Data Store Read' */
    t15_2_B.DataStoreRead_b1[i] = t15_2_DWork.volt[20 * i];

    /* Gain: '<S96>/0.001' */
    t15_2_B.u01_b[i] = t15_2_P.u01_Gain_f * t15_2_B.DataStoreRead_b1[i];

    /* DataStoreRead: '<S96>/Data Store Read1' */
    t15_2_B.DataStoreRead1_bb[i] = t15_2_DWork.volt[20 * i + 9];

    /* DataStoreRead: '<S87>/Data Store Read' */
    t15_2_B.DataStoreRead_k[i] = t15_2_DWork.volt[20 * i];

    /* Gain: '<S87>/0.001' */
    t15_2_B.u01_ks[i] = t15_2_P.u01_Gain_b * t15_2_B.DataStoreRead_k[i];

    /* DataStoreRead: '<S87>/Data Store Read1' */
    t15_2_B.DataStoreRead1_c[i] = t15_2_DWork.volt[20 * i + 10];

    /* DataStoreRead: '<S88>/Data Store Read' */
    t15_2_B.DataStoreRead_n[i] = t15_2_DWork.volt[20 * i];

    /* Gain: '<S88>/0.001' */
    t15_2_B.u01_pp[i] = t15_2_P.u01_Gain_c * t15_2_B.DataStoreRead_n[i];

    /* DataStoreRead: '<S88>/Data Store Read1' */
    t15_2_B.DataStoreRead1_oa[i] = t15_2_DWork.volt[20 * i + 11];
  }

  /* Dynamic Look-Up Table Block: '<S86>/volt1'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(t15_2_B.volt1), &t15_2_B.DataStoreRead1_dx[0],
                       t15_2_B.Times, &t15_2_B.u01[0], 499U);

  /* Dynamic Look-Up Table Block: '<S89>/volt1'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(t15_2_B.volt1_k), &t15_2_B.DataStoreRead1_h[0],
                       t15_2_B.Times, &t15_2_B.u01_a[0], 499U);

  /* Dynamic Look-Up Table Block: '<S90>/volt1'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(t15_2_B.volt1_c), &t15_2_B.DataStoreRead1_p[0],
                       t15_2_B.Times, &t15_2_B.u01_i[0], 499U);

  /* Dynamic Look-Up Table Block: '<S91>/volt1'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(t15_2_B.volt1_o), &t15_2_B.DataStoreRead1_g[0],
                       t15_2_B.Times, &t15_2_B.u01_c[0], 499U);

  /* Dynamic Look-Up Table Block: '<S92>/volt1'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(t15_2_B.volt1_g), &t15_2_B.DataStoreRead1_bu[0],
                       t15_2_B.Times, &t15_2_B.u01_p[0], 499U);

  /* Dynamic Look-Up Table Block: '<S93>/volt1'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(t15_2_B.volt1_a), &t15_2_B.DataStoreRead1_i[0],
                       t15_2_B.Times, &t15_2_B.u01_o[0], 499U);

  /* Dynamic Look-Up Table Block: '<S94>/volt1'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(t15_2_B.volt1_h), &t15_2_B.DataStoreRead1_o[0],
                       t15_2_B.Times, &t15_2_B.u01_k[0], 499U);

  /* Dynamic Look-Up Table Block: '<S95>/volt1'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(t15_2_B.volt1_cs), &t15_2_B.DataStoreRead1_n[0],
                       t15_2_B.Times, &t15_2_B.u01_d[0], 499U);

  /* Dynamic Look-Up Table Block: '<S96>/volt1'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(t15_2_B.volt1_op), &t15_2_B.DataStoreRead1_bb[0],
                       t15_2_B.Times, &t15_2_B.u01_b[0], 499U);

  /* Dynamic Look-Up Table Block: '<S87>/volt1'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(t15_2_B.volt1_m), &t15_2_B.DataStoreRead1_c[0],
                       t15_2_B.Times, &t15_2_B.u01_ks[0], 499U);

  /* Dynamic Look-Up Table Block: '<S88>/volt1'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(t15_2_B.volt1_d), &t15_2_B.DataStoreRead1_oa[0],
                       t15_2_B.Times, &t15_2_B.u01_pp[0], 499U);

  /* Sum: '<S15>/Sum1' incorporates:
   *  Constant: '<S15>/1 '
   */
  t15_2_B.Sum1_n = t15_2_P._Value_f - t15_2_B.LogicalOperator1;

  /* Product: '<S15>/Divide7' */
  t15_2_B.Divide7[0] = t15_2_B.volt1 * t15_2_B.Sum1_n;
  t15_2_B.Divide7[1] = t15_2_B.volt1_k * t15_2_B.Sum1_n;
  t15_2_B.Divide7[2] = t15_2_B.volt1_c * t15_2_B.Sum1_n;
  t15_2_B.Divide7[3] = t15_2_B.volt1_o * t15_2_B.Sum1_n;
  t15_2_B.Divide7[4] = t15_2_B.volt1_g * t15_2_B.Sum1_n;
  t15_2_B.Divide7[5] = t15_2_B.volt1_a * t15_2_B.Sum1_n;
  t15_2_B.Divide7[6] = t15_2_B.volt1_h * t15_2_B.Sum1_n;
  t15_2_B.Divide7[7] = t15_2_B.volt1_cs * t15_2_B.Sum1_n;
  t15_2_B.Divide7[8] = t15_2_B.volt1_op * t15_2_B.Sum1_n;
  t15_2_B.Divide7[9] = t15_2_B.volt1_m * t15_2_B.Sum1_n;
  t15_2_B.Divide7[10] = t15_2_B.volt1_d * t15_2_B.Sum1_n;
  for (i = 0; i < 11; i++) {
    /* Sum: '<S15>/Sum3' */
    t15_2_B.Sum3[i] = ((t15_2_B.Divide4_b[i] + t15_2_B.Divide5_d[i]) +
                       t15_2_B.Divide5[i]) + t15_2_B.Divide7[i];

    /* Product: '<S53>/Divide2' */
    t15_2_B.Divide2_j[i] = t15_2_B.e6_m[i] * t15_2_B.Sum3[i];

    /* RelationalOperator: '<S71>/Compare' incorporates:
     *  Constant: '<S71>/Constant'
     */
    t15_2_B.Compare_j[i] = (uint8_T)(t15_2_B.Divide2_j[i] <
      t15_2_P.Constant_Value_a1);

    /* Logic: '<S53>/Logical Operator' */
    t15_2_B.LogicalOperator_k[i] = ((t15_2_B.Compare[i] != 0) &&
      (t15_2_B.Compare_j[i] != 0));

    /* Switch: '<S53>/Switch' incorporates:
     *  Constant: '<S53>/1'
     */
    if (t15_2_B.LogicalOperator_k[i]) {
      t15_2_B.Switch[i] = t15_2_P._Value_co;
    } else {
      t15_2_B.Switch[i] = t15_2_B.Saturation[i];
    }

    /* End of Switch: '<S53>/Switch' */

    /* Product: '<S53>/Divide6' */
    t15_2_B.Divide6_g[i] = t15_2_B.Sum3[i] * t15_2_B.Switch[i];
  }

  /* UniformRandomNumber: '<S63>/Uniform Random Number' */
  t15_2_B.UniformRandomNumber = t15_2_DWork.UniformRandomNumber_NextOutput;

  /* DataStoreRead: '<S82>/Data Store Read' */
  t15_2_B.DataStoreRead_pa = t15_2_DWork.RupRd[5];

  /* Gain: '<S82>/1.75' */
  t15_2_B.u5 = t15_2_P.u5_Gain * t15_2_B.DataStoreRead_pa;

  /* Product: '<S82>/Divide11' */
  t15_2_B.Divide11 = t15_2_B.UniformRandomNumber * t15_2_B.u5;

  /* UnitDelay: '<S83>/UD' */
  t15_2_B.Uk1_n = t15_2_DWork.UD_DSTATE_h;

  /* Sum: '<S83>/Diff' */
  t15_2_B.Diff_l = t15_2_B.Times - t15_2_B.Uk1_n;

  /* Gain: '<S82>/2e3' */
  t15_2_B.e3_n = t15_2_P.e3_Gain_p * t15_2_B.Diff_l;

  /* Sqrt: '<S82>/Sqrt' */
  t15_2_B.Sqrt = sqrt(t15_2_B.e3_n);

  /* Product: '<S82>/Divide1' */
  t15_2_B.Divide1_ap = t15_2_B.Divide11 / t15_2_B.Sqrt;

  /* Sum: '<S63>/Sum2' */
  t15_2_B.Sum2_g = t15_2_B.Divide1_ap + t15_2_B.Divide;

  /* DataStoreRead: '<S65>/Data Store Read' */
  t15_2_B.DataStoreRead_l4 = t15_2_DWork.t_tran2D;

  /* DataStoreRead: '<S65>/Data Store Read2' */
  t15_2_B.DataStoreRead2_e = t15_2_DWork.tcont2;

  /* MinMax: '<S65>/MinMax' */
  u = t15_2_B.DataStoreRead_l4;
  tmin = t15_2_B.DataStoreRead2_e;
  if ((u >= tmin) || rtIsNaN(tmin)) {
    tmin = u;
  }

  t15_2_B.MinMax_c = tmin;

  /* End of MinMax: '<S65>/MinMax' */

  /* RelationalOperator: '<S65>/Relational Operator1' */
  t15_2_B.RelationalOperator1_k = (t15_2_B.Times > t15_2_B.MinMax_c);

  /* Product: '<S65>/Divide12' */
  t15_2_B.Divide12_h[0] = t15_2_B.Sum2_g * t15_2_B.RelationalOperator1_k;
  t15_2_B.Divide12_h[1] = t15_2_B.e6_m[11] * t15_2_B.RelationalOperator1_k;

  /* DiscreteStateSpace: '<S60>/VS. contr' */
  {
    {
      static const int_T colCidxRow0[5] = { 3, 4, 5, 6, 7 };

      const int_T *pCidx = &colCidxRow0[0];
      const real_T *pC0 = t15_2_P.VScontr_C;
      const real_T *xd = &t15_2_DWork.VScontr_DSTATE[0];
      real_T *y0 = &t15_2_B.VScontr[0];
      int_T numNonZero = 4;
      *y0 = (*pC0++) * xd[*pCidx++];
      while (numNonZero--) {
        *y0 += (*pC0++) * xd[*pCidx++];
      }
    }

    t15_2_B.VScontr[0] += (t15_2_P.VScontr_D[0])*t15_2_B.Divide12_h[0] +
      (t15_2_P.VScontr_D[1])*t15_2_B.Divide12_h[1];

    {
      static const int_T colCidxRow1[5] = { 0, 1, 2, 7, 8 };

      const int_T *pCidx = &colCidxRow1[0];
      const real_T *pC5 = &t15_2_P.VScontr_C[5];
      const real_T *xd = &t15_2_DWork.VScontr_DSTATE[0];
      real_T *y1 = &t15_2_B.VScontr[1];
      int_T numNonZero = 4;
      *y1 = (*pC5++) * xd[*pCidx++];
      while (numNonZero--) {
        *y1 += (*pC5++) * xd[*pCidx++];
      }
    }

    t15_2_B.VScontr[1] += (t15_2_P.VScontr_D[2])*t15_2_B.Divide12_h[0] +
      (t15_2_P.VScontr_D[3])*t15_2_B.Divide12_h[1];
  }

  /* RelationalOperator: '<S79>/Compare' incorporates:
   *  Constant: '<S79>/Constant'
   */
  t15_2_B.Compare_p = (t15_2_B.u_h < t15_2_P.Constant_Value_h);

  /* Product: '<S60>/Divide4' */
  t15_2_B.Divide4_n[0] = (real_T)t15_2_B.Compare_p * t15_2_B.Divide12_h[0];
  t15_2_B.Divide4_n[1] = (real_T)t15_2_B.Compare_p * t15_2_B.Divide12_h[1];

  /* DiscreteStateSpace: '<S60>/VS. contr hl' */
  {
    {
      static const int_T colCidxRow0[5] = { 3, 4, 5, 6, 7 };

      const int_T *pCidx = &colCidxRow0[0];
      const real_T *pC0 = t15_2_P.VScontrhl_C;
      const real_T *xd = &t15_2_DWork.VScontrhl_DSTATE[0];
      real_T *y0 = &t15_2_B.VScontrhl[0];
      int_T numNonZero = 4;
      *y0 = (*pC0++) * xd[*pCidx++];
      while (numNonZero--) {
        *y0 += (*pC0++) * xd[*pCidx++];
      }
    }

    t15_2_B.VScontrhl[0] += (t15_2_P.VScontrhl_D[0])*t15_2_B.Divide4_n[0] +
      (t15_2_P.VScontrhl_D[1])*t15_2_B.Divide4_n[1];
    t15_2_B.VScontrhl[1] = (t15_2_P.VScontrhl_C[5])*
      t15_2_DWork.VScontrhl_DSTATE[0] + (t15_2_P.VScontrhl_C[6])*
      t15_2_DWork.VScontrhl_DSTATE[1]
      + (t15_2_P.VScontrhl_C[7])*t15_2_DWork.VScontrhl_DSTATE[2]
      + (t15_2_P.VScontrhl_C[8])*t15_2_DWork.VScontrhl_DSTATE[7];
    t15_2_B.VScontrhl[1] += (t15_2_P.VScontrhl_D[2])*t15_2_B.Divide4_n[0] +
      (t15_2_P.VScontrhl_D[3])*t15_2_B.Divide4_n[1];
  }

  /* Switch: '<S60>/c_eob' */
  if (t15_2_B.u_h >= t15_2_P.c_eob_Threshold_l3) {
    t15_2_B.c_eob_h[0] = t15_2_B.VScontr[0];
    t15_2_B.c_eob_h[1] = t15_2_B.VScontr[1];
  } else {
    t15_2_B.c_eob_h[0] = t15_2_B.VScontrhl[0];
    t15_2_B.c_eob_h[1] = t15_2_B.VScontrhl[1];
  }

  /* End of Switch: '<S60>/c_eob' */

  /* DataStoreRead: '<S59>/Data Store Read1' */
  t15_2_B.DataStoreRead1_e = t15_2_DWork.Ip_rd;

  /* RelationalOperator: '<S59>/Relational Operator2' */
  t15_2_B.RelationalOperator2_j = (t15_2_B.e6 < t15_2_B.DataStoreRead1_e);

  /* DataStoreRead: '<S59>/Data Store Read' */
  t15_2_B.DataStoreRead_je = t15_2_DWork.RupRd[2];

  /* Abs: '<S59>/Abs' */
  t15_2_B.Abs_lu = fabs(t15_2_B.DataStoreRead_je);

  /* RelationalOperator: '<S59>/Relational Operator1' */
  t15_2_B.RelationalOperator1_d = (t15_2_B.e6 > t15_2_B.Abs_lu);

  /* RelationalOperator: '<S78>/Compare' incorporates:
   *  Constant: '<S78>/Constant'
   */
  t15_2_B.Compare_c = (t15_2_B.u_h < t15_2_P.Constant_Value_aq);

  /* Logic: '<S59>/Logical Operator1' */
  t15_2_B.LogicalOperator1_d = ((t15_2_B.RelationalOperator2_j != 0.0) &&
    (t15_2_B.RelationalOperator1_d != 0.0) && t15_2_B.Compare_c);

  /* DataStoreRead: '<S61>/Data Store Read' */
  t15_2_B.DataStoreRead_g = t15_2_DWork.c_a_tpl1;

  /* Gain: '<S61>/1//15' */
  t15_2_B.u5_e = t15_2_P.u5_Gain_i * t15_2_B.DataStoreRead_g;

  /* Product: '<S61>/Div' */
  t15_2_B.Div = t15_2_B.e6 * t15_2_B.u5_e;

  /* Switch: '<S59>/1' incorporates:
   *  Switch: '<S15>/c_eob '
   */
  if (t15_2_B.LogicalOperator1_d >= t15_2_P._Threshold_o) {
    /* Product: '<S15>/Divide6' */
    t15_2_B.Divide6_e = t15_2_B.u15 * t15_2_B.e6;

    /* RelationalOperator: '<S56>/LowerRelop1' incorporates:
     *  Constant: '<S15>/1'
     */
    t15_2_B.LowerRelop1_g = (t15_2_B.Divide6_e > t15_2_P._Value_h);

    /* Switch: '<S56>/Switch2' incorporates:
     *  Constant: '<S15>/1'
     */
    if (t15_2_B.LowerRelop1_g) {
      t15_2_B.Switch2_p = t15_2_P._Value_h;
    } else {
      /* DataStoreRead: '<S15>/Data Store Read3' */
      t15_2_B.DataStoreRead3_c = t15_2_DWork.c_a_tpl_min;

      /* RelationalOperator: '<S56>/UpperRelop' */
      t15_2_B.UpperRelop_f = (t15_2_B.Divide6_e < t15_2_B.DataStoreRead3_c);

      /* Switch: '<S56>/Switch' */
      if (t15_2_B.UpperRelop_f) {
        t15_2_B.Switch_o = t15_2_B.DataStoreRead3_c;
      } else {
        t15_2_B.Switch_o = t15_2_B.Divide6_e;
      }

      /* End of Switch: '<S56>/Switch' */
      t15_2_B.Switch2_p = t15_2_B.Switch_o;
    }

    /* End of Switch: '<S56>/Switch2' */

    /* Product: '<S15>/Divide11' */
    t15_2_B.Divide11_l[0] = t15_2_B.Switch2_p * t15_2_B.c_eob_h[0];
    t15_2_B.Divide11_l[1] = t15_2_B.Switch2_p * t15_2_B.c_eob_h[1];
    t15_2_B.u_c[0] = t15_2_B.Divide11_l[0];
    t15_2_B.u_c[1] = t15_2_B.Divide11_l[1];
  } else {
    if (t15_2_B.u_h >= t15_2_P.c_eob_Threshold) {
      /* DataStoreRead: '<S61>/Data Store Read1' incorporates:
       *  Switch: '<S15>/c_eob '
       */
      t15_2_B.DataStoreRead1_pd = t15_2_DWork.Ip_div;

      /* RelationalOperator: '<S61>/Relational Operator2' incorporates:
       *  Switch: '<S15>/c_eob '
       */
      t15_2_B.RelationalOperator2_i = (t15_2_B.e6 > t15_2_B.DataStoreRead1_pd);

      /* Switch: '<S61>/Lim. Div. tr.' incorporates:
       *  Switch: '<S15>/c_eob '
       */
      if (t15_2_B.RelationalOperator2_i >= t15_2_P.LimDivtr_Threshold) {
        /* Saturate: '<S61>/Sat. Div' */
        u = t15_2_B.Div;
        tmin = t15_2_P.SatDiv_LowerSat;
        u_0 = t15_2_P.SatDiv_UpperSat;
        if (u >= u_0) {
          t15_2_B.SatDiv = u_0;
        } else if (u <= tmin) {
          t15_2_B.SatDiv = tmin;
        } else {
          t15_2_B.SatDiv = u;
        }

        /* End of Saturate: '<S61>/Sat. Div' */
        t15_2_B.LimDivtr = t15_2_B.SatDiv;
      } else {
        /* DataStoreRead: '<S61>/Data Store Read2' */
        t15_2_B.DataStoreRead2_n = t15_2_DWork.max_VS_lim;

        /* RelationalOperator: '<S80>/LowerRelop1' */
        t15_2_B.LowerRelop1_ld = (t15_2_B.Div > t15_2_B.DataStoreRead2_n);

        /* Switch: '<S80>/Switch2' */
        if (t15_2_B.LowerRelop1_ld) {
          t15_2_B.Switch2_b = t15_2_B.DataStoreRead2_n;
        } else {
          /* RelationalOperator: '<S80>/UpperRelop' incorporates:
           *  Constant: '<S61>/1'
           */
          t15_2_B.UpperRelop_g = (t15_2_B.Div < t15_2_P._Value_p);

          /* Switch: '<S80>/Switch' incorporates:
           *  Constant: '<S61>/1'
           */
          if (t15_2_B.UpperRelop_g) {
            t15_2_B.Switch_n = t15_2_P._Value_p;
          } else {
            t15_2_B.Switch_n = t15_2_B.Div;
          }

          /* End of Switch: '<S80>/Switch' */
          t15_2_B.Switch2_b = t15_2_B.Switch_n;
        }

        /* End of Switch: '<S80>/Switch2' */
        t15_2_B.LimDivtr = t15_2_B.Switch2_b;
      }

      /* End of Switch: '<S61>/Lim. Div. tr.' */

      /* Product: '<S15>/Divide8' incorporates:
       *  Switch: '<S15>/c_eob '
       */
      t15_2_B.Divide8[0] = t15_2_B.LimDivtr * t15_2_B.c_eob_h[0];
      t15_2_B.Divide8[1] = t15_2_B.LimDivtr * t15_2_B.c_eob_h[1];

      /* Switch: '<S15>/c_eob ' */
      t15_2_B.c_eob_oc[0] = t15_2_B.Divide8[0];
      t15_2_B.c_eob_oc[1] = t15_2_B.Divide8[1];
    } else {
      /* Product: '<S15>/Divide15' incorporates:
       *  Switch: '<S15>/c_eob '
       */
      t15_2_B.Divide15 = t15_2_B.u15 * t15_2_B.e6;

      /* DataStoreRead: '<S15>/Data Store Read4' incorporates:
       *  Switch: '<S15>/c_eob '
       */
      t15_2_B.DataStoreRead4 = t15_2_DWork.max_VS_lim;

      /* RelationalOperator: '<S57>/LowerRelop1' incorporates:
       *  Switch: '<S15>/c_eob '
       */
      t15_2_B.LowerRelop1_j = (t15_2_B.Divide15 > t15_2_B.DataStoreRead4);

      /* Switch: '<S57>/Switch2' incorporates:
       *  Switch: '<S15>/c_eob '
       */
      if (t15_2_B.LowerRelop1_j) {
        t15_2_B.Switch2_kp = t15_2_B.DataStoreRead4;
      } else {
        /* RelationalOperator: '<S57>/UpperRelop' incorporates:
         *  Constant: '<S15>/2'
         */
        t15_2_B.UpperRelop_d = (t15_2_B.Divide15 < t15_2_P._Value_c);

        /* Switch: '<S57>/Switch' incorporates:
         *  Constant: '<S15>/2'
         */
        if (t15_2_B.UpperRelop_d) {
          t15_2_B.Switch_l = t15_2_P._Value_c;
        } else {
          t15_2_B.Switch_l = t15_2_B.Divide15;
        }

        /* End of Switch: '<S57>/Switch' */
        t15_2_B.Switch2_kp = t15_2_B.Switch_l;
      }

      /* End of Switch: '<S57>/Switch2' */

      /* Product: '<S15>/Divide ' incorporates:
       *  Switch: '<S15>/c_eob '
       */
      t15_2_B.Divide_n[0] = t15_2_B.c_eob_h[0] * t15_2_B.Switch2_kp;
      t15_2_B.Divide_n[1] = t15_2_B.c_eob_h[1] * t15_2_B.Switch2_kp;

      /* Switch: '<S15>/c_eob ' */
      t15_2_B.c_eob_oc[0] = t15_2_B.Divide_n[0];
      t15_2_B.c_eob_oc[1] = t15_2_B.Divide_n[1];
    }

    t15_2_B.u_c[0] = t15_2_B.c_eob_oc[0];
    t15_2_B.u_c[1] = t15_2_B.c_eob_oc[1];
  }

  /* End of Switch: '<S59>/1' */

  /* Product: '<S15>/Divide10' */
  t15_2_B.Divide10[0] = t15_2_B.Sum1_n * t15_2_B.u_c[0];
  t15_2_B.Divide10[1] = t15_2_B.Sum1_n * t15_2_B.u_c[1];
  for (i = 0; i < 20; i++) {
    /* Gain: '<S15>/G_curr_term' */
    t15_2_B.G_curr_term[i] = 0.0;
    for (i_0 = 0; i_0 < 11; i_0++) {
      t15_2_B.G_curr_term[i] += t15_2_P.G_curr_term_Gain[20 * i_0 + i] *
        t15_2_B.e6_m[i_0];
    }

    /* End of Gain: '<S15>/G_curr_term' */

    /* Product: '<S15>/Divide12' */
    t15_2_B.Divide12_c[i] = t15_2_B.G_curr_term[i] * t15_2_B.LogicalOperator1;
  }

  /* DataStoreRead: '<S54>/Data Store Read' */
  t15_2_B.DataStoreRead_gv = t15_2_DWork.ref_ramp;
  for (i = 0; i < 11; i++) {
    /* Product: '<S55>/Divide1' */
    t15_2_B.Divide1_ar[i] = t15_2_B.u_g[i + 8] / t15_2_B.DataStoreRead2_p[i];

    /* Gain: '<S55>/1e6' */
    t15_2_B.e6_g[i] = t15_2_P.e6_Gain_h * t15_2_B.Divide1_ar[i];

    /* DataStoreRead: '<S5>/Data Store Read2' */
    t15_2_B.DataStoreRead2_m[i] = t15_2_DWork.ntur[i];

    /* Product: '<S5>/Divide4' */
    t15_2_B.Divide4_j[i] = t15_2_B.DataStoreRead2_m[i] * t15_2_B.Divide6_g[i];
  }

  /* Level2 S-Function Block: '<S1>/S-Function' (read_tt_kavin2) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[16];
    sfcnOutputs(rts, 0);
  }

  /* DataStoreWrite: '<S1>/Data Store Write1' */
  memcpy(&t15_2_DWork.ntur[0], &t15_2_B.SFunction_k[32], 12U * sizeof(real_T));

  /* DataStoreWrite: '<S1>/Data Store Write2' */
  for (i = 0; i < 6; i++) {
    t15_2_DWork.RupRd[i] = t15_2_B.SFunction_k[i];
  }

  /* End of DataStoreWrite: '<S1>/Data Store Write2' */

  /* DataStoreWrite: '<S1>/Data Store Write3' */
  t15_2_DWork.VS3_up = t15_2_B.SFunction_k[7];

  /* DataStoreWrite: '<S1>/Data Store Write5' */
  t15_2_DWork.VS1_up = t15_2_B.SFunction_k[6];

  /* DataStoreWrite: '<S1>/Data Store Write7' */
  t15_2_DWork.Tu = t15_2_B.SFunction_k[19];

  /* DataStoreWrite: '<S1>/Data Store Write8' */
  t15_2_DWork.c_cur_max = t15_2_B.SFunction_k[20];

  /* DataStoreRead: '<S8>/Data Store Read3' */
  t15_2_B.DataStoreRead3 = t15_2_DWork.Tu;

  /* UnitDelay: '<S6>/UD' */
  t15_2_B.Uk1_e = t15_2_DWork.UD_DSTATE_e;

  /* Sum: '<S6>/Diff' */
  t15_2_B.Diff_n = t15_2_B.Times - t15_2_B.Uk1_e;
  for (i = 0; i < 11; i++) {
    /* DataStoreWrite: '<S1>/Data Store Write4' */
    t15_2_DWork.Vcspf_up[i] = t15_2_B.SFunction_k[i + 8];

    /* DataStoreWrite: '<S1>/Data Store Write9' */
    t15_2_DWork.Imax[i] = t15_2_B.SFunction_k[i + 21];

    /* DataStoreRead: '<S9>/Data Store Read1' */
    t15_2_B.DataStoreRead1_hg[i] = t15_2_DWork.Vcspf_up[i];

    /* Memory: '<S7>/Memory1' */
    t15_2_B.Memory1_hb[i] = t15_2_DWork.Memory1_PreviousInput_p0[i];

    /* DataStoreRead: '<S8>/Data Store Read1' */
    t15_2_B.DataStoreRead1_k[i] = t15_2_DWork.Vcspf_up[i];

    /* Gain: '<S8>/2' */
    t15_2_B.u_k[i] = t15_2_P._Gain * t15_2_B.DataStoreRead1_k[i];

    /* Product: '<S8>/Divide1' */
    t15_2_B.Divide1_p0[i] = t15_2_B.u_k[i] / t15_2_B.DataStoreRead3;

    /* Sum: '<S7>/Add1' */
    t15_2_B.Add1_fv[i] = t15_2_B.Divide4_j[i] - t15_2_B.Memory1_hb[i];

    /* Product: '<S7>/Divide' */
    t15_2_B.Divide_o[i] = t15_2_B.Add1_fv[i] / t15_2_B.Diff_n;

    /* RelationalOperator: '<S10>/LowerRelop1' */
    t15_2_B.LowerRelop1[i] = (t15_2_B.Divide_o[i] > t15_2_B.Divide1_p0[i]);

    /* Gain: '<S8>/-1' */
    t15_2_B.u_p[i] = t15_2_P.u_Gain_j * t15_2_B.Divide1_p0[i];

    /* RelationalOperator: '<S10>/UpperRelop' */
    t15_2_B.UpperRelop[i] = (t15_2_B.Divide_o[i] < t15_2_B.u_p[i]);

    /* Switch: '<S10>/Switch' */
    if (t15_2_B.UpperRelop[i]) {
      t15_2_B.Switch_p[i] = t15_2_B.u_p[i];
    } else {
      t15_2_B.Switch_p[i] = t15_2_B.Divide_o[i];
    }

    /* End of Switch: '<S10>/Switch' */

    /* Switch: '<S10>/Switch2' */
    if (t15_2_B.LowerRelop1[i]) {
      t15_2_B.Switch2[i] = t15_2_B.Divide1_p0[i];
    } else {
      t15_2_B.Switch2[i] = t15_2_B.Switch_p[i];
    }

    /* End of Switch: '<S10>/Switch2' */

    /* Product: '<S7>/Divide1' */
    t15_2_B.Divide1_ne[i] = t15_2_B.Switch2[i] * t15_2_B.Diff_n;

    /* Sum: '<S7>/Add2' */
    t15_2_B.Add2_f[i] = t15_2_B.Memory1_hb[i] + t15_2_B.Divide1_ne[i];

    /* RelationalOperator: '<S11>/LowerRelop1' */
    t15_2_B.LowerRelop1_l[i] = (t15_2_B.Add2_f[i] > t15_2_B.DataStoreRead1_hg[i]);

    /* Gain: '<S9>/Gain' */
    t15_2_B.Gain[i] = t15_2_P.Gain_Gain_c * t15_2_B.DataStoreRead1_hg[i];

    /* RelationalOperator: '<S11>/UpperRelop' */
    t15_2_B.UpperRelop_a[i] = (t15_2_B.Add2_f[i] < t15_2_B.Gain[i]);

    /* Switch: '<S11>/Switch' */
    if (t15_2_B.UpperRelop_a[i]) {
      t15_2_B.Switch_d[i] = t15_2_B.Gain[i];
    } else {
      t15_2_B.Switch_d[i] = t15_2_B.Add2_f[i];
    }

    /* End of Switch: '<S11>/Switch' */

    /* Switch: '<S11>/Switch2' */
    if (t15_2_B.LowerRelop1_l[i]) {
      t15_2_B.Switch2_k[i] = t15_2_B.DataStoreRead1_hg[i];
    } else {
      t15_2_B.Switch2_k[i] = t15_2_B.Switch_d[i];
    }

    /* End of Switch: '<S11>/Switch2' */

    /* DataStoreRead: '<S2>/Data Store Read2' */
    t15_2_B.DataStoreRead2_c[i] = t15_2_DWork.ntur[i];

    /* Product: '<S2>/Divide3' */
    t15_2_B.Divide3_e[i] = t15_2_B.Switch2_k[i] / t15_2_B.DataStoreRead2_c[i];

    /* Product: '<S2>/Divide1' incorporates:
     *  Constant: '<S2>/wz1'
     */
    t15_2_B.Divide1_lq[i] = t15_2_P.wz1_Value[i] / t15_2_B.DataStoreRead2_c[i];
  }

  /* DataStoreRead: '<S4>/Data Store Read1' */
  t15_2_B.DataStoreRead1_bw = t15_2_DWork.VS1_up;

  /* RelationalOperator: '<S12>/LowerRelop1' */
  t15_2_B.LowerRelop1_b = (t15_2_B.Divide10[0] > t15_2_B.DataStoreRead1_bw);

  /* Switch: '<S12>/Switch2' */
  if (t15_2_B.LowerRelop1_b) {
    t15_2_B.Switch2_e = t15_2_B.DataStoreRead1_bw;
  } else {
    /* Gain: '<S4>/Gain' */
    t15_2_B.Gain_p = t15_2_P.Gain_Gain * t15_2_B.DataStoreRead1_bw;

    /* RelationalOperator: '<S12>/UpperRelop' */
    t15_2_B.UpperRelop_j = (t15_2_B.Divide10[0] < t15_2_B.Gain_p);

    /* Switch: '<S12>/Switch' */
    if (t15_2_B.UpperRelop_j) {
      t15_2_B.Switch_f = t15_2_B.Gain_p;
    } else {
      t15_2_B.Switch_f = t15_2_B.Divide10[0];
    }

    /* End of Switch: '<S12>/Switch' */
    t15_2_B.Switch2_e = t15_2_B.Switch_f;
  }

  for (i = 0; i < 11; i++) {
    /* Product: '<S2>/Divide2' */
    t15_2_B.Divide2_f[i] = t15_2_B.Divide1_lq[i] * t15_2_B.Switch2_e;

    /* Sum: '<S2>/Add1' */
    t15_2_B.Add1_b[i] = t15_2_B.Divide3_e[i] + t15_2_B.Divide2_f[i];
  }

  /* End of Switch: '<S12>/Switch2' */

  /* DataStoreRead: '<S2>/Data Store Read1' */
  t15_2_B.DataStoreRead1_ht = t15_2_DWork.ntur[11];

  /* Product: '<S2>/Divide4' incorporates:
   *  Constant: '<S2>/wz2'
   */
  t15_2_B.Divide4_f = t15_2_P.wz2_Value / t15_2_B.DataStoreRead1_ht;

  /* DataStoreRead: '<S4>/Data Store Read3' */
  t15_2_B.DataStoreRead3_d = t15_2_DWork.VS3_up;

  /* RelationalOperator: '<S13>/LowerRelop1' */
  t15_2_B.LowerRelop1_a = (t15_2_B.Divide10[1] > t15_2_B.DataStoreRead3_d);

  /* Switch: '<S13>/Switch2' */
  if (t15_2_B.LowerRelop1_a) {
    t15_2_B.Switch2_ec = t15_2_B.DataStoreRead3_d;
  } else {
    /* Gain: '<S4>/Gain1' */
    t15_2_B.Gain1 = t15_2_P.Gain1_Gain * t15_2_B.DataStoreRead3_d;

    /* RelationalOperator: '<S13>/UpperRelop' */
    t15_2_B.UpperRelop_l = (t15_2_B.Divide10[1] < t15_2_B.Gain1);

    /* Switch: '<S13>/Switch' */
    if (t15_2_B.UpperRelop_l) {
      t15_2_B.Switch_m = t15_2_B.Gain1;
    } else {
      t15_2_B.Switch_m = t15_2_B.Divide10[1];
    }

    /* End of Switch: '<S13>/Switch' */
    t15_2_B.Switch2_ec = t15_2_B.Switch_m;
  }

  /* End of Switch: '<S13>/Switch2' */

  /* Product: '<S2>/Divide5' */
  t15_2_B.Divide5_o = t15_2_B.Divide4_f * t15_2_B.Switch2_ec;

  /* SignalConversion: '<S2>/TmpSignal ConversionAtnpf,12Inport1' */
  memcpy(&t15_2_B.TmpSignalConversionAtnpf12Inpor[0], &t15_2_B.Add1_b[0], 11U *
         sizeof(real_T));
  t15_2_B.TmpSignalConversionAtnpf12Inpor[11] = t15_2_B.Divide5_o;
  for (i = 0; i < 15; i++) {
    /* Gain: '<S2>/npf,12' */
    t15_2_B.npf12[i] = 0.0;
    for (i_0 = 0; i_0 < 12; i_0++) {
      t15_2_B.npf12[i] += t15_2_P.npf12_Gain[15 * i_0 + i] *
        t15_2_B.TmpSignalConversionAtnpf12Inpor[i_0];
    }

    /* End of Gain: '<S2>/npf,12' */

    /* Outport: '<Root>/to_DINA' */
    t15_2_Y.to_DINA[i] = t15_2_B.npf12[i];
  }

  /* Outport: '<Root>/to_DINA' */
  memcpy(&t15_2_Y.to_DINA[15], &t15_2_B.Divide3_e[0], 11U * sizeof(real_T));
  for (i = 0; i < 11; i++) {
    /* Outport: '<Root>/to_DINA' */
    t15_2_Y.to_DINA[i + 26] = t15_2_B.Divide2_f[i];

    /* Update for Memory: '<S52>/Memory1' */
    t15_2_DWork.Memory1_PreviousInput_k[i] = t15_2_B.switch1_l[i];

    /* Update for Memory: '<S66>/Memory1' */
    t15_2_DWork.Memory1_PreviousInput_i[i] = t15_2_B.u_o[i];

    /* Update for Memory: '<S58>/Memory' */
    t15_2_DWork.Memory_PreviousInput_o[i] = t15_2_B.u_e[i];

    /* Update for Memory: '<S7>/Memory1' */
    t15_2_DWork.Memory1_PreviousInput_p0[i] = t15_2_B.Switch2_k[i];
  }

  /* Outport: '<Root>/to_DINA' */
  t15_2_Y.to_DINA[37] = t15_2_B.Divide5_o;

  /* Update for Memory: '<S5>/Memory2' */
  t15_2_DWork.Memory2_PreviousInput = t15_2_B.Ip1e4;

  /* Update for Memory: '<S18>/Memory1' */
  t15_2_DWork.Memory1_PreviousInput = t15_2_B.switch1;

  /* Update for Memory: '<S26>/Memory' */
  t15_2_DWork.Memory_PreviousInput = t15_2_B.LogicalOperator;

  /* Update for Memory: '<S19>/Memory1' */
  t15_2_DWork.Memory1_PreviousInput_e = t15_2_B.c_eob;

  /* Update for Memory: '<S44>/Memory2' */
  t15_2_DWork.Memory2_PreviousInput_o = t15_2_B.c_eob1;

  /* Update for Memory: '<S44>/Memory1' */
  t15_2_DWork.Memory1_PreviousInput_l = t15_2_B.c_eob_g;

  /* Update for Memory: '<S40>/Memory2' */
  t15_2_DWork.Memory2_PreviousInput_b = t15_2_B.c_eob1_f;

  /* Update for Memory: '<S40>/Memory1' */
  t15_2_DWork.Memory1_PreviousInput_n = t15_2_B.c_eob_kp;

  /* Update for Memory: '<S41>/Memory2' */
  t15_2_DWork.Memory2_PreviousInput_e = t15_2_B.c_eob1_fq;

  /* Update for Memory: '<S41>/Memory1' */
  t15_2_DWork.Memory1_PreviousInput_e4 = t15_2_B.c_eob_d;

  /* Update for Memory: '<S42>/Memory2' */
  t15_2_DWork.Memory2_PreviousInput_od = t15_2_B.c_eob1_o;

  /* Update for Memory: '<S42>/Memory1' */
  t15_2_DWork.Memory1_PreviousInput_p = t15_2_B.c_eob_ka;

  /* Update for Memory: '<S45>/Memory2' */
  t15_2_DWork.Memory2_PreviousInput_p = t15_2_B.c_eob1_oa;

  /* Update for Memory: '<S45>/Memory1' */
  t15_2_DWork.Memory1_PreviousInput_j = t15_2_B.c_eob_m;

  /* Update for Memory: '<S43>/Memory2' */
  t15_2_DWork.Memory2_PreviousInput_n = t15_2_B.c_eob1_m;

  /* Update for Memory: '<S43>/Memory1' */
  t15_2_DWork.Memory1_PreviousInput_a = t15_2_B.c_eob_i4;

  /* Update for Memory: '<S29>/Memory2' */
  t15_2_DWork.Memory2_PreviousInput_e2 = t15_2_B.c_eob_im;

  /* Update for Memory: '<S32>/Memory2' */
  t15_2_DWork.Memory2_PreviousInput_nv = t15_2_B.c_eob_j;

  /* Update for Memory: '<S33>/Memory2' */
  t15_2_DWork.Memory2_PreviousInput_h = t15_2_B.c_eob_n;

  /* Update for Memory: '<S34>/Memory2' */
  t15_2_DWork.Memory2_PreviousInput_l = t15_2_B.c_eob_o;

  /* Update for Memory: '<S35>/Memory2' */
  t15_2_DWork.Memory2_PreviousInput_pa = t15_2_B.c_eob_e;

  /* Update for Memory: '<S36>/Memory2' */
  t15_2_DWork.Memory2_PreviousInput_j = t15_2_B.c_eob_f;

  /* Update for Memory: '<S37>/Memory2' */
  t15_2_DWork.Memory2_PreviousInput_bt = t15_2_B.c_eob_cz;

  /* Update for Memory: '<S38>/Memory2' */
  t15_2_DWork.Memory2_PreviousInput_i = t15_2_B.c_eob_g2;

  /* Update for Memory: '<S39>/Memory2' */
  t15_2_DWork.Memory2_PreviousInput_iw = t15_2_B.c_eob_bq;

  /* Update for Memory: '<S30>/Memory2' */
  t15_2_DWork.Memory2_PreviousInput_oh = t15_2_B.c_eob_kx;

  /* Update for Memory: '<S31>/Memory2' */
  t15_2_DWork.Memory2_PreviousInput_nt = t15_2_B.c_eob_dh;

  /* Update for Memory: '<S25>/Memory' */
  t15_2_DWork.Memory_PreviousInput_h = t15_2_B.LogicalOperator_f;

  /* Update for UnitDelay: '<S27>/UD' incorporates:
   *  Inport: '<Root>/In1'
   */
  t15_2_DWork.UD_DSTATE = t15_2_U.In1[0];

  /* Update for UnitDelay: '<S28>/UD' */
  t15_2_DWork.UD_DSTATE_p = t15_2_B.Times;

  /* Update for Memory: '<S52>/Memory3' */
  t15_2_DWork.Memory3_PreviousInput = t15_2_B.switch1_j;

  /* Update for Memory: '<S64>/Memory1' */
  t15_2_DWork.Memory1_PreviousInput_a0 = t15_2_B.c_eob_kh;

  /* Update for DiscreteStateSpace: '<S55>/Lim. contr.' */
  {
    real_T xnew[50];

    {
      static const int_T colAidxRow0[25] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 21, 23, 24, 25, 27 };

      const int_T *pAidx = &colAidxRow0[0];
      const real_T *pA0 = t15_2_P.Limcontr_A;
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew0 = &xnew[0];
      int_T numNonZero = 24;
      *pxnew0 = (*pA0++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew0 += (*pA0++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow0[16] = { 0, 2, 3, 4, 7, 8, 9, 10, 11, 12, 13,
        14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow0[0];
      const real_T *pB0 = t15_2_P.Limcontr_B;
      const real_T *u = &t15_2_B.Divide12_n[0];
      real_T *pxnew0 = &xnew[0];
      int_T numNonZero = 16;
      while (numNonZero--) {
        *pxnew0 += (*pB0++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow1[25] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 21, 23, 24, 25, 27 };

      const int_T *pAidx = &colAidxRow1[0];
      const real_T *pA25 = &t15_2_P.Limcontr_A[25];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew1 = &xnew[1];
      int_T numNonZero = 24;
      *pxnew1 = (*pA25++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew1 += (*pA25++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow1[16] = { 0, 2, 3, 4, 7, 8, 9, 10, 11, 12, 13,
        14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow1[0];
      const real_T *pB16 = &t15_2_P.Limcontr_B[16];
      const real_T *u = &t15_2_B.Divide12_n[0];
      real_T *pxnew1 = &xnew[1];
      int_T numNonZero = 16;
      while (numNonZero--) {
        *pxnew1 += (*pB16++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow2[25] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 21, 23, 24, 25, 27 };

      const int_T *pAidx = &colAidxRow2[0];
      const real_T *pA50 = &t15_2_P.Limcontr_A[50];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew2 = &xnew[2];
      int_T numNonZero = 24;
      *pxnew2 = (*pA50++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew2 += (*pA50++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow2[16] = { 0, 2, 3, 4, 7, 8, 9, 10, 11, 12, 13,
        14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow2[0];
      const real_T *pB32 = &t15_2_P.Limcontr_B[32];
      const real_T *u = &t15_2_B.Divide12_n[0];
      real_T *pxnew2 = &xnew[2];
      int_T numNonZero = 16;
      while (numNonZero--) {
        *pxnew2 += (*pB32++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow3[25] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 21, 23, 24, 25, 27 };

      const int_T *pAidx = &colAidxRow3[0];
      const real_T *pA75 = &t15_2_P.Limcontr_A[75];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew3 = &xnew[3];
      int_T numNonZero = 24;
      *pxnew3 = (*pA75++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew3 += (*pA75++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow3[16] = { 0, 2, 3, 4, 7, 8, 9, 10, 11, 12, 13,
        14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow3[0];
      const real_T *pB48 = &t15_2_P.Limcontr_B[48];
      const real_T *u = &t15_2_B.Divide12_n[0];
      real_T *pxnew3 = &xnew[3];
      int_T numNonZero = 16;
      while (numNonZero--) {
        *pxnew3 += (*pB48++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow4[25] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 21, 23, 24, 25, 27 };

      const int_T *pAidx = &colAidxRow4[0];
      const real_T *pA100 = &t15_2_P.Limcontr_A[100];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew4 = &xnew[4];
      int_T numNonZero = 24;
      *pxnew4 = (*pA100++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew4 += (*pA100++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow4[16] = { 0, 2, 3, 4, 7, 8, 9, 10, 11, 12, 13,
        14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow4[0];
      const real_T *pB64 = &t15_2_P.Limcontr_B[64];
      const real_T *u = &t15_2_B.Divide12_n[0];
      real_T *pxnew4 = &xnew[4];
      int_T numNonZero = 16;
      while (numNonZero--) {
        *pxnew4 += (*pB64++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow5[25] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 21, 23, 24, 25, 27 };

      const int_T *pAidx = &colAidxRow5[0];
      const real_T *pA125 = &t15_2_P.Limcontr_A[125];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew5 = &xnew[5];
      int_T numNonZero = 24;
      *pxnew5 = (*pA125++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew5 += (*pA125++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow5[16] = { 0, 2, 3, 4, 7, 8, 9, 10, 11, 12, 13,
        14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow5[0];
      const real_T *pB80 = &t15_2_P.Limcontr_B[80];
      const real_T *u = &t15_2_B.Divide12_n[0];
      real_T *pxnew5 = &xnew[5];
      int_T numNonZero = 16;
      while (numNonZero--) {
        *pxnew5 += (*pB80++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow6[25] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 21, 23, 24, 25, 27 };

      const int_T *pAidx = &colAidxRow6[0];
      const real_T *pA150 = &t15_2_P.Limcontr_A[150];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew6 = &xnew[6];
      int_T numNonZero = 24;
      *pxnew6 = (*pA150++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew6 += (*pA150++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow6[16] = { 0, 2, 3, 4, 7, 8, 9, 10, 11, 12, 13,
        14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow6[0];
      const real_T *pB96 = &t15_2_P.Limcontr_B[96];
      const real_T *u = &t15_2_B.Divide12_n[0];
      real_T *pxnew6 = &xnew[6];
      int_T numNonZero = 16;
      while (numNonZero--) {
        *pxnew6 += (*pB96++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow7[25] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 21, 23, 24, 25, 27 };

      const int_T *pAidx = &colAidxRow7[0];
      const real_T *pA175 = &t15_2_P.Limcontr_A[175];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew7 = &xnew[7];
      int_T numNonZero = 24;
      *pxnew7 = (*pA175++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew7 += (*pA175++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow7[16] = { 0, 2, 3, 4, 7, 8, 9, 10, 11, 12, 13,
        14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow7[0];
      const real_T *pB112 = &t15_2_P.Limcontr_B[112];
      const real_T *u = &t15_2_B.Divide12_n[0];
      real_T *pxnew7 = &xnew[7];
      int_T numNonZero = 16;
      while (numNonZero--) {
        *pxnew7 += (*pB112++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow8[25] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 21, 23, 24, 25, 27 };

      const int_T *pAidx = &colAidxRow8[0];
      const real_T *pA200 = &t15_2_P.Limcontr_A[200];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew8 = &xnew[8];
      int_T numNonZero = 24;
      *pxnew8 = (*pA200++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew8 += (*pA200++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow8[16] = { 0, 2, 3, 4, 7, 8, 9, 10, 11, 12, 13,
        14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow8[0];
      const real_T *pB128 = &t15_2_P.Limcontr_B[128];
      const real_T *u = &t15_2_B.Divide12_n[0];
      real_T *pxnew8 = &xnew[8];
      int_T numNonZero = 16;
      while (numNonZero--) {
        *pxnew8 += (*pB128++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow9[25] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 21, 23, 24, 25, 27 };

      const int_T *pAidx = &colAidxRow9[0];
      const real_T *pA225 = &t15_2_P.Limcontr_A[225];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew9 = &xnew[9];
      int_T numNonZero = 24;
      *pxnew9 = (*pA225++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew9 += (*pA225++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow9[16] = { 0, 2, 3, 4, 7, 8, 9, 10, 11, 12, 13,
        14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow9[0];
      const real_T *pB144 = &t15_2_P.Limcontr_B[144];
      const real_T *u = &t15_2_B.Divide12_n[0];
      real_T *pxnew9 = &xnew[9];
      int_T numNonZero = 16;
      while (numNonZero--) {
        *pxnew9 += (*pB144++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow10[25] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 21, 23, 24, 25, 27 };

      const int_T *pAidx = &colAidxRow10[0];
      const real_T *pA250 = &t15_2_P.Limcontr_A[250];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew10 = &xnew[10];
      int_T numNonZero = 24;
      *pxnew10 = (*pA250++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew10 += (*pA250++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow10[16] = { 0, 2, 3, 4, 7, 8, 9, 10, 11, 12,
        13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow10[0];
      const real_T *pB160 = &t15_2_P.Limcontr_B[160];
      const real_T *u = &t15_2_B.Divide12_n[0];
      real_T *pxnew10 = &xnew[10];
      int_T numNonZero = 16;
      while (numNonZero--) {
        *pxnew10 += (*pB160++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow11[25] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 21, 23, 24, 25, 27 };

      const int_T *pAidx = &colAidxRow11[0];
      const real_T *pA275 = &t15_2_P.Limcontr_A[275];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew11 = &xnew[11];
      int_T numNonZero = 24;
      *pxnew11 = (*pA275++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew11 += (*pA275++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow11[16] = { 0, 2, 3, 4, 7, 8, 9, 10, 11, 12,
        13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow11[0];
      const real_T *pB176 = &t15_2_P.Limcontr_B[176];
      const real_T *u = &t15_2_B.Divide12_n[0];
      real_T *pxnew11 = &xnew[11];
      int_T numNonZero = 16;
      while (numNonZero--) {
        *pxnew11 += (*pB176++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow12[25] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 21, 23, 24, 25, 27 };

      const int_T *pAidx = &colAidxRow12[0];
      const real_T *pA300 = &t15_2_P.Limcontr_A[300];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew12 = &xnew[12];
      int_T numNonZero = 24;
      *pxnew12 = (*pA300++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew12 += (*pA300++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow12[16] = { 0, 2, 3, 4, 7, 8, 9, 10, 11, 12,
        13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow12[0];
      const real_T *pB192 = &t15_2_P.Limcontr_B[192];
      const real_T *u = &t15_2_B.Divide12_n[0];
      real_T *pxnew12 = &xnew[12];
      int_T numNonZero = 16;
      while (numNonZero--) {
        *pxnew12 += (*pB192++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow13[25] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 21, 23, 24, 25, 27 };

      const int_T *pAidx = &colAidxRow13[0];
      const real_T *pA325 = &t15_2_P.Limcontr_A[325];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew13 = &xnew[13];
      int_T numNonZero = 24;
      *pxnew13 = (*pA325++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew13 += (*pA325++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow13[16] = { 0, 2, 3, 4, 7, 8, 9, 10, 11, 12,
        13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow13[0];
      const real_T *pB208 = &t15_2_P.Limcontr_B[208];
      const real_T *u = &t15_2_B.Divide12_n[0];
      real_T *pxnew13 = &xnew[13];
      int_T numNonZero = 16;
      while (numNonZero--) {
        *pxnew13 += (*pB208++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow14[25] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 21, 23, 24, 25, 27 };

      const int_T *pAidx = &colAidxRow14[0];
      const real_T *pA350 = &t15_2_P.Limcontr_A[350];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew14 = &xnew[14];
      int_T numNonZero = 24;
      *pxnew14 = (*pA350++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew14 += (*pA350++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow14[16] = { 0, 2, 3, 4, 7, 8, 9, 10, 11, 12,
        13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow14[0];
      const real_T *pB224 = &t15_2_P.Limcontr_B[224];
      const real_T *u = &t15_2_B.Divide12_n[0];
      real_T *pxnew14 = &xnew[14];
      int_T numNonZero = 16;
      while (numNonZero--) {
        *pxnew14 += (*pB224++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow15[25] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 21, 23, 24, 25, 27 };

      const int_T *pAidx = &colAidxRow15[0];
      const real_T *pA375 = &t15_2_P.Limcontr_A[375];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew15 = &xnew[15];
      int_T numNonZero = 24;
      *pxnew15 = (*pA375++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew15 += (*pA375++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow15[16] = { 0, 2, 3, 4, 7, 8, 9, 10, 11, 12,
        13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow15[0];
      const real_T *pB240 = &t15_2_P.Limcontr_B[240];
      const real_T *u = &t15_2_B.Divide12_n[0];
      real_T *pxnew15 = &xnew[15];
      int_T numNonZero = 16;
      while (numNonZero--) {
        *pxnew15 += (*pB240++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow16[25] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 21, 23, 24, 25, 27 };

      const int_T *pAidx = &colAidxRow16[0];
      const real_T *pA400 = &t15_2_P.Limcontr_A[400];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew16 = &xnew[16];
      int_T numNonZero = 24;
      *pxnew16 = (*pA400++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew16 += (*pA400++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow16[16] = { 0, 2, 3, 4, 7, 8, 9, 10, 11, 12,
        13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow16[0];
      const real_T *pB256 = &t15_2_P.Limcontr_B[256];
      const real_T *u = &t15_2_B.Divide12_n[0];
      real_T *pxnew16 = &xnew[16];
      int_T numNonZero = 16;
      while (numNonZero--) {
        *pxnew16 += (*pB256++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow17[25] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 21, 23, 24, 25, 27 };

      const int_T *pAidx = &colAidxRow17[0];
      const real_T *pA425 = &t15_2_P.Limcontr_A[425];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew17 = &xnew[17];
      int_T numNonZero = 24;
      *pxnew17 = (*pA425++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew17 += (*pA425++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow17[16] = { 0, 2, 3, 4, 7, 8, 9, 10, 11, 12,
        13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow17[0];
      const real_T *pB272 = &t15_2_P.Limcontr_B[272];
      const real_T *u = &t15_2_B.Divide12_n[0];
      real_T *pxnew17 = &xnew[17];
      int_T numNonZero = 16;
      while (numNonZero--) {
        *pxnew17 += (*pB272++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow18[25] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 21, 23, 24, 25, 27 };

      const int_T *pAidx = &colAidxRow18[0];
      const real_T *pA450 = &t15_2_P.Limcontr_A[450];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew18 = &xnew[18];
      int_T numNonZero = 24;
      *pxnew18 = (*pA450++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew18 += (*pA450++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow18[16] = { 0, 2, 3, 4, 7, 8, 9, 10, 11, 12,
        13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow18[0];
      const real_T *pB288 = &t15_2_P.Limcontr_B[288];
      const real_T *u = &t15_2_B.Divide12_n[0];
      real_T *pxnew18 = &xnew[18];
      int_T numNonZero = 16;
      while (numNonZero--) {
        *pxnew18 += (*pB288++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow19[25] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 21, 23, 24, 25, 27 };

      const int_T *pAidx = &colAidxRow19[0];
      const real_T *pA475 = &t15_2_P.Limcontr_A[475];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew19 = &xnew[19];
      int_T numNonZero = 24;
      *pxnew19 = (*pA475++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew19 += (*pA475++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow19[16] = { 0, 2, 3, 4, 7, 8, 9, 10, 11, 12,
        13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow19[0];
      const real_T *pB304 = &t15_2_P.Limcontr_B[304];
      const real_T *u = &t15_2_B.Divide12_n[0];
      real_T *pxnew19 = &xnew[19];
      int_T numNonZero = 16;
      while (numNonZero--) {
        *pxnew19 += (*pB304++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow20[6] = { 20, 21, 23, 24, 25, 27 };

      const int_T *pAidx = &colAidxRow20[0];
      const real_T *pA500 = &t15_2_P.Limcontr_A[500];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew20 = &xnew[20];
      int_T numNonZero = 5;
      *pxnew20 = (*pA500++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew20 += (*pA500++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow20[16] = { 0, 2, 3, 4, 7, 8, 9, 10, 11, 12,
        13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow20[0];
      const real_T *pB320 = &t15_2_P.Limcontr_B[320];
      const real_T *u = &t15_2_B.Divide12_n[0];
      real_T *pxnew20 = &xnew[20];
      int_T numNonZero = 16;
      while (numNonZero--) {
        *pxnew20 += (*pB320++) * u[*pBidx++];
      }
    }

    xnew[21] = (t15_2_P.Limcontr_A[506])*t15_2_DWork.Limcontr_DSTATE[21];
    xnew[21] += (t15_2_P.Limcontr_B[336])*t15_2_B.Divide12_n[0];
    xnew[22] = (t15_2_P.Limcontr_A[507])*t15_2_DWork.Limcontr_DSTATE[22];
    xnew[22] += (t15_2_P.Limcontr_B[337])*t15_2_B.Divide12_n[1];
    xnew[23] = (t15_2_P.Limcontr_A[508])*t15_2_DWork.Limcontr_DSTATE[23];
    xnew[23] += (t15_2_P.Limcontr_B[338])*t15_2_B.Divide12_n[2];
    xnew[24] = (t15_2_P.Limcontr_A[509])*t15_2_DWork.Limcontr_DSTATE[24];
    xnew[24] += (t15_2_P.Limcontr_B[339])*t15_2_B.Divide12_n[3];
    xnew[25] = (t15_2_P.Limcontr_A[510])*t15_2_DWork.Limcontr_DSTATE[25];
    xnew[25] += (t15_2_P.Limcontr_B[340])*t15_2_B.Divide12_n[4];
    xnew[26] = (t15_2_P.Limcontr_A[511])*t15_2_DWork.Limcontr_DSTATE[26];
    xnew[26] += (t15_2_P.Limcontr_B[341])*t15_2_B.Divide12_n[5];
    xnew[27] = (t15_2_P.Limcontr_A[512])*t15_2_DWork.Limcontr_DSTATE[27];
    xnew[27] += (t15_2_P.Limcontr_B[342])*t15_2_B.Divide12_n[7];

    {
      static const int_T colAidxRow28[20] = { 28, 29, 30, 31, 32, 33, 34, 35, 36,
        37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47 };

      const int_T *pAidx = &colAidxRow28[0];
      const real_T *pA513 = &t15_2_P.Limcontr_A[513];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew28 = &xnew[28];
      int_T numNonZero = 19;
      *pxnew28 = (*pA513++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew28 += (*pA513++) * xd[*pAidx++];
      }
    }

    xnew[28] += (t15_2_P.Limcontr_B[343])*t15_2_B.Divide12_n[5];

    {
      static const int_T colAidxRow29[20] = { 28, 29, 30, 31, 32, 33, 34, 35, 36,
        37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47 };

      const int_T *pAidx = &colAidxRow29[0];
      const real_T *pA533 = &t15_2_P.Limcontr_A[533];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew29 = &xnew[29];
      int_T numNonZero = 19;
      *pxnew29 = (*pA533++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew29 += (*pA533++) * xd[*pAidx++];
      }
    }

    xnew[29] += (t15_2_P.Limcontr_B[344])*t15_2_B.Divide12_n[5];

    {
      static const int_T colAidxRow30[20] = { 28, 29, 30, 31, 32, 33, 34, 35, 36,
        37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47 };

      const int_T *pAidx = &colAidxRow30[0];
      const real_T *pA553 = &t15_2_P.Limcontr_A[553];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew30 = &xnew[30];
      int_T numNonZero = 19;
      *pxnew30 = (*pA553++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew30 += (*pA553++) * xd[*pAidx++];
      }
    }

    xnew[30] += (t15_2_P.Limcontr_B[345])*t15_2_B.Divide12_n[5];

    {
      static const int_T colAidxRow31[20] = { 28, 29, 30, 31, 32, 33, 34, 35, 36,
        37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47 };

      const int_T *pAidx = &colAidxRow31[0];
      const real_T *pA573 = &t15_2_P.Limcontr_A[573];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew31 = &xnew[31];
      int_T numNonZero = 19;
      *pxnew31 = (*pA573++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew31 += (*pA573++) * xd[*pAidx++];
      }
    }

    xnew[31] += (t15_2_P.Limcontr_B[346])*t15_2_B.Divide12_n[5];

    {
      static const int_T colAidxRow32[20] = { 28, 29, 30, 31, 32, 33, 34, 35, 36,
        37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47 };

      const int_T *pAidx = &colAidxRow32[0];
      const real_T *pA593 = &t15_2_P.Limcontr_A[593];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew32 = &xnew[32];
      int_T numNonZero = 19;
      *pxnew32 = (*pA593++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew32 += (*pA593++) * xd[*pAidx++];
      }
    }

    xnew[32] += (t15_2_P.Limcontr_B[347])*t15_2_B.Divide12_n[5];

    {
      static const int_T colAidxRow33[20] = { 28, 29, 30, 31, 32, 33, 34, 35, 36,
        37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47 };

      const int_T *pAidx = &colAidxRow33[0];
      const real_T *pA613 = &t15_2_P.Limcontr_A[613];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew33 = &xnew[33];
      int_T numNonZero = 19;
      *pxnew33 = (*pA613++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew33 += (*pA613++) * xd[*pAidx++];
      }
    }

    xnew[33] += (t15_2_P.Limcontr_B[348])*t15_2_B.Divide12_n[5];

    {
      static const int_T colAidxRow34[20] = { 28, 29, 30, 31, 32, 33, 34, 35, 36,
        37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47 };

      const int_T *pAidx = &colAidxRow34[0];
      const real_T *pA633 = &t15_2_P.Limcontr_A[633];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew34 = &xnew[34];
      int_T numNonZero = 19;
      *pxnew34 = (*pA633++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew34 += (*pA633++) * xd[*pAidx++];
      }
    }

    xnew[34] += (t15_2_P.Limcontr_B[349])*t15_2_B.Divide12_n[5];

    {
      static const int_T colAidxRow35[20] = { 28, 29, 30, 31, 32, 33, 34, 35, 36,
        37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47 };

      const int_T *pAidx = &colAidxRow35[0];
      const real_T *pA653 = &t15_2_P.Limcontr_A[653];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew35 = &xnew[35];
      int_T numNonZero = 19;
      *pxnew35 = (*pA653++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew35 += (*pA653++) * xd[*pAidx++];
      }
    }

    xnew[35] += (t15_2_P.Limcontr_B[350])*t15_2_B.Divide12_n[5];

    {
      static const int_T colAidxRow36[20] = { 28, 29, 30, 31, 32, 33, 34, 35, 36,
        37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47 };

      const int_T *pAidx = &colAidxRow36[0];
      const real_T *pA673 = &t15_2_P.Limcontr_A[673];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew36 = &xnew[36];
      int_T numNonZero = 19;
      *pxnew36 = (*pA673++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew36 += (*pA673++) * xd[*pAidx++];
      }
    }

    xnew[36] += (t15_2_P.Limcontr_B[351])*t15_2_B.Divide12_n[5];

    {
      static const int_T colAidxRow37[20] = { 28, 29, 30, 31, 32, 33, 34, 35, 36,
        37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47 };

      const int_T *pAidx = &colAidxRow37[0];
      const real_T *pA693 = &t15_2_P.Limcontr_A[693];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew37 = &xnew[37];
      int_T numNonZero = 19;
      *pxnew37 = (*pA693++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew37 += (*pA693++) * xd[*pAidx++];
      }
    }

    xnew[37] += (t15_2_P.Limcontr_B[352])*t15_2_B.Divide12_n[5];

    {
      static const int_T colAidxRow38[20] = { 28, 29, 30, 31, 32, 33, 34, 35, 36,
        37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47 };

      const int_T *pAidx = &colAidxRow38[0];
      const real_T *pA713 = &t15_2_P.Limcontr_A[713];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew38 = &xnew[38];
      int_T numNonZero = 19;
      *pxnew38 = (*pA713++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew38 += (*pA713++) * xd[*pAidx++];
      }
    }

    xnew[38] += (t15_2_P.Limcontr_B[353])*t15_2_B.Divide12_n[5];

    {
      static const int_T colAidxRow39[20] = { 28, 29, 30, 31, 32, 33, 34, 35, 36,
        37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47 };

      const int_T *pAidx = &colAidxRow39[0];
      const real_T *pA733 = &t15_2_P.Limcontr_A[733];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew39 = &xnew[39];
      int_T numNonZero = 19;
      *pxnew39 = (*pA733++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew39 += (*pA733++) * xd[*pAidx++];
      }
    }

    xnew[39] += (t15_2_P.Limcontr_B[354])*t15_2_B.Divide12_n[5];

    {
      static const int_T colAidxRow40[20] = { 28, 29, 30, 31, 32, 33, 34, 35, 36,
        37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47 };

      const int_T *pAidx = &colAidxRow40[0];
      const real_T *pA753 = &t15_2_P.Limcontr_A[753];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew40 = &xnew[40];
      int_T numNonZero = 19;
      *pxnew40 = (*pA753++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew40 += (*pA753++) * xd[*pAidx++];
      }
    }

    xnew[40] += (t15_2_P.Limcontr_B[355])*t15_2_B.Divide12_n[5];

    {
      static const int_T colAidxRow41[20] = { 28, 29, 30, 31, 32, 33, 34, 35, 36,
        37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47 };

      const int_T *pAidx = &colAidxRow41[0];
      const real_T *pA773 = &t15_2_P.Limcontr_A[773];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew41 = &xnew[41];
      int_T numNonZero = 19;
      *pxnew41 = (*pA773++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew41 += (*pA773++) * xd[*pAidx++];
      }
    }

    xnew[41] += (t15_2_P.Limcontr_B[356])*t15_2_B.Divide12_n[5];

    {
      static const int_T colAidxRow42[20] = { 28, 29, 30, 31, 32, 33, 34, 35, 36,
        37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47 };

      const int_T *pAidx = &colAidxRow42[0];
      const real_T *pA793 = &t15_2_P.Limcontr_A[793];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew42 = &xnew[42];
      int_T numNonZero = 19;
      *pxnew42 = (*pA793++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew42 += (*pA793++) * xd[*pAidx++];
      }
    }

    xnew[42] += (t15_2_P.Limcontr_B[357])*t15_2_B.Divide12_n[5];

    {
      static const int_T colAidxRow43[20] = { 28, 29, 30, 31, 32, 33, 34, 35, 36,
        37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47 };

      const int_T *pAidx = &colAidxRow43[0];
      const real_T *pA813 = &t15_2_P.Limcontr_A[813];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew43 = &xnew[43];
      int_T numNonZero = 19;
      *pxnew43 = (*pA813++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew43 += (*pA813++) * xd[*pAidx++];
      }
    }

    xnew[43] += (t15_2_P.Limcontr_B[358])*t15_2_B.Divide12_n[5];

    {
      static const int_T colAidxRow44[20] = { 28, 29, 30, 31, 32, 33, 34, 35, 36,
        37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47 };

      const int_T *pAidx = &colAidxRow44[0];
      const real_T *pA833 = &t15_2_P.Limcontr_A[833];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew44 = &xnew[44];
      int_T numNonZero = 19;
      *pxnew44 = (*pA833++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew44 += (*pA833++) * xd[*pAidx++];
      }
    }

    xnew[44] += (t15_2_P.Limcontr_B[359])*t15_2_B.Divide12_n[5];

    {
      static const int_T colAidxRow45[20] = { 28, 29, 30, 31, 32, 33, 34, 35, 36,
        37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47 };

      const int_T *pAidx = &colAidxRow45[0];
      const real_T *pA853 = &t15_2_P.Limcontr_A[853];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew45 = &xnew[45];
      int_T numNonZero = 19;
      *pxnew45 = (*pA853++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew45 += (*pA853++) * xd[*pAidx++];
      }
    }

    xnew[45] += (t15_2_P.Limcontr_B[360])*t15_2_B.Divide12_n[5];

    {
      static const int_T colAidxRow46[20] = { 28, 29, 30, 31, 32, 33, 34, 35, 36,
        37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47 };

      const int_T *pAidx = &colAidxRow46[0];
      const real_T *pA873 = &t15_2_P.Limcontr_A[873];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew46 = &xnew[46];
      int_T numNonZero = 19;
      *pxnew46 = (*pA873++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew46 += (*pA873++) * xd[*pAidx++];
      }
    }

    xnew[46] += (t15_2_P.Limcontr_B[361])*t15_2_B.Divide12_n[5];

    {
      static const int_T colAidxRow47[20] = { 28, 29, 30, 31, 32, 33, 34, 35, 36,
        37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47 };

      const int_T *pAidx = &colAidxRow47[0];
      const real_T *pA893 = &t15_2_P.Limcontr_A[893];
      const real_T *xd = &t15_2_DWork.Limcontr_DSTATE[0];
      real_T *pxnew47 = &xnew[47];
      int_T numNonZero = 19;
      *pxnew47 = (*pA893++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew47 += (*pA893++) * xd[*pAidx++];
      }
    }

    xnew[47] += (t15_2_P.Limcontr_B[362])*t15_2_B.Divide12_n[5];
    xnew[48] = (t15_2_P.Limcontr_A[913])*t15_2_DWork.Limcontr_DSTATE[48];
    xnew[48] += (t15_2_P.Limcontr_B[363])*t15_2_B.Divide12_n[5];
    xnew[49] = 0.0;
    (void) memcpy(&t15_2_DWork.Limcontr_DSTATE[0], xnew,
                  sizeof(real_T)*50);
  }

  /* Update for DiscreteStateSpace: '<S55>/Curr. contr.' */
  {
    real_T xnew[11];

    {
      static const int_T colAidxRow0[11] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

      const int_T *pAidx = &colAidxRow0[0];
      const real_T *pA0 = t15_2_P.Currcontr_A;
      const real_T *xd = &t15_2_DWork.Currcontr_DSTATE[0];
      real_T *pxnew0 = &xnew[0];
      int_T numNonZero = 10;
      *pxnew0 = (*pA0++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew0 += (*pA0++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow0[11] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

      const int_T *pBidx = &colBidxRow0[0];
      const real_T *pB0 = t15_2_P.Currcontr_B;
      const real_T *u = &t15_2_B.e6_g[0];
      real_T *pxnew0 = &xnew[0];
      int_T numNonZero = 11;
      while (numNonZero--) {
        *pxnew0 += (*pB0++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow1[11] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

      const int_T *pAidx = &colAidxRow1[0];
      const real_T *pA11 = &t15_2_P.Currcontr_A[11];
      const real_T *xd = &t15_2_DWork.Currcontr_DSTATE[0];
      real_T *pxnew1 = &xnew[1];
      int_T numNonZero = 10;
      *pxnew1 = (*pA11++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew1 += (*pA11++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow1[11] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

      const int_T *pBidx = &colBidxRow1[0];
      const real_T *pB11 = &t15_2_P.Currcontr_B[11];
      const real_T *u = &t15_2_B.e6_g[0];
      real_T *pxnew1 = &xnew[1];
      int_T numNonZero = 11;
      while (numNonZero--) {
        *pxnew1 += (*pB11++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow2[11] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

      const int_T *pAidx = &colAidxRow2[0];
      const real_T *pA22 = &t15_2_P.Currcontr_A[22];
      const real_T *xd = &t15_2_DWork.Currcontr_DSTATE[0];
      real_T *pxnew2 = &xnew[2];
      int_T numNonZero = 10;
      *pxnew2 = (*pA22++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew2 += (*pA22++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow2[11] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

      const int_T *pBidx = &colBidxRow2[0];
      const real_T *pB22 = &t15_2_P.Currcontr_B[22];
      const real_T *u = &t15_2_B.e6_g[0];
      real_T *pxnew2 = &xnew[2];
      int_T numNonZero = 11;
      while (numNonZero--) {
        *pxnew2 += (*pB22++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow3[11] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

      const int_T *pAidx = &colAidxRow3[0];
      const real_T *pA33 = &t15_2_P.Currcontr_A[33];
      const real_T *xd = &t15_2_DWork.Currcontr_DSTATE[0];
      real_T *pxnew3 = &xnew[3];
      int_T numNonZero = 10;
      *pxnew3 = (*pA33++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew3 += (*pA33++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow3[11] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

      const int_T *pBidx = &colBidxRow3[0];
      const real_T *pB33 = &t15_2_P.Currcontr_B[33];
      const real_T *u = &t15_2_B.e6_g[0];
      real_T *pxnew3 = &xnew[3];
      int_T numNonZero = 11;
      while (numNonZero--) {
        *pxnew3 += (*pB33++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow4[11] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

      const int_T *pAidx = &colAidxRow4[0];
      const real_T *pA44 = &t15_2_P.Currcontr_A[44];
      const real_T *xd = &t15_2_DWork.Currcontr_DSTATE[0];
      real_T *pxnew4 = &xnew[4];
      int_T numNonZero = 10;
      *pxnew4 = (*pA44++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew4 += (*pA44++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow4[11] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

      const int_T *pBidx = &colBidxRow4[0];
      const real_T *pB44 = &t15_2_P.Currcontr_B[44];
      const real_T *u = &t15_2_B.e6_g[0];
      real_T *pxnew4 = &xnew[4];
      int_T numNonZero = 11;
      while (numNonZero--) {
        *pxnew4 += (*pB44++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow5[11] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

      const int_T *pAidx = &colAidxRow5[0];
      const real_T *pA55 = &t15_2_P.Currcontr_A[55];
      const real_T *xd = &t15_2_DWork.Currcontr_DSTATE[0];
      real_T *pxnew5 = &xnew[5];
      int_T numNonZero = 10;
      *pxnew5 = (*pA55++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew5 += (*pA55++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow5[11] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

      const int_T *pBidx = &colBidxRow5[0];
      const real_T *pB55 = &t15_2_P.Currcontr_B[55];
      const real_T *u = &t15_2_B.e6_g[0];
      real_T *pxnew5 = &xnew[5];
      int_T numNonZero = 11;
      while (numNonZero--) {
        *pxnew5 += (*pB55++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow6[11] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

      const int_T *pAidx = &colAidxRow6[0];
      const real_T *pA66 = &t15_2_P.Currcontr_A[66];
      const real_T *xd = &t15_2_DWork.Currcontr_DSTATE[0];
      real_T *pxnew6 = &xnew[6];
      int_T numNonZero = 10;
      *pxnew6 = (*pA66++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew6 += (*pA66++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow6[11] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

      const int_T *pBidx = &colBidxRow6[0];
      const real_T *pB66 = &t15_2_P.Currcontr_B[66];
      const real_T *u = &t15_2_B.e6_g[0];
      real_T *pxnew6 = &xnew[6];
      int_T numNonZero = 11;
      while (numNonZero--) {
        *pxnew6 += (*pB66++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow7[11] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

      const int_T *pAidx = &colAidxRow7[0];
      const real_T *pA77 = &t15_2_P.Currcontr_A[77];
      const real_T *xd = &t15_2_DWork.Currcontr_DSTATE[0];
      real_T *pxnew7 = &xnew[7];
      int_T numNonZero = 10;
      *pxnew7 = (*pA77++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew7 += (*pA77++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow7[11] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

      const int_T *pBidx = &colBidxRow7[0];
      const real_T *pB77 = &t15_2_P.Currcontr_B[77];
      const real_T *u = &t15_2_B.e6_g[0];
      real_T *pxnew7 = &xnew[7];
      int_T numNonZero = 11;
      while (numNonZero--) {
        *pxnew7 += (*pB77++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow8[11] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

      const int_T *pAidx = &colAidxRow8[0];
      const real_T *pA88 = &t15_2_P.Currcontr_A[88];
      const real_T *xd = &t15_2_DWork.Currcontr_DSTATE[0];
      real_T *pxnew8 = &xnew[8];
      int_T numNonZero = 10;
      *pxnew8 = (*pA88++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew8 += (*pA88++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow8[11] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

      const int_T *pBidx = &colBidxRow8[0];
      const real_T *pB88 = &t15_2_P.Currcontr_B[88];
      const real_T *u = &t15_2_B.e6_g[0];
      real_T *pxnew8 = &xnew[8];
      int_T numNonZero = 11;
      while (numNonZero--) {
        *pxnew8 += (*pB88++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow9[11] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

      const int_T *pAidx = &colAidxRow9[0];
      const real_T *pA99 = &t15_2_P.Currcontr_A[99];
      const real_T *xd = &t15_2_DWork.Currcontr_DSTATE[0];
      real_T *pxnew9 = &xnew[9];
      int_T numNonZero = 10;
      *pxnew9 = (*pA99++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew9 += (*pA99++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow9[11] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

      const int_T *pBidx = &colBidxRow9[0];
      const real_T *pB99 = &t15_2_P.Currcontr_B[99];
      const real_T *u = &t15_2_B.e6_g[0];
      real_T *pxnew9 = &xnew[9];
      int_T numNonZero = 11;
      while (numNonZero--) {
        *pxnew9 += (*pB99++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow10[11] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

      const int_T *pAidx = &colAidxRow10[0];
      const real_T *pA110 = &t15_2_P.Currcontr_A[110];
      const real_T *xd = &t15_2_DWork.Currcontr_DSTATE[0];
      real_T *pxnew10 = &xnew[10];
      int_T numNonZero = 10;
      *pxnew10 = (*pA110++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew10 += (*pA110++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow10[11] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

      const int_T *pBidx = &colBidxRow10[0];
      const real_T *pB110 = &t15_2_P.Currcontr_B[110];
      const real_T *u = &t15_2_B.e6_g[0];
      real_T *pxnew10 = &xnew[10];
      int_T numNonZero = 11;
      while (numNonZero--) {
        *pxnew10 += (*pB110++) * u[*pBidx++];
      }
    }

    (void) memcpy(&t15_2_DWork.Currcontr_DSTATE[0], xnew,
                  sizeof(real_T)*11);
  }

  /* Update for DiscreteStateSpace: '<S15>/Div. contr.' */
  {
    real_T xnew[32];

    {
      static const int_T colAidxRow0[27] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 25, 26, 27, 28, 29, 30, 31 };

      const int_T *pAidx = &colAidxRow0[0];
      const real_T *pA0 = t15_2_P.Divcontr_A;
      const real_T *xd = &t15_2_DWork.Divcontr_DSTATE[0];
      real_T *pxnew0 = &xnew[0];
      int_T numNonZero = 26;
      *pxnew0 = (*pA0++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew0 += (*pA0++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow0[17] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow0[0];
      const real_T *pB0 = t15_2_P.Divcontr_B;
      const real_T *u = &t15_2_B.Divide2_a[0];
      real_T *pxnew0 = &xnew[0];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *pxnew0 += (*pB0++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow1[27] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 25, 26, 27, 28, 29, 30, 31 };

      const int_T *pAidx = &colAidxRow1[0];
      const real_T *pA27 = &t15_2_P.Divcontr_A[27];
      const real_T *xd = &t15_2_DWork.Divcontr_DSTATE[0];
      real_T *pxnew1 = &xnew[1];
      int_T numNonZero = 26;
      *pxnew1 = (*pA27++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew1 += (*pA27++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow1[17] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow1[0];
      const real_T *pB17 = &t15_2_P.Divcontr_B[17];
      const real_T *u = &t15_2_B.Divide2_a[0];
      real_T *pxnew1 = &xnew[1];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *pxnew1 += (*pB17++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow2[27] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 25, 26, 27, 28, 29, 30, 31 };

      const int_T *pAidx = &colAidxRow2[0];
      const real_T *pA54 = &t15_2_P.Divcontr_A[54];
      const real_T *xd = &t15_2_DWork.Divcontr_DSTATE[0];
      real_T *pxnew2 = &xnew[2];
      int_T numNonZero = 26;
      *pxnew2 = (*pA54++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew2 += (*pA54++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow2[17] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow2[0];
      const real_T *pB34 = &t15_2_P.Divcontr_B[34];
      const real_T *u = &t15_2_B.Divide2_a[0];
      real_T *pxnew2 = &xnew[2];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *pxnew2 += (*pB34++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow3[27] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 25, 26, 27, 28, 29, 30, 31 };

      const int_T *pAidx = &colAidxRow3[0];
      const real_T *pA81 = &t15_2_P.Divcontr_A[81];
      const real_T *xd = &t15_2_DWork.Divcontr_DSTATE[0];
      real_T *pxnew3 = &xnew[3];
      int_T numNonZero = 26;
      *pxnew3 = (*pA81++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew3 += (*pA81++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow3[17] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow3[0];
      const real_T *pB51 = &t15_2_P.Divcontr_B[51];
      const real_T *u = &t15_2_B.Divide2_a[0];
      real_T *pxnew3 = &xnew[3];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *pxnew3 += (*pB51++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow4[27] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 25, 26, 27, 28, 29, 30, 31 };

      const int_T *pAidx = &colAidxRow4[0];
      const real_T *pA108 = &t15_2_P.Divcontr_A[108];
      const real_T *xd = &t15_2_DWork.Divcontr_DSTATE[0];
      real_T *pxnew4 = &xnew[4];
      int_T numNonZero = 26;
      *pxnew4 = (*pA108++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew4 += (*pA108++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow4[17] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow4[0];
      const real_T *pB68 = &t15_2_P.Divcontr_B[68];
      const real_T *u = &t15_2_B.Divide2_a[0];
      real_T *pxnew4 = &xnew[4];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *pxnew4 += (*pB68++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow5[27] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 25, 26, 27, 28, 29, 30, 31 };

      const int_T *pAidx = &colAidxRow5[0];
      const real_T *pA135 = &t15_2_P.Divcontr_A[135];
      const real_T *xd = &t15_2_DWork.Divcontr_DSTATE[0];
      real_T *pxnew5 = &xnew[5];
      int_T numNonZero = 26;
      *pxnew5 = (*pA135++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew5 += (*pA135++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow5[17] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow5[0];
      const real_T *pB85 = &t15_2_P.Divcontr_B[85];
      const real_T *u = &t15_2_B.Divide2_a[0];
      real_T *pxnew5 = &xnew[5];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *pxnew5 += (*pB85++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow6[27] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 25, 26, 27, 28, 29, 30, 31 };

      const int_T *pAidx = &colAidxRow6[0];
      const real_T *pA162 = &t15_2_P.Divcontr_A[162];
      const real_T *xd = &t15_2_DWork.Divcontr_DSTATE[0];
      real_T *pxnew6 = &xnew[6];
      int_T numNonZero = 26;
      *pxnew6 = (*pA162++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew6 += (*pA162++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow6[17] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow6[0];
      const real_T *pB102 = &t15_2_P.Divcontr_B[102];
      const real_T *u = &t15_2_B.Divide2_a[0];
      real_T *pxnew6 = &xnew[6];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *pxnew6 += (*pB102++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow7[27] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 25, 26, 27, 28, 29, 30, 31 };

      const int_T *pAidx = &colAidxRow7[0];
      const real_T *pA189 = &t15_2_P.Divcontr_A[189];
      const real_T *xd = &t15_2_DWork.Divcontr_DSTATE[0];
      real_T *pxnew7 = &xnew[7];
      int_T numNonZero = 26;
      *pxnew7 = (*pA189++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew7 += (*pA189++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow7[17] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow7[0];
      const real_T *pB119 = &t15_2_P.Divcontr_B[119];
      const real_T *u = &t15_2_B.Divide2_a[0];
      real_T *pxnew7 = &xnew[7];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *pxnew7 += (*pB119++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow8[27] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 25, 26, 27, 28, 29, 30, 31 };

      const int_T *pAidx = &colAidxRow8[0];
      const real_T *pA216 = &t15_2_P.Divcontr_A[216];
      const real_T *xd = &t15_2_DWork.Divcontr_DSTATE[0];
      real_T *pxnew8 = &xnew[8];
      int_T numNonZero = 26;
      *pxnew8 = (*pA216++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew8 += (*pA216++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow8[17] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow8[0];
      const real_T *pB136 = &t15_2_P.Divcontr_B[136];
      const real_T *u = &t15_2_B.Divide2_a[0];
      real_T *pxnew8 = &xnew[8];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *pxnew8 += (*pB136++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow9[27] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 25, 26, 27, 28, 29, 30, 31 };

      const int_T *pAidx = &colAidxRow9[0];
      const real_T *pA243 = &t15_2_P.Divcontr_A[243];
      const real_T *xd = &t15_2_DWork.Divcontr_DSTATE[0];
      real_T *pxnew9 = &xnew[9];
      int_T numNonZero = 26;
      *pxnew9 = (*pA243++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew9 += (*pA243++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow9[17] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow9[0];
      const real_T *pB153 = &t15_2_P.Divcontr_B[153];
      const real_T *u = &t15_2_B.Divide2_a[0];
      real_T *pxnew9 = &xnew[9];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *pxnew9 += (*pB153++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow10[27] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 25, 26, 27, 28, 29, 30, 31 };

      const int_T *pAidx = &colAidxRow10[0];
      const real_T *pA270 = &t15_2_P.Divcontr_A[270];
      const real_T *xd = &t15_2_DWork.Divcontr_DSTATE[0];
      real_T *pxnew10 = &xnew[10];
      int_T numNonZero = 26;
      *pxnew10 = (*pA270++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew10 += (*pA270++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow10[17] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow10[0];
      const real_T *pB170 = &t15_2_P.Divcontr_B[170];
      const real_T *u = &t15_2_B.Divide2_a[0];
      real_T *pxnew10 = &xnew[10];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *pxnew10 += (*pB170++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow11[27] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 25, 26, 27, 28, 29, 30, 31 };

      const int_T *pAidx = &colAidxRow11[0];
      const real_T *pA297 = &t15_2_P.Divcontr_A[297];
      const real_T *xd = &t15_2_DWork.Divcontr_DSTATE[0];
      real_T *pxnew11 = &xnew[11];
      int_T numNonZero = 26;
      *pxnew11 = (*pA297++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew11 += (*pA297++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow11[17] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow11[0];
      const real_T *pB187 = &t15_2_P.Divcontr_B[187];
      const real_T *u = &t15_2_B.Divide2_a[0];
      real_T *pxnew11 = &xnew[11];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *pxnew11 += (*pB187++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow12[27] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 25, 26, 27, 28, 29, 30, 31 };

      const int_T *pAidx = &colAidxRow12[0];
      const real_T *pA324 = &t15_2_P.Divcontr_A[324];
      const real_T *xd = &t15_2_DWork.Divcontr_DSTATE[0];
      real_T *pxnew12 = &xnew[12];
      int_T numNonZero = 26;
      *pxnew12 = (*pA324++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew12 += (*pA324++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow12[17] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow12[0];
      const real_T *pB204 = &t15_2_P.Divcontr_B[204];
      const real_T *u = &t15_2_B.Divide2_a[0];
      real_T *pxnew12 = &xnew[12];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *pxnew12 += (*pB204++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow13[27] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 25, 26, 27, 28, 29, 30, 31 };

      const int_T *pAidx = &colAidxRow13[0];
      const real_T *pA351 = &t15_2_P.Divcontr_A[351];
      const real_T *xd = &t15_2_DWork.Divcontr_DSTATE[0];
      real_T *pxnew13 = &xnew[13];
      int_T numNonZero = 26;
      *pxnew13 = (*pA351++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew13 += (*pA351++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow13[17] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow13[0];
      const real_T *pB221 = &t15_2_P.Divcontr_B[221];
      const real_T *u = &t15_2_B.Divide2_a[0];
      real_T *pxnew13 = &xnew[13];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *pxnew13 += (*pB221++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow14[27] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 25, 26, 27, 28, 29, 30, 31 };

      const int_T *pAidx = &colAidxRow14[0];
      const real_T *pA378 = &t15_2_P.Divcontr_A[378];
      const real_T *xd = &t15_2_DWork.Divcontr_DSTATE[0];
      real_T *pxnew14 = &xnew[14];
      int_T numNonZero = 26;
      *pxnew14 = (*pA378++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew14 += (*pA378++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow14[17] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow14[0];
      const real_T *pB238 = &t15_2_P.Divcontr_B[238];
      const real_T *u = &t15_2_B.Divide2_a[0];
      real_T *pxnew14 = &xnew[14];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *pxnew14 += (*pB238++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow15[27] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 25, 26, 27, 28, 29, 30, 31 };

      const int_T *pAidx = &colAidxRow15[0];
      const real_T *pA405 = &t15_2_P.Divcontr_A[405];
      const real_T *xd = &t15_2_DWork.Divcontr_DSTATE[0];
      real_T *pxnew15 = &xnew[15];
      int_T numNonZero = 26;
      *pxnew15 = (*pA405++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew15 += (*pA405++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow15[17] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow15[0];
      const real_T *pB255 = &t15_2_P.Divcontr_B[255];
      const real_T *u = &t15_2_B.Divide2_a[0];
      real_T *pxnew15 = &xnew[15];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *pxnew15 += (*pB255++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow16[27] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 25, 26, 27, 28, 29, 30, 31 };

      const int_T *pAidx = &colAidxRow16[0];
      const real_T *pA432 = &t15_2_P.Divcontr_A[432];
      const real_T *xd = &t15_2_DWork.Divcontr_DSTATE[0];
      real_T *pxnew16 = &xnew[16];
      int_T numNonZero = 26;
      *pxnew16 = (*pA432++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew16 += (*pA432++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow16[17] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow16[0];
      const real_T *pB272 = &t15_2_P.Divcontr_B[272];
      const real_T *u = &t15_2_B.Divide2_a[0];
      real_T *pxnew16 = &xnew[16];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *pxnew16 += (*pB272++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow17[27] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 25, 26, 27, 28, 29, 30, 31 };

      const int_T *pAidx = &colAidxRow17[0];
      const real_T *pA459 = &t15_2_P.Divcontr_A[459];
      const real_T *xd = &t15_2_DWork.Divcontr_DSTATE[0];
      real_T *pxnew17 = &xnew[17];
      int_T numNonZero = 26;
      *pxnew17 = (*pA459++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew17 += (*pA459++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow17[17] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow17[0];
      const real_T *pB289 = &t15_2_P.Divcontr_B[289];
      const real_T *u = &t15_2_B.Divide2_a[0];
      real_T *pxnew17 = &xnew[17];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *pxnew17 += (*pB289++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow18[27] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 25, 26, 27, 28, 29, 30, 31 };

      const int_T *pAidx = &colAidxRow18[0];
      const real_T *pA486 = &t15_2_P.Divcontr_A[486];
      const real_T *xd = &t15_2_DWork.Divcontr_DSTATE[0];
      real_T *pxnew18 = &xnew[18];
      int_T numNonZero = 26;
      *pxnew18 = (*pA486++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew18 += (*pA486++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow18[17] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow18[0];
      const real_T *pB306 = &t15_2_P.Divcontr_B[306];
      const real_T *u = &t15_2_B.Divide2_a[0];
      real_T *pxnew18 = &xnew[18];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *pxnew18 += (*pB306++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow19[27] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 25, 26, 27, 28, 29, 30, 31 };

      const int_T *pAidx = &colAidxRow19[0];
      const real_T *pA513 = &t15_2_P.Divcontr_A[513];
      const real_T *xd = &t15_2_DWork.Divcontr_DSTATE[0];
      real_T *pxnew19 = &xnew[19];
      int_T numNonZero = 26;
      *pxnew19 = (*pA513++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew19 += (*pA513++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow19[17] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow19[0];
      const real_T *pB323 = &t15_2_P.Divcontr_B[323];
      const real_T *u = &t15_2_B.Divide2_a[0];
      real_T *pxnew19 = &xnew[19];
      int_T numNonZero = 17;
      while (numNonZero--) {
        *pxnew19 += (*pB323++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow20[5] = { 20, 21, 22, 23, 24 };

      const int_T *pAidx = &colAidxRow20[0];
      const real_T *pA540 = &t15_2_P.Divcontr_A[540];
      const real_T *xd = &t15_2_DWork.Divcontr_DSTATE[0];
      real_T *pxnew20 = &xnew[20];
      int_T numNonZero = 4;
      *pxnew20 = (*pA540++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew20 += (*pA540++) * xd[*pAidx++];
      }
    }

    xnew[20] += (t15_2_P.Divcontr_B[340])*t15_2_B.Divide2_a[12];

    {
      static const int_T colAidxRow21[5] = { 20, 21, 22, 23, 24 };

      const int_T *pAidx = &colAidxRow21[0];
      const real_T *pA545 = &t15_2_P.Divcontr_A[545];
      const real_T *xd = &t15_2_DWork.Divcontr_DSTATE[0];
      real_T *pxnew21 = &xnew[21];
      int_T numNonZero = 4;
      *pxnew21 = (*pA545++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew21 += (*pA545++) * xd[*pAidx++];
      }
    }

    xnew[21] += (t15_2_P.Divcontr_B[341])*t15_2_B.Divide2_a[12];

    {
      static const int_T colAidxRow22[5] = { 20, 21, 22, 23, 24 };

      const int_T *pAidx = &colAidxRow22[0];
      const real_T *pA550 = &t15_2_P.Divcontr_A[550];
      const real_T *xd = &t15_2_DWork.Divcontr_DSTATE[0];
      real_T *pxnew22 = &xnew[22];
      int_T numNonZero = 4;
      *pxnew22 = (*pA550++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew22 += (*pA550++) * xd[*pAidx++];
      }
    }

    xnew[22] += (t15_2_P.Divcontr_B[342])*t15_2_B.Divide2_a[12];

    {
      static const int_T colAidxRow23[5] = { 20, 21, 22, 23, 24 };

      const int_T *pAidx = &colAidxRow23[0];
      const real_T *pA555 = &t15_2_P.Divcontr_A[555];
      const real_T *xd = &t15_2_DWork.Divcontr_DSTATE[0];
      real_T *pxnew23 = &xnew[23];
      int_T numNonZero = 4;
      *pxnew23 = (*pA555++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew23 += (*pA555++) * xd[*pAidx++];
      }
    }

    xnew[23] += (t15_2_P.Divcontr_B[343])*t15_2_B.Divide2_a[12];

    {
      static const int_T colAidxRow24[5] = { 20, 21, 22, 23, 24 };

      const int_T *pAidx = &colAidxRow24[0];
      const real_T *pA560 = &t15_2_P.Divcontr_A[560];
      const real_T *xd = &t15_2_DWork.Divcontr_DSTATE[0];
      real_T *pxnew24 = &xnew[24];
      int_T numNonZero = 4;
      *pxnew24 = (*pA560++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew24 += (*pA560++) * xd[*pAidx++];
      }
    }

    xnew[24] += (t15_2_P.Divcontr_B[344])*t15_2_B.Divide2_a[12];
    xnew[25] = (t15_2_P.Divcontr_A[565])*t15_2_DWork.Divcontr_DSTATE[25];
    xnew[25] += (t15_2_P.Divcontr_B[345])*t15_2_B.Divide2_a[0];
    xnew[26] = (t15_2_P.Divcontr_A[566])*t15_2_DWork.Divcontr_DSTATE[26];
    xnew[26] += (t15_2_P.Divcontr_B[346])*t15_2_B.Divide2_a[1];
    xnew[27] = (t15_2_P.Divcontr_A[567])*t15_2_DWork.Divcontr_DSTATE[27];
    xnew[27] += (t15_2_P.Divcontr_B[347])*t15_2_B.Divide2_a[2];
    xnew[28] = (t15_2_P.Divcontr_A[568])*t15_2_DWork.Divcontr_DSTATE[28];
    xnew[28] += (t15_2_P.Divcontr_B[348])*t15_2_B.Divide2_a[3];
    xnew[29] = (t15_2_P.Divcontr_A[569])*t15_2_DWork.Divcontr_DSTATE[29];
    xnew[29] += (t15_2_P.Divcontr_B[349])*t15_2_B.Divide2_a[4];
    xnew[30] = (t15_2_P.Divcontr_A[570])*t15_2_DWork.Divcontr_DSTATE[30];
    xnew[30] += (t15_2_P.Divcontr_B[350])*t15_2_B.Divide2_a[5];
    xnew[31] = (t15_2_P.Divcontr_A[571])*t15_2_DWork.Divcontr_DSTATE[31];
    xnew[31] += (t15_2_P.Divcontr_B[351])*t15_2_B.Divide2_a[7];
    (void) memcpy(&t15_2_DWork.Divcontr_DSTATE[0], xnew,
                  sizeof(real_T)*32);
  }

  /* Update for Memory: '<S62>/Memory1' */
  t15_2_DWork.Memory1_PreviousInput_an = t15_2_B.switch1_m;

  /* Update for DiscreteStateSpace: '<S15>/Div_rd contr' */
  {
    real_T xnew[22];

    {
      static const int_T colAidxRow0[22] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 };

      const int_T *pAidx = &colAidxRow0[0];
      const real_T *pA0 = t15_2_P.Div_rdcontr_A;
      const real_T *xd = &t15_2_DWork.Div_rdcontr_DSTATE[0];
      real_T *pxnew0 = &xnew[0];
      int_T numNonZero = 21;
      *pxnew0 = (*pA0++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew0 += (*pA0++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow0[18] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        12, 13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow0[0];
      const real_T *pB0 = t15_2_P.Div_rdcontr_B;
      const real_T *u = &t15_2_B.Divide13[0];
      real_T *pxnew0 = &xnew[0];
      int_T numNonZero = 18;
      while (numNonZero--) {
        *pxnew0 += (*pB0++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow1[22] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 };

      const int_T *pAidx = &colAidxRow1[0];
      const real_T *pA22 = &t15_2_P.Div_rdcontr_A[22];
      const real_T *xd = &t15_2_DWork.Div_rdcontr_DSTATE[0];
      real_T *pxnew1 = &xnew[1];
      int_T numNonZero = 21;
      *pxnew1 = (*pA22++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew1 += (*pA22++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow1[18] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        12, 13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow1[0];
      const real_T *pB18 = &t15_2_P.Div_rdcontr_B[18];
      const real_T *u = &t15_2_B.Divide13[0];
      real_T *pxnew1 = &xnew[1];
      int_T numNonZero = 18;
      while (numNonZero--) {
        *pxnew1 += (*pB18++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow2[22] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 };

      const int_T *pAidx = &colAidxRow2[0];
      const real_T *pA44 = &t15_2_P.Div_rdcontr_A[44];
      const real_T *xd = &t15_2_DWork.Div_rdcontr_DSTATE[0];
      real_T *pxnew2 = &xnew[2];
      int_T numNonZero = 21;
      *pxnew2 = (*pA44++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew2 += (*pA44++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow2[18] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        12, 13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow2[0];
      const real_T *pB36 = &t15_2_P.Div_rdcontr_B[36];
      const real_T *u = &t15_2_B.Divide13[0];
      real_T *pxnew2 = &xnew[2];
      int_T numNonZero = 18;
      while (numNonZero--) {
        *pxnew2 += (*pB36++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow3[22] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 };

      const int_T *pAidx = &colAidxRow3[0];
      const real_T *pA66 = &t15_2_P.Div_rdcontr_A[66];
      const real_T *xd = &t15_2_DWork.Div_rdcontr_DSTATE[0];
      real_T *pxnew3 = &xnew[3];
      int_T numNonZero = 21;
      *pxnew3 = (*pA66++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew3 += (*pA66++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow3[18] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        12, 13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow3[0];
      const real_T *pB54 = &t15_2_P.Div_rdcontr_B[54];
      const real_T *u = &t15_2_B.Divide13[0];
      real_T *pxnew3 = &xnew[3];
      int_T numNonZero = 18;
      while (numNonZero--) {
        *pxnew3 += (*pB54++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow4[22] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 };

      const int_T *pAidx = &colAidxRow4[0];
      const real_T *pA88 = &t15_2_P.Div_rdcontr_A[88];
      const real_T *xd = &t15_2_DWork.Div_rdcontr_DSTATE[0];
      real_T *pxnew4 = &xnew[4];
      int_T numNonZero = 21;
      *pxnew4 = (*pA88++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew4 += (*pA88++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow4[18] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        12, 13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow4[0];
      const real_T *pB72 = &t15_2_P.Div_rdcontr_B[72];
      const real_T *u = &t15_2_B.Divide13[0];
      real_T *pxnew4 = &xnew[4];
      int_T numNonZero = 18;
      while (numNonZero--) {
        *pxnew4 += (*pB72++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow5[22] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 };

      const int_T *pAidx = &colAidxRow5[0];
      const real_T *pA110 = &t15_2_P.Div_rdcontr_A[110];
      const real_T *xd = &t15_2_DWork.Div_rdcontr_DSTATE[0];
      real_T *pxnew5 = &xnew[5];
      int_T numNonZero = 21;
      *pxnew5 = (*pA110++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew5 += (*pA110++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow5[18] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        12, 13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow5[0];
      const real_T *pB90 = &t15_2_P.Div_rdcontr_B[90];
      const real_T *u = &t15_2_B.Divide13[0];
      real_T *pxnew5 = &xnew[5];
      int_T numNonZero = 18;
      while (numNonZero--) {
        *pxnew5 += (*pB90++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow6[22] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 };

      const int_T *pAidx = &colAidxRow6[0];
      const real_T *pA132 = &t15_2_P.Div_rdcontr_A[132];
      const real_T *xd = &t15_2_DWork.Div_rdcontr_DSTATE[0];
      real_T *pxnew6 = &xnew[6];
      int_T numNonZero = 21;
      *pxnew6 = (*pA132++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew6 += (*pA132++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow6[18] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        12, 13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow6[0];
      const real_T *pB108 = &t15_2_P.Div_rdcontr_B[108];
      const real_T *u = &t15_2_B.Divide13[0];
      real_T *pxnew6 = &xnew[6];
      int_T numNonZero = 18;
      while (numNonZero--) {
        *pxnew6 += (*pB108++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow7[22] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 };

      const int_T *pAidx = &colAidxRow7[0];
      const real_T *pA154 = &t15_2_P.Div_rdcontr_A[154];
      const real_T *xd = &t15_2_DWork.Div_rdcontr_DSTATE[0];
      real_T *pxnew7 = &xnew[7];
      int_T numNonZero = 21;
      *pxnew7 = (*pA154++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew7 += (*pA154++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow7[18] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        12, 13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow7[0];
      const real_T *pB126 = &t15_2_P.Div_rdcontr_B[126];
      const real_T *u = &t15_2_B.Divide13[0];
      real_T *pxnew7 = &xnew[7];
      int_T numNonZero = 18;
      while (numNonZero--) {
        *pxnew7 += (*pB126++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow8[22] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 };

      const int_T *pAidx = &colAidxRow8[0];
      const real_T *pA176 = &t15_2_P.Div_rdcontr_A[176];
      const real_T *xd = &t15_2_DWork.Div_rdcontr_DSTATE[0];
      real_T *pxnew8 = &xnew[8];
      int_T numNonZero = 21;
      *pxnew8 = (*pA176++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew8 += (*pA176++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow8[18] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        12, 13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow8[0];
      const real_T *pB144 = &t15_2_P.Div_rdcontr_B[144];
      const real_T *u = &t15_2_B.Divide13[0];
      real_T *pxnew8 = &xnew[8];
      int_T numNonZero = 18;
      while (numNonZero--) {
        *pxnew8 += (*pB144++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow9[22] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 };

      const int_T *pAidx = &colAidxRow9[0];
      const real_T *pA198 = &t15_2_P.Div_rdcontr_A[198];
      const real_T *xd = &t15_2_DWork.Div_rdcontr_DSTATE[0];
      real_T *pxnew9 = &xnew[9];
      int_T numNonZero = 21;
      *pxnew9 = (*pA198++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew9 += (*pA198++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow9[18] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        12, 13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow9[0];
      const real_T *pB162 = &t15_2_P.Div_rdcontr_B[162];
      const real_T *u = &t15_2_B.Divide13[0];
      real_T *pxnew9 = &xnew[9];
      int_T numNonZero = 18;
      while (numNonZero--) {
        *pxnew9 += (*pB162++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow10[22] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 };

      const int_T *pAidx = &colAidxRow10[0];
      const real_T *pA220 = &t15_2_P.Div_rdcontr_A[220];
      const real_T *xd = &t15_2_DWork.Div_rdcontr_DSTATE[0];
      real_T *pxnew10 = &xnew[10];
      int_T numNonZero = 21;
      *pxnew10 = (*pA220++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew10 += (*pA220++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow10[18] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        12, 13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow10[0];
      const real_T *pB180 = &t15_2_P.Div_rdcontr_B[180];
      const real_T *u = &t15_2_B.Divide13[0];
      real_T *pxnew10 = &xnew[10];
      int_T numNonZero = 18;
      while (numNonZero--) {
        *pxnew10 += (*pB180++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow11[22] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 };

      const int_T *pAidx = &colAidxRow11[0];
      const real_T *pA242 = &t15_2_P.Div_rdcontr_A[242];
      const real_T *xd = &t15_2_DWork.Div_rdcontr_DSTATE[0];
      real_T *pxnew11 = &xnew[11];
      int_T numNonZero = 21;
      *pxnew11 = (*pA242++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew11 += (*pA242++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow11[18] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        12, 13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow11[0];
      const real_T *pB198 = &t15_2_P.Div_rdcontr_B[198];
      const real_T *u = &t15_2_B.Divide13[0];
      real_T *pxnew11 = &xnew[11];
      int_T numNonZero = 18;
      while (numNonZero--) {
        *pxnew11 += (*pB198++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow12[22] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 };

      const int_T *pAidx = &colAidxRow12[0];
      const real_T *pA264 = &t15_2_P.Div_rdcontr_A[264];
      const real_T *xd = &t15_2_DWork.Div_rdcontr_DSTATE[0];
      real_T *pxnew12 = &xnew[12];
      int_T numNonZero = 21;
      *pxnew12 = (*pA264++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew12 += (*pA264++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow12[18] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        12, 13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow12[0];
      const real_T *pB216 = &t15_2_P.Div_rdcontr_B[216];
      const real_T *u = &t15_2_B.Divide13[0];
      real_T *pxnew12 = &xnew[12];
      int_T numNonZero = 18;
      while (numNonZero--) {
        *pxnew12 += (*pB216++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow13[22] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 };

      const int_T *pAidx = &colAidxRow13[0];
      const real_T *pA286 = &t15_2_P.Div_rdcontr_A[286];
      const real_T *xd = &t15_2_DWork.Div_rdcontr_DSTATE[0];
      real_T *pxnew13 = &xnew[13];
      int_T numNonZero = 21;
      *pxnew13 = (*pA286++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew13 += (*pA286++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow13[18] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        12, 13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow13[0];
      const real_T *pB234 = &t15_2_P.Div_rdcontr_B[234];
      const real_T *u = &t15_2_B.Divide13[0];
      real_T *pxnew13 = &xnew[13];
      int_T numNonZero = 18;
      while (numNonZero--) {
        *pxnew13 += (*pB234++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow14[22] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 };

      const int_T *pAidx = &colAidxRow14[0];
      const real_T *pA308 = &t15_2_P.Div_rdcontr_A[308];
      const real_T *xd = &t15_2_DWork.Div_rdcontr_DSTATE[0];
      real_T *pxnew14 = &xnew[14];
      int_T numNonZero = 21;
      *pxnew14 = (*pA308++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew14 += (*pA308++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow14[18] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11,
        12, 13, 14, 15, 16, 17, 18 };

      const int_T *pBidx = &colBidxRow14[0];
      const real_T *pB252 = &t15_2_P.Div_rdcontr_B[252];
      const real_T *u = &t15_2_B.Divide13[0];
      real_T *pxnew14 = &xnew[14];
      int_T numNonZero = 18;
      while (numNonZero--) {
        *pxnew14 += (*pB252++) * u[*pBidx++];
      }
    }

    xnew[15] = (t15_2_P.Div_rdcontr_A[330])*t15_2_DWork.Div_rdcontr_DSTATE[15];
    xnew[15] += (t15_2_P.Div_rdcontr_B[270])*t15_2_B.Divide13[0];
    xnew[16] = (t15_2_P.Div_rdcontr_A[331])*t15_2_DWork.Div_rdcontr_DSTATE[16];
    xnew[16] += (t15_2_P.Div_rdcontr_B[271])*t15_2_B.Divide13[1];
    xnew[17] = (t15_2_P.Div_rdcontr_A[332])*t15_2_DWork.Div_rdcontr_DSTATE[17];
    xnew[17] += (t15_2_P.Div_rdcontr_B[272])*t15_2_B.Divide13[2];
    xnew[18] = (t15_2_P.Div_rdcontr_A[333])*t15_2_DWork.Div_rdcontr_DSTATE[18];
    xnew[18] += (t15_2_P.Div_rdcontr_B[273])*t15_2_B.Divide13[3];
    xnew[19] = (t15_2_P.Div_rdcontr_A[334])*t15_2_DWork.Div_rdcontr_DSTATE[19];
    xnew[19] += (t15_2_P.Div_rdcontr_B[274])*t15_2_B.Divide13[4];
    xnew[20] = (t15_2_P.Div_rdcontr_A[335])*t15_2_DWork.Div_rdcontr_DSTATE[20];
    xnew[20] += (t15_2_P.Div_rdcontr_B[275])*t15_2_B.Divide13[5];
    xnew[21] = (t15_2_P.Div_rdcontr_A[336])*t15_2_DWork.Div_rdcontr_DSTATE[21];
    xnew[21] += (t15_2_P.Div_rdcontr_B[276])*t15_2_B.Divide13[7];
    (void) memcpy(&t15_2_DWork.Div_rdcontr_DSTATE[0], xnew,
                  sizeof(real_T)*22);
  }

  /* Update for DiscreteStateSpace: '<S15>/Curr. term. contr' */
  {
    real_T xnew[22];

    {
      static const int_T colAidxRow0[12] = { 0, 11, 12, 13, 14, 15, 16, 17, 18,
        19, 20, 21 };

      const int_T *pAidx = &colAidxRow0[0];
      const real_T *pA0 = t15_2_P.Currtermcontr_A;
      const real_T *xd = &t15_2_DWork.Currtermcontr_DSTATE[0];
      real_T *pxnew0 = &xnew[0];
      int_T numNonZero = 11;
      *pxnew0 = (*pA0++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew0 += (*pA0++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colAidxRow1[12] = { 1, 11, 12, 13, 14, 15, 16, 17, 18,
        19, 20, 21 };

      const int_T *pAidx = &colAidxRow1[0];
      const real_T *pA12 = &t15_2_P.Currtermcontr_A[12];
      const real_T *xd = &t15_2_DWork.Currtermcontr_DSTATE[0];
      real_T *pxnew1 = &xnew[1];
      int_T numNonZero = 11;
      *pxnew1 = (*pA12++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew1 += (*pA12++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colAidxRow2[12] = { 2, 11, 12, 13, 14, 15, 16, 17, 18,
        19, 20, 21 };

      const int_T *pAidx = &colAidxRow2[0];
      const real_T *pA24 = &t15_2_P.Currtermcontr_A[24];
      const real_T *xd = &t15_2_DWork.Currtermcontr_DSTATE[0];
      real_T *pxnew2 = &xnew[2];
      int_T numNonZero = 11;
      *pxnew2 = (*pA24++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew2 += (*pA24++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colAidxRow3[12] = { 3, 11, 12, 13, 14, 15, 16, 17, 18,
        19, 20, 21 };

      const int_T *pAidx = &colAidxRow3[0];
      const real_T *pA36 = &t15_2_P.Currtermcontr_A[36];
      const real_T *xd = &t15_2_DWork.Currtermcontr_DSTATE[0];
      real_T *pxnew3 = &xnew[3];
      int_T numNonZero = 11;
      *pxnew3 = (*pA36++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew3 += (*pA36++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colAidxRow4[12] = { 4, 11, 12, 13, 14, 15, 16, 17, 18,
        19, 20, 21 };

      const int_T *pAidx = &colAidxRow4[0];
      const real_T *pA48 = &t15_2_P.Currtermcontr_A[48];
      const real_T *xd = &t15_2_DWork.Currtermcontr_DSTATE[0];
      real_T *pxnew4 = &xnew[4];
      int_T numNonZero = 11;
      *pxnew4 = (*pA48++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew4 += (*pA48++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colAidxRow5[12] = { 5, 11, 12, 13, 14, 15, 16, 17, 18,
        19, 20, 21 };

      const int_T *pAidx = &colAidxRow5[0];
      const real_T *pA60 = &t15_2_P.Currtermcontr_A[60];
      const real_T *xd = &t15_2_DWork.Currtermcontr_DSTATE[0];
      real_T *pxnew5 = &xnew[5];
      int_T numNonZero = 11;
      *pxnew5 = (*pA60++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew5 += (*pA60++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colAidxRow6[12] = { 6, 11, 12, 13, 14, 15, 16, 17, 18,
        19, 20, 21 };

      const int_T *pAidx = &colAidxRow6[0];
      const real_T *pA72 = &t15_2_P.Currtermcontr_A[72];
      const real_T *xd = &t15_2_DWork.Currtermcontr_DSTATE[0];
      real_T *pxnew6 = &xnew[6];
      int_T numNonZero = 11;
      *pxnew6 = (*pA72++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew6 += (*pA72++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colAidxRow7[12] = { 7, 11, 12, 13, 14, 15, 16, 17, 18,
        19, 20, 21 };

      const int_T *pAidx = &colAidxRow7[0];
      const real_T *pA84 = &t15_2_P.Currtermcontr_A[84];
      const real_T *xd = &t15_2_DWork.Currtermcontr_DSTATE[0];
      real_T *pxnew7 = &xnew[7];
      int_T numNonZero = 11;
      *pxnew7 = (*pA84++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew7 += (*pA84++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colAidxRow8[12] = { 8, 11, 12, 13, 14, 15, 16, 17, 18,
        19, 20, 21 };

      const int_T *pAidx = &colAidxRow8[0];
      const real_T *pA96 = &t15_2_P.Currtermcontr_A[96];
      const real_T *xd = &t15_2_DWork.Currtermcontr_DSTATE[0];
      real_T *pxnew8 = &xnew[8];
      int_T numNonZero = 11;
      *pxnew8 = (*pA96++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew8 += (*pA96++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colAidxRow9[12] = { 9, 11, 12, 13, 14, 15, 16, 17, 18,
        19, 20, 21 };

      const int_T *pAidx = &colAidxRow9[0];
      const real_T *pA108 = &t15_2_P.Currtermcontr_A[108];
      const real_T *xd = &t15_2_DWork.Currtermcontr_DSTATE[0];
      real_T *pxnew9 = &xnew[9];
      int_T numNonZero = 11;
      *pxnew9 = (*pA108++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew9 += (*pA108++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colAidxRow10[12] = { 10, 11, 12, 13, 14, 15, 16, 17, 18,
        19, 20, 21 };

      const int_T *pAidx = &colAidxRow10[0];
      const real_T *pA120 = &t15_2_P.Currtermcontr_A[120];
      const real_T *xd = &t15_2_DWork.Currtermcontr_DSTATE[0];
      real_T *pxnew10 = &xnew[10];
      int_T numNonZero = 11;
      *pxnew10 = (*pA120++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew10 += (*pA120++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colAidxRow11[11] = { 11, 12, 13, 14, 15, 16, 17, 18, 19,
        20, 21 };

      const int_T *pAidx = &colAidxRow11[0];
      const real_T *pA132 = &t15_2_P.Currtermcontr_A[132];
      const real_T *xd = &t15_2_DWork.Currtermcontr_DSTATE[0];
      real_T *pxnew11 = &xnew[11];
      int_T numNonZero = 10;
      *pxnew11 = (*pA132++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew11 += (*pA132++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow11[11] = { 8, 9, 10, 11, 12, 13, 14, 15, 16,
        17, 18 };

      const int_T *pBidx = &colBidxRow11[0];
      const real_T *pB0 = t15_2_P.Currtermcontr_B;
      const real_T *u = &t15_2_B.Divide12_c[0];
      real_T *pxnew11 = &xnew[11];
      int_T numNonZero = 11;
      while (numNonZero--) {
        *pxnew11 += (*pB0++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow12[11] = { 11, 12, 13, 14, 15, 16, 17, 18, 19,
        20, 21 };

      const int_T *pAidx = &colAidxRow12[0];
      const real_T *pA143 = &t15_2_P.Currtermcontr_A[143];
      const real_T *xd = &t15_2_DWork.Currtermcontr_DSTATE[0];
      real_T *pxnew12 = &xnew[12];
      int_T numNonZero = 10;
      *pxnew12 = (*pA143++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew12 += (*pA143++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow12[11] = { 8, 9, 10, 11, 12, 13, 14, 15, 16,
        17, 18 };

      const int_T *pBidx = &colBidxRow12[0];
      const real_T *pB11 = &t15_2_P.Currtermcontr_B[11];
      const real_T *u = &t15_2_B.Divide12_c[0];
      real_T *pxnew12 = &xnew[12];
      int_T numNonZero = 11;
      while (numNonZero--) {
        *pxnew12 += (*pB11++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow13[11] = { 11, 12, 13, 14, 15, 16, 17, 18, 19,
        20, 21 };

      const int_T *pAidx = &colAidxRow13[0];
      const real_T *pA154 = &t15_2_P.Currtermcontr_A[154];
      const real_T *xd = &t15_2_DWork.Currtermcontr_DSTATE[0];
      real_T *pxnew13 = &xnew[13];
      int_T numNonZero = 10;
      *pxnew13 = (*pA154++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew13 += (*pA154++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow13[11] = { 8, 9, 10, 11, 12, 13, 14, 15, 16,
        17, 18 };

      const int_T *pBidx = &colBidxRow13[0];
      const real_T *pB22 = &t15_2_P.Currtermcontr_B[22];
      const real_T *u = &t15_2_B.Divide12_c[0];
      real_T *pxnew13 = &xnew[13];
      int_T numNonZero = 11;
      while (numNonZero--) {
        *pxnew13 += (*pB22++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow14[11] = { 11, 12, 13, 14, 15, 16, 17, 18, 19,
        20, 21 };

      const int_T *pAidx = &colAidxRow14[0];
      const real_T *pA165 = &t15_2_P.Currtermcontr_A[165];
      const real_T *xd = &t15_2_DWork.Currtermcontr_DSTATE[0];
      real_T *pxnew14 = &xnew[14];
      int_T numNonZero = 10;
      *pxnew14 = (*pA165++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew14 += (*pA165++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow14[11] = { 8, 9, 10, 11, 12, 13, 14, 15, 16,
        17, 18 };

      const int_T *pBidx = &colBidxRow14[0];
      const real_T *pB33 = &t15_2_P.Currtermcontr_B[33];
      const real_T *u = &t15_2_B.Divide12_c[0];
      real_T *pxnew14 = &xnew[14];
      int_T numNonZero = 11;
      while (numNonZero--) {
        *pxnew14 += (*pB33++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow15[11] = { 11, 12, 13, 14, 15, 16, 17, 18, 19,
        20, 21 };

      const int_T *pAidx = &colAidxRow15[0];
      const real_T *pA176 = &t15_2_P.Currtermcontr_A[176];
      const real_T *xd = &t15_2_DWork.Currtermcontr_DSTATE[0];
      real_T *pxnew15 = &xnew[15];
      int_T numNonZero = 10;
      *pxnew15 = (*pA176++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew15 += (*pA176++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow15[11] = { 8, 9, 10, 11, 12, 13, 14, 15, 16,
        17, 18 };

      const int_T *pBidx = &colBidxRow15[0];
      const real_T *pB44 = &t15_2_P.Currtermcontr_B[44];
      const real_T *u = &t15_2_B.Divide12_c[0];
      real_T *pxnew15 = &xnew[15];
      int_T numNonZero = 11;
      while (numNonZero--) {
        *pxnew15 += (*pB44++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow16[11] = { 11, 12, 13, 14, 15, 16, 17, 18, 19,
        20, 21 };

      const int_T *pAidx = &colAidxRow16[0];
      const real_T *pA187 = &t15_2_P.Currtermcontr_A[187];
      const real_T *xd = &t15_2_DWork.Currtermcontr_DSTATE[0];
      real_T *pxnew16 = &xnew[16];
      int_T numNonZero = 10;
      *pxnew16 = (*pA187++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew16 += (*pA187++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow16[11] = { 8, 9, 10, 11, 12, 13, 14, 15, 16,
        17, 18 };

      const int_T *pBidx = &colBidxRow16[0];
      const real_T *pB55 = &t15_2_P.Currtermcontr_B[55];
      const real_T *u = &t15_2_B.Divide12_c[0];
      real_T *pxnew16 = &xnew[16];
      int_T numNonZero = 11;
      while (numNonZero--) {
        *pxnew16 += (*pB55++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow17[11] = { 11, 12, 13, 14, 15, 16, 17, 18, 19,
        20, 21 };

      const int_T *pAidx = &colAidxRow17[0];
      const real_T *pA198 = &t15_2_P.Currtermcontr_A[198];
      const real_T *xd = &t15_2_DWork.Currtermcontr_DSTATE[0];
      real_T *pxnew17 = &xnew[17];
      int_T numNonZero = 10;
      *pxnew17 = (*pA198++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew17 += (*pA198++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow17[11] = { 8, 9, 10, 11, 12, 13, 14, 15, 16,
        17, 18 };

      const int_T *pBidx = &colBidxRow17[0];
      const real_T *pB66 = &t15_2_P.Currtermcontr_B[66];
      const real_T *u = &t15_2_B.Divide12_c[0];
      real_T *pxnew17 = &xnew[17];
      int_T numNonZero = 11;
      while (numNonZero--) {
        *pxnew17 += (*pB66++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow18[11] = { 11, 12, 13, 14, 15, 16, 17, 18, 19,
        20, 21 };

      const int_T *pAidx = &colAidxRow18[0];
      const real_T *pA209 = &t15_2_P.Currtermcontr_A[209];
      const real_T *xd = &t15_2_DWork.Currtermcontr_DSTATE[0];
      real_T *pxnew18 = &xnew[18];
      int_T numNonZero = 10;
      *pxnew18 = (*pA209++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew18 += (*pA209++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow18[11] = { 8, 9, 10, 11, 12, 13, 14, 15, 16,
        17, 18 };

      const int_T *pBidx = &colBidxRow18[0];
      const real_T *pB77 = &t15_2_P.Currtermcontr_B[77];
      const real_T *u = &t15_2_B.Divide12_c[0];
      real_T *pxnew18 = &xnew[18];
      int_T numNonZero = 11;
      while (numNonZero--) {
        *pxnew18 += (*pB77++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow19[11] = { 11, 12, 13, 14, 15, 16, 17, 18, 19,
        20, 21 };

      const int_T *pAidx = &colAidxRow19[0];
      const real_T *pA220 = &t15_2_P.Currtermcontr_A[220];
      const real_T *xd = &t15_2_DWork.Currtermcontr_DSTATE[0];
      real_T *pxnew19 = &xnew[19];
      int_T numNonZero = 10;
      *pxnew19 = (*pA220++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew19 += (*pA220++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow19[11] = { 8, 9, 10, 11, 12, 13, 14, 15, 16,
        17, 18 };

      const int_T *pBidx = &colBidxRow19[0];
      const real_T *pB88 = &t15_2_P.Currtermcontr_B[88];
      const real_T *u = &t15_2_B.Divide12_c[0];
      real_T *pxnew19 = &xnew[19];
      int_T numNonZero = 11;
      while (numNonZero--) {
        *pxnew19 += (*pB88++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow20[11] = { 11, 12, 13, 14, 15, 16, 17, 18, 19,
        20, 21 };

      const int_T *pAidx = &colAidxRow20[0];
      const real_T *pA231 = &t15_2_P.Currtermcontr_A[231];
      const real_T *xd = &t15_2_DWork.Currtermcontr_DSTATE[0];
      real_T *pxnew20 = &xnew[20];
      int_T numNonZero = 10;
      *pxnew20 = (*pA231++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew20 += (*pA231++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow20[11] = { 8, 9, 10, 11, 12, 13, 14, 15, 16,
        17, 18 };

      const int_T *pBidx = &colBidxRow20[0];
      const real_T *pB99 = &t15_2_P.Currtermcontr_B[99];
      const real_T *u = &t15_2_B.Divide12_c[0];
      real_T *pxnew20 = &xnew[20];
      int_T numNonZero = 11;
      while (numNonZero--) {
        *pxnew20 += (*pB99++) * u[*pBidx++];
      }
    }

    {
      static const int_T colAidxRow21[11] = { 11, 12, 13, 14, 15, 16, 17, 18, 19,
        20, 21 };

      const int_T *pAidx = &colAidxRow21[0];
      const real_T *pA242 = &t15_2_P.Currtermcontr_A[242];
      const real_T *xd = &t15_2_DWork.Currtermcontr_DSTATE[0];
      real_T *pxnew21 = &xnew[21];
      int_T numNonZero = 10;
      *pxnew21 = (*pA242++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew21 += (*pA242++) * xd[*pAidx++];
      }
    }

    {
      static const int_T colBidxRow21[11] = { 8, 9, 10, 11, 12, 13, 14, 15, 16,
        17, 18 };

      const int_T *pBidx = &colBidxRow21[0];
      const real_T *pB110 = &t15_2_P.Currtermcontr_B[110];
      const real_T *u = &t15_2_B.Divide12_c[0];
      real_T *pxnew21 = &xnew[21];
      int_T numNonZero = 11;
      while (numNonZero--) {
        *pxnew21 += (*pB110++) * u[*pBidx++];
      }
    }

    (void) memcpy(&t15_2_DWork.Currtermcontr_DSTATE[0], xnew,
                  sizeof(real_T)*22);
  }

  /* Update for UniformRandomNumber: '<S63>/Uniform Random Number' */
  tmin = t15_2_P.UniformRandomNumber_Minimum;
  t15_2_DWork.UniformRandomNumber_NextOutput =
    (t15_2_P.UniformRandomNumber_Maximum - tmin) * rt_urand_Upu32_Yd_f_pw_snf
    (&t15_2_DWork.RandSeed) + tmin;

  /* Update for UnitDelay: '<S83>/UD' */
  t15_2_DWork.UD_DSTATE_h = t15_2_B.Times;

  /* Update for DiscreteStateSpace: '<S60>/VS. contr' */
  {
    real_T xnew[9];
    xnew[0] = (t15_2_P.VScontr_A[0])*t15_2_DWork.VScontr_DSTATE[0] +
      (t15_2_P.VScontr_A[1])*t15_2_DWork.VScontr_DSTATE[1]
      + (t15_2_P.VScontr_A[2])*t15_2_DWork.VScontr_DSTATE[2]
      + (t15_2_P.VScontr_A[3])*t15_2_DWork.VScontr_DSTATE[7];
    xnew[0] += (t15_2_P.VScontr_B[0])*t15_2_B.Divide12_h[0] +
      (t15_2_P.VScontr_B[1])*t15_2_B.Divide12_h[1];
    xnew[1] = (t15_2_P.VScontr_A[4])*t15_2_DWork.VScontr_DSTATE[0] +
      (t15_2_P.VScontr_A[5])*t15_2_DWork.VScontr_DSTATE[1]
      + (t15_2_P.VScontr_A[6])*t15_2_DWork.VScontr_DSTATE[2]
      + (t15_2_P.VScontr_A[7])*t15_2_DWork.VScontr_DSTATE[7];
    xnew[1] += (t15_2_P.VScontr_B[2])*t15_2_B.Divide12_h[0] +
      (t15_2_P.VScontr_B[3])*t15_2_B.Divide12_h[1];
    xnew[2] = (t15_2_P.VScontr_A[8])*t15_2_DWork.VScontr_DSTATE[0] +
      (t15_2_P.VScontr_A[9])*t15_2_DWork.VScontr_DSTATE[1]
      + (t15_2_P.VScontr_A[10])*t15_2_DWork.VScontr_DSTATE[2]
      + (t15_2_P.VScontr_A[11])*t15_2_DWork.VScontr_DSTATE[7];
    xnew[2] += (t15_2_P.VScontr_B[4])*t15_2_B.Divide12_h[0] +
      (t15_2_P.VScontr_B[5])*t15_2_B.Divide12_h[1];

    {
      static const int_T colAidxRow3[5] = { 3, 4, 5, 6, 7 };

      const int_T *pAidx = &colAidxRow3[0];
      const real_T *pA12 = &t15_2_P.VScontr_A[12];
      const real_T *xd = &t15_2_DWork.VScontr_DSTATE[0];
      real_T *pxnew3 = &xnew[3];
      int_T numNonZero = 4;
      *pxnew3 = (*pA12++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew3 += (*pA12++) * xd[*pAidx++];
      }
    }

    xnew[3] += (t15_2_P.VScontr_B[6])*t15_2_B.Divide12_h[0] +
      (t15_2_P.VScontr_B[7])*t15_2_B.Divide12_h[1];

    {
      static const int_T colAidxRow4[5] = { 3, 4, 5, 6, 7 };

      const int_T *pAidx = &colAidxRow4[0];
      const real_T *pA17 = &t15_2_P.VScontr_A[17];
      const real_T *xd = &t15_2_DWork.VScontr_DSTATE[0];
      real_T *pxnew4 = &xnew[4];
      int_T numNonZero = 4;
      *pxnew4 = (*pA17++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew4 += (*pA17++) * xd[*pAidx++];
      }
    }

    xnew[4] += (t15_2_P.VScontr_B[8])*t15_2_B.Divide12_h[0] +
      (t15_2_P.VScontr_B[9])*t15_2_B.Divide12_h[1];

    {
      static const int_T colAidxRow5[5] = { 3, 4, 5, 6, 7 };

      const int_T *pAidx = &colAidxRow5[0];
      const real_T *pA22 = &t15_2_P.VScontr_A[22];
      const real_T *xd = &t15_2_DWork.VScontr_DSTATE[0];
      real_T *pxnew5 = &xnew[5];
      int_T numNonZero = 4;
      *pxnew5 = (*pA22++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew5 += (*pA22++) * xd[*pAidx++];
      }
    }

    xnew[5] += (t15_2_P.VScontr_B[10])*t15_2_B.Divide12_h[0] +
      (t15_2_P.VScontr_B[11])*t15_2_B.Divide12_h[1];

    {
      static const int_T colAidxRow6[5] = { 3, 4, 5, 6, 7 };

      const int_T *pAidx = &colAidxRow6[0];
      const real_T *pA27 = &t15_2_P.VScontr_A[27];
      const real_T *xd = &t15_2_DWork.VScontr_DSTATE[0];
      real_T *pxnew6 = &xnew[6];
      int_T numNonZero = 4;
      *pxnew6 = (*pA27++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew6 += (*pA27++) * xd[*pAidx++];
      }
    }

    xnew[6] += (t15_2_P.VScontr_B[12])*t15_2_B.Divide12_h[0] +
      (t15_2_P.VScontr_B[13])*t15_2_B.Divide12_h[1];
    xnew[7] = (t15_2_P.VScontr_A[32])*t15_2_DWork.VScontr_DSTATE[7];
    xnew[7] += (t15_2_P.VScontr_B[14])*t15_2_B.Divide12_h[0];
    xnew[8] = (t15_2_P.VScontr_A[33])*t15_2_DWork.VScontr_DSTATE[8];
    xnew[8] += (t15_2_P.VScontr_B[15])*t15_2_B.Divide12_h[1];
    (void) memcpy(&t15_2_DWork.VScontr_DSTATE[0], xnew,
                  sizeof(real_T)*9);
  }

  /* Update for DiscreteStateSpace: '<S60>/VS. contr hl' */
  {
    real_T xnew[8];
    xnew[0] = (t15_2_P.VScontrhl_A[0])*t15_2_DWork.VScontrhl_DSTATE[0] +
      (t15_2_P.VScontrhl_A[1])*t15_2_DWork.VScontrhl_DSTATE[1]
      + (t15_2_P.VScontrhl_A[2])*t15_2_DWork.VScontrhl_DSTATE[2]
      + (t15_2_P.VScontrhl_A[3])*t15_2_DWork.VScontrhl_DSTATE[7];
    xnew[0] += (t15_2_P.VScontrhl_B[0])*t15_2_B.Divide4_n[0] +
      (t15_2_P.VScontrhl_B[1])*t15_2_B.Divide4_n[1];
    xnew[1] = (t15_2_P.VScontrhl_A[4])*t15_2_DWork.VScontrhl_DSTATE[0] +
      (t15_2_P.VScontrhl_A[5])*t15_2_DWork.VScontrhl_DSTATE[1]
      + (t15_2_P.VScontrhl_A[6])*t15_2_DWork.VScontrhl_DSTATE[2]
      + (t15_2_P.VScontrhl_A[7])*t15_2_DWork.VScontrhl_DSTATE[7];
    xnew[1] += (t15_2_P.VScontrhl_B[2])*t15_2_B.Divide4_n[0] +
      (t15_2_P.VScontrhl_B[3])*t15_2_B.Divide4_n[1];
    xnew[2] = (t15_2_P.VScontrhl_A[8])*t15_2_DWork.VScontrhl_DSTATE[0] +
      (t15_2_P.VScontrhl_A[9])*t15_2_DWork.VScontrhl_DSTATE[1]
      + (t15_2_P.VScontrhl_A[10])*t15_2_DWork.VScontrhl_DSTATE[2]
      + (t15_2_P.VScontrhl_A[11])*t15_2_DWork.VScontrhl_DSTATE[7];
    xnew[2] += (t15_2_P.VScontrhl_B[4])*t15_2_B.Divide4_n[0] +
      (t15_2_P.VScontrhl_B[5])*t15_2_B.Divide4_n[1];

    {
      static const int_T colAidxRow3[5] = { 3, 4, 5, 6, 7 };

      const int_T *pAidx = &colAidxRow3[0];
      const real_T *pA12 = &t15_2_P.VScontrhl_A[12];
      const real_T *xd = &t15_2_DWork.VScontrhl_DSTATE[0];
      real_T *pxnew3 = &xnew[3];
      int_T numNonZero = 4;
      *pxnew3 = (*pA12++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew3 += (*pA12++) * xd[*pAidx++];
      }
    }

    xnew[3] += (t15_2_P.VScontrhl_B[6])*t15_2_B.Divide4_n[0] +
      (t15_2_P.VScontrhl_B[7])*t15_2_B.Divide4_n[1];

    {
      static const int_T colAidxRow4[5] = { 3, 4, 5, 6, 7 };

      const int_T *pAidx = &colAidxRow4[0];
      const real_T *pA17 = &t15_2_P.VScontrhl_A[17];
      const real_T *xd = &t15_2_DWork.VScontrhl_DSTATE[0];
      real_T *pxnew4 = &xnew[4];
      int_T numNonZero = 4;
      *pxnew4 = (*pA17++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew4 += (*pA17++) * xd[*pAidx++];
      }
    }

    xnew[4] += (t15_2_P.VScontrhl_B[8])*t15_2_B.Divide4_n[0] +
      (t15_2_P.VScontrhl_B[9])*t15_2_B.Divide4_n[1];

    {
      static const int_T colAidxRow5[5] = { 3, 4, 5, 6, 7 };

      const int_T *pAidx = &colAidxRow5[0];
      const real_T *pA22 = &t15_2_P.VScontrhl_A[22];
      const real_T *xd = &t15_2_DWork.VScontrhl_DSTATE[0];
      real_T *pxnew5 = &xnew[5];
      int_T numNonZero = 4;
      *pxnew5 = (*pA22++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew5 += (*pA22++) * xd[*pAidx++];
      }
    }

    xnew[5] += (t15_2_P.VScontrhl_B[10])*t15_2_B.Divide4_n[0] +
      (t15_2_P.VScontrhl_B[11])*t15_2_B.Divide4_n[1];

    {
      static const int_T colAidxRow6[5] = { 3, 4, 5, 6, 7 };

      const int_T *pAidx = &colAidxRow6[0];
      const real_T *pA27 = &t15_2_P.VScontrhl_A[27];
      const real_T *xd = &t15_2_DWork.VScontrhl_DSTATE[0];
      real_T *pxnew6 = &xnew[6];
      int_T numNonZero = 4;
      *pxnew6 = (*pA27++) * xd[*pAidx++];
      while (numNonZero--) {
        *pxnew6 += (*pA27++) * xd[*pAidx++];
      }
    }

    xnew[6] += (t15_2_P.VScontrhl_B[12])*t15_2_B.Divide4_n[0] +
      (t15_2_P.VScontrhl_B[13])*t15_2_B.Divide4_n[1];
    xnew[7] = (t15_2_P.VScontrhl_A[32])*t15_2_DWork.VScontrhl_DSTATE[7];
    xnew[7] += (t15_2_P.VScontrhl_B[14])*t15_2_B.Divide4_n[0];
    (void) memcpy(&t15_2_DWork.VScontrhl_DSTATE[0], xnew,
                  sizeof(real_T)*8);
  }

  /* Update for UnitDelay: '<S6>/UD' */
  t15_2_DWork.UD_DSTATE_e = t15_2_B.Times;

  /* Update absolute time for base rate */
  /* The "clockTick0" counts the number of times the code of this task has
   * been executed. The absolute time is the multiplication of "clockTick0"
   * and "Timing.stepSize0". Size of "clockTick0" ensures timer will not
   * overflow during the application lifespan selected.
   */
  t15_2_M->Timing.t[0] =
    (++t15_2_M->Timing.clockTick0) * t15_2_M->Timing.stepSize0;
}

/* Model initialize function */
void t15_2_initialize(void)
{
  /* Registration code */

  /* initialize non-finites */
  rt_InitInfAndNaN(sizeof(real_T));

  /* initialize real-time model */
  (void) memset((void *)t15_2_M, 0,
                sizeof(RT_MODEL_t15_2));
  rtsiSetSolverName(&t15_2_M->solverInfo,"FixedStepDiscrete");
  t15_2_M->solverInfoPtr = (&t15_2_M->solverInfo);

  /* Initialize timing info */
  {
    int_T *mdlTsMap = t15_2_M->Timing.sampleTimeTaskIDArray;
    mdlTsMap[0] = 0;
    t15_2_M->Timing.sampleTimeTaskIDPtr = (&mdlTsMap[0]);
    t15_2_M->Timing.sampleTimes = (&t15_2_M->Timing.sampleTimesArray[0]);
    t15_2_M->Timing.offsetTimes = (&t15_2_M->Timing.offsetTimesArray[0]);

    /* task periods */
    t15_2_M->Timing.sampleTimes[0] = (0.002);

    /* task offsets */
    t15_2_M->Timing.offsetTimes[0] = (0.0);
  }

  rtmSetTPtr(t15_2_M, &t15_2_M->Timing.tArray[0]);

  {
    int_T *mdlSampleHits = t15_2_M->Timing.sampleHitArray;
    mdlSampleHits[0] = 1;
    t15_2_M->Timing.sampleHits = (&mdlSampleHits[0]);
  }

  rtmSetTFinal(t15_2_M, -1);
  t15_2_M->Timing.stepSize0 = 0.002;
  t15_2_M->solverInfoPtr = (&t15_2_M->solverInfo);
  t15_2_M->Timing.stepSize = (0.002);
  rtsiSetFixedStepSize(&t15_2_M->solverInfo, 0.002);
  rtsiSetSolverMode(&t15_2_M->solverInfo, SOLVER_MODE_SINGLETASKING);

  /* block I/O */
  (void) memset(((void *) &t15_2_B), 0,
                sizeof(BlockIO_t15_2));

  {
    int_T i;
    for (i = 0; i < 6500; i++) {
      t15_2_B.SFunction1[i] = 0.0;
    }

    for (i = 0; i < 10000; i++) {
      t15_2_B.SFunction2[i] = 0.0;
    }

    for (i = 0; i < 17; i++) {
      t15_2_B.SFunction[i] = 0.0;
    }

    for (i = 0; i < 15; i++) {
      t15_2_B.e6_m[i] = 0.0;
    }

    for (i = 0; i < 100; i++) {
      t15_2_B.SFunction1_p[i] = 0.0;
    }

    for (i = 0; i < 6; i++) {
      t15_2_B.e2[i] = 0.0;
    }

    for (i = 0; i < 100; i++) {
      t15_2_B.SFunction1_j[i] = 0.0;
    }

    for (i = 0; i < 100; i++) {
      t15_2_B.SFunction1_pi[i] = 0.0;
    }

    for (i = 0; i < 100; i++) {
      t15_2_B.SFunction1_g[i] = 0.0;
    }

    for (i = 0; i < 100; i++) {
      t15_2_B.SFunction1_h[i] = 0.0;
    }

    for (i = 0; i < 100; i++) {
      t15_2_B.SFunction1_k[i] = 0.0;
    }

    for (i = 0; i < 100; i++) {
      t15_2_B.SFunction1_g0[i] = 0.0;
    }

    for (i = 0; i < 100; i++) {
      t15_2_B.SFunction1_h5[i] = 0.0;
    }

    for (i = 0; i < 100; i++) {
      t15_2_B.SFunction1_o[i] = 0.0;
    }

    for (i = 0; i < 100; i++) {
      t15_2_B.SFunction1_d[i] = 0.0;
    }

    for (i = 0; i < 100; i++) {
      t15_2_B.SFunction1_ha[i] = 0.0;
    }

    for (i = 0; i < 100; i++) {
      t15_2_B.SFunction1_m[i] = 0.0;
    }

    for (i = 0; i < 100; i++) {
      t15_2_B.SFunction1_ke[i] = 0.0;
    }

    for (i = 0; i < 6; i++) {
      t15_2_B.e2_l[i] = 0.0;
    }

    for (i = 0; i < 20; i++) {
      t15_2_B.u_g[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Memory1_a[i] = 0.0;
    }

    for (i = 0; i < 20; i++) {
      t15_2_B.Divide12_n[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Limcontr[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Currcontr[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.DataStoreRead2_p[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.switch1_l[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide5[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.e3_p[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Abs_k[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.DataStoreRead1_d2[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.DataStoreRead2_d[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide5_j[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Sum2_p[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide3[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Sum1[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide4[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide1_gh[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Saturation[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Memory1_h[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Memory_g[i] = 0.0;
    }

    for (i = 0; i < 20; i++) {
      t15_2_B.Divide2_a[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divcontr[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.u_e[i] = 0.0;
    }

    for (i = 0; i < 20; i++) {
      t15_2_B.Divide13[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Div_rdcontr[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.u_o[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide4_b[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Currtermcontr[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide5_d[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead_c[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.u01[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead1_dx[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead_dx[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.u01_a[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead1_h[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead_j[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.u01_i[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead1_p[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead_ck[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.u01_c[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead1_g[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead_h[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.u01_p[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead1_bu[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead_be[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.u01_o[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead1_i[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead_e[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.u01_k[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead1_o[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead_p[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.u01_d[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead1_n[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead_b1[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.u01_b[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead1_bb[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead_k[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.u01_ks[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead1_c[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead_n[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.u01_pp[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead1_oa[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide7[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Sum3[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide2_j[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Switch[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide6_g[i] = 0.0;
    }

    for (i = 0; i < 20; i++) {
      t15_2_B.G_curr_term[i] = 0.0;
    }

    for (i = 0; i < 20; i++) {
      t15_2_B.Divide12_c[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide1_ar[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.e6_g[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.DataStoreRead2_m[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide4_j[i] = 0.0;
    }

    for (i = 0; i < 44; i++) {
      t15_2_B.SFunction_k[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.DataStoreRead1_hg[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Memory1_hb[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.DataStoreRead1_k[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.u_k[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide1_p0[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Add1_fv[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide_o[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.u_p[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Switch_p[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Switch2[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide1_ne[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Add2_f[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Gain[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Switch_d[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Switch2_k[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.DataStoreRead2_c[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide3_e[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide1_lq[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide2_f[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Add1_b[i] = 0.0;
    }

    for (i = 0; i < 12; i++) {
      t15_2_B.TmpSignalConversionAtnpf12Inpor[i] = 0.0;
    }

    for (i = 0; i < 15; i++) {
      t15_2_B.npf12[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide3_p[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide1_he[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Sum2_gz[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide_c[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.u_m[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide_d[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide2_c[i] = 0.0;
    }

    for (i = 0; i < 49; i++) {
      t15_2_B.Selector[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.TmpSignalConversionAtg5_termref[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Selector1[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Divide6_m[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Add2_fd[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Selector_e[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Selector1_i[i] = 0.0;
    }

    for (i = 0; i < 49; i++) {
      t15_2_B.Selector_k[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.TmpSignalConversionAtg1_termref[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Selector1_n[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Divide6_b[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Add2_l[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Selector_o[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Selector1_d[i] = 0.0;
    }

    for (i = 0; i < 49; i++) {
      t15_2_B.Selector_p[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.TmpSignalConversionAtg6_termref[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Selector1_b[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Divide6_f[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Add2_m[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Selector_n[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Selector1_h[i] = 0.0;
    }

    for (i = 0; i < 49; i++) {
      t15_2_B.Selector_l[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.TmpSignalConversionAtg4_termref[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Selector1_e[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Divide6_bs[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Add2_mw[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Selector_h[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Selector1_o[i] = 0.0;
    }

    for (i = 0; i < 49; i++) {
      t15_2_B.Selector_d[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.TmpSignalConversionAtg3_termref[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Selector1_ee[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Divide6_i[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Add2_dp[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Selector_pi[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Selector1_j[i] = 0.0;
    }

    for (i = 0; i < 49; i++) {
      t15_2_B.Selector_a[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.TmpSignalConversionAtg2_termref[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Selector1_e2[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Divide6_mi[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Add2_o[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Selector_ln[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Selector1_c[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead1_ce[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead_m[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead1_f0[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead_o[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead1_gn[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead_np[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead1_az[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead_oa[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead1_bue[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead_do[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead1_l[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead_n5[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead1_fb[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead_ku[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead1_bh[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead_hg[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead1_ov[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead_c2[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead1_g4[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead_bo[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead1_gv[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead_iz[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead1_if[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.DataStoreRead_j4[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Selector_or[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Selector1_ip[i] = 0.0;
    }

    t15_2_B.Times = 0.0;
    t15_2_B.Memory2 = 0.0;
    t15_2_B.u = 0.0;
    t15_2_B.Ip1e4 = 0.0;
    t15_2_B.Sum2 = 0.0;
    t15_2_B.DataStoreRead1 = 0.0;
    t15_2_B.e6 = 0.0;
    t15_2_B.Memory1 = 0.0;
    t15_2_B.DataStoreRead1_j = 0.0;
    t15_2_B.e3 = 0.0;
    t15_2_B.DataStoreRead2 = 0.0;
    t15_2_B.Product1 = 0.0;
    t15_2_B.RelationalOperator = 0.0;
    t15_2_B.Memory = 0.0;
    t15_2_B.LogicalOperator = 0.0;
    t15_2_B.switch1 = 0.0;
    t15_2_B.Add2 = 0.0;
    t15_2_B.DataStoreRead = 0.0;
    t15_2_B.Product = 0.0;
    t15_2_B.Add1 = 0.0;
    t15_2_B.u_h = 0.0;
    t15_2_B.Memory1_f = 0.0;
    t15_2_B.c_eob = 0.0;
    t15_2_B.Divide6 = 0.0;
    t15_2_B.Add1_a = 0.0;
    t15_2_B.Memory2_n = 0.0;
    t15_2_B.c_eob1 = 0.0;
    t15_2_B.Memory1_n = 0.0;
    t15_2_B.c_eob_g = 0.0;
    t15_2_B.c_eob_k = 0.0;
    t15_2_B.Add2_d = 0.0;
    t15_2_B.Memory2_l = 0.0;
    t15_2_B.c_eob1_f = 0.0;
    t15_2_B.Memory1_fz = 0.0;
    t15_2_B.c_eob_kp = 0.0;
    t15_2_B.c_eob_i = 0.0;
    t15_2_B.Add1_l = 0.0;
    t15_2_B.DataStoreRead1_jr = 0.0;
    t15_2_B.RelationalOperator2 = 0.0;
    t15_2_B.Memory2_i = 0.0;
    t15_2_B.c_eob1_fq = 0.0;
    t15_2_B.Memory1_o = 0.0;
    t15_2_B.c_eob_d = 0.0;
    t15_2_B.c_eob_b = 0.0;
    t15_2_B.Add3 = 0.0;
    t15_2_B.Divide2 = 0.0;
    t15_2_B.Memory2_ib = 0.0;
    t15_2_B.c_eob1_o = 0.0;
    t15_2_B.Memory1_oa = 0.0;
    t15_2_B.c_eob_ka = 0.0;
    t15_2_B.c_eob_c = 0.0;
    t15_2_B.Add4 = 0.0;
    t15_2_B.DataStoreRead_l = 0.0;
    t15_2_B.DataStoreRead2_h = 0.0;
    t15_2_B.MinMax = 0.0;
    t15_2_B.RelationalOperator1 = 0.0;
    t15_2_B.Divide12 = 0.0;
    t15_2_B.Memory2_h = 0.0;
    t15_2_B.c_eob1_oa = 0.0;
    t15_2_B.Memory1_i = 0.0;
    t15_2_B.c_eob_m = 0.0;
    t15_2_B.c_eob_i3 = 0.0;
    t15_2_B.Add5 = 0.0;
    t15_2_B.Memory2_j = 0.0;
    t15_2_B.c_eob1_m = 0.0;
    t15_2_B.Memory1_oo = 0.0;
    t15_2_B.c_eob_i4 = 0.0;
    t15_2_B.c_eob_l = 0.0;
    t15_2_B.Add6 = 0.0;
    t15_2_B.Divide1 = 0.0;
    t15_2_B.Memory2_o = 0.0;
    t15_2_B.c_eob_im = 0.0;
    t15_2_B.Divide1_g = 0.0;
    t15_2_B.Add3_n = 0.0;
    t15_2_B.Memory2_li = 0.0;
    t15_2_B.c_eob_j = 0.0;
    t15_2_B.Divide1_d = 0.0;
    t15_2_B.Add1_f = 0.0;
    t15_2_B.Memory2_a = 0.0;
    t15_2_B.c_eob_n = 0.0;
    t15_2_B.Divide1_n = 0.0;
    t15_2_B.Add2_a = 0.0;
    t15_2_B.Memory2_p = 0.0;
    t15_2_B.c_eob_o = 0.0;
    t15_2_B.Divide1_h = 0.0;
    t15_2_B.Add4_b = 0.0;
    t15_2_B.Memory2_o2 = 0.0;
    t15_2_B.c_eob_e = 0.0;
    t15_2_B.Divide1_p = 0.0;
    t15_2_B.Add5_i = 0.0;
    t15_2_B.Memory2_hs = 0.0;
    t15_2_B.c_eob_f = 0.0;
    t15_2_B.Divide1_nx = 0.0;
    t15_2_B.Add6_a = 0.0;
    t15_2_B.Memory2_at = 0.0;
    t15_2_B.c_eob_cz = 0.0;
    t15_2_B.Divide1_l = 0.0;
    t15_2_B.Add7 = 0.0;
    t15_2_B.Memory2_b = 0.0;
    t15_2_B.c_eob_g2 = 0.0;
    t15_2_B.Divide1_m = 0.0;
    t15_2_B.Add8 = 0.0;
    t15_2_B.Memory2_i2 = 0.0;
    t15_2_B.c_eob_bq = 0.0;
    t15_2_B.Divide1_j = 0.0;
    t15_2_B.Add9 = 0.0;
    t15_2_B.Memory2_oz = 0.0;
    t15_2_B.c_eob_kx = 0.0;
    t15_2_B.Divide1_i = 0.0;
    t15_2_B.Add10 = 0.0;
    t15_2_B.Memory2_c = 0.0;
    t15_2_B.c_eob_dh = 0.0;
    t15_2_B.Divide1_a = 0.0;
    t15_2_B.Add11 = 0.0;
    t15_2_B.DataStoreRead1_d = 0.0;
    t15_2_B.RelationalOperator_c = 0.0;
    t15_2_B.Memory_b = 0.0;
    t15_2_B.LogicalOperator_f = 0.0;
    t15_2_B.Uk1 = 0.0;
    t15_2_B.Diff = 0.0;
    t15_2_B.Uk1_c = 0.0;
    t15_2_B.Diff_j = 0.0;
    t15_2_B.Divide = 0.0;
    t15_2_B.DataStoreRead_d = 0.0;
    t15_2_B.u15 = 0.0;
    t15_2_B.DataStoreRead_b = 0.0;
    t15_2_B.Memory3 = 0.0;
    t15_2_B.DataStoreRead_f = 0.0;
    t15_2_B.Abs = 0.0;
    t15_2_B.LogicalOperator1 = 0.0;
    t15_2_B.switch1_j = 0.0;
    t15_2_B.Subtract2 = 0.0;
    t15_2_B.Divide1_b = 0.0;
    t15_2_B.Subtract1 = 0.0;
    t15_2_B.Saturation1 = 0.0;
    t15_2_B.Memory1_nc = 0.0;
    t15_2_B.c_eob_kh = 0.0;
    t15_2_B.c_eob_kz = 0.0;
    t15_2_B.DataStoreRead_i = 0.0;
    t15_2_B.Subtract3 = 0.0;
    t15_2_B.DataStoreRead1_b = 0.0;
    t15_2_B.DataStoreRead_ia = 0.0;
    t15_2_B.Abs_d = 0.0;
    t15_2_B.LogicalOperator2 = 0.0;
    t15_2_B.DataStoreRead_bl = 0.0;
    t15_2_B.DataStoreRead1_jv = 0.0;
    t15_2_B.Abs_l = 0.0;
    t15_2_B.LogicalOperator1_i = 0.0;
    t15_2_B.Memory1_ih = 0.0;
    t15_2_B.DataStoreRead_a = 0.0;
    t15_2_B.LogicalOperator1_m = 0.0;
    t15_2_B.switch1_m = 0.0;
    t15_2_B.DataStoreRead_ft = 0.0;
    t15_2_B.Abs_b = 0.0;
    t15_2_B.LogicalOperator2_c = 0.0;
    t15_2_B.Subtract4 = 0.0;
    t15_2_B.volt1 = 0.0;
    t15_2_B.volt1_k = 0.0;
    t15_2_B.volt1_c = 0.0;
    t15_2_B.volt1_o = 0.0;
    t15_2_B.volt1_g = 0.0;
    t15_2_B.volt1_a = 0.0;
    t15_2_B.volt1_h = 0.0;
    t15_2_B.volt1_cs = 0.0;
    t15_2_B.volt1_op = 0.0;
    t15_2_B.volt1_m = 0.0;
    t15_2_B.volt1_d = 0.0;
    t15_2_B.Sum1_n = 0.0;
    t15_2_B.UniformRandomNumber = 0.0;
    t15_2_B.DataStoreRead_pa = 0.0;
    t15_2_B.u5 = 0.0;
    t15_2_B.Divide11 = 0.0;
    t15_2_B.Uk1_n = 0.0;
    t15_2_B.Diff_l = 0.0;
    t15_2_B.e3_n = 0.0;
    t15_2_B.Sqrt = 0.0;
    t15_2_B.Divide1_ap = 0.0;
    t15_2_B.Sum2_g = 0.0;
    t15_2_B.DataStoreRead_l4 = 0.0;
    t15_2_B.DataStoreRead2_e = 0.0;
    t15_2_B.MinMax_c = 0.0;
    t15_2_B.RelationalOperator1_k = 0.0;
    t15_2_B.Divide12_h[0] = 0.0;
    t15_2_B.Divide12_h[1] = 0.0;
    t15_2_B.VScontr[0] = 0.0;
    t15_2_B.VScontr[1] = 0.0;
    t15_2_B.Divide4_n[0] = 0.0;
    t15_2_B.Divide4_n[1] = 0.0;
    t15_2_B.VScontrhl[0] = 0.0;
    t15_2_B.VScontrhl[1] = 0.0;
    t15_2_B.c_eob_h[0] = 0.0;
    t15_2_B.c_eob_h[1] = 0.0;
    t15_2_B.DataStoreRead1_e = 0.0;
    t15_2_B.RelationalOperator2_j = 0.0;
    t15_2_B.DataStoreRead_je = 0.0;
    t15_2_B.Abs_lu = 0.0;
    t15_2_B.RelationalOperator1_d = 0.0;
    t15_2_B.LogicalOperator1_d = 0.0;
    t15_2_B.DataStoreRead_g = 0.0;
    t15_2_B.u5_e = 0.0;
    t15_2_B.Div = 0.0;
    t15_2_B.u_c[0] = 0.0;
    t15_2_B.u_c[1] = 0.0;
    t15_2_B.Divide10[0] = 0.0;
    t15_2_B.Divide10[1] = 0.0;
    t15_2_B.DataStoreRead_gv = 0.0;
    t15_2_B.DataStoreRead3 = 0.0;
    t15_2_B.Uk1_e = 0.0;
    t15_2_B.Diff_n = 0.0;
    t15_2_B.DataStoreRead1_bw = 0.0;
    t15_2_B.Switch2_e = 0.0;
    t15_2_B.DataStoreRead1_ht = 0.0;
    t15_2_B.Divide4_f = 0.0;
    t15_2_B.DataStoreRead3_d = 0.0;
    t15_2_B.Switch2_ec = 0.0;
    t15_2_B.Divide5_o = 0.0;
    t15_2_B.Subtract2_f = 0.0;
    t15_2_B.DataStoreRead1_a = 0.0;
    t15_2_B.Divide4_p = 0.0;
    t15_2_B.Subtract3_m = 0.0;
    t15_2_B.Saturation_c = 0.0;
    t15_2_B.Subtract1_c = 0.0;
    t15_2_B.Divide6_e = 0.0;
    t15_2_B.Switch2_p = 0.0;
    t15_2_B.Divide11_l[0] = 0.0;
    t15_2_B.Divide11_l[1] = 0.0;
    t15_2_B.DataStoreRead3_c = 0.0;
    t15_2_B.Switch_o = 0.0;
    t15_2_B.c_eob_oc[0] = 0.0;
    t15_2_B.c_eob_oc[1] = 0.0;
    t15_2_B.DataStoreRead1_pd = 0.0;
    t15_2_B.RelationalOperator2_i = 0.0;
    t15_2_B.LimDivtr = 0.0;
    t15_2_B.Divide8[0] = 0.0;
    t15_2_B.Divide8[1] = 0.0;
    t15_2_B.SatDiv = 0.0;
    t15_2_B.DataStoreRead2_n = 0.0;
    t15_2_B.Switch2_b = 0.0;
    t15_2_B.Switch_n = 0.0;
    t15_2_B.Divide15 = 0.0;
    t15_2_B.DataStoreRead4 = 0.0;
    t15_2_B.Switch2_kp = 0.0;
    t15_2_B.Divide_n[0] = 0.0;
    t15_2_B.Divide_n[1] = 0.0;
    t15_2_B.Switch_l = 0.0;
    t15_2_B.DataStoreRead_iq = 0.0;
    t15_2_B.DataStoreRead1_g5 = 0.0;
    t15_2_B.DataStoreRead_ny = 0.0;
    t15_2_B.Subtract3_h = 0.0;
    t15_2_B.Divide2_k = 0.0;
    t15_2_B.Saturation1_c = 0.0;
    t15_2_B.DataStoreRead2_l = 0.0;
    t15_2_B.u15_g = 0.0;
    t15_2_B.Divide9 = 0.0;
    t15_2_B.Saturation_p = 0.0;
    t15_2_B.DataStoreRead2_la = 0.0;
    t15_2_B.Sum3_l = 0.0;
    t15_2_B.DataStoreRead4_e = 0.0;
    t15_2_B.DataStoreRead3_k = 0.0;
    t15_2_B.Sum2_a = 0.0;
    t15_2_B.Divide1_c = 0.0;
    t15_2_B.Divide6_h = 0.0;
    t15_2_B.Sum = 0.0;
    t15_2_B.Divide2_h = 0.0;
    t15_2_B.Sum1_o = 0.0;
    t15_2_B.Switch2_d = 0.0;
    t15_2_B.Switch_g = 0.0;
    t15_2_B.DataStoreRead1_f = 0.0;
    t15_2_B.DataStoreRead_lq = 0.0;
    t15_2_B.g5_termref = 0.0;
    t15_2_B.g5ref = 0.0;
    t15_2_B.DataStoreRead1_br = 0.0;
    t15_2_B.DataStoreRead_f2 = 0.0;
    t15_2_B.g1_termref = 0.0;
    t15_2_B.g1ref = 0.0;
    t15_2_B.DataStoreRead1_m = 0.0;
    t15_2_B.DataStoreRead_hm = 0.0;
    t15_2_B.g6_termref = 0.0;
    t15_2_B.g6ref = 0.0;
    t15_2_B.DataStoreRead1_ju = 0.0;
    t15_2_B.DataStoreRead_a0 = 0.0;
    t15_2_B.g4_termref = 0.0;
    t15_2_B.g4ref = 0.0;
    t15_2_B.DataStoreRead1_hgi = 0.0;
    t15_2_B.DataStoreRead_i4 = 0.0;
    t15_2_B.g3_termref = 0.0;
    t15_2_B.g3ref = 0.0;
    t15_2_B.DataStoreRead1_ju3 = 0.0;
    t15_2_B.DataStoreRead_ky = 0.0;
    t15_2_B.g2_termref = 0.0;
    t15_2_B.g2ref = 0.0;
    t15_2_B.I1 = 0.0;
    t15_2_B.I1_i = 0.0;
    t15_2_B.I1_o = 0.0;
    t15_2_B.I1_a = 0.0;
    t15_2_B.I1_f = 0.0;
    t15_2_B.I1_n = 0.0;
    t15_2_B.I1_h = 0.0;
    t15_2_B.I1_oi = 0.0;
    t15_2_B.I1_h0 = 0.0;
    t15_2_B.I1_oj = 0.0;
    t15_2_B.I1_l = 0.0;
    t15_2_B.Ipref = 0.0;
    t15_2_B.elong = 0.0;
    t15_2_B.Add2_g = 0.0;
    t15_2_B.DataStoreRead1_ej = 0.0;
    t15_2_B.Divide_g[0] = 0.0;
    t15_2_B.Divide_g[1] = 0.0;
    t15_2_B.Divide_g[2] = 0.0;
    t15_2_B.Divide_g[3] = 0.0;
    t15_2_B.Gain1 = 0.0;
    t15_2_B.Switch_m = 0.0;
    t15_2_B.Gain_p = 0.0;
    t15_2_B.Switch_f = 0.0;
  }

  /* states (dwork) */
  (void) memset((void *)&t15_2_DWork, 0,
                sizeof(D_Work_t15_2));
  t15_2_DWork.UD_DSTATE = 0.0;
  t15_2_DWork.UD_DSTATE_p = 0.0;

  {
    int_T i;
    for (i = 0; i < 50; i++) {
      t15_2_DWork.Limcontr_DSTATE[i] = 0.0;
    }
  }

  {
    int_T i;
    for (i = 0; i < 11; i++) {
      t15_2_DWork.Currcontr_DSTATE[i] = 0.0;
    }
  }

  {
    int_T i;
    for (i = 0; i < 32; i++) {
      t15_2_DWork.Divcontr_DSTATE[i] = 0.0;
    }
  }

  {
    int_T i;
    for (i = 0; i < 22; i++) {
      t15_2_DWork.Div_rdcontr_DSTATE[i] = 0.0;
    }
  }

  {
    int_T i;
    for (i = 0; i < 22; i++) {
      t15_2_DWork.Currtermcontr_DSTATE[i] = 0.0;
    }
  }

  t15_2_DWork.UD_DSTATE_h = 0.0;

  {
    int_T i;
    for (i = 0; i < 9; i++) {
      t15_2_DWork.VScontr_DSTATE[i] = 0.0;
    }
  }

  {
    int_T i;
    for (i = 0; i < 8; i++) {
      t15_2_DWork.VScontrhl_DSTATE[i] = 0.0;
    }
  }

  t15_2_DWork.UD_DSTATE_e = 0.0;
  t15_2_DWork.Memory2_PreviousInput = 0.0;
  t15_2_DWork.Memory1_PreviousInput = 0.0;
  t15_2_DWork.Memory_PreviousInput = 0.0;
  t15_2_DWork.Memory1_PreviousInput_e = 0.0;
  t15_2_DWork.Memory2_PreviousInput_o = 0.0;
  t15_2_DWork.Memory1_PreviousInput_l = 0.0;
  t15_2_DWork.Memory2_PreviousInput_b = 0.0;
  t15_2_DWork.Memory1_PreviousInput_n = 0.0;
  t15_2_DWork.Memory2_PreviousInput_e = 0.0;
  t15_2_DWork.Memory1_PreviousInput_e4 = 0.0;
  t15_2_DWork.Memory2_PreviousInput_od = 0.0;
  t15_2_DWork.Memory1_PreviousInput_p = 0.0;
  t15_2_DWork.Memory2_PreviousInput_p = 0.0;
  t15_2_DWork.Memory1_PreviousInput_j = 0.0;
  t15_2_DWork.Memory2_PreviousInput_n = 0.0;
  t15_2_DWork.Memory1_PreviousInput_a = 0.0;
  t15_2_DWork.Memory2_PreviousInput_e2 = 0.0;
  t15_2_DWork.Memory2_PreviousInput_nv = 0.0;
  t15_2_DWork.Memory2_PreviousInput_h = 0.0;
  t15_2_DWork.Memory2_PreviousInput_l = 0.0;
  t15_2_DWork.Memory2_PreviousInput_pa = 0.0;
  t15_2_DWork.Memory2_PreviousInput_j = 0.0;
  t15_2_DWork.Memory2_PreviousInput_bt = 0.0;
  t15_2_DWork.Memory2_PreviousInput_i = 0.0;
  t15_2_DWork.Memory2_PreviousInput_iw = 0.0;
  t15_2_DWork.Memory2_PreviousInput_oh = 0.0;
  t15_2_DWork.Memory2_PreviousInput_nt = 0.0;
  t15_2_DWork.Memory_PreviousInput_h = 0.0;
  t15_2_DWork.Memory3_PreviousInput = 0.0;

  {
    int_T i;
    for (i = 0; i < 11; i++) {
      t15_2_DWork.Memory1_PreviousInput_k[i] = 0.0;
    }
  }

  t15_2_DWork.Memory1_PreviousInput_a0 = 0.0;

  {
    int_T i;
    for (i = 0; i < 11; i++) {
      t15_2_DWork.Memory1_PreviousInput_i[i] = 0.0;
    }
  }

  {
    int_T i;
    for (i = 0; i < 11; i++) {
      t15_2_DWork.Memory_PreviousInput_o[i] = 0.0;
    }
  }

  t15_2_DWork.Memory1_PreviousInput_an = 0.0;
  t15_2_DWork.UniformRandomNumber_NextOutput = 0.0;

  {
    int_T i;
    for (i = 0; i < 6500; i++) {
      t15_2_DWork.scr_data[i] = 0.0;
    }
  }

  {
    int_T i;
    for (i = 0; i < 10000; i++) {
      t15_2_DWork.volt[i] = 0.0;
    }
  }

  t15_2_DWork.c_a_tpl1_eob = 0.0;
  t15_2_DWork.c_a_tpl2 = 0.0;
  t15_2_DWork.c_a_tpl_min = 0.0;
  t15_2_DWork.y0 = 0.0;
  t15_2_DWork.c1_y0 = 0.0;
  t15_2_DWork.c2_y0 = 0.0;
  t15_2_DWork.t_tran2D = 0.0;
  t15_2_DWork.max_VS_lim = 0.0;
  t15_2_DWork.k_g4 = 0.0;
  t15_2_DWork.c_a_tpl1 = 0.0;
  t15_2_DWork.tcont2 = 0.0;
  t15_2_DWork.Ip_div = 0.0;
  t15_2_DWork.ref_ramp = 0.0;
  t15_2_DWork.dtcont2 = 0.0;
  t15_2_DWork.Ip_rd = 0.0;
  t15_2_DWork.trd_ref = 0.0;
  t15_2_DWork.Time_stop = 0.0;

  {
    int_T i;
    for (i = 0; i < 11; i++) {
      t15_2_DWork.Memory1_PreviousInput_p0[i] = 0.0;
    }
  }

  {
    int_T i;
    for (i = 0; i < 12; i++) {
      t15_2_DWork.ntur[i] = 0.0;
    }
  }

  {
    int_T i;
    for (i = 0; i < 6; i++) {
      t15_2_DWork.RupRd[i] = 0.0;
    }
  }

  t15_2_DWork.VS3_up = 0.0;

  {
    int_T i;
    for (i = 0; i < 11; i++) {
      t15_2_DWork.Vcspf_up[i] = 0.0;
    }
  }

  t15_2_DWork.VS1_up = 0.0;
  t15_2_DWork.Tu = 0.0;
  t15_2_DWork.c_cur_max = 0.0;

  {
    int_T i;
    for (i = 0; i < 11; i++) {
      t15_2_DWork.Imax[i] = 0.0;
    }
  }

  /* external inputs */
  {
    int_T i;
    for (i = 0; i < 15; i++) {
      t15_2_U.In1[i] = 0.0;
    }
  }

  {
    int_T i;
    for (i = 0; i < 123; i++) {
      t15_2_U.In2[i] = 0.0;
    }
  }

  /* external outputs */
  {
    int_T i;
    for (i = 0; i < 38; i++) {
      t15_2_Y.to_DINA[i] = 0.0;
    }
  }

  /* child S-Function registration */
  {
    RTWSfcnInfo *sfcnInfo = &t15_2_M->NonInlinedSFcns.sfcnInfo;
    t15_2_M->sfcnInfo = (sfcnInfo);
    rtssSetErrorStatusPtr(sfcnInfo, ((const char_T **)(&rtmGetErrorStatus
      (t15_2_M))));
    rtssSetNumRootSampTimesPtr(sfcnInfo, &t15_2_M->Sizes.numSampTimes);
    t15_2_M->NonInlinedSFcns.taskTimePtrs[0] = &(rtmGetTPtr(t15_2_M)[0]);
    rtssSetTPtrPtr(sfcnInfo,t15_2_M->NonInlinedSFcns.taskTimePtrs);
    rtssSetTStartPtr(sfcnInfo, &rtmGetTStart(t15_2_M));
    rtssSetTFinalPtr(sfcnInfo, &rtmGetTFinal(t15_2_M));
    rtssSetTimeOfLastOutputPtr(sfcnInfo, &rtmGetTimeOfLastOutput(t15_2_M));
    rtssSetStepSizePtr(sfcnInfo, &t15_2_M->Timing.stepSize);
    rtssSetStopRequestedPtr(sfcnInfo, &rtmGetStopRequested(t15_2_M));
    rtssSetDerivCacheNeedsResetPtr(sfcnInfo,
      &t15_2_M->ModelData.derivCacheNeedsReset);
    rtssSetZCCacheNeedsResetPtr(sfcnInfo, &t15_2_M->ModelData.zCCacheNeedsReset);
    rtssSetBlkStateChangePtr(sfcnInfo, &t15_2_M->ModelData.blkStateChange);
    rtssSetSampleHitsPtr(sfcnInfo, &t15_2_M->Timing.sampleHits);
    rtssSetPerTaskSampleHitsPtr(sfcnInfo, &t15_2_M->Timing.perTaskSampleHits);
    rtssSetSimModePtr(sfcnInfo, &t15_2_M->simMode);
    rtssSetSolverInfoPtr(sfcnInfo, &t15_2_M->solverInfoPtr);
  }

  t15_2_M->Sizes.numSFcns = (17);

  /* register each child */
  {
    (void) memset((void *)&t15_2_M->NonInlinedSFcns.childSFunctions[0], 0,
                  17*sizeof(SimStruct));
    t15_2_M->childSfunctions = (&t15_2_M->NonInlinedSFcns.childSFunctionPtrs[0]);

    {
      int_T i;
      for (i = 0; i < 17; i++) {
        t15_2_M->childSfunctions[i] = (&t15_2_M->
          NonInlinedSFcns.childSFunctions[i]);
      }
    }

    /* Level2 S-Function Block: t15_2/<S5>/S-Function1 (pf_lookup3) */
    {
      SimStruct *rts = t15_2_M->childSfunctions[0];

      /* timing info */
      time_T *sfcnPeriod = t15_2_M->NonInlinedSFcns.Sfcn0.sfcnPeriod;
      time_T *sfcnOffset = t15_2_M->NonInlinedSFcns.Sfcn0.sfcnOffset;
      int_T *sfcnTsMap = t15_2_M->NonInlinedSFcns.Sfcn0.sfcnTsMap;
      (void) memset((void*)sfcnPeriod, 0,
                    sizeof(time_T)*1);
      (void) memset((void*)sfcnOffset, 0,
                    sizeof(time_T)*1);
      ssSetSampleTimePtr(rts, &sfcnPeriod[0]);
      ssSetOffsetTimePtr(rts, &sfcnOffset[0]);
      ssSetSampleTimeTaskIDPtr(rts, sfcnTsMap);

      /* Set up the mdlInfo pointer */
      {
        ssSetBlkInfo2Ptr(rts, &t15_2_M->NonInlinedSFcns.blkInfo2[0]);
      }

      ssSetRTWSfcnInfo(rts, t15_2_M->sfcnInfo);

      /* Allocate memory of model methods 2 */
      {
        ssSetModelMethods2(rts, &t15_2_M->NonInlinedSFcns.methods2[0]);
      }

      /* Allocate memory of model methods 3 */
      {
        ssSetModelMethods3(rts, &t15_2_M->NonInlinedSFcns.methods3[0]);
      }

      /* Allocate memory for states auxilliary information */
      {
        ssSetStatesInfo2(rts, &t15_2_M->NonInlinedSFcns.statesInfo2[0]);
      }

      /* outputs */
      {
        ssSetPortInfoForOutputs(rts,
          &t15_2_M->NonInlinedSFcns.Sfcn0.outputPortInfo[0]);
        _ssSetNumOutputPorts(rts, 1);

        /* port 0 */
        {
          int_T *dimensions = (int_T *) &t15_2_M->NonInlinedSFcns.Sfcn0.oDims0;
          dimensions[0] = 13;
          dimensions[1] = 500;
          _ssSetOutputPortDimensionsPtr(rts, 0, dimensions);
          _ssSetOutputPortNumDimensions(rts, 0, 2);
          ssSetOutputPortWidth(rts, 0, 6500);
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.SFunction1));
        }
      }

      /* path info */
      ssSetModelName(rts, "S-Function1");
      ssSetPath(rts, "t15_2/Pow. Supply MC 2/kavin_contr/S-Function1");
      ssSetRTModel(rts,t15_2_M);
      ssSetParentSS(rts, (NULL));
      ssSetRootSS(rts, rts);
      ssSetVersion(rts, SIMSTRUCT_VERSION_LEVEL2);

      /* parameters */
      {
        mxArray **sfcnParams = (mxArray **)
          &t15_2_M->NonInlinedSFcns.Sfcn0.params;
        ssSetSFcnParamsCount(rts, 1);
        ssSetSFcnParamsPtr(rts, &sfcnParams[0]);
        ssSetSFcnParam(rts, 0, (mxArray*)t15_2_P.SFunction1_P1_Size);
      }

      /* registration */
      pf_lookup3(rts);
      sfcnInitializeSizes(rts);
      sfcnInitializeSampleTimes(rts);

      /* adjust sample time */
      ssSetSampleTime(rts, 0, 0.002);
      ssSetOffsetTime(rts, 0, 0.0);
      sfcnTsMap[0] = 0;

      /* set compiled values of dynamic vector attributes */
      ssSetNumNonsampledZCs(rts, 0);

      /* Update connectivity flags for each port */
      _ssSetOutputPortConnected(rts, 0, 1);
      _ssSetOutputPortBeingMerged(rts, 0, 0);

      /* Update the BufferDstPort flags for each input port */
    }

    /* Level2 S-Function Block: t15_2/<S5>/S-Function2 (read_volt) */
    {
      SimStruct *rts = t15_2_M->childSfunctions[1];

      /* timing info */
      time_T *sfcnPeriod = t15_2_M->NonInlinedSFcns.Sfcn1.sfcnPeriod;
      time_T *sfcnOffset = t15_2_M->NonInlinedSFcns.Sfcn1.sfcnOffset;
      int_T *sfcnTsMap = t15_2_M->NonInlinedSFcns.Sfcn1.sfcnTsMap;
      (void) memset((void*)sfcnPeriod, 0,
                    sizeof(time_T)*1);
      (void) memset((void*)sfcnOffset, 0,
                    sizeof(time_T)*1);
      ssSetSampleTimePtr(rts, &sfcnPeriod[0]);
      ssSetOffsetTimePtr(rts, &sfcnOffset[0]);
      ssSetSampleTimeTaskIDPtr(rts, sfcnTsMap);

      /* Set up the mdlInfo pointer */
      {
        ssSetBlkInfo2Ptr(rts, &t15_2_M->NonInlinedSFcns.blkInfo2[1]);
      }

      ssSetRTWSfcnInfo(rts, t15_2_M->sfcnInfo);

      /* Allocate memory of model methods 2 */
      {
        ssSetModelMethods2(rts, &t15_2_M->NonInlinedSFcns.methods2[1]);
      }

      /* Allocate memory of model methods 3 */
      {
        ssSetModelMethods3(rts, &t15_2_M->NonInlinedSFcns.methods3[1]);
      }

      /* Allocate memory for states auxilliary information */
      {
        ssSetStatesInfo2(rts, &t15_2_M->NonInlinedSFcns.statesInfo2[1]);
      }

      /* outputs */
      {
        ssSetPortInfoForOutputs(rts,
          &t15_2_M->NonInlinedSFcns.Sfcn1.outputPortInfo[0]);
        _ssSetNumOutputPorts(rts, 1);

        /* port 0 */
        {
          int_T *dimensions = (int_T *) &t15_2_M->NonInlinedSFcns.Sfcn1.oDims0;
          dimensions[0] = 20;
          dimensions[1] = 500;
          _ssSetOutputPortDimensionsPtr(rts, 0, dimensions);
          _ssSetOutputPortNumDimensions(rts, 0, 2);
          ssSetOutputPortWidth(rts, 0, 10000);
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.SFunction2));
        }
      }

      /* path info */
      ssSetModelName(rts, "S-Function2");
      ssSetPath(rts, "t15_2/Pow. Supply MC 2/kavin_contr/S-Function2");
      ssSetRTModel(rts,t15_2_M);
      ssSetParentSS(rts, (NULL));
      ssSetRootSS(rts, rts);
      ssSetVersion(rts, SIMSTRUCT_VERSION_LEVEL2);

      /* parameters */
      {
        mxArray **sfcnParams = (mxArray **)
          &t15_2_M->NonInlinedSFcns.Sfcn1.params;
        ssSetSFcnParamsCount(rts, 1);
        ssSetSFcnParamsPtr(rts, &sfcnParams[0]);
        ssSetSFcnParam(rts, 0, (mxArray*)t15_2_P.SFunction2_P1_Size);
      }

      /* registration */
      read_volt(rts);
      sfcnInitializeSizes(rts);
      sfcnInitializeSampleTimes(rts);

      /* adjust sample time */
      ssSetSampleTime(rts, 0, 0.002);
      ssSetOffsetTime(rts, 0, 0.0);
      sfcnTsMap[0] = 0;

      /* set compiled values of dynamic vector attributes */
      ssSetNumNonsampledZCs(rts, 0);

      /* Update connectivity flags for each port */
      _ssSetOutputPortConnected(rts, 0, 1);
      _ssSetOutputPortBeingMerged(rts, 0, 0);

      /* Update the BufferDstPort flags for each input port */
    }

    /* Level2 S-Function Block: t15_2/<S5>/S-Function (read_control_data2) */
    {
      SimStruct *rts = t15_2_M->childSfunctions[2];

      /* timing info */
      time_T *sfcnPeriod = t15_2_M->NonInlinedSFcns.Sfcn2.sfcnPeriod;
      time_T *sfcnOffset = t15_2_M->NonInlinedSFcns.Sfcn2.sfcnOffset;
      int_T *sfcnTsMap = t15_2_M->NonInlinedSFcns.Sfcn2.sfcnTsMap;
      (void) memset((void*)sfcnPeriod, 0,
                    sizeof(time_T)*1);
      (void) memset((void*)sfcnOffset, 0,
                    sizeof(time_T)*1);
      ssSetSampleTimePtr(rts, &sfcnPeriod[0]);
      ssSetOffsetTimePtr(rts, &sfcnOffset[0]);
      ssSetSampleTimeTaskIDPtr(rts, sfcnTsMap);

      /* Set up the mdlInfo pointer */
      {
        ssSetBlkInfo2Ptr(rts, &t15_2_M->NonInlinedSFcns.blkInfo2[2]);
      }

      ssSetRTWSfcnInfo(rts, t15_2_M->sfcnInfo);

      /* Allocate memory of model methods 2 */
      {
        ssSetModelMethods2(rts, &t15_2_M->NonInlinedSFcns.methods2[2]);
      }

      /* Allocate memory of model methods 3 */
      {
        ssSetModelMethods3(rts, &t15_2_M->NonInlinedSFcns.methods3[2]);
      }

      /* Allocate memory for states auxilliary information */
      {
        ssSetStatesInfo2(rts, &t15_2_M->NonInlinedSFcns.statesInfo2[2]);
      }

      /* outputs */
      {
        ssSetPortInfoForOutputs(rts,
          &t15_2_M->NonInlinedSFcns.Sfcn2.outputPortInfo[0]);
        _ssSetNumOutputPorts(rts, 1);

        /* port 0 */
        {
          _ssSetOutputPortNumDimensions(rts, 0, 1);
          ssSetOutputPortWidth(rts, 0, 17);
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.SFunction));
        }
      }

      /* path info */
      ssSetModelName(rts, "S-Function");
      ssSetPath(rts, "t15_2/Pow. Supply MC 2/kavin_contr/S-Function");
      ssSetRTModel(rts,t15_2_M);
      ssSetParentSS(rts, (NULL));
      ssSetRootSS(rts, rts);
      ssSetVersion(rts, SIMSTRUCT_VERSION_LEVEL2);

      /* registration */
      read_control_data2(rts);
      sfcnInitializeSizes(rts);
      sfcnInitializeSampleTimes(rts);

      /* adjust sample time */
      ssSetSampleTime(rts, 0, 0.002);
      ssSetOffsetTime(rts, 0, 0.0);
      sfcnTsMap[0] = 0;

      /* set compiled values of dynamic vector attributes */
      ssSetNumNonsampledZCs(rts, 0);

      /* Update connectivity flags for each port */
      _ssSetOutputPortConnected(rts, 0, 1);
      _ssSetOutputPortBeingMerged(rts, 0, 0);

      /* Update the BufferDstPort flags for each input port */
    }

    /* Level2 S-Function Block: t15_2/<S21>/S-Function1 (read_gaps) */
    {
      SimStruct *rts = t15_2_M->childSfunctions[3];

      /* timing info */
      time_T *sfcnPeriod = t15_2_M->NonInlinedSFcns.Sfcn3.sfcnPeriod;
      time_T *sfcnOffset = t15_2_M->NonInlinedSFcns.Sfcn3.sfcnOffset;
      int_T *sfcnTsMap = t15_2_M->NonInlinedSFcns.Sfcn3.sfcnTsMap;
      (void) memset((void*)sfcnPeriod, 0,
                    sizeof(time_T)*1);
      (void) memset((void*)sfcnOffset, 0,
                    sizeof(time_T)*1);
      ssSetSampleTimePtr(rts, &sfcnPeriod[0]);
      ssSetOffsetTimePtr(rts, &sfcnOffset[0]);
      ssSetSampleTimeTaskIDPtr(rts, sfcnTsMap);

      /* Set up the mdlInfo pointer */
      {
        ssSetBlkInfo2Ptr(rts, &t15_2_M->NonInlinedSFcns.blkInfo2[3]);
      }

      ssSetRTWSfcnInfo(rts, t15_2_M->sfcnInfo);

      /* Allocate memory of model methods 2 */
      {
        ssSetModelMethods2(rts, &t15_2_M->NonInlinedSFcns.methods2[3]);
      }

      /* Allocate memory of model methods 3 */
      {
        ssSetModelMethods3(rts, &t15_2_M->NonInlinedSFcns.methods3[3]);
      }

      /* Allocate memory for states auxilliary information */
      {
        ssSetStatesInfo2(rts, &t15_2_M->NonInlinedSFcns.statesInfo2[3]);
      }

      /* outputs */
      {
        ssSetPortInfoForOutputs(rts,
          &t15_2_M->NonInlinedSFcns.Sfcn3.outputPortInfo[0]);
        _ssSetNumOutputPorts(rts, 1);

        /* port 0 */
        {
          int_T *dimensions = (int_T *) &t15_2_M->NonInlinedSFcns.Sfcn3.oDims0;
          dimensions[0] = 2;
          dimensions[1] = 50;
          _ssSetOutputPortDimensionsPtr(rts, 0, dimensions);
          _ssSetOutputPortNumDimensions(rts, 0, 2);
          ssSetOutputPortWidth(rts, 0, 100);
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.SFunction1_p));
        }
      }

      /* path info */
      ssSetModelName(rts, "S-Function1");
      ssSetPath(rts,
                "t15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/elong_ref.dat/S-Function1");
      ssSetRTModel(rts,t15_2_M);
      ssSetParentSS(rts, (NULL));
      ssSetRootSS(rts, rts);
      ssSetVersion(rts, SIMSTRUCT_VERSION_LEVEL2);

      /* parameters */
      {
        mxArray **sfcnParams = (mxArray **)
          &t15_2_M->NonInlinedSFcns.Sfcn3.params;
        ssSetSFcnParamsCount(rts, 1);
        ssSetSFcnParamsPtr(rts, &sfcnParams[0]);
        ssSetSFcnParam(rts, 0, (mxArray*)t15_2_P.SFunction1_P1_Size_d);
      }

      /* registration */
      read_gaps(rts);
      sfcnInitializeSizes(rts);
      sfcnInitializeSampleTimes(rts);

      /* adjust sample time */
      ssSetSampleTime(rts, 0, 0.002);
      ssSetOffsetTime(rts, 0, 0.0);
      sfcnTsMap[0] = 0;

      /* set compiled values of dynamic vector attributes */
      ssSetNumNonsampledZCs(rts, 0);

      /* Update connectivity flags for each port */
      _ssSetOutputPortConnected(rts, 0, 1);
      _ssSetOutputPortBeingMerged(rts, 0, 0);

      /* Update the BufferDstPort flags for each input port */
    }

    /* Level2 S-Function Block: t15_2/<S44>/S-Function1 (read_gaps) */
    {
      SimStruct *rts = t15_2_M->childSfunctions[4];

      /* timing info */
      time_T *sfcnPeriod = t15_2_M->NonInlinedSFcns.Sfcn4.sfcnPeriod;
      time_T *sfcnOffset = t15_2_M->NonInlinedSFcns.Sfcn4.sfcnOffset;
      int_T *sfcnTsMap = t15_2_M->NonInlinedSFcns.Sfcn4.sfcnTsMap;
      (void) memset((void*)sfcnPeriod, 0,
                    sizeof(time_T)*1);
      (void) memset((void*)sfcnOffset, 0,
                    sizeof(time_T)*1);
      ssSetSampleTimePtr(rts, &sfcnPeriod[0]);
      ssSetOffsetTimePtr(rts, &sfcnOffset[0]);
      ssSetSampleTimeTaskIDPtr(rts, sfcnTsMap);

      /* Set up the mdlInfo pointer */
      {
        ssSetBlkInfo2Ptr(rts, &t15_2_M->NonInlinedSFcns.blkInfo2[4]);
      }

      ssSetRTWSfcnInfo(rts, t15_2_M->sfcnInfo);

      /* Allocate memory of model methods 2 */
      {
        ssSetModelMethods2(rts, &t15_2_M->NonInlinedSFcns.methods2[4]);
      }

      /* Allocate memory of model methods 3 */
      {
        ssSetModelMethods3(rts, &t15_2_M->NonInlinedSFcns.methods3[4]);
      }

      /* Allocate memory for states auxilliary information */
      {
        ssSetStatesInfo2(rts, &t15_2_M->NonInlinedSFcns.statesInfo2[4]);
      }

      /* outputs */
      {
        ssSetPortInfoForOutputs(rts,
          &t15_2_M->NonInlinedSFcns.Sfcn4.outputPortInfo[0]);
        _ssSetNumOutputPorts(rts, 1);

        /* port 0 */
        {
          int_T *dimensions = (int_T *) &t15_2_M->NonInlinedSFcns.Sfcn4.oDims0;
          dimensions[0] = 2;
          dimensions[1] = 50;
          _ssSetOutputPortDimensionsPtr(rts, 0, dimensions);
          _ssSetOutputPortNumDimensions(rts, 0, 2);
          ssSetOutputPortWidth(rts, 0, 100);
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.SFunction1_j));
        }
      }

      /* path info */
      ssSetModelName(rts, "S-Function1");
      ssSetPath(rts,
                "t15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/g1-g6.dat,g1_term-g6_term.dat/Subsystem6/S-Function1");
      ssSetRTModel(rts,t15_2_M);
      ssSetParentSS(rts, (NULL));
      ssSetRootSS(rts, rts);
      ssSetVersion(rts, SIMSTRUCT_VERSION_LEVEL2);

      /* parameters */
      {
        mxArray **sfcnParams = (mxArray **)
          &t15_2_M->NonInlinedSFcns.Sfcn4.params;
        ssSetSFcnParamsCount(rts, 1);
        ssSetSFcnParamsPtr(rts, &sfcnParams[0]);
        ssSetSFcnParam(rts, 0, (mxArray*)t15_2_P.SFunction1_P1_Size_dr);
      }

      /* registration */
      read_gaps(rts);
      sfcnInitializeSizes(rts);
      sfcnInitializeSampleTimes(rts);

      /* adjust sample time */
      ssSetSampleTime(rts, 0, 0.002);
      ssSetOffsetTime(rts, 0, 0.0);
      sfcnTsMap[0] = 0;

      /* set compiled values of dynamic vector attributes */
      ssSetNumNonsampledZCs(rts, 0);

      /* Update connectivity flags for each port */
      _ssSetOutputPortConnected(rts, 0, 1);
      _ssSetOutputPortBeingMerged(rts, 0, 0);

      /* Update the BufferDstPort flags for each input port */
    }

    /* Level2 S-Function Block: t15_2/<S50>/S-Function1 (read_gaps_term) */
    {
      SimStruct *rts = t15_2_M->childSfunctions[5];

      /* timing info */
      time_T *sfcnPeriod = t15_2_M->NonInlinedSFcns.Sfcn5.sfcnPeriod;
      time_T *sfcnOffset = t15_2_M->NonInlinedSFcns.Sfcn5.sfcnOffset;
      int_T *sfcnTsMap = t15_2_M->NonInlinedSFcns.Sfcn5.sfcnTsMap;
      (void) memset((void*)sfcnPeriod, 0,
                    sizeof(time_T)*1);
      (void) memset((void*)sfcnOffset, 0,
                    sizeof(time_T)*1);
      ssSetSampleTimePtr(rts, &sfcnPeriod[0]);
      ssSetOffsetTimePtr(rts, &sfcnOffset[0]);
      ssSetSampleTimeTaskIDPtr(rts, sfcnTsMap);

      /* Set up the mdlInfo pointer */
      {
        ssSetBlkInfo2Ptr(rts, &t15_2_M->NonInlinedSFcns.blkInfo2[5]);
      }

      ssSetRTWSfcnInfo(rts, t15_2_M->sfcnInfo);

      /* Allocate memory of model methods 2 */
      {
        ssSetModelMethods2(rts, &t15_2_M->NonInlinedSFcns.methods2[5]);
      }

      /* Allocate memory of model methods 3 */
      {
        ssSetModelMethods3(rts, &t15_2_M->NonInlinedSFcns.methods3[5]);
      }

      /* Allocate memory for states auxilliary information */
      {
        ssSetStatesInfo2(rts, &t15_2_M->NonInlinedSFcns.statesInfo2[5]);
      }

      /* outputs */
      {
        ssSetPortInfoForOutputs(rts,
          &t15_2_M->NonInlinedSFcns.Sfcn5.outputPortInfo[0]);
        _ssSetNumOutputPorts(rts, 1);

        /* port 0 */
        {
          int_T *dimensions = (int_T *) &t15_2_M->NonInlinedSFcns.Sfcn5.oDims0;
          dimensions[0] = 2;
          dimensions[1] = 50;
          _ssSetOutputPortDimensionsPtr(rts, 0, dimensions);
          _ssSetOutputPortNumDimensions(rts, 0, 2);
          ssSetOutputPortWidth(rts, 0, 100);
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.SFunction1_pi));
        }
      }

      /* path info */
      ssSetModelName(rts, "S-Function1");
      ssSetPath(rts,
                "t15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/g1-g6.dat,g1_term-g6_term.dat/Subsystem6/g1_term,ref/S-Function1");
      ssSetRTModel(rts,t15_2_M);
      ssSetParentSS(rts, (NULL));
      ssSetRootSS(rts, rts);
      ssSetVersion(rts, SIMSTRUCT_VERSION_LEVEL2);

      /* parameters */
      {
        mxArray **sfcnParams = (mxArray **)
          &t15_2_M->NonInlinedSFcns.Sfcn5.params;
        ssSetSFcnParamsCount(rts, 1);
        ssSetSFcnParamsPtr(rts, &sfcnParams[0]);
        ssSetSFcnParam(rts, 0, (mxArray*)t15_2_P.SFunction1_P1_Size_p);
      }

      /* registration */
      read_gaps_term(rts);
      sfcnInitializeSizes(rts);
      sfcnInitializeSampleTimes(rts);

      /* adjust sample time */
      ssSetSampleTime(rts, 0, 0.002);
      ssSetOffsetTime(rts, 0, 0.0);
      sfcnTsMap[0] = 0;

      /* set compiled values of dynamic vector attributes */
      ssSetNumNonsampledZCs(rts, 0);

      /* Update connectivity flags for each port */
      _ssSetOutputPortConnected(rts, 0, 1);
      _ssSetOutputPortBeingMerged(rts, 0, 0);

      /* Update the BufferDstPort flags for each input port */
    }

    /* Level2 S-Function Block: t15_2/<S40>/S-Function1 (read_gaps) */
    {
      SimStruct *rts = t15_2_M->childSfunctions[6];

      /* timing info */
      time_T *sfcnPeriod = t15_2_M->NonInlinedSFcns.Sfcn6.sfcnPeriod;
      time_T *sfcnOffset = t15_2_M->NonInlinedSFcns.Sfcn6.sfcnOffset;
      int_T *sfcnTsMap = t15_2_M->NonInlinedSFcns.Sfcn6.sfcnTsMap;
      (void) memset((void*)sfcnPeriod, 0,
                    sizeof(time_T)*1);
      (void) memset((void*)sfcnOffset, 0,
                    sizeof(time_T)*1);
      ssSetSampleTimePtr(rts, &sfcnPeriod[0]);
      ssSetOffsetTimePtr(rts, &sfcnOffset[0]);
      ssSetSampleTimeTaskIDPtr(rts, sfcnTsMap);

      /* Set up the mdlInfo pointer */
      {
        ssSetBlkInfo2Ptr(rts, &t15_2_M->NonInlinedSFcns.blkInfo2[6]);
      }

      ssSetRTWSfcnInfo(rts, t15_2_M->sfcnInfo);

      /* Allocate memory of model methods 2 */
      {
        ssSetModelMethods2(rts, &t15_2_M->NonInlinedSFcns.methods2[6]);
      }

      /* Allocate memory of model methods 3 */
      {
        ssSetModelMethods3(rts, &t15_2_M->NonInlinedSFcns.methods3[6]);
      }

      /* Allocate memory for states auxilliary information */
      {
        ssSetStatesInfo2(rts, &t15_2_M->NonInlinedSFcns.statesInfo2[6]);
      }

      /* outputs */
      {
        ssSetPortInfoForOutputs(rts,
          &t15_2_M->NonInlinedSFcns.Sfcn6.outputPortInfo[0]);
        _ssSetNumOutputPorts(rts, 1);

        /* port 0 */
        {
          int_T *dimensions = (int_T *) &t15_2_M->NonInlinedSFcns.Sfcn6.oDims0;
          dimensions[0] = 2;
          dimensions[1] = 50;
          _ssSetOutputPortDimensionsPtr(rts, 0, dimensions);
          _ssSetOutputPortNumDimensions(rts, 0, 2);
          ssSetOutputPortWidth(rts, 0, 100);
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.SFunction1_g));
        }
      }

      /* path info */
      ssSetModelName(rts, "S-Function1");
      ssSetPath(rts,
                "t15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/g1-g6.dat,g1_term-g6_term.dat/Subsystem1/S-Function1");
      ssSetRTModel(rts,t15_2_M);
      ssSetParentSS(rts, (NULL));
      ssSetRootSS(rts, rts);
      ssSetVersion(rts, SIMSTRUCT_VERSION_LEVEL2);

      /* parameters */
      {
        mxArray **sfcnParams = (mxArray **)
          &t15_2_M->NonInlinedSFcns.Sfcn6.params;
        ssSetSFcnParamsCount(rts, 1);
        ssSetSFcnParamsPtr(rts, &sfcnParams[0]);
        ssSetSFcnParam(rts, 0, (mxArray*)t15_2_P.SFunction1_P1_Size_m);
      }

      /* registration */
      read_gaps(rts);
      sfcnInitializeSizes(rts);
      sfcnInitializeSampleTimes(rts);

      /* adjust sample time */
      ssSetSampleTime(rts, 0, 0.002);
      ssSetOffsetTime(rts, 0, 0.0);
      sfcnTsMap[0] = 0;

      /* set compiled values of dynamic vector attributes */
      ssSetNumNonsampledZCs(rts, 0);

      /* Update connectivity flags for each port */
      _ssSetOutputPortConnected(rts, 0, 1);
      _ssSetOutputPortBeingMerged(rts, 0, 0);

      /* Update the BufferDstPort flags for each input port */
    }

    /* Level2 S-Function Block: t15_2/<S46>/S-Function1 (read_gaps_term) */
    {
      SimStruct *rts = t15_2_M->childSfunctions[7];

      /* timing info */
      time_T *sfcnPeriod = t15_2_M->NonInlinedSFcns.Sfcn7.sfcnPeriod;
      time_T *sfcnOffset = t15_2_M->NonInlinedSFcns.Sfcn7.sfcnOffset;
      int_T *sfcnTsMap = t15_2_M->NonInlinedSFcns.Sfcn7.sfcnTsMap;
      (void) memset((void*)sfcnPeriod, 0,
                    sizeof(time_T)*1);
      (void) memset((void*)sfcnOffset, 0,
                    sizeof(time_T)*1);
      ssSetSampleTimePtr(rts, &sfcnPeriod[0]);
      ssSetOffsetTimePtr(rts, &sfcnOffset[0]);
      ssSetSampleTimeTaskIDPtr(rts, sfcnTsMap);

      /* Set up the mdlInfo pointer */
      {
        ssSetBlkInfo2Ptr(rts, &t15_2_M->NonInlinedSFcns.blkInfo2[7]);
      }

      ssSetRTWSfcnInfo(rts, t15_2_M->sfcnInfo);

      /* Allocate memory of model methods 2 */
      {
        ssSetModelMethods2(rts, &t15_2_M->NonInlinedSFcns.methods2[7]);
      }

      /* Allocate memory of model methods 3 */
      {
        ssSetModelMethods3(rts, &t15_2_M->NonInlinedSFcns.methods3[7]);
      }

      /* Allocate memory for states auxilliary information */
      {
        ssSetStatesInfo2(rts, &t15_2_M->NonInlinedSFcns.statesInfo2[7]);
      }

      /* outputs */
      {
        ssSetPortInfoForOutputs(rts,
          &t15_2_M->NonInlinedSFcns.Sfcn7.outputPortInfo[0]);
        _ssSetNumOutputPorts(rts, 1);

        /* port 0 */
        {
          int_T *dimensions = (int_T *) &t15_2_M->NonInlinedSFcns.Sfcn7.oDims0;
          dimensions[0] = 2;
          dimensions[1] = 50;
          _ssSetOutputPortDimensionsPtr(rts, 0, dimensions);
          _ssSetOutputPortNumDimensions(rts, 0, 2);
          ssSetOutputPortWidth(rts, 0, 100);
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.SFunction1_h));
        }
      }

      /* path info */
      ssSetModelName(rts, "S-Function1");
      ssSetPath(rts,
                "t15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/g1-g6.dat,g1_term-g6_term.dat/Subsystem1/g2_term,ref/S-Function1");
      ssSetRTModel(rts,t15_2_M);
      ssSetParentSS(rts, (NULL));
      ssSetRootSS(rts, rts);
      ssSetVersion(rts, SIMSTRUCT_VERSION_LEVEL2);

      /* parameters */
      {
        mxArray **sfcnParams = (mxArray **)
          &t15_2_M->NonInlinedSFcns.Sfcn7.params;
        ssSetSFcnParamsCount(rts, 1);
        ssSetSFcnParamsPtr(rts, &sfcnParams[0]);
        ssSetSFcnParam(rts, 0, (mxArray*)t15_2_P.SFunction1_P1_Size_dz);
      }

      /* registration */
      read_gaps_term(rts);
      sfcnInitializeSizes(rts);
      sfcnInitializeSampleTimes(rts);

      /* adjust sample time */
      ssSetSampleTime(rts, 0, 0.002);
      ssSetOffsetTime(rts, 0, 0.0);
      sfcnTsMap[0] = 0;

      /* set compiled values of dynamic vector attributes */
      ssSetNumNonsampledZCs(rts, 0);

      /* Update connectivity flags for each port */
      _ssSetOutputPortConnected(rts, 0, 1);
      _ssSetOutputPortBeingMerged(rts, 0, 0);

      /* Update the BufferDstPort flags for each input port */
    }

    /* Level2 S-Function Block: t15_2/<S41>/S-Function1 (read_gaps) */
    {
      SimStruct *rts = t15_2_M->childSfunctions[8];

      /* timing info */
      time_T *sfcnPeriod = t15_2_M->NonInlinedSFcns.Sfcn8.sfcnPeriod;
      time_T *sfcnOffset = t15_2_M->NonInlinedSFcns.Sfcn8.sfcnOffset;
      int_T *sfcnTsMap = t15_2_M->NonInlinedSFcns.Sfcn8.sfcnTsMap;
      (void) memset((void*)sfcnPeriod, 0,
                    sizeof(time_T)*1);
      (void) memset((void*)sfcnOffset, 0,
                    sizeof(time_T)*1);
      ssSetSampleTimePtr(rts, &sfcnPeriod[0]);
      ssSetOffsetTimePtr(rts, &sfcnOffset[0]);
      ssSetSampleTimeTaskIDPtr(rts, sfcnTsMap);

      /* Set up the mdlInfo pointer */
      {
        ssSetBlkInfo2Ptr(rts, &t15_2_M->NonInlinedSFcns.blkInfo2[8]);
      }

      ssSetRTWSfcnInfo(rts, t15_2_M->sfcnInfo);

      /* Allocate memory of model methods 2 */
      {
        ssSetModelMethods2(rts, &t15_2_M->NonInlinedSFcns.methods2[8]);
      }

      /* Allocate memory of model methods 3 */
      {
        ssSetModelMethods3(rts, &t15_2_M->NonInlinedSFcns.methods3[8]);
      }

      /* Allocate memory for states auxilliary information */
      {
        ssSetStatesInfo2(rts, &t15_2_M->NonInlinedSFcns.statesInfo2[8]);
      }

      /* outputs */
      {
        ssSetPortInfoForOutputs(rts,
          &t15_2_M->NonInlinedSFcns.Sfcn8.outputPortInfo[0]);
        _ssSetNumOutputPorts(rts, 1);

        /* port 0 */
        {
          int_T *dimensions = (int_T *) &t15_2_M->NonInlinedSFcns.Sfcn8.oDims0;
          dimensions[0] = 2;
          dimensions[1] = 50;
          _ssSetOutputPortDimensionsPtr(rts, 0, dimensions);
          _ssSetOutputPortNumDimensions(rts, 0, 2);
          ssSetOutputPortWidth(rts, 0, 100);
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.SFunction1_k));
        }
      }

      /* path info */
      ssSetModelName(rts, "S-Function1");
      ssSetPath(rts,
                "t15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/g1-g6.dat,g1_term-g6_term.dat/Subsystem2/S-Function1");
      ssSetRTModel(rts,t15_2_M);
      ssSetParentSS(rts, (NULL));
      ssSetRootSS(rts, rts);
      ssSetVersion(rts, SIMSTRUCT_VERSION_LEVEL2);

      /* parameters */
      {
        mxArray **sfcnParams = (mxArray **)
          &t15_2_M->NonInlinedSFcns.Sfcn8.params;
        ssSetSFcnParamsCount(rts, 1);
        ssSetSFcnParamsPtr(rts, &sfcnParams[0]);
        ssSetSFcnParam(rts, 0, (mxArray*)t15_2_P.SFunction1_P1_Size_p4);
      }

      /* registration */
      read_gaps(rts);
      sfcnInitializeSizes(rts);
      sfcnInitializeSampleTimes(rts);

      /* adjust sample time */
      ssSetSampleTime(rts, 0, 0.002);
      ssSetOffsetTime(rts, 0, 0.0);
      sfcnTsMap[0] = 0;

      /* set compiled values of dynamic vector attributes */
      ssSetNumNonsampledZCs(rts, 0);

      /* Update connectivity flags for each port */
      _ssSetOutputPortConnected(rts, 0, 1);
      _ssSetOutputPortBeingMerged(rts, 0, 0);

      /* Update the BufferDstPort flags for each input port */
    }

    /* Level2 S-Function Block: t15_2/<S47>/S-Function1 (read_gaps_term) */
    {
      SimStruct *rts = t15_2_M->childSfunctions[9];

      /* timing info */
      time_T *sfcnPeriod = t15_2_M->NonInlinedSFcns.Sfcn9.sfcnPeriod;
      time_T *sfcnOffset = t15_2_M->NonInlinedSFcns.Sfcn9.sfcnOffset;
      int_T *sfcnTsMap = t15_2_M->NonInlinedSFcns.Sfcn9.sfcnTsMap;
      (void) memset((void*)sfcnPeriod, 0,
                    sizeof(time_T)*1);
      (void) memset((void*)sfcnOffset, 0,
                    sizeof(time_T)*1);
      ssSetSampleTimePtr(rts, &sfcnPeriod[0]);
      ssSetOffsetTimePtr(rts, &sfcnOffset[0]);
      ssSetSampleTimeTaskIDPtr(rts, sfcnTsMap);

      /* Set up the mdlInfo pointer */
      {
        ssSetBlkInfo2Ptr(rts, &t15_2_M->NonInlinedSFcns.blkInfo2[9]);
      }

      ssSetRTWSfcnInfo(rts, t15_2_M->sfcnInfo);

      /* Allocate memory of model methods 2 */
      {
        ssSetModelMethods2(rts, &t15_2_M->NonInlinedSFcns.methods2[9]);
      }

      /* Allocate memory of model methods 3 */
      {
        ssSetModelMethods3(rts, &t15_2_M->NonInlinedSFcns.methods3[9]);
      }

      /* Allocate memory for states auxilliary information */
      {
        ssSetStatesInfo2(rts, &t15_2_M->NonInlinedSFcns.statesInfo2[9]);
      }

      /* outputs */
      {
        ssSetPortInfoForOutputs(rts,
          &t15_2_M->NonInlinedSFcns.Sfcn9.outputPortInfo[0]);
        _ssSetNumOutputPorts(rts, 1);

        /* port 0 */
        {
          int_T *dimensions = (int_T *) &t15_2_M->NonInlinedSFcns.Sfcn9.oDims0;
          dimensions[0] = 2;
          dimensions[1] = 50;
          _ssSetOutputPortDimensionsPtr(rts, 0, dimensions);
          _ssSetOutputPortNumDimensions(rts, 0, 2);
          ssSetOutputPortWidth(rts, 0, 100);
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.SFunction1_g0));
        }
      }

      /* path info */
      ssSetModelName(rts, "S-Function1");
      ssSetPath(rts,
                "t15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/g1-g6.dat,g1_term-g6_term.dat/Subsystem2/g3_term,ref/S-Function1");
      ssSetRTModel(rts,t15_2_M);
      ssSetParentSS(rts, (NULL));
      ssSetRootSS(rts, rts);
      ssSetVersion(rts, SIMSTRUCT_VERSION_LEVEL2);

      /* parameters */
      {
        mxArray **sfcnParams = (mxArray **)
          &t15_2_M->NonInlinedSFcns.Sfcn9.params;
        ssSetSFcnParamsCount(rts, 1);
        ssSetSFcnParamsPtr(rts, &sfcnParams[0]);
        ssSetSFcnParam(rts, 0, (mxArray*)t15_2_P.SFunction1_P1_Size_c);
      }

      /* registration */
      read_gaps_term(rts);
      sfcnInitializeSizes(rts);
      sfcnInitializeSampleTimes(rts);

      /* adjust sample time */
      ssSetSampleTime(rts, 0, 0.002);
      ssSetOffsetTime(rts, 0, 0.0);
      sfcnTsMap[0] = 0;

      /* set compiled values of dynamic vector attributes */
      ssSetNumNonsampledZCs(rts, 0);

      /* Update connectivity flags for each port */
      _ssSetOutputPortConnected(rts, 0, 1);
      _ssSetOutputPortBeingMerged(rts, 0, 0);

      /* Update the BufferDstPort flags for each input port */
    }

    /* Level2 S-Function Block: t15_2/<S42>/S-Function1 (read_gaps) */
    {
      SimStruct *rts = t15_2_M->childSfunctions[10];

      /* timing info */
      time_T *sfcnPeriod = t15_2_M->NonInlinedSFcns.Sfcn10.sfcnPeriod;
      time_T *sfcnOffset = t15_2_M->NonInlinedSFcns.Sfcn10.sfcnOffset;
      int_T *sfcnTsMap = t15_2_M->NonInlinedSFcns.Sfcn10.sfcnTsMap;
      (void) memset((void*)sfcnPeriod, 0,
                    sizeof(time_T)*1);
      (void) memset((void*)sfcnOffset, 0,
                    sizeof(time_T)*1);
      ssSetSampleTimePtr(rts, &sfcnPeriod[0]);
      ssSetOffsetTimePtr(rts, &sfcnOffset[0]);
      ssSetSampleTimeTaskIDPtr(rts, sfcnTsMap);

      /* Set up the mdlInfo pointer */
      {
        ssSetBlkInfo2Ptr(rts, &t15_2_M->NonInlinedSFcns.blkInfo2[10]);
      }

      ssSetRTWSfcnInfo(rts, t15_2_M->sfcnInfo);

      /* Allocate memory of model methods 2 */
      {
        ssSetModelMethods2(rts, &t15_2_M->NonInlinedSFcns.methods2[10]);
      }

      /* Allocate memory of model methods 3 */
      {
        ssSetModelMethods3(rts, &t15_2_M->NonInlinedSFcns.methods3[10]);
      }

      /* Allocate memory for states auxilliary information */
      {
        ssSetStatesInfo2(rts, &t15_2_M->NonInlinedSFcns.statesInfo2[10]);
      }

      /* outputs */
      {
        ssSetPortInfoForOutputs(rts,
          &t15_2_M->NonInlinedSFcns.Sfcn10.outputPortInfo[0]);
        _ssSetNumOutputPorts(rts, 1);

        /* port 0 */
        {
          int_T *dimensions = (int_T *) &t15_2_M->NonInlinedSFcns.Sfcn10.oDims0;
          dimensions[0] = 2;
          dimensions[1] = 50;
          _ssSetOutputPortDimensionsPtr(rts, 0, dimensions);
          _ssSetOutputPortNumDimensions(rts, 0, 2);
          ssSetOutputPortWidth(rts, 0, 100);
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.SFunction1_h5));
        }
      }

      /* path info */
      ssSetModelName(rts, "S-Function1");
      ssSetPath(rts,
                "t15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/g1-g6.dat,g1_term-g6_term.dat/Subsystem3/S-Function1");
      ssSetRTModel(rts,t15_2_M);
      ssSetParentSS(rts, (NULL));
      ssSetRootSS(rts, rts);
      ssSetVersion(rts, SIMSTRUCT_VERSION_LEVEL2);

      /* parameters */
      {
        mxArray **sfcnParams = (mxArray **)
          &t15_2_M->NonInlinedSFcns.Sfcn10.params;
        ssSetSFcnParamsCount(rts, 1);
        ssSetSFcnParamsPtr(rts, &sfcnParams[0]);
        ssSetSFcnParam(rts, 0, (mxArray*)t15_2_P.SFunction1_P1_Size_cc);
      }

      /* registration */
      read_gaps(rts);
      sfcnInitializeSizes(rts);
      sfcnInitializeSampleTimes(rts);

      /* adjust sample time */
      ssSetSampleTime(rts, 0, 0.002);
      ssSetOffsetTime(rts, 0, 0.0);
      sfcnTsMap[0] = 0;

      /* set compiled values of dynamic vector attributes */
      ssSetNumNonsampledZCs(rts, 0);

      /* Update connectivity flags for each port */
      _ssSetOutputPortConnected(rts, 0, 1);
      _ssSetOutputPortBeingMerged(rts, 0, 0);

      /* Update the BufferDstPort flags for each input port */
    }

    /* Level2 S-Function Block: t15_2/<S48>/S-Function1 (read_gaps_term) */
    {
      SimStruct *rts = t15_2_M->childSfunctions[11];

      /* timing info */
      time_T *sfcnPeriod = t15_2_M->NonInlinedSFcns.Sfcn11.sfcnPeriod;
      time_T *sfcnOffset = t15_2_M->NonInlinedSFcns.Sfcn11.sfcnOffset;
      int_T *sfcnTsMap = t15_2_M->NonInlinedSFcns.Sfcn11.sfcnTsMap;
      (void) memset((void*)sfcnPeriod, 0,
                    sizeof(time_T)*1);
      (void) memset((void*)sfcnOffset, 0,
                    sizeof(time_T)*1);
      ssSetSampleTimePtr(rts, &sfcnPeriod[0]);
      ssSetOffsetTimePtr(rts, &sfcnOffset[0]);
      ssSetSampleTimeTaskIDPtr(rts, sfcnTsMap);

      /* Set up the mdlInfo pointer */
      {
        ssSetBlkInfo2Ptr(rts, &t15_2_M->NonInlinedSFcns.blkInfo2[11]);
      }

      ssSetRTWSfcnInfo(rts, t15_2_M->sfcnInfo);

      /* Allocate memory of model methods 2 */
      {
        ssSetModelMethods2(rts, &t15_2_M->NonInlinedSFcns.methods2[11]);
      }

      /* Allocate memory of model methods 3 */
      {
        ssSetModelMethods3(rts, &t15_2_M->NonInlinedSFcns.methods3[11]);
      }

      /* Allocate memory for states auxilliary information */
      {
        ssSetStatesInfo2(rts, &t15_2_M->NonInlinedSFcns.statesInfo2[11]);
      }

      /* outputs */
      {
        ssSetPortInfoForOutputs(rts,
          &t15_2_M->NonInlinedSFcns.Sfcn11.outputPortInfo[0]);
        _ssSetNumOutputPorts(rts, 1);

        /* port 0 */
        {
          int_T *dimensions = (int_T *) &t15_2_M->NonInlinedSFcns.Sfcn11.oDims0;
          dimensions[0] = 2;
          dimensions[1] = 50;
          _ssSetOutputPortDimensionsPtr(rts, 0, dimensions);
          _ssSetOutputPortNumDimensions(rts, 0, 2);
          ssSetOutputPortWidth(rts, 0, 100);
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.SFunction1_o));
        }
      }

      /* path info */
      ssSetModelName(rts, "S-Function1");
      ssSetPath(rts,
                "t15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/g1-g6.dat,g1_term-g6_term.dat/Subsystem3/g4_term,ref/S-Function1");
      ssSetRTModel(rts,t15_2_M);
      ssSetParentSS(rts, (NULL));
      ssSetRootSS(rts, rts);
      ssSetVersion(rts, SIMSTRUCT_VERSION_LEVEL2);

      /* parameters */
      {
        mxArray **sfcnParams = (mxArray **)
          &t15_2_M->NonInlinedSFcns.Sfcn11.params;
        ssSetSFcnParamsCount(rts, 1);
        ssSetSFcnParamsPtr(rts, &sfcnParams[0]);
        ssSetSFcnParam(rts, 0, (mxArray*)t15_2_P.SFunction1_P1_Size_h);
      }

      /* registration */
      read_gaps_term(rts);
      sfcnInitializeSizes(rts);
      sfcnInitializeSampleTimes(rts);

      /* adjust sample time */
      ssSetSampleTime(rts, 0, 0.002);
      ssSetOffsetTime(rts, 0, 0.0);
      sfcnTsMap[0] = 0;

      /* set compiled values of dynamic vector attributes */
      ssSetNumNonsampledZCs(rts, 0);

      /* Update connectivity flags for each port */
      _ssSetOutputPortConnected(rts, 0, 1);
      _ssSetOutputPortBeingMerged(rts, 0, 0);

      /* Update the BufferDstPort flags for each input port */
    }

    /* Level2 S-Function Block: t15_2/<S45>/S-Function1 (read_gaps) */
    {
      SimStruct *rts = t15_2_M->childSfunctions[12];

      /* timing info */
      time_T *sfcnPeriod = t15_2_M->NonInlinedSFcns.Sfcn12.sfcnPeriod;
      time_T *sfcnOffset = t15_2_M->NonInlinedSFcns.Sfcn12.sfcnOffset;
      int_T *sfcnTsMap = t15_2_M->NonInlinedSFcns.Sfcn12.sfcnTsMap;
      (void) memset((void*)sfcnPeriod, 0,
                    sizeof(time_T)*1);
      (void) memset((void*)sfcnOffset, 0,
                    sizeof(time_T)*1);
      ssSetSampleTimePtr(rts, &sfcnPeriod[0]);
      ssSetOffsetTimePtr(rts, &sfcnOffset[0]);
      ssSetSampleTimeTaskIDPtr(rts, sfcnTsMap);

      /* Set up the mdlInfo pointer */
      {
        ssSetBlkInfo2Ptr(rts, &t15_2_M->NonInlinedSFcns.blkInfo2[12]);
      }

      ssSetRTWSfcnInfo(rts, t15_2_M->sfcnInfo);

      /* Allocate memory of model methods 2 */
      {
        ssSetModelMethods2(rts, &t15_2_M->NonInlinedSFcns.methods2[12]);
      }

      /* Allocate memory of model methods 3 */
      {
        ssSetModelMethods3(rts, &t15_2_M->NonInlinedSFcns.methods3[12]);
      }

      /* Allocate memory for states auxilliary information */
      {
        ssSetStatesInfo2(rts, &t15_2_M->NonInlinedSFcns.statesInfo2[12]);
      }

      /* outputs */
      {
        ssSetPortInfoForOutputs(rts,
          &t15_2_M->NonInlinedSFcns.Sfcn12.outputPortInfo[0]);
        _ssSetNumOutputPorts(rts, 1);

        /* port 0 */
        {
          int_T *dimensions = (int_T *) &t15_2_M->NonInlinedSFcns.Sfcn12.oDims0;
          dimensions[0] = 2;
          dimensions[1] = 50;
          _ssSetOutputPortDimensionsPtr(rts, 0, dimensions);
          _ssSetOutputPortNumDimensions(rts, 0, 2);
          ssSetOutputPortWidth(rts, 0, 100);
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.SFunction1_d));
        }
      }

      /* path info */
      ssSetModelName(rts, "S-Function1");
      ssSetPath(rts,
                "t15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/g1-g6.dat,g1_term-g6_term.dat/Zcontr/S-Function1");
      ssSetRTModel(rts,t15_2_M);
      ssSetParentSS(rts, (NULL));
      ssSetRootSS(rts, rts);
      ssSetVersion(rts, SIMSTRUCT_VERSION_LEVEL2);

      /* parameters */
      {
        mxArray **sfcnParams = (mxArray **)
          &t15_2_M->NonInlinedSFcns.Sfcn12.params;
        ssSetSFcnParamsCount(rts, 1);
        ssSetSFcnParamsPtr(rts, &sfcnParams[0]);
        ssSetSFcnParam(rts, 0, (mxArray*)t15_2_P.SFunction1_P1_Size_dv);
      }

      /* registration */
      read_gaps(rts);
      sfcnInitializeSizes(rts);
      sfcnInitializeSampleTimes(rts);

      /* adjust sample time */
      ssSetSampleTime(rts, 0, 0.002);
      ssSetOffsetTime(rts, 0, 0.0);
      sfcnTsMap[0] = 0;

      /* set compiled values of dynamic vector attributes */
      ssSetNumNonsampledZCs(rts, 0);

      /* Update connectivity flags for each port */
      _ssSetOutputPortConnected(rts, 0, 1);
      _ssSetOutputPortBeingMerged(rts, 0, 0);

      /* Update the BufferDstPort flags for each input port */
    }

    /* Level2 S-Function Block: t15_2/<S51>/S-Function1 (read_gaps_term) */
    {
      SimStruct *rts = t15_2_M->childSfunctions[13];

      /* timing info */
      time_T *sfcnPeriod = t15_2_M->NonInlinedSFcns.Sfcn13.sfcnPeriod;
      time_T *sfcnOffset = t15_2_M->NonInlinedSFcns.Sfcn13.sfcnOffset;
      int_T *sfcnTsMap = t15_2_M->NonInlinedSFcns.Sfcn13.sfcnTsMap;
      (void) memset((void*)sfcnPeriod, 0,
                    sizeof(time_T)*1);
      (void) memset((void*)sfcnOffset, 0,
                    sizeof(time_T)*1);
      ssSetSampleTimePtr(rts, &sfcnPeriod[0]);
      ssSetOffsetTimePtr(rts, &sfcnOffset[0]);
      ssSetSampleTimeTaskIDPtr(rts, sfcnTsMap);

      /* Set up the mdlInfo pointer */
      {
        ssSetBlkInfo2Ptr(rts, &t15_2_M->NonInlinedSFcns.blkInfo2[13]);
      }

      ssSetRTWSfcnInfo(rts, t15_2_M->sfcnInfo);

      /* Allocate memory of model methods 2 */
      {
        ssSetModelMethods2(rts, &t15_2_M->NonInlinedSFcns.methods2[13]);
      }

      /* Allocate memory of model methods 3 */
      {
        ssSetModelMethods3(rts, &t15_2_M->NonInlinedSFcns.methods3[13]);
      }

      /* Allocate memory for states auxilliary information */
      {
        ssSetStatesInfo2(rts, &t15_2_M->NonInlinedSFcns.statesInfo2[13]);
      }

      /* outputs */
      {
        ssSetPortInfoForOutputs(rts,
          &t15_2_M->NonInlinedSFcns.Sfcn13.outputPortInfo[0]);
        _ssSetNumOutputPorts(rts, 1);

        /* port 0 */
        {
          int_T *dimensions = (int_T *) &t15_2_M->NonInlinedSFcns.Sfcn13.oDims0;
          dimensions[0] = 2;
          dimensions[1] = 50;
          _ssSetOutputPortDimensionsPtr(rts, 0, dimensions);
          _ssSetOutputPortNumDimensions(rts, 0, 2);
          ssSetOutputPortWidth(rts, 0, 100);
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.SFunction1_ha));
        }
      }

      /* path info */
      ssSetModelName(rts, "S-Function1");
      ssSetPath(rts,
                "t15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/g1-g6.dat,g1_term-g6_term.dat/Zcontr/g5_term,ref/S-Function1");
      ssSetRTModel(rts,t15_2_M);
      ssSetParentSS(rts, (NULL));
      ssSetRootSS(rts, rts);
      ssSetVersion(rts, SIMSTRUCT_VERSION_LEVEL2);

      /* parameters */
      {
        mxArray **sfcnParams = (mxArray **)
          &t15_2_M->NonInlinedSFcns.Sfcn13.params;
        ssSetSFcnParamsCount(rts, 1);
        ssSetSFcnParamsPtr(rts, &sfcnParams[0]);
        ssSetSFcnParam(rts, 0, (mxArray*)t15_2_P.SFunction1_P1_Size_l);
      }

      /* registration */
      read_gaps_term(rts);
      sfcnInitializeSizes(rts);
      sfcnInitializeSampleTimes(rts);

      /* adjust sample time */
      ssSetSampleTime(rts, 0, 0.002);
      ssSetOffsetTime(rts, 0, 0.0);
      sfcnTsMap[0] = 0;

      /* set compiled values of dynamic vector attributes */
      ssSetNumNonsampledZCs(rts, 0);

      /* Update connectivity flags for each port */
      _ssSetOutputPortConnected(rts, 0, 1);
      _ssSetOutputPortBeingMerged(rts, 0, 0);

      /* Update the BufferDstPort flags for each input port */
    }

    /* Level2 S-Function Block: t15_2/<S43>/S-Function1 (read_gaps) */
    {
      SimStruct *rts = t15_2_M->childSfunctions[14];

      /* timing info */
      time_T *sfcnPeriod = t15_2_M->NonInlinedSFcns.Sfcn14.sfcnPeriod;
      time_T *sfcnOffset = t15_2_M->NonInlinedSFcns.Sfcn14.sfcnOffset;
      int_T *sfcnTsMap = t15_2_M->NonInlinedSFcns.Sfcn14.sfcnTsMap;
      (void) memset((void*)sfcnPeriod, 0,
                    sizeof(time_T)*1);
      (void) memset((void*)sfcnOffset, 0,
                    sizeof(time_T)*1);
      ssSetSampleTimePtr(rts, &sfcnPeriod[0]);
      ssSetOffsetTimePtr(rts, &sfcnOffset[0]);
      ssSetSampleTimeTaskIDPtr(rts, sfcnTsMap);

      /* Set up the mdlInfo pointer */
      {
        ssSetBlkInfo2Ptr(rts, &t15_2_M->NonInlinedSFcns.blkInfo2[14]);
      }

      ssSetRTWSfcnInfo(rts, t15_2_M->sfcnInfo);

      /* Allocate memory of model methods 2 */
      {
        ssSetModelMethods2(rts, &t15_2_M->NonInlinedSFcns.methods2[14]);
      }

      /* Allocate memory of model methods 3 */
      {
        ssSetModelMethods3(rts, &t15_2_M->NonInlinedSFcns.methods3[14]);
      }

      /* Allocate memory for states auxilliary information */
      {
        ssSetStatesInfo2(rts, &t15_2_M->NonInlinedSFcns.statesInfo2[14]);
      }

      /* outputs */
      {
        ssSetPortInfoForOutputs(rts,
          &t15_2_M->NonInlinedSFcns.Sfcn14.outputPortInfo[0]);
        _ssSetNumOutputPorts(rts, 1);

        /* port 0 */
        {
          int_T *dimensions = (int_T *) &t15_2_M->NonInlinedSFcns.Sfcn14.oDims0;
          dimensions[0] = 2;
          dimensions[1] = 50;
          _ssSetOutputPortDimensionsPtr(rts, 0, dimensions);
          _ssSetOutputPortNumDimensions(rts, 0, 2);
          ssSetOutputPortWidth(rts, 0, 100);
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.SFunction1_m));
        }
      }

      /* path info */
      ssSetModelName(rts, "S-Function1");
      ssSetPath(rts,
                "t15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/g1-g6.dat,g1_term-g6_term.dat/Subsystem5/S-Function1");
      ssSetRTModel(rts,t15_2_M);
      ssSetParentSS(rts, (NULL));
      ssSetRootSS(rts, rts);
      ssSetVersion(rts, SIMSTRUCT_VERSION_LEVEL2);

      /* parameters */
      {
        mxArray **sfcnParams = (mxArray **)
          &t15_2_M->NonInlinedSFcns.Sfcn14.params;
        ssSetSFcnParamsCount(rts, 1);
        ssSetSFcnParamsPtr(rts, &sfcnParams[0]);
        ssSetSFcnParam(rts, 0, (mxArray*)t15_2_P.SFunction1_P1_Size_ml);
      }

      /* registration */
      read_gaps(rts);
      sfcnInitializeSizes(rts);
      sfcnInitializeSampleTimes(rts);

      /* adjust sample time */
      ssSetSampleTime(rts, 0, 0.002);
      ssSetOffsetTime(rts, 0, 0.0);
      sfcnTsMap[0] = 0;

      /* set compiled values of dynamic vector attributes */
      ssSetNumNonsampledZCs(rts, 0);

      /* Update connectivity flags for each port */
      _ssSetOutputPortConnected(rts, 0, 1);
      _ssSetOutputPortBeingMerged(rts, 0, 0);

      /* Update the BufferDstPort flags for each input port */
    }

    /* Level2 S-Function Block: t15_2/<S49>/S-Function1 (read_gaps_term) */
    {
      SimStruct *rts = t15_2_M->childSfunctions[15];

      /* timing info */
      time_T *sfcnPeriod = t15_2_M->NonInlinedSFcns.Sfcn15.sfcnPeriod;
      time_T *sfcnOffset = t15_2_M->NonInlinedSFcns.Sfcn15.sfcnOffset;
      int_T *sfcnTsMap = t15_2_M->NonInlinedSFcns.Sfcn15.sfcnTsMap;
      (void) memset((void*)sfcnPeriod, 0,
                    sizeof(time_T)*1);
      (void) memset((void*)sfcnOffset, 0,
                    sizeof(time_T)*1);
      ssSetSampleTimePtr(rts, &sfcnPeriod[0]);
      ssSetOffsetTimePtr(rts, &sfcnOffset[0]);
      ssSetSampleTimeTaskIDPtr(rts, sfcnTsMap);

      /* Set up the mdlInfo pointer */
      {
        ssSetBlkInfo2Ptr(rts, &t15_2_M->NonInlinedSFcns.blkInfo2[15]);
      }

      ssSetRTWSfcnInfo(rts, t15_2_M->sfcnInfo);

      /* Allocate memory of model methods 2 */
      {
        ssSetModelMethods2(rts, &t15_2_M->NonInlinedSFcns.methods2[15]);
      }

      /* Allocate memory of model methods 3 */
      {
        ssSetModelMethods3(rts, &t15_2_M->NonInlinedSFcns.methods3[15]);
      }

      /* Allocate memory for states auxilliary information */
      {
        ssSetStatesInfo2(rts, &t15_2_M->NonInlinedSFcns.statesInfo2[15]);
      }

      /* outputs */
      {
        ssSetPortInfoForOutputs(rts,
          &t15_2_M->NonInlinedSFcns.Sfcn15.outputPortInfo[0]);
        _ssSetNumOutputPorts(rts, 1);

        /* port 0 */
        {
          int_T *dimensions = (int_T *) &t15_2_M->NonInlinedSFcns.Sfcn15.oDims0;
          dimensions[0] = 2;
          dimensions[1] = 50;
          _ssSetOutputPortDimensionsPtr(rts, 0, dimensions);
          _ssSetOutputPortNumDimensions(rts, 0, 2);
          ssSetOutputPortWidth(rts, 0, 100);
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.SFunction1_ke));
        }
      }

      /* path info */
      ssSetModelName(rts, "S-Function1");
      ssSetPath(rts,
                "t15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/g1-g6.dat,g1_term-g6_term.dat/Subsystem5/g6_term,ref/S-Function1");
      ssSetRTModel(rts,t15_2_M);
      ssSetParentSS(rts, (NULL));
      ssSetRootSS(rts, rts);
      ssSetVersion(rts, SIMSTRUCT_VERSION_LEVEL2);

      /* parameters */
      {
        mxArray **sfcnParams = (mxArray **)
          &t15_2_M->NonInlinedSFcns.Sfcn15.params;
        ssSetSFcnParamsCount(rts, 1);
        ssSetSFcnParamsPtr(rts, &sfcnParams[0]);
        ssSetSFcnParam(rts, 0, (mxArray*)t15_2_P.SFunction1_P1_Size_g);
      }

      /* registration */
      read_gaps_term(rts);
      sfcnInitializeSizes(rts);
      sfcnInitializeSampleTimes(rts);

      /* adjust sample time */
      ssSetSampleTime(rts, 0, 0.002);
      ssSetOffsetTime(rts, 0, 0.0);
      sfcnTsMap[0] = 0;

      /* set compiled values of dynamic vector attributes */
      ssSetNumNonsampledZCs(rts, 0);

      /* Update connectivity flags for each port */
      _ssSetOutputPortConnected(rts, 0, 1);
      _ssSetOutputPortBeingMerged(rts, 0, 0);

      /* Update the BufferDstPort flags for each input port */
    }

    /* Level2 S-Function Block: t15_2/<S1>/S-Function (read_tt_kavin2) */
    {
      SimStruct *rts = t15_2_M->childSfunctions[16];

      /* timing info */
      time_T *sfcnPeriod = t15_2_M->NonInlinedSFcns.Sfcn16.sfcnPeriod;
      time_T *sfcnOffset = t15_2_M->NonInlinedSFcns.Sfcn16.sfcnOffset;
      int_T *sfcnTsMap = t15_2_M->NonInlinedSFcns.Sfcn16.sfcnTsMap;
      (void) memset((void*)sfcnPeriod, 0,
                    sizeof(time_T)*1);
      (void) memset((void*)sfcnOffset, 0,
                    sizeof(time_T)*1);
      ssSetSampleTimePtr(rts, &sfcnPeriod[0]);
      ssSetOffsetTimePtr(rts, &sfcnOffset[0]);
      ssSetSampleTimeTaskIDPtr(rts, sfcnTsMap);

      /* Set up the mdlInfo pointer */
      {
        ssSetBlkInfo2Ptr(rts, &t15_2_M->NonInlinedSFcns.blkInfo2[16]);
      }

      ssSetRTWSfcnInfo(rts, t15_2_M->sfcnInfo);

      /* Allocate memory of model methods 2 */
      {
        ssSetModelMethods2(rts, &t15_2_M->NonInlinedSFcns.methods2[16]);
      }

      /* Allocate memory of model methods 3 */
      {
        ssSetModelMethods3(rts, &t15_2_M->NonInlinedSFcns.methods3[16]);
      }

      /* Allocate memory for states auxilliary information */
      {
        ssSetStatesInfo2(rts, &t15_2_M->NonInlinedSFcns.statesInfo2[16]);
      }

      /* outputs */
      {
        ssSetPortInfoForOutputs(rts,
          &t15_2_M->NonInlinedSFcns.Sfcn16.outputPortInfo[0]);
        _ssSetNumOutputPorts(rts, 1);

        /* port 0 */
        {
          _ssSetOutputPortNumDimensions(rts, 0, 1);
          ssSetOutputPortWidth(rts, 0, 44);
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.SFunction_k));
        }
      }

      /* path info */
      ssSetModelName(rts, "S-Function");
      ssSetPath(rts, "t15_2/Pow. Supply MC 2/S-Function");
      ssSetRTModel(rts,t15_2_M);
      ssSetParentSS(rts, (NULL));
      ssSetRootSS(rts, rts);
      ssSetVersion(rts, SIMSTRUCT_VERSION_LEVEL2);

      /* registration */
      read_tt_kavin2(rts);
      sfcnInitializeSizes(rts);
      sfcnInitializeSampleTimes(rts);

      /* adjust sample time */
      ssSetSampleTime(rts, 0, 0.002);
      ssSetOffsetTime(rts, 0, 0.0);
      sfcnTsMap[0] = 0;

      /* set compiled values of dynamic vector attributes */
      ssSetNumNonsampledZCs(rts, 0);

      /* Update connectivity flags for each port */
      _ssSetOutputPortConnected(rts, 0, 1);
      _ssSetOutputPortBeingMerged(rts, 0, 0);

      /* Update the BufferDstPort flags for each input port */
    }
  }

  {
    uint32_T tseed;
    int32_T r;
    int32_T t;
    real_T tmin;

    /* Start for UniformRandomNumber: '<S63>/Uniform Random Number' */
    tmin = floor(t15_2_P.UniformRandomNumber_Seed);
    if (rtIsNaN(tmin) || rtIsInf(tmin)) {
      tmin = 0.0;
    } else {
      tmin = fmod(tmin, 4.294967296E+9);
    }

    tseed = tmin < 0.0 ? (uint32_T)-(int32_T)(uint32_T)-tmin : (uint32_T)tmin;
    r = (int32_T)(tseed >> 16U);
    t = (int32_T)(tseed & 32768U);
    tseed = ((((tseed - ((uint32_T)r << 16U)) + t) << 16U) + t) + r;
    if (tseed < 1U) {
      tseed = 1144108930U;
    } else {
      if (tseed > 2147483646U) {
        tseed = 2147483646U;
      }
    }

    t15_2_DWork.RandSeed = tseed;
    tmin = t15_2_P.UniformRandomNumber_Minimum;
    t15_2_DWork.UniformRandomNumber_NextOutput =
      (t15_2_P.UniformRandomNumber_Maximum - tmin) * rt_urand_Upu32_Yd_f_pw_snf(
      &t15_2_DWork.RandSeed) + tmin;

    /* End of Start for UniformRandomNumber: '<S63>/Uniform Random Number' */

    /* Start for DataStoreMemory: '<S5>/Data Store Memory' */
    memcpy(&t15_2_DWork.scr_data[0], &t15_2_P.DataStoreMemory_InitialValue[0],
           6500U * sizeof(real_T));

    /* Start for DataStoreMemory: '<S5>/Data Store Memory1' */
    memcpy(&t15_2_DWork.volt[0], &t15_2_P.DataStoreMemory1_InitialValue[0],
           10000U * sizeof(real_T));

    /* Start for DataStoreMemory: '<S5>/Data Store Memory10' */
    t15_2_DWork.c_a_tpl1_eob = t15_2_P.DataStoreMemory10_InitialValue;

    /* Start for DataStoreMemory: '<S5>/Data Store Memory11' */
    t15_2_DWork.c_a_tpl2 = t15_2_P.DataStoreMemory11_InitialValue;

    /* Start for DataStoreMemory: '<S5>/Data Store Memory12' */
    t15_2_DWork.c_a_tpl_min = t15_2_P.DataStoreMemory12_InitialValue;

    /* Start for DataStoreMemory: '<S5>/Data Store Memory13' */
    t15_2_DWork.y0 = t15_2_P.DataStoreMemory13_InitialValue;

    /* Start for DataStoreMemory: '<S5>/Data Store Memory14' */
    t15_2_DWork.c1_y0 = t15_2_P.DataStoreMemory14_InitialValue;

    /* Start for DataStoreMemory: '<S5>/Data Store Memory15' */
    t15_2_DWork.c2_y0 = t15_2_P.DataStoreMemory15_InitialValue;

    /* Start for DataStoreMemory: '<S5>/Data Store Memory16' */
    t15_2_DWork.t_tran2D = t15_2_P.DataStoreMemory16_InitialValue;

    /* Start for DataStoreMemory: '<S5>/Data Store Memory17' */
    t15_2_DWork.max_VS_lim = t15_2_P.DataStoreMemory17_InitialValue;

    /* Start for DataStoreMemory: '<S5>/Data Store Memory18' */
    t15_2_DWork.k_g4 = t15_2_P.DataStoreMemory18_InitialValue;

    /* Start for DataStoreMemory: '<S5>/Data Store Memory2' */
    t15_2_DWork.c_a_tpl1 = t15_2_P.DataStoreMemory2_InitialValue;

    /* Start for DataStoreMemory: '<S5>/Data Store Memory3' */
    t15_2_DWork.tcont2 = t15_2_P.DataStoreMemory3_InitialValue;

    /* Start for DataStoreMemory: '<S5>/Data Store Memory4' */
    t15_2_DWork.Ip_div = t15_2_P.DataStoreMemory4_InitialValue;

    /* Start for DataStoreMemory: '<S5>/Data Store Memory5' */
    t15_2_DWork.ref_ramp = t15_2_P.DataStoreMemory5_InitialValue;

    /* Start for DataStoreMemory: '<S5>/Data Store Memory6' */
    t15_2_DWork.dtcont2 = t15_2_P.DataStoreMemory6_InitialValue;

    /* Start for DataStoreMemory: '<S5>/Data Store Memory7' */
    t15_2_DWork.Ip_rd = t15_2_P.DataStoreMemory7_InitialValue;

    /* Start for DataStoreMemory: '<S5>/Data Store Memory8' */
    t15_2_DWork.trd_ref = t15_2_P.DataStoreMemory8_InitialValue;

    /* Start for DataStoreMemory: '<S5>/Data Store Memory9' */
    t15_2_DWork.Time_stop = t15_2_P.DataStoreMemory9_InitialValue;

    /* Start for DataStoreMemory: '<S1>/Data Store Memory1' */
    memcpy(&t15_2_DWork.ntur[0], &t15_2_P.DataStoreMemory1_InitialValue_i[0],
           12U * sizeof(real_T));

    /* Start for DataStoreMemory: '<S1>/Data Store Memory2' */
    for (r = 0; r < 6; r++) {
      t15_2_DWork.RupRd[r] = t15_2_P.DataStoreMemory2_InitialValue_h[r];
    }

    /* End of Start for DataStoreMemory: '<S1>/Data Store Memory2' */

    /* Start for DataStoreMemory: '<S1>/Data Store Memory3' */
    t15_2_DWork.VS3_up = t15_2_P.DataStoreMemory3_InitialValue_b;

    /* Start for DataStoreMemory: '<S1>/Data Store Memory5' */
    t15_2_DWork.VS1_up = t15_2_P.DataStoreMemory5_InitialValue_e;

    /* Start for DataStoreMemory: '<S1>/Data Store Memory7' */
    t15_2_DWork.Tu = t15_2_P.DataStoreMemory7_InitialValue_p;

    /* Start for DataStoreMemory: '<S1>/Data Store Memory8' */
    t15_2_DWork.c_cur_max = t15_2_P.DataStoreMemory8_InitialValue_k;
    for (r = 0; r < 11; r++) {
      /* Start for DataStoreMemory: '<S1>/Data Store Memory4' */
      t15_2_DWork.Vcspf_up[r] = t15_2_P.DataStoreMemory4_InitialValue_e[r];

      /* Start for DataStoreMemory: '<S1>/Data Store Memory9' */
      t15_2_DWork.Imax[r] = t15_2_P.DataStoreMemory9_InitialValue_f[r];
    }
  }

  {
    int32_T i;

    /* InitializeConditions for Memory: '<S5>/Memory2' */
    t15_2_DWork.Memory2_PreviousInput = t15_2_P.Memory2_X0;

    /* InitializeConditions for Memory: '<S18>/Memory1' */
    t15_2_DWork.Memory1_PreviousInput = t15_2_P.Memory1_X0;

    /* InitializeConditions for Memory: '<S26>/Memory' */
    t15_2_DWork.Memory_PreviousInput = t15_2_P.Memory_X0;

    /* InitializeConditions for Memory: '<S19>/Memory1' */
    t15_2_DWork.Memory1_PreviousInput_e = t15_2_P.Memory1_X0_j;

    /* InitializeConditions for Memory: '<S44>/Memory2' */
    t15_2_DWork.Memory2_PreviousInput_o = t15_2_P.Memory2_X0_k;

    /* InitializeConditions for Memory: '<S44>/Memory1' */
    t15_2_DWork.Memory1_PreviousInput_l = t15_2_P.Memory1_X0_k;

    /* InitializeConditions for Memory: '<S40>/Memory2' */
    t15_2_DWork.Memory2_PreviousInput_b = t15_2_P.Memory2_X0_f;

    /* InitializeConditions for Memory: '<S40>/Memory1' */
    t15_2_DWork.Memory1_PreviousInput_n = t15_2_P.Memory1_X0_js;

    /* InitializeConditions for Memory: '<S41>/Memory2' */
    t15_2_DWork.Memory2_PreviousInput_e = t15_2_P.Memory2_X0_l;

    /* InitializeConditions for Memory: '<S41>/Memory1' */
    t15_2_DWork.Memory1_PreviousInput_e4 = t15_2_P.Memory1_X0_f;

    /* InitializeConditions for Memory: '<S42>/Memory2' */
    t15_2_DWork.Memory2_PreviousInput_od = t15_2_P.Memory2_X0_fb;

    /* InitializeConditions for Memory: '<S42>/Memory1' */
    t15_2_DWork.Memory1_PreviousInput_p = t15_2_P.Memory1_X0_o;

    /* InitializeConditions for Memory: '<S45>/Memory2' */
    t15_2_DWork.Memory2_PreviousInput_p = t15_2_P.Memory2_X0_c;

    /* InitializeConditions for Memory: '<S45>/Memory1' */
    t15_2_DWork.Memory1_PreviousInput_j = t15_2_P.Memory1_X0_i;

    /* InitializeConditions for Memory: '<S43>/Memory2' */
    t15_2_DWork.Memory2_PreviousInput_n = t15_2_P.Memory2_X0_kx;

    /* InitializeConditions for Memory: '<S43>/Memory1' */
    t15_2_DWork.Memory1_PreviousInput_a = t15_2_P.Memory1_X0_g;

    /* InitializeConditions for Memory: '<S29>/Memory2' */
    t15_2_DWork.Memory2_PreviousInput_e2 = t15_2_P.Memory2_X0_o;

    /* InitializeConditions for Memory: '<S32>/Memory2' */
    t15_2_DWork.Memory2_PreviousInput_nv = t15_2_P.Memory2_X0_f5;

    /* InitializeConditions for Memory: '<S33>/Memory2' */
    t15_2_DWork.Memory2_PreviousInput_h = t15_2_P.Memory2_X0_m;

    /* InitializeConditions for Memory: '<S34>/Memory2' */
    t15_2_DWork.Memory2_PreviousInput_l = t15_2_P.Memory2_X0_g;

    /* InitializeConditions for Memory: '<S35>/Memory2' */
    t15_2_DWork.Memory2_PreviousInput_pa = t15_2_P.Memory2_X0_l5;

    /* InitializeConditions for Memory: '<S36>/Memory2' */
    t15_2_DWork.Memory2_PreviousInput_j = t15_2_P.Memory2_X0_b;

    /* InitializeConditions for Memory: '<S37>/Memory2' */
    t15_2_DWork.Memory2_PreviousInput_bt = t15_2_P.Memory2_X0_cc;

    /* InitializeConditions for Memory: '<S38>/Memory2' */
    t15_2_DWork.Memory2_PreviousInput_i = t15_2_P.Memory2_X0_gp;

    /* InitializeConditions for Memory: '<S39>/Memory2' */
    t15_2_DWork.Memory2_PreviousInput_iw = t15_2_P.Memory2_X0_j;

    /* InitializeConditions for Memory: '<S30>/Memory2' */
    t15_2_DWork.Memory2_PreviousInput_oh = t15_2_P.Memory2_X0_d;

    /* InitializeConditions for Memory: '<S31>/Memory2' */
    t15_2_DWork.Memory2_PreviousInput_nt = t15_2_P.Memory2_X0_gn;

    /* InitializeConditions for Memory: '<S25>/Memory' */
    t15_2_DWork.Memory_PreviousInput_h = t15_2_P.Memory_X0_g;

    /* InitializeConditions for UnitDelay: '<S27>/UD' */
    t15_2_DWork.UD_DSTATE = t15_2_P.UD_InitialCondition;

    /* InitializeConditions for UnitDelay: '<S28>/UD' */
    t15_2_DWork.UD_DSTATE_p = t15_2_P.UD_InitialCondition_f;

    /* InitializeConditions for Memory: '<S52>/Memory3' */
    t15_2_DWork.Memory3_PreviousInput = t15_2_P.Memory3_X0;

    /* InitializeConditions for Memory: '<S64>/Memory1' */
    t15_2_DWork.Memory1_PreviousInput_a0 = t15_2_P.Memory1_X0_e;

    /* InitializeConditions for DiscreteStateSpace: '<S55>/Lim. contr.' */
    {
      int_T i1;
      real_T *dw_DSTATE = &t15_2_DWork.Limcontr_DSTATE[0];
      for (i1=0; i1 < 50; i1++) {
        dw_DSTATE[i1] = t15_2_P.Limcontr_X0;
      }
    }

    /* InitializeConditions for DiscreteStateSpace: '<S55>/Curr. contr.' */
    {
      int_T i1;
      real_T *dw_DSTATE = &t15_2_DWork.Currcontr_DSTATE[0];
      for (i1=0; i1 < 11; i1++) {
        dw_DSTATE[i1] = t15_2_P.Currcontr_X0;
      }
    }

    /* InitializeConditions for DiscreteStateSpace: '<S15>/Div. contr.' */
    {
      int_T i1;
      real_T *dw_DSTATE = &t15_2_DWork.Divcontr_DSTATE[0];
      for (i1=0; i1 < 32; i1++) {
        dw_DSTATE[i1] = t15_2_P.Divcontr_X0;
      }
    }

    /* InitializeConditions for Memory: '<S62>/Memory1' */
    t15_2_DWork.Memory1_PreviousInput_an = t15_2_P.Memory1_X0_p;

    /* InitializeConditions for DiscreteStateSpace: '<S15>/Div_rd contr' */
    {
      int_T i1;
      real_T *dw_DSTATE = &t15_2_DWork.Div_rdcontr_DSTATE[0];
      for (i1=0; i1 < 22; i1++) {
        dw_DSTATE[i1] = t15_2_P.Div_rdcontr_X0;
      }
    }

    /* InitializeConditions for DiscreteStateSpace: '<S15>/Curr. term. contr' */
    {
      int_T i1;
      real_T *dw_DSTATE = &t15_2_DWork.Currtermcontr_DSTATE[0];
      for (i1=0; i1 < 22; i1++) {
        dw_DSTATE[i1] = t15_2_P.Currtermcontr_X0;
      }
    }

    /* InitializeConditions for UnitDelay: '<S83>/UD' */
    t15_2_DWork.UD_DSTATE_h = t15_2_P.UD_InitialCondition_a;

    /* InitializeConditions for DiscreteStateSpace: '<S60>/VS. contr' */
    {
      int_T i1;
      real_T *dw_DSTATE = &t15_2_DWork.VScontr_DSTATE[0];
      for (i1=0; i1 < 9; i1++) {
        dw_DSTATE[i1] = t15_2_P.VScontr_X0;
      }
    }

    /* InitializeConditions for DiscreteStateSpace: '<S60>/VS. contr hl' */
    {
      int_T i1;
      real_T *dw_DSTATE = &t15_2_DWork.VScontrhl_DSTATE[0];
      for (i1=0; i1 < 8; i1++) {
        dw_DSTATE[i1] = t15_2_P.VScontrhl_X0;
      }
    }

    for (i = 0; i < 11; i++) {
      /* InitializeConditions for Memory: '<S52>/Memory1' */
      t15_2_DWork.Memory1_PreviousInput_k[i] = t15_2_P.Memory1_X0_l;

      /* InitializeConditions for Memory: '<S66>/Memory1' */
      t15_2_DWork.Memory1_PreviousInput_i[i] = t15_2_P.Memory1_X0_gk;

      /* InitializeConditions for Memory: '<S58>/Memory' */
      t15_2_DWork.Memory_PreviousInput_o[i] = t15_2_P.Memory_X0_n;

      /* InitializeConditions for Memory: '<S7>/Memory1' */
      t15_2_DWork.Memory1_PreviousInput_p0[i] = t15_2_P.Memory1_X0_n;
    }

    /* InitializeConditions for UnitDelay: '<S6>/UD' */
    t15_2_DWork.UD_DSTATE_e = t15_2_P.UD_InitialCondition_k;
  }
}

/* Model terminate function */
void t15_2_terminate(void)
{
  /* Level2 S-Function Block: '<S5>/S-Function1' (pf_lookup3) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[0];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<S5>/S-Function2' (read_volt) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[1];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<S5>/S-Function' (read_control_data2) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[2];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<S21>/S-Function1' (read_gaps) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[3];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<S44>/S-Function1' (read_gaps) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[4];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<S50>/S-Function1' (read_gaps_term) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[5];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<S40>/S-Function1' (read_gaps) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[6];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<S46>/S-Function1' (read_gaps_term) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[7];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<S41>/S-Function1' (read_gaps) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[8];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<S47>/S-Function1' (read_gaps_term) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[9];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<S42>/S-Function1' (read_gaps) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[10];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<S48>/S-Function1' (read_gaps_term) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[11];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<S45>/S-Function1' (read_gaps) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[12];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<S51>/S-Function1' (read_gaps_term) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[13];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<S43>/S-Function1' (read_gaps) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[14];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<S49>/S-Function1' (read_gaps_term) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[15];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<S1>/S-Function' (read_tt_kavin2) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[16];
    sfcnTerminate(rts);
  }
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
void t15_2_output(int  nbrInputArgs, double* input,
int *nbrOutputArgs, double* output) 
{
	 int i, k, ki;

	  ki=0;

	  if( kpr == 1){
	  printf("Enter t15_2_output "
         " and ki "
		 " .  %d %d  \n",nbrInputArgs,ki);}

  /* external inputs */
	k=0;
    for (i = 0; i < 15; i++) 
	{ t15_2_U.In1[i] = input[i];
	  k=k+1;
    }
    ki=k;
if( kpr == -1){
	printf("k  ki %d %d  \n",k,ki);}

	
	for (i = 0; i < 123; i++)
	{ t15_2_U.In2[i] = input[i+ki];
	  k=k+1;
    }
    ki=k;

if( kpr ==- 1){
		  printf("k  ki %d %d  \n",k,ki);

	  printf("nbrInputArgs "
         " and ki "
		 " .  %d %d  \n",nbrInputArgs,ki);}
/*
	  printf("test1_step() "
         "getControllerOutput. "
         " .  %.3f\n",input[0]);
*/

	  t15_2_step();


//	  printf("---t15_2_step  \n");



  /* external outputs */
  //real_T Out1[15];
  	  k=0;

      for (i = 0; i < 15; i++) 
	  { output[i]=t15_2_Y.to_DINA[i] ;
	  k=k+1;
      }
	  
	  ki=k;

      for (i = 0; i < 11; i++) 
//	  { output[i+ki]=t15_2_B.Saturation[i] ;
//	  { output[i+ki]=t15_2_DWork.Vcspf_up[i] ;

	  { output[i+ki]=0.0 ;
	  k=k+1;
      }

//t15_2_B.Saturation6[i] + t15_2_B.SaturationVS[i];

	  ki=k;

      for (i = 0; i < 11; i++) 
//	  { output[i+ki]=t15_2_B.wz[i] ;
	  { output[i+ki]=0.0 ;
	  k=k+1;
      }

	  i=11;
//	  output[i+ki]=t15_2_B.wz[i] ;
	  output[i+ki]=0.0 ;

	  ki=k;

	  nbrOutputArgs=&ki;

	  if( kpr == 1){
  
	  printf("---nbrOutputArgs "
         " and ki "
		 " .  %d %d  \n",*nbrOutputArgs,ki);
	

      for (i = 0; i < ki; i++) 
	  { 	  printf("output "
         " and i "
         " .  %g %d  \n",output[i],i);
      }
      
	  
	  }

}
