/*
 * File: t15_2.h
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

#ifndef RTW_HEADER_t15_2_h_
#define RTW_HEADER_t15_2_h_
#ifndef t15_2_COMMON_INCLUDES_
# define t15_2_COMMON_INCLUDES_
#include <stddef.h>
#include <math.h>
#include <string.h>
#include "rtwtypes.h"
#include "simstruc.h"
#include "sfcn_bridge.h"
#include "fixedpoint.h"
#include "rtGetInf.h"
#include "rtGetNaN.h"
#include "rt_nonfinite.h"
#endif                                 /* t15_2_COMMON_INCLUDES_ */

#include "t15_2_types.h"

/* Macros for accessing real-time model data structure */
#ifndef rtmGetFinalTime
# define rtmGetFinalTime(rtm)          ((rtm)->Timing.tFinal)
#endif

#ifndef rtmGetSampleHitArray
# define rtmGetSampleHitArray(rtm)     ((rtm)->Timing.sampleHitArray)
#endif

#ifndef rtmGetStepSize
# define rtmGetStepSize(rtm)           ((rtm)->Timing.stepSize)
#endif

#ifndef rtmGet_TimeOfLastOutput
# define rtmGet_TimeOfLastOutput(rtm)  ((rtm)->Timing.timeOfLastOutput)
#endif

#ifndef rtmGetErrorStatus
# define rtmGetErrorStatus(rtm)        ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
# define rtmSetErrorStatus(rtm, val)   ((rtm)->errorStatus = (val))
#endif

#ifndef rtmGetStopRequested
# define rtmGetStopRequested(rtm)      ((rtm)->Timing.stopRequestedFlag)
#endif

#ifndef rtmSetStopRequested
# define rtmSetStopRequested(rtm, val) ((rtm)->Timing.stopRequestedFlag = (val))
#endif

#ifndef rtmGetStopRequestedPtr
# define rtmGetStopRequestedPtr(rtm)   (&((rtm)->Timing.stopRequestedFlag))
#endif

#ifndef rtmGetT
# define rtmGetT(rtm)                  (rtmGetTPtr((rtm))[0])
#endif

#ifndef rtmGetTFinal
# define rtmGetTFinal(rtm)             ((rtm)->Timing.tFinal)
#endif

#ifndef rtmGetTStart
# define rtmGetTStart(rtm)             ((rtm)->Timing.tStart)
#endif

#ifndef rtmGetTimeOfLastOutput
# define rtmGetTimeOfLastOutput(rtm)   ((rtm)->Timing.timeOfLastOutput)
#endif

