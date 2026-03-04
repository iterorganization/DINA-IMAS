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
 * Model version                  : 1.1164
 * Simulink Coder version         : 8.5 (R2013b) 08-Aug-2013
 * C/C++ source code generated on : Mon Mar 20 13:30:01 2023
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

  /* Level2 S-Function Block: '<S1>/read_control_data2_fun' (read_control_data2) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[0];
    sfcnOutputs(rts, 0);
  }

  /* DataStoreWrite: '<S2>/Data Store Write19' */
  t15_2_DWork.Ipdiv = t15_2_B.read_control_data2_fun[2];

  /* If: '<S2>/If' */
  if (t15_2_B.read_control_data2_fun[2] >= 0.0) {
    /* Outputs for IfAction SubSystem: '<S2>/If Action' incorporates:
     *  ActionPort: '<S7>/Action Port'
     */
    /* DataStoreWrite: '<S7>/Data Store Write19' */
    t15_2_DWork.tdiv = t15_2_B.read_control_data2_fun[2];

    /* End of Outputs for SubSystem: '<S2>/If Action' */
  }

  /* End of If: '<S2>/If' */

  /* DataStoreWrite: '<S1>/Data Store Write10' */
  t15_2_DWork.c_a_tpl1_eob = t15_2_B.read_control_data2_fun[10];

  /* DataStoreWrite: '<S1>/Data Store Write11' */
  t15_2_DWork.c_a_tpl2 = t15_2_B.read_control_data2_fun[11];

  /* DataStoreWrite: '<S1>/Data Store Write12' */
  t15_2_DWork.c_a_tpl_min = t15_2_B.read_control_data2_fun[12];

  /* DataStoreWrite: '<S1>/Data Store Write13' */
  t15_2_DWork.y0 = t15_2_B.read_control_data2_fun[13];

  /* DataStoreWrite: '<S1>/Data Store Write14' */
  t15_2_DWork.c1_y0 = t15_2_B.read_control_data2_fun[14];

  /* DataStoreWrite: '<S1>/Data Store Write15' */
  t15_2_DWork.c2_y0 = t15_2_B.read_control_data2_fun[15];

  /* DataStoreWrite: '<S1>/Data Store Write16' */
  t15_2_DWork.t_tran2D = t15_2_B.read_control_data2_fun[16];

  /* DataStoreWrite: '<S1>/Data Store Write17' */
  t15_2_DWork.max_VS_lim = t15_2_B.read_control_data2_fun[6];

  /* DataStoreWrite: '<S1>/Data Store Write18' */
  t15_2_DWork.k_g4 = t15_2_B.read_control_data2_fun[7];

  /* DataStoreWrite: '<S1>/Data Store Write19' */
  t15_2_DWork.tcont2 = t15_2_B.read_control_data2_fun[0];

  /* DataStoreWrite: '<S1>/Data Store Write20' */
  t15_2_DWork.ref_ramp = t15_2_B.read_control_data2_fun[3];

  /* DataStoreWrite: '<S1>/Data Store Write21' */
  t15_2_DWork.dtcont2 = t15_2_B.read_control_data2_fun[1];

  /* DataStoreWrite: '<S1>/Data Store Write22' */
  t15_2_DWork.Ip_rd = t15_2_B.read_control_data2_fun[4];

  /* DataStoreWrite: '<S1>/Data Store Write23' */
  t15_2_DWork.trd_ref = t15_2_B.read_control_data2_fun[5];

  /* DataStoreWrite: '<S1>/Data Store Write24' */
  t15_2_DWork.Time_stop = t15_2_B.read_control_data2_fun[8];

  /* DataStoreWrite: '<S1>/Data Store Write6' */
  t15_2_DWork.c_a_tpl1 = t15_2_B.read_control_data2_fun[9];

  /* Level2 S-Function Block: '<S1>/read_tt_kavin2_fun' (read_tt_kavin2) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[1];
    sfcnOutputs(rts, 0);
  }

  /* DataStoreWrite: '<S1>/Imax Write' */
  memcpy(&t15_2_DWork.Imax[0], &t15_2_B.read_tt_kavin2_fun[21], 11U * sizeof
         (real_T));

  /* DataStoreWrite: '<S1>/RupRd Write' */
  for (i = 0; i < 6; i++) {
    t15_2_DWork.RupRd[i] = t15_2_B.read_tt_kavin2_fun[i];
  }

  /* End of DataStoreWrite: '<S1>/RupRd Write' */

  /* DataStoreWrite: '<S1>/Tu Write' */
  t15_2_DWork.Tu = t15_2_B.read_tt_kavin2_fun[19];

  /* DataStoreWrite: '<S1>/VS1 Write' */
  t15_2_DWork.VS1_up = t15_2_B.read_tt_kavin2_fun[6];

  /* DataStoreWrite: '<S1>/VS3 Write' */
  t15_2_DWork.VS3_up = t15_2_B.read_tt_kavin2_fun[7];

  /* DataStoreWrite: '<S1>/Vcspf Write' */
  memcpy(&t15_2_DWork.Vcspf_up[0], &t15_2_B.read_tt_kavin2_fun[8], 11U * sizeof
         (real_T));

  /* DataStoreWrite: '<S1>/curr Write' */
  t15_2_DWork.c_cur_max = t15_2_B.read_tt_kavin2_fun[20];

  /* DataStoreWrite: '<S1>/ntur Write' */
  memcpy(&t15_2_DWork.ntur[0], &t15_2_B.read_tt_kavin2_fun[32], 12U * sizeof
         (real_T));

  /* Level2 S-Function Block: '<S1>/read_elong_fun' (read_gaps) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[2];
    sfcnOutputs(rts, 0);
  }

  /* DataStoreWrite: '<S1>/Elong Write' */
  memcpy(&t15_2_DWork.Elong[0], &t15_2_B.read_elong_fun[0], 100U * sizeof(real_T));

  /* Level2 S-Function Block: '<S1>/read_volt_fun' (read_volt) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[3];
    sfcnOutputs(rts, 0);
  }

  /* DataStoreWrite: '<S1>/Volt Write' */
  memcpy(&t15_2_DWork.volt[0], &t15_2_B.read_volt_fun[0], 10000U * sizeof(real_T));

  /* Level2 S-Function Block: '<S1>/read_g1_fun' (read_gaps) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[4];
    sfcnOutputs(rts, 0);
  }

  /* Level2 S-Function Block: '<S1>/read_g1_t_fun' (read_gaps_term) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[5];
    sfcnOutputs(rts, 0);
  }

  /* Level2 S-Function Block: '<S1>/read_g2_fun' (read_gaps) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[6];
    sfcnOutputs(rts, 0);
  }

  /* Level2 S-Function Block: '<S1>/read_g2_t_fun' (read_gaps_term) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[7];
    sfcnOutputs(rts, 0);
  }

  /* Level2 S-Function Block: '<S1>/read_g3_fun' (read_gaps) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[8];
    sfcnOutputs(rts, 0);
  }

  /* Level2 S-Function Block: '<S1>/read_g3_t_fun' (read_gaps_term) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[9];
    sfcnOutputs(rts, 0);
  }

  /* Level2 S-Function Block: '<S1>/read_g4_fun' (read_gaps) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[10];
    sfcnOutputs(rts, 0);
  }

  /* Level2 S-Function Block: '<S1>/read_g4_t_fun' (read_gaps_term) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[11];
    sfcnOutputs(rts, 0);
  }

  /* Level2 S-Function Block: '<S1>/read_g5_fun' (read_gaps) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[12];
    sfcnOutputs(rts, 0);
  }

  /* Level2 S-Function Block: '<S1>/read_g5_t_fun' (read_gaps_term) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[13];
    sfcnOutputs(rts, 0);
  }

  /* Level2 S-Function Block: '<S1>/read_g6_fun' (read_gaps) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[14];
    sfcnOutputs(rts, 0);
  }

  /* Level2 S-Function Block: '<S1>/read_g6_t_fun' (read_gaps_term) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[15];
    sfcnOutputs(rts, 0);
  }

  for (i = 0; i < 100; i++) {
    /* DataStoreWrite: '<S1>/g1 Write' */
    t15_2_DWork.g1[i] = t15_2_B.read_g1_fun[i];

    /* DataStoreWrite: '<S1>/g1_t Write' */
    t15_2_DWork.g1_term[i] = t15_2_B.read_g1_t_fun[i];

    /* DataStoreWrite: '<S1>/g2 Write' */
    t15_2_DWork.g2[i] = t15_2_B.read_g2_fun[i];

    /* DataStoreWrite: '<S1>/g2_t Write' */
    t15_2_DWork.g2_term[i] = t15_2_B.read_g2_t_fun[i];

    /* DataStoreWrite: '<S1>/g3 Write' */
    t15_2_DWork.g3[i] = t15_2_B.read_g3_fun[i];

    /* DataStoreWrite: '<S1>/g3_t Write' */
    t15_2_DWork.g3_term[i] = t15_2_B.read_g3_t_fun[i];

    /* DataStoreWrite: '<S1>/g4 Write' */
    t15_2_DWork.g4[i] = t15_2_B.read_g4_fun[i];

    /* DataStoreWrite: '<S1>/g4_t Write' */
    t15_2_DWork.g4_term[i] = t15_2_B.read_g4_t_fun[i];

    /* DataStoreWrite: '<S1>/g5 Write' */
    t15_2_DWork.g5[i] = t15_2_B.read_g5_fun[i];

    /* DataStoreWrite: '<S1>/g5_t Write' */
    t15_2_DWork.g5_term[i] = t15_2_B.read_g5_t_fun[i];

    /* DataStoreWrite: '<S1>/g6 Write' */
    t15_2_DWork.g6[i] = t15_2_B.read_g6_fun[i];

    /* DataStoreWrite: '<S1>/g6_t Write' */
    t15_2_DWork.g6_term[i] = t15_2_B.read_g6_t_fun[i];
  }

  /* Level2 S-Function Block: '<S1>/read_scr_fun' (pf_lookup3) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[16];
    sfcnOutputs(rts, 0);
  }

  /* DataStoreWrite: '<S1>/scr Write' */
  memcpy(&t15_2_DWork.scr_data[0], &t15_2_B.read_scr_fun[0], 6500U * sizeof
         (real_T));

  /* DataStoreRead: '<S10>/Data Store Read3' */
  t15_2_B.DataStoreRead3 = t15_2_DWork.Tu;
  for (i = 0; i < 11; i++) {
    /* DataStoreRead: '<S11>/Data Store Read1' */
    t15_2_B.DataStoreRead1[i] = t15_2_DWork.Vcspf_up[i];

    /* Memory: '<S9>/Memory1' */
    t15_2_B.Memory1[i] = t15_2_DWork.Memory1_PreviousInput[i];

    /* DataStoreRead: '<S10>/Data Store Read1' */
    t15_2_B.DataStoreRead1_l[i] = t15_2_DWork.Vcspf_up[i];

    /* Gain: '<S10>/2' */
    t15_2_B.u[i] = t15_2_P._Gain * t15_2_B.DataStoreRead1_l[i];

    /* Product: '<S10>/Divide1' */
    t15_2_B.Divide1[i] = t15_2_B.u[i] / t15_2_B.DataStoreRead3;

    /* DataStoreRead: '<S6>/Data Store Read2' */
    t15_2_B.DataStoreRead2[i] = t15_2_DWork.ntur[i];
  }

  /* Gain: '<S19>/Time s' incorporates:
   *  Inport: '<Root>/In1'
   */
  t15_2_B.Times = t15_2_P.Times_Gain * t15_2_U.In1[8];

  /* Gain: '<S16>/1e-6' incorporates:
   *  Inport: '<Root>/In1'
   */
  t15_2_B.e6 = t15_2_P.e6_Gain * t15_2_U.In1[3];

  /* Gain: '<S26>/1e2' incorporates:
   *  Inport: '<Root>/In1'
   *  Inport: '<Root>/In2'
   */
  t15_2_B.e2[0] = t15_2_P.e2_Gain * t15_2_U.In2[0];
  t15_2_B.e2[1] = t15_2_P.e2_Gain * t15_2_U.In2[1];
  t15_2_B.e2[2] = t15_2_P.e2_Gain * t15_2_U.In1[6];
  t15_2_B.e2[3] = t15_2_P.e2_Gain * t15_2_U.In2[3];
  t15_2_B.e2[4] = t15_2_P.e2_Gain * t15_2_U.In2[4];
  t15_2_B.e2[5] = t15_2_P.e2_Gain * t15_2_U.In1[5];

  /* Memory: '<S21>/Memory1' */
  t15_2_B.Memory1_j = t15_2_DWork.Memory1_PreviousInput_c;

  /* Gain: '<S16>/1e-6   ' incorporates:
   *  Inport: '<Root>/In2'
   */
  for (i = 0; i < 15; i++) {
    t15_2_B.e6_n[i] = t15_2_U.In2[i + 6] * t15_2_P.e6_Gain_f;
  }

  /* End of Gain: '<S16>/1e-6   ' */

  /* DataStoreRead: '<S21>/RupRd Read1' */
  t15_2_B.RupRdRead1 = t15_2_DWork.RupRd[4];

  /* Gain: '<S21>/1e-3' */
  t15_2_B.e3 = t15_2_P.e3_Gain * t15_2_B.RupRdRead1;

  /* DataStoreRead: '<S21>/ntur Read2' */
  t15_2_B.nturRead2 = t15_2_DWork.ntur[2];

  /* Product: '<S21>/Product1' */
  t15_2_B.Product1 = t15_2_B.e3 * t15_2_B.nturRead2;

  /* RelationalOperator: '<S21>/Relational Operator' */
  t15_2_B.RelationalOperator = (t15_2_B.e6_n[2] < t15_2_B.Product1);

  /* Memory: '<S32>/Memory' */
  t15_2_B.Memory = t15_2_DWork.Memory_PreviousInput;

  /* Logic: '<S32>/Logical Operator' */
  t15_2_B.LogicalOperator = ((t15_2_B.RelationalOperator != 0.0) ||
    (t15_2_B.Memory != 0.0));

  /* Switch: '<S21>/switch1' */
  if (t15_2_B.LogicalOperator >= t15_2_P.switch1_Threshold) {
    t15_2_B.switch1 = t15_2_B.Memory1_j;
  } else {
    t15_2_B.switch1 = t15_2_B.Times;
  }

  /* End of Switch: '<S21>/switch1' */

  /* Sum: '<S21>/Add2' */
  t15_2_B.Add2 = t15_2_B.switch1 - t15_2_B.Times;

  /* DataStoreRead: '<S21>/Data Store Read' */
  t15_2_B.DataStoreRead = t15_2_DWork.RupRd[1];

  /* Product: '<S21>/Product' */
  t15_2_B.Product = t15_2_B.Add2 / t15_2_B.DataStoreRead;

  /* Sum: '<S21>/Add1' incorporates:
   *  Constant: '<S21>/Constant4'
   */
  t15_2_B.Add1 = t15_2_B.Product + t15_2_P.Constant4_Value;

  /* Saturate: '<S21>/1 0' */
  u = t15_2_B.Add1;
  tmin = t15_2_P.u_LowerSat;
  u_0 = t15_2_P.u_UpperSat;
  if (u >= u_0) {
    t15_2_B.u_b = u_0;
  } else if (u <= tmin) {
    t15_2_B.u_b = tmin;
  } else {
    t15_2_B.u_b = u;
  }

  /* End of Saturate: '<S21>/1 0' */

  /* Memory: '<S46>/Memory2' */
  t15_2_B.Memory2 = t15_2_DWork.Memory2_PreviousInput;

  /* Switch: '<S46>/c_eob  1' */
  if (t15_2_B.u_b >= t15_2_P.c_eob1_Threshold) {
    for (i = 0; i < 50; i++) {
      /* DataStoreRead: '<S46>/g1 Read1' */
      t15_2_B.g1Read1[i] = t15_2_DWork.g1[(i << 1) + 1];

      /* DataStoreRead: '<S46>/g1 Read' */
      t15_2_B.g1Read[i] = t15_2_DWork.g1[i << 1];
    }

    /* Dynamic Look-Up Table Block: '<S46>/g1ref1'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.g1ref1), &t15_2_B.g1Read1[0], t15_2_B.Times,
                         &t15_2_B.g1Read[0], 49U);
    t15_2_B.c_eob1 = t15_2_B.g1ref1;
  } else {
    t15_2_B.c_eob1 = t15_2_B.Memory2;
  }

  /* End of Switch: '<S46>/c_eob  1' */

  /* Memory: '<S46>/Memory1' */
  t15_2_B.Memory1_h = t15_2_DWork.Memory1_PreviousInput_l;

  /* Switch: '<S46>/c_eob  ' */
  if (t15_2_B.u_b >= t15_2_P.c_eob_Threshold) {
    t15_2_B.c_eob = t15_2_B.Times;
  } else {
    t15_2_B.c_eob = t15_2_B.Memory1_h;
  }

  /* End of Switch: '<S46>/c_eob  ' */

  /* Switch: '<S46>/c_eob' */
  if (t15_2_B.u_b >= t15_2_P.c_eob_Threshold_o) {
    t15_2_B.c_eob_c = t15_2_B.c_eob1;
  } else {
    /* DataStoreRead: '<S52>/g1_t Read' */
    memcpy(&t15_2_B.g1_tRead[0], &t15_2_DWork.g1_term[0], 100U * sizeof(real_T));

    /* SignalConversion: '<S52>/TmpSignal ConversionAtg1_term,refInport3' */
    t15_2_B.TmpSignalConversionAtg1_termref[0] = t15_2_B.c_eob1;
    for (i = 0; i < 49; i++) {
      /* Selector: '<S52>/Selector' */
      t15_2_B.Selector_c[i] = t15_2_B.g1_tRead[((1 + i) << 1) + 1];
      t15_2_B.TmpSignalConversionAtg1_termref[i + 1] = t15_2_B.Selector_c[i];
    }

    /* End of SignalConversion: '<S52>/TmpSignal ConversionAtg1_term,refInport3' */

    /* DataStoreRead: '<S52>/trd Read' */
    t15_2_B.trdRead_d = t15_2_DWork.trd_ref;

    /* DataStoreRead: '<S52>/RupRd Read' */
    t15_2_B.RupRdRead_p = t15_2_DWork.RupRd[1];
    for (i = 0; i < 50; i++) {
      /* Selector: '<S52>/Selector1' */
      t15_2_B.Selector1_c[i] = t15_2_B.g1_tRead[i << 1];

      /* Product: '<S52>/Divide6' */
      t15_2_B.Divide6_k[i] = t15_2_B.Selector1_c[i] * t15_2_B.RupRdRead_p /
        t15_2_B.trdRead_d;

      /* Sum: '<S52>/Add2' */
      t15_2_B.Add2_p[i] = t15_2_B.c_eob + t15_2_B.Divide6_k[i];
    }

    /* Dynamic Look-Up Table Block: '<S52>/g1_term,ref'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.g1_termref),
                         &t15_2_B.TmpSignalConversionAtg1_termref[0],
                         t15_2_B.Times, &t15_2_B.Add2_p[0], 49U);
    t15_2_B.c_eob_c = t15_2_B.g1_termref;
  }

  /* End of Switch: '<S46>/c_eob' */

  /* Sum: '<S26>/Add2' */
  t15_2_B.Add2_i = t15_2_B.e2[0] - t15_2_B.c_eob_c;

  /* Memory: '<S47>/Memory2' */
  t15_2_B.Memory2_b = t15_2_DWork.Memory2_PreviousInput_k;

  /* Switch: '<S47>/c_eob  1' */
  if (t15_2_B.u_b >= t15_2_P.c_eob1_Threshold_e) {
    for (i = 0; i < 50; i++) {
      /* DataStoreRead: '<S47>/g2 Read1' */
      t15_2_B.g2Read1[i] = t15_2_DWork.g2[(i << 1) + 1];

      /* DataStoreRead: '<S47>/g2 Read' */
      t15_2_B.g2Read[i] = t15_2_DWork.g2[i << 1];
    }

    /* Dynamic Look-Up Table Block: '<S47>/g2ref'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.g2ref), &t15_2_B.g2Read1[0], t15_2_B.Times,
                         &t15_2_B.g2Read[0], 49U);
    t15_2_B.c_eob1_m = t15_2_B.g2ref;
  } else {
    t15_2_B.c_eob1_m = t15_2_B.Memory2_b;
  }

  /* End of Switch: '<S47>/c_eob  1' */

  /* Memory: '<S47>/Memory1' */
  t15_2_B.Memory1_e = t15_2_DWork.Memory1_PreviousInput_la;

  /* Switch: '<S47>/c_eob  ' */
  if (t15_2_B.u_b >= t15_2_P.c_eob_Threshold_d) {
    t15_2_B.c_eob_p = t15_2_B.Times;
  } else {
    t15_2_B.c_eob_p = t15_2_B.Memory1_e;
  }

  /* End of Switch: '<S47>/c_eob  ' */

  /* Switch: '<S47>/c_eob' */
  if (t15_2_B.u_b >= t15_2_P.c_eob_Threshold_h) {
    t15_2_B.c_eob_k = t15_2_B.c_eob1_m;
  } else {
    /* DataStoreRead: '<S53>/g2_t Read' */
    memcpy(&t15_2_B.g2_tRead[0], &t15_2_DWork.g2_term[0], 100U * sizeof(real_T));

    /* SignalConversion: '<S53>/TmpSignal ConversionAtg2_term,refInport3' */
    t15_2_B.TmpSignalConversionAtg2_termref[0] = t15_2_B.c_eob1_m;
    for (i = 0; i < 49; i++) {
      /* Selector: '<S53>/Selector' */
      t15_2_B.Selector_h[i] = t15_2_B.g2_tRead[((1 + i) << 1) + 1];
      t15_2_B.TmpSignalConversionAtg2_termref[i + 1] = t15_2_B.Selector_h[i];
    }

    /* End of SignalConversion: '<S53>/TmpSignal ConversionAtg2_term,refInport3' */

    /* DataStoreRead: '<S53>/trd Read' */
    t15_2_B.trdRead_c = t15_2_DWork.trd_ref;

    /* DataStoreRead: '<S53>/RupRd Read' */
    t15_2_B.RupRdRead_mw = t15_2_DWork.RupRd[1];
    for (i = 0; i < 50; i++) {
      /* Selector: '<S53>/Selector1' */
      t15_2_B.Selector1_p[i] = t15_2_B.g2_tRead[i << 1];

      /* Product: '<S53>/Divide6' */
      t15_2_B.Divide6_il[i] = t15_2_B.Selector1_p[i] * t15_2_B.RupRdRead_mw /
        t15_2_B.trdRead_c;

      /* Sum: '<S53>/Add2' */
      t15_2_B.Add2_m[i] = t15_2_B.c_eob_p + t15_2_B.Divide6_il[i];
    }

    /* Dynamic Look-Up Table Block: '<S53>/g2_term,ref'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.g2_termref),
                         &t15_2_B.TmpSignalConversionAtg2_termref[0],
                         t15_2_B.Times, &t15_2_B.Add2_m[0], 49U);
    t15_2_B.c_eob_k = t15_2_B.g2_termref;
  }

  /* End of Switch: '<S47>/c_eob' */

  /* Sum: '<S26>/Add1' */
  t15_2_B.Add1_c = t15_2_B.e2[1] - t15_2_B.c_eob_k;

  /* Memory: '<S48>/Memory2' */
  t15_2_B.Memory2_f = t15_2_DWork.Memory2_PreviousInput_i;

  /* Switch: '<S48>/c_eob  1' */
  if (t15_2_B.u_b >= t15_2_P.c_eob1_Threshold_j) {
    for (i = 0; i < 50; i++) {
      /* DataStoreRead: '<S48>/g3 Read1' */
      t15_2_B.g3Read1[i] = t15_2_DWork.g3[(i << 1) + 1];

      /* DataStoreRead: '<S48>/g3 Read' */
      t15_2_B.g3Read[i] = t15_2_DWork.g3[i << 1];
    }

    /* Dynamic Look-Up Table Block: '<S48>/g3ref'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.g3ref), &t15_2_B.g3Read1[0], t15_2_B.Times,
                         &t15_2_B.g3Read[0], 49U);
    t15_2_B.c_eob1_n = t15_2_B.g3ref;
  } else {
    t15_2_B.c_eob1_n = t15_2_B.Memory2_f;
  }

  /* End of Switch: '<S48>/c_eob  1' */

  /* Memory: '<S48>/Memory1' */
  t15_2_B.Memory1_i = t15_2_DWork.Memory1_PreviousInput_i;

  /* Switch: '<S48>/c_eob  ' */
  if (t15_2_B.u_b >= t15_2_P.c_eob_Threshold_om) {
    t15_2_B.c_eob_l = t15_2_B.Times;
  } else {
    t15_2_B.c_eob_l = t15_2_B.Memory1_i;
  }

  /* End of Switch: '<S48>/c_eob  ' */

  /* Switch: '<S48>/c_eob' */
  if (t15_2_B.u_b >= t15_2_P.c_eob_Threshold_p) {
    t15_2_B.c_eob_o = t15_2_B.c_eob1_n;
  } else {
    /* DataStoreRead: '<S54>/g3_t Read' */
    memcpy(&t15_2_B.g3_tRead[0], &t15_2_DWork.g3_term[0], 100U * sizeof(real_T));

    /* SignalConversion: '<S54>/TmpSignal ConversionAtg3_term,refInport3' */
    t15_2_B.TmpSignalConversionAtg3_termref[0] = t15_2_B.c_eob1_n;
    for (i = 0; i < 49; i++) {
      /* Selector: '<S54>/Selector' */
      t15_2_B.Selector_p[i] = t15_2_B.g3_tRead[((1 + i) << 1) + 1];
      t15_2_B.TmpSignalConversionAtg3_termref[i + 1] = t15_2_B.Selector_p[i];
    }

    /* End of SignalConversion: '<S54>/TmpSignal ConversionAtg3_term,refInport3' */

    /* DataStoreRead: '<S54>/trd Read' */
    t15_2_B.trdRead_m = t15_2_DWork.trd_ref;

    /* DataStoreRead: '<S54>/RupRd Read' */
    t15_2_B.RupRdRead_j = t15_2_DWork.RupRd[1];
    for (i = 0; i < 50; i++) {
      /* Selector: '<S54>/Selector1' */
      t15_2_B.Selector1_a[i] = t15_2_B.g3_tRead[i << 1];

      /* Product: '<S54>/Divide6' */
      t15_2_B.Divide6_el[i] = t15_2_B.Selector1_a[i] * t15_2_B.RupRdRead_j /
        t15_2_B.trdRead_m;

      /* Sum: '<S54>/Add2' */
      t15_2_B.Add2_cn[i] = t15_2_B.c_eob_l + t15_2_B.Divide6_el[i];
    }

    /* Dynamic Look-Up Table Block: '<S54>/g3_term,ref'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.g3_termref),
                         &t15_2_B.TmpSignalConversionAtg3_termref[0],
                         t15_2_B.Times, &t15_2_B.Add2_cn[0], 49U);
    t15_2_B.c_eob_o = t15_2_B.g3_termref;
  }

  /* End of Switch: '<S48>/c_eob' */

  /* Sum: '<S26>/Add3' */
  t15_2_B.Add3 = t15_2_B.e2[2] - t15_2_B.c_eob_o;

  /* Memory: '<S49>/Memory2' */
  t15_2_B.Memory2_fe = t15_2_DWork.Memory2_PreviousInput_e;

  /* Switch: '<S49>/c_eob  1' */
  if (t15_2_B.u_b >= t15_2_P.c_eob1_Threshold_l) {
    for (i = 0; i < 50; i++) {
      /* DataStoreRead: '<S49>/g4 Read1' */
      t15_2_B.g4Read1[i] = t15_2_DWork.g4[(i << 1) + 1];

      /* DataStoreRead: '<S49>/g4 Read' */
      t15_2_B.g4Read[i] = t15_2_DWork.g4[i << 1];
    }

    /* Dynamic Look-Up Table Block: '<S49>/g4ref'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.g4ref), &t15_2_B.g4Read1[0], t15_2_B.Times,
                         &t15_2_B.g4Read[0], 49U);
    t15_2_B.c_eob1_o = t15_2_B.g4ref;
  } else {
    t15_2_B.c_eob1_o = t15_2_B.Memory2_fe;
  }

  /* End of Switch: '<S49>/c_eob  1' */

  /* Memory: '<S49>/Memory1' */
  t15_2_B.Memory1_o = t15_2_DWork.Memory1_PreviousInput_f;

  /* Switch: '<S49>/c_eob  ' */
  if (t15_2_B.u_b >= t15_2_P.c_eob_Threshold_b) {
    t15_2_B.c_eob_f = t15_2_B.Times;
  } else {
    t15_2_B.c_eob_f = t15_2_B.Memory1_o;
  }

  /* End of Switch: '<S49>/c_eob  ' */

  /* Switch: '<S49>/c_eob' */
  if (t15_2_B.u_b >= t15_2_P.c_eob_Threshold_n) {
    t15_2_B.c_eob_fx = t15_2_B.c_eob1_o;
  } else {
    /* DataStoreRead: '<S55>/g4_t Read' */
    memcpy(&t15_2_B.g4_tRead[0], &t15_2_DWork.g4_term[0], 100U * sizeof(real_T));

    /* SignalConversion: '<S55>/TmpSignal ConversionAtg4_term,refInport3' */
    t15_2_B.TmpSignalConversionAtg4_termref[0] = t15_2_B.c_eob1_o;
    for (i = 0; i < 49; i++) {
      /* Selector: '<S55>/Selector' */
      t15_2_B.Selector_g[i] = t15_2_B.g4_tRead[((1 + i) << 1) + 1];
      t15_2_B.TmpSignalConversionAtg4_termref[i + 1] = t15_2_B.Selector_g[i];
    }

    /* End of SignalConversion: '<S55>/TmpSignal ConversionAtg4_term,refInport3' */

    /* DataStoreRead: '<S55>/trd Read' */
    t15_2_B.trdRead_j = t15_2_DWork.trd_ref;

    /* DataStoreRead: '<S55>/RupRd Read' */
    t15_2_B.RupRdRead_o = t15_2_DWork.RupRd[1];
    for (i = 0; i < 50; i++) {
      /* Selector: '<S55>/Selector1' */
      t15_2_B.Selector1_fw[i] = t15_2_B.g4_tRead[i << 1];

      /* Product: '<S55>/Divide6' */
      t15_2_B.Divide6_c[i] = t15_2_B.Selector1_fw[i] * t15_2_B.RupRdRead_o /
        t15_2_B.trdRead_j;

      /* Sum: '<S55>/Add2' */
      t15_2_B.Add2_ln[i] = t15_2_B.c_eob_f + t15_2_B.Divide6_c[i];
    }

    /* Dynamic Look-Up Table Block: '<S55>/g4_term,ref'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.g4_termref),
                         &t15_2_B.TmpSignalConversionAtg4_termref[0],
                         t15_2_B.Times, &t15_2_B.Add2_ln[0], 49U);
    t15_2_B.c_eob_fx = t15_2_B.g4_termref;
  }

  /* End of Switch: '<S49>/c_eob' */

  /* Sum: '<S26>/Add4' */
  t15_2_B.Add4 = t15_2_B.e2[3] - t15_2_B.c_eob_fx;

  /* DataStoreRead: '<S26>/t_tran2D Read' */
  t15_2_B.t_tran2DRead = t15_2_DWork.t_tran2D;

  /* DataStoreRead: '<S26>/tcont2 Read' */
  t15_2_B.tcont2Read = t15_2_DWork.tcont2;

  /* MinMax: '<S26>/MinMax' */
  u = t15_2_B.t_tran2DRead;
  tmin = t15_2_B.tcont2Read;
  if ((u >= tmin) || rtIsNaN(tmin)) {
    tmin = u;
  }

  t15_2_B.MinMax = tmin;

  /* End of MinMax: '<S26>/MinMax' */

  /* RelationalOperator: '<S26>/Relational Operator1' */
  t15_2_B.RelationalOperator1 = (t15_2_B.Times > t15_2_B.MinMax);

  /* Product: '<S26>/Divide12' */
  t15_2_B.Divide12 = t15_2_B.Add4 * t15_2_B.RelationalOperator1;

  /* Memory: '<S50>/Memory2' */
  t15_2_B.Memory2_fu = t15_2_DWork.Memory2_PreviousInput_j;

  /* Switch: '<S50>/c_eob  1' */
  if (t15_2_B.u_b >= t15_2_P.c_eob1_Threshold_jg) {
    for (i = 0; i < 50; i++) {
      /* DataStoreRead: '<S50>/g5 Read1' */
      t15_2_B.g5Read1[i] = t15_2_DWork.g5[(i << 1) + 1];

      /* DataStoreRead: '<S50>/g5 Read' */
      t15_2_B.g5Read[i] = t15_2_DWork.g5[i << 1];
    }

    /* Dynamic Look-Up Table Block: '<S50>/g5ref'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.g5ref), &t15_2_B.g5Read1[0], t15_2_B.Times,
                         &t15_2_B.g5Read[0], 49U);
    t15_2_B.c_eob1_b = t15_2_B.g5ref;
  } else {
    t15_2_B.c_eob1_b = t15_2_B.Memory2_fu;
  }

  /* End of Switch: '<S50>/c_eob  1' */

  /* Memory: '<S50>/Memory1' */
  t15_2_B.Memory1_n = t15_2_DWork.Memory1_PreviousInput_l5;

  /* Switch: '<S50>/c_eob  ' */
  if (t15_2_B.u_b >= t15_2_P.c_eob_Threshold_a) {
    t15_2_B.c_eob_n = t15_2_B.Times;
  } else {
    t15_2_B.c_eob_n = t15_2_B.Memory1_n;
  }

  /* End of Switch: '<S50>/c_eob  ' */

  /* Switch: '<S50>/c_eob' */
  if (t15_2_B.u_b >= t15_2_P.c_eob_Threshold_g) {
    t15_2_B.c_eob_ni = t15_2_B.c_eob1_b;
  } else {
    /* DataStoreRead: '<S56>/g5_t Read' */
    memcpy(&t15_2_B.g5_tRead[0], &t15_2_DWork.g5_term[0], 100U * sizeof(real_T));

    /* SignalConversion: '<S56>/TmpSignal ConversionAtg5_term,refInport3' */
    t15_2_B.TmpSignalConversionAtg5_termref[0] = t15_2_B.c_eob1_b;
    for (i = 0; i < 49; i++) {
      /* Selector: '<S56>/Selector' */
      t15_2_B.Selector_f[i] = t15_2_B.g5_tRead[((1 + i) << 1) + 1];
      t15_2_B.TmpSignalConversionAtg5_termref[i + 1] = t15_2_B.Selector_f[i];
    }

    /* End of SignalConversion: '<S56>/TmpSignal ConversionAtg5_term,refInport3' */

    /* DataStoreRead: '<S56>/trd Read' */
    t15_2_B.trdRead_l = t15_2_DWork.trd_ref;

    /* DataStoreRead: '<S56>/RupRd Read' */
    t15_2_B.RupRdRead_m = t15_2_DWork.RupRd[1];
    for (i = 0; i < 50; i++) {
      /* Selector: '<S56>/Selector1' */
      t15_2_B.Selector1_f[i] = t15_2_B.g5_tRead[i << 1];

      /* Product: '<S56>/Divide6' */
      t15_2_B.Divide6_j[i] = t15_2_B.Selector1_f[i] * t15_2_B.RupRdRead_m /
        t15_2_B.trdRead_l;

      /* Sum: '<S56>/Add2' */
      t15_2_B.Add2_l[i] = t15_2_B.c_eob_n + t15_2_B.Divide6_j[i];
    }

    /* Dynamic Look-Up Table Block: '<S56>/g5_term,ref'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.g5_termref),
                         &t15_2_B.TmpSignalConversionAtg5_termref[0],
                         t15_2_B.Times, &t15_2_B.Add2_l[0], 49U);
    t15_2_B.c_eob_ni = t15_2_B.g5_termref;
  }

  /* End of Switch: '<S50>/c_eob' */

  /* Sum: '<S26>/Add5' */
  t15_2_B.Add5 = t15_2_B.e2[4] - t15_2_B.c_eob_ni;

  /* Memory: '<S51>/Memory2' */
  t15_2_B.Memory2_g = t15_2_DWork.Memory2_PreviousInput_c;

  /* Switch: '<S51>/c_eob  1' */
  if (t15_2_B.u_b >= t15_2_P.c_eob1_Threshold_ev) {
    for (i = 0; i < 50; i++) {
      /* DataStoreRead: '<S51>/g6 Read1' */
      t15_2_B.g6Read1[i] = t15_2_DWork.g6[(i << 1) + 1];

      /* DataStoreRead: '<S51>/g6 Read' */
      t15_2_B.g6Read[i] = t15_2_DWork.g6[i << 1];
    }

    /* Dynamic Look-Up Table Block: '<S51>/g6ref'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.g6ref), &t15_2_B.g6Read1[0], t15_2_B.Times,
                         &t15_2_B.g6Read[0], 49U);
    t15_2_B.c_eob1_j = t15_2_B.g6ref;
  } else {
    t15_2_B.c_eob1_j = t15_2_B.Memory2_g;
  }

  /* End of Switch: '<S51>/c_eob  1' */

  /* Memory: '<S51>/Memory1' */
  t15_2_B.Memory1_nl = t15_2_DWork.Memory1_PreviousInput_k;

  /* Switch: '<S51>/c_eob  ' */
  if (t15_2_B.u_b >= t15_2_P.c_eob_Threshold_ay) {
    t15_2_B.c_eob_oo = t15_2_B.Times;
  } else {
    t15_2_B.c_eob_oo = t15_2_B.Memory1_nl;
  }

  /* End of Switch: '<S51>/c_eob  ' */

  /* Switch: '<S51>/c_eob' */
  if (t15_2_B.u_b >= t15_2_P.c_eob_Threshold_ht) {
    t15_2_B.c_eob_d = t15_2_B.c_eob1_j;
  } else {
    /* DataStoreRead: '<S57>/g6_t Read' */
    memcpy(&t15_2_B.g6_tRead[0], &t15_2_DWork.g6_term[0], 100U * sizeof(real_T));

    /* SignalConversion: '<S57>/TmpSignal ConversionAtg6_term,refInport3' */
    t15_2_B.TmpSignalConversionAtg6_termref[0] = t15_2_B.c_eob1_j;
    for (i = 0; i < 49; i++) {
      /* Selector: '<S57>/Selector' */
      t15_2_B.Selector[i] = t15_2_B.g6_tRead[((1 + i) << 1) + 1];
      t15_2_B.TmpSignalConversionAtg6_termref[i + 1] = t15_2_B.Selector[i];
    }

    /* End of SignalConversion: '<S57>/TmpSignal ConversionAtg6_term,refInport3' */

    /* DataStoreRead: '<S57>/trd Read' */
    t15_2_B.trdRead = t15_2_DWork.trd_ref;

    /* DataStoreRead: '<S57>/RupRd Read' */
    t15_2_B.RupRdRead = t15_2_DWork.RupRd[1];
    for (i = 0; i < 50; i++) {
      /* Selector: '<S57>/Selector1' */
      t15_2_B.Selector1[i] = t15_2_B.g6_tRead[i << 1];

      /* Product: '<S57>/Divide6' */
      t15_2_B.Divide6_p[i] = t15_2_B.Selector1[i] * t15_2_B.RupRdRead /
        t15_2_B.trdRead;

      /* Sum: '<S57>/Add2' */
      t15_2_B.Add2_d[i] = t15_2_B.c_eob_oo + t15_2_B.Divide6_p[i];
    }

    /* Dynamic Look-Up Table Block: '<S57>/g6_term,ref'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.g6_termref),
                         &t15_2_B.TmpSignalConversionAtg6_termref[0],
                         t15_2_B.Times, &t15_2_B.Add2_d[0], 49U);
    t15_2_B.c_eob_d = t15_2_B.g6_termref;
  }

  /* End of Switch: '<S51>/c_eob' */

  /* Sum: '<S26>/Add6' */
  t15_2_B.Add6 = t15_2_B.e2[5] - t15_2_B.c_eob_d;

  /* Product: '<S26>/Divide1' */
  t15_2_B.Divide1_c = t15_2_B.Add6 * t15_2_B.RelationalOperator1;

  /* Gain: '<S26>/1e-2' */
  t15_2_B.e2_f[0] = t15_2_P.e2_Gain_d * t15_2_B.Add2_i;
  t15_2_B.e2_f[1] = t15_2_P.e2_Gain_d * t15_2_B.Add1_c;
  t15_2_B.e2_f[2] = t15_2_P.e2_Gain_d * t15_2_B.Add3;
  t15_2_B.e2_f[3] = t15_2_P.e2_Gain_d * t15_2_B.Divide12;
  t15_2_B.e2_f[4] = t15_2_P.e2_Gain_d * t15_2_B.Add5;
  t15_2_B.e2_f[5] = t15_2_P.e2_Gain_d * t15_2_B.Divide1_c;

  /* Memory: '<S22>/Memory1' */
  t15_2_B.Memory1_l = t15_2_DWork.Memory1_PreviousInput_h;

  /* Switch: '<S22>/c_eob' */
  if (t15_2_B.u_b >= t15_2_P.c_eob_Threshold_j) {
    for (i = 0; i < 500; i++) {
      /* DataStoreRead: '<S22>/scr2 Read' */
      t15_2_B.scr2Read_c[i] = t15_2_DWork.scr_data[13 * i + 1];

      /* DataStoreRead: '<S22>/scr1 Read' */
      t15_2_B.scr1Read_in[i] = t15_2_DWork.scr_data[13 * i];
    }

    /* Dynamic Look-Up Table Block: '<S22>/Ipref'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.Ipref), &t15_2_B.scr2Read_c[0],
                         t15_2_B.Times, &t15_2_B.scr1Read_in[0], 499U);
    t15_2_B.c_eob_d4 = t15_2_B.Ipref;
  } else {
    t15_2_B.c_eob_d4 = t15_2_B.Memory1_l;
  }

  /* End of Switch: '<S22>/c_eob' */

  /* Product: '<S22>/Divide6' */
  t15_2_B.Divide6 = t15_2_B.c_eob_d4 * t15_2_B.u_b;

  /* Sum: '<S16>/Add1' */
  t15_2_B.Add1_p = t15_2_B.e6 - t15_2_B.Divide6;

  /* Memory: '<S35>/Memory2' */
  t15_2_B.Memory2_m = t15_2_DWork.Memory2_PreviousInput_b;

  /* Switch: '<S35>/c_eob' */
  if (t15_2_B.u_b >= t15_2_P.c_eob_Threshold_i) {
    for (i = 0; i < 500; i++) {
      /* DataStoreRead: '<S35>/scr2 Read' */
      t15_2_B.scr2Read_m[i] = t15_2_DWork.scr_data[13 * i + 2];

      /* DataStoreRead: '<S35>/scr1 Read' */
      t15_2_B.scr1Read_n[i] = t15_2_DWork.scr_data[13 * i];
    }

    /* Dynamic Look-Up Table Block: '<S35>/I1'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.I1_k), &t15_2_B.scr2Read_m[0], t15_2_B.Times,
                         &t15_2_B.scr1Read_n[0], 499U);
    t15_2_B.c_eob_fm = t15_2_B.I1_k;
  } else {
    t15_2_B.c_eob_fm = t15_2_B.Memory2_m;
  }

  /* End of Switch: '<S35>/c_eob' */

  /* Product: '<S35>/Divide1' */
  t15_2_B.Divide1_n = t15_2_B.c_eob_fm * t15_2_B.u_b;

  /* Sum: '<S25>/Add3' */
  t15_2_B.Add3_i = t15_2_B.e6_n[0] - t15_2_B.Divide1_n;

  /* Memory: '<S38>/Memory2' */
  t15_2_B.Memory2_n = t15_2_DWork.Memory2_PreviousInput_d;

  /* Switch: '<S38>/c_eob' */
  if (t15_2_B.u_b >= t15_2_P.c_eob_Threshold_ph) {
    for (i = 0; i < 500; i++) {
      /* DataStoreRead: '<S38>/scr2 Read' */
      t15_2_B.scr2Read[i] = t15_2_DWork.scr_data[13 * i + 3];

      /* DataStoreRead: '<S38>/scr1 Read' */
      t15_2_B.scr1Read_dp[i] = t15_2_DWork.scr_data[13 * i];
    }

    /* Dynamic Look-Up Table Block: '<S38>/I1'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.I1_c), &t15_2_B.scr2Read[0], t15_2_B.Times,
                         &t15_2_B.scr1Read_dp[0], 499U);
    t15_2_B.c_eob_h = t15_2_B.I1_c;
  } else {
    t15_2_B.c_eob_h = t15_2_B.Memory2_n;
  }

  /* End of Switch: '<S38>/c_eob' */

  /* Product: '<S38>/Divide1' */
  t15_2_B.Divide1_o = t15_2_B.c_eob_h * t15_2_B.u_b;

  /* Sum: '<S25>/Add1' */
  t15_2_B.Add1_n = t15_2_B.e6_n[1] - t15_2_B.Divide1_o;

  /* Memory: '<S39>/Memory2' */
  t15_2_B.Memory2_h = t15_2_DWork.Memory2_PreviousInput_o;

  /* Switch: '<S39>/c_eob' */
  if (t15_2_B.u_b >= t15_2_P.c_eob_Threshold_nq) {
    for (i = 0; i < 500; i++) {
      /* DataStoreRead: '<S39>/scr5 Read' */
      t15_2_B.scr5Read[i] = t15_2_DWork.scr_data[13 * i + 4];

      /* DataStoreRead: '<S39>/scr1 Read' */
      t15_2_B.scr1Read_i[i] = t15_2_DWork.scr_data[13 * i];
    }

    /* Dynamic Look-Up Table Block: '<S39>/I1'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.I1_f), &t15_2_B.scr5Read[0], t15_2_B.Times,
                         &t15_2_B.scr1Read_i[0], 499U);
    t15_2_B.c_eob_pa = t15_2_B.I1_f;
  } else {
    t15_2_B.c_eob_pa = t15_2_B.Memory2_h;
  }

  /* End of Switch: '<S39>/c_eob' */

  /* Product: '<S39>/Divide1' */
  t15_2_B.Divide1_na = t15_2_B.c_eob_pa * t15_2_B.u_b;

  /* Sum: '<S25>/Add2' */
  t15_2_B.Add2_h = t15_2_B.e6_n[2] - t15_2_B.Divide1_na;

  /* Memory: '<S40>/Memory2' */
  t15_2_B.Memory2_l = t15_2_DWork.Memory2_PreviousInput_jf;

  /* Switch: '<S40>/c_eob' */
  if (t15_2_B.u_b >= t15_2_P.c_eob_Threshold_ja) {
    for (i = 0; i < 500; i++) {
      /* DataStoreRead: '<S40>/scr6 Read' */
      t15_2_B.scr6Read[i] = t15_2_DWork.scr_data[13 * i + 5];

      /* DataStoreRead: '<S40>/scr1 Read' */
      t15_2_B.scr1Read_a[i] = t15_2_DWork.scr_data[13 * i];
    }

    /* Dynamic Look-Up Table Block: '<S40>/I1'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.I1_i), &t15_2_B.scr6Read[0], t15_2_B.Times,
                         &t15_2_B.scr1Read_a[0], 499U);
    t15_2_B.c_eob_l2 = t15_2_B.I1_i;
  } else {
    t15_2_B.c_eob_l2 = t15_2_B.Memory2_l;
  }

  /* End of Switch: '<S40>/c_eob' */

  /* Product: '<S40>/Divide1' */
  t15_2_B.Divide1_b = t15_2_B.c_eob_l2 * t15_2_B.u_b;

  /* Sum: '<S25>/Add4' */
  t15_2_B.Add4_a = t15_2_B.e6_n[3] - t15_2_B.Divide1_b;

  /* Memory: '<S41>/Memory2' */
  t15_2_B.Memory2_a = t15_2_DWork.Memory2_PreviousInput_f;

  /* Switch: '<S41>/c_eob' */
  if (t15_2_B.u_b >= t15_2_P.c_eob_Threshold_h5) {
    for (i = 0; i < 500; i++) {
      /* DataStoreRead: '<S41>/scr7 Read' */
      t15_2_B.scr7Read[i] = t15_2_DWork.scr_data[13 * i + 6];

      /* DataStoreRead: '<S41>/scr1 Read' */
      t15_2_B.scr1Read_m[i] = t15_2_DWork.scr_data[13 * i];
    }

    /* Dynamic Look-Up Table Block: '<S41>/I1'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.I1_j), &t15_2_B.scr7Read[0], t15_2_B.Times,
                         &t15_2_B.scr1Read_m[0], 499U);
    t15_2_B.c_eob_hm = t15_2_B.I1_j;
  } else {
    t15_2_B.c_eob_hm = t15_2_B.Memory2_a;
  }

  /* End of Switch: '<S41>/c_eob' */

  /* Product: '<S41>/Divide1' */
  t15_2_B.Divide1_a = t15_2_B.c_eob_hm * t15_2_B.u_b;

  /* Sum: '<S25>/Add5' */
  t15_2_B.Add5_h = t15_2_B.e6_n[4] - t15_2_B.Divide1_a;

  /* Memory: '<S42>/Memory2' */
  t15_2_B.Memory2_k = t15_2_DWork.Memory2_PreviousInput_i2;

  /* Switch: '<S42>/c_eob' */
  if (t15_2_B.u_b >= t15_2_P.c_eob_Threshold_ii) {
    for (i = 0; i < 500; i++) {
      /* DataStoreRead: '<S42>/scr8 Read' */
      t15_2_B.scr8Read[i] = t15_2_DWork.scr_data[13 * i + 7];

      /* DataStoreRead: '<S42>/sct1 Read' */
      t15_2_B.sct1Read[i] = t15_2_DWork.scr_data[13 * i];
    }

    /* Dynamic Look-Up Table Block: '<S42>/I1'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.I1_po), &t15_2_B.scr8Read[0], t15_2_B.Times,
                         &t15_2_B.sct1Read[0], 499U);
    t15_2_B.c_eob_hu = t15_2_B.I1_po;
  } else {
    t15_2_B.c_eob_hu = t15_2_B.Memory2_k;
  }

  /* End of Switch: '<S42>/c_eob' */

  /* Product: '<S42>/Divide1' */
  t15_2_B.Divide1_m = t15_2_B.c_eob_hu * t15_2_B.u_b;

  /* Sum: '<S25>/Add6' */
  t15_2_B.Add6_n = t15_2_B.e6_n[5] - t15_2_B.Divide1_m;

  /* Memory: '<S43>/Memory2' */
  t15_2_B.Memory2_j = t15_2_DWork.Memory2_PreviousInput_fs;

  /* Switch: '<S43>/c_eob' */
  if (t15_2_B.u_b >= t15_2_P.c_eob_Threshold_e) {
    for (i = 0; i < 500; i++) {
      /* DataStoreRead: '<S43>/scr9 Read' */
      t15_2_B.scr9Read[i] = t15_2_DWork.scr_data[13 * i + 8];

      /* DataStoreRead: '<S43>/scr1 Read' */
      t15_2_B.scr1Read_d[i] = t15_2_DWork.scr_data[13 * i];
    }

    /* Dynamic Look-Up Table Block: '<S43>/I1'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.I1_p), &t15_2_B.scr9Read[0], t15_2_B.Times,
                         &t15_2_B.scr1Read_d[0], 499U);
    t15_2_B.c_eob_m = t15_2_B.I1_p;
  } else {
    t15_2_B.c_eob_m = t15_2_B.Memory2_j;
  }

  /* End of Switch: '<S43>/c_eob' */

  /* Product: '<S43>/Divide1' */
  t15_2_B.Divide1_cw = t15_2_B.c_eob_m * t15_2_B.u_b;

  /* Sum: '<S25>/Add7' */
  t15_2_B.Add7 = t15_2_B.e6_n[6] - t15_2_B.Divide1_cw;

  /* Memory: '<S44>/Memory2' */
  t15_2_B.Memory2_p = t15_2_DWork.Memory2_PreviousInput_m;

  /* Switch: '<S44>/c_eob' */
  if (t15_2_B.u_b >= t15_2_P.c_eob_Threshold_ol) {
    for (i = 0; i < 500; i++) {
      /* DataStoreRead: '<S44>/scr10 Read' */
      t15_2_B.scr10Read[i] = t15_2_DWork.scr_data[13 * i + 9];

      /* DataStoreRead: '<S44>/scr1 Read' */
      t15_2_B.scr1Read_h[i] = t15_2_DWork.scr_data[13 * i];
    }

    /* Dynamic Look-Up Table Block: '<S44>/I1'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.I1_n), &t15_2_B.scr10Read[0], t15_2_B.Times,
                         &t15_2_B.scr1Read_h[0], 499U);
    t15_2_B.c_eob_i = t15_2_B.I1_n;
  } else {
    t15_2_B.c_eob_i = t15_2_B.Memory2_p;
  }

  /* End of Switch: '<S44>/c_eob' */

  /* Product: '<S44>/Divide1' */
  t15_2_B.Divide1_me = t15_2_B.c_eob_i * t15_2_B.u_b;

  /* Sum: '<S25>/Add8' */
  t15_2_B.Add8 = t15_2_B.e6_n[7] - t15_2_B.Divide1_me;

  /* Memory: '<S45>/Memory2' */
  t15_2_B.Memory2_aw = t15_2_DWork.Memory2_PreviousInput_n;

  /* Switch: '<S45>/c_eob' */
  if (t15_2_B.u_b >= t15_2_P.c_eob_Threshold_l) {
    for (i = 0; i < 500; i++) {
      /* DataStoreRead: '<S45>/scr11 Read' */
      t15_2_B.scr11Read[i] = t15_2_DWork.scr_data[13 * i + 10];

      /* DataStoreRead: '<S45>/scr1 Read' */
      t15_2_B.scr1Read[i] = t15_2_DWork.scr_data[13 * i];
    }

    /* Dynamic Look-Up Table Block: '<S45>/I1'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.I1), &t15_2_B.scr11Read[0], t15_2_B.Times,
                         &t15_2_B.scr1Read[0], 499U);
    t15_2_B.c_eob_nt = t15_2_B.I1;
  } else {
    t15_2_B.c_eob_nt = t15_2_B.Memory2_aw;
  }

  /* End of Switch: '<S45>/c_eob' */

  /* Product: '<S45>/Divide1' */
  t15_2_B.Divide1_f = t15_2_B.c_eob_nt * t15_2_B.u_b;

  /* Sum: '<S25>/Add9' */
  t15_2_B.Add9 = t15_2_B.e6_n[8] - t15_2_B.Divide1_f;

  /* Memory: '<S36>/Memory2' */
  t15_2_B.Memory2_f5 = t15_2_DWork.Memory2_PreviousInput_g;

  /* Switch: '<S36>/c_eob' */
  if (t15_2_B.u_b >= t15_2_P.c_eob_Threshold_hk) {
    for (i = 0; i < 500; i++) {
      /* DataStoreRead: '<S36>/scr12 Read' */
      t15_2_B.scr12Read[i] = t15_2_DWork.scr_data[13 * i + 11];

      /* DataStoreRead: '<S36>/scr1 Read' */
      t15_2_B.scr1Read_l[i] = t15_2_DWork.scr_data[13 * i];
    }

    /* Dynamic Look-Up Table Block: '<S36>/I1'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.I1_h), &t15_2_B.scr12Read[0], t15_2_B.Times,
                         &t15_2_B.scr1Read_l[0], 499U);
    t15_2_B.c_eob_ml = t15_2_B.I1_h;
  } else {
    t15_2_B.c_eob_ml = t15_2_B.Memory2_f5;
  }

  /* End of Switch: '<S36>/c_eob' */

  /* Product: '<S36>/Divide1' */
  t15_2_B.Divide1_mm = t15_2_B.c_eob_ml * t15_2_B.u_b;

  /* Sum: '<S25>/Add10' */
  t15_2_B.Add10 = t15_2_B.e6_n[9] - t15_2_B.Divide1_mm;

  /* Memory: '<S37>/Memory2' */
  t15_2_B.Memory2_lp = t15_2_DWork.Memory2_PreviousInput_c4;

  /* Switch: '<S37>/c_eob' */
  if (t15_2_B.u_b >= t15_2_P.c_eob_Threshold_al) {
    for (i = 0; i < 500; i++) {
      /* DataStoreRead: '<S37>/scr13 Read' */
      t15_2_B.scr13Read[i] = t15_2_DWork.scr_data[13 * i + 12];

      /* DataStoreRead: '<S37>/scr1 Read' */
      t15_2_B.scr1Read_hm[i] = t15_2_DWork.scr_data[13 * i];
    }

    /* Dynamic Look-Up Table Block: '<S37>/I1'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.I1_a), &t15_2_B.scr13Read[0], t15_2_B.Times,
                         &t15_2_B.scr1Read_hm[0], 499U);
    t15_2_B.c_eob_g = t15_2_B.I1_a;
  } else {
    t15_2_B.c_eob_g = t15_2_B.Memory2_lp;
  }

  /* End of Switch: '<S37>/c_eob' */

  /* Product: '<S37>/Divide1' */
  t15_2_B.Divide1_fg = t15_2_B.c_eob_g * t15_2_B.u_b;

  /* Sum: '<S25>/Add11' */
  t15_2_B.Add11 = t15_2_B.e6_n[10] - t15_2_B.Divide1_fg;

  /* DataStoreRead: '<S20>/Data Store Read1' */
  t15_2_B.DataStoreRead1_m = t15_2_DWork.Ipdiv;

  /* Abs: '<S20>/Abs' */
  t15_2_B.Abs = fabs(t15_2_B.DataStoreRead1_m);

  /* RelationalOperator: '<S20>/Relational Operator1' */
  t15_2_B.RelationalOperator1_a = (t15_2_B.Abs <= t15_2_B.e6);

  /* Memory: '<S29>/Memory' */
  t15_2_B.Memory_i = t15_2_DWork.Memory_PreviousInput_d;

  /* Logic: '<S29>/Logical Operator' */
  t15_2_B.LogicalOperator_b = ((t15_2_B.RelationalOperator1_a != 0.0) ||
    (t15_2_B.Memory_i != 0.0));

  /* Switch: '<S20>/3' */
  if (t15_2_B.DataStoreRead1_m >= t15_2_P._Threshold_i) {
    /* DataStoreRead: '<S20>/Data Store Read2' */
    t15_2_B.DataStoreRead2_e = t15_2_DWork.tdiv;

    /* RelationalOperator: '<S20>/Relational Operator' */
    t15_2_B.RelationalOperator_h = (t15_2_B.Times >= t15_2_B.DataStoreRead2_e);
    t15_2_B.u_bg = t15_2_B.RelationalOperator_h;
  } else {
    t15_2_B.u_bg = t15_2_B.LogicalOperator_b;
  }

  /* End of Switch: '<S20>/3' */

  /* Switch: '<S20>/2' incorporates:
   *  Constant: '<S16>/Constant4'
   */
  if (t15_2_B.u_bg >= t15_2_P._Threshold_o) {
    for (i = 0; i < 6; i++) {
      t15_2_B.u_m[i] = t15_2_B.e2_f[i];
    }

    t15_2_B.u_m[6] = t15_2_P.Constant4_Value_c;
    t15_2_B.u_m[7] = t15_2_B.Add1_p;
    t15_2_B.u_m[8] = t15_2_B.Add3_i;
    t15_2_B.u_m[9] = t15_2_B.Add1_n;
    t15_2_B.u_m[10] = t15_2_B.Add2_h;
    t15_2_B.u_m[11] = t15_2_B.Add4_a;
    t15_2_B.u_m[12] = t15_2_B.Add5_h;
    t15_2_B.u_m[13] = t15_2_B.Add6_n;
    t15_2_B.u_m[14] = t15_2_B.Add7;
    t15_2_B.u_m[15] = t15_2_B.Add8;
    t15_2_B.u_m[16] = t15_2_B.Add9;
    t15_2_B.u_m[17] = t15_2_B.Add10;
    t15_2_B.u_m[18] = t15_2_B.Add11;
    t15_2_B.u_m[19] = t15_2_P.Constant4_Value_c;
  } else {
    /* DataStoreRead: '<S24>/Elong Read' */
    memcpy(&t15_2_B.ElongRead[0], &t15_2_DWork.Elong[0], 100U * sizeof(real_T));
    for (i = 0; i < 50; i++) {
      /* Selector: '<S24>/Selector' */
      t15_2_B.Selector_n[i] = t15_2_B.ElongRead[(i << 1) + 1];

      /* Selector: '<S24>/Selector1' */
      t15_2_B.Selector1_cb[i] = t15_2_B.ElongRead[i << 1];
    }

    /* Dynamic Look-Up Table Block: '<S24>/elong'
     * Input0  Data Type:  Floating Point real_T
     * Input1  Data Type:  Floating Point real_T
     * Input2  Data Type:  Floating Point real_T
     * Output0 Data Type:  Floating Point real_T
     * Lookup Method: Linear_Endpoint
     *
     */
    LookUp_real_T_real_T( &(t15_2_B.elong), &t15_2_B.Selector_n[0],
                         t15_2_B.Times, &t15_2_B.Selector1_cb[0], 49U);

    /* Sum: '<S16>/Add2' incorporates:
     *  Inport: '<Root>/In1'
     */
    t15_2_B.Add2_a = t15_2_U.In1[2] - t15_2_B.elong;
    t15_2_B.u_m[0] = t15_2_B.Add2_a;
    t15_2_B.u_m[1] = t15_2_P.Constant4_Value_c;
    t15_2_B.u_m[2] = t15_2_B.e2_f[2];
    t15_2_B.u_m[3] = t15_2_B.e2_f[3];
    t15_2_B.u_m[4] = t15_2_B.e2_f[4];
    t15_2_B.u_m[5] = t15_2_B.e2_f[5];
    t15_2_B.u_m[6] = t15_2_P.Constant4_Value_c;
    t15_2_B.u_m[7] = t15_2_B.Add1_p;
    t15_2_B.u_m[8] = t15_2_B.Add3_i;
    t15_2_B.u_m[9] = t15_2_B.Add1_n;
    t15_2_B.u_m[10] = t15_2_B.Add2_h;
    t15_2_B.u_m[11] = t15_2_B.Add4_a;
    t15_2_B.u_m[12] = t15_2_B.Add5_h;
    t15_2_B.u_m[13] = t15_2_B.Add6_n;
    t15_2_B.u_m[14] = t15_2_B.Add7;
    t15_2_B.u_m[15] = t15_2_B.Add8;
    t15_2_B.u_m[16] = t15_2_B.Add9;
    t15_2_B.u_m[17] = t15_2_B.Add10;
    t15_2_B.u_m[18] = t15_2_B.Add11;
    t15_2_B.u_m[19] = t15_2_P.Constant4_Value_c;
  }

  /* End of Switch: '<S20>/2' */

  /* UnitDelay: '<S33>/UD' */
  t15_2_B.Uk1 = t15_2_DWork.UD_DSTATE;

  /* Sum: '<S33>/Diff' incorporates:
   *  Inport: '<Root>/In1'
   */
  t15_2_B.Diff = t15_2_U.In1[0] - t15_2_B.Uk1;

  /* UnitDelay: '<S34>/UD' */
  t15_2_B.Uk1_g = t15_2_DWork.UD_DSTATE_o;

  /* Sum: '<S34>/Diff' */
  t15_2_B.Diff_i = t15_2_B.Times - t15_2_B.Uk1_g;

  /* Product: '<S23>/Divide' */
  t15_2_B.Divide = t15_2_B.Diff / t15_2_B.Diff_i;

  /* DataStoreRead: '<S27>/Data Store Read2' */
  t15_2_B.DataStoreRead2_h = t15_2_DWork.Ip_rd;

  /* Abs: '<S27>/Abs' */
  t15_2_B.Abs_o = fabs(t15_2_B.DataStoreRead2_h);

  /* RelationalOperator: '<S27>/Relational Operator2' */
  t15_2_B.RelationalOperator2_a3 = (t15_2_B.e6 <= t15_2_B.Abs_o);

  /* RelationalOperator: '<S58>/Compare' incorporates:
   *  Constant: '<S58>/Constant'
   */
  t15_2_B.Compare_i = (t15_2_B.u_b < t15_2_P.Constant_Value_m);

  /* Logic: '<S27>/Logical Operator1' */
  t15_2_B.LogicalOperator1 = (t15_2_B.RelationalOperator2_a3 &&
    t15_2_B.Compare_i);

  /* Memory: '<S60>/Memory' */
  t15_2_B.Memory_g = t15_2_DWork.Memory_PreviousInput_o;

  /* Logic: '<S60>/Logical Operator' */
  t15_2_B.LogicalOperator_e = ((t15_2_B.LogicalOperator1 != 0.0) ||
    (t15_2_B.Memory_g != 0.0));

  /* Memory: '<S27>/Memory1' */
  t15_2_B.Memory1_b = t15_2_DWork.Memory1_PreviousInput_kq;

  /* Logic: '<S27>/Logical Operator' */
  t15_2_B.LogicalOperator_i = !((t15_2_B.LogicalOperator_e != 0.0) &&
    (t15_2_B.Memory1_b != 0.0));

  /* If: '<S27>/If ' */
  if ((t15_2_B.LogicalOperator_e >= 1.0) && (t15_2_B.LogicalOperator_i >= 1.0))
  {
    /* Outputs for IfAction SubSystem: '<S27>/If Action Subsystem2' incorporates:
     *  ActionPort: '<S59>/Action Port'
     */
    /* DataStoreWrite: '<S59>/Data Store Write2' */
    t15_2_DWork.trd = t15_2_B.Times;

    /* End of Outputs for SubSystem: '<S27>/If Action Subsystem2' */
  }

  /* End of If: '<S27>/If ' */

  /* DataStoreRead: '<S63>/Data Store Read' */
  t15_2_B.DataStoreRead_h = t15_2_DWork.RupRd[2];

  /* Abs: '<S63>/Abs' */
  t15_2_B.Abs_j = fabs(t15_2_B.DataStoreRead_h);

  /* RelationalOperator: '<S63>/Relational Operator' */
  t15_2_B.RelationalOperator_b = (t15_2_B.e6 < t15_2_B.Abs_j);

  /* RelationalOperator: '<S61>/Compare' incorporates:
   *  Constant: '<S61>/Constant'
   */
  t15_2_B.Compare_k = (t15_2_B.u_b < t15_2_P.Constant_Value_b);

  /* Logic: '<S28>/Logical Operator2' */
  t15_2_B.LogicalOperator2 = (t15_2_B.RelationalOperator_b && t15_2_B.Compare_k);

  /* Memory: '<S64>/Memory' */
  t15_2_B.Memory_p = t15_2_DWork.Memory_PreviousInput_f;

  /* Logic: '<S64>/Logical Operator' */
  t15_2_B.LogicalOperator_k = ((t15_2_B.LogicalOperator2 != 0.0) ||
    (t15_2_B.Memory_p != 0.0));

  /* Memory: '<S28>/Memory1' */
  t15_2_B.Memory1_jw = t15_2_DWork.Memory1_PreviousInput_j;

  /* Logic: '<S28>/Logical Operator' */
  t15_2_B.LogicalOperator_g = !((t15_2_B.LogicalOperator_k != 0.0) &&
    (t15_2_B.Memory1_jw != 0.0));

  /* If: '<S28>/If ' */
  if ((t15_2_B.LogicalOperator_k >= 1.0) && (t15_2_B.LogicalOperator_g >= 1.0))
  {
    /* Outputs for IfAction SubSystem: '<S28>/If Action Subsystem2' incorporates:
     *  ActionPort: '<S62>/Action Port'
     */
    /* DataStoreWrite: '<S62>/Data Store Write2' */
    t15_2_DWork.tterm = t15_2_B.Times;

    /* End of Outputs for SubSystem: '<S28>/If Action Subsystem2' */
  }

  /* End of If: '<S28>/If ' */

  /* Memory: '<S30>/Memory1' */
  t15_2_B.Memory1_p = t15_2_DWork.Memory1_PreviousInput_m;

  /* Logic: '<S30>/Logical Operator' */
  t15_2_B.LogicalOperator_f = !((t15_2_B.LogicalOperator_b != 0.0) &&
    (t15_2_B.Memory1_p != 0.0));

  /* If: '<S30>/u1<0 & u2 >=1 & u3>=1 ' */
  if ((t15_2_B.DataStoreRead1_m < 0.0) && (t15_2_B.LogicalOperator_b >= 1.0) &&
      (t15_2_B.LogicalOperator_f >= 1.0)) {
    /* Outputs for IfAction SubSystem: '<S30>/If Action ' incorporates:
     *  ActionPort: '<S31>/Action Port'
     */
    /* DataStoreWrite: '<S31>/Data Store Write19' */
    t15_2_DWork.tdiv = t15_2_B.Times;

    /* End of Outputs for SubSystem: '<S30>/If Action ' */
  }

  /* End of If: '<S30>/u1<0 & u2 >=1 & u3>=1 ' */

  /* Memory: '<S110>/Memory2' */
  memcpy(&t15_2_B.Memory2_d[0], &t15_2_DWork.Memory2_PreviousInput_kw[0], 11U *
         sizeof(real_T));

  /* DataStoreRead: '<S110>/Data Store Read1' */
  t15_2_B.DataStoreRead1_l0 = t15_2_DWork.tdiv;

  /* RelationalOperator: '<S110>/Relational Operator1' */
  t15_2_B.RelationalOperator1_n = (t15_2_B.Times >= t15_2_B.DataStoreRead1_l0);

  /* DataStoreRead: '<S109>/Data Store Read' */
  t15_2_B.DataStoreRead_f = t15_2_DWork.tcont2;

  /* RelationalOperator: '<S109>/Relational Operator' */
  t15_2_B.RelationalOperator_f = (t15_2_B.Times > t15_2_B.DataStoreRead_f);

  /* Product: '<S109>/Divide12' */
  for (i = 0; i < 20; i++) {
    t15_2_B.Divide12_k[i] = t15_2_B.u_m[i] * t15_2_B.RelationalOperator_f;
  }

  /* End of Product: '<S109>/Divide12' */

  /* Level2 S-Function Block: '<S107>/S-Function' (contr_lim) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[17];
    sfcnOutputs(rts, 0);
  }

  for (i = 0; i < 11; i++) {
    /* DataStoreRead: '<S96>/Data Store Read2' */
    t15_2_B.DataStoreRead2_a[i] = t15_2_DWork.ntur[i];

    /* Product: '<S96>/Divide1' */
    t15_2_B.Divide1_c5[i] = t15_2_B.u_m[i + 8] / t15_2_B.DataStoreRead2_a[i];

    /* Gain: '<S96>/1e6' */
    t15_2_B.e6_l[i] = t15_2_P.e6_Gain_o * t15_2_B.Divide1_c5[i];
  }

  /* Gain: '<S106>/Gain' */
  for (i = 0; i < 20; i++) {
    t15_2_B.Gain[i] = 0.0;
    for (i_0 = 0; i_0 < 11; i_0++) {
      t15_2_B.Gain[i] += t15_2_P.Gain_Gain_o[20 * i_0 + i] * t15_2_B.e6_l[i_0];
    }
  }

  /* End of Gain: '<S106>/Gain' */

  /* Level2 S-Function Block: '<S106>/S-Function' (contr_curr) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[18];
    sfcnOutputs(rts, 0);
  }

  /* Switch: '<S110>/ 1 ' */
  if (t15_2_B.RelationalOperator1_n >= t15_2_P.u_Threshold) {
    memcpy(&t15_2_B.u_bx[0], &t15_2_B.Memory2_d[0], 11U * sizeof(real_T));
  } else {
    /* DataStoreRead: '<S110>/Data Store Read' */
    t15_2_B.DataStoreRead_ky = t15_2_DWork.tcont2;

    /* RelationalOperator: '<S110>/Relational Operator' */
    t15_2_B.RelationalOperator_a = (t15_2_B.Times > t15_2_B.DataStoreRead_ky);

    /* Switch: '<S110>/1' */
    if (t15_2_B.RelationalOperator_a >= t15_2_P._Threshold) {
      /* DataStoreRead: '<S108>/Data Store Read1' */
      t15_2_B.DataStoreRead1_lt = t15_2_DWork.dtcont2;

      /* DataStoreRead: '<S108>/Data Store Read' */
      t15_2_B.DataStoreRead_c = t15_2_DWork.tcont2;

      /* Sum: '<S108>/Subtract3' */
      t15_2_B.Subtract3_c = t15_2_B.Times - t15_2_B.DataStoreRead_c;

      /* Product: '<S108>/Divide2' */
      t15_2_B.Divide2_nx = t15_2_B.Subtract3_c / t15_2_B.DataStoreRead1_lt;

      /* Saturate: '<S108>/Saturation1' */
      u = t15_2_B.Divide2_nx;
      tmin = t15_2_P.Saturation1_LowerSat;
      u_0 = t15_2_P.Saturation1_UpperSat;
      if (u >= u_0) {
        t15_2_B.Saturation1_i = u_0;
      } else if (u <= tmin) {
        t15_2_B.Saturation1_i = tmin;
      } else {
        t15_2_B.Saturation1_i = u;
      }

      /* End of Saturate: '<S108>/Saturation1' */

      /* Gain: '<S96>/1//15' */
      t15_2_B.u5_p = t15_2_P.u5_Gain_k * t15_2_B.e6;

      /* DataStoreRead: '<S96>/Data Store Read1' */
      t15_2_B.DataStoreRead1_bd = t15_2_DWork.k_g4;

      /* Product: '<S96>/Divide 1' */
      t15_2_B.Divide1_oh = t15_2_B.DataStoreRead1_bd * t15_2_B.u5_p;

      /* Product: '<S96>/Divide ' */
      for (i = 0; i < 11; i++) {
        t15_2_B.Divide_d[i] = t15_2_B.Divide1_oh * t15_2_B.SFunction[i] *
          t15_2_B.Saturation1_i;
        t15_2_B.u_c[i] = t15_2_B.Divide_d[i];
      }

      /* End of Product: '<S96>/Divide ' */
    } else {
      /* Product: '<S96>/Divide2' */
      for (i = 0; i < 11; i++) {
        t15_2_B.Divide2_m[i] = t15_2_B.SFunction_m[i] /
          t15_2_B.DataStoreRead2_a[i];
        t15_2_B.u_c[i] = t15_2_B.Divide2_m[i];
      }

      /* End of Product: '<S96>/Divide2' */
    }

    /* End of Switch: '<S110>/1' */
    memcpy(&t15_2_B.u_bx[0], &t15_2_B.u_c[0], 11U * sizeof(real_T));
  }

  /* End of Switch: '<S110>/ 1 ' */

  /* DataStoreRead: '<S92>/Data Store Read' */
  t15_2_B.DataStoreRead_k = t15_2_DWork.ref_ramp;

  /* Memory: '<S92>/Memory3' */
  t15_2_B.Memory3 = t15_2_DWork.Memory3_PreviousInput;

  /* DataStoreRead: '<S92>/Data Store Read1' */
  t15_2_B.DataStoreRead1_n = t15_2_DWork.tdiv;

  /* RelationalOperator: '<S92>/Relational Operator1' */
  t15_2_B.RelationalOperator1_p = (t15_2_B.Times >= t15_2_B.DataStoreRead1_n);

  /* Switch: '<S92>/switch1 ' */
  if (t15_2_B.RelationalOperator1_p >= t15_2_P.switch1_Threshold_j) {
    t15_2_B.switch1_b = t15_2_B.Memory3;
  } else {
    t15_2_B.switch1_b = t15_2_B.Times;
  }

  /* End of Switch: '<S92>/switch1 ' */

  /* Sum: '<S92>/Subtract2' */
  t15_2_B.Subtract2 = t15_2_B.switch1_b - t15_2_B.Times;

  /* Product: '<S92>/Divide1' */
  t15_2_B.Divide1_i = 1.0 / t15_2_B.DataStoreRead_k * t15_2_B.Subtract2;

  /* Sum: '<S92>/Subtract1' incorporates:
   *  Constant: '<S92>/1'
   */
  t15_2_B.Subtract1 = t15_2_B.Divide1_i + t15_2_P._Value_a;

  /* Saturate: '<S92>/Saturation1' */
  u = t15_2_B.Subtract1;
  tmin = t15_2_P.Saturation1_LowerSat_e;
  u_0 = t15_2_P.Saturation1_UpperSat_a;
  if (u >= u_0) {
    t15_2_B.Saturation1 = u_0;
  } else if (u <= tmin) {
    t15_2_B.Saturation1 = tmin;
  } else {
    t15_2_B.Saturation1 = u;
  }

  /* End of Saturate: '<S92>/Saturation1' */

  /* DataStoreRead: '<S100>/Data Store Read' */
  t15_2_B.DataStoreRead_kw = t15_2_DWork.tterm;

  /* RelationalOperator: '<S100>/Relational Operator' */
  t15_2_B.RelationalOperator_l = (t15_2_B.Times >= t15_2_B.DataStoreRead_kw);
  for (i = 0; i < 11; i++) {
    /* Product: '<S68>/Divide14' */
    t15_2_B.Divide14[i] = t15_2_B.u_bx[i] * t15_2_B.Saturation1;

    /* Memory: '<S100>/Memory1' */
    t15_2_B.Memory1_ps[i] = t15_2_DWork.Memory1_PreviousInput_b[i];

    /* Memory: '<S104>/Memory' */
    t15_2_B.Memory_k[i] = t15_2_DWork.Memory_PreviousInput_h[i];
  }

  /* DataStoreRead: '<S104>/Data Store Read2' */
  t15_2_B.DataStoreRead2_k = t15_2_DWork.trd;

  /* RelationalOperator: '<S104>/Relational Operator2' */
  t15_2_B.RelationalOperator2 = (t15_2_B.Times >= t15_2_B.DataStoreRead2_k);

  /* DataStoreRead: '<S105>/Data Store Read2' */
  t15_2_B.DataStoreRead2_o = t15_2_DWork.tdiv;

  /* RelationalOperator: '<S105>/Relational Operator1' */
  t15_2_B.RelationalOperator1_e = (t15_2_B.Times >= t15_2_B.DataStoreRead2_o);

  /* Product: '<S94>/Divide2' */
  for (i = 0; i < 20; i++) {
    t15_2_B.Divide2[i] = t15_2_B.RelationalOperator1_e * t15_2_B.u_m[i];
  }

  /* End of Product: '<S94>/Divide2' */

  /* Level2 S-Function Block: '<S103>/S-Function' (contr_div) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[19];
    sfcnOutputs(rts, 0);
  }

  /* Memory: '<S113>/Memory1' */
  t15_2_B.Memory1_p5 = t15_2_DWork.Memory1_PreviousInput_o;

  /* Switch: '<S113>/c_eob' */
  if (t15_2_B.u_b >= t15_2_P.c_eob_Threshold_hy) {
    t15_2_B.c_eob_a = t15_2_B.e6;
  } else {
    t15_2_B.c_eob_a = t15_2_B.Memory1_p5;
  }

  /* End of Switch: '<S113>/c_eob' */

  /* Switch: '<S99>/c_eob' */
  if (t15_2_B.u_b >= t15_2_P.c_eob_Threshold_o3) {
    /* DataStoreRead: '<S99>/Data Store Read2' */
    t15_2_B.DataStoreRead2_hu = t15_2_DWork.c_a_tpl2;

    /* Gain: '<S99>/ 1//15 ' */
    t15_2_B.u15 = t15_2_P.u15_Gain_g * t15_2_B.DataStoreRead2_hu;

    /* Product: '<S99>/Divide9' */
    t15_2_B.Divide9 = t15_2_B.u15 * t15_2_B.e6;

    /* Saturate: '<S99>/Saturation' */
    u = t15_2_B.Divide9;
    tmin = t15_2_P.Saturation_LowerSat;
    u_0 = t15_2_P.Saturation_UpperSat;
    if (u >= u_0) {
      t15_2_B.Saturation_m = u_0;
    } else if (u <= tmin) {
      t15_2_B.Saturation_m = tmin;
    } else {
      t15_2_B.Saturation_m = u;
    }

    /* End of Saturate: '<S99>/Saturation' */
    t15_2_B.c_eob_ay = t15_2_B.Saturation_m;
  } else {
    /* DataStoreRead: '<S113>/Data Store Read2' */
    t15_2_B.DataStoreRead2_g = t15_2_DWork.y0;

    /* Sum: '<S113>/Sum3' incorporates:
     *  Constant: '<S113>/2'
     */
    t15_2_B.Sum3_n = t15_2_P._Value_h - t15_2_B.DataStoreRead2_g;

    /* DataStoreRead: '<S113>/Data Store Read4' */
    t15_2_B.DataStoreRead4 = t15_2_DWork.c2_y0;

    /* DataStoreRead: '<S113>/Data Store Read3' */
    t15_2_B.DataStoreRead3_o = t15_2_DWork.c1_y0;

    /* Sum: '<S113>/Sum2' */
    t15_2_B.Sum2_bk = t15_2_B.DataStoreRead4 - t15_2_B.DataStoreRead3_o;

    /* Product: '<S113>/Divide1' */
    t15_2_B.Divide1_gf = 1.0 / t15_2_B.Sum2_bk * t15_2_B.Sum3_n;

    /* Product: '<S113>/Divide6' */
    t15_2_B.Divide6_n = t15_2_B.c_eob_a * t15_2_B.u_b;

    /* Sum: '<S113>/Sum' */
    t15_2_B.Sum = t15_2_B.Divide6_n - t15_2_B.DataStoreRead3_o;

    /* Product: '<S113>/Divide2' */
    t15_2_B.Divide2_f = t15_2_B.Sum * t15_2_B.Divide1_gf;

    /* Sum: '<S113>/Sum1' */
    t15_2_B.Sum1_f = t15_2_B.Divide2_f + t15_2_B.DataStoreRead2_g;

    /* RelationalOperator: '<S114>/LowerRelop1' incorporates:
     *  Constant: '<S113>/1'
     */
    t15_2_B.LowerRelop1_cl = (t15_2_B.Sum1_f > t15_2_P._Value_i);

    /* Switch: '<S114>/Switch2' incorporates:
     *  Constant: '<S113>/1'
     */
    if (t15_2_B.LowerRelop1_cl) {
      t15_2_B.Switch2_j1 = t15_2_P._Value_i;
    } else {
      /* RelationalOperator: '<S114>/UpperRelop' */
      t15_2_B.UpperRelop_g = (t15_2_B.Sum1_f < t15_2_B.DataStoreRead2_g);

      /* Switch: '<S114>/Switch' */
      if (t15_2_B.UpperRelop_g) {
        t15_2_B.Switch_o = t15_2_B.DataStoreRead2_g;
      } else {
        t15_2_B.Switch_o = t15_2_B.Sum1_f;
      }

      /* End of Switch: '<S114>/Switch' */
      t15_2_B.Switch2_j1 = t15_2_B.Switch_o;
    }

    /* End of Switch: '<S114>/Switch2' */
    t15_2_B.c_eob_ay = t15_2_B.Switch2_j1;
  }

  for (i = 0; i < 11; i++) {
    /* Switch: '<S104>/1' */
    if (t15_2_B.RelationalOperator2 >= t15_2_P._Threshold_f) {
      t15_2_B.u_g[i] = t15_2_B.Memory_k[i];
    } else {
      /* Product: '<S94>/Divide' */
      t15_2_B.Divide_np[i] = t15_2_B.SFunction_g[i] * t15_2_B.c_eob_ay;
      t15_2_B.u_g[i] = t15_2_B.Divide_np[i];
    }

    /* End of Switch: '<S104>/1' */
  }

  /* End of Switch: '<S99>/c_eob' */

  /* Memory: '<S98>/Memory1' */
  t15_2_B.Memory1_h0 = t15_2_DWork.Memory1_PreviousInput_p;

  /* DataStoreRead: '<S98>/Data Store Read2' */
  t15_2_B.DataStoreRead2_j = t15_2_DWork.trd;

  /* RelationalOperator: '<S98>/Relational Operator2' */
  t15_2_B.RelationalOperator2_a = (t15_2_B.Times >= t15_2_B.DataStoreRead2_j);

  /* Switch: '<S98>/switch1' */
  if (t15_2_B.RelationalOperator2_a >= t15_2_P.switch1_Threshold_m) {
    t15_2_B.switch1_g = t15_2_B.Memory1_h0;
  } else {
    t15_2_B.switch1_g = t15_2_B.Times;
  }

  /* End of Switch: '<S98>/switch1' */

  /* DataStoreRead: '<S102>/Data Store Read2' */
  t15_2_B.DataStoreRead2_d = t15_2_DWork.trd;

  /* RelationalOperator: '<S102>/Relational Operator2' */
  t15_2_B.RelationalOperator2_p = (t15_2_B.Times >= t15_2_B.DataStoreRead2_d);

  /* Product: '<S93>/Divide4' */
  for (i = 0; i < 20; i++) {
    t15_2_B.Divide4[i] = t15_2_B.RelationalOperator2_p * t15_2_B.u_m[i];
  }

  /* End of Product: '<S93>/Divide4' */

  /* Level2 S-Function Block: '<S101>/S-Function' (contr_div) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[20];
    sfcnOutputs(rts, 0);
  }

  /* Switch: '<S100>/1' */
  if (t15_2_B.RelationalOperator_l) {
    memcpy(&t15_2_B.u_gg[0], &t15_2_B.Memory1_ps[0], 11U * sizeof(real_T));
  } else {
    /* Sum: '<S98>/Subtract2' */
    t15_2_B.Subtract2_g = t15_2_B.switch1_g - t15_2_B.Times;

    /* DataStoreRead: '<S98>/Data Store Read1' */
    t15_2_B.DataStoreRead1_c = t15_2_DWork.ref_ramp;

    /* Product: '<S98>/Divide4' */
    t15_2_B.Divide4_ii = 1.0 / t15_2_B.DataStoreRead1_c * t15_2_B.Subtract2_g;

    /* Sum: '<S98>/Subtract3' incorporates:
     *  Constant: '<S98>/1'
     */
    t15_2_B.Subtract3_i = t15_2_B.Divide4_ii + t15_2_P._Value_m;

    /* Saturate: '<S98>/Saturation' */
    u = t15_2_B.Subtract3_i;
    tmin = t15_2_P.Saturation_LowerSat_b;
    u_0 = t15_2_P.Saturation_UpperSat_f;
    if (u >= u_0) {
      t15_2_B.Saturation_n = u_0;
    } else if (u <= tmin) {
      t15_2_B.Saturation_n = tmin;
    } else {
      t15_2_B.Saturation_n = u;
    }

    /* End of Saturate: '<S98>/Saturation' */

    /* Sum: '<S98>/Subtract1' incorporates:
     *  Constant: '<S98>/1'
     */
    t15_2_B.Subtract1_k = t15_2_P._Value_m - t15_2_B.Saturation_n;

    /* Sum: '<S92>/Subtract3' incorporates:
     *  Constant: '<S92>/1'
     */
    t15_2_B.Subtract3_ix = t15_2_P._Value_a - t15_2_B.Saturation1;
    for (i = 0; i < 11; i++) {
      /* Product: '<S93>/Divide3' */
      t15_2_B.Divide3_f[i] = t15_2_B.c_eob_ay * t15_2_B.SFunction_g3[i];

      /* Product: '<S68>/Divide5' */
      t15_2_B.Divide5_b[i] = t15_2_B.Subtract1_k * t15_2_B.Divide3_f[i];

      /* Product: '<S68>/Divide6' */
      t15_2_B.Divide6_e[i] = t15_2_B.Subtract3_ix * t15_2_B.u_g[i];

      /* Product: '<S68>/Divide1' */
      t15_2_B.Divide1_n2[i] = t15_2_B.Divide6_e[i] * t15_2_B.Saturation_n;

      /* Sum: '<S68>/Sum2' */
      t15_2_B.Sum2_d[i] = t15_2_B.Divide1_n2[i] + t15_2_B.Divide5_b[i];
      t15_2_B.u_gg[i] = t15_2_B.Sum2_d[i];
    }
  }

  /* End of Switch: '<S100>/1' */

  /* DataStoreRead: '<S95>/Data Store Read' */
  t15_2_B.DataStoreRead_k5 = t15_2_DWork.ref_ramp;

  /* Memory: '<S95>/Memory1' */
  t15_2_B.Memory1_ea = t15_2_DWork.Memory1_PreviousInput_hp;

  /* DataStoreRead: '<S95>/Data Store Read2' */
  t15_2_B.DataStoreRead2_i = t15_2_DWork.tterm;

  /* RelationalOperator: '<S95>/Relational Operator2' */
  t15_2_B.RelationalOperator2_j = (t15_2_B.Times >= t15_2_B.DataStoreRead2_i);

  /* Switch: '<S95>/1 ' */
  if (t15_2_B.RelationalOperator2_j >= t15_2_P._Threshold_fg) {
    t15_2_B.u_gv = t15_2_B.Memory1_ea;
  } else {
    t15_2_B.u_gv = t15_2_B.Times;
  }

  /* End of Switch: '<S95>/1 ' */

  /* Sum: '<S95>/Subtract2' */
  t15_2_B.Subtract2_o = t15_2_B.u_gv - t15_2_B.Times;

  /* Product: '<S95>/Divide4' */
  t15_2_B.Divide4_o = 1.0 / t15_2_B.DataStoreRead_k5 * t15_2_B.Subtract2_o;

  /* Sum: '<S95>/Subtract3' incorporates:
   *  Constant: '<S95>/1'
   */
  t15_2_B.Subtract3 = t15_2_B.Divide4_o + t15_2_P._Value_e;

  /* Saturate: '<S95>/Saturation' */
  u = t15_2_B.Subtract3;
  tmin = t15_2_P.Saturation_LowerSat_o;
  u_0 = t15_2_P.Saturation_UpperSat_m;
  if (u >= u_0) {
    t15_2_B.Saturation = u_0;
  } else if (u <= tmin) {
    t15_2_B.Saturation = tmin;
  } else {
    t15_2_B.Saturation = u;
  }

  /* End of Saturate: '<S95>/Saturation' */

  /* Product: '<S68>/Divide4' */
  for (i = 0; i < 11; i++) {
    t15_2_B.Divide4_i[i] = t15_2_B.u_gg[i] * t15_2_B.Saturation;
  }

  /* End of Product: '<S68>/Divide4' */

  /* Sum: '<S95>/Subtract1' incorporates:
   *  Constant: '<S95>/1'
   */
  t15_2_B.Subtract1_i = t15_2_P._Value_e - t15_2_B.Saturation;

  /* DataStoreRead: '<S112>/Data Store Read2' */
  t15_2_B.DataStoreRead2_ac = t15_2_DWork.tterm;

  /* RelationalOperator: '<S112>/Relational Operator2' */
  t15_2_B.RelationalOperator2_p5 = (t15_2_B.Times >= t15_2_B.DataStoreRead2_ac);
  for (i = 0; i < 20; i++) {
    /* Gain: '<S97>/ G_curr_term 1' */
    t15_2_B.G_curr_term1[i] = 0.0;
    for (i_0 = 0; i_0 < 11; i_0++) {
      t15_2_B.G_curr_term1[i] += t15_2_P.G_curr_term1_Gain[20 * i_0 + i] *
        t15_2_B.e6_n[i_0];
    }

    /* End of Gain: '<S97>/ G_curr_term 1' */

    /* Product: '<S97>/Divide12' */
    t15_2_B.Divide12_b[i] = t15_2_B.G_curr_term1[i] *
      t15_2_B.RelationalOperator2_p5;
  }

  /* Level2 S-Function Block: '<S111>/S-Function' (contr_curr) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[21];
    sfcnOutputs(rts, 0);
  }

  /* Product: '<S68>/Divide2' */
  for (i = 0; i < 11; i++) {
    t15_2_B.Divide2_n[i] = t15_2_B.Subtract1_i * t15_2_B.SFunction_a[i];
  }

  for (i = 0; i < 500; i++) {
    /* DataStoreRead: '<S116>/volt1 Read' */
    t15_2_B.volt1Read[i] = t15_2_DWork.volt[20 * i];

    /* Gain: '<S116>/0.001' */
    t15_2_B.u01[i] = t15_2_P.u01_Gain * t15_2_B.volt1Read[i];

    /* DataStoreRead: '<S116>/volt2 Read' */
    t15_2_B.volt2Read[i] = t15_2_DWork.volt[20 * i + 1];

    /* DataStoreRead: '<S119>/volt1 Read' */
    t15_2_B.volt1Read_i[i] = t15_2_DWork.volt[20 * i];

    /* Gain: '<S119>/0.001' */
    t15_2_B.u01_j[i] = t15_2_P.u01_Gain_o * t15_2_B.volt1Read_i[i];

    /* DataStoreRead: '<S119>/volt3 Read' */
    t15_2_B.volt3Read[i] = t15_2_DWork.volt[20 * i + 2];

    /* DataStoreRead: '<S120>/volt1 Read' */
    t15_2_B.volt1Read_c[i] = t15_2_DWork.volt[20 * i];

    /* Gain: '<S120>/0.001' */
    t15_2_B.u01_n[i] = t15_2_P.u01_Gain_o2 * t15_2_B.volt1Read_c[i];

    /* DataStoreRead: '<S120>/volt4 Read' */
    t15_2_B.volt4Read[i] = t15_2_DWork.volt[20 * i + 3];

    /* DataStoreRead: '<S121>/volt1 Read' */
    t15_2_B.volt1Read_k[i] = t15_2_DWork.volt[20 * i];

    /* Gain: '<S121>/0.001' */
    t15_2_B.u01_b[i] = t15_2_P.u01_Gain_n * t15_2_B.volt1Read_k[i];

    /* DataStoreRead: '<S121>/volt5 Read' */
    t15_2_B.volt5Read[i] = t15_2_DWork.volt[20 * i + 4];

    /* DataStoreRead: '<S122>/volt1 Read' */
    t15_2_B.volt1Read_h[i] = t15_2_DWork.volt[20 * i];

    /* Gain: '<S122>/0.001' */
    t15_2_B.u01_f[i] = t15_2_P.u01_Gain_j * t15_2_B.volt1Read_h[i];

    /* DataStoreRead: '<S122>/volt6 Read' */
    t15_2_B.volt6Read[i] = t15_2_DWork.volt[20 * i + 5];

    /* DataStoreRead: '<S123>/volt1 Read' */
    t15_2_B.volt1Read_b[i] = t15_2_DWork.volt[20 * i];

    /* Gain: '<S123>/0.001' */
    t15_2_B.u01_b0[i] = t15_2_P.u01_Gain_d * t15_2_B.volt1Read_b[i];

    /* DataStoreRead: '<S123>/volt7 Read' */
    t15_2_B.volt7Read[i] = t15_2_DWork.volt[20 * i + 6];

    /* DataStoreRead: '<S124>/volt1 Read' */
    t15_2_B.volt1Read_f[i] = t15_2_DWork.volt[20 * i];

    /* Gain: '<S124>/0.001' */
    t15_2_B.u01_jr[i] = t15_2_P.u01_Gain_m * t15_2_B.volt1Read_f[i];

    /* DataStoreRead: '<S124>/volt8 Read' */
    t15_2_B.volt8Read[i] = t15_2_DWork.volt[20 * i + 7];

    /* DataStoreRead: '<S125>/volt1 Read' */
    t15_2_B.volt1Read_m[i] = t15_2_DWork.volt[20 * i];

    /* Gain: '<S125>/0.001' */
    t15_2_B.u01_m[i] = t15_2_P.u01_Gain_i * t15_2_B.volt1Read_m[i];

    /* DataStoreRead: '<S125>/volt9 Read' */
    t15_2_B.volt9Read[i] = t15_2_DWork.volt[20 * i + 8];

    /* DataStoreRead: '<S126>/volt1 Read' */
    t15_2_B.volt1Read_b3[i] = t15_2_DWork.volt[20 * i];

    /* Gain: '<S126>/0.001' */
    t15_2_B.u01_bv[i] = t15_2_P.u01_Gain_f * t15_2_B.volt1Read_b3[i];

    /* DataStoreRead: '<S126>/volt10 Read' */
    t15_2_B.volt10Read[i] = t15_2_DWork.volt[20 * i + 9];

    /* DataStoreRead: '<S117>/volt1 Read' */
    t15_2_B.volt1Read_o[i] = t15_2_DWork.volt[20 * i];

    /* Gain: '<S117>/0.001' */
    t15_2_B.u01_ft[i] = t15_2_P.u01_Gain_iy * t15_2_B.volt1Read_o[i];

    /* DataStoreRead: '<S117>/volt11 Read' */
    t15_2_B.volt11Read[i] = t15_2_DWork.volt[20 * i + 10];

    /* DataStoreRead: '<S118>/volt1 Read' */
    t15_2_B.volt1Read_ba[i] = t15_2_DWork.volt[20 * i];

    /* Gain: '<S118>/0.001' */
    t15_2_B.u01_bc[i] = t15_2_P.u01_Gain_os * t15_2_B.volt1Read_ba[i];

    /* DataStoreRead: '<S118>/volt12 Read' */
    t15_2_B.volt12Read[i] = t15_2_DWork.volt[20 * i + 11];
  }

  /* End of Product: '<S68>/Divide2' */
  /* Dynamic Look-Up Table Block: '<S116>/volt1'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(t15_2_B.volt1), &t15_2_B.volt2Read[0], t15_2_B.Times,
                       &t15_2_B.u01[0], 499U);

  /* Dynamic Look-Up Table Block: '<S119>/volt1'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(t15_2_B.volt1_p), &t15_2_B.volt3Read[0], t15_2_B.Times,
                       &t15_2_B.u01_j[0], 499U);

  /* Dynamic Look-Up Table Block: '<S120>/volt1'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(t15_2_B.volt1_i), &t15_2_B.volt4Read[0], t15_2_B.Times,
                       &t15_2_B.u01_n[0], 499U);

  /* Dynamic Look-Up Table Block: '<S121>/volt1'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(t15_2_B.volt1_k), &t15_2_B.volt5Read[0], t15_2_B.Times,
                       &t15_2_B.u01_b[0], 499U);

  /* Dynamic Look-Up Table Block: '<S122>/volt1'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(t15_2_B.volt1_pu), &t15_2_B.volt6Read[0],
                       t15_2_B.Times, &t15_2_B.u01_f[0], 499U);

  /* Dynamic Look-Up Table Block: '<S123>/volt1'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(t15_2_B.volt1_o), &t15_2_B.volt7Read[0], t15_2_B.Times,
                       &t15_2_B.u01_b0[0], 499U);

  /* Dynamic Look-Up Table Block: '<S124>/volt1'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(t15_2_B.volt1_f), &t15_2_B.volt8Read[0], t15_2_B.Times,
                       &t15_2_B.u01_jr[0], 499U);

  /* Dynamic Look-Up Table Block: '<S125>/volt1'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(t15_2_B.volt1_l), &t15_2_B.volt9Read[0], t15_2_B.Times,
                       &t15_2_B.u01_m[0], 499U);

  /* Dynamic Look-Up Table Block: '<S126>/volt1'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(t15_2_B.volt1_a), &t15_2_B.volt10Read[0],
                       t15_2_B.Times, &t15_2_B.u01_bv[0], 499U);

  /* Dynamic Look-Up Table Block: '<S117>/volt1'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(t15_2_B.volt1_d), &t15_2_B.volt11Read[0],
                       t15_2_B.Times, &t15_2_B.u01_ft[0], 499U);

  /* Dynamic Look-Up Table Block: '<S118>/volt1'
   * Input0  Data Type:  Floating Point real_T
   * Input1  Data Type:  Floating Point real_T
   * Input2  Data Type:  Floating Point real_T
   * Output0 Data Type:  Floating Point real_T
   * Lookup Method: Linear_Endpoint
   *
   */
  LookUp_real_T_real_T( &(t15_2_B.volt1_kr), &t15_2_B.volt12Read[0],
                       t15_2_B.Times, &t15_2_B.u01_bc[0], 499U);

  /* DataStoreRead: '<S115>/Data Store Read2' */
  t15_2_B.DataStoreRead2_aj = t15_2_DWork.tterm;

  /* RelationalOperator: '<S115>/Relational Operator2' */
  t15_2_B.RelationalOperator2_m = (t15_2_B.Times < t15_2_B.DataStoreRead2_aj);

  /* Product: '<S69>/Divide7' */
  t15_2_B.Divide7[0] = t15_2_B.volt1 * t15_2_B.RelationalOperator2_m;
  t15_2_B.Divide7[1] = t15_2_B.volt1_p * t15_2_B.RelationalOperator2_m;
  t15_2_B.Divide7[2] = t15_2_B.volt1_i * t15_2_B.RelationalOperator2_m;
  t15_2_B.Divide7[3] = t15_2_B.volt1_k * t15_2_B.RelationalOperator2_m;
  t15_2_B.Divide7[4] = t15_2_B.volt1_pu * t15_2_B.RelationalOperator2_m;
  t15_2_B.Divide7[5] = t15_2_B.volt1_o * t15_2_B.RelationalOperator2_m;
  t15_2_B.Divide7[6] = t15_2_B.volt1_f * t15_2_B.RelationalOperator2_m;
  t15_2_B.Divide7[7] = t15_2_B.volt1_l * t15_2_B.RelationalOperator2_m;
  t15_2_B.Divide7[8] = t15_2_B.volt1_a * t15_2_B.RelationalOperator2_m;
  t15_2_B.Divide7[9] = t15_2_B.volt1_d * t15_2_B.RelationalOperator2_m;
  t15_2_B.Divide7[10] = t15_2_B.volt1_kr * t15_2_B.RelationalOperator2_m;

  /* DataStoreRead: '<S65>/Data Store Read1' */
  t15_2_B.DataStoreRead1_g = t15_2_DWork.c_cur_max;
  for (i = 0; i < 11; i++) {
    /* Sum: '<S66>/Sum3' */
    t15_2_B.Sum3[i] = ((t15_2_B.Divide14[i] + t15_2_B.Divide4_i[i]) +
                       t15_2_B.Divide2_n[i]) + t15_2_B.Divide7[i];

    /* Product: '<S65>/Divide2' */
    t15_2_B.Divide2_l[i] = t15_2_B.Sum3[i] * t15_2_B.e6_n[i];

    /* RelationalOperator: '<S71>/Compare' incorporates:
     *  Constant: '<S71>/Constant'
     */
    t15_2_B.Compare[i] = (uint8_T)(t15_2_B.Divide2_l[i] <
      t15_2_P.Constant_Value_k);

    /* Gain: '<S65>/1e3' */
    t15_2_B.e3_p[i] = t15_2_P.e3_Gain_b * t15_2_B.e6_n[i];

    /* Abs: '<S65>/Abs' */
    t15_2_B.Abs_p[i] = fabs(t15_2_B.e3_p[i]);

    /* DataStoreRead: '<S17>/Data Store Read1' */
    t15_2_B.DataStoreRead1_a[i] = t15_2_DWork.Imax[i];

    /* DataStoreRead: '<S65>/Data Store Read2' */
    t15_2_B.DataStoreRead2_l[i] = t15_2_DWork.ntur[i];

    /* Product: '<S65>/Divide5' */
    t15_2_B.Divide5[i] = t15_2_B.DataStoreRead1_a[i] *
      t15_2_B.DataStoreRead2_l[i];

    /* Sum: '<S65>/Sum2' */
    t15_2_B.Sum2[i] = t15_2_B.Divide5[i] - t15_2_B.Abs_p[i];

    /* Product: '<S65>/Divide3' */
    t15_2_B.Divide3[i] = t15_2_B.Divide5[i] * t15_2_B.DataStoreRead1_g;

    /* Sum: '<S65>/Sum1' */
    t15_2_B.Sum1[i] = t15_2_B.Divide5[i] - t15_2_B.Divide3[i];

    /* Product: '<S65>/Divide4' */
    t15_2_B.Divide4_p[i] = t15_2_B.Sum2[i] / t15_2_B.Sum1[i];

    /* Product: '<S65>/Divide1' */
    t15_2_B.Divide1_ah[i] = t15_2_B.Divide4_p[i] * t15_2_B.Divide4_p[i] *
      t15_2_B.Divide4_p[i];

    /* Saturate: '<S65>/Saturation' */
    u = t15_2_B.Divide1_ah[i];
    tmin = t15_2_P.Saturation_LowerSat_p;
    u_0 = t15_2_P.Saturation_UpperSat_n;
    if (u >= u_0) {
      u = u_0;
    } else {
      if (u <= tmin) {
        u = tmin;
      }
    }

    t15_2_B.Saturation_b[i] = u;

    /* End of Saturate: '<S65>/Saturation' */

    /* RelationalOperator: '<S70>/Compare' incorporates:
     *  Constant: '<S70>/Constant'
     */
    t15_2_B.Compare_h[i] = (uint8_T)(t15_2_B.Saturation_b[i] <
      t15_2_P.Constant_Value_ir);

    /* Logic: '<S65>/Logical Operator' */
    t15_2_B.LogicalOperator_h[i] = ((t15_2_B.Compare[i] != 0) &&
      (t15_2_B.Compare_h[i] != 0));

    /* Switch: '<S65>/Switch' incorporates:
     *  Constant: '<S65>/1'
     */
    if (t15_2_B.LogicalOperator_h[i] >= t15_2_P.Switch_Threshold) {
      t15_2_B.Switch[i] = t15_2_P._Value_p;
    } else {
      t15_2_B.Switch[i] = t15_2_B.Saturation_b[i];
    }

    /* End of Switch: '<S65>/Switch' */

    /* Product: '<S65>/Divide6' */
    t15_2_B.Divide6_i[i] = t15_2_B.Sum3[i] * t15_2_B.Switch[i];
  }

  /* DataStoreRead: '<S89>/Data Store Read' */
  t15_2_B.DataStoreRead_l = t15_2_DWork.c_a_tpl1;

  /* Gain: '<S89>/1//15' */
  t15_2_B.u5 = t15_2_P.u5_Gain_g * t15_2_B.DataStoreRead_l;

  /* Product: '<S89>/Div' */
  t15_2_B.Div = t15_2_B.e6 * t15_2_B.u5;

  /* UniformRandomNumber: '<S73>/Uniform Random Number' */
  t15_2_B.UniformRandomNumber = t15_2_DWork.UniformRandomNumber_NextOutput;

  /* DataStoreRead: '<S77>/Data Store Read' */
  t15_2_B.DataStoreRead_m = t15_2_DWork.RupRd[5];

  /* Gain: '<S77>/1.75' */
  t15_2_B.u5_e = t15_2_P.u5_Gain_c * t15_2_B.DataStoreRead_m;

  /* Product: '<S77>/Divide11' */
  t15_2_B.Divide11 = t15_2_B.UniformRandomNumber * t15_2_B.u5_e;

  /* UnitDelay: '<S78>/UD' */
  t15_2_B.Uk1_h = t15_2_DWork.UD_DSTATE_a;

  /* Sum: '<S78>/Diff' */
  t15_2_B.Diff_p = t15_2_B.Times - t15_2_B.Uk1_h;

  /* Gain: '<S77>/2e3' */
  t15_2_B.e3_b = t15_2_P.e3_Gain_a * t15_2_B.Diff_p;

  /* Sqrt: '<S77>/Sqrt' */
  t15_2_B.Sqrt = sqrt(t15_2_B.e3_b);

  /* Product: '<S77>/Divide1' */
  t15_2_B.Divide1_no = t15_2_B.Divide11 / t15_2_B.Sqrt;

  /* Sum: '<S73>/Sum2' */
  t15_2_B.Sum2_c = t15_2_B.Divide1_no + t15_2_B.Divide;

  /* DataStoreRead: '<S76>/Data Store Read' */
  t15_2_B.DataStoreRead_j = t15_2_DWork.t_tran2D;

  /* RelationalOperator: '<S76>/Relational Operator1' */
  t15_2_B.RelationalOperator1_f = (t15_2_B.Times > t15_2_B.DataStoreRead_j);

  /* Product: '<S76>/Divide12' */
  t15_2_B.Divide12_g[0] = t15_2_B.Sum2_c * t15_2_B.RelationalOperator1_f;
  t15_2_B.Divide12_g[1] = t15_2_B.e6_n[11] * t15_2_B.RelationalOperator1_f;

  /* Gain: '<S88>/ eye(20,2)' */
  for (i = 0; i < 20; i++) {
    t15_2_B.eye202[i] = 0.0;
    t15_2_B.eye202[i] += t15_2_P.eye202_Gain[i] * t15_2_B.Divide12_g[0];
    t15_2_B.eye202[i] += t15_2_P.eye202_Gain[i + 20] * t15_2_B.Divide12_g[1];
  }

  /* End of Gain: '<S88>/ eye(20,2)' */

  /* Level2 S-Function Block: '<S88>/S-Function' (contr_vert_vs3) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[22];
    sfcnOutputs(rts, 0);
  }

  /* RelationalOperator: '<S79>/Compare' incorporates:
   *  Constant: '<S79>/Constant'
   */
  t15_2_B.Compare_n = (t15_2_B.u_b < t15_2_P.Constant_Value_kq);

  /* Product: '<S74>/Divide4' */
  t15_2_B.Divide4_b[0] = t15_2_B.Divide12_g[0] * (real_T)t15_2_B.Compare_n;
  t15_2_B.Divide4_b[1] = t15_2_B.Divide12_g[1] * (real_T)t15_2_B.Compare_n;

  /* Gain: '<S83>/ eye(20,2)' */
  for (i = 0; i < 20; i++) {
    t15_2_B.eye202_p[i] = 0.0;
    t15_2_B.eye202_p[i] += t15_2_P.eye202_Gain_n[i] * t15_2_B.Divide4_b[0];
    t15_2_B.eye202_p[i] += t15_2_P.eye202_Gain_n[i + 20] * t15_2_B.Divide4_b[1];
  }

  /* End of Gain: '<S83>/ eye(20,2)' */

  /* Level2 S-Function Block: '<S83>/S-Function' (contr_vert_vs3) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[23];
    sfcnOutputs(rts, 0);
  }

  /* Switch: '<S67>/c_eob1' */
  if (t15_2_B.u_b >= t15_2_P.c_eob1_Threshold_a) {
    /* DataStoreRead: '<S89>/Data Store Read1' */
    t15_2_B.DataStoreRead1_f = t15_2_DWork.tdiv;

    /* RelationalOperator: '<S89>/Relational Operator2' */
    t15_2_B.RelationalOperator2_a2 = (t15_2_B.Times >= t15_2_B.DataStoreRead1_f);

    /* Switch: '<S89>/Lim. Div. tr.' */
    if (t15_2_B.RelationalOperator2_a2 >= t15_2_P.LimDivtr_Threshold) {
      /* DataStoreRead: '<S89>/Data Store Read3' */
      t15_2_B.DataStoreRead3_a = t15_2_DWork.RupRd[3];

      /* RelationalOperator: '<S91>/LowerRelop1' */
      t15_2_B.LowerRelop1_m = (t15_2_B.Div > t15_2_B.DataStoreRead3_a);

      /* Switch: '<S91>/Switch2' */
      if (t15_2_B.LowerRelop1_m) {
        t15_2_B.Switch2_h = t15_2_B.DataStoreRead3_a;
      } else {
        /* RelationalOperator: '<S91>/UpperRelop' incorporates:
         *  Constant: '<S89>/1'
         */
        t15_2_B.UpperRelop_d = (t15_2_B.Div < t15_2_P._Value_aq);

        /* Switch: '<S91>/Switch' incorporates:
         *  Constant: '<S89>/1'
         */
        if (t15_2_B.UpperRelop_d) {
          t15_2_B.Switch_b = t15_2_P._Value_aq;
        } else {
          t15_2_B.Switch_b = t15_2_B.Div;
        }

        /* End of Switch: '<S91>/Switch' */
        t15_2_B.Switch2_h = t15_2_B.Switch_b;
      }

      /* End of Switch: '<S91>/Switch2' */
      t15_2_B.LimDivtr = t15_2_B.Switch2_h;
    } else {
      /* DataStoreRead: '<S89>/Data Store Read2' */
      t15_2_B.DataStoreRead2_jg = t15_2_DWork.max_VS_lim;

      /* RelationalOperator: '<S90>/LowerRelop1' */
      t15_2_B.LowerRelop1_g = (t15_2_B.Div > t15_2_B.DataStoreRead2_jg);

      /* Switch: '<S90>/Switch2' */
      if (t15_2_B.LowerRelop1_g) {
        t15_2_B.Switch2_p = t15_2_B.DataStoreRead2_jg;
      } else {
        /* RelationalOperator: '<S90>/UpperRelop' incorporates:
         *  Constant: '<S89>/1'
         */
        t15_2_B.UpperRelop_j = (t15_2_B.Div < t15_2_P._Value_aq);

        /* Switch: '<S90>/Switch' incorporates:
         *  Constant: '<S89>/1'
         */
        if (t15_2_B.UpperRelop_j) {
          t15_2_B.Switch_c = t15_2_P._Value_aq;
        } else {
          t15_2_B.Switch_c = t15_2_B.Div;
        }

        /* End of Switch: '<S90>/Switch' */
        t15_2_B.Switch2_p = t15_2_B.Switch_c;
      }

      /* End of Switch: '<S90>/Switch2' */
      t15_2_B.LimDivtr = t15_2_B.Switch2_p;
    }

    /* End of Switch: '<S89>/Lim. Div. tr.' */

    /* Product: '<S75>/Divide8' */
    t15_2_B.Divide8[0] = t15_2_B.LimDivtr * t15_2_B.SFunction_mf[1];
    t15_2_B.Divide8[1] = t15_2_B.LimDivtr * t15_2_B.SFunction_mf[0];
    t15_2_B.c_eob1_k[0] = t15_2_B.Divide8[0];
    t15_2_B.c_eob1_k[1] = t15_2_B.Divide8[1];
  } else {
    /* RelationalOperator: '<S86>/Compare' incorporates:
     *  Constant: '<S86>/Constant'
     */
    t15_2_B.Compare_p = (t15_2_B.u_b < t15_2_P.Constant_Value);

    /* DataStoreRead: '<S82>/Data Store Read1' */
    t15_2_B.DataStoreRead1_mp = t15_2_DWork.Ip_rd;

    /* RelationalOperator: '<S87>/Compare' incorporates:
     *  Constant: '<S87>/Constant'
     */
    t15_2_B.Compare_ha = (t15_2_B.DataStoreRead1_mp < t15_2_P.Constant_Value_i);

    /* Logic: '<S82>/Logical Operator1' */
    t15_2_B.LogicalOperator1_f = (t15_2_B.Compare_ha && t15_2_B.Compare_p);

    /* DataStoreRead: '<S82>/Data Store Read2' */
    t15_2_B.DataStoreRead2_h1 = t15_2_DWork.trd;

    /* RelationalOperator: '<S82>/Relational Operator1' */
    t15_2_B.RelationalOperator1_d = (t15_2_B.Times >= t15_2_B.DataStoreRead2_h1);

    /* Logic: '<S82>/Logical Operator2' */
    t15_2_B.LogicalOperator2_m = ((t15_2_B.RelationalOperator1_d != 0.0) ||
      (t15_2_B.LogicalOperator1_f != 0.0));

    /* Switch: '<S74>/Ip_rd ' */
    if (t15_2_B.LogicalOperator2_m >= t15_2_P.Ip_rd_Threshold) {
      /* DataStoreRead: '<S80>/Data Store Read' */
      t15_2_B.DataStoreRead_n = t15_2_DWork.c_a_tpl1_eob;

      /* Gain: '<S80>/ 1//15' */
      t15_2_B.u15_n = t15_2_P.u15_Gain * t15_2_B.DataStoreRead_n;

      /* Product: '<S80>/Divide6' */
      t15_2_B.Divide6_ey = t15_2_B.u15_n * t15_2_B.e6;

      /* RelationalOperator: '<S84>/LowerRelop1' incorporates:
       *  Constant: '<S80>/1'
       */
      t15_2_B.LowerRelop1_h3 = (t15_2_B.Divide6_ey > t15_2_P._Value_b);

      /* Switch: '<S84>/Switch2' incorporates:
       *  Constant: '<S80>/1'
       */
      if (t15_2_B.LowerRelop1_h3) {
        t15_2_B.Switch2_l = t15_2_P._Value_b;
      } else {
        /* DataStoreRead: '<S80>/Data Store Read3' */
        t15_2_B.DataStoreRead3_oz = t15_2_DWork.c_a_tpl_min;

        /* RelationalOperator: '<S84>/UpperRelop' */
        t15_2_B.UpperRelop_pt = (t15_2_B.Divide6_ey < t15_2_B.DataStoreRead3_oz);

        /* Switch: '<S84>/Switch' */
        if (t15_2_B.UpperRelop_pt) {
          t15_2_B.Switch_b3 = t15_2_B.DataStoreRead3_oz;
        } else {
          t15_2_B.Switch_b3 = t15_2_B.Divide6_ey;
        }

        /* End of Switch: '<S84>/Switch' */
        t15_2_B.Switch2_l = t15_2_B.Switch_b3;
      }

      /* End of Switch: '<S84>/Switch2' */
      t15_2_B.Ip_rd = t15_2_B.Switch2_l;
    } else {
      /* Gain: '<S81>/1//15' */
      t15_2_B.u5_b = t15_2_P.u5_Gain * t15_2_B.e6;

      /* RelationalOperator: '<S85>/LowerRelop1' incorporates:
       *  Constant: '<S81>/3'
       */
      t15_2_B.LowerRelop1_gc = (t15_2_B.u5_b > t15_2_P._Value);

      /* Switch: '<S85>/Switch2' incorporates:
       *  Constant: '<S81>/3'
       */
      if (t15_2_B.LowerRelop1_gc) {
        t15_2_B.Switch2_j5 = t15_2_P._Value;
      } else {
        /* DataStoreRead: '<S81>/Data Store Read2' */
        t15_2_B.DataStoreRead2_iu = t15_2_DWork.c_a_tpl_min;

        /* RelationalOperator: '<S85>/UpperRelop' */
        t15_2_B.UpperRelop_o = (t15_2_B.u5_b < t15_2_B.DataStoreRead2_iu);

        /* Switch: '<S85>/Switch' */
        if (t15_2_B.UpperRelop_o) {
          t15_2_B.Switch_dp = t15_2_B.DataStoreRead2_iu;
        } else {
          t15_2_B.Switch_dp = t15_2_B.u5_b;
        }

        /* End of Switch: '<S85>/Switch' */
        t15_2_B.Switch2_j5 = t15_2_B.Switch_dp;
      }

      /* End of Switch: '<S85>/Switch2' */
      t15_2_B.Ip_rd = t15_2_B.Switch2_j5;
    }

    /* End of Switch: '<S74>/Ip_rd ' */

    /* Product: '<S74>/Divide1' */
    t15_2_B.Divide1_fs[0] = t15_2_B.SFunction_n[1] * t15_2_B.Ip_rd;
    t15_2_B.Divide1_fs[1] = t15_2_B.SFunction_n[0] * t15_2_B.Ip_rd;
    t15_2_B.c_eob1_k[0] = t15_2_B.Divide1_fs[0];
    t15_2_B.c_eob1_k[1] = t15_2_B.Divide1_fs[1];
  }

  /* End of Switch: '<S67>/c_eob1' */

  /* DataStoreRead: '<S72>/Data Store Read2' */
  t15_2_B.DataStoreRead2_m = t15_2_DWork.tterm;

  /* RelationalOperator: '<S72>/Relational Operator2' */
  t15_2_B.RelationalOperator2_ah = (t15_2_B.Times < t15_2_B.DataStoreRead2_m);

  /* Product: '<S67>/Divide10' */
  t15_2_B.Divide10[0] = t15_2_B.c_eob1_k[0] * t15_2_B.RelationalOperator2_ah;
  t15_2_B.Divide10[1] = t15_2_B.c_eob1_k[1] * t15_2_B.RelationalOperator2_ah;

  /* UnitDelay: '<S8>/UD' */
  t15_2_B.Uk1_hc = t15_2_DWork.UD_DSTATE_j;

  /* Sum: '<S8>/Diff' */
  t15_2_B.Diff_o = t15_2_B.Times - t15_2_B.Uk1_hc;
  for (i = 0; i < 11; i++) {
    /* Product: '<S6>/Divide4' */
    t15_2_B.Divide4_pj[i] = t15_2_B.DataStoreRead2[i] * t15_2_B.Divide6_i[i];

    /* Sum: '<S9>/Add1' */
    t15_2_B.Add1_b[i] = t15_2_B.Divide4_pj[i] - t15_2_B.Memory1[i];

    /* Product: '<S9>/Divide' */
    t15_2_B.Divide_n[i] = t15_2_B.Add1_b[i] / t15_2_B.Diff_o;

    /* RelationalOperator: '<S12>/LowerRelop1' */
    t15_2_B.LowerRelop1[i] = (t15_2_B.Divide_n[i] > t15_2_B.Divide1[i]);

    /* Gain: '<S10>/-1' */
    t15_2_B.u_a[i] = t15_2_P.u_Gain * t15_2_B.Divide1[i];

    /* RelationalOperator: '<S12>/UpperRelop' */
    t15_2_B.UpperRelop[i] = (t15_2_B.Divide_n[i] < t15_2_B.u_a[i]);

    /* Switch: '<S12>/Switch' */
    if (t15_2_B.UpperRelop[i]) {
      t15_2_B.Switch_g[i] = t15_2_B.u_a[i];
    } else {
      t15_2_B.Switch_g[i] = t15_2_B.Divide_n[i];
    }

    /* End of Switch: '<S12>/Switch' */

    /* Switch: '<S12>/Switch2' */
    if (t15_2_B.LowerRelop1[i]) {
      t15_2_B.Switch2[i] = t15_2_B.Divide1[i];
    } else {
      t15_2_B.Switch2[i] = t15_2_B.Switch_g[i];
    }

    /* End of Switch: '<S12>/Switch2' */

    /* Product: '<S9>/Divide1' */
    t15_2_B.Divide1_g[i] = t15_2_B.Switch2[i] * t15_2_B.Diff_o;

    /* Sum: '<S9>/Add2' */
    t15_2_B.Add2_c[i] = t15_2_B.Memory1[i] + t15_2_B.Divide1_g[i];

    /* RelationalOperator: '<S13>/LowerRelop1' */
    t15_2_B.LowerRelop1_c[i] = (t15_2_B.Add2_c[i] > t15_2_B.DataStoreRead1[i]);

    /* Gain: '<S11>/Gain' */
    t15_2_B.Gain_m[i] = t15_2_P.Gain_Gain_k * t15_2_B.DataStoreRead1[i];

    /* RelationalOperator: '<S13>/UpperRelop' */
    t15_2_B.UpperRelop_p[i] = (t15_2_B.Add2_c[i] < t15_2_B.Gain_m[i]);

    /* Switch: '<S13>/Switch' */
    if (t15_2_B.UpperRelop_p[i]) {
      t15_2_B.Switch_d[i] = t15_2_B.Gain_m[i];
    } else {
      t15_2_B.Switch_d[i] = t15_2_B.Add2_c[i];
    }

    /* End of Switch: '<S13>/Switch' */

    /* Switch: '<S13>/Switch2' */
    if (t15_2_B.LowerRelop1_c[i]) {
      t15_2_B.Switch2_g[i] = t15_2_B.DataStoreRead1[i];
    } else {
      t15_2_B.Switch2_g[i] = t15_2_B.Switch_d[i];
    }

    /* End of Switch: '<S13>/Switch2' */

    /* DataStoreRead: '<S3>/Data Store Read2' */
    t15_2_B.DataStoreRead2_ln[i] = t15_2_DWork.ntur[i];

    /* Product: '<S3>/Divide3' */
    t15_2_B.Divide3_d[i] = t15_2_B.Switch2_g[i] / t15_2_B.DataStoreRead2_ln[i];

    /* Product: '<S3>/Divide1' incorporates:
     *  Constant: '<S3>/wz1'
     */
    t15_2_B.Divide1_ow[i] = t15_2_P.wz1_Value[i] / t15_2_B.DataStoreRead2_ln[i];
  }

  /* DataStoreRead: '<S5>/Data Store Read1' */
  t15_2_B.DataStoreRead1_b = t15_2_DWork.VS1_up;

  /* RelationalOperator: '<S14>/LowerRelop1' */
  t15_2_B.LowerRelop1_h = (t15_2_B.Divide10[0] > t15_2_B.DataStoreRead1_b);

  /* Switch: '<S14>/Switch2' */
  if (t15_2_B.LowerRelop1_h) {
    t15_2_B.Switch2_j = t15_2_B.DataStoreRead1_b;
  } else {
    /* Gain: '<S5>/Gain' */
    t15_2_B.Gain_d = t15_2_P.Gain_Gain * t15_2_B.DataStoreRead1_b;

    /* RelationalOperator: '<S14>/UpperRelop' */
    t15_2_B.UpperRelop_a = (t15_2_B.Divide10[0] < t15_2_B.Gain_d);

    /* Switch: '<S14>/Switch' */
    if (t15_2_B.UpperRelop_a) {
      t15_2_B.Switch_d4 = t15_2_B.Gain_d;
    } else {
      t15_2_B.Switch_d4 = t15_2_B.Divide10[0];
    }

    /* End of Switch: '<S14>/Switch' */
    t15_2_B.Switch2_j = t15_2_B.Switch_d4;
  }

  for (i = 0; i < 11; i++) {
    /* Product: '<S3>/Divide2' */
    t15_2_B.Divide2_p[i] = t15_2_B.Divide1_ow[i] * t15_2_B.Switch2_j;

    /* Sum: '<S3>/Add1' */
    t15_2_B.Add1_m[i] = t15_2_B.Divide3_d[i] + t15_2_B.Divide2_p[i];
  }

  /* End of Switch: '<S14>/Switch2' */

  /* DataStoreRead: '<S3>/Data Store Read1' */
  t15_2_B.DataStoreRead1_d = t15_2_DWork.ntur[11];

  /* Product: '<S3>/Divide4' incorporates:
   *  Constant: '<S3>/wz2'
   */
  t15_2_B.Divide4_bw = t15_2_P.wz2_Value / t15_2_B.DataStoreRead1_d;

  /* DataStoreRead: '<S5>/Data Store Read3' */
  t15_2_B.DataStoreRead3_h = t15_2_DWork.VS3_up;

  /* RelationalOperator: '<S15>/LowerRelop1' */
  t15_2_B.LowerRelop1_n = (t15_2_B.Divide10[1] > t15_2_B.DataStoreRead3_h);

  /* Switch: '<S15>/Switch2' */
  if (t15_2_B.LowerRelop1_n) {
    t15_2_B.Switch2_d = t15_2_B.DataStoreRead3_h;
  } else {
    /* Gain: '<S5>/Gain1' */
    t15_2_B.Gain1 = t15_2_P.Gain1_Gain * t15_2_B.DataStoreRead3_h;

    /* RelationalOperator: '<S15>/UpperRelop' */
    t15_2_B.UpperRelop_m = (t15_2_B.Divide10[1] < t15_2_B.Gain1);

    /* Switch: '<S15>/Switch' */
    if (t15_2_B.UpperRelop_m) {
      t15_2_B.Switch_bj = t15_2_B.Gain1;
    } else {
      t15_2_B.Switch_bj = t15_2_B.Divide10[1];
    }

    /* End of Switch: '<S15>/Switch' */
    t15_2_B.Switch2_d = t15_2_B.Switch_bj;
  }

  /* End of Switch: '<S15>/Switch2' */

  /* Product: '<S3>/Divide5' */
  t15_2_B.Divide5_p = t15_2_B.Divide4_bw * t15_2_B.Switch2_d;

  /* SignalConversion: '<S3>/TmpSignal ConversionAtnpf,12Inport1' */
  memcpy(&t15_2_B.TmpSignalConversionAtnpf12Inpor[0], &t15_2_B.Add1_m[0], 11U *
         sizeof(real_T));
  t15_2_B.TmpSignalConversionAtnpf12Inpor[11] = t15_2_B.Divide5_p;

  /* Gain: '<S3>/npf,12' */
  for (i = 0; i < 15; i++) {
    t15_2_B.npf12[i] = 0.0;
    for (i_0 = 0; i_0 < 12; i_0++) {
      t15_2_B.npf12[i] += t15_2_P.npf12_Gain[15 * i_0 + i] *
        t15_2_B.TmpSignalConversionAtnpf12Inpor[i_0];
    }
  }

  /* End of Gain: '<S3>/npf,12' */

  /* Memory: '<S18>/Memory2' */
  t15_2_B.Memory2_ga = t15_2_DWork.Memory2_PreviousInput_d0;

  /* Gain: '<S18>/-1' incorporates:
   *  Inport: '<Root>/In1'
   */
  t15_2_B.u_p = t15_2_P.u_Gain_d * t15_2_U.In1[3];

  /* Switch: '<S18>/Ip<1e-4 ' */
  if (t15_2_B.u_p > t15_2_P.Ip1e4_Threshold) {
    t15_2_B.Ip1e4 = t15_2_B.Memory2_ga;
  } else {
    t15_2_B.Ip1e4 = t15_2_B.Times;
  }

  /* End of Switch: '<S18>/Ip<1e-4 ' */

  /* Sum: '<S18>/Sum2' incorporates:
   *  Constant: '<S18>/Constant4'
   */
  t15_2_B.Sum2_b = t15_2_B.Ip1e4 + t15_2_P.Constant4_Value_m;

  /* RelationalOperator: '<S6>/Rel.Operator' */
  t15_2_B.RelOperator = (t15_2_B.Sum2_b < t15_2_B.Times);

  /* Stop: '<S6>/Stop Simulation' */
  if (t15_2_B.RelOperator) {
    rtmSetStopRequested(t15_2_M, 1);
  }

  /* End of Stop: '<S6>/Stop Simulation' */

  /* DataStoreRead: '<S6>/Time_stop Read' */
  t15_2_B.Time_stopRead = t15_2_DWork.Time_stop;

  /* RelationalOperator: '<S6>/Rel.Operator1' */
  t15_2_B.RelOperator1 = (t15_2_B.Times >= t15_2_B.Time_stopRead);

  /* Stop: '<S6>/Stop Simulation1' */
  if (t15_2_B.RelOperator1) {
    rtmSetStopRequested(t15_2_M, 1);
  }

  /* End of Stop: '<S6>/Stop Simulation1' */

  /* Outport: '<Root>/to_DINA' */
  memcpy(&t15_2_Y.to_DINA[0], &t15_2_B.npf12[0], 15U * sizeof(real_T));
  memcpy(&t15_2_Y.to_DINA[15], &t15_2_B.Divide3_d[0], 11U * sizeof(real_T));
  for (i = 0; i < 11; i++) {
    /* Outport: '<Root>/to_DINA' */
    t15_2_Y.to_DINA[i + 26] = t15_2_B.Divide2_p[i];

    /* Update for Memory: '<S9>/Memory1' */
    t15_2_DWork.Memory1_PreviousInput[i] = t15_2_B.Switch2_g[i];

    /* Update for Memory: '<S110>/Memory2' */
    t15_2_DWork.Memory2_PreviousInput_kw[i] = t15_2_B.u_bx[i];

    /* Update for Memory: '<S100>/Memory1' */
    t15_2_DWork.Memory1_PreviousInput_b[i] = t15_2_B.u_gg[i];

    /* Update for Memory: '<S104>/Memory' */
    t15_2_DWork.Memory_PreviousInput_h[i] = t15_2_B.u_g[i];
  }

  /* Outport: '<Root>/to_DINA' */
  t15_2_Y.to_DINA[37] = t15_2_B.Divide5_p;

  /* Update for Memory: '<S21>/Memory1' */
  t15_2_DWork.Memory1_PreviousInput_c = t15_2_B.switch1;

  /* Update for Memory: '<S32>/Memory' */
  t15_2_DWork.Memory_PreviousInput = t15_2_B.LogicalOperator;

  /* Update for Memory: '<S46>/Memory2' */
  t15_2_DWork.Memory2_PreviousInput = t15_2_B.c_eob1;

  /* Update for Memory: '<S46>/Memory1' */
  t15_2_DWork.Memory1_PreviousInput_l = t15_2_B.c_eob;

  /* Update for Memory: '<S47>/Memory2' */
  t15_2_DWork.Memory2_PreviousInput_k = t15_2_B.c_eob1_m;

  /* Update for Memory: '<S47>/Memory1' */
  t15_2_DWork.Memory1_PreviousInput_la = t15_2_B.c_eob_p;

  /* Update for Memory: '<S48>/Memory2' */
  t15_2_DWork.Memory2_PreviousInput_i = t15_2_B.c_eob1_n;

  /* Update for Memory: '<S48>/Memory1' */
  t15_2_DWork.Memory1_PreviousInput_i = t15_2_B.c_eob_l;

  /* Update for Memory: '<S49>/Memory2' */
  t15_2_DWork.Memory2_PreviousInput_e = t15_2_B.c_eob1_o;

  /* Update for Memory: '<S49>/Memory1' */
  t15_2_DWork.Memory1_PreviousInput_f = t15_2_B.c_eob_f;

  /* Update for Memory: '<S50>/Memory2' */
  t15_2_DWork.Memory2_PreviousInput_j = t15_2_B.c_eob1_b;

  /* Update for Memory: '<S50>/Memory1' */
  t15_2_DWork.Memory1_PreviousInput_l5 = t15_2_B.c_eob_n;

  /* Update for Memory: '<S51>/Memory2' */
  t15_2_DWork.Memory2_PreviousInput_c = t15_2_B.c_eob1_j;

  /* Update for Memory: '<S51>/Memory1' */
  t15_2_DWork.Memory1_PreviousInput_k = t15_2_B.c_eob_oo;

  /* Update for Memory: '<S22>/Memory1' */
  t15_2_DWork.Memory1_PreviousInput_h = t15_2_B.c_eob_d4;

  /* Update for Memory: '<S35>/Memory2' */
  t15_2_DWork.Memory2_PreviousInput_b = t15_2_B.c_eob_fm;

  /* Update for Memory: '<S38>/Memory2' */
  t15_2_DWork.Memory2_PreviousInput_d = t15_2_B.c_eob_h;

  /* Update for Memory: '<S39>/Memory2' */
  t15_2_DWork.Memory2_PreviousInput_o = t15_2_B.c_eob_pa;

  /* Update for Memory: '<S40>/Memory2' */
  t15_2_DWork.Memory2_PreviousInput_jf = t15_2_B.c_eob_l2;

  /* Update for Memory: '<S41>/Memory2' */
  t15_2_DWork.Memory2_PreviousInput_f = t15_2_B.c_eob_hm;

  /* Update for Memory: '<S42>/Memory2' */
  t15_2_DWork.Memory2_PreviousInput_i2 = t15_2_B.c_eob_hu;

  /* Update for Memory: '<S43>/Memory2' */
  t15_2_DWork.Memory2_PreviousInput_fs = t15_2_B.c_eob_m;

  /* Update for Memory: '<S44>/Memory2' */
  t15_2_DWork.Memory2_PreviousInput_m = t15_2_B.c_eob_i;

  /* Update for Memory: '<S45>/Memory2' */
  t15_2_DWork.Memory2_PreviousInput_n = t15_2_B.c_eob_nt;

  /* Update for Memory: '<S36>/Memory2' */
  t15_2_DWork.Memory2_PreviousInput_g = t15_2_B.c_eob_ml;

  /* Update for Memory: '<S37>/Memory2' */
  t15_2_DWork.Memory2_PreviousInput_c4 = t15_2_B.c_eob_g;

  /* Update for Memory: '<S29>/Memory' */
  t15_2_DWork.Memory_PreviousInput_d = t15_2_B.LogicalOperator_b;

  /* Update for UnitDelay: '<S33>/UD' incorporates:
   *  Inport: '<Root>/In1'
   */
  t15_2_DWork.UD_DSTATE = t15_2_U.In1[0];

  /* Update for UnitDelay: '<S34>/UD' */
  t15_2_DWork.UD_DSTATE_o = t15_2_B.Times;

  /* Update for Memory: '<S60>/Memory' */
  t15_2_DWork.Memory_PreviousInput_o = t15_2_B.LogicalOperator_e;

  /* Update for Memory: '<S27>/Memory1' */
  t15_2_DWork.Memory1_PreviousInput_kq = t15_2_B.LogicalOperator_e;

  /* Update for Memory: '<S64>/Memory' */
  t15_2_DWork.Memory_PreviousInput_f = t15_2_B.LogicalOperator_k;

  /* Update for Memory: '<S28>/Memory1' */
  t15_2_DWork.Memory1_PreviousInput_j = t15_2_B.LogicalOperator_k;

  /* Update for Memory: '<S30>/Memory1' */
  t15_2_DWork.Memory1_PreviousInput_m = t15_2_B.LogicalOperator_b;

  /* Level2 S-Function Block: '<S107>/S-Function' (contr_lim) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[17];
    sfcnUpdate(rts, 0);
    if (ssGetErrorStatus(rts) != (NULL))
      return;
  }

  /* Level2 S-Function Block: '<S106>/S-Function' (contr_curr) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[18];
    sfcnUpdate(rts, 0);
    if (ssGetErrorStatus(rts) != (NULL))
      return;
  }

  /* Update for Memory: '<S92>/Memory3' */
  t15_2_DWork.Memory3_PreviousInput = t15_2_B.switch1_b;

  /* Level2 S-Function Block: '<S103>/S-Function' (contr_div) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[19];
    sfcnUpdate(rts, 0);
    if (ssGetErrorStatus(rts) != (NULL))
      return;
  }

  /* Update for Memory: '<S113>/Memory1' */
  t15_2_DWork.Memory1_PreviousInput_o = t15_2_B.c_eob_a;

  /* Update for Memory: '<S98>/Memory1' */
  t15_2_DWork.Memory1_PreviousInput_p = t15_2_B.switch1_g;

  /* Level2 S-Function Block: '<S101>/S-Function' (contr_div) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[20];
    sfcnUpdate(rts, 0);
    if (ssGetErrorStatus(rts) != (NULL))
      return;
  }

  /* Update for Memory: '<S95>/Memory1' */
  t15_2_DWork.Memory1_PreviousInput_hp = t15_2_B.u_gv;

  /* Level2 S-Function Block: '<S111>/S-Function' (contr_curr) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[21];
    sfcnUpdate(rts, 0);
    if (ssGetErrorStatus(rts) != (NULL))
      return;
  }

  /* Update for UniformRandomNumber: '<S73>/Uniform Random Number' */
  tmin = t15_2_P.UniformRandomNumber_Minimum;
  t15_2_DWork.UniformRandomNumber_NextOutput =
    (t15_2_P.UniformRandomNumber_Maximum - tmin) * rt_urand_Upu32_Yd_f_pw_snf
    (&t15_2_DWork.RandSeed) + tmin;

  /* Update for UnitDelay: '<S78>/UD' */
  t15_2_DWork.UD_DSTATE_a = t15_2_B.Times;

  /* Level2 S-Function Block: '<S88>/S-Function' (contr_vert_vs3) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[22];
    sfcnUpdate(rts, 0);
    if (ssGetErrorStatus(rts) != (NULL))
      return;
  }

  /* Level2 S-Function Block: '<S83>/S-Function' (contr_vert_vs3) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[23];
    sfcnUpdate(rts, 0);
    if (ssGetErrorStatus(rts) != (NULL))
      return;
  }

  /* Update for UnitDelay: '<S8>/UD' */
  t15_2_DWork.UD_DSTATE_j = t15_2_B.Times;

  /* Update for Memory: '<S18>/Memory2' */
  t15_2_DWork.Memory2_PreviousInput_d0 = t15_2_B.Ip1e4;

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
    for (i = 0; i < 17; i++) {
      t15_2_B.read_control_data2_fun[i] = 0.0;
    }

    for (i = 0; i < 44; i++) {
      t15_2_B.read_tt_kavin2_fun[i] = 0.0;
    }

    for (i = 0; i < 100; i++) {
      t15_2_B.read_elong_fun[i] = 0.0;
    }

    for (i = 0; i < 10000; i++) {
      t15_2_B.read_volt_fun[i] = 0.0;
    }

    for (i = 0; i < 100; i++) {
      t15_2_B.read_g1_fun[i] = 0.0;
    }

    for (i = 0; i < 100; i++) {
      t15_2_B.read_g1_t_fun[i] = 0.0;
    }

    for (i = 0; i < 100; i++) {
      t15_2_B.read_g2_fun[i] = 0.0;
    }

    for (i = 0; i < 100; i++) {
      t15_2_B.read_g2_t_fun[i] = 0.0;
    }

    for (i = 0; i < 100; i++) {
      t15_2_B.read_g3_fun[i] = 0.0;
    }

    for (i = 0; i < 100; i++) {
      t15_2_B.read_g3_t_fun[i] = 0.0;
    }

    for (i = 0; i < 100; i++) {
      t15_2_B.read_g4_fun[i] = 0.0;
    }

    for (i = 0; i < 100; i++) {
      t15_2_B.read_g4_t_fun[i] = 0.0;
    }

    for (i = 0; i < 100; i++) {
      t15_2_B.read_g5_fun[i] = 0.0;
    }

    for (i = 0; i < 100; i++) {
      t15_2_B.read_g5_t_fun[i] = 0.0;
    }

    for (i = 0; i < 100; i++) {
      t15_2_B.read_g6_fun[i] = 0.0;
    }

    for (i = 0; i < 100; i++) {
      t15_2_B.read_g6_t_fun[i] = 0.0;
    }

    for (i = 0; i < 6500; i++) {
      t15_2_B.read_scr_fun[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.DataStoreRead1[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Memory1[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.DataStoreRead1_l[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.u[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide1[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.DataStoreRead2[i] = 0.0;
    }

    for (i = 0; i < 6; i++) {
      t15_2_B.e2[i] = 0.0;
    }

    for (i = 0; i < 15; i++) {
      t15_2_B.e6_n[i] = 0.0;
    }

    for (i = 0; i < 6; i++) {
      t15_2_B.e2_f[i] = 0.0;
    }

    for (i = 0; i < 20; i++) {
      t15_2_B.u_m[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Memory2_d[i] = 0.0;
    }

    for (i = 0; i < 20; i++) {
      t15_2_B.Divide12_k[i] = 0.0;
    }

    for (i = 0; i < 20; i++) {
      t15_2_B.SFunction[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.DataStoreRead2_a[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide1_c5[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.e6_l[i] = 0.0;
    }

    for (i = 0; i < 20; i++) {
      t15_2_B.Gain[i] = 0.0;
    }

    for (i = 0; i < 20; i++) {
      t15_2_B.SFunction_m[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.u_bx[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide14[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Memory1_ps[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Memory_k[i] = 0.0;
    }

    for (i = 0; i < 20; i++) {
      t15_2_B.Divide2[i] = 0.0;
    }

    for (i = 0; i < 20; i++) {
      t15_2_B.SFunction_g[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.u_g[i] = 0.0;
    }

    for (i = 0; i < 20; i++) {
      t15_2_B.Divide4[i] = 0.0;
    }

    for (i = 0; i < 20; i++) {
      t15_2_B.SFunction_g3[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.u_gg[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide4_i[i] = 0.0;
    }

    for (i = 0; i < 20; i++) {
      t15_2_B.G_curr_term1[i] = 0.0;
    }

    for (i = 0; i < 20; i++) {
      t15_2_B.Divide12_b[i] = 0.0;
    }

    for (i = 0; i < 20; i++) {
      t15_2_B.SFunction_a[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide2_n[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.volt1Read[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.u01[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.volt2Read[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.volt1Read_i[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.u01_j[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.volt3Read[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.volt1Read_c[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.u01_n[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.volt4Read[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.volt1Read_k[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.u01_b[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.volt5Read[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.volt1Read_h[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.u01_f[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.volt6Read[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.volt1Read_b[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.u01_b0[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.volt7Read[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.volt1Read_f[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.u01_jr[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.volt8Read[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.volt1Read_m[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.u01_m[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.volt9Read[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.volt1Read_b3[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.u01_bv[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.volt10Read[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.volt1Read_o[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.u01_ft[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.volt11Read[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.volt1Read_ba[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.u01_bc[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.volt12Read[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide7[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Sum3[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide2_l[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.e3_p[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Abs_p[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.DataStoreRead1_a[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.DataStoreRead2_l[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide5[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Sum2[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide3[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Sum1[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide4_p[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide1_ah[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Saturation_b[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.LogicalOperator_h[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Switch[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide6_i[i] = 0.0;
    }

    for (i = 0; i < 20; i++) {
      t15_2_B.eye202[i] = 0.0;
    }

    for (i = 0; i < 20; i++) {
      t15_2_B.SFunction_mf[i] = 0.0;
    }

    for (i = 0; i < 20; i++) {
      t15_2_B.eye202_p[i] = 0.0;
    }

    for (i = 0; i < 20; i++) {
      t15_2_B.SFunction_n[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide4_pj[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Add1_b[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide_n[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.u_a[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Switch_g[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Switch2[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide1_g[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Add2_c[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Gain_m[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Switch_d[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Switch2_g[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.DataStoreRead2_ln[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide3_d[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide1_ow[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide2_p[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Add1_m[i] = 0.0;
    }

    for (i = 0; i < 12; i++) {
      t15_2_B.TmpSignalConversionAtnpf12Inpor[i] = 0.0;
    }

    for (i = 0; i < 15; i++) {
      t15_2_B.npf12[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide3_f[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide5_b[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide6_e[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide1_n2[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Sum2_d[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.u_c[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide_d[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide2_m[i] = 0.0;
    }

    for (i = 0; i < 11; i++) {
      t15_2_B.Divide_np[i] = 0.0;
    }

    for (i = 0; i < 100; i++) {
      t15_2_B.g6_tRead[i] = 0.0;
    }

    for (i = 0; i < 49; i++) {
      t15_2_B.Selector[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.TmpSignalConversionAtg6_termref[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Selector1[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Divide6_p[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Add2_d[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.g6Read1[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.g6Read[i] = 0.0;
    }

    for (i = 0; i < 100; i++) {
      t15_2_B.g5_tRead[i] = 0.0;
    }

    for (i = 0; i < 49; i++) {
      t15_2_B.Selector_f[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.TmpSignalConversionAtg5_termref[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Selector1_f[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Divide6_j[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Add2_l[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.g5Read1[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.g5Read[i] = 0.0;
    }

    for (i = 0; i < 100; i++) {
      t15_2_B.g4_tRead[i] = 0.0;
    }

    for (i = 0; i < 49; i++) {
      t15_2_B.Selector_g[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.TmpSignalConversionAtg4_termref[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Selector1_fw[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Divide6_c[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Add2_ln[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.g4Read1[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.g4Read[i] = 0.0;
    }

    for (i = 0; i < 100; i++) {
      t15_2_B.g3_tRead[i] = 0.0;
    }

    for (i = 0; i < 49; i++) {
      t15_2_B.Selector_p[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.TmpSignalConversionAtg3_termref[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Selector1_a[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Divide6_el[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Add2_cn[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.g3Read1[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.g3Read[i] = 0.0;
    }

    for (i = 0; i < 100; i++) {
      t15_2_B.g2_tRead[i] = 0.0;
    }

    for (i = 0; i < 49; i++) {
      t15_2_B.Selector_h[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.TmpSignalConversionAtg2_termref[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Selector1_p[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Divide6_il[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Add2_m[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.g2Read1[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.g2Read[i] = 0.0;
    }

    for (i = 0; i < 100; i++) {
      t15_2_B.g1_tRead[i] = 0.0;
    }

    for (i = 0; i < 49; i++) {
      t15_2_B.Selector_c[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.TmpSignalConversionAtg1_termref[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Selector1_c[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Divide6_k[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Add2_p[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.g1Read1[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.g1Read[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.scr11Read[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.scr1Read[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.scr10Read[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.scr1Read_h[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.scr9Read[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.scr1Read_d[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.scr8Read[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.sct1Read[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.scr7Read[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.scr1Read_m[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.scr6Read[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.scr1Read_a[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.scr5Read[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.scr1Read_i[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.scr2Read[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.scr1Read_dp[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.scr13Read[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.scr1Read_hm[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.scr12Read[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.scr1Read_l[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.scr2Read_m[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.scr1Read_n[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.scr2Read_c[i] = 0.0;
    }

    for (i = 0; i < 500; i++) {
      t15_2_B.scr1Read_in[i] = 0.0;
    }

    for (i = 0; i < 100; i++) {
      t15_2_B.ElongRead[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Selector_n[i] = 0.0;
    }

    for (i = 0; i < 50; i++) {
      t15_2_B.Selector1_cb[i] = 0.0;
    }

    t15_2_B.DataStoreRead3 = 0.0;
    t15_2_B.Times = 0.0;
    t15_2_B.e6 = 0.0;
    t15_2_B.Memory1_j = 0.0;
    t15_2_B.RupRdRead1 = 0.0;
    t15_2_B.e3 = 0.0;
    t15_2_B.nturRead2 = 0.0;
    t15_2_B.Product1 = 0.0;
    t15_2_B.RelationalOperator = 0.0;
    t15_2_B.Memory = 0.0;
    t15_2_B.LogicalOperator = 0.0;
    t15_2_B.switch1 = 0.0;
    t15_2_B.Add2 = 0.0;
    t15_2_B.DataStoreRead = 0.0;
    t15_2_B.Product = 0.0;
    t15_2_B.Add1 = 0.0;
    t15_2_B.u_b = 0.0;
    t15_2_B.Memory2 = 0.0;
    t15_2_B.c_eob1 = 0.0;
    t15_2_B.Memory1_h = 0.0;
    t15_2_B.c_eob = 0.0;
    t15_2_B.c_eob_c = 0.0;
    t15_2_B.Add2_i = 0.0;
    t15_2_B.Memory2_b = 0.0;
    t15_2_B.c_eob1_m = 0.0;
    t15_2_B.Memory1_e = 0.0;
    t15_2_B.c_eob_p = 0.0;
    t15_2_B.c_eob_k = 0.0;
    t15_2_B.Add1_c = 0.0;
    t15_2_B.Memory2_f = 0.0;
    t15_2_B.c_eob1_n = 0.0;
    t15_2_B.Memory1_i = 0.0;
    t15_2_B.c_eob_l = 0.0;
    t15_2_B.c_eob_o = 0.0;
    t15_2_B.Add3 = 0.0;
    t15_2_B.Memory2_fe = 0.0;
    t15_2_B.c_eob1_o = 0.0;
    t15_2_B.Memory1_o = 0.0;
    t15_2_B.c_eob_f = 0.0;
    t15_2_B.c_eob_fx = 0.0;
    t15_2_B.Add4 = 0.0;
    t15_2_B.t_tran2DRead = 0.0;
    t15_2_B.tcont2Read = 0.0;
    t15_2_B.MinMax = 0.0;
    t15_2_B.RelationalOperator1 = 0.0;
    t15_2_B.Divide12 = 0.0;
    t15_2_B.Memory2_fu = 0.0;
    t15_2_B.c_eob1_b = 0.0;
    t15_2_B.Memory1_n = 0.0;
    t15_2_B.c_eob_n = 0.0;
    t15_2_B.c_eob_ni = 0.0;
    t15_2_B.Add5 = 0.0;
    t15_2_B.Memory2_g = 0.0;
    t15_2_B.c_eob1_j = 0.0;
    t15_2_B.Memory1_nl = 0.0;
    t15_2_B.c_eob_oo = 0.0;
    t15_2_B.c_eob_d = 0.0;
    t15_2_B.Add6 = 0.0;
    t15_2_B.Divide1_c = 0.0;
    t15_2_B.Memory1_l = 0.0;
    t15_2_B.c_eob_d4 = 0.0;
    t15_2_B.Divide6 = 0.0;
    t15_2_B.Add1_p = 0.0;
    t15_2_B.Memory2_m = 0.0;
    t15_2_B.c_eob_fm = 0.0;
    t15_2_B.Divide1_n = 0.0;
    t15_2_B.Add3_i = 0.0;
    t15_2_B.Memory2_n = 0.0;
    t15_2_B.c_eob_h = 0.0;
    t15_2_B.Divide1_o = 0.0;
    t15_2_B.Add1_n = 0.0;
    t15_2_B.Memory2_h = 0.0;
    t15_2_B.c_eob_pa = 0.0;
    t15_2_B.Divide1_na = 0.0;
    t15_2_B.Add2_h = 0.0;
    t15_2_B.Memory2_l = 0.0;
    t15_2_B.c_eob_l2 = 0.0;
    t15_2_B.Divide1_b = 0.0;
    t15_2_B.Add4_a = 0.0;
    t15_2_B.Memory2_a = 0.0;
    t15_2_B.c_eob_hm = 0.0;
    t15_2_B.Divide1_a = 0.0;
    t15_2_B.Add5_h = 0.0;
    t15_2_B.Memory2_k = 0.0;
    t15_2_B.c_eob_hu = 0.0;
    t15_2_B.Divide1_m = 0.0;
    t15_2_B.Add6_n = 0.0;
    t15_2_B.Memory2_j = 0.0;
    t15_2_B.c_eob_m = 0.0;
    t15_2_B.Divide1_cw = 0.0;
    t15_2_B.Add7 = 0.0;
    t15_2_B.Memory2_p = 0.0;
    t15_2_B.c_eob_i = 0.0;
    t15_2_B.Divide1_me = 0.0;
    t15_2_B.Add8 = 0.0;
    t15_2_B.Memory2_aw = 0.0;
    t15_2_B.c_eob_nt = 0.0;
    t15_2_B.Divide1_f = 0.0;
    t15_2_B.Add9 = 0.0;
    t15_2_B.Memory2_f5 = 0.0;
    t15_2_B.c_eob_ml = 0.0;
    t15_2_B.Divide1_mm = 0.0;
    t15_2_B.Add10 = 0.0;
    t15_2_B.Memory2_lp = 0.0;
    t15_2_B.c_eob_g = 0.0;
    t15_2_B.Divide1_fg = 0.0;
    t15_2_B.Add11 = 0.0;
    t15_2_B.DataStoreRead1_m = 0.0;
    t15_2_B.Abs = 0.0;
    t15_2_B.RelationalOperator1_a = 0.0;
    t15_2_B.Memory_i = 0.0;
    t15_2_B.LogicalOperator_b = 0.0;
    t15_2_B.u_bg = 0.0;
    t15_2_B.Uk1 = 0.0;
    t15_2_B.Diff = 0.0;
    t15_2_B.Uk1_g = 0.0;
    t15_2_B.Diff_i = 0.0;
    t15_2_B.Divide = 0.0;
    t15_2_B.DataStoreRead2_h = 0.0;
    t15_2_B.Abs_o = 0.0;
    t15_2_B.LogicalOperator1 = 0.0;
    t15_2_B.Memory_g = 0.0;
    t15_2_B.LogicalOperator_e = 0.0;
    t15_2_B.Memory1_b = 0.0;
    t15_2_B.LogicalOperator_i = 0.0;
    t15_2_B.DataStoreRead_h = 0.0;
    t15_2_B.Abs_j = 0.0;
    t15_2_B.LogicalOperator2 = 0.0;
    t15_2_B.Memory_p = 0.0;
    t15_2_B.LogicalOperator_k = 0.0;
    t15_2_B.Memory1_jw = 0.0;
    t15_2_B.LogicalOperator_g = 0.0;
    t15_2_B.Memory1_p = 0.0;
    t15_2_B.LogicalOperator_f = 0.0;
    t15_2_B.DataStoreRead1_l0 = 0.0;
    t15_2_B.RelationalOperator1_n = 0.0;
    t15_2_B.DataStoreRead_f = 0.0;
    t15_2_B.RelationalOperator_f = 0.0;
    t15_2_B.DataStoreRead_k = 0.0;
    t15_2_B.Memory3 = 0.0;
    t15_2_B.DataStoreRead1_n = 0.0;
    t15_2_B.RelationalOperator1_p = 0.0;
    t15_2_B.switch1_b = 0.0;
    t15_2_B.Subtract2 = 0.0;
    t15_2_B.Divide1_i = 0.0;
    t15_2_B.Subtract1 = 0.0;
    t15_2_B.Saturation1 = 0.0;
    t15_2_B.DataStoreRead_kw = 0.0;
    t15_2_B.DataStoreRead2_k = 0.0;
    t15_2_B.RelationalOperator2 = 0.0;
    t15_2_B.DataStoreRead2_o = 0.0;
    t15_2_B.RelationalOperator1_e = 0.0;
    t15_2_B.Memory1_p5 = 0.0;
    t15_2_B.c_eob_a = 0.0;
    t15_2_B.c_eob_ay = 0.0;
    t15_2_B.Memory1_h0 = 0.0;
    t15_2_B.DataStoreRead2_j = 0.0;
    t15_2_B.RelationalOperator2_a = 0.0;
    t15_2_B.switch1_g = 0.0;
    t15_2_B.DataStoreRead2_d = 0.0;
    t15_2_B.RelationalOperator2_p = 0.0;
    t15_2_B.DataStoreRead_k5 = 0.0;
    t15_2_B.Memory1_ea = 0.0;
    t15_2_B.DataStoreRead2_i = 0.0;
    t15_2_B.RelationalOperator2_j = 0.0;
    t15_2_B.u_gv = 0.0;
    t15_2_B.Subtract2_o = 0.0;
    t15_2_B.Divide4_o = 0.0;
    t15_2_B.Subtract3 = 0.0;
    t15_2_B.Saturation = 0.0;
    t15_2_B.Subtract1_i = 0.0;
    t15_2_B.DataStoreRead2_ac = 0.0;
    t15_2_B.RelationalOperator2_p5 = 0.0;
    t15_2_B.volt1 = 0.0;
    t15_2_B.volt1_p = 0.0;
    t15_2_B.volt1_i = 0.0;
    t15_2_B.volt1_k = 0.0;
    t15_2_B.volt1_pu = 0.0;
    t15_2_B.volt1_o = 0.0;
    t15_2_B.volt1_f = 0.0;
    t15_2_B.volt1_l = 0.0;
    t15_2_B.volt1_a = 0.0;
    t15_2_B.volt1_d = 0.0;
    t15_2_B.volt1_kr = 0.0;
    t15_2_B.DataStoreRead2_aj = 0.0;
    t15_2_B.RelationalOperator2_m = 0.0;
    t15_2_B.DataStoreRead1_g = 0.0;
    t15_2_B.DataStoreRead_l = 0.0;
    t15_2_B.u5 = 0.0;
    t15_2_B.Div = 0.0;
    t15_2_B.UniformRandomNumber = 0.0;
    t15_2_B.DataStoreRead_m = 0.0;
    t15_2_B.u5_e = 0.0;
    t15_2_B.Divide11 = 0.0;
    t15_2_B.Uk1_h = 0.0;
    t15_2_B.Diff_p = 0.0;
    t15_2_B.e3_b = 0.0;
    t15_2_B.Sqrt = 0.0;
    t15_2_B.Divide1_no = 0.0;
    t15_2_B.Sum2_c = 0.0;
    t15_2_B.DataStoreRead_j = 0.0;
    t15_2_B.RelationalOperator1_f = 0.0;
    t15_2_B.Divide12_g[0] = 0.0;
    t15_2_B.Divide12_g[1] = 0.0;
    t15_2_B.Divide4_b[0] = 0.0;
    t15_2_B.Divide4_b[1] = 0.0;
    t15_2_B.c_eob1_k[0] = 0.0;
    t15_2_B.c_eob1_k[1] = 0.0;
    t15_2_B.DataStoreRead2_m = 0.0;
    t15_2_B.RelationalOperator2_ah = 0.0;
    t15_2_B.Divide10[0] = 0.0;
    t15_2_B.Divide10[1] = 0.0;
    t15_2_B.Uk1_hc = 0.0;
    t15_2_B.Diff_o = 0.0;
    t15_2_B.DataStoreRead1_b = 0.0;
    t15_2_B.Switch2_j = 0.0;
    t15_2_B.DataStoreRead1_d = 0.0;
    t15_2_B.Divide4_bw = 0.0;
    t15_2_B.DataStoreRead3_h = 0.0;
    t15_2_B.Switch2_d = 0.0;
    t15_2_B.Divide5_p = 0.0;
    t15_2_B.Memory2_ga = 0.0;
    t15_2_B.u_p = 0.0;
    t15_2_B.Ip1e4 = 0.0;
    t15_2_B.Sum2_b = 0.0;
    t15_2_B.Time_stopRead = 0.0;
    t15_2_B.Subtract2_g = 0.0;
    t15_2_B.DataStoreRead1_c = 0.0;
    t15_2_B.Divide4_ii = 0.0;
    t15_2_B.Subtract3_i = 0.0;
    t15_2_B.Saturation_n = 0.0;
    t15_2_B.Subtract1_k = 0.0;
    t15_2_B.Subtract3_ix = 0.0;
    t15_2_B.DataStoreRead2_hu = 0.0;
    t15_2_B.u15 = 0.0;
    t15_2_B.Divide9 = 0.0;
    t15_2_B.Saturation_m = 0.0;
    t15_2_B.DataStoreRead2_g = 0.0;
    t15_2_B.Sum3_n = 0.0;
    t15_2_B.DataStoreRead4 = 0.0;
    t15_2_B.DataStoreRead3_o = 0.0;
    t15_2_B.Sum2_bk = 0.0;
    t15_2_B.Divide1_gf = 0.0;
    t15_2_B.Divide6_n = 0.0;
    t15_2_B.Sum = 0.0;
    t15_2_B.Divide2_f = 0.0;
    t15_2_B.Sum1_f = 0.0;
    t15_2_B.Switch2_j1 = 0.0;
    t15_2_B.Switch_o = 0.0;
    t15_2_B.DataStoreRead_ky = 0.0;
    t15_2_B.RelationalOperator_a = 0.0;
    t15_2_B.DataStoreRead1_lt = 0.0;
    t15_2_B.DataStoreRead_c = 0.0;
    t15_2_B.Subtract3_c = 0.0;
    t15_2_B.Divide2_nx = 0.0;
    t15_2_B.Saturation1_i = 0.0;
    t15_2_B.u5_p = 0.0;
    t15_2_B.DataStoreRead1_bd = 0.0;
    t15_2_B.Divide1_oh = 0.0;
    t15_2_B.DataStoreRead1_f = 0.0;
    t15_2_B.RelationalOperator2_a2 = 0.0;
    t15_2_B.LimDivtr = 0.0;
    t15_2_B.Divide8[0] = 0.0;
    t15_2_B.Divide8[1] = 0.0;
    t15_2_B.DataStoreRead3_a = 0.0;
    t15_2_B.Switch2_h = 0.0;
    t15_2_B.Switch_b = 0.0;
    t15_2_B.DataStoreRead2_jg = 0.0;
    t15_2_B.Switch2_p = 0.0;
    t15_2_B.Switch_c = 0.0;
    t15_2_B.DataStoreRead1_mp = 0.0;
    t15_2_B.LogicalOperator1_f = 0.0;
    t15_2_B.DataStoreRead2_h1 = 0.0;
    t15_2_B.RelationalOperator1_d = 0.0;
    t15_2_B.LogicalOperator2_m = 0.0;
    t15_2_B.Ip_rd = 0.0;
    t15_2_B.Divide1_fs[0] = 0.0;
    t15_2_B.Divide1_fs[1] = 0.0;
    t15_2_B.DataStoreRead_n = 0.0;
    t15_2_B.u15_n = 0.0;
    t15_2_B.Divide6_ey = 0.0;
    t15_2_B.Switch2_l = 0.0;
    t15_2_B.DataStoreRead3_oz = 0.0;
    t15_2_B.Switch_b3 = 0.0;
    t15_2_B.u5_b = 0.0;
    t15_2_B.Switch2_j5 = 0.0;
    t15_2_B.DataStoreRead2_iu = 0.0;
    t15_2_B.Switch_dp = 0.0;
    t15_2_B.trdRead = 0.0;
    t15_2_B.RupRdRead = 0.0;
    t15_2_B.g6_termref = 0.0;
    t15_2_B.g6ref = 0.0;
    t15_2_B.trdRead_l = 0.0;
    t15_2_B.RupRdRead_m = 0.0;
    t15_2_B.g5_termref = 0.0;
    t15_2_B.g5ref = 0.0;
    t15_2_B.trdRead_j = 0.0;
    t15_2_B.RupRdRead_o = 0.0;
    t15_2_B.g4_termref = 0.0;
    t15_2_B.g4ref = 0.0;
    t15_2_B.trdRead_m = 0.0;
    t15_2_B.RupRdRead_j = 0.0;
    t15_2_B.g3_termref = 0.0;
    t15_2_B.g3ref = 0.0;
    t15_2_B.trdRead_c = 0.0;
    t15_2_B.RupRdRead_mw = 0.0;
    t15_2_B.g2_termref = 0.0;
    t15_2_B.g2ref = 0.0;
    t15_2_B.trdRead_d = 0.0;
    t15_2_B.RupRdRead_p = 0.0;
    t15_2_B.g1_termref = 0.0;
    t15_2_B.g1ref1 = 0.0;
    t15_2_B.I1 = 0.0;
    t15_2_B.I1_n = 0.0;
    t15_2_B.I1_p = 0.0;
    t15_2_B.I1_po = 0.0;
    t15_2_B.I1_j = 0.0;
    t15_2_B.I1_i = 0.0;
    t15_2_B.I1_f = 0.0;
    t15_2_B.I1_c = 0.0;
    t15_2_B.I1_a = 0.0;
    t15_2_B.I1_h = 0.0;
    t15_2_B.I1_k = 0.0;
    t15_2_B.Ipref = 0.0;
    t15_2_B.elong = 0.0;
    t15_2_B.Add2_a = 0.0;
    t15_2_B.DataStoreRead2_e = 0.0;
    t15_2_B.RelationalOperator_h = 0.0;
    t15_2_B.Gain1 = 0.0;
    t15_2_B.Switch_bj = 0.0;
    t15_2_B.Gain_d = 0.0;
    t15_2_B.Switch_d4 = 0.0;
  }

  /* states (dwork) */
  (void) memset((void *)&t15_2_DWork, 0,
                sizeof(D_Work_t15_2));
  t15_2_DWork.UD_DSTATE = 0.0;
  t15_2_DWork.UD_DSTATE_o = 0.0;

  {
    int_T i;
    for (i = 0; i < 50; i++) {
      t15_2_DWork.SFunction_DSTATE[i] = 0.0;
    }
  }

  {
    int_T i;
    for (i = 0; i < 50; i++) {
      t15_2_DWork.SFunction_DSTATE_j[i] = 0.0;
    }
  }

  {
    int_T i;
    for (i = 0; i < 50; i++) {
      t15_2_DWork.SFunction_DSTATE_f[i] = 0.0;
    }
  }

  {
    int_T i;
    for (i = 0; i < 50; i++) {
      t15_2_DWork.SFunction_DSTATE_a[i] = 0.0;
    }
  }

  {
    int_T i;
    for (i = 0; i < 50; i++) {
      t15_2_DWork.SFunction_DSTATE_ay[i] = 0.0;
    }
  }

  t15_2_DWork.UD_DSTATE_a = 0.0;

  {
    int_T i;
    for (i = 0; i < 50; i++) {
      t15_2_DWork.SFunction_DSTATE_e[i] = 0.0;
    }
  }

  {
    int_T i;
    for (i = 0; i < 50; i++) {
      t15_2_DWork.SFunction_DSTATE_k[i] = 0.0;
    }
  }

  t15_2_DWork.UD_DSTATE_j = 0.0;

  {
    int_T i;
    for (i = 0; i < 11; i++) {
      t15_2_DWork.Memory1_PreviousInput[i] = 0.0;
    }
  }

  t15_2_DWork.Memory1_PreviousInput_c = 0.0;
  t15_2_DWork.Memory_PreviousInput = 0.0;
  t15_2_DWork.Memory2_PreviousInput = 0.0;
  t15_2_DWork.Memory1_PreviousInput_l = 0.0;
  t15_2_DWork.Memory2_PreviousInput_k = 0.0;
  t15_2_DWork.Memory1_PreviousInput_la = 0.0;
  t15_2_DWork.Memory2_PreviousInput_i = 0.0;
  t15_2_DWork.Memory1_PreviousInput_i = 0.0;
  t15_2_DWork.Memory2_PreviousInput_e = 0.0;
  t15_2_DWork.Memory1_PreviousInput_f = 0.0;
  t15_2_DWork.Memory2_PreviousInput_j = 0.0;
  t15_2_DWork.Memory1_PreviousInput_l5 = 0.0;
  t15_2_DWork.Memory2_PreviousInput_c = 0.0;
  t15_2_DWork.Memory1_PreviousInput_k = 0.0;
  t15_2_DWork.Memory1_PreviousInput_h = 0.0;
  t15_2_DWork.Memory2_PreviousInput_b = 0.0;
  t15_2_DWork.Memory2_PreviousInput_d = 0.0;
  t15_2_DWork.Memory2_PreviousInput_o = 0.0;
  t15_2_DWork.Memory2_PreviousInput_jf = 0.0;
  t15_2_DWork.Memory2_PreviousInput_f = 0.0;
  t15_2_DWork.Memory2_PreviousInput_i2 = 0.0;
  t15_2_DWork.Memory2_PreviousInput_fs = 0.0;
  t15_2_DWork.Memory2_PreviousInput_m = 0.0;
  t15_2_DWork.Memory2_PreviousInput_n = 0.0;
  t15_2_DWork.Memory2_PreviousInput_g = 0.0;
  t15_2_DWork.Memory2_PreviousInput_c4 = 0.0;
  t15_2_DWork.Memory_PreviousInput_d = 0.0;
  t15_2_DWork.Memory_PreviousInput_o = 0.0;
  t15_2_DWork.Memory1_PreviousInput_kq = 0.0;
  t15_2_DWork.Memory_PreviousInput_f = 0.0;
  t15_2_DWork.Memory1_PreviousInput_j = 0.0;
  t15_2_DWork.Memory1_PreviousInput_m = 0.0;

  {
    int_T i;
    for (i = 0; i < 11; i++) {
      t15_2_DWork.Memory2_PreviousInput_kw[i] = 0.0;
    }
  }

  t15_2_DWork.Memory3_PreviousInput = 0.0;

  {
    int_T i;
    for (i = 0; i < 11; i++) {
      t15_2_DWork.Memory1_PreviousInput_b[i] = 0.0;
    }
  }

  {
    int_T i;
    for (i = 0; i < 11; i++) {
      t15_2_DWork.Memory_PreviousInput_h[i] = 0.0;
    }
  }

  t15_2_DWork.Memory1_PreviousInput_o = 0.0;
  t15_2_DWork.Memory1_PreviousInput_p = 0.0;
  t15_2_DWork.Memory1_PreviousInput_hp = 0.0;
  t15_2_DWork.UniformRandomNumber_NextOutput = 0.0;
  t15_2_DWork.Memory2_PreviousInput_d0 = 0.0;
  t15_2_DWork.tdiv = 0.0;
  t15_2_DWork.c_a_tpl1_eob = 0.0;
  t15_2_DWork.c_a_tpl2 = 0.0;
  t15_2_DWork.tterm = 0.0;
  t15_2_DWork.trd = 0.0;
  t15_2_DWork.c_a_tpl_min = 0.0;
  t15_2_DWork.y0 = 0.0;
  t15_2_DWork.c1_y0 = 0.0;
  t15_2_DWork.c2_y0 = 0.0;
  t15_2_DWork.t_tran2D = 0.0;
  t15_2_DWork.max_VS_lim = 0.0;
  t15_2_DWork.k_g4 = 0.0;
  t15_2_DWork.tcont2 = 0.0;
  t15_2_DWork.Ipdiv = 0.0;
  t15_2_DWork.ref_ramp = 0.0;
  t15_2_DWork.dtcont2 = 0.0;
  t15_2_DWork.Ip_rd = 0.0;
  t15_2_DWork.trd_ref = 0.0;
  t15_2_DWork.Time_stop = 0.0;
  t15_2_DWork.c_a_tpl1 = 0.0;

  {
    int_T i;
    for (i = 0; i < 100; i++) {
      t15_2_DWork.Elong[i] = 0.0;
    }
  }

  {
    int_T i;
    for (i = 0; i < 11; i++) {
      t15_2_DWork.Imax[i] = 0.0;
    }
  }

  {
    int_T i;
    for (i = 0; i < 6; i++) {
      t15_2_DWork.RupRd[i] = 0.0;
    }
  }

  t15_2_DWork.Tu = 0.0;
  t15_2_DWork.VS1_up = 0.0;
  t15_2_DWork.VS3_up = 0.0;

  {
    int_T i;
    for (i = 0; i < 11; i++) {
      t15_2_DWork.Vcspf_up[i] = 0.0;
    }
  }

  {
    int_T i;
    for (i = 0; i < 10000; i++) {
      t15_2_DWork.volt[i] = 0.0;
    }
  }

  t15_2_DWork.c_cur_max = 0.0;

  {
    int_T i;
    for (i = 0; i < 100; i++) {
      t15_2_DWork.g1[i] = 0.0;
    }
  }

  {
    int_T i;
    for (i = 0; i < 100; i++) {
      t15_2_DWork.g1_term[i] = 0.0;
    }
  }

  {
    int_T i;
    for (i = 0; i < 100; i++) {
      t15_2_DWork.g2[i] = 0.0;
    }
  }

  {
    int_T i;
    for (i = 0; i < 100; i++) {
      t15_2_DWork.g2_term[i] = 0.0;
    }
  }

  {
    int_T i;
    for (i = 0; i < 100; i++) {
      t15_2_DWork.g3[i] = 0.0;
    }
  }

  {
    int_T i;
    for (i = 0; i < 100; i++) {
      t15_2_DWork.g3_term[i] = 0.0;
    }
  }

  {
    int_T i;
    for (i = 0; i < 100; i++) {
      t15_2_DWork.g4[i] = 0.0;
    }
  }

  {
    int_T i;
    for (i = 0; i < 100; i++) {
      t15_2_DWork.g4_term[i] = 0.0;
    }
  }

  {
    int_T i;
    for (i = 0; i < 100; i++) {
      t15_2_DWork.g5[i] = 0.0;
    }
  }

  {
    int_T i;
    for (i = 0; i < 100; i++) {
      t15_2_DWork.g5_term[i] = 0.0;
    }
  }

  {
    int_T i;
    for (i = 0; i < 100; i++) {
      t15_2_DWork.g6[i] = 0.0;
    }
  }

  {
    int_T i;
    for (i = 0; i < 100; i++) {
      t15_2_DWork.g6_term[i] = 0.0;
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
    for (i = 0; i < 6500; i++) {
      t15_2_DWork.scr_data[i] = 0.0;
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

  t15_2_M->Sizes.numSFcns = (24);

  /* register each child */
  {
    (void) memset((void *)&t15_2_M->NonInlinedSFcns.childSFunctions[0], 0,
                  24*sizeof(SimStruct));
    t15_2_M->childSfunctions = (&t15_2_M->NonInlinedSFcns.childSFunctionPtrs[0]);

    {
      int_T i;
      for (i = 0; i < 24; i++) {
        t15_2_M->childSfunctions[i] = (&t15_2_M->
          NonInlinedSFcns.childSFunctions[i]);
      }
    }

    /* Level2 S-Function Block: t15_2/<S1>/read_control_data2_fun (read_control_data2) */
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
          _ssSetOutputPortNumDimensions(rts, 0, 1);
          ssSetOutputPortWidth(rts, 0, 17);
          ssSetOutputPortSignal(rts, 0, ((real_T *)
            t15_2_B.read_control_data2_fun));
        }
      }

      /* path info */
      ssSetModelName(rts, "read_control_data2_fun");
      ssSetPath(rts, "t15_2/Pow. Supply MC 2/read_control_data2_fun");
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

    /* Level2 S-Function Block: t15_2/<S1>/read_tt_kavin2_fun (read_tt_kavin2) */
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
          _ssSetOutputPortNumDimensions(rts, 0, 1);
          ssSetOutputPortWidth(rts, 0, 44);
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.read_tt_kavin2_fun));
        }
      }

      /* path info */
      ssSetModelName(rts, "read_tt_kavin2_fun");
      ssSetPath(rts, "t15_2/Pow. Supply MC 2/read_tt_kavin2_fun");
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

    /* Level2 S-Function Block: t15_2/<S1>/read_elong_fun (read_gaps) */
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
          int_T *dimensions = (int_T *) &t15_2_M->NonInlinedSFcns.Sfcn2.oDims0;
          dimensions[0] = 2;
          dimensions[1] = 50;
          _ssSetOutputPortDimensionsPtr(rts, 0, dimensions);
          _ssSetOutputPortNumDimensions(rts, 0, 2);
          ssSetOutputPortWidth(rts, 0, 100);
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.read_elong_fun));
        }
      }

      /* path info */
      ssSetModelName(rts, "read_elong_fun");
      ssSetPath(rts, "t15_2/Pow. Supply MC 2/read_elong_fun");
      ssSetRTModel(rts,t15_2_M);
      ssSetParentSS(rts, (NULL));
      ssSetRootSS(rts, rts);
      ssSetVersion(rts, SIMSTRUCT_VERSION_LEVEL2);

      /* parameters */
      {
        mxArray **sfcnParams = (mxArray **)
          &t15_2_M->NonInlinedSFcns.Sfcn2.params;
        ssSetSFcnParamsCount(rts, 1);
        ssSetSFcnParamsPtr(rts, &sfcnParams[0]);
        ssSetSFcnParam(rts, 0, (mxArray*)t15_2_P.read_elong_fun_P1_Size);
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

    /* Level2 S-Function Block: t15_2/<S1>/read_volt_fun (read_volt) */
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
          dimensions[0] = 20;
          dimensions[1] = 500;
          _ssSetOutputPortDimensionsPtr(rts, 0, dimensions);
          _ssSetOutputPortNumDimensions(rts, 0, 2);
          ssSetOutputPortWidth(rts, 0, 10000);
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.read_volt_fun));
        }
      }

      /* path info */
      ssSetModelName(rts, "read_volt_fun");
      ssSetPath(rts, "t15_2/Pow. Supply MC 2/read_volt_fun");
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
        ssSetSFcnParam(rts, 0, (mxArray*)t15_2_P.read_volt_fun_P1_Size);
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

    /* Level2 S-Function Block: t15_2/<S1>/read_g1_fun (read_gaps) */
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
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.read_g1_fun));
        }
      }

      /* path info */
      ssSetModelName(rts, "read_g1_fun");
      ssSetPath(rts, "t15_2/Pow. Supply MC 2/read_g1_fun");
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
        ssSetSFcnParam(rts, 0, (mxArray*)t15_2_P.read_g1_fun_P1_Size);
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

    /* Level2 S-Function Block: t15_2/<S1>/read_g1_t_fun (read_gaps_term) */
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
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.read_g1_t_fun));
        }
      }

      /* path info */
      ssSetModelName(rts, "read_g1_t_fun");
      ssSetPath(rts, "t15_2/Pow. Supply MC 2/read_g1_t_fun");
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
        ssSetSFcnParam(rts, 0, (mxArray*)t15_2_P.read_g1_t_fun_P1_Size);
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

    /* Level2 S-Function Block: t15_2/<S1>/read_g2_fun (read_gaps) */
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
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.read_g2_fun));
        }
      }

      /* path info */
      ssSetModelName(rts, "read_g2_fun");
      ssSetPath(rts, "t15_2/Pow. Supply MC 2/read_g2_fun");
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
        ssSetSFcnParam(rts, 0, (mxArray*)t15_2_P.read_g2_fun_P1_Size);
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

    /* Level2 S-Function Block: t15_2/<S1>/read_g2_t_fun (read_gaps_term) */
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
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.read_g2_t_fun));
        }
      }

      /* path info */
      ssSetModelName(rts, "read_g2_t_fun");
      ssSetPath(rts, "t15_2/Pow. Supply MC 2/read_g2_t_fun");
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
        ssSetSFcnParam(rts, 0, (mxArray*)t15_2_P.read_g2_t_fun_P1_Size);
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

    /* Level2 S-Function Block: t15_2/<S1>/read_g3_fun (read_gaps) */
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
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.read_g3_fun));
        }
      }

      /* path info */
      ssSetModelName(rts, "read_g3_fun");
      ssSetPath(rts, "t15_2/Pow. Supply MC 2/read_g3_fun");
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
        ssSetSFcnParam(rts, 0, (mxArray*)t15_2_P.read_g3_fun_P1_Size);
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

    /* Level2 S-Function Block: t15_2/<S1>/read_g3_t_fun (read_gaps_term) */
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
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.read_g3_t_fun));
        }
      }

      /* path info */
      ssSetModelName(rts, "read_g3_t_fun");
      ssSetPath(rts, "t15_2/Pow. Supply MC 2/read_g3_t_fun");
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
        ssSetSFcnParam(rts, 0, (mxArray*)t15_2_P.read_g3_t_fun_P1_Size);
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

    /* Level2 S-Function Block: t15_2/<S1>/read_g4_fun (read_gaps) */
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
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.read_g4_fun));
        }
      }

      /* path info */
      ssSetModelName(rts, "read_g4_fun");
      ssSetPath(rts, "t15_2/Pow. Supply MC 2/read_g4_fun");
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
        ssSetSFcnParam(rts, 0, (mxArray*)t15_2_P.read_g4_fun_P1_Size);
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

    /* Level2 S-Function Block: t15_2/<S1>/read_g4_t_fun (read_gaps_term) */
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
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.read_g4_t_fun));
        }
      }

      /* path info */
      ssSetModelName(rts, "read_g4_t_fun");
      ssSetPath(rts, "t15_2/Pow. Supply MC 2/read_g4_t_fun");
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
        ssSetSFcnParam(rts, 0, (mxArray*)t15_2_P.read_g4_t_fun_P1_Size);
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

    /* Level2 S-Function Block: t15_2/<S1>/read_g5_fun (read_gaps) */
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
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.read_g5_fun));
        }
      }

      /* path info */
      ssSetModelName(rts, "read_g5_fun");
      ssSetPath(rts, "t15_2/Pow. Supply MC 2/read_g5_fun");
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
        ssSetSFcnParam(rts, 0, (mxArray*)t15_2_P.read_g5_fun_P1_Size);
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

    /* Level2 S-Function Block: t15_2/<S1>/read_g5_t_fun (read_gaps_term) */
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
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.read_g5_t_fun));
        }
      }

      /* path info */
      ssSetModelName(rts, "read_g5_t_fun");
      ssSetPath(rts, "t15_2/Pow. Supply MC 2/read_g5_t_fun");
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
        ssSetSFcnParam(rts, 0, (mxArray*)t15_2_P.read_g5_t_fun_P1_Size);
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

    /* Level2 S-Function Block: t15_2/<S1>/read_g6_fun (read_gaps) */
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
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.read_g6_fun));
        }
      }

      /* path info */
      ssSetModelName(rts, "read_g6_fun");
      ssSetPath(rts, "t15_2/Pow. Supply MC 2/read_g6_fun");
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
        ssSetSFcnParam(rts, 0, (mxArray*)t15_2_P.read_g6_fun_P1_Size);
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

    /* Level2 S-Function Block: t15_2/<S1>/read_g6_t_fun (read_gaps_term) */
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
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.read_g6_t_fun));
        }
      }

      /* path info */
      ssSetModelName(rts, "read_g6_t_fun");
      ssSetPath(rts, "t15_2/Pow. Supply MC 2/read_g6_t_fun");
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
        ssSetSFcnParam(rts, 0, (mxArray*)t15_2_P.read_g6_t_fun_P1_Size);
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

    /* Level2 S-Function Block: t15_2/<S1>/read_scr_fun (pf_lookup3) */
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
          int_T *dimensions = (int_T *) &t15_2_M->NonInlinedSFcns.Sfcn16.oDims0;
          dimensions[0] = 13;
          dimensions[1] = 500;
          _ssSetOutputPortDimensionsPtr(rts, 0, dimensions);
          _ssSetOutputPortNumDimensions(rts, 0, 2);
          ssSetOutputPortWidth(rts, 0, 6500);
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.read_scr_fun));
        }
      }

      /* path info */
      ssSetModelName(rts, "read_scr_fun");
      ssSetPath(rts, "t15_2/Pow. Supply MC 2/read_scr_fun");
      ssSetRTModel(rts,t15_2_M);
      ssSetParentSS(rts, (NULL));
      ssSetRootSS(rts, rts);
      ssSetVersion(rts, SIMSTRUCT_VERSION_LEVEL2);

      /* parameters */
      {
        mxArray **sfcnParams = (mxArray **)
          &t15_2_M->NonInlinedSFcns.Sfcn16.params;
        ssSetSFcnParamsCount(rts, 1);
        ssSetSFcnParamsPtr(rts, &sfcnParams[0]);
        ssSetSFcnParam(rts, 0, (mxArray*)t15_2_P.read_scr_fun_P1_Size);
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

    /* Level2 S-Function Block: t15_2/<S107>/S-Function (contr_lim) */
    {
      SimStruct *rts = t15_2_M->childSfunctions[17];

      /* timing info */
      time_T *sfcnPeriod = t15_2_M->NonInlinedSFcns.Sfcn17.sfcnPeriod;
      time_T *sfcnOffset = t15_2_M->NonInlinedSFcns.Sfcn17.sfcnOffset;
      int_T *sfcnTsMap = t15_2_M->NonInlinedSFcns.Sfcn17.sfcnTsMap;
      (void) memset((void*)sfcnPeriod, 0,
                    sizeof(time_T)*1);
      (void) memset((void*)sfcnOffset, 0,
                    sizeof(time_T)*1);
      ssSetSampleTimePtr(rts, &sfcnPeriod[0]);
      ssSetOffsetTimePtr(rts, &sfcnOffset[0]);
      ssSetSampleTimeTaskIDPtr(rts, sfcnTsMap);

      /* Set up the mdlInfo pointer */
      {
        ssSetBlkInfo2Ptr(rts, &t15_2_M->NonInlinedSFcns.blkInfo2[17]);
      }

      ssSetRTWSfcnInfo(rts, t15_2_M->sfcnInfo);

      /* Allocate memory of model methods 2 */
      {
        ssSetModelMethods2(rts, &t15_2_M->NonInlinedSFcns.methods2[17]);
      }

      /* Allocate memory of model methods 3 */
      {
        ssSetModelMethods3(rts, &t15_2_M->NonInlinedSFcns.methods3[17]);
      }

      /* Allocate memory for states auxilliary information */
      {
        ssSetStatesInfo2(rts, &t15_2_M->NonInlinedSFcns.statesInfo2[17]);
      }

      /* inputs */
      {
        _ssSetNumInputPorts(rts, 1);
        ssSetPortInfoForInputs(rts,
          &t15_2_M->NonInlinedSFcns.Sfcn17.inputPortInfo[0]);

        /* port 0 */
        {
          ssSetInputPortRequiredContiguous(rts, 0, 1);
          ssSetInputPortSignal(rts, 0, t15_2_B.Divide12_k);
          _ssSetInputPortNumDimensions(rts, 0, 1);
          ssSetInputPortWidth(rts, 0, 20);
        }
      }

      /* outputs */
      {
        ssSetPortInfoForOutputs(rts,
          &t15_2_M->NonInlinedSFcns.Sfcn17.outputPortInfo[0]);
        _ssSetNumOutputPorts(rts, 1);

        /* port 0 */
        {
          _ssSetOutputPortNumDimensions(rts, 0, 1);
          ssSetOutputPortWidth(rts, 0, 20);
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.SFunction));
        }
      }

      /* states */
      ssSetDiscStates(rts, (real_T *) &t15_2_DWork.SFunction_DSTATE[0]);

      /* path info */
      ssSetModelName(rts, "S-Function");
      ssSetPath(rts,
                "t15_2/Pow. Supply MC 2/kavin_contr/Control1/controllers/Lim. contr.1/Lim. contr./S-Function");
      ssSetRTModel(rts,t15_2_M);
      ssSetParentSS(rts, (NULL));
      ssSetRootSS(rts, rts);
      ssSetVersion(rts, SIMSTRUCT_VERSION_LEVEL2);

      /* parameters */
      {
        mxArray **sfcnParams = (mxArray **)
          &t15_2_M->NonInlinedSFcns.Sfcn17.params;
        ssSetSFcnParamsCount(rts, 2);
        ssSetSFcnParamsPtr(rts, &sfcnParams[0]);
        ssSetSFcnParam(rts, 0, (mxArray*)t15_2_P.SFunction_P1_Size);
        ssSetSFcnParam(rts, 1, (mxArray*)t15_2_P.SFunction_P2_Size);
      }

      /* work vectors */
      {
        struct _ssDWorkRecord *dWorkRecord = (struct _ssDWorkRecord *)
          &t15_2_M->NonInlinedSFcns.Sfcn17.dWork;
        struct _ssDWorkAuxRecord *dWorkAuxRecord = (struct _ssDWorkAuxRecord *)
          &t15_2_M->NonInlinedSFcns.Sfcn17.dWorkAux;
        ssSetSFcnDWork(rts, dWorkRecord);
        ssSetSFcnDWorkAux(rts, dWorkAuxRecord);
        _ssSetNumDWork(rts, 1);

        /* DSTATE */
        ssSetDWorkWidth(rts, 0, 50);
        ssSetDWorkDataType(rts, 0,SS_DOUBLE);
        ssSetDWorkComplexSignal(rts, 0, 0);
        ssSetDWorkUsedAsDState(rts, 0, 1);
        ssSetDWork(rts, 0, &t15_2_DWork.SFunction_DSTATE[0]);
      }

      /* registration */
      contr_lim(rts);
      sfcnInitializeSizes(rts);
      sfcnInitializeSampleTimes(rts);

      /* adjust sample time */
      ssSetSampleTime(rts, 0, 0.002);
      ssSetOffsetTime(rts, 0, 0.0);
      sfcnTsMap[0] = 0;

      /* set compiled values of dynamic vector attributes */
      ssSetNumNonsampledZCs(rts, 0);

      /* Update connectivity flags for each port */
      _ssSetInputPortConnected(rts, 0, 1);
      _ssSetOutputPortConnected(rts, 0, 1);
      _ssSetOutputPortBeingMerged(rts, 0, 0);

      /* Update the BufferDstPort flags for each input port */
      ssSetInputPortBufferDstPort(rts, 0, -1);
    }

    /* Level2 S-Function Block: t15_2/<S106>/S-Function (contr_curr) */
    {
      SimStruct *rts = t15_2_M->childSfunctions[18];

      /* timing info */
      time_T *sfcnPeriod = t15_2_M->NonInlinedSFcns.Sfcn18.sfcnPeriod;
      time_T *sfcnOffset = t15_2_M->NonInlinedSFcns.Sfcn18.sfcnOffset;
      int_T *sfcnTsMap = t15_2_M->NonInlinedSFcns.Sfcn18.sfcnTsMap;
      (void) memset((void*)sfcnPeriod, 0,
                    sizeof(time_T)*1);
      (void) memset((void*)sfcnOffset, 0,
                    sizeof(time_T)*1);
      ssSetSampleTimePtr(rts, &sfcnPeriod[0]);
      ssSetOffsetTimePtr(rts, &sfcnOffset[0]);
      ssSetSampleTimeTaskIDPtr(rts, sfcnTsMap);

      /* Set up the mdlInfo pointer */
      {
        ssSetBlkInfo2Ptr(rts, &t15_2_M->NonInlinedSFcns.blkInfo2[18]);
      }

      ssSetRTWSfcnInfo(rts, t15_2_M->sfcnInfo);

      /* Allocate memory of model methods 2 */
      {
        ssSetModelMethods2(rts, &t15_2_M->NonInlinedSFcns.methods2[18]);
      }

      /* Allocate memory of model methods 3 */
      {
        ssSetModelMethods3(rts, &t15_2_M->NonInlinedSFcns.methods3[18]);
      }

      /* Allocate memory for states auxilliary information */
      {
        ssSetStatesInfo2(rts, &t15_2_M->NonInlinedSFcns.statesInfo2[18]);
      }

      /* inputs */
      {
        _ssSetNumInputPorts(rts, 1);
        ssSetPortInfoForInputs(rts,
          &t15_2_M->NonInlinedSFcns.Sfcn18.inputPortInfo[0]);

        /* port 0 */
        {
          ssSetInputPortRequiredContiguous(rts, 0, 1);
          ssSetInputPortSignal(rts, 0, t15_2_B.Gain);
          _ssSetInputPortNumDimensions(rts, 0, 1);
          ssSetInputPortWidth(rts, 0, 20);
        }
      }

      /* outputs */
      {
        ssSetPortInfoForOutputs(rts,
          &t15_2_M->NonInlinedSFcns.Sfcn18.outputPortInfo[0]);
        _ssSetNumOutputPorts(rts, 1);

        /* port 0 */
        {
          _ssSetOutputPortNumDimensions(rts, 0, 1);
          ssSetOutputPortWidth(rts, 0, 20);
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.SFunction_m));
        }
      }

      /* states */
      ssSetDiscStates(rts, (real_T *) &t15_2_DWork.SFunction_DSTATE_j[0]);

      /* path info */
      ssSetModelName(rts, "S-Function");
      ssSetPath(rts,
                "t15_2/Pow. Supply MC 2/kavin_contr/Control1/controllers/Lim. contr.1/Curr. contr./S-Function");
      ssSetRTModel(rts,t15_2_M);
      ssSetParentSS(rts, (NULL));
      ssSetRootSS(rts, rts);
      ssSetVersion(rts, SIMSTRUCT_VERSION_LEVEL2);

      /* parameters */
      {
        mxArray **sfcnParams = (mxArray **)
          &t15_2_M->NonInlinedSFcns.Sfcn18.params;
        ssSetSFcnParamsCount(rts, 3);
        ssSetSFcnParamsPtr(rts, &sfcnParams[0]);
        ssSetSFcnParam(rts, 0, (mxArray*)t15_2_P.SFunction_P1_Size_f);
        ssSetSFcnParam(rts, 1, (mxArray*)t15_2_P.SFunction_P2_Size_g);
        ssSetSFcnParam(rts, 2, (mxArray*)t15_2_P.SFunction_P3_Size);
      }

      /* work vectors */
      {
        struct _ssDWorkRecord *dWorkRecord = (struct _ssDWorkRecord *)
          &t15_2_M->NonInlinedSFcns.Sfcn18.dWork;
        struct _ssDWorkAuxRecord *dWorkAuxRecord = (struct _ssDWorkAuxRecord *)
          &t15_2_M->NonInlinedSFcns.Sfcn18.dWorkAux;
        ssSetSFcnDWork(rts, dWorkRecord);
        ssSetSFcnDWorkAux(rts, dWorkAuxRecord);
        _ssSetNumDWork(rts, 1);

        /* DSTATE */
        ssSetDWorkWidth(rts, 0, 50);
        ssSetDWorkDataType(rts, 0,SS_DOUBLE);
        ssSetDWorkComplexSignal(rts, 0, 0);
        ssSetDWorkUsedAsDState(rts, 0, 1);
        ssSetDWork(rts, 0, &t15_2_DWork.SFunction_DSTATE_j[0]);
      }

      /* registration */
      contr_curr(rts);
      sfcnInitializeSizes(rts);
      sfcnInitializeSampleTimes(rts);

      /* adjust sample time */
      ssSetSampleTime(rts, 0, 0.002);
      ssSetOffsetTime(rts, 0, 0.0);
      sfcnTsMap[0] = 0;

      /* set compiled values of dynamic vector attributes */
      ssSetNumNonsampledZCs(rts, 0);

      /* Update connectivity flags for each port */
      _ssSetInputPortConnected(rts, 0, 1);
      _ssSetOutputPortConnected(rts, 0, 1);
      _ssSetOutputPortBeingMerged(rts, 0, 0);

      /* Update the BufferDstPort flags for each input port */
      ssSetInputPortBufferDstPort(rts, 0, -1);
    }

    /* Level2 S-Function Block: t15_2/<S103>/S-Function (contr_div) */
    {
      SimStruct *rts = t15_2_M->childSfunctions[19];

      /* timing info */
      time_T *sfcnPeriod = t15_2_M->NonInlinedSFcns.Sfcn19.sfcnPeriod;
      time_T *sfcnOffset = t15_2_M->NonInlinedSFcns.Sfcn19.sfcnOffset;
      int_T *sfcnTsMap = t15_2_M->NonInlinedSFcns.Sfcn19.sfcnTsMap;
      (void) memset((void*)sfcnPeriod, 0,
                    sizeof(time_T)*1);
      (void) memset((void*)sfcnOffset, 0,
                    sizeof(time_T)*1);
      ssSetSampleTimePtr(rts, &sfcnPeriod[0]);
      ssSetOffsetTimePtr(rts, &sfcnOffset[0]);
      ssSetSampleTimeTaskIDPtr(rts, sfcnTsMap);

      /* Set up the mdlInfo pointer */
      {
        ssSetBlkInfo2Ptr(rts, &t15_2_M->NonInlinedSFcns.blkInfo2[19]);
      }

      ssSetRTWSfcnInfo(rts, t15_2_M->sfcnInfo);

      /* Allocate memory of model methods 2 */
      {
        ssSetModelMethods2(rts, &t15_2_M->NonInlinedSFcns.methods2[19]);
      }

      /* Allocate memory of model methods 3 */
      {
        ssSetModelMethods3(rts, &t15_2_M->NonInlinedSFcns.methods3[19]);
      }

      /* Allocate memory for states auxilliary information */
      {
        ssSetStatesInfo2(rts, &t15_2_M->NonInlinedSFcns.statesInfo2[19]);
      }

      /* inputs */
      {
        _ssSetNumInputPorts(rts, 1);
        ssSetPortInfoForInputs(rts,
          &t15_2_M->NonInlinedSFcns.Sfcn19.inputPortInfo[0]);

        /* port 0 */
        {
          ssSetInputPortRequiredContiguous(rts, 0, 1);
          ssSetInputPortSignal(rts, 0, t15_2_B.Divide2);
          _ssSetInputPortNumDimensions(rts, 0, 1);
          ssSetInputPortWidth(rts, 0, 20);
        }
      }

      /* outputs */
      {
        ssSetPortInfoForOutputs(rts,
          &t15_2_M->NonInlinedSFcns.Sfcn19.outputPortInfo[0]);
        _ssSetNumOutputPorts(rts, 1);

        /* port 0 */
        {
          _ssSetOutputPortNumDimensions(rts, 0, 1);
          ssSetOutputPortWidth(rts, 0, 20);
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.SFunction_g));
        }
      }

      /* states */
      ssSetDiscStates(rts, (real_T *) &t15_2_DWork.SFunction_DSTATE_f[0]);

      /* path info */
      ssSetModelName(rts, "S-Function");
      ssSetPath(rts,
                "t15_2/Pow. Supply MC 2/kavin_contr/Control1/controllers/Div. contr/Div. contr./S-Function");
      ssSetRTModel(rts,t15_2_M);
      ssSetParentSS(rts, (NULL));
      ssSetRootSS(rts, rts);
      ssSetVersion(rts, SIMSTRUCT_VERSION_LEVEL2);

      /* parameters */
      {
        mxArray **sfcnParams = (mxArray **)
          &t15_2_M->NonInlinedSFcns.Sfcn19.params;
        ssSetSFcnParamsCount(rts, 3);
        ssSetSFcnParamsPtr(rts, &sfcnParams[0]);
        ssSetSFcnParam(rts, 0, (mxArray*)t15_2_P.SFunction_P1_Size_k);
        ssSetSFcnParam(rts, 1, (mxArray*)t15_2_P.SFunction_P2_Size_gz);
        ssSetSFcnParam(rts, 2, (mxArray*)t15_2_P.SFunction_P3_Size_e);
      }

      /* work vectors */
      {
        struct _ssDWorkRecord *dWorkRecord = (struct _ssDWorkRecord *)
          &t15_2_M->NonInlinedSFcns.Sfcn19.dWork;
        struct _ssDWorkAuxRecord *dWorkAuxRecord = (struct _ssDWorkAuxRecord *)
          &t15_2_M->NonInlinedSFcns.Sfcn19.dWorkAux;
        ssSetSFcnDWork(rts, dWorkRecord);
        ssSetSFcnDWorkAux(rts, dWorkAuxRecord);
        _ssSetNumDWork(rts, 1);

        /* DSTATE */
        ssSetDWorkWidth(rts, 0, 50);
        ssSetDWorkDataType(rts, 0,SS_DOUBLE);
        ssSetDWorkComplexSignal(rts, 0, 0);
        ssSetDWorkUsedAsDState(rts, 0, 1);
        ssSetDWork(rts, 0, &t15_2_DWork.SFunction_DSTATE_f[0]);
      }

      /* registration */
      contr_div(rts);
      sfcnInitializeSizes(rts);
      sfcnInitializeSampleTimes(rts);

      /* adjust sample time */
      ssSetSampleTime(rts, 0, 0.002);
      ssSetOffsetTime(rts, 0, 0.0);
      sfcnTsMap[0] = 0;

      /* set compiled values of dynamic vector attributes */
      ssSetNumNonsampledZCs(rts, 0);

      /* Update connectivity flags for each port */
      _ssSetInputPortConnected(rts, 0, 1);
      _ssSetOutputPortConnected(rts, 0, 1);
      _ssSetOutputPortBeingMerged(rts, 0, 0);

      /* Update the BufferDstPort flags for each input port */
      ssSetInputPortBufferDstPort(rts, 0, -1);
    }

    /* Level2 S-Function Block: t15_2/<S101>/S-Function (contr_div) */
    {
      SimStruct *rts = t15_2_M->childSfunctions[20];

      /* timing info */
      time_T *sfcnPeriod = t15_2_M->NonInlinedSFcns.Sfcn20.sfcnPeriod;
      time_T *sfcnOffset = t15_2_M->NonInlinedSFcns.Sfcn20.sfcnOffset;
      int_T *sfcnTsMap = t15_2_M->NonInlinedSFcns.Sfcn20.sfcnTsMap;
      (void) memset((void*)sfcnPeriod, 0,
                    sizeof(time_T)*1);
      (void) memset((void*)sfcnOffset, 0,
                    sizeof(time_T)*1);
      ssSetSampleTimePtr(rts, &sfcnPeriod[0]);
      ssSetOffsetTimePtr(rts, &sfcnOffset[0]);
      ssSetSampleTimeTaskIDPtr(rts, sfcnTsMap);

      /* Set up the mdlInfo pointer */
      {
        ssSetBlkInfo2Ptr(rts, &t15_2_M->NonInlinedSFcns.blkInfo2[20]);
      }

      ssSetRTWSfcnInfo(rts, t15_2_M->sfcnInfo);

      /* Allocate memory of model methods 2 */
      {
        ssSetModelMethods2(rts, &t15_2_M->NonInlinedSFcns.methods2[20]);
      }

      /* Allocate memory of model methods 3 */
      {
        ssSetModelMethods3(rts, &t15_2_M->NonInlinedSFcns.methods3[20]);
      }

      /* Allocate memory for states auxilliary information */
      {
        ssSetStatesInfo2(rts, &t15_2_M->NonInlinedSFcns.statesInfo2[20]);
      }

      /* inputs */
      {
        _ssSetNumInputPorts(rts, 1);
        ssSetPortInfoForInputs(rts,
          &t15_2_M->NonInlinedSFcns.Sfcn20.inputPortInfo[0]);

        /* port 0 */
        {
          ssSetInputPortRequiredContiguous(rts, 0, 1);
          ssSetInputPortSignal(rts, 0, t15_2_B.Divide4);
          _ssSetInputPortNumDimensions(rts, 0, 1);
          ssSetInputPortWidth(rts, 0, 20);
        }
      }

      /* outputs */
      {
        ssSetPortInfoForOutputs(rts,
          &t15_2_M->NonInlinedSFcns.Sfcn20.outputPortInfo[0]);
        _ssSetNumOutputPorts(rts, 1);

        /* port 0 */
        {
          _ssSetOutputPortNumDimensions(rts, 0, 1);
          ssSetOutputPortWidth(rts, 0, 20);
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.SFunction_g3));
        }
      }

      /* states */
      ssSetDiscStates(rts, (real_T *) &t15_2_DWork.SFunction_DSTATE_a[0]);

      /* path info */
      ssSetModelName(rts, "S-Function");
      ssSetPath(rts,
                "t15_2/Pow. Supply MC 2/kavin_contr/Control1/controllers/Div rd contr/Div_rd contr/S-Function");
      ssSetRTModel(rts,t15_2_M);
      ssSetParentSS(rts, (NULL));
      ssSetRootSS(rts, rts);
      ssSetVersion(rts, SIMSTRUCT_VERSION_LEVEL2);

      /* parameters */
      {
        mxArray **sfcnParams = (mxArray **)
          &t15_2_M->NonInlinedSFcns.Sfcn20.params;
        ssSetSFcnParamsCount(rts, 3);
        ssSetSFcnParamsPtr(rts, &sfcnParams[0]);
        ssSetSFcnParam(rts, 0, (mxArray*)t15_2_P.SFunction_P1_Size_kj);
        ssSetSFcnParam(rts, 1, (mxArray*)t15_2_P.SFunction_P2_Size_p);
        ssSetSFcnParam(rts, 2, (mxArray*)t15_2_P.SFunction_P3_Size_m);
      }

      /* work vectors */
      {
        struct _ssDWorkRecord *dWorkRecord = (struct _ssDWorkRecord *)
          &t15_2_M->NonInlinedSFcns.Sfcn20.dWork;
        struct _ssDWorkAuxRecord *dWorkAuxRecord = (struct _ssDWorkAuxRecord *)
          &t15_2_M->NonInlinedSFcns.Sfcn20.dWorkAux;
        ssSetSFcnDWork(rts, dWorkRecord);
        ssSetSFcnDWorkAux(rts, dWorkAuxRecord);
        _ssSetNumDWork(rts, 1);

        /* DSTATE */
        ssSetDWorkWidth(rts, 0, 50);
        ssSetDWorkDataType(rts, 0,SS_DOUBLE);
        ssSetDWorkComplexSignal(rts, 0, 0);
        ssSetDWorkUsedAsDState(rts, 0, 1);
        ssSetDWork(rts, 0, &t15_2_DWork.SFunction_DSTATE_a[0]);
      }

      /* registration */
      contr_div(rts);
      sfcnInitializeSizes(rts);
      sfcnInitializeSampleTimes(rts);

      /* adjust sample time */
      ssSetSampleTime(rts, 0, 0.002);
      ssSetOffsetTime(rts, 0, 0.0);
      sfcnTsMap[0] = 0;

      /* set compiled values of dynamic vector attributes */
      ssSetNumNonsampledZCs(rts, 0);

      /* Update connectivity flags for each port */
      _ssSetInputPortConnected(rts, 0, 1);
      _ssSetOutputPortConnected(rts, 0, 1);
      _ssSetOutputPortBeingMerged(rts, 0, 0);

      /* Update the BufferDstPort flags for each input port */
      ssSetInputPortBufferDstPort(rts, 0, -1);
    }

    /* Level2 S-Function Block: t15_2/<S111>/S-Function (contr_curr) */
    {
      SimStruct *rts = t15_2_M->childSfunctions[21];

      /* timing info */
      time_T *sfcnPeriod = t15_2_M->NonInlinedSFcns.Sfcn21.sfcnPeriod;
      time_T *sfcnOffset = t15_2_M->NonInlinedSFcns.Sfcn21.sfcnOffset;
      int_T *sfcnTsMap = t15_2_M->NonInlinedSFcns.Sfcn21.sfcnTsMap;
      (void) memset((void*)sfcnPeriod, 0,
                    sizeof(time_T)*1);
      (void) memset((void*)sfcnOffset, 0,
                    sizeof(time_T)*1);
      ssSetSampleTimePtr(rts, &sfcnPeriod[0]);
      ssSetOffsetTimePtr(rts, &sfcnOffset[0]);
      ssSetSampleTimeTaskIDPtr(rts, sfcnTsMap);

      /* Set up the mdlInfo pointer */
      {
        ssSetBlkInfo2Ptr(rts, &t15_2_M->NonInlinedSFcns.blkInfo2[21]);
      }

      ssSetRTWSfcnInfo(rts, t15_2_M->sfcnInfo);

      /* Allocate memory of model methods 2 */
      {
        ssSetModelMethods2(rts, &t15_2_M->NonInlinedSFcns.methods2[21]);
      }

      /* Allocate memory of model methods 3 */
      {
        ssSetModelMethods3(rts, &t15_2_M->NonInlinedSFcns.methods3[21]);
      }

      /* Allocate memory for states auxilliary information */
      {
        ssSetStatesInfo2(rts, &t15_2_M->NonInlinedSFcns.statesInfo2[21]);
      }

      /* inputs */
      {
        _ssSetNumInputPorts(rts, 1);
        ssSetPortInfoForInputs(rts,
          &t15_2_M->NonInlinedSFcns.Sfcn21.inputPortInfo[0]);

        /* port 0 */
        {
          int_T *dimensions = (int_T *) &t15_2_M->NonInlinedSFcns.Sfcn21.iDims0;
          ssSetInputPortRequiredContiguous(rts, 0, 1);
          ssSetInputPortSignal(rts, 0, t15_2_B.Divide12_b);
          dimensions[0] = 20;
          dimensions[1] = 1;
          _ssSetInputPortDimensionsPtr(rts, 0, dimensions);
          _ssSetInputPortNumDimensions(rts, 0, 2);
          ssSetInputPortWidth(rts, 0, 20);
        }
      }

      /* outputs */
      {
        ssSetPortInfoForOutputs(rts,
          &t15_2_M->NonInlinedSFcns.Sfcn21.outputPortInfo[0]);
        _ssSetNumOutputPorts(rts, 1);

        /* port 0 */
        {
          int_T *dimensions = (int_T *) &t15_2_M->NonInlinedSFcns.Sfcn21.oDims0;
          dimensions[0] = 20;
          dimensions[1] = 1;
          _ssSetOutputPortDimensionsPtr(rts, 0, dimensions);
          _ssSetOutputPortNumDimensions(rts, 0, 2);
          ssSetOutputPortWidth(rts, 0, 20);
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.SFunction_a));
        }
      }

      /* states */
      ssSetDiscStates(rts, (real_T *) &t15_2_DWork.SFunction_DSTATE_ay[0]);

      /* path info */
      ssSetModelName(rts, "S-Function");
      ssSetPath(rts,
                "t15_2/Pow. Supply MC 2/kavin_contr/Control1/controllers/curr term contr/Curr. term. contr/S-Function");
      ssSetRTModel(rts,t15_2_M);
      ssSetParentSS(rts, (NULL));
      ssSetRootSS(rts, rts);
      ssSetVersion(rts, SIMSTRUCT_VERSION_LEVEL2);

      /* parameters */
      {
        mxArray **sfcnParams = (mxArray **)
          &t15_2_M->NonInlinedSFcns.Sfcn21.params;
        ssSetSFcnParamsCount(rts, 3);
        ssSetSFcnParamsPtr(rts, &sfcnParams[0]);
        ssSetSFcnParam(rts, 0, (mxArray*)t15_2_P.SFunction_P1_Size_a);
        ssSetSFcnParam(rts, 1, (mxArray*)t15_2_P.SFunction_P2_Size_b);
        ssSetSFcnParam(rts, 2, (mxArray*)t15_2_P.SFunction_P3_Size_a);
      }

      /* work vectors */
      {
        struct _ssDWorkRecord *dWorkRecord = (struct _ssDWorkRecord *)
          &t15_2_M->NonInlinedSFcns.Sfcn21.dWork;
        struct _ssDWorkAuxRecord *dWorkAuxRecord = (struct _ssDWorkAuxRecord *)
          &t15_2_M->NonInlinedSFcns.Sfcn21.dWorkAux;
        ssSetSFcnDWork(rts, dWorkRecord);
        ssSetSFcnDWorkAux(rts, dWorkAuxRecord);
        _ssSetNumDWork(rts, 1);

        /* DSTATE */
        ssSetDWorkWidth(rts, 0, 50);
        ssSetDWorkDataType(rts, 0,SS_DOUBLE);
        ssSetDWorkComplexSignal(rts, 0, 0);
        ssSetDWorkUsedAsDState(rts, 0, 1);
        ssSetDWork(rts, 0, &t15_2_DWork.SFunction_DSTATE_ay[0]);
      }

      /* registration */
      contr_curr(rts);
      sfcnInitializeSizes(rts);
      sfcnInitializeSampleTimes(rts);

      /* adjust sample time */
      ssSetSampleTime(rts, 0, 0.002);
      ssSetOffsetTime(rts, 0, 0.0);
      sfcnTsMap[0] = 0;

      /* set compiled values of dynamic vector attributes */
      ssSetNumNonsampledZCs(rts, 0);

      /* Update connectivity flags for each port */
      _ssSetInputPortConnected(rts, 0, 1);
      _ssSetOutputPortConnected(rts, 0, 1);
      _ssSetOutputPortBeingMerged(rts, 0, 0);

      /* Update the BufferDstPort flags for each input port */
      ssSetInputPortBufferDstPort(rts, 0, -1);
    }

    /* Level2 S-Function Block: t15_2/<S88>/S-Function (contr_vert_vs3) */
    {
      SimStruct *rts = t15_2_M->childSfunctions[22];

      /* timing info */
      time_T *sfcnPeriod = t15_2_M->NonInlinedSFcns.Sfcn22.sfcnPeriod;
      time_T *sfcnOffset = t15_2_M->NonInlinedSFcns.Sfcn22.sfcnOffset;
      int_T *sfcnTsMap = t15_2_M->NonInlinedSFcns.Sfcn22.sfcnTsMap;
      (void) memset((void*)sfcnPeriod, 0,
                    sizeof(time_T)*1);
      (void) memset((void*)sfcnOffset, 0,
                    sizeof(time_T)*1);
      ssSetSampleTimePtr(rts, &sfcnPeriod[0]);
      ssSetOffsetTimePtr(rts, &sfcnOffset[0]);
      ssSetSampleTimeTaskIDPtr(rts, sfcnTsMap);

      /* Set up the mdlInfo pointer */
      {
        ssSetBlkInfo2Ptr(rts, &t15_2_M->NonInlinedSFcns.blkInfo2[22]);
      }

      ssSetRTWSfcnInfo(rts, t15_2_M->sfcnInfo);

      /* Allocate memory of model methods 2 */
      {
        ssSetModelMethods2(rts, &t15_2_M->NonInlinedSFcns.methods2[22]);
      }

      /* Allocate memory of model methods 3 */
      {
        ssSetModelMethods3(rts, &t15_2_M->NonInlinedSFcns.methods3[22]);
      }

      /* Allocate memory for states auxilliary information */
      {
        ssSetStatesInfo2(rts, &t15_2_M->NonInlinedSFcns.statesInfo2[22]);
      }

      /* inputs */
      {
        _ssSetNumInputPorts(rts, 1);
        ssSetPortInfoForInputs(rts,
          &t15_2_M->NonInlinedSFcns.Sfcn22.inputPortInfo[0]);

        /* port 0 */
        {
          ssSetInputPortRequiredContiguous(rts, 0, 1);
          ssSetInputPortSignal(rts, 0, t15_2_B.eye202);
          _ssSetInputPortNumDimensions(rts, 0, 1);
          ssSetInputPortWidth(rts, 0, 20);
        }
      }

      /* outputs */
      {
        ssSetPortInfoForOutputs(rts,
          &t15_2_M->NonInlinedSFcns.Sfcn22.outputPortInfo[0]);
        _ssSetNumOutputPorts(rts, 1);

        /* port 0 */
        {
          _ssSetOutputPortNumDimensions(rts, 0, 1);
          ssSetOutputPortWidth(rts, 0, 20);
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.SFunction_mf));
        }
      }

      /* states */
      ssSetDiscStates(rts, (real_T *) &t15_2_DWork.SFunction_DSTATE_e[0]);

      /* path info */
      ssSetModelName(rts, "S-Function");
      ssSetPath(rts,
                "t15_2/Pow. Supply MC 2/kavin_contr/Control1/VS control/eob >= 1/VS. contr1/S-Function");
      ssSetRTModel(rts,t15_2_M);
      ssSetParentSS(rts, (NULL));
      ssSetRootSS(rts, rts);
      ssSetVersion(rts, SIMSTRUCT_VERSION_LEVEL2);

      /* parameters */
      {
        mxArray **sfcnParams = (mxArray **)
          &t15_2_M->NonInlinedSFcns.Sfcn22.params;
        ssSetSFcnParamsCount(rts, 3);
        ssSetSFcnParamsPtr(rts, &sfcnParams[0]);
        ssSetSFcnParam(rts, 0, (mxArray*)t15_2_P.SFunction_P1_Size_p);
        ssSetSFcnParam(rts, 1, (mxArray*)t15_2_P.SFunction_P2_Size_p5);
        ssSetSFcnParam(rts, 2, (mxArray*)t15_2_P.SFunction_P3_Size_g);
      }

      /* work vectors */
      {
        struct _ssDWorkRecord *dWorkRecord = (struct _ssDWorkRecord *)
          &t15_2_M->NonInlinedSFcns.Sfcn22.dWork;
        struct _ssDWorkAuxRecord *dWorkAuxRecord = (struct _ssDWorkAuxRecord *)
          &t15_2_M->NonInlinedSFcns.Sfcn22.dWorkAux;
        ssSetSFcnDWork(rts, dWorkRecord);
        ssSetSFcnDWorkAux(rts, dWorkAuxRecord);
        _ssSetNumDWork(rts, 1);

        /* DSTATE */
        ssSetDWorkWidth(rts, 0, 50);
        ssSetDWorkDataType(rts, 0,SS_DOUBLE);
        ssSetDWorkComplexSignal(rts, 0, 0);
        ssSetDWorkUsedAsDState(rts, 0, 1);
        ssSetDWork(rts, 0, &t15_2_DWork.SFunction_DSTATE_e[0]);
      }

      /* registration */
      contr_vert_vs3(rts);
      sfcnInitializeSizes(rts);
      sfcnInitializeSampleTimes(rts);

      /* adjust sample time */
      ssSetSampleTime(rts, 0, 0.002);
      ssSetOffsetTime(rts, 0, 0.0);
      sfcnTsMap[0] = 0;

      /* set compiled values of dynamic vector attributes */
      ssSetNumNonsampledZCs(rts, 0);

      /* Update connectivity flags for each port */
      _ssSetInputPortConnected(rts, 0, 1);
      _ssSetOutputPortConnected(rts, 0, 1);
      _ssSetOutputPortBeingMerged(rts, 0, 0);

      /* Update the BufferDstPort flags for each input port */
      ssSetInputPortBufferDstPort(rts, 0, -1);
    }

    /* Level2 S-Function Block: t15_2/<S83>/S-Function (contr_vert_vs3) */
    {
      SimStruct *rts = t15_2_M->childSfunctions[23];

      /* timing info */
      time_T *sfcnPeriod = t15_2_M->NonInlinedSFcns.Sfcn23.sfcnPeriod;
      time_T *sfcnOffset = t15_2_M->NonInlinedSFcns.Sfcn23.sfcnOffset;
      int_T *sfcnTsMap = t15_2_M->NonInlinedSFcns.Sfcn23.sfcnTsMap;
      (void) memset((void*)sfcnPeriod, 0,
                    sizeof(time_T)*1);
      (void) memset((void*)sfcnOffset, 0,
                    sizeof(time_T)*1);
      ssSetSampleTimePtr(rts, &sfcnPeriod[0]);
      ssSetOffsetTimePtr(rts, &sfcnOffset[0]);
      ssSetSampleTimeTaskIDPtr(rts, sfcnTsMap);

      /* Set up the mdlInfo pointer */
      {
        ssSetBlkInfo2Ptr(rts, &t15_2_M->NonInlinedSFcns.blkInfo2[23]);
      }

      ssSetRTWSfcnInfo(rts, t15_2_M->sfcnInfo);

      /* Allocate memory of model methods 2 */
      {
        ssSetModelMethods2(rts, &t15_2_M->NonInlinedSFcns.methods2[23]);
      }

      /* Allocate memory of model methods 3 */
      {
        ssSetModelMethods3(rts, &t15_2_M->NonInlinedSFcns.methods3[23]);
      }

      /* Allocate memory for states auxilliary information */
      {
        ssSetStatesInfo2(rts, &t15_2_M->NonInlinedSFcns.statesInfo2[23]);
      }

      /* inputs */
      {
        _ssSetNumInputPorts(rts, 1);
        ssSetPortInfoForInputs(rts,
          &t15_2_M->NonInlinedSFcns.Sfcn23.inputPortInfo[0]);

        /* port 0 */
        {
          ssSetInputPortRequiredContiguous(rts, 0, 1);
          ssSetInputPortSignal(rts, 0, t15_2_B.eye202_p);
          _ssSetInputPortNumDimensions(rts, 0, 1);
          ssSetInputPortWidth(rts, 0, 20);
        }
      }

      /* outputs */
      {
        ssSetPortInfoForOutputs(rts,
          &t15_2_M->NonInlinedSFcns.Sfcn23.outputPortInfo[0]);
        _ssSetNumOutputPorts(rts, 1);

        /* port 0 */
        {
          _ssSetOutputPortNumDimensions(rts, 0, 1);
          ssSetOutputPortWidth(rts, 0, 20);
          ssSetOutputPortSignal(rts, 0, ((real_T *) t15_2_B.SFunction_n));
        }
      }

      /* states */
      ssSetDiscStates(rts, (real_T *) &t15_2_DWork.SFunction_DSTATE_k[0]);

      /* path info */
      ssSetModelName(rts, "S-Function");
      ssSetPath(rts,
                "t15_2/Pow. Supply MC 2/kavin_contr/Control1/VS control/eob < 1/VS. contr hl/S-Function");
      ssSetRTModel(rts,t15_2_M);
      ssSetParentSS(rts, (NULL));
      ssSetRootSS(rts, rts);
      ssSetVersion(rts, SIMSTRUCT_VERSION_LEVEL2);

      /* parameters */
      {
        mxArray **sfcnParams = (mxArray **)
          &t15_2_M->NonInlinedSFcns.Sfcn23.params;
        ssSetSFcnParamsCount(rts, 3);
        ssSetSFcnParamsPtr(rts, &sfcnParams[0]);
        ssSetSFcnParam(rts, 0, (mxArray*)t15_2_P.SFunction_P1_Size_h);
        ssSetSFcnParam(rts, 1, (mxArray*)t15_2_P.SFunction_P2_Size_m);
        ssSetSFcnParam(rts, 2, (mxArray*)t15_2_P.SFunction_P3_Size_o);
      }

      /* work vectors */
      {
        struct _ssDWorkRecord *dWorkRecord = (struct _ssDWorkRecord *)
          &t15_2_M->NonInlinedSFcns.Sfcn23.dWork;
        struct _ssDWorkAuxRecord *dWorkAuxRecord = (struct _ssDWorkAuxRecord *)
          &t15_2_M->NonInlinedSFcns.Sfcn23.dWorkAux;
        ssSetSFcnDWork(rts, dWorkRecord);
        ssSetSFcnDWorkAux(rts, dWorkAuxRecord);
        _ssSetNumDWork(rts, 1);

        /* DSTATE */
        ssSetDWorkWidth(rts, 0, 50);
        ssSetDWorkDataType(rts, 0,SS_DOUBLE);
        ssSetDWorkComplexSignal(rts, 0, 0);
        ssSetDWorkUsedAsDState(rts, 0, 1);
        ssSetDWork(rts, 0, &t15_2_DWork.SFunction_DSTATE_k[0]);
      }

      /* registration */
      contr_vert_vs3(rts);
      sfcnInitializeSizes(rts);
      sfcnInitializeSampleTimes(rts);

      /* adjust sample time */
      ssSetSampleTime(rts, 0, 0.002);
      ssSetOffsetTime(rts, 0, 0.0);
      sfcnTsMap[0] = 0;

      /* set compiled values of dynamic vector attributes */
      ssSetNumNonsampledZCs(rts, 0);

      /* Update connectivity flags for each port */
      _ssSetInputPortConnected(rts, 0, 1);
      _ssSetOutputPortConnected(rts, 0, 1);
      _ssSetOutputPortBeingMerged(rts, 0, 0);

      /* Update the BufferDstPort flags for each input port */
      ssSetInputPortBufferDstPort(rts, 0, -1);
    }
  }

  {
    uint32_T tseed;
    int32_T r;
    int32_T t;
    real_T tmin;

    /* Start for UniformRandomNumber: '<S73>/Uniform Random Number' */
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

    /* End of Start for UniformRandomNumber: '<S73>/Uniform Random Number' */
    /* Start for DataStoreMemory: '<S1>/ ' */
    t15_2_DWork.tdiv = t15_2_P._InitialValue;

    /* Start for DataStoreMemory: '<S1>/Data Store Memory10' */
    t15_2_DWork.c_a_tpl1_eob = t15_2_P.DataStoreMemory10_InitialValue;

    /* Start for DataStoreMemory: '<S1>/Data Store Memory11' */
    t15_2_DWork.c_a_tpl2 = t15_2_P.DataStoreMemory11_InitialValue;

    /* Start for DataStoreMemory: '<S1>/Data Store Memory111' */
    t15_2_DWork.tterm = t15_2_P.DataStoreMemory111_InitialValue;

    /* Start for DataStoreMemory: '<S1>/Data Store Memory112' */
    t15_2_DWork.trd = t15_2_P.DataStoreMemory112_InitialValue;

    /* Start for DataStoreMemory: '<S1>/Data Store Memory12' */
    t15_2_DWork.c_a_tpl_min = t15_2_P.DataStoreMemory12_InitialValue;

    /* Start for DataStoreMemory: '<S1>/Data Store Memory13' */
    t15_2_DWork.y0 = t15_2_P.DataStoreMemory13_InitialValue;

    /* Start for DataStoreMemory: '<S1>/Data Store Memory14' */
    t15_2_DWork.c1_y0 = t15_2_P.DataStoreMemory14_InitialValue;

    /* Start for DataStoreMemory: '<S1>/Data Store Memory15' */
    t15_2_DWork.c2_y0 = t15_2_P.DataStoreMemory15_InitialValue;

    /* Start for DataStoreMemory: '<S1>/Data Store Memory16' */
    t15_2_DWork.t_tran2D = t15_2_P.DataStoreMemory16_InitialValue;

    /* Start for DataStoreMemory: '<S1>/Data Store Memory17' */
    t15_2_DWork.max_VS_lim = t15_2_P.DataStoreMemory17_InitialValue;

    /* Start for DataStoreMemory: '<S1>/Data Store Memory18' */
    t15_2_DWork.k_g4 = t15_2_P.DataStoreMemory18_InitialValue;

    /* Start for DataStoreMemory: '<S1>/Data Store Memory19' */
    t15_2_DWork.tcont2 = t15_2_P.DataStoreMemory19_InitialValue;

    /* Start for DataStoreMemory: '<S1>/Data Store Memory20' */
    t15_2_DWork.Ipdiv = t15_2_P.DataStoreMemory20_InitialValue;

    /* Start for DataStoreMemory: '<S1>/Data Store Memory21' */
    t15_2_DWork.ref_ramp = t15_2_P.DataStoreMemory21_InitialValue;

    /* Start for DataStoreMemory: '<S1>/Data Store Memory22' */
    t15_2_DWork.dtcont2 = t15_2_P.DataStoreMemory22_InitialValue;

    /* Start for DataStoreMemory: '<S1>/Data Store Memory23' */
    t15_2_DWork.Ip_rd = t15_2_P.DataStoreMemory23_InitialValue;

    /* Start for DataStoreMemory: '<S1>/Data Store Memory24' */
    t15_2_DWork.trd_ref = t15_2_P.DataStoreMemory24_InitialValue;

    /* Start for DataStoreMemory: '<S1>/Data Store Memory25' */
    t15_2_DWork.Time_stop = t15_2_P.DataStoreMemory25_InitialValue;

    /* Start for DataStoreMemory: '<S1>/Data Store Memory6' */
    t15_2_DWork.c_a_tpl1 = t15_2_P.DataStoreMemory6_InitialValue;

    /* Start for DataStoreMemory: '<S1>/Elong Memory' */
    memcpy(&t15_2_DWork.Elong[0], &t15_2_P.ElongMemory_InitialValue[0], 100U *
           sizeof(real_T));

    /* Start for DataStoreMemory: '<S1>/Imax Memory' */
    memcpy(&t15_2_DWork.Imax[0], &t15_2_P.ImaxMemory_InitialValue[0], 11U *
           sizeof(real_T));

    /* Start for DataStoreMemory: '<S1>/RupRd Memory' */
    for (r = 0; r < 6; r++) {
      t15_2_DWork.RupRd[r] = t15_2_P.RupRdMemory_InitialValue[r];
    }

    /* End of Start for DataStoreMemory: '<S1>/RupRd Memory' */

    /* Start for DataStoreMemory: '<S1>/Tu Memory' */
    t15_2_DWork.Tu = t15_2_P.TuMemory_InitialValue;

    /* Start for DataStoreMemory: '<S1>/VS1 Memory' */
    t15_2_DWork.VS1_up = t15_2_P.VS1Memory_InitialValue;

    /* Start for DataStoreMemory: '<S1>/VS3 Memory' */
    t15_2_DWork.VS3_up = t15_2_P.VS3Memory_InitialValue;

    /* Start for DataStoreMemory: '<S1>/Vcspf Memory' */
    memcpy(&t15_2_DWork.Vcspf_up[0], &t15_2_P.VcspfMemory_InitialValue[0], 11U *
           sizeof(real_T));

    /* Start for DataStoreMemory: '<S1>/Volt Memory' */
    memcpy(&t15_2_DWork.volt[0], &t15_2_P.VoltMemory_InitialValue[0], 10000U *
           sizeof(real_T));

    /* Start for DataStoreMemory: '<S1>/curr Memory' */
    t15_2_DWork.c_cur_max = t15_2_P.currMemory_InitialValue;
    for (r = 0; r < 100; r++) {
      /* Start for DataStoreMemory: '<S1>/g1 Memory' */
      t15_2_DWork.g1[r] = t15_2_P.g1Memory_InitialValue[r];

      /* Start for DataStoreMemory: '<S1>/g1_t Memory' */
      t15_2_DWork.g1_term[r] = t15_2_P.g1_tMemory_InitialValue[r];

      /* Start for DataStoreMemory: '<S1>/g2 Memory' */
      t15_2_DWork.g2[r] = t15_2_P.g2Memory_InitialValue[r];

      /* Start for DataStoreMemory: '<S1>/g2_t Memory' */
      t15_2_DWork.g2_term[r] = t15_2_P.g2_tMemory_InitialValue[r];

      /* Start for DataStoreMemory: '<S1>/g3 Memory' */
      t15_2_DWork.g3[r] = t15_2_P.g3Memory_InitialValue[r];

      /* Start for DataStoreMemory: '<S1>/g3_t Memory' */
      t15_2_DWork.g3_term[r] = t15_2_P.g3_tMemory_InitialValue[r];

      /* Start for DataStoreMemory: '<S1>/g4 Memory' */
      t15_2_DWork.g4[r] = t15_2_P.g4Memory_InitialValue[r];

      /* Start for DataStoreMemory: '<S1>/g4_t Memory' */
      t15_2_DWork.g4_term[r] = t15_2_P.g4_tMemory_InitialValue[r];

      /* Start for DataStoreMemory: '<S1>/g5 Memory' */
      t15_2_DWork.g5[r] = t15_2_P.g5Memory_InitialValue[r];

      /* Start for DataStoreMemory: '<S1>/g5_t Memory' */
      t15_2_DWork.g5_term[r] = t15_2_P.g5_tMemory_InitialValue[r];

      /* Start for DataStoreMemory: '<S1>/g6 Memory' */
      t15_2_DWork.g6[r] = t15_2_P.g6Memory_InitialValue[r];

      /* Start for DataStoreMemory: '<S1>/g6_t Memory' */
      t15_2_DWork.g6_term[r] = t15_2_P.g6_tMemory_InitialValue[r];
    }

    /* Start for DataStoreMemory: '<S1>/ntur Memory' */
    memcpy(&t15_2_DWork.ntur[0], &t15_2_P.nturMemory_InitialValue[0], 12U *
           sizeof(real_T));

    /* Start for DataStoreMemory: '<S1>/scr Memory' */
    memcpy(&t15_2_DWork.scr_data[0], &t15_2_P.scrMemory_InitialValue[0], 6500U *
           sizeof(real_T));
  }

  {
    int32_T i;

    /* InitializeConditions for Memory: '<S21>/Memory1' */
    t15_2_DWork.Memory1_PreviousInput_c = t15_2_P.Memory1_X0_d;

    /* InitializeConditions for Memory: '<S32>/Memory' */
    t15_2_DWork.Memory_PreviousInput = t15_2_P.Memory_X0;

    /* InitializeConditions for Memory: '<S46>/Memory2' */
    t15_2_DWork.Memory2_PreviousInput = t15_2_P.Memory2_X0;

    /* InitializeConditions for Memory: '<S46>/Memory1' */
    t15_2_DWork.Memory1_PreviousInput_l = t15_2_P.Memory1_X0_a;

    /* InitializeConditions for Memory: '<S47>/Memory2' */
    t15_2_DWork.Memory2_PreviousInput_k = t15_2_P.Memory2_X0_d;

    /* InitializeConditions for Memory: '<S47>/Memory1' */
    t15_2_DWork.Memory1_PreviousInput_la = t15_2_P.Memory1_X0_g;

    /* InitializeConditions for Memory: '<S48>/Memory2' */
    t15_2_DWork.Memory2_PreviousInput_i = t15_2_P.Memory2_X0_b;

    /* InitializeConditions for Memory: '<S48>/Memory1' */
    t15_2_DWork.Memory1_PreviousInput_i = t15_2_P.Memory1_X0_f;

    /* InitializeConditions for Memory: '<S49>/Memory2' */
    t15_2_DWork.Memory2_PreviousInput_e = t15_2_P.Memory2_X0_e;

    /* InitializeConditions for Memory: '<S49>/Memory1' */
    t15_2_DWork.Memory1_PreviousInput_f = t15_2_P.Memory1_X0_b;

    /* InitializeConditions for Memory: '<S50>/Memory2' */
    t15_2_DWork.Memory2_PreviousInput_j = t15_2_P.Memory2_X0_f;

    /* InitializeConditions for Memory: '<S50>/Memory1' */
    t15_2_DWork.Memory1_PreviousInput_l5 = t15_2_P.Memory1_X0_l;

    /* InitializeConditions for Memory: '<S51>/Memory2' */
    t15_2_DWork.Memory2_PreviousInput_c = t15_2_P.Memory2_X0_n;

    /* InitializeConditions for Memory: '<S51>/Memory1' */
    t15_2_DWork.Memory1_PreviousInput_k = t15_2_P.Memory1_X0_bs;

    /* InitializeConditions for Memory: '<S22>/Memory1' */
    t15_2_DWork.Memory1_PreviousInput_h = t15_2_P.Memory1_X0_gf;

    /* InitializeConditions for Memory: '<S35>/Memory2' */
    t15_2_DWork.Memory2_PreviousInput_b = t15_2_P.Memory2_X0_fl;

    /* InitializeConditions for Memory: '<S38>/Memory2' */
    t15_2_DWork.Memory2_PreviousInput_d = t15_2_P.Memory2_X0_i;

    /* InitializeConditions for Memory: '<S39>/Memory2' */
    t15_2_DWork.Memory2_PreviousInput_o = t15_2_P.Memory2_X0_fld;

    /* InitializeConditions for Memory: '<S40>/Memory2' */
    t15_2_DWork.Memory2_PreviousInput_jf = t15_2_P.Memory2_X0_du;

    /* InitializeConditions for Memory: '<S41>/Memory2' */
    t15_2_DWork.Memory2_PreviousInput_f = t15_2_P.Memory2_X0_nt;

    /* InitializeConditions for Memory: '<S42>/Memory2' */
    t15_2_DWork.Memory2_PreviousInput_i2 = t15_2_P.Memory2_X0_c;

    /* InitializeConditions for Memory: '<S43>/Memory2' */
    t15_2_DWork.Memory2_PreviousInput_fs = t15_2_P.Memory2_X0_ii;

    /* InitializeConditions for Memory: '<S44>/Memory2' */
    t15_2_DWork.Memory2_PreviousInput_m = t15_2_P.Memory2_X0_j;

    /* InitializeConditions for Memory: '<S45>/Memory2' */
    t15_2_DWork.Memory2_PreviousInput_n = t15_2_P.Memory2_X0_eu;

    /* InitializeConditions for Memory: '<S36>/Memory2' */
    t15_2_DWork.Memory2_PreviousInput_g = t15_2_P.Memory2_X0_er;

    /* InitializeConditions for Memory: '<S37>/Memory2' */
    t15_2_DWork.Memory2_PreviousInput_c4 = t15_2_P.Memory2_X0_ir;

    /* InitializeConditions for Memory: '<S29>/Memory' */
    t15_2_DWork.Memory_PreviousInput_d = t15_2_P.Memory_X0_c;

    /* InitializeConditions for UnitDelay: '<S33>/UD' */
    t15_2_DWork.UD_DSTATE = t15_2_P.UD_InitialCondition;

    /* InitializeConditions for UnitDelay: '<S34>/UD' */
    t15_2_DWork.UD_DSTATE_o = t15_2_P.UD_InitialCondition_c;

    /* InitializeConditions for Memory: '<S60>/Memory' */
    t15_2_DWork.Memory_PreviousInput_o = t15_2_P.Memory_X0_p;

    /* InitializeConditions for Memory: '<S27>/Memory1' */
    t15_2_DWork.Memory1_PreviousInput_kq = t15_2_P.Memory1_X0_m;

    /* InitializeConditions for Memory: '<S64>/Memory' */
    t15_2_DWork.Memory_PreviousInput_f = t15_2_P.Memory_X0_cp;

    /* InitializeConditions for Memory: '<S28>/Memory1' */
    t15_2_DWork.Memory1_PreviousInput_j = t15_2_P.Memory1_X0_n;

    /* InitializeConditions for Memory: '<S30>/Memory1' */
    t15_2_DWork.Memory1_PreviousInput_m = t15_2_P.Memory1_X0_g4;

    /* Level2 S-Function Block: '<S107>/S-Function' (contr_lim) */
    {
      SimStruct *rts = t15_2_M->childSfunctions[17];
      sfcnInitializeConditions(rts);
      if (ssGetErrorStatus(rts) != (NULL))
        return;
    }

    /* Level2 S-Function Block: '<S106>/S-Function' (contr_curr) */
    {
      SimStruct *rts = t15_2_M->childSfunctions[18];
      sfcnInitializeConditions(rts);
      if (ssGetErrorStatus(rts) != (NULL))
        return;
    }

    /* InitializeConditions for Memory: '<S92>/Memory3' */
    t15_2_DWork.Memory3_PreviousInput = t15_2_P.Memory3_X0;
    for (i = 0; i < 11; i++) {
      /* InitializeConditions for Memory: '<S9>/Memory1' */
      t15_2_DWork.Memory1_PreviousInput[i] = t15_2_P.Memory1_X0;

      /* InitializeConditions for Memory: '<S110>/Memory2' */
      t15_2_DWork.Memory2_PreviousInput_kw[i] = t15_2_P.Memory2_X0_m;

      /* InitializeConditions for Memory: '<S100>/Memory1' */
      t15_2_DWork.Memory1_PreviousInput_b[i] = t15_2_P.Memory1_X0_lx;

      /* InitializeConditions for Memory: '<S104>/Memory' */
      t15_2_DWork.Memory_PreviousInput_h[i] = t15_2_P.Memory_X0_g;
    }

    /* Level2 S-Function Block: '<S103>/S-Function' (contr_div) */
    {
      SimStruct *rts = t15_2_M->childSfunctions[19];
      sfcnInitializeConditions(rts);
      if (ssGetErrorStatus(rts) != (NULL))
        return;
    }

    /* InitializeConditions for Memory: '<S113>/Memory1' */
    t15_2_DWork.Memory1_PreviousInput_o = t15_2_P.Memory1_X0_j;

    /* InitializeConditions for Memory: '<S98>/Memory1' */
    t15_2_DWork.Memory1_PreviousInput_p = t15_2_P.Memory1_X0_o;

    /* Level2 S-Function Block: '<S101>/S-Function' (contr_div) */
    {
      SimStruct *rts = t15_2_M->childSfunctions[20];
      sfcnInitializeConditions(rts);
      if (ssGetErrorStatus(rts) != (NULL))
        return;
    }

    /* InitializeConditions for Memory: '<S95>/Memory1' */
    t15_2_DWork.Memory1_PreviousInput_hp = t15_2_P.Memory1_X0_gg;

    /* Level2 S-Function Block: '<S111>/S-Function' (contr_curr) */
    {
      SimStruct *rts = t15_2_M->childSfunctions[21];
      sfcnInitializeConditions(rts);
      if (ssGetErrorStatus(rts) != (NULL))
        return;
    }

    /* InitializeConditions for UnitDelay: '<S78>/UD' */
    t15_2_DWork.UD_DSTATE_a = t15_2_P.UD_InitialCondition_g;

    /* Level2 S-Function Block: '<S88>/S-Function' (contr_vert_vs3) */
    {
      SimStruct *rts = t15_2_M->childSfunctions[22];
      sfcnInitializeConditions(rts);
      if (ssGetErrorStatus(rts) != (NULL))
        return;
    }

    /* Level2 S-Function Block: '<S83>/S-Function' (contr_vert_vs3) */
    {
      SimStruct *rts = t15_2_M->childSfunctions[23];
      sfcnInitializeConditions(rts);
      if (ssGetErrorStatus(rts) != (NULL))
        return;
    }

    /* InitializeConditions for UnitDelay: '<S8>/UD' */
    t15_2_DWork.UD_DSTATE_j = t15_2_P.UD_InitialCondition_f;

    /* InitializeConditions for Memory: '<S18>/Memory2' */
    t15_2_DWork.Memory2_PreviousInput_d0 = t15_2_P.Memory2_X0_a;
  }
}

/* Model terminate function */
void t15_2_terminate(void)
{
  /* Level2 S-Function Block: '<S1>/read_control_data2_fun' (read_control_data2) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[0];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<S1>/read_tt_kavin2_fun' (read_tt_kavin2) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[1];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<S1>/read_elong_fun' (read_gaps) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[2];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<S1>/read_volt_fun' (read_volt) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[3];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<S1>/read_g1_fun' (read_gaps) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[4];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<S1>/read_g1_t_fun' (read_gaps_term) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[5];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<S1>/read_g2_fun' (read_gaps) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[6];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<S1>/read_g2_t_fun' (read_gaps_term) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[7];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<S1>/read_g3_fun' (read_gaps) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[8];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<S1>/read_g3_t_fun' (read_gaps_term) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[9];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<S1>/read_g4_fun' (read_gaps) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[10];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<S1>/read_g4_t_fun' (read_gaps_term) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[11];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<S1>/read_g5_fun' (read_gaps) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[12];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<S1>/read_g5_t_fun' (read_gaps_term) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[13];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<S1>/read_g6_fun' (read_gaps) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[14];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<S1>/read_g6_t_fun' (read_gaps_term) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[15];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<S1>/read_scr_fun' (pf_lookup3) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[16];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<S107>/S-Function' (contr_lim) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[17];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<S106>/S-Function' (contr_curr) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[18];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<S103>/S-Function' (contr_div) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[19];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<S101>/S-Function' (contr_div) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[20];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<S111>/S-Function' (contr_curr) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[21];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<S88>/S-Function' (contr_vert_vs3) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[22];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<S83>/S-Function' (contr_vert_vs3) */
  {
    SimStruct *rts = t15_2_M->childSfunctions[23];
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

//	  { output[i+ki]=0.0 ;
	  { output[i+ki]=t15_2_Y.to_DINA[i] ;
	  k=k+1;
      }

//t15_2_B.Saturation6[i] + t15_2_B.SaturationVS[i];

	  ki=k;

      for (i = 0; i < 12; i++) 
//	  { output[i+ki]=t15_2_B.wz[i] ;
//	  { output[i+ki]=0.0 ;
	  { output[i+ki]=t15_2_Y.to_DINA[i] ;
	  k=k+1;
      }

	  i=11;
//	  output[i+ki]=t15_2_B.wz[i] ;
//	  output[i+ki]=0.0 ;

	  ki=k;

	  nbrOutputArgs=&ki;

	  if( kpr == 1){
  
	  printf("---nbrOutputArgs "
         " and ki "
		 " .  %d %d  \n",*nbrOutputArgs,ki);
	

      for (i = 22; i < ki; i++) 
	  { 	  printf("output "
         " and i "
         " .  %g %d  \n",output[i],i);
      }
      
	  
	  }

}