/* Block signals (auto storage) */
typedef struct {
  real_T read_control_data2_fun[17];   /* '<S1>/read_control_data2_fun' */
  real_T read_tt_kavin2_fun[44];       /* '<S1>/read_tt_kavin2_fun' */
  real_T read_elong_fun[100];          /* '<S1>/read_elong_fun' */
  real_T read_volt_fun[10000];         /* '<S1>/read_volt_fun' */
  real_T read_g1_fun[100];             /* '<S1>/read_g1_fun' */
  real_T read_g1_t_fun[100];           /* '<S1>/read_g1_t_fun' */
  real_T read_g2_fun[100];             /* '<S1>/read_g2_fun' */
  real_T read_g2_t_fun[100];           /* '<S1>/read_g2_t_fun' */
  real_T read_g3_fun[100];             /* '<S1>/read_g3_fun' */
  real_T read_g3_t_fun[100];           /* '<S1>/read_g3_t_fun' */
  real_T read_g4_fun[100];             /* '<S1>/read_g4_fun' */
  real_T read_g4_t_fun[100];           /* '<S1>/read_g4_t_fun' */
  real_T read_g5_fun[100];             /* '<S1>/read_g5_fun' */
  real_T read_g5_t_fun[100];           /* '<S1>/read_g5_t_fun' */
  real_T read_g6_fun[100];             /* '<S1>/read_g6_fun' */
  real_T read_g6_t_fun[100];           /* '<S1>/read_g6_t_fun' */
  real_T read_scr_fun[6500];           /* '<S1>/read_scr_fun' */
  real_T DataStoreRead1[11];           /* '<S11>/Data Store Read1' */
  real_T Memory1[11];                  /* '<S9>/Memory1' */
  real_T DataStoreRead1_l[11];         /* '<S10>/Data Store Read1' */
  real_T u[11];                        /* '<S10>/2' */
  real_T DataStoreRead3;               /* '<S10>/Data Store Read3' */
  real_T Divide1[11];                  /* '<S10>/Divide1' */
  real_T DataStoreRead2[11];           /* '<S6>/Data Store Read2' */
  real_T Times;                        /* '<S19>/Time s' */
  real_T e6;                           /* '<S16>/1e-6' */
  real_T e2[6];                        /* '<S26>/1e2' */
  real_T Memory1_j;                    /* '<S21>/Memory1' */
  real_T e6_n[15];                     /* '<S16>/1e-6   ' */
  real_T RupRdRead1;                   /* '<S21>/RupRd Read1' */
  real_T e3;                           /* '<S21>/1e-3' */
  real_T nturRead2;                    /* '<S21>/ntur Read2' */
  real_T Product1;                     /* '<S21>/Product1' */
  real_T RelationalOperator;           /* '<S21>/Relational Operator' */
  real_T Memory;                       /* '<S32>/Memory' */
  real_T LogicalOperator;              /* '<S32>/Logical Operator' */
  real_T switch1;                      /* '<S21>/switch1' */
  real_T Add2;                         /* '<S21>/Add2' */
  real_T DataStoreRead;                /* '<S21>/Data Store Read' */
  real_T Product;                      /* '<S21>/Product' */
  real_T Add1;                         /* '<S21>/Add1' */
  real_T u_b;                          /* '<S21>/1 0' */
  real_T Memory2;                      /* '<S46>/Memory2' */
  real_T c_eob1;                       /* '<S46>/c_eob  1' */
  real_T Memory1_h;                    /* '<S46>/Memory1' */
  real_T c_eob;                        /* '<S46>/c_eob  ' */
  real_T c_eob_c;                      /* '<S46>/c_eob' */
  real_T Add2_i;                       /* '<S26>/Add2' */
  real_T Memory2_b;                    /* '<S47>/Memory2' */
  real_T c_eob1_m;                     /* '<S47>/c_eob  1' */
  real_T Memory1_e;                    /* '<S47>/Memory1' */
  real_T c_eob_p;                      /* '<S47>/c_eob  ' */
  real_T c_eob_k;                      /* '<S47>/c_eob' */
  real_T Add1_c;                       /* '<S26>/Add1' */
  real_T Memory2_f;                    /* '<S48>/Memory2' */
  real_T c_eob1_n;                     /* '<S48>/c_eob  1' */
  real_T Memory1_i;                    /* '<S48>/Memory1' */
  real_T c_eob_l;                      /* '<S48>/c_eob  ' */
  real_T c_eob_o;                      /* '<S48>/c_eob' */
  real_T Add3;                         /* '<S26>/Add3' */
  real_T Memory2_fe;                   /* '<S49>/Memory2' */
  real_T c_eob1_o;                     /* '<S49>/c_eob  1' */
  real_T Memory1_o;                    /* '<S49>/Memory1' */
  real_T c_eob_f;                      /* '<S49>/c_eob  ' */
  real_T c_eob_fx;                     /* '<S49>/c_eob' */
  real_T Add4;                         /* '<S26>/Add4' */
  real_T t_tran2DRead;                 /* '<S26>/t_tran2D Read' */
  real_T tcont2Read;                   /* '<S26>/tcont2 Read' */
  real_T MinMax;                       /* '<S26>/MinMax' */
  real_T RelationalOperator1;          /* '<S26>/Relational Operator1' */
  real_T Divide12;                     /* '<S26>/Divide12' */
  real_T Memory2_fu;                   /* '<S50>/Memory2' */
  real_T c_eob1_b;                     /* '<S50>/c_eob  1' */
  real_T Memory1_n;                    /* '<S50>/Memory1' */
  real_T c_eob_n;                      /* '<S50>/c_eob  ' */
  real_T c_eob_ni;                     /* '<S50>/c_eob' */
  real_T Add5;                         /* '<S26>/Add5' */
  real_T Memory2_g;                    /* '<S51>/Memory2' */
  real_T c_eob1_j;                     /* '<S51>/c_eob  1' */
  real_T Memory1_nl;                   /* '<S51>/Memory1' */
  real_T c_eob_oo;                     /* '<S51>/c_eob  ' */
  real_T c_eob_d;                      /* '<S51>/c_eob' */
  real_T Add6;                         /* '<S26>/Add6' */
  real_T Divide1_c;                    /* '<S26>/Divide1' */
  real_T e2_f[6];                      /* '<S26>/1e-2' */
  real_T Memory1_l;                    /* '<S22>/Memory1' */
  real_T c_eob_d4;                     /* '<S22>/c_eob' */
  real_T Divide6;                      /* '<S22>/Divide6' */
  real_T Add1_p;                       /* '<S16>/Add1' */
  real_T Memory2_m;                    /* '<S35>/Memory2' */
  real_T c_eob_fm;                     /* '<S35>/c_eob' */
  real_T Divide1_n;                    /* '<S35>/Divide1' */
  real_T Add3_i;                       /* '<S25>/Add3' */
  real_T Memory2_n;                    /* '<S38>/Memory2' */
  real_T c_eob_h;                      /* '<S38>/c_eob' */
  real_T Divide1_o;                    /* '<S38>/Divide1' */
  real_T Add1_n;                       /* '<S25>/Add1' */
  real_T Memory2_h;                    /* '<S39>/Memory2' */
  real_T c_eob_pa;                     /* '<S39>/c_eob' */
  real_T Divide1_na;                   /* '<S39>/Divide1' */
  real_T Add2_h;                       /* '<S25>/Add2' */
  real_T Memory2_l;                    /* '<S40>/Memory2' */
  real_T c_eob_l2;                     /* '<S40>/c_eob' */
  real_T Divide1_b;                    /* '<S40>/Divide1' */
  real_T Add4_a;                       /* '<S25>/Add4' */
  real_T Memory2_a;                    /* '<S41>/Memory2' */
  real_T c_eob_hm;                     /* '<S41>/c_eob' */
  real_T Divide1_a;                    /* '<S41>/Divide1' */
  real_T Add5_h;                       /* '<S25>/Add5' */
  real_T Memory2_k;                    /* '<S42>/Memory2' */
  real_T c_eob_hu;                     /* '<S42>/c_eob' */
  real_T Divide1_m;                    /* '<S42>/Divide1' */
  real_T Add6_n;                       /* '<S25>/Add6' */
  real_T Memory2_j;                    /* '<S43>/Memory2' */
  real_T c_eob_m;                      /* '<S43>/c_eob' */
  real_T Divide1_cw;                   /* '<S43>/Divide1' */
  real_T Add7;                         /* '<S25>/Add7' */
  real_T Memory2_p;                    /* '<S44>/Memory2' */
  real_T c_eob_i;                      /* '<S44>/c_eob' */
  real_T Divide1_me;                   /* '<S44>/Divide1' */
  real_T Add8;                         /* '<S25>/Add8' */
  real_T Memory2_aw;                   /* '<S45>/Memory2' */
  real_T c_eob_nt;                     /* '<S45>/c_eob' */
  real_T Divide1_f;                    /* '<S45>/Divide1' */
  real_T Add9;                         /* '<S25>/Add9' */
  real_T Memory2_f5;                   /* '<S36>/Memory2' */
  real_T c_eob_ml;                     /* '<S36>/c_eob' */
  real_T Divide1_mm;                   /* '<S36>/Divide1' */
  real_T Add10;                        /* '<S25>/Add10' */
  real_T Memory2_lp;                   /* '<S37>/Memory2' */
  real_T c_eob_g;                      /* '<S37>/c_eob' */
  real_T Divide1_fg;                   /* '<S37>/Divide1' */
  real_T Add11;                        /* '<S25>/Add11' */
  real_T DataStoreRead1_m;             /* '<S20>/Data Store Read1' */
  real_T Abs;                          /* '<S20>/Abs' */
  real_T RelationalOperator1_a;        /* '<S20>/Relational Operator1' */
  real_T Memory_i;                     /* '<S29>/Memory' */
  real_T LogicalOperator_b;            /* '<S29>/Logical Operator' */
  real_T u_bg;                         /* '<S20>/3' */
  real_T u_m[20];                      /* '<S20>/2' */
  real_T Uk1;                          /* '<S33>/UD' */
  real_T Diff;                         /* '<S33>/Diff' */
  real_T Uk1_g;                        /* '<S34>/UD' */
  real_T Diff_i;                       /* '<S34>/Diff' */
  real_T Divide;                       /* '<S23>/Divide' */
  real_T DataStoreRead2_h;             /* '<S27>/Data Store Read2' */
  real_T Abs_o;                        /* '<S27>/Abs' */
  real_T LogicalOperator1;             /* '<S27>/Logical Operator1' */
  real_T Memory_g;                     /* '<S60>/Memory' */
  real_T LogicalOperator_e;            /* '<S60>/Logical Operator' */
  real_T Memory1_b;                    /* '<S27>/Memory1' */
  real_T LogicalOperator_i;            /* '<S27>/Logical Operator' */
  real_T DataStoreRead_h;              /* '<S63>/Data Store Read' */
  real_T Abs_j;                        /* '<S63>/Abs' */
  real_T LogicalOperator2;             /* '<S28>/Logical Operator2' */
  real_T Memory_p;                     /* '<S64>/Memory' */
  real_T LogicalOperator_k;            /* '<S64>/Logical Operator' */
  real_T Memory1_jw;                   /* '<S28>/Memory1' */
  real_T LogicalOperator_g;            /* '<S28>/Logical Operator' */
  real_T Memory1_p;                    /* '<S30>/Memory1' */
  real_T LogicalOperator_f;            /* '<S30>/Logical Operator' */
  real_T Memory2_d[11];                /* '<S110>/Memory2' */
  real_T DataStoreRead1_l0;            /* '<S110>/Data Store Read1' */
  real_T RelationalOperator1_n;        /* '<S110>/Relational Operator1' */
  real_T DataStoreRead_f;              /* '<S109>/Data Store Read' */
  real_T RelationalOperator_f;         /* '<S109>/Relational Operator' */
  real_T Divide12_k[20];               /* '<S109>/Divide12' */
  real_T SFunction[20];                /* '<S107>/S-Function' */
  real_T DataStoreRead2_a[11];         /* '<S96>/Data Store Read2' */
  real_T Divide1_c5[11];               /* '<S96>/Divide1' */
  real_T e6_l[11];                     /* '<S96>/1e6' */
  real_T Gain[20];                     /* '<S106>/Gain' */
  real_T SFunction_m[20];              /* '<S106>/S-Function' */
  real_T u_bx[11];                     /* '<S110>/ 1 ' */
  real_T DataStoreRead_k;              /* '<S92>/Data Store Read' */
  real_T Memory3;                      /* '<S92>/Memory3' */
  real_T DataStoreRead1_n;             /* '<S92>/Data Store Read1' */
  real_T RelationalOperator1_p;        /* '<S92>/Relational Operator1' */
  real_T switch1_b;                    /* '<S92>/switch1 ' */
  real_T Subtract2;                    /* '<S92>/Subtract2' */
  real_T Divide1_i;                    /* '<S92>/Divide1' */
  real_T Subtract1;                    /* '<S92>/Subtract1' */
  real_T Saturation1;                  /* '<S92>/Saturation1' */
  real_T Divide14[11];                 /* '<S68>/Divide14' */
  real_T Memory1_ps[11];               /* '<S100>/Memory1' */
  real_T DataStoreRead_kw;             /* '<S100>/Data Store Read' */
  real_T Memory_k[11];                 /* '<S104>/Memory' */
  real_T DataStoreRead2_k;             /* '<S104>/Data Store Read2' */
  real_T RelationalOperator2;          /* '<S104>/Relational Operator2' */
  real_T DataStoreRead2_o;             /* '<S105>/Data Store Read2' */
  real_T RelationalOperator1_e;        /* '<S105>/Relational Operator1' */
  real_T Divide2[20];                  /* '<S94>/Divide2' */
  real_T SFunction_g[20];              /* '<S103>/S-Function' */
  real_T Memory1_p5;                   /* '<S113>/Memory1' */
  real_T c_eob_a;                      /* '<S113>/c_eob' */
  real_T c_eob_ay;                     /* '<S99>/c_eob' */
  real_T u_g[11];                      /* '<S104>/1' */
  real_T Memory1_h0;                   /* '<S98>/Memory1' */
  real_T DataStoreRead2_j;             /* '<S98>/Data Store Read2' */
  real_T RelationalOperator2_a;        /* '<S98>/Relational Operator2' */
  real_T switch1_g;                    /* '<S98>/switch1' */
  real_T DataStoreRead2_d;             /* '<S102>/Data Store Read2' */
  real_T RelationalOperator2_p;        /* '<S102>/Relational Operator2' */
  real_T Divide4[20];                  /* '<S93>/Divide4' */
  real_T SFunction_g3[20];             /* '<S101>/S-Function' */
  real_T u_gg[11];                     /* '<S100>/1' */
  real_T DataStoreRead_k5;             /* '<S95>/Data Store Read' */
  real_T Memory1_ea;                   /* '<S95>/Memory1' */
  real_T DataStoreRead2_i;             /* '<S95>/Data Store Read2' */
  real_T RelationalOperator2_j;        /* '<S95>/Relational Operator2' */
  real_T u_gv;                         /* '<S95>/1 ' */
  real_T Subtract2_o;                  /* '<S95>/Subtract2' */
  real_T Divide4_o;                    /* '<S95>/Divide4' */
  real_T Subtract3;                    /* '<S95>/Subtract3' */
  real_T Saturation;                   /* '<S95>/Saturation' */
  real_T Divide4_i[11];                /* '<S68>/Divide4' */
  real_T Subtract1_i;                  /* '<S95>/Subtract1' */
  real_T G_curr_term1[20];             /* '<S97>/ G_curr_term 1' */
  real_T DataStoreRead2_ac;            /* '<S112>/Data Store Read2' */
  real_T RelationalOperator2_p5;       /* '<S112>/Relational Operator2' */
  real_T Divide12_b[20];               /* '<S97>/Divide12' */
  real_T SFunction_a[20];              /* '<S111>/S-Function' */
  real_T Divide2_n[11];                /* '<S68>/Divide2' */
  real_T volt1Read[500];               /* '<S116>/volt1 Read' */
  real_T u01[500];                     /* '<S116>/0.001' */
  real_T volt2Read[500];               /* '<S116>/volt2 Read' */
  real_T volt1;                        /* '<S116>/volt1' */
  real_T volt1Read_i[500];             /* '<S119>/volt1 Read' */
  real_T u01_j[500];                   /* '<S119>/0.001' */
  real_T volt3Read[500];               /* '<S119>/volt3 Read' */
  real_T volt1_p;                      /* '<S119>/volt1' */
  real_T volt1Read_c[500];             /* '<S120>/volt1 Read' */
  real_T u01_n[500];                   /* '<S120>/0.001' */
  real_T volt4Read[500];               /* '<S120>/volt4 Read' */
  real_T volt1_i;                      /* '<S120>/volt1' */
  real_T volt1Read_k[500];             /* '<S121>/volt1 Read' */
  real_T u01_b[500];                   /* '<S121>/0.001' */
  real_T volt5Read[500];               /* '<S121>/volt5 Read' */
  real_T volt1_k;                      /* '<S121>/volt1' */
  real_T volt1Read_h[500];             /* '<S122>/volt1 Read' */
  real_T u01_f[500];                   /* '<S122>/0.001' */
  real_T volt6Read[500];               /* '<S122>/volt6 Read' */
  real_T volt1_pu;                     /* '<S122>/volt1' */
  real_T volt1Read_b[500];             /* '<S123>/volt1 Read' */
  real_T u01_b0[500];                  /* '<S123>/0.001' */
  real_T volt7Read[500];               /* '<S123>/volt7 Read' */
  real_T volt1_o;                      /* '<S123>/volt1' */
  real_T volt1Read_f[500];             /* '<S124>/volt1 Read' */
  real_T u01_jr[500];                  /* '<S124>/0.001' */
  real_T volt8Read[500];               /* '<S124>/volt8 Read' */
  real_T volt1_f;                      /* '<S124>/volt1' */
  real_T volt1Read_m[500];             /* '<S125>/volt1 Read' */
  real_T u01_m[500];                   /* '<S125>/0.001' */
  real_T volt9Read[500];               /* '<S125>/volt9 Read' */
  real_T volt1_l;                      /* '<S125>/volt1' */
  real_T volt1Read_b3[500];            /* '<S126>/volt1 Read' */
  real_T u01_bv[500];                  /* '<S126>/0.001' */
  real_T volt10Read[500];              /* '<S126>/volt10 Read' */
  real_T volt1_a;                      /* '<S126>/volt1' */
  real_T volt1Read_o[500];             /* '<S117>/volt1 Read' */
  real_T u01_ft[500];                  /* '<S117>/0.001' */
  real_T volt11Read[500];              /* '<S117>/volt11 Read' */
  real_T volt1_d;                      /* '<S117>/volt1' */
  real_T volt1Read_ba[500];            /* '<S118>/volt1 Read' */
  real_T u01_bc[500];                  /* '<S118>/0.001' */
  real_T volt12Read[500];              /* '<S118>/volt12 Read' */
  real_T volt1_kr;                     /* '<S118>/volt1' */
  real_T DataStoreRead2_aj;            /* '<S115>/Data Store Read2' */
  real_T RelationalOperator2_m;        /* '<S115>/Relational Operator2' */
  real_T Divide7[11];                  /* '<S69>/Divide7' */
  real_T Sum3[11];                     /* '<S66>/Sum3' */
  real_T Divide2_l[11];                /* '<S65>/Divide2' */
  real_T e3_p[11];                     /* '<S65>/1e3' */
  real_T Abs_p[11];                    /* '<S65>/Abs' */
  real_T DataStoreRead1_a[11];         /* '<S17>/Data Store Read1' */
  real_T DataStoreRead2_l[11];         /* '<S65>/Data Store Read2' */
  real_T Divide5[11];                  /* '<S65>/Divide5' */
  real_T Sum2[11];                     /* '<S65>/Sum2' */
  real_T DataStoreRead1_g;             /* '<S65>/Data Store Read1' */
  real_T Divide3[11];                  /* '<S65>/Divide3' */
  real_T Sum1[11];                     /* '<S65>/Sum1' */
  real_T Divide4_p[11];                /* '<S65>/Divide4' */
  real_T Divide1_ah[11];               /* '<S65>/Divide1' */
  real_T Saturation_b[11];             /* '<S65>/Saturation' */
  real_T LogicalOperator_h[11];        /* '<S65>/Logical Operator' */
  real_T Switch[11];                   /* '<S65>/Switch' */
  real_T Divide6_i[11];                /* '<S65>/Divide6' */
  real_T DataStoreRead_l;              /* '<S89>/Data Store Read' */
  real_T u5;                           /* '<S89>/1//15' */
  real_T Div;                          /* '<S89>/Div' */
  real_T UniformRandomNumber;          /* '<S73>/Uniform Random Number' */
  real_T DataStoreRead_m;              /* '<S77>/Data Store Read' */
  real_T u5_e;                         /* '<S77>/1.75' */
  real_T Divide11;                     /* '<S77>/Divide11' */
  real_T Uk1_h;                        /* '<S78>/UD' */
  real_T Diff_p;                       /* '<S78>/Diff' */
  real_T e3_b;                         /* '<S77>/2e3' */
  real_T Sqrt;                         /* '<S77>/Sqrt' */
  real_T Divide1_no;                   /* '<S77>/Divide1' */
  real_T Sum2_c;                       /* '<S73>/Sum2' */
  real_T DataStoreRead_j;              /* '<S76>/Data Store Read' */
  real_T RelationalOperator1_f;        /* '<S76>/Relational Operator1' */
  real_T Divide12_g[2];                /* '<S76>/Divide12' */
  real_T eye202[20];                   /* '<S88>/ eye(20,2)' */
  real_T SFunction_mf[20];             /* '<S88>/S-Function' */
  real_T Divide4_b[2];                 /* '<S74>/Divide4' */
  real_T eye202_p[20];                 /* '<S83>/ eye(20,2)' */
  real_T SFunction_n[20];              /* '<S83>/S-Function' */
  real_T c_eob1_k[2];                  /* '<S67>/c_eob1' */
  real_T DataStoreRead2_m;             /* '<S72>/Data Store Read2' */
  real_T RelationalOperator2_ah;       /* '<S72>/Relational Operator2' */
  real_T Divide10[2];                  /* '<S67>/Divide10' */
  real_T Divide4_pj[11];               /* '<S6>/Divide4' */
  real_T Add1_b[11];                   /* '<S9>/Add1' */
  real_T Uk1_hc;                       /* '<S8>/UD' */
  real_T Diff_o;                       /* '<S8>/Diff' */
  real_T Divide_n[11];                 /* '<S9>/Divide' */
  real_T u_a[11];                      /* '<S10>/-1' */
  real_T Switch_g[11];                 /* '<S12>/Switch' */
  real_T Switch2[11];                  /* '<S12>/Switch2' */
  real_T Divide1_g[11];                /* '<S9>/Divide1' */
  real_T Add2_c[11];                   /* '<S9>/Add2' */
  real_T Gain_m[11];                   /* '<S11>/Gain' */
  real_T Switch_d[11];                 /* '<S13>/Switch' */
  real_T Switch2_g[11];                /* '<S13>/Switch2' */
  real_T DataStoreRead2_ln[11];        /* '<S3>/Data Store Read2' */
  real_T Divide3_d[11];                /* '<S3>/Divide3' */
  real_T Divide1_ow[11];               /* '<S3>/Divide1' */
  real_T DataStoreRead1_b;             /* '<S5>/Data Store Read1' */
  real_T Switch2_j;                    /* '<S14>/Switch2' */
  real_T Divide2_p[11];                /* '<S3>/Divide2' */
  real_T Add1_m[11];                   /* '<S3>/Add1' */
  real_T DataStoreRead1_d;             /* '<S3>/Data Store Read1' */
  real_T Divide4_bw;                   /* '<S3>/Divide4' */
  real_T DataStoreRead3_h;             /* '<S5>/Data Store Read3' */
  real_T Switch2_d;                    /* '<S15>/Switch2' */
  real_T Divide5_p;                    /* '<S3>/Divide5' */
  real_T TmpSignalConversionAtnpf12Inpor[12];
  real_T npf12[15];                    /* '<S3>/npf,12' */
  real_T Memory2_ga;                   /* '<S18>/Memory2' */
  real_T u_p;                          /* '<S18>/-1' */
  real_T Ip1e4;                        /* '<S18>/Ip<1e-4 ' */
  real_T Sum2_b;                       /* '<S18>/Sum2' */
  real_T Time_stopRead;                /* '<S6>/Time_stop Read' */
  real_T Divide3_f[11];                /* '<S93>/Divide3' */
  real_T Subtract2_g;                  /* '<S98>/Subtract2' */
  real_T DataStoreRead1_c;             /* '<S98>/Data Store Read1' */
  real_T Divide4_ii;                   /* '<S98>/Divide4' */
  real_T Subtract3_i;                  /* '<S98>/Subtract3' */
  real_T Saturation_n;                 /* '<S98>/Saturation' */
  real_T Subtract1_k;                  /* '<S98>/Subtract1' */
  real_T Divide5_b[11];                /* '<S68>/Divide5' */
  real_T Subtract3_ix;                 /* '<S92>/Subtract3' */
  real_T Divide6_e[11];                /* '<S68>/Divide6' */
  real_T Divide1_n2[11];               /* '<S68>/Divide1' */
  real_T Sum2_d[11];                   /* '<S68>/Sum2' */
  real_T DataStoreRead2_hu;            /* '<S99>/Data Store Read2' */
  real_T u15;                          /* '<S99>/ 1//15 ' */
  real_T Divide9;                      /* '<S99>/Divide9' */
  real_T Saturation_m;                 /* '<S99>/Saturation' */
  real_T DataStoreRead2_g;             /* '<S113>/Data Store Read2' */
  real_T Sum3_n;                       /* '<S113>/Sum3' */
  real_T DataStoreRead4;               /* '<S113>/Data Store Read4' */
  real_T DataStoreRead3_o;             /* '<S113>/Data Store Read3' */
  real_T Sum2_bk;                      /* '<S113>/Sum2' */
  real_T Divide1_gf;                   /* '<S113>/Divide1' */
  real_T Divide6_n;                    /* '<S113>/Divide6' */
  real_T Sum;                          /* '<S113>/Sum' */
  real_T Divide2_f;                    /* '<S113>/Divide2' */
  real_T Sum1_f;                       /* '<S113>/Sum1' */
  real_T Switch2_j1;                   /* '<S114>/Switch2' */
  real_T Switch_o;                     /* '<S114>/Switch' */
  real_T DataStoreRead_ky;             /* '<S110>/Data Store Read' */
  real_T RelationalOperator_a;         /* '<S110>/Relational Operator' */
  real_T u_c[11];                      /* '<S110>/1' */
  real_T DataStoreRead1_lt;            /* '<S108>/Data Store Read1' */
  real_T DataStoreRead_c;              /* '<S108>/Data Store Read' */
  real_T Subtract3_c;                  /* '<S108>/Subtract3' */
  real_T Divide2_nx;                   /* '<S108>/Divide2' */
  real_T Saturation1_i;                /* '<S108>/Saturation1' */
  real_T u5_p;                         /* '<S96>/1//15' */
  real_T DataStoreRead1_bd;            /* '<S96>/Data Store Read1' */
  real_T Divide1_oh;                   /* '<S96>/Divide 1' */
  real_T Divide_d[11];                 /* '<S96>/Divide ' */
  real_T Divide2_m[11];                /* '<S96>/Divide2' */
  real_T Divide_np[11];                /* '<S94>/Divide' */
  real_T DataStoreRead1_f;             /* '<S89>/Data Store Read1' */
  real_T RelationalOperator2_a2;       /* '<S89>/Relational Operator2' */
  real_T LimDivtr;                     /* '<S89>/Lim. Div. tr.' */
  real_T Divide8[2];                   /* '<S75>/Divide8' */
  real_T DataStoreRead3_a;             /* '<S89>/Data Store Read3' */
  real_T Switch2_h;                    /* '<S91>/Switch2' */
  real_T Switch_b;                     /* '<S91>/Switch' */
  real_T DataStoreRead2_jg;            /* '<S89>/Data Store Read2' */
  real_T Switch2_p;                    /* '<S90>/Switch2' */
  real_T Switch_c;                     /* '<S90>/Switch' */
  real_T DataStoreRead1_mp;            /* '<S82>/Data Store Read1' */
  real_T LogicalOperator1_f;           /* '<S82>/Logical Operator1' */
  real_T DataStoreRead2_h1;            /* '<S82>/Data Store Read2' */
  real_T RelationalOperator1_d;        /* '<S82>/Relational Operator1' */
  real_T LogicalOperator2_m;           /* '<S82>/Logical Operator2' */
  real_T Ip_rd;                        /* '<S74>/Ip_rd ' */
  real_T Divide1_fs[2];                /* '<S74>/Divide1' */
  real_T DataStoreRead_n;              /* '<S80>/Data Store Read' */
  real_T u15_n;                        /* '<S80>/ 1//15' */
  real_T Divide6_ey;                   /* '<S80>/Divide6' */
  real_T Switch2_l;                    /* '<S84>/Switch2' */
  real_T DataStoreRead3_oz;            /* '<S80>/Data Store Read3' */
  real_T Switch_b3;                    /* '<S84>/Switch' */
  real_T u5_b;                         /* '<S81>/1//15' */
  real_T Switch2_j5;                   /* '<S85>/Switch2' */
  real_T DataStoreRead2_iu;            /* '<S81>/Data Store Read2' */
  real_T Switch_dp;                    /* '<S85>/Switch' */
  real_T g6_tRead[100];                /* '<S57>/g6_t Read' */
  real_T Selector[49];                 /* '<S57>/Selector' */
  real_T TmpSignalConversionAtg6_termref[50];
  real_T trdRead;                      /* '<S57>/trd Read' */
  real_T RupRdRead;                    /* '<S57>/RupRd Read' */
  real_T Selector1[50];                /* '<S57>/Selector1' */
  real_T Divide6_p[50];                /* '<S57>/Divide6' */
  real_T Add2_d[50];                   /* '<S57>/Add2' */
  real_T g6_termref;                   /* '<S57>/g6_term,ref' */
  real_T g6Read1[50];                  /* '<S51>/g6 Read1' */
  real_T g6Read[50];                   /* '<S51>/g6 Read' */
  real_T g6ref;                        /* '<S51>/g6ref' */
  real_T g5_tRead[100];                /* '<S56>/g5_t Read' */
  real_T Selector_f[49];               /* '<S56>/Selector' */
  real_T TmpSignalConversionAtg5_termref[50];
  real_T trdRead_l;                    /* '<S56>/trd Read' */
  real_T RupRdRead_m;                  /* '<S56>/RupRd Read' */
  real_T Selector1_f[50];              /* '<S56>/Selector1' */
  real_T Divide6_j[50];                /* '<S56>/Divide6' */
  real_T Add2_l[50];                   /* '<S56>/Add2' */
  real_T g5_termref;                   /* '<S56>/g5_term,ref' */
  real_T g5Read1[50];                  /* '<S50>/g5 Read1' */
  real_T g5Read[50];                   /* '<S50>/g5 Read' */
  real_T g5ref;                        /* '<S50>/g5ref' */
  real_T g4_tRead[100];                /* '<S55>/g4_t Read' */
  real_T Selector_g[49];               /* '<S55>/Selector' */
  real_T TmpSignalConversionAtg4_termref[50];
  real_T trdRead_j;                    /* '<S55>/trd Read' */
  real_T RupRdRead_o;                  /* '<S55>/RupRd Read' */
  real_T Selector1_fw[50];             /* '<S55>/Selector1' */
  real_T Divide6_c[50];                /* '<S55>/Divide6' */
  real_T Add2_ln[50];                  /* '<S55>/Add2' */
  real_T g4_termref;                   /* '<S55>/g4_term,ref' */
  real_T g4Read1[50];                  /* '<S49>/g4 Read1' */
  real_T g4Read[50];                   /* '<S49>/g4 Read' */
  real_T g4ref;                        /* '<S49>/g4ref' */
  real_T g3_tRead[100];                /* '<S54>/g3_t Read' */
  real_T Selector_p[49];               /* '<S54>/Selector' */
  real_T TmpSignalConversionAtg3_termref[50];
  real_T trdRead_m;                    /* '<S54>/trd Read' */
  real_T RupRdRead_j;                  /* '<S54>/RupRd Read' */
  real_T Selector1_a[50];              /* '<S54>/Selector1' */
  real_T Divide6_el[50];               /* '<S54>/Divide6' */
  real_T Add2_cn[50];                  /* '<S54>/Add2' */
  real_T g3_termref;                   /* '<S54>/g3_term,ref' */
  real_T g3Read1[50];                  /* '<S48>/g3 Read1' */
  real_T g3Read[50];                   /* '<S48>/g3 Read' */
  real_T g3ref;                        /* '<S48>/g3ref' */
  real_T g2_tRead[100];                /* '<S53>/g2_t Read' */
  real_T Selector_h[49];               /* '<S53>/Selector' */
  real_T TmpSignalConversionAtg2_termref[50];
  real_T trdRead_c;                    /* '<S53>/trd Read' */
  real_T RupRdRead_mw;                 /* '<S53>/RupRd Read' */
  real_T Selector1_p[50];              /* '<S53>/Selector1' */
  real_T Divide6_il[50];               /* '<S53>/Divide6' */
  real_T Add2_m[50];                   /* '<S53>/Add2' */
  real_T g2_termref;                   /* '<S53>/g2_term,ref' */
  real_T g2Read1[50];                  /* '<S47>/g2 Read1' */
  real_T g2Read[50];                   /* '<S47>/g2 Read' */
  real_T g2ref;                        /* '<S47>/g2ref' */
  real_T g1_tRead[100];                /* '<S52>/g1_t Read' */
  real_T Selector_c[49];               /* '<S52>/Selector' */
  real_T TmpSignalConversionAtg1_termref[50];
  real_T trdRead_d;                    /* '<S52>/trd Read' */
  real_T RupRdRead_p;                  /* '<S52>/RupRd Read' */
  real_T Selector1_c[50];              /* '<S52>/Selector1' */
  real_T Divide6_k[50];                /* '<S52>/Divide6' */
  real_T Add2_p[50];                   /* '<S52>/Add2' */
  real_T g1_termref;                   /* '<S52>/g1_term,ref' */
  real_T g1Read1[50];                  /* '<S46>/g1 Read1' */
  real_T g1Read[50];                   /* '<S46>/g1 Read' */
  real_T g1ref1;                       /* '<S46>/g1ref1' */
  real_T scr11Read[500];               /* '<S45>/scr11 Read' */
  real_T scr1Read[500];                /* '<S45>/scr1 Read' */
  real_T I1;                           /* '<S45>/I1' */
  real_T scr10Read[500];               /* '<S44>/scr10 Read' */
  real_T scr1Read_h[500];              /* '<S44>/scr1 Read' */
  real_T I1_n;                         /* '<S44>/I1' */
  real_T scr9Read[500];                /* '<S43>/scr9 Read' */
  real_T scr1Read_d[500];              /* '<S43>/scr1 Read' */
  real_T I1_p;                         /* '<S43>/I1' */
  real_T scr8Read[500];                /* '<S42>/scr8 Read' */
  real_T sct1Read[500];                /* '<S42>/sct1 Read' */
  real_T I1_po;                        /* '<S42>/I1' */
  real_T scr7Read[500];                /* '<S41>/scr7 Read' */
  real_T scr1Read_m[500];              /* '<S41>/scr1 Read' */
  real_T I1_j;                         /* '<S41>/I1' */
  real_T scr6Read[500];                /* '<S40>/scr6 Read' */
  real_T scr1Read_a[500];              /* '<S40>/scr1 Read' */
  real_T I1_i;                         /* '<S40>/I1' */
  real_T scr5Read[500];                /* '<S39>/scr5 Read' */
  real_T scr1Read_i[500];              /* '<S39>/scr1 Read' */
  real_T I1_f;                         /* '<S39>/I1' */
  real_T scr2Read[500];                /* '<S38>/scr2 Read' */
  real_T scr1Read_dp[500];             /* '<S38>/scr1 Read' */
  real_T I1_c;                         /* '<S38>/I1' */
  real_T scr13Read[500];               /* '<S37>/scr13 Read' */
  real_T scr1Read_hm[500];             /* '<S37>/scr1 Read' */
  real_T I1_a;                         /* '<S37>/I1' */
  real_T scr12Read[500];               /* '<S36>/scr12 Read' */
  real_T scr1Read_l[500];              /* '<S36>/scr1 Read' */
  real_T I1_h;                         /* '<S36>/I1' */
  real_T scr2Read_m[500];              /* '<S35>/scr2 Read' */
  real_T scr1Read_n[500];              /* '<S35>/scr1 Read' */
  real_T I1_k;                         /* '<S35>/I1' */
  real_T scr2Read_c[500];              /* '<S22>/scr2 Read' */
  real_T scr1Read_in[500];             /* '<S22>/scr1 Read' */
  real_T Ipref;                        /* '<S22>/Ipref' */
  real_T ElongRead[100];               /* '<S24>/Elong Read' */
  real_T Selector_n[50];               /* '<S24>/Selector' */
  real_T Selector1_cb[50];             /* '<S24>/Selector1' */
  real_T elong;                        /* '<S24>/elong' */
  real_T Add2_a;                       /* '<S16>/Add2' */
  real_T DataStoreRead2_e;             /* '<S20>/Data Store Read2' */
  real_T RelationalOperator_h;         /* '<S20>/Relational Operator' */
  real_T Gain1;                        /* '<S5>/Gain1' */
  real_T Switch_bj;                    /* '<S15>/Switch' */
  real_T Gain_d;                       /* '<S5>/Gain' */
  real_T Switch_d4;                    /* '<S14>/Switch' */
  uint8_T Compare[11];                 /* '<S71>/Compare' */
  uint8_T Compare_h[11];               /* '<S70>/Compare' */
  boolean_T RelationalOperator2_a3;    /* '<S27>/Relational Operator2' */
  boolean_T Compare_i;                 /* '<S58>/Compare' */
  boolean_T RelationalOperator_b;      /* '<S63>/Relational Operator' */
  boolean_T Compare_k;                 /* '<S61>/Compare' */
  boolean_T RelationalOperator_l;      /* '<S100>/Relational Operator' */
  boolean_T Compare_n;                 /* '<S79>/Compare' */
  boolean_T LowerRelop1[11];           /* '<S12>/LowerRelop1' */
  boolean_T UpperRelop[11];            /* '<S12>/UpperRelop' */
  boolean_T LowerRelop1_c[11];         /* '<S13>/LowerRelop1' */
  boolean_T UpperRelop_p[11];          /* '<S13>/UpperRelop' */
  boolean_T LowerRelop1_h;             /* '<S14>/LowerRelop1' */
  boolean_T LowerRelop1_n;             /* '<S15>/LowerRelop1' */
  boolean_T RelOperator;               /* '<S6>/Rel.Operator' */
  boolean_T RelOperator1;              /* '<S6>/Rel.Operator1' */
  boolean_T LowerRelop1_cl;            /* '<S114>/LowerRelop1' */
  boolean_T UpperRelop_g;              /* '<S114>/UpperRelop' */
  boolean_T LowerRelop1_m;             /* '<S91>/LowerRelop1' */
  boolean_T UpperRelop_d;              /* '<S91>/UpperRelop' */
  boolean_T LowerRelop1_g;             /* '<S90>/LowerRelop1' */
  boolean_T UpperRelop_j;              /* '<S90>/UpperRelop' */
  boolean_T Compare_p;                 /* '<S86>/Compare' */
  boolean_T Compare_ha;                /* '<S87>/Compare' */
  boolean_T LowerRelop1_h3;            /* '<S84>/LowerRelop1' */
  boolean_T UpperRelop_pt;             /* '<S84>/UpperRelop' */
  boolean_T LowerRelop1_gc;            /* '<S85>/LowerRelop1' */
  boolean_T UpperRelop_o;              /* '<S85>/UpperRelop' */
  boolean_T UpperRelop_m;              /* '<S15>/UpperRelop' */
  boolean_T UpperRelop_a;              /* '<S14>/UpperRelop' */
} BlockIO_t15_2;

/* Block states (auto storage) for system '<Root>' */
typedef struct {
  real_T UD_DSTATE;                    /* '<S33>/UD' */
  real_T UD_DSTATE_o;                  /* '<S34>/UD' */
  real_T SFunction_DSTATE[50];         /* '<S107>/S-Function' */
  real_T SFunction_DSTATE_j[50];       /* '<S106>/S-Function' */
  real_T SFunction_DSTATE_f[50];       /* '<S103>/S-Function' */
  real_T SFunction_DSTATE_a[50];       /* '<S101>/S-Function' */
  real_T SFunction_DSTATE_ay[50];      /* '<S111>/S-Function' */
  real_T UD_DSTATE_a;                  /* '<S78>/UD' */
  real_T SFunction_DSTATE_e[50];       /* '<S88>/S-Function' */
  real_T SFunction_DSTATE_k[50];       /* '<S83>/S-Function' */
  real_T UD_DSTATE_j;                  /* '<S8>/UD' */
  real_T Memory1_PreviousInput[11];    /* '<S9>/Memory1' */
  real_T Memory1_PreviousInput_c;      /* '<S21>/Memory1' */
  real_T Memory_PreviousInput;         /* '<S32>/Memory' */
  real_T Memory2_PreviousInput;        /* '<S46>/Memory2' */
  real_T Memory1_PreviousInput_l;      /* '<S46>/Memory1' */
  real_T Memory2_PreviousInput_k;      /* '<S47>/Memory2' */
  real_T Memory1_PreviousInput_la;     /* '<S47>/Memory1' */
  real_T Memory2_PreviousInput_i;      /* '<S48>/Memory2' */
  real_T Memory1_PreviousInput_i;      /* '<S48>/Memory1' */
  real_T Memory2_PreviousInput_e;      /* '<S49>/Memory2' */
  real_T Memory1_PreviousInput_f;      /* '<S49>/Memory1' */
  real_T Memory2_PreviousInput_j;      /* '<S50>/Memory2' */
  real_T Memory1_PreviousInput_l5;     /* '<S50>/Memory1' */
  real_T Memory2_PreviousInput_c;      /* '<S51>/Memory2' */
  real_T Memory1_PreviousInput_k;      /* '<S51>/Memory1' */
  real_T Memory1_PreviousInput_h;      /* '<S22>/Memory1' */
  real_T Memory2_PreviousInput_b;      /* '<S35>/Memory2' */
  real_T Memory2_PreviousInput_d;      /* '<S38>/Memory2' */
  real_T Memory2_PreviousInput_o;      /* '<S39>/Memory2' */
  real_T Memory2_PreviousInput_jf;     /* '<S40>/Memory2' */
  real_T Memory2_PreviousInput_f;      /* '<S41>/Memory2' */
  real_T Memory2_PreviousInput_i2;     /* '<S42>/Memory2' */
  real_T Memory2_PreviousInput_fs;     /* '<S43>/Memory2' */
  real_T Memory2_PreviousInput_m;      /* '<S44>/Memory2' */
  real_T Memory2_PreviousInput_n;      /* '<S45>/Memory2' */
  real_T Memory2_PreviousInput_g;      /* '<S36>/Memory2' */
  real_T Memory2_PreviousInput_c4;     /* '<S37>/Memory2' */
  real_T Memory_PreviousInput_d;       /* '<S29>/Memory' */
  real_T Memory_PreviousInput_o;       /* '<S60>/Memory' */
  real_T Memory1_PreviousInput_kq;     /* '<S27>/Memory1' */
  real_T Memory_PreviousInput_f;       /* '<S64>/Memory' */
  real_T Memory1_PreviousInput_j;      /* '<S28>/Memory1' */
  real_T Memory1_PreviousInput_m;      /* '<S30>/Memory1' */
  real_T Memory2_PreviousInput_kw[11]; /* '<S110>/Memory2' */
  real_T Memory3_PreviousInput;        /* '<S92>/Memory3' */
  real_T Memory1_PreviousInput_b[11];  /* '<S100>/Memory1' */
  real_T Memory_PreviousInput_h[11];   /* '<S104>/Memory' */
  real_T Memory1_PreviousInput_o;      /* '<S113>/Memory1' */
  real_T Memory1_PreviousInput_p;      /* '<S98>/Memory1' */
  real_T Memory1_PreviousInput_hp;     /* '<S95>/Memory1' */
  real_T UniformRandomNumber_NextOutput;/* '<S73>/Uniform Random Number' */
  real_T Memory2_PreviousInput_d0;     /* '<S18>/Memory2' */
  real_T tdiv;                         /* '<S1>/ ' */
  real_T c_a_tpl1_eob;                 /* '<S1>/Data Store Memory10' */
  real_T c_a_tpl2;                     /* '<S1>/Data Store Memory11' */
  real_T tterm;                        /* '<S1>/Data Store Memory111' */
  real_T trd;                          /* '<S1>/Data Store Memory112' */
  real_T c_a_tpl_min;                  /* '<S1>/Data Store Memory12' */
  real_T y0;                           /* '<S1>/Data Store Memory13' */
  real_T c1_y0;                        /* '<S1>/Data Store Memory14' */
  real_T c2_y0;                        /* '<S1>/Data Store Memory15' */
  real_T t_tran2D;                     /* '<S1>/Data Store Memory16' */
  real_T max_VS_lim;                   /* '<S1>/Data Store Memory17' */
  real_T k_g4;                         /* '<S1>/Data Store Memory18' */
  real_T tcont2;                       /* '<S1>/Data Store Memory19' */
  real_T Ipdiv;                        /* '<S1>/Data Store Memory20' */
  real_T ref_ramp;                     /* '<S1>/Data Store Memory21' */
  real_T dtcont2;                      /* '<S1>/Data Store Memory22' */
  real_T Ip_rd;                        /* '<S1>/Data Store Memory23' */
  real_T trd_ref;                      /* '<S1>/Data Store Memory24' */
  real_T Time_stop;                    /* '<S1>/Data Store Memory25' */
  real_T c_a_tpl1;                     /* '<S1>/Data Store Memory6' */
  real_T Elong[100];                   /* '<S1>/Elong Memory' */
  real_T Imax[11];                     /* '<S1>/Imax Memory' */
  real_T RupRd[6];                     /* '<S1>/RupRd Memory' */
  real_T Tu;                           /* '<S1>/Tu Memory' */
  real_T VS1_up;                       /* '<S1>/VS1 Memory' */
  real_T VS3_up;                       /* '<S1>/VS3 Memory' */
  real_T Vcspf_up[11];                 /* '<S1>/Vcspf Memory' */
  real_T volt[10000];                  /* '<S1>/Volt Memory' */
  real_T c_cur_max;                    /* '<S1>/curr Memory' */
  real_T g1[100];                      /* '<S1>/g1 Memory' */
  real_T g1_term[100];                 /* '<S1>/g1_t Memory' */
  real_T g2[100];                      /* '<S1>/g2 Memory' */
  real_T g2_term[100];                 /* '<S1>/g2_t Memory' */
  real_T g3[100];                      /* '<S1>/g3 Memory' */
  real_T g3_term[100];                 /* '<S1>/g3_t Memory' */
  real_T g4[100];                      /* '<S1>/g4 Memory' */
  real_T g4_term[100];                 /* '<S1>/g4_t Memory' */
  real_T g5[100];                      /* '<S1>/g5 Memory' */
  real_T g5_term[100];                 /* '<S1>/g5_t Memory' */
  real_T g6[100];                      /* '<S1>/g6 Memory' */
  real_T g6_term[100];                 /* '<S1>/g6_t Memory' */
  real_T ntur[12];                     /* '<S1>/ntur Memory' */
  real_T scr_data[6500];               /* '<S1>/scr Memory' */
  uint32_T RandSeed;                   /* '<S73>/Uniform Random Number' */
} D_Work_t15_2;

/* External inputs (root inport signals with auto storage) */
typedef struct {
  real_T In1[15];                      /* '<Root>/In1' */
  real_T In2[123];                     /* '<Root>/In2' */
} ExternalInputs_t15_2;

/* External outputs (root outports fed by signals with auto storage) */
typedef struct {
  real_T to_DINA[38];                  /* '<Root>/to_DINA' */
} ExternalOutputs_t15_2;

/* Parameters (auto storage) */
struct Parameters_t15_2_ {
  real_T Gain_Gain;                    /* Expression: -1
                                        * Referenced by: '<S5>/Gain'
                                        */
  real_T Gain1_Gain;                   /* Expression: -1
                                        * Referenced by: '<S5>/Gain1'
                                        */
  real_T u5_Gain;                      /* Expression: 1/15
                                        * Referenced by: '<S81>/1//15'
                                        */
  real_T _Value;                       /* Expression: 1
                                        * Referenced by: '<S81>/3'
                                        */
  real_T u15_Gain;                     /* Expression: 1/15
                                        * Referenced by: '<S80>/ 1//15'
                                        */
  real_T _Value_b;                     /* Expression: 1
                                        * Referenced by: '<S80>/1'
                                        */
  real_T Constant_Value;               /* Expression: const
                                        * Referenced by: '<S86>/Constant'
                                        */
  real_T Constant_Value_i;             /* Expression: const
                                        * Referenced by: '<S87>/Constant'
                                        */
  real_T Ip_rd_Threshold;              /* Expression: 1
                                        * Referenced by: '<S74>/Ip_rd '
                                        */
  real_T LimDivtr_Threshold;           /* Expression: 1
                                        * Referenced by: '<S89>/Lim. Div. tr.'
                                        */
  real_T Saturation1_UpperSat;         /* Expression: 1
                                        * Referenced by: '<S108>/Saturation1'
                                        */
  real_T Saturation1_LowerSat;         /* Expression: 0
                                        * Referenced by: '<S108>/Saturation1'
                                        */
  real_T u5_Gain_k;                    /* Expression: 1/15
                                        * Referenced by: '<S96>/1//15'
                                        */
  real_T _Threshold;                   /* Expression: 1
                                        * Referenced by: '<S110>/1'
                                        */
  real_T _Value_h;                     /* Expression: 1
                                        * Referenced by: '<S113>/2'
                                        */
  real_T _Value_i;                     /* Expression: 1
                                        * Referenced by: '<S113>/1'
                                        */
  real_T u15_Gain_g;                   /* Expression: 1/15
                                        * Referenced by: '<S99>/ 1//15 '
                                        */
  real_T Saturation_UpperSat;          /* Expression: 1
                                        * Referenced by: '<S99>/Saturation'
                                        */
  real_T Saturation_LowerSat;          /* Expression: 0
                                        * Referenced by: '<S99>/Saturation'
                                        */
  real_T _Value_m;                     /* Expression: 1
                                        * Referenced by: '<S98>/1'
                                        */
  real_T Saturation_UpperSat_f;        /* Expression: 1
                                        * Referenced by: '<S98>/Saturation'
                                        */
  real_T Saturation_LowerSat_b;        /* Expression: 0
                                        * Referenced by: '<S98>/Saturation'
                                        */
  real_T read_elong_fun_P1_Size[2];    /* Computed Parameter: read_elong_fun_P1_Size
                                        * Referenced by: '<S1>/read_elong_fun'
                                        */
  real_T read_elong_fun_P1;            /* Expression: 0
                                        * Referenced by: '<S1>/read_elong_fun'
                                        */
  real_T read_volt_fun_P1_Size[2];     /* Computed Parameter: read_volt_fun_P1_Size
                                        * Referenced by: '<S1>/read_volt_fun'
                                        */
  real_T read_volt_fun_P1;             /* Expression: 12
                                        * Referenced by: '<S1>/read_volt_fun'
                                        */
  real_T read_g1_fun_P1_Size[2];       /* Computed Parameter: read_g1_fun_P1_Size
                                        * Referenced by: '<S1>/read_g1_fun'
                                        */
  real_T read_g1_fun_P1;               /* Expression: 1
                                        * Referenced by: '<S1>/read_g1_fun'
                                        */
  real_T read_g1_t_fun_P1_Size[2];     /* Computed Parameter: read_g1_t_fun_P1_Size
                                        * Referenced by: '<S1>/read_g1_t_fun'
                                        */
  real_T read_g1_t_fun_P1;             /* Expression: 1
                                        * Referenced by: '<S1>/read_g1_t_fun'
                                        */
  real_T read_g2_fun_P1_Size[2];       /* Computed Parameter: read_g2_fun_P1_Size
                                        * Referenced by: '<S1>/read_g2_fun'
                                        */
  real_T read_g2_fun_P1;               /* Expression: 2
                                        * Referenced by: '<S1>/read_g2_fun'
                                        */
  real_T read_g2_t_fun_P1_Size[2];     /* Computed Parameter: read_g2_t_fun_P1_Size
                                        * Referenced by: '<S1>/read_g2_t_fun'
                                        */
  real_T read_g2_t_fun_P1;             /* Expression: 2
                                        * Referenced by: '<S1>/read_g2_t_fun'
                                        */
  real_T read_g3_fun_P1_Size[2];       /* Computed Parameter: read_g3_fun_P1_Size
                                        * Referenced by: '<S1>/read_g3_fun'
                                        */
  real_T read_g3_fun_P1;               /* Expression: 3
                                        * Referenced by: '<S1>/read_g3_fun'
                                        */
  real_T read_g3_t_fun_P1_Size[2];     /* Computed Parameter: read_g3_t_fun_P1_Size
                                        * Referenced by: '<S1>/read_g3_t_fun'
                                        */
  real_T read_g3_t_fun_P1;             /* Expression: 3
                                        * Referenced by: '<S1>/read_g3_t_fun'
                                        */
  real_T read_g4_fun_P1_Size[2];       /* Computed Parameter: read_g4_fun_P1_Size
                                        * Referenced by: '<S1>/read_g4_fun'
                                        */
  real_T read_g4_fun_P1;               /* Expression: 4
                                        * Referenced by: '<S1>/read_g4_fun'
                                        */
  real_T read_g4_t_fun_P1_Size[2];     /* Computed Parameter: read_g4_t_fun_P1_Size
                                        * Referenced by: '<S1>/read_g4_t_fun'
                                        */
  real_T read_g4_t_fun_P1;             /* Expression: 4
                                        * Referenced by: '<S1>/read_g4_t_fun'
                                        */
  real_T read_g5_fun_P1_Size[2];       /* Computed Parameter: read_g5_fun_P1_Size
                                        * Referenced by: '<S1>/read_g5_fun'
                                        */
  real_T read_g5_fun_P1;               /* Expression: 5
                                        * Referenced by: '<S1>/read_g5_fun'
                                        */
  real_T read_g5_t_fun_P1_Size[2];     /* Computed Parameter: read_g5_t_fun_P1_Size
                                        * Referenced by: '<S1>/read_g5_t_fun'
                                        */
  real_T read_g5_t_fun_P1;             /* Expression: 5
                                        * Referenced by: '<S1>/read_g5_t_fun'
                                        */
  real_T read_g6_fun_P1_Size[2];       /* Computed Parameter: read_g6_fun_P1_Size
                                        * Referenced by: '<S1>/read_g6_fun'
                                        */
  real_T read_g6_fun_P1;               /* Expression: 6
                                        * Referenced by: '<S1>/read_g6_fun'
                                        */
  real_T read_g6_t_fun_P1_Size[2];     /* Computed Parameter: read_g6_t_fun_P1_Size
                                        * Referenced by: '<S1>/read_g6_t_fun'
                                        */
  real_T read_g6_t_fun_P1;             /* Expression: 6
                                        * Referenced by: '<S1>/read_g6_t_fun'
                                        */
  real_T read_scr_fun_P1_Size[2];      /* Computed Parameter: read_scr_fun_P1_Size
                                        * Referenced by: '<S1>/read_scr_fun'
                                        */
  real_T read_scr_fun_P1;              /* Expression: 1
                                        * Referenced by: '<S1>/read_scr_fun'
                                        */
  real_T Memory1_X0;                   /* Expression: 0
                                        * Referenced by: '<S9>/Memory1'
                                        */
  real_T _Gain;                        /* Expression: 2
                                        * Referenced by: '<S10>/2'
                                        */
  real_T Times_Gain;                   /* Expression: 1e-3
                                        * Referenced by: '<S19>/Time s'
                                        */
  real_T e6_Gain;                      /* Expression: 1e-6
                                        * Referenced by: '<S16>/1e-6'
                                        */
  real_T e2_Gain;                      /* Expression: 1e2
                                        * Referenced by: '<S26>/1e2'
                                        */
  real_T Memory1_X0_d;                 /* Expression: 0
                                        * Referenced by: '<S21>/Memory1'
                                        */
  real_T e6_Gain_f;                    /* Expression: 1e-6
                                        * Referenced by: '<S16>/1e-6   '
                                        */
  real_T e3_Gain;                      /* Expression: 1e-3
                                        * Referenced by: '<S21>/1e-3'
                                        */
  real_T Memory_X0;                    /* Expression: 0
                                        * Referenced by: '<S32>/Memory'
                                        */
  real_T switch1_Threshold;            /* Expression: 1
                                        * Referenced by: '<S21>/switch1'
                                        */
  real_T Constant4_Value;              /* Expression: 1
                                        * Referenced by: '<S21>/Constant4'
                                        */
  real_T u_UpperSat;                   /* Expression: 1
                                        * Referenced by: '<S21>/1 0'
                                        */
  real_T u_LowerSat;                   /* Expression: 0
                                        * Referenced by: '<S21>/1 0'
                                        */
  real_T Memory2_X0;                   /* Expression: 0
                                        * Referenced by: '<S46>/Memory2'
                                        */
  real_T c_eob1_Threshold;             /* Expression: 1
                                        * Referenced by: '<S46>/c_eob  1'
                                        */
  real_T Memory1_X0_a;                 /* Expression: 0
                                        * Referenced by: '<S46>/Memory1'
                                        */
  real_T c_eob_Threshold;              /* Expression: 1
                                        * Referenced by: '<S46>/c_eob  '
                                        */
  real_T c_eob_Threshold_o;            /* Expression: 1
                                        * Referenced by: '<S46>/c_eob'
                                        */
  real_T Memory2_X0_d;                 /* Expression: 0
                                        * Referenced by: '<S47>/Memory2'
                                        */
  real_T c_eob1_Threshold_e;           /* Expression: 1
                                        * Referenced by: '<S47>/c_eob  1'
                                        */
  real_T Memory1_X0_g;                 /* Expression: 0
                                        * Referenced by: '<S47>/Memory1'
                                        */
  real_T c_eob_Threshold_d;            /* Expression: 1
                                        * Referenced by: '<S47>/c_eob  '
                                        */
  real_T c_eob_Threshold_h;            /* Expression: 1
                                        * Referenced by: '<S47>/c_eob'
                                        */
  real_T Memory2_X0_b;                 /* Expression: 0
                                        * Referenced by: '<S48>/Memory2'
                                        */
  real_T c_eob1_Threshold_j;           /* Expression: 1
                                        * Referenced by: '<S48>/c_eob  1'
                                        */
  real_T Memory1_X0_f;                 /* Expression: 0
                                        * Referenced by: '<S48>/Memory1'
                                        */
  real_T c_eob_Threshold_om;           /* Expression: 1
                                        * Referenced by: '<S48>/c_eob  '
                                        */
  real_T c_eob_Threshold_p;            /* Expression: 1
                                        * Referenced by: '<S48>/c_eob'
                                        */
  real_T Memory2_X0_e;                 /* Expression: 0
                                        * Referenced by: '<S49>/Memory2'
                                        */
  real_T c_eob1_Threshold_l;           /* Expression: 1
                                        * Referenced by: '<S49>/c_eob  1'
                                        */
  real_T Memory1_X0_b;                 /* Expression: 0
                                        * Referenced by: '<S49>/Memory1'
                                        */
  real_T c_eob_Threshold_b;            /* Expression: 1
                                        * Referenced by: '<S49>/c_eob  '
                                        */
  real_T c_eob_Threshold_n;            /* Expression: 1
                                        * Referenced by: '<S49>/c_eob'
                                        */
  real_T Memory2_X0_f;                 /* Expression: 0
                                        * Referenced by: '<S50>/Memory2'
                                        */
  real_T c_eob1_Threshold_jg;          /* Expression: 1
                                        * Referenced by: '<S50>/c_eob  1'
                                        */
  real_T Memory1_X0_l;                 /* Expression: 0
                                        * Referenced by: '<S50>/Memory1'
                                        */
  real_T c_eob_Threshold_a;            /* Expression: 1
                                        * Referenced by: '<S50>/c_eob  '
                                        */
  real_T c_eob_Threshold_g;            /* Expression: 1
                                        * Referenced by: '<S50>/c_eob'
                                        */
  real_T Memory2_X0_n;                 /* Expression: 0
                                        * Referenced by: '<S51>/Memory2'
                                        */
  real_T c_eob1_Threshold_ev;          /* Expression: 1
                                        * Referenced by: '<S51>/c_eob  1'
                                        */
  real_T Memory1_X0_bs;                /* Expression: 0
                                        * Referenced by: '<S51>/Memory1'
                                        */
  real_T c_eob_Threshold_ay;           /* Expression: 1
                                        * Referenced by: '<S51>/c_eob  '
                                        */
  real_T c_eob_Threshold_ht;           /* Expression: 1
                                        * Referenced by: '<S51>/c_eob'
                                        */
  real_T e2_Gain_d;                    /* Expression: 1e-2
                                        * Referenced by: '<S26>/1e-2'
                                        */
  real_T Constant4_Value_c;            /* Expression: 0
                                        * Referenced by: '<S16>/Constant4'
                                        */
  real_T Memory1_X0_gf;                /* Expression: 0
                                        * Referenced by: '<S22>/Memory1'
                                        */
  real_T c_eob_Threshold_j;            /* Expression: 1
                                        * Referenced by: '<S22>/c_eob'
                                        */
  real_T Memory2_X0_fl;                /* Expression: 0
                                        * Referenced by: '<S35>/Memory2'
                                        */
  real_T c_eob_Threshold_i;            /* Expression: 1
                                        * Referenced by: '<S35>/c_eob'
                                        */
  real_T Memory2_X0_i;                 /* Expression: 0
                                        * Referenced by: '<S38>/Memory2'
                                        */
  real_T c_eob_Threshold_ph;           /* Expression: 1
                                        * Referenced by: '<S38>/c_eob'
                                        */
  real_T Memory2_X0_fld;               /* Expression: 0
                                        * Referenced by: '<S39>/Memory2'
                                        */
  real_T c_eob_Threshold_nq;           /* Expression: 1
                                        * Referenced by: '<S39>/c_eob'
                                        */
  real_T Memory2_X0_du;                /* Expression: 0
                                        * Referenced by: '<S40>/Memory2'
                                        */
  real_T c_eob_Threshold_ja;           /* Expression: 1
                                        * Referenced by: '<S40>/c_eob'
                                        */
  real_T Memory2_X0_nt;                /* Expression: 0
                                        * Referenced by: '<S41>/Memory2'
                                        */
  real_T c_eob_Threshold_h5;           /* Expression: 1
                                        * Referenced by: '<S41>/c_eob'
                                        */
  real_T Memory2_X0_c;                 /* Expression: 0
                                        * Referenced by: '<S42>/Memory2'
                                        */
  real_T c_eob_Threshold_ii;           /* Expression: 1
                                        * Referenced by: '<S42>/c_eob'
                                        */
  real_T Memory2_X0_ii;                /* Expression: 0
                                        * Referenced by: '<S43>/Memory2'
                                        */
  real_T c_eob_Threshold_e;            /* Expression: 1
                                        * Referenced by: '<S43>/c_eob'
                                        */
  real_T Memory2_X0_j;                 /* Expression: 0
                                        * Referenced by: '<S44>/Memory2'
                                        */
  real_T c_eob_Threshold_ol;           /* Expression: 1
                                        * Referenced by: '<S44>/c_eob'
                                        */
  real_T Memory2_X0_eu;                /* Expression: 0
                                        * Referenced by: '<S45>/Memory2'
                                        */
  real_T c_eob_Threshold_l;            /* Expression: 1
                                        * Referenced by: '<S45>/c_eob'
                                        */
  real_T Memory2_X0_er;                /* Expression: 0
                                        * Referenced by: '<S36>/Memory2'
                                        */
  real_T c_eob_Threshold_hk;           /* Expression: 1
                                        * Referenced by: '<S36>/c_eob'
                                        */
  real_T Memory2_X0_ir;                /* Expression: 0
                                        * Referenced by: '<S37>/Memory2'
                                        */
  real_T c_eob_Threshold_al;           /* Expression: 1
                                        * Referenced by: '<S37>/c_eob'
                                        */
  real_T Memory_X0_c;                  /* Expression: 0
                                        * Referenced by: '<S29>/Memory'
                                        */
  real_T _Threshold_i;                 /* Expression: 0
                                        * Referenced by: '<S20>/3'
                                        */
  real_T _Threshold_o;                 /* Expression: 1
                                        * Referenced by: '<S20>/2'
                                        */
  real_T UD_InitialCondition;          /* Expression: ICPrevInput
                                        * Referenced by: '<S33>/UD'
                                        */
  real_T UD_InitialCondition_c;        /* Expression: ICPrevInput
                                        * Referenced by: '<S34>/UD'
                                        */
  real_T Constant_Value_m;             /* Expression: const
                                        * Referenced by: '<S58>/Constant'
                                        */
  real_T Memory_X0_p;                  /* Expression: 0
                                        * Referenced by: '<S60>/Memory'
                                        */
  real_T Memory1_X0_m;                 /* Expression: 0
                                        * Referenced by: '<S27>/Memory1'
                                        */
  real_T Constant_Value_b;             /* Expression: const
                                        * Referenced by: '<S61>/Constant'
                                        */
  real_T Memory_X0_cp;                 /* Expression: 0
                                        * Referenced by: '<S64>/Memory'
                                        */
  real_T Memory1_X0_n;                 /* Expression: 0
                                        * Referenced by: '<S28>/Memory1'
                                        */
  real_T Memory1_X0_g4;                /* Expression: 0
                                        * Referenced by: '<S30>/Memory1'
                                        */
  real_T Memory2_X0_m;                 /* Expression: 0
                                        * Referenced by: '<S110>/Memory2'
                                        */
  real_T SFunction_P1_Size[2];         /* Computed Parameter: SFunction_P1_Size
                                        * Referenced by: '<S107>/S-Function'
                                        */
  real_T SFunction_P1;                 /* Expression: 20
                                        * Referenced by: '<S107>/S-Function'
                                        */
  real_T SFunction_P2_Size[2];         /* Computed Parameter: SFunction_P2_Size
                                        * Referenced by: '<S107>/S-Function'
                                        */
  real_T SFunction_P2;                 /* Expression: n_mc
                                        * Referenced by: '<S107>/S-Function'
                                        */
  real_T e6_Gain_o;                    /* Expression: 1e6
                                        * Referenced by: '<S96>/1e6'
                                        */
  real_T Gain_Gain_o[220];             /* Expression: eye(20,n_mc)
                                        * Referenced by: '<S106>/Gain'
                                        */
  real_T SFunction_P1_Size_f[2];       /* Computed Parameter: SFunction_P1_Size_f
                                        * Referenced by: '<S106>/S-Function'
                                        */
  real_T SFunction_P1_d;               /* Expression: n_mc
                                        * Referenced by: '<S106>/S-Function'
                                        */
  real_T SFunction_P2_Size_g[2];       /* Computed Parameter: SFunction_P2_Size_g
                                        * Referenced by: '<S106>/S-Function'
                                        */
  real_T SFunction_P2_d;               /* Expression: n_mc
                                        * Referenced by: '<S106>/S-Function'
                                        */
  real_T SFunction_P3_Size[2];         /* Computed Parameter: SFunction_P3_Size
                                        * Referenced by: '<S106>/S-Function'
                                        */
  real_T SFunction_P3;                 /* Expression: 1
                                        * Referenced by: '<S106>/S-Function'
                                        */
  real_T u_Threshold;                  /* Expression: 1
                                        * Referenced by: '<S110>/ 1 '
                                        */
  real_T Memory3_X0;                   /* Expression: 0
                                        * Referenced by: '<S92>/Memory3'
                                        */
  real_T switch1_Threshold_j;          /* Expression: 1
                                        * Referenced by: '<S92>/switch1 '
                                        */
  real_T _Value_a;                     /* Expression: 1
                                        * Referenced by: '<S92>/1'
                                        */
  real_T Saturation1_UpperSat_a;       /* Expression: 1
                                        * Referenced by: '<S92>/Saturation1'
                                        */
  real_T Saturation1_LowerSat_e;       /* Expression: 0
                                        * Referenced by: '<S92>/Saturation1'
                                        */
  real_T Memory1_X0_lx;                /* Expression: 0
                                        * Referenced by: '<S100>/Memory1'
                                        */
  real_T Memory_X0_g;                  /* Expression: 0
                                        * Referenced by: '<S104>/Memory'
                                        */
  real_T SFunction_P1_Size_k[2];       /* Computed Parameter: SFunction_P1_Size_k
                                        * Referenced by: '<S103>/S-Function'
                                        */
  real_T SFunction_P1_k;               /* Expression: 20
                                        * Referenced by: '<S103>/S-Function'
                                        */
  real_T SFunction_P2_Size_gz[2];      /* Computed Parameter: SFunction_P2_Size_gz
                                        * Referenced by: '<S103>/S-Function'
                                        */
  real_T SFunction_P2_c;               /* Expression: n_mc
                                        * Referenced by: '<S103>/S-Function'
                                        */
  real_T SFunction_P3_Size_e[2];       /* Computed Parameter: SFunction_P3_Size_e
                                        * Referenced by: '<S103>/S-Function'
                                        */
  real_T SFunction_P3_g;               /* Expression: 1
                                        * Referenced by: '<S103>/S-Function'
                                        */
  real_T Memory1_X0_j;                 /* Expression: 0
                                        * Referenced by: '<S113>/Memory1'
                                        */
  real_T c_eob_Threshold_hy;           /* Expression: 1
                                        * Referenced by: '<S113>/c_eob'
                                        */
  real_T c_eob_Threshold_o3;           /* Expression: 1
                                        * Referenced by: '<S99>/c_eob'
                                        */
  real_T _Threshold_f;                 /* Expression: 1
                                        * Referenced by: '<S104>/1'
                                        */
  real_T Memory1_X0_o;                 /* Expression: 0
                                        * Referenced by: '<S98>/Memory1'
                                        */
  real_T switch1_Threshold_m;          /* Expression: 1
                                        * Referenced by: '<S98>/switch1'
                                        */
  real_T SFunction_P1_Size_kj[2];      /* Computed Parameter: SFunction_P1_Size_kj
                                        * Referenced by: '<S101>/S-Function'
                                        */
  real_T SFunction_P1_i;               /* Expression: 20
                                        * Referenced by: '<S101>/S-Function'
                                        */
  real_T SFunction_P2_Size_p[2];       /* Computed Parameter: SFunction_P2_Size_p
                                        * Referenced by: '<S101>/S-Function'
                                        */
  real_T SFunction_P2_n;               /* Expression: n_mc
                                        * Referenced by: '<S101>/S-Function'
                                        */
  real_T SFunction_P3_Size_m[2];       /* Computed Parameter: SFunction_P3_Size_m
                                        * Referenced by: '<S101>/S-Function'
                                        */
  real_T SFunction_P3_e;               /* Expression: 2
                                        * Referenced by: '<S101>/S-Function'
                                        */
  real_T Memory1_X0_gg;                /* Expression: 0
                                        * Referenced by: '<S95>/Memory1'
                                        */
  real_T _Threshold_fg;                /* Expression: 1
                                        * Referenced by: '<S95>/1 '
                                        */
  real_T _Value_e;                     /* Expression: 1
                                        * Referenced by: '<S95>/1'
                                        */
  real_T Saturation_UpperSat_m;        /* Expression: 1
                                        * Referenced by: '<S95>/Saturation'
                                        */
  real_T Saturation_LowerSat_o;        /* Expression: 0
                                        * Referenced by: '<S95>/Saturation'
                                        */
  real_T G_curr_term1_Gain[220];       /* Expression: [zeros(8,11); eye(11); zeros(1,11)]
                                        * Referenced by: '<S97>/ G_curr_term 1'
                                        */
  real_T SFunction_P1_Size_a[2];       /* Computed Parameter: SFunction_P1_Size_a
                                        * Referenced by: '<S111>/S-Function'
                                        */
  real_T SFunction_P1_j;               /* Expression: 20
                                        * Referenced by: '<S111>/S-Function'
                                        */
  real_T SFunction_P2_Size_b[2];       /* Computed Parameter: SFunction_P2_Size_b
                                        * Referenced by: '<S111>/S-Function'
                                        */
  real_T SFunction_P2_p;               /* Expression: n_mc
                                        * Referenced by: '<S111>/S-Function'
                                        */
  real_T SFunction_P3_Size_a[2];       /* Computed Parameter: SFunction_P3_Size_a
                                        * Referenced by: '<S111>/S-Function'
                                        */
  real_T SFunction_P3_k;               /* Expression: 2
                                        * Referenced by: '<S111>/S-Function'
                                        */
  real_T u01_Gain;                     /* Expression: 1e-3
                                        * Referenced by: '<S116>/0.001'
                                        */
  real_T u01_Gain_o;                   /* Expression: 1e-3
                                        * Referenced by: '<S119>/0.001'
                                        */
  real_T u01_Gain_o2;                  /* Expression: 1e-3
                                        * Referenced by: '<S120>/0.001'
                                        */
  real_T u01_Gain_n;                   /* Expression: 1e-3
                                        * Referenced by: '<S121>/0.001'
                                        */
  real_T u01_Gain_j;                   /* Expression: 1e-3
                                        * Referenced by: '<S122>/0.001'
                                        */
  real_T u01_Gain_d;                   /* Expression: 1e-3
                                        * Referenced by: '<S123>/0.001'
                                        */
  real_T u01_Gain_m;                   /* Expression: 1e-3
                                        * Referenced by: '<S124>/0.001'
                                        */
  real_T u01_Gain_i;                   /* Expression: 1e-3
                                        * Referenced by: '<S125>/0.001'
                                        */
  real_T u01_Gain_f;                   /* Expression: 1e-3
                                        * Referenced by: '<S126>/0.001'
                                        */
  real_T u01_Gain_iy;                  /* Expression: 1e-3
                                        * Referenced by: '<S117>/0.001'
                                        */
  real_T u01_Gain_os;                  /* Expression: 1e-3
                                        * Referenced by: '<S118>/0.001'
                                        */
  real_T _Value_p;                     /* Expression: 1
                                        * Referenced by: '<S65>/1'
                                        */
  real_T Constant_Value_k;             /* Expression: 0
                                        * Referenced by: '<S71>/Constant'
                                        */
  real_T e3_Gain_b;                    /* Expression: 1e3
                                        * Referenced by: '<S65>/1e3'
                                        */
  real_T Saturation_UpperSat_n;        /* Expression: 1
                                        * Referenced by: '<S65>/Saturation'
                                        */
  real_T Saturation_LowerSat_p;        /* Expression: -1
                                        * Referenced by: '<S65>/Saturation'
                                        */
  real_T Constant_Value_ir;            /* Expression: const
                                        * Referenced by: '<S70>/Constant'
                                        */
  real_T Switch_Threshold;             /* Expression: 1
                                        * Referenced by: '<S65>/Switch'
                                        */
  real_T u5_Gain_g;                    /* Expression: 1/15
                                        * Referenced by: '<S89>/1//15'
                                        */
  real_T _Value_aq;                    /* Expression: 0
                                        * Referenced by: '<S89>/1'
                                        */
  real_T UniformRandomNumber_Minimum;  /* Expression: -1
                                        * Referenced by: '<S73>/Uniform Random Number'
                                        */
  real_T UniformRandomNumber_Maximum;  /* Expression: 1
                                        * Referenced by: '<S73>/Uniform Random Number'
                                        */
  real_T UniformRandomNumber_Seed;     /* Expression: 0
                                        * Referenced by: '<S73>/Uniform Random Number'
                                        */
  real_T u5_Gain_c;                    /* Expression: 1.75
                                        * Referenced by: '<S77>/1.75'
                                        */
  real_T UD_InitialCondition_g;        /* Expression: ICPrevInput
                                        * Referenced by: '<S78>/UD'
                                        */
  real_T e3_Gain_a;                    /* Expression: 2e3
                                        * Referenced by: '<S77>/2e3'
                                        */
  real_T eye202_Gain[40];              /* Expression: eye(20,2)
                                        * Referenced by: '<S88>/ eye(20,2)'
                                        */
  real_T SFunction_P1_Size_p[2];       /* Computed Parameter: SFunction_P1_Size_p
                                        * Referenced by: '<S88>/S-Function'
                                        */
  real_T SFunction_P1_a;               /* Expression: 2
                                        * Referenced by: '<S88>/S-Function'
                                        */
  real_T SFunction_P2_Size_p5[2];      /* Computed Parameter: SFunction_P2_Size_p5
                                        * Referenced by: '<S88>/S-Function'
                                        */
  real_T SFunction_P2_b;               /* Expression: 2
                                        * Referenced by: '<S88>/S-Function'
                                        */
  real_T SFunction_P3_Size_g[2];       /* Computed Parameter: SFunction_P3_Size_g
                                        * Referenced by: '<S88>/S-Function'
                                        */
  real_T SFunction_P3_i;               /* Expression: 1
                                        * Referenced by: '<S88>/S-Function'
                                        */
  real_T Constant_Value_kq;            /* Expression: const
                                        * Referenced by: '<S79>/Constant'
                                        */
  real_T eye202_Gain_n[40];            /* Expression: eye(20,2)
                                        * Referenced by: '<S83>/ eye(20,2)'
                                        */
  real_T SFunction_P1_Size_h[2];       /* Computed Parameter: SFunction_P1_Size_h
                                        * Referenced by: '<S83>/S-Function'
                                        */
  real_T SFunction_P1_n;               /* Expression: 2
                                        * Referenced by: '<S83>/S-Function'
                                        */
  real_T SFunction_P2_Size_m[2];       /* Computed Parameter: SFunction_P2_Size_m
                                        * Referenced by: '<S83>/S-Function'
                                        */
  real_T SFunction_P2_k;               /* Expression: 2
                                        * Referenced by: '<S83>/S-Function'
                                        */
  real_T SFunction_P3_Size_o[2];       /* Computed Parameter: SFunction_P3_Size_o
                                        * Referenced by: '<S83>/S-Function'
                                        */
  real_T SFunction_P3_ei;              /* Expression: 2
                                        * Referenced by: '<S83>/S-Function'
                                        */
  real_T c_eob1_Threshold_a;           /* Expression: 1
                                        * Referenced by: '<S67>/c_eob1'
                                        */
  real_T UD_InitialCondition_f;        /* Expression: ICPrevInput
                                        * Referenced by: '<S8>/UD'
                                        */
  real_T u_Gain;                       /* Expression: -1
                                        * Referenced by: '<S10>/-1'
                                        */
  real_T Gain_Gain_k;                  /* Expression: -1
                                        * Referenced by: '<S11>/Gain'
                                        */
  real_T wz1_Value[11];                /* Expression: [0 0 0 0 0 0 -1 -1 1 1 0]'
                                        * Referenced by: '<S3>/wz1'
                                        */
  real_T wz2_Value;                    /* Expression: 1
                                        * Referenced by: '<S3>/wz2'
                                        */
  real_T npf12_Gain[180];              /* Expression: eye(15,11+1)
                                        * Referenced by: '<S3>/npf,12'
                                        */
  real_T Memory2_X0_a;                 /* Expression: 0
                                        * Referenced by: '<S18>/Memory2'
                                        */
  real_T u_Gain_d;                     /* Expression: -1
                                        * Referenced by: '<S18>/-1'
                                        */
  real_T Ip1e4_Threshold;              /* Expression: -1e-4
                                        * Referenced by: '<S18>/Ip<1e-4 '
                                        */
  real_T Constant4_Value_m;            /* Expression: 50
                                        * Referenced by: '<S18>/Constant4'
                                        */
  real_T _InitialValue;                /* Expression: 1e3
                                        * Referenced by: '<S1>/ '
                                        */
  real_T DataStoreMemory10_InitialValue;/* Expression: 0
                                         * Referenced by: '<S1>/Data Store Memory10'
                                         */
  real_T DataStoreMemory11_InitialValue;/* Expression: 0
                                         * Referenced by: '<S1>/Data Store Memory11'
                                         */
  real_T DataStoreMemory111_InitialValue;/* Expression: 1000
                                          * Referenced by: '<S1>/Data Store Memory111'
                                          */
  real_T DataStoreMemory112_InitialValue;/* Expression: 1000
                                          * Referenced by: '<S1>/Data Store Memory112'
                                          */
  real_T DataStoreMemory12_InitialValue;/* Expression: 0
                                         * Referenced by: '<S1>/Data Store Memory12'
                                         */
  real_T DataStoreMemory13_InitialValue;/* Expression: 0
                                         * Referenced by: '<S1>/Data Store Memory13'
                                         */
  real_T DataStoreMemory14_InitialValue;/* Expression: 0
                                         * Referenced by: '<S1>/Data Store Memory14'
                                         */
  real_T DataStoreMemory15_InitialValue;/* Expression: 0
                                         * Referenced by: '<S1>/Data Store Memory15'
                                         */
  real_T DataStoreMemory16_InitialValue;/* Expression: 0
                                         * Referenced by: '<S1>/Data Store Memory16'
                                         */
  real_T DataStoreMemory17_InitialValue;/* Expression: 0
                                         * Referenced by: '<S1>/Data Store Memory17'
                                         */
  real_T DataStoreMemory18_InitialValue;/* Expression: 0
                                         * Referenced by: '<S1>/Data Store Memory18'
                                         */
  real_T DataStoreMemory19_InitialValue;/* Expression: 0
                                         * Referenced by: '<S1>/Data Store Memory19'
                                         */
  real_T DataStoreMemory20_InitialValue;/* Expression: 0.1
                                         * Referenced by: '<S1>/Data Store Memory20'
                                         */
  real_T DataStoreMemory21_InitialValue;/* Expression: 1e-3
                                         * Referenced by: '<S1>/Data Store Memory21'
                                         */
  real_T DataStoreMemory22_InitialValue;/* Expression: 1e-3
                                         * Referenced by: '<S1>/Data Store Memory22'
                                         */
  real_T DataStoreMemory23_InitialValue;/* Expression: 0
                                         * Referenced by: '<S1>/Data Store Memory23'
                                         */
  real_T DataStoreMemory24_InitialValue;/* Expression: 0
                                         * Referenced by: '<S1>/Data Store Memory24'
                                         */
  real_T DataStoreMemory25_InitialValue;/* Expression: 0
                                         * Referenced by: '<S1>/Data Store Memory25'
                                         */
  real_T DataStoreMemory6_InitialValue;/* Expression: 0
                                        * Referenced by: '<S1>/Data Store Memory6'
                                        */
  real_T ElongMemory_InitialValue[100];/* Expression: [0:49;zeros(1,50)]
                                        * Referenced by: '<S1>/Elong Memory'
                                        */
  real_T ImaxMemory_InitialValue[11];  /* Expression: ones(1,11)*1e6
                                        * Referenced by: '<S1>/Imax Memory'
                                        */
  real_T RupRdMemory_InitialValue[6];  /* Expression: [1; ones(3,1)*1e-6; -1e6; 1e-6]
                                        * Referenced by: '<S1>/RupRd Memory'
                                        */
  real_T TuMemory_InitialValue;        /* Expression: 0
                                        * Referenced by: '<S1>/Tu Memory'
                                        */
  real_T VS1Memory_InitialValue;       /* Expression: 0
                                        * Referenced by: '<S1>/VS1 Memory'
                                        */
  real_T VS3Memory_InitialValue;       /* Expression: 0
                                        * Referenced by: '<S1>/VS3 Memory'
                                        */
  real_T VcspfMemory_InitialValue[11]; /* Expression: zeros(11,1)
                                        * Referenced by: '<S1>/Vcspf Memory'
                                        */
  real_T VoltMemory_InitialValue[10000];/* Expression: [(0:499);zeros(19,500)]
                                         * Referenced by: '<S1>/Volt Memory'
                                         */
  real_T currMemory_InitialValue;      /* Expression: 0
                                        * Referenced by: '<S1>/curr Memory'
                                        */
  real_T g1Memory_InitialValue[100];   /* Expression: [0:49;zeros(1,50)]
                                        * Referenced by: '<S1>/g1 Memory'
                                        */
  real_T g1_tMemory_InitialValue[100]; /* Expression: zeros(2, 50)
                                        * Referenced by: '<S1>/g1_t Memory'
                                        */
  real_T g2Memory_InitialValue[100];   /* Expression: [0:49;zeros(1,50)]
                                        * Referenced by: '<S1>/g2 Memory'
                                        */
  real_T g2_tMemory_InitialValue[100]; /* Expression: zeros(2, 50)
                                        * Referenced by: '<S1>/g2_t Memory'
                                        */
  real_T g3Memory_InitialValue[100];   /* Expression: [0:49;zeros(1,50)]
                                        * Referenced by: '<S1>/g3 Memory'
                                        */
  real_T g3_tMemory_InitialValue[100]; /* Expression: zeros(2, 50)
                                        * Referenced by: '<S1>/g3_t Memory'
                                        */
  real_T g4Memory_InitialValue[100];   /* Expression: [0:49;zeros(1,50)]
                                        * Referenced by: '<S1>/g4 Memory'
                                        */
  real_T g4_tMemory_InitialValue[100]; /* Expression: zeros(2, 50)
                                        * Referenced by: '<S1>/g4_t Memory'
                                        */
  real_T g5Memory_InitialValue[100];   /* Expression: [0:49;zeros(1,50)]
                                        * Referenced by: '<S1>/g5 Memory'
                                        */
  real_T g5_tMemory_InitialValue[100]; /* Expression: zeros(2, 50)
                                        * Referenced by: '<S1>/g5_t Memory'
                                        */
  real_T g6Memory_InitialValue[100];   /* Expression: [0:49;zeros(1,50)]
                                        * Referenced by: '<S1>/g6 Memory'
                                        */
  real_T g6_tMemory_InitialValue[100]; /* Expression: zeros(2, 50)
                                        * Referenced by: '<S1>/g6_t Memory'
                                        */
  real_T nturMemory_InitialValue[12];  /* Expression: [554,554,554,554,554  248.6 115.2 185.9 169.9 216.8  459.4 1]
                                        * Referenced by: '<S1>/ntur Memory'
                                        */
  real_T scrMemory_InitialValue[6500]; /* Expression: [(0:499); zeros(12,500)]
                                        * Referenced by: '<S1>/scr Memory'
                                        */
};

/* Real-time Model Data Structure */
struct tag_RTM_t15_2 {
  struct SimStruct_tag * *childSfunctions;
  const char_T * volatile errorStatus;
  SS_SimMode simMode;
  RTWSolverInfo solverInfo;
  RTWSolverInfo *solverInfoPtr;
  void *sfcnInfo;

  /*
   * NonInlinedSFcns:
   * The following substructure contains information regarding
   * non-inlined s-functions used in the model.
   */
  struct {
    RTWSfcnInfo sfcnInfo;
    time_T *taskTimePtrs[1];
    SimStruct childSFunctions[24];
    SimStruct *childSFunctionPtrs[24];
    struct _ssBlkInfo2 blkInfo2[24];
    struct _ssSFcnModelMethods2 methods2[24];
    struct _ssSFcnModelMethods3 methods3[24];
    struct _ssStatesInfo2 statesInfo2[24];
    struct {
      time_T sfcnPeriod[1];
      time_T sfcnOffset[1];
      int_T sfcnTsMap[1];
      struct _ssPortOutputs outputPortInfo[1];
    } Sfcn0;

    struct {
      time_T sfcnPeriod[1];
      time_T sfcnOffset[1];
      int_T sfcnTsMap[1];
      struct _ssPortOutputs outputPortInfo[1];
    } Sfcn1;

    struct {
      time_T sfcnPeriod[1];
      time_T sfcnOffset[1];
      int_T sfcnTsMap[1];
      struct _ssPortOutputs outputPortInfo[1];
      int_T oDims0[2];
      uint_T attribs[1];
      mxArray *params[1];
    } Sfcn2;

    struct {
      time_T sfcnPeriod[1];
      time_T sfcnOffset[1];
      int_T sfcnTsMap[1];
      struct _ssPortOutputs outputPortInfo[1];
      int_T oDims0[2];
      uint_T attribs[1];
      mxArray *params[1];
    } Sfcn3;

    struct {
      time_T sfcnPeriod[1];
      time_T sfcnOffset[1];
      int_T sfcnTsMap[1];
      struct _ssPortOutputs outputPortInfo[1];
      int_T oDims0[2];
      uint_T attribs[1];
      mxArray *params[1];
    } Sfcn4;

    struct {
      time_T sfcnPeriod[1];
      time_T sfcnOffset[1];
      int_T sfcnTsMap[1];
      struct _ssPortOutputs outputPortInfo[1];
      int_T oDims0[2];
      uint_T attribs[1];
      mxArray *params[1];
    } Sfcn5;

    struct {
      time_T sfcnPeriod[1];
      time_T sfcnOffset[1];
      int_T sfcnTsMap[1];
      struct _ssPortOutputs outputPortInfo[1];
      int_T oDims0[2];
      uint_T attribs[1];
      mxArray *params[1];
    } Sfcn6;

    struct {
      time_T sfcnPeriod[1];
      time_T sfcnOffset[1];
      int_T sfcnTsMap[1];
      struct _ssPortOutputs outputPortInfo[1];
      int_T oDims0[2];
      uint_T attribs[1];
      mxArray *params[1];
    } Sfcn7;

    struct {
      time_T sfcnPeriod[1];
      time_T sfcnOffset[1];
      int_T sfcnTsMap[1];
      struct _ssPortOutputs outputPortInfo[1];
      int_T oDims0[2];
      uint_T attribs[1];
      mxArray *params[1];
    } Sfcn8;

    struct {
      time_T sfcnPeriod[1];
      time_T sfcnOffset[1];
      int_T sfcnTsMap[1];
      struct _ssPortOutputs outputPortInfo[1];
      int_T oDims0[2];
      uint_T attribs[1];
      mxArray *params[1];
    } Sfcn9;

    struct {
      time_T sfcnPeriod[1];
      time_T sfcnOffset[1];
      int_T sfcnTsMap[1];
      struct _ssPortOutputs outputPortInfo[1];
      int_T oDims0[2];
      uint_T attribs[1];
      mxArray *params[1];
    } Sfcn10;

    struct {
      time_T sfcnPeriod[1];
      time_T sfcnOffset[1];
      int_T sfcnTsMap[1];
      struct _ssPortOutputs outputPortInfo[1];
      int_T oDims0[2];
      uint_T attribs[1];
      mxArray *params[1];
    } Sfcn11;

    struct {
      time_T sfcnPeriod[1];
      time_T sfcnOffset[1];
      int_T sfcnTsMap[1];
      struct _ssPortOutputs outputPortInfo[1];
      int_T oDims0[2];
      uint_T attribs[1];
      mxArray *params[1];
    } Sfcn12;

    struct {
      time_T sfcnPeriod[1];
      time_T sfcnOffset[1];
      int_T sfcnTsMap[1];
      struct _ssPortOutputs outputPortInfo[1];
      int_T oDims0[2];
      uint_T attribs[1];
      mxArray *params[1];
    } Sfcn13;

    struct {
      time_T sfcnPeriod[1];
      time_T sfcnOffset[1];
      int_T sfcnTsMap[1];
      struct _ssPortOutputs outputPortInfo[1];
      int_T oDims0[2];
      uint_T attribs[1];
      mxArray *params[1];
    } Sfcn14;

    struct {
      time_T sfcnPeriod[1];
      time_T sfcnOffset[1];
      int_T sfcnTsMap[1];
      struct _ssPortOutputs outputPortInfo[1];
      int_T oDims0[2];
      uint_T attribs[1];
      mxArray *params[1];
    } Sfcn15;

    struct {
      time_T sfcnPeriod[1];
      time_T sfcnOffset[1];
      int_T sfcnTsMap[1];
      struct _ssPortOutputs outputPortInfo[1];
      int_T oDims0[2];
      uint_T attribs[1];
      mxArray *params[1];
    } Sfcn16;

    struct {
      time_T sfcnPeriod[1];
      time_T sfcnOffset[1];
      int_T sfcnTsMap[1];
      struct _ssPortInputs inputPortInfo[1];
      struct _ssPortOutputs outputPortInfo[1];
      uint_T attribs[2];
      mxArray *params[2];
      struct _ssDWorkRecord dWork[1];
      struct _ssDWorkAuxRecord dWorkAux[1];
    } Sfcn17;

    struct {
      time_T sfcnPeriod[1];
      time_T sfcnOffset[1];
      int_T sfcnTsMap[1];
      struct _ssPortInputs inputPortInfo[1];
      struct _ssPortOutputs outputPortInfo[1];
      uint_T attribs[3];
      mxArray *params[3];
      struct _ssDWorkRecord dWork[1];
      struct _ssDWorkAuxRecord dWorkAux[1];
    } Sfcn18;

    struct {
      time_T sfcnPeriod[1];
      time_T sfcnOffset[1];
      int_T sfcnTsMap[1];
      struct _ssPortInputs inputPortInfo[1];
      struct _ssPortOutputs outputPortInfo[1];
      uint_T attribs[3];
      mxArray *params[3];
      struct _ssDWorkRecord dWork[1];
      struct _ssDWorkAuxRecord dWorkAux[1];
    } Sfcn19;

    struct {
      time_T sfcnPeriod[1];
      time_T sfcnOffset[1];
      int_T sfcnTsMap[1];
      struct _ssPortInputs inputPortInfo[1];
      struct _ssPortOutputs outputPortInfo[1];
      uint_T attribs[3];
      mxArray *params[3];
      struct _ssDWorkRecord dWork[1];
      struct _ssDWorkAuxRecord dWorkAux[1];
    } Sfcn20;

    struct {
      time_T sfcnPeriod[1];
      time_T sfcnOffset[1];
      int_T sfcnTsMap[1];
      struct _ssPortInputs inputPortInfo[1];
      int_T iDims0[2];
      struct _ssPortOutputs outputPortInfo[1];
      int_T oDims0[2];
      uint_T attribs[3];
      mxArray *params[3];
      struct _ssDWorkRecord dWork[1];
      struct _ssDWorkAuxRecord dWorkAux[1];
    } Sfcn21;

    struct {
      time_T sfcnPeriod[1];
      time_T sfcnOffset[1];
      int_T sfcnTsMap[1];
      struct _ssPortInputs inputPortInfo[1];
      struct _ssPortOutputs outputPortInfo[1];
      uint_T attribs[3];
      mxArray *params[3];
      struct _ssDWorkRecord dWork[1];
      struct _ssDWorkAuxRecord dWorkAux[1];
    } Sfcn22;

    struct {
      time_T sfcnPeriod[1];
      time_T sfcnOffset[1];
      int_T sfcnTsMap[1];
      struct _ssPortInputs inputPortInfo[1];
      struct _ssPortOutputs outputPortInfo[1];
      uint_T attribs[3];
      mxArray *params[3];
      struct _ssDWorkRecord dWork[1];
      struct _ssDWorkAuxRecord dWorkAux[1];
    } Sfcn23;
  } NonInlinedSFcns;

  /*
   * ModelData:
   * The following substructure contains information regarding
   * the data used in the model.
   */
  struct {
    boolean_T zCCacheNeedsReset;
    boolean_T derivCacheNeedsReset;
    boolean_T blkStateChange;
  } ModelData;

  /*
   * Sizes:
   * The following substructure contains sizes information
   * for many of the model attributes such as inputs, outputs,
   * dwork, sample times, etc.
   */
  struct {
    uint32_T options;
    int_T numContStates;
    int_T numU;
    int_T numY;
    int_T numSampTimes;
    int_T numBlocks;
    int_T numBlockIO;
    int_T numBlockPrms;
    int_T numDwork;
    int_T numSFcnPrms;
    int_T numSFcns;
    int_T numIports;
    int_T numOports;
    int_T numNonSampZCs;
    int_T sysDirFeedThru;
    int_T rtwGenSfcn;
  } Sizes;

  /*
   * Timing:
   * The following substructure contains information regarding
   * the timing information for the model.
   */
  struct {
    time_T stepSize;
    uint32_T clockTick0;
    time_T stepSize0;
    time_T tStart;
    time_T tFinal;
    time_T timeOfLastOutput;
    boolean_T stopRequestedFlag;
    time_T *sampleTimes;
    time_T *offsetTimes;
    int_T *sampleTimeTaskIDPtr;
    int_T *sampleHits;
    int_T *perTaskSampleHits;
    time_T *t;
    time_T sampleTimesArray[1];
    time_T offsetTimesArray[1];
    int_T sampleTimeTaskIDArray[1];
    int_T sampleHitArray[1];
    int_T perTaskSampleHitsArray[1];
    time_T tArray[1];
  } Timing;
};

/* Block parameters (auto storage) */
extern Parameters_t15_2 t15_2_P;

/* Block signals (auto storage) */
extern BlockIO_t15_2 t15_2_B;

/* Block states (auto storage) */
extern D_Work_t15_2 t15_2_DWork;

/* External inputs (root inport signals with auto storage) */
extern ExternalInputs_t15_2 t15_2_U;

/* External outputs (root outports fed by signals with auto storage) */
extern ExternalOutputs_t15_2 t15_2_Y;

/* Model entry point functions */
extern void t15_2_initialize(void);
extern void t15_2_step(void);
extern void t15_2_terminate(void);

/* Real-time Model object */
extern RT_MODEL_t15_2 *const t15_2_M;

/*-
 * These blocks were eliminated from the model due to optimizations:
 *
 * Block '<S3>/Memory1' : Unused code path elimination
 * Block '<S3>/Memory2' : Unused code path elimination
 * Block '<S3>/Memory3' : Unused code path elimination
 * Block '<S3>/To Workspace1' : Unused code path elimination
 * Block '<S3>/To Workspace2' : Unused code path elimination
 * Block '<S3>/To Workspace3' : Unused code path elimination
 * Block '<S12>/Data Type Duplicate' : Unused code path elimination
 * Block '<S12>/Data Type Propagation' : Unused code path elimination
 * Block '<S13>/Data Type Duplicate' : Unused code path elimination
 * Block '<S13>/Data Type Propagation' : Unused code path elimination
 * Block '<S9>/To Workspace1' : Unused code path elimination
 * Block '<S14>/Data Type Duplicate' : Unused code path elimination
 * Block '<S14>/Data Type Propagation' : Unused code path elimination
 * Block '<S15>/Data Type Duplicate' : Unused code path elimination
 * Block '<S15>/Data Type Propagation' : Unused code path elimination
 * Block '<S1>/Time' : Unused code path elimination
 * Block '<S16>/To Workspace1' : Unused code path elimination
 * Block '<S16>/To Workspace2' : Unused code path elimination
 * Block '<S16>/To Workspace3' : Unused code path elimination
 * Block '<S66>/To Workspace' : Unused code path elimination
 * Block '<S84>/Data Type Duplicate' : Unused code path elimination
 * Block '<S84>/Data Type Propagation' : Unused code path elimination
 * Block '<S85>/Data Type Duplicate' : Unused code path elimination
 * Block '<S85>/Data Type Propagation' : Unused code path elimination
 * Block '<S90>/Data Type Duplicate' : Unused code path elimination
 * Block '<S90>/Data Type Propagation' : Unused code path elimination
 * Block '<S91>/Data Type Duplicate' : Unused code path elimination
 * Block '<S91>/Data Type Propagation' : Unused code path elimination
 * Block '<S114>/Data Type Duplicate' : Unused code path elimination
 * Block '<S114>/Data Type Propagation' : Unused code path elimination
 * Block '<S19>/A' : Unused code path elimination
 * Block '<S19>/A  ' : Unused code path elimination
 * Block '<S19>/To Workspace21' : Unused code path elimination
 * Block '<S19>/To Workspace5' : Unused code path elimination
 * Block '<S19>/To Workspace7' : Unused code path elimination
 * Block '<S19>/klim' : Unused code path elimination
 * Block '<S19>/m' : Unused code path elimination
 * Block '<S19>/m  ' : Unused code path elimination
 * Block '<S19>/m   ' : Unused code path elimination
 * Block '<S19>/rsep' : Unused code path elimination
 * Block '<S19>/rsep1' : Unused code path elimination
 * Block '<S19>/xleft' : Unused code path elimination
 * Block '<S19>/xright' : Unused code path elimination
 * Block '<S19>/zsep' : Unused code path elimination
 */

/*-
 * The generated code includes comments that allow you to trace directly
 * back to the appropriate location in the model.  The basic format
 * is <system>/block_name, where system is the system number (uniquely
 * assigned by Simulink) and block_name is the name of the block.
 *
 * Use the MATLAB hilite_system command to trace the generated code back
 * to the model.  For example,
 *
 * hilite_system('<S3>')    - opens system 3
 * hilite_system('<S3>/Kp') - opens and selects block Kp which resides in S3
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 't15_2'
 * '<S1>'   : 't15_2/Pow. Supply MC 2'
 * '<S2>'   : 't15_2/Pow. Supply MC 2/  '
 * '<S3>'   : 't15_2/Pow. Supply MC 2/Commutation for Dina'
 * '<S4>'   : 't15_2/Pow. Supply MC 2/Pow. Supply MC 2'
 * '<S5>'   : 't15_2/Pow. Supply MC 2/Pow. Supply VS1,3'
 * '<S6>'   : 't15_2/Pow. Supply MC 2/kavin_contr'
 * '<S7>'   : 't15_2/Pow. Supply MC 2/  /If Action'
 * '<S8>'   : 't15_2/Pow. Supply MC 2/Pow. Supply MC 2/Difference'
 * '<S9>'   : 't15_2/Pow. Supply MC 2/Pow. Supply MC 2/Pow. Supply MC 1'
 * '<S10>'  : 't15_2/Pow. Supply MC 2/Pow. Supply MC 2/Pow. Supply MC 1/MC rate'
 * '<S11>'  : 't15_2/Pow. Supply MC 2/Pow. Supply MC 2/Pow. Supply MC 1/MC satur.'
 * '<S12>'  : 't15_2/Pow. Supply MC 2/Pow. Supply MC 2/Pow. Supply MC 1/MC rate/Saturation Dynamic'
 * '<S13>'  : 't15_2/Pow. Supply MC 2/Pow. Supply MC 2/Pow. Supply MC 1/MC satur./Saturation Dynamic'
 * '<S14>'  : 't15_2/Pow. Supply MC 2/Pow. Supply VS1,3/Saturation Dynamic'
 * '<S15>'  : 't15_2/Pow. Supply MC 2/Pow. Supply VS1,3/Saturation Dynamic1'
 * '<S16>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1'
 * '<S17>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1'
 * '<S18>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Ipl_timestop'
 * '<S19>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Subsystem1'
 * '<S20>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/Err.1'
 * '<S21>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/Ics1_end'
 * '<S22>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/Ip_ref scr_data.dat'
 * '<S23>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/dZ//dt'
 * '<S24>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/elong_ref.dat'
 * '<S25>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/err(Ic) scr_data.dat'
 * '<S26>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/g1-g6.dat,g1_term-g6_term.dat'
 * '<S27>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/trd'
 * '<S28>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/tterm'
 * '<S29>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/Err.1/Trigger'
 * '<S30>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/Err.1/tdiv if Ip is set '
 * '<S31>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/Err.1/tdiv if Ip is set /If Action '
 * '<S32>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/Ics1_end/Trigger'
 * '<S33>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/dZ//dt/Difference'
 * '<S34>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/dZ//dt/Difference1'
 * '<S35>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/err(Ic) scr_data.dat/Icoil1 ref'
 * '<S36>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/err(Ic) scr_data.dat/Icoil10 ref'
 * '<S37>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/err(Ic) scr_data.dat/Icoil11 ref'
 * '<S38>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/err(Ic) scr_data.dat/Icoil2 ref'
 * '<S39>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/err(Ic) scr_data.dat/Icoil3 ref'
 * '<S40>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/err(Ic) scr_data.dat/Icoil4 ref'
 * '<S41>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/err(Ic) scr_data.dat/Icoil5 ref'
 * '<S42>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/err(Ic) scr_data.dat/Icoil6 ref'
 * '<S43>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/err(Ic) scr_data.dat/Icoil7 ref'
 * '<S44>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/err(Ic) scr_data.dat/Icoil8 ref'
 * '<S45>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/err(Ic) scr_data.dat/Icoil9 ref'
 * '<S46>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/g1-g6.dat,g1_term-g6_term.dat/g1'
 * '<S47>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/g1-g6.dat,g1_term-g6_term.dat/g2'
 * '<S48>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/g1-g6.dat,g1_term-g6_term.dat/g3'
 * '<S49>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/g1-g6.dat,g1_term-g6_term.dat/g4'
 * '<S50>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/g1-g6.dat,g1_term-g6_term.dat/g5'
 * '<S51>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/g1-g6.dat,g1_term-g6_term.dat/g6'
 * '<S52>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/g1-g6.dat,g1_term-g6_term.dat/g1/g1_term,ref'
 * '<S53>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/g1-g6.dat,g1_term-g6_term.dat/g2/g2_term,ref'
 * '<S54>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/g1-g6.dat,g1_term-g6_term.dat/g3/g3_term,ref'
 * '<S55>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/g1-g6.dat,g1_term-g6_term.dat/g4/g4_term,ref'
 * '<S56>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/g1-g6.dat,g1_term-g6_term.dat/g5/g5_term,ref'
 * '<S57>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/g1-g6.dat,g1_term-g6_term.dat/g6/g6_term,ref'
 * '<S58>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/trd/Compare To Constant1'
 * '<S59>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/trd/If Action Subsystem2'
 * '<S60>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/trd/Trigger'
 * '<S61>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/tterm/Compare To Constant1'
 * '<S62>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/tterm/If Action Subsystem2'
 * '<S63>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/tterm/Ip<cIp_end'
 * '<S64>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/tterm/Trigger'
 * '<S65>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/Curr. satur.1'
 * '<S66>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/Sum'
 * '<S67>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/VS control'
 * '<S68>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/controllers'
 * '<S69>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/volt.dat'
 * '<S70>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/Curr. satur.1/Compare To Constant'
 * '<S71>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/Curr. satur.1/Compare To Zero'
 * '<S72>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/VS control/Ip>cIp_end'
 * '<S73>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/VS control/dzdt noise1'
 * '<S74>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/VS control/eob < 1'
 * '<S75>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/VS control/eob >= 1'
 * '<S76>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/VS control/t_tran2D'
 * '<S77>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/VS control/dzdt noise1/Subsystem'
 * '<S78>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/VS control/dzdt noise1/Subsystem/Difference'
 * '<S79>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/VS control/eob < 1/Compare To Constant1'
 * '<S80>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/VS control/eob < 1/Ip < Ip_rd'
 * '<S81>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/VS control/eob < 1/Ip > Ip_rd'
 * '<S82>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/VS control/eob < 1/Ip_rd tr'
 * '<S83>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/VS control/eob < 1/VS. contr hl'
 * '<S84>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/VS control/eob < 1/Ip < Ip_rd/Saturation Dynamic'
 * '<S85>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/VS control/eob < 1/Ip > Ip_rd/Saturation Dynamic1'
 * '<S86>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/VS control/eob < 1/Ip_rd tr/Compare To Constant1'
 * '<S87>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/VS control/eob < 1/Ip_rd tr/Compare To Constant2'
 * '<S88>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/VS control/eob >= 1/VS. contr1'
 * '<S89>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/VS control/eob >= 1/dim or lim'
 * '<S90>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/VS control/eob >= 1/dim or lim/Saturation Dynamic'
 * '<S91>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/VS control/eob >= 1/dim or lim/Saturation Dynamic1'
 * '<S92>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/controllers/ tt_kavin2.dat(1)'
 * '<S93>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/controllers/Div rd contr'
 * '<S94>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/controllers/Div. contr'
 * '<S95>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/controllers/Ip>cIp_end1'
 * '<S96>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/controllers/Lim. contr.1'
 * '<S97>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/controllers/curr term contr'
 * '<S98>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/controllers/div_divrd'
 * '<S99>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/controllers/gain'
 * '<S100>' : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/controllers/tt_kavin2.dat(1,4)1'
 * '<S101>' : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/controllers/Div rd contr/Div_rd contr'
 * '<S102>' : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/controllers/Div rd contr/div_rd tr'
 * '<S103>' : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/controllers/Div. contr/Div. contr.'
 * '<S104>' : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/controllers/Div. contr/Udiv'
 * '<S105>' : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/controllers/Div. contr/div tr'
 * '<S106>' : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/controllers/Lim. contr.1/Curr. contr.'
 * '<S107>' : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/controllers/Lim. contr.1/Lim. contr.'
 * '<S108>' : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/controllers/Lim. contr.1/gain_cont2'
 * '<S109>' : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/controllers/Lim. contr.1/t_cont2'
 * '<S110>' : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/controllers/Lim. contr.1/t_cont2_1'
 * '<S111>' : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/controllers/curr term contr/Curr. term. contr'
 * '<S112>' : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/controllers/curr term contr/term tr'
 * '<S113>' : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/controllers/gain/gain rd'
 * '<S114>' : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/controllers/gain/gain rd/Saturation Dynamic'
 * '<S115>' : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/volt.dat/tterm tr'
 * '<S116>' : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/volt.dat/volt1'
 * '<S117>' : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/volt.dat/volt10'
 * '<S118>' : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/volt.dat/volt11'
 * '<S119>' : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/volt.dat/volt2'
 * '<S120>' : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/volt.dat/volt3'
 * '<S121>' : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/volt.dat/volt4'
 * '<S122>' : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/volt.dat/volt5'
 * '<S123>' : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/volt.dat/volt6'
 * '<S124>' : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/volt.dat/volt7'
 * '<S125>' : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/volt.dat/volt8'
 * '<S126>' : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/volt.dat/volt9'
 * '<S127>' : 't15_2/Pow. Supply MC 2/kavin_contr/Subsystem1/Subsystem'
 */
#endif                                 /* RTW_HEADER_t15_2_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
