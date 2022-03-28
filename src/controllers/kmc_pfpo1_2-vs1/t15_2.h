/*
 * File: t15_2.h
 *
 * Code generated for Simulink model 't15_2'.
 *
 * Model version                  : 1.1159
 * Simulink Coder version         : 8.5 (R2013b) 08-Aug-2013
 * C/C++ source code generated on : Sun Nov 21 17:36:31 2021
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
  real_T SFunction1[6500];             /* '<S5>/S-Function1' */
  real_T SFunction2[10000];            /* '<S5>/S-Function2' */
  real_T SFunction[17];                /* '<S5>/S-Function' */
  real_T Times;                        /* '<S5>/Time s' */
  real_T Memory2;                      /* '<S5>/Memory2' */
  real_T u;                            /* '<S5>/-1' */
  real_T Ip1e4;                        /* '<S5>/Ip<1e-4 ' */
  real_T Sum2;                         /* '<S5>/Sum2' */
  real_T DataStoreRead1;               /* '<S5>/Data Store Read1' */
  real_T e6;                           /* '<S14>/1e-6' */
  real_T e6_h[15];                     /* '<S14>/1e-6   ' */
  real_T Memory1;                      /* '<S18>/Memory1' */
  real_T DataStoreRead1_f;             /* '<S18>/Data Store Read1' */
  real_T e3;                           /* '<S18>/1e-3' */
  real_T DataStoreRead2;               /* '<S18>/Data Store Read2' */
  real_T Product1;                     /* '<S18>/Product1' */
  real_T RelationalOperator;           /* '<S18>/Relational Operator' */
  real_T Memory;                       /* '<S26>/Memory' */
  real_T LogicalOperator;              /* '<S26>/Logical Operator' */
  real_T switch1;                      /* '<S18>/switch1' */
  real_T Add2;                         /* '<S18>/Add2' */
  real_T DataStoreRead;                /* '<S18>/Data Store Read' */
  real_T Product;                      /* '<S18>/Product' */
  real_T Add1;                         /* '<S18>/Add1' */
  real_T u_c;                          /* '<S18>/1 0' */
  real_T Memory1_h;                    /* '<S19>/Memory1' */
  real_T c_eob;                        /* '<S19>/c_eob' */
  real_T Divide6;                      /* '<S19>/Divide6' */
  real_T Add1_f;                       /* '<S14>/Add1' */
  real_T SFunction1_d[100];            /* '<S21>/S-Function1' */
  real_T e2[6];                        /* '<S23>/1e2' */
  real_T SFunction1_m[100];            /* '<S44>/S-Function1' */
  real_T Memory2_m;                    /* '<S44>/Memory2' */
  real_T c_eob1;                       /* '<S44>/c_eob  1' */
  real_T Memory1_j;                    /* '<S44>/Memory1' */
  real_T c_eob_n;                      /* '<S44>/c_eob  ' */
  real_T SFunction1_l[100];            /* '<S50>/S-Function1' */
  real_T c_eob_c;                      /* '<S44>/c_eob' */
  real_T Add2_p;                       /* '<S23>/Add2' */
  real_T SFunction1_e[100];            /* '<S40>/S-Function1' */
  real_T Memory2_a;                    /* '<S40>/Memory2' */
  real_T c_eob1_j;                     /* '<S40>/c_eob  1' */
  real_T Memory1_k;                    /* '<S40>/Memory1' */
  real_T c_eob_a;                      /* '<S40>/c_eob  ' */
  real_T SFunction1_l4[100];           /* '<S46>/S-Function1' */
  real_T c_eob_j;                      /* '<S40>/c_eob' */
  real_T Add1_g;                       /* '<S23>/Add1' */
  real_T DataStoreRead1_n;             /* '<S23>/Data Store Read1' */
  real_T RelationalOperator2;          /* '<S23>/Relational Operator2' */
  real_T SFunction1_h[100];            /* '<S41>/S-Function1' */
  real_T Memory2_ao;                   /* '<S41>/Memory2' */
  real_T c_eob1_jl;                    /* '<S41>/c_eob  1' */
  real_T Memory1_f;                    /* '<S41>/Memory1' */
  real_T c_eob_p;                      /* '<S41>/c_eob  ' */
  real_T SFunction1_o[100];            /* '<S47>/S-Function1' */
  real_T c_eob_nz;                     /* '<S41>/c_eob' */
  real_T Add3;                         /* '<S23>/Add3' */
  real_T Divide2;                      /* '<S23>/Divide2' */
  real_T SFunction1_ol[100];           /* '<S42>/S-Function1' */
  real_T Memory2_j;                    /* '<S42>/Memory2' */
  real_T c_eob1_g;                     /* '<S42>/c_eob  1' */
  real_T Memory1_m;                    /* '<S42>/Memory1' */
  real_T c_eob_jm;                     /* '<S42>/c_eob  ' */
  real_T SFunction1_mh[100];           /* '<S48>/S-Function1' */
  real_T c_eob_k;                      /* '<S42>/c_eob' */
  real_T Add4;                         /* '<S23>/Add4' */
  real_T DataStoreRead_o;              /* '<S23>/Data Store Read' */
  real_T DataStoreRead2_l;             /* '<S23>/Data Store Read2' */
  real_T MinMax;                       /* '<S23>/MinMax' */
  real_T RelationalOperator1;          /* '<S23>/Relational Operator1' */
  real_T Divide12;                     /* '<S23>/Divide12' */
  real_T SFunction1_g[100];            /* '<S45>/S-Function1' */
  real_T Memory2_jv;                   /* '<S45>/Memory2' */
  real_T c_eob1_i;                     /* '<S45>/c_eob  1' */
  real_T Memory1_fu;                   /* '<S45>/Memory1' */
  real_T c_eob_h;                      /* '<S45>/c_eob  ' */
  real_T SFunction1_ev[100];           /* '<S51>/S-Function1' */
  real_T c_eob_i;                      /* '<S45>/c_eob' */
  real_T Add5;                         /* '<S23>/Add5' */
  real_T SFunction1_dk[100];           /* '<S43>/S-Function1' */
  real_T Memory2_b;                    /* '<S43>/Memory2' */
  real_T c_eob1_a;                     /* '<S43>/c_eob  1' */
  real_T Memory1_n;                    /* '<S43>/Memory1' */
  real_T c_eob_ck;                     /* '<S43>/c_eob  ' */
  real_T SFunction1_l0[100];           /* '<S49>/S-Function1' */
  real_T c_eob_h4;                     /* '<S43>/c_eob' */
  real_T Add6;                         /* '<S23>/Add6' */
  real_T Divide1;                      /* '<S23>/Divide1' */
  real_T e2_b[6];                      /* '<S23>/1e-2' */
  real_T Memory2_o;                    /* '<S29>/Memory2' */
  real_T c_eob_na;                     /* '<S29>/c_eob' */
  real_T Divide1_f;                    /* '<S29>/Divide1' */
  real_T Add3_c;                       /* '<S22>/Add3' */
  real_T Memory2_k;                    /* '<S32>/Memory2' */
  real_T c_eob_b;                      /* '<S32>/c_eob' */
  real_T Divide1_n;                    /* '<S32>/Divide1' */
  real_T Add1_b;                       /* '<S22>/Add1' */
  real_T Memory2_e;                    /* '<S33>/Memory2' */
  real_T c_eob_e;                      /* '<S33>/c_eob' */
  real_T Divide1_d;                    /* '<S33>/Divide1' */
  real_T Add2_f;                       /* '<S22>/Add2' */
  real_T Memory2_d;                    /* '<S34>/Memory2' */
  real_T c_eob_m;                      /* '<S34>/c_eob' */
  real_T Divide1_a;                    /* '<S34>/Divide1' */
  real_T Add4_b;                       /* '<S22>/Add4' */
  real_T Memory2_g;                    /* '<S35>/Memory2' */
  real_T c_eob_ay;                     /* '<S35>/c_eob' */
  real_T Divide1_d1;                   /* '<S35>/Divide1' */
  real_T Add5_b;                       /* '<S22>/Add5' */
  real_T Memory2_or;                   /* '<S36>/Memory2' */
  real_T c_eob_b4;                     /* '<S36>/c_eob' */
  real_T Divide1_fe;                   /* '<S36>/Divide1' */
  real_T Add6_k;                       /* '<S22>/Add6' */
  real_T Memory2_mv;                   /* '<S37>/Memory2' */
  real_T c_eob_g;                      /* '<S37>/c_eob' */
  real_T Divide1_l;                    /* '<S37>/Divide1' */
  real_T Add7;                         /* '<S22>/Add7' */
  real_T Memory2_j0;                   /* '<S38>/Memory2' */
  real_T c_eob_b2;                     /* '<S38>/c_eob' */
  real_T Divide1_lo;                   /* '<S38>/Divide1' */
  real_T Add8;                         /* '<S22>/Add8' */
  real_T Memory2_ke;                   /* '<S39>/Memory2' */
  real_T c_eob_gg;                     /* '<S39>/c_eob' */
  real_T Divide1_h;                    /* '<S39>/Divide1' */
  real_T Add9;                         /* '<S22>/Add9' */
  real_T Memory2_c;                    /* '<S30>/Memory2' */
  real_T c_eob_en;                     /* '<S30>/c_eob' */
  real_T Divide1_k;                    /* '<S30>/Divide1' */
  real_T Add10;                        /* '<S22>/Add10' */
  real_T Memory2_p;                    /* '<S31>/Memory2' */
  real_T c_eob_ev;                     /* '<S31>/c_eob' */
  real_T Divide1_lf;                   /* '<S31>/Divide1' */
  real_T Add11;                        /* '<S22>/Add11' */
  real_T DataStoreRead1_nr;            /* '<S17>/Data Store Read1' */
  real_T RelationalOperator_c;         /* '<S17>/Relational Operator' */
  real_T Memory_c;                     /* '<S25>/Memory' */
  real_T LogicalOperator_h;            /* '<S25>/Logical Operator' */
  real_T u_g[20];                      /* '<S17>/1' */
  real_T Uk1;                          /* '<S27>/UD' */
  real_T Diff;                         /* '<S27>/Diff' */
  real_T Uk1_k;                        /* '<S28>/UD' */
  real_T Diff_h;                       /* '<S28>/Diff' */
  real_T Divide;                       /* '<S20>/Divide' */
  real_T DataStoreRead_k;              /* '<S15>/Data Store Read' */
  real_T u15;                          /* '<S15>/ 1//15' */
  real_T DataStoreRead_p;              /* '<S52>/Data Store Read' */
  real_T Memory3;                      /* '<S52>/Memory3' */
  real_T DataStoreRead_k2;             /* '<S69>/Data Store Read' */
  real_T Abs;                          /* '<S69>/Abs' */
  real_T LogicalOperator1;             /* '<S52>/Logical Operator1' */
  real_T switch1_i;                    /* '<S52>/switch1 ' */
  real_T Subtract2;                    /* '<S52>/Subtract2' */
  real_T Divide1_j;                    /* '<S52>/Divide1' */
  real_T Subtract1;                    /* '<S52>/Subtract1' */
  real_T Saturation1;                  /* '<S52>/Saturation1' */
  real_T Memory1_e[11];                /* '<S52>/Memory1' */
  real_T Memory1_kk;                   /* '<S64>/Memory1' */
  real_T c_eob_jma;                    /* '<S64>/c_eob' */
  real_T c_eob_o;                      /* '<S15>/c_eob' */
  real_T DataStoreRead_n;              /* '<S75>/Data Store Read' */
  real_T Divide12_f[20];               /* '<S75>/Divide12' */
  real_T Limcontr[11];                 /* '<S55>/Lim. contr.' */
  real_T Currcontr[11];                /* '<S55>/Curr. contr.' */
  real_T DataStoreRead2_p[11];         /* '<S55>/Data Store Read2' */
  real_T switch1_h[11];                /* '<S52>/switch1' */
  real_T Divide5[11];                  /* '<S52>/Divide5' */
  real_T Subtract3;                    /* '<S52>/Subtract3' */
  real_T e3_g[11];                     /* '<S53>/1e3' */
  real_T Abs_f[11];                    /* '<S53>/Abs' */
  real_T DataStoreRead1_e[11];         /* '<S15>/Data Store Read1' */
  real_T DataStoreRead2_f[11];         /* '<S53>/Data Store Read2' */
  real_T Divide5_b[11];                /* '<S53>/Divide5' */
  real_T Sum2_k[11];                   /* '<S53>/Sum2' */
  real_T DataStoreRead1_e5;            /* '<S53>/Data Store Read1' */
  real_T Divide3[11];                  /* '<S53>/Divide3' */
  real_T Sum1[11];                     /* '<S53>/Sum1' */
  real_T Divide4[11];                  /* '<S53>/Divide4' */
  real_T Divide1_aw[11];               /* '<S53>/Divide1' */
  real_T Saturation[11];               /* '<S53>/Saturation' */
  real_T Memory1_ja[11];               /* '<S66>/Memory1' */
  real_T DataStoreRead_h;              /* '<S66>/Data Store Read' */
  real_T Abs_j;                        /* '<S66>/Abs' */
  real_T LogicalOperator2;             /* '<S66>/Logical Operator2' */
  real_T Memory_i[11];                 /* '<S58>/Memory' */
  real_T DataStoreRead_p3;             /* '<S58>/Data Store Read' */
  real_T DataStoreRead1_j;             /* '<S58>/Data Store Read1' */
  real_T Abs_m;                        /* '<S58>/Abs' */
  real_T LogicalOperator1_f;           /* '<S58>/Logical Operator1' */
  real_T Divcontr[11];                 /* '<S15>/Div. contr.' */
  real_T u_e[11];                      /* '<S58>/0.1' */
  real_T Memory1_kr;                   /* '<S62>/Memory1' */
  real_T DataStoreRead_hc;             /* '<S62>/Data Store Read' */
  real_T LogicalOperator1_a;           /* '<S62>/Logical Operator1' */
  real_T switch1_k;                    /* '<S62>/switch1' */
  real_T Div_rdcontr[11];              /* '<S15>/Div_rd contr' */
  real_T u_o[11];                      /* '<S66>/1' */
  real_T DataStoreRead_a;              /* '<S73>/Data Store Read' */
  real_T Abs_f2;                       /* '<S73>/Abs' */
  real_T LogicalOperator2_h;           /* '<S54>/Logical Operator2' */
  real_T Subtract4;                    /* '<S54>/Subtract4' */
  real_T Divide4_g[11];                /* '<S15>/Divide4' */
  real_T Currtermcontr[11];            /* '<S15>/Curr. term. contr' */
  real_T Divide5_c[11];                /* '<S15>/Divide5' */
  real_T DataStoreRead_i[500];         /* '<S86>/Data Store Read' */
  real_T u01[500];                     /* '<S86>/0.001' */
  real_T DataStoreRead1_m[500];        /* '<S86>/Data Store Read1' */
  real_T volt1;                        /* '<S86>/volt1' */
  real_T DataStoreRead_c[500];         /* '<S89>/Data Store Read' */
  real_T u01_b[500];                   /* '<S89>/0.001' */
  real_T DataStoreRead1_l[500];        /* '<S89>/Data Store Read1' */
  real_T volt1_f;                      /* '<S89>/volt1' */
  real_T DataStoreRead_m[500];         /* '<S90>/Data Store Read' */
  real_T u01_c[500];                   /* '<S90>/0.001' */
  real_T DataStoreRead1_fa[500];       /* '<S90>/Data Store Read1' */
  real_T volt1_n;                      /* '<S90>/volt1' */
  real_T DataStoreRead_g[500];         /* '<S91>/Data Store Read' */
  real_T u01_p[500];                   /* '<S91>/0.001' */
  real_T DataStoreRead1_d[500];        /* '<S91>/Data Store Read1' */
  real_T volt1_j;                      /* '<S91>/volt1' */
  real_T DataStoreRead_m1[500];        /* '<S92>/Data Store Read' */
  real_T u01_k[500];                   /* '<S92>/0.001' */
  real_T DataStoreRead1_dl[500];       /* '<S92>/Data Store Read1' */
  real_T volt1_k;                      /* '<S92>/volt1' */
  real_T DataStoreRead_pj[500];        /* '<S93>/Data Store Read' */
  real_T u01_m[500];                   /* '<S93>/0.001' */
  real_T DataStoreRead1_du[500];       /* '<S93>/Data Store Read1' */
  real_T volt1_nb;                     /* '<S93>/volt1' */
  real_T DataStoreRead_l[500];         /* '<S94>/Data Store Read' */
  real_T u01_o[500];                   /* '<S94>/0.001' */
  real_T DataStoreRead1_mt[500];       /* '<S94>/Data Store Read1' */
  real_T volt1_m;                      /* '<S94>/volt1' */
  real_T DataStoreRead_km[500];        /* '<S95>/Data Store Read' */
  real_T u01_g[500];                   /* '<S95>/0.001' */
  real_T DataStoreRead1_p[500];        /* '<S95>/Data Store Read1' */
  real_T volt1_b;                      /* '<S95>/volt1' */
  real_T DataStoreRead_mu[500];        /* '<S96>/Data Store Read' */
  real_T u01_g3[500];                  /* '<S96>/0.001' */
  real_T DataStoreRead1_f2[500];       /* '<S96>/Data Store Read1' */
  real_T volt1_mf;                     /* '<S96>/volt1' */
  real_T DataStoreRead_j[500];         /* '<S87>/Data Store Read' */
  real_T u01_i[500];                   /* '<S87>/0.001' */
  real_T DataStoreRead1_h[500];        /* '<S87>/Data Store Read1' */
  real_T volt1_bd;                     /* '<S87>/volt1' */
  real_T DataStoreRead_b[500];         /* '<S88>/Data Store Read' */
  real_T u01_mu[500];                  /* '<S88>/0.001' */
  real_T DataStoreRead1_nn[500];       /* '<S88>/Data Store Read1' */
  real_T volt1_i;                      /* '<S88>/volt1' */
  real_T Sum1_k;                       /* '<S15>/Sum1' */
  real_T Divide7[11];                  /* '<S15>/Divide7' */
  real_T Sum3[11];                     /* '<S15>/Sum3' */
  real_T Divide2_o[11];                /* '<S53>/Divide2' */
  real_T Switch[11];                   /* '<S53>/Switch' */
  real_T Divide6_j[11];                /* '<S53>/Divide6' */
  real_T UniformRandomNumber;          /* '<S63>/Uniform Random Number' */
  real_T DataStoreRead_bm;             /* '<S82>/Data Store Read' */
  real_T u5;                           /* '<S82>/1.75' */
  real_T Divide11;                     /* '<S82>/Divide11' */
  real_T Uk1_kx;                       /* '<S83>/UD' */
  real_T Diff_c;                       /* '<S83>/Diff' */
  real_T e3_p;                         /* '<S82>/2e3' */
  real_T Sqrt;                         /* '<S82>/Sqrt' */
  real_T Divide1_ap;                   /* '<S82>/Divide1' */
  real_T Sum2_h;                       /* '<S63>/Sum2' */
  real_T DataStoreRead_f;              /* '<S65>/Data Store Read' */
  real_T DataStoreRead2_pz;            /* '<S65>/Data Store Read2' */
  real_T MinMax_h;                     /* '<S65>/MinMax' */
  real_T RelationalOperator1_o;        /* '<S65>/Relational Operator1' */
  real_T Divide12_p[2];                /* '<S65>/Divide12' */
  real_T VScontr[2];                   /* '<S60>/VS. contr' */
  real_T Divide4_gb[2];                /* '<S60>/Divide4' */
  real_T VScontrhl[2];                 /* '<S60>/VS. contr hl' */
  real_T c_eob_kz[2];                  /* '<S60>/c_eob' */
  real_T DataStoreRead1_pd;            /* '<S59>/Data Store Read1' */
  real_T RelationalOperator2_c;        /* '<S59>/Relational Operator2' */
  real_T DataStoreRead_am;             /* '<S59>/Data Store Read' */
  real_T Abs_mv;                       /* '<S59>/Abs' */
  real_T RelationalOperator1_h;        /* '<S59>/Relational Operator1' */
  real_T LogicalOperator1_j;           /* '<S59>/Logical Operator1' */
  real_T DataStoreRead_hk;             /* '<S61>/Data Store Read' */
  real_T u5_e;                         /* '<S61>/1//15' */
  real_T Div;                          /* '<S61>/Div' */
  real_T u_d[2];                       /* '<S59>/1' */
  real_T Divide10[2];                  /* '<S15>/Divide10' */
  real_T G_curr_term[20];              /* '<S15>/G_curr_term' */
  real_T Divide12_d[20];               /* '<S15>/Divide12' */
  real_T Divide2_b[20];                /* '<S15>/Divide2' */
  real_T Divide13[20];                 /* '<S15>/Divide13' */
  real_T DataStoreRead_al;             /* '<S54>/Data Store Read' */
  real_T Divide1_az[11];               /* '<S55>/Divide1' */
  real_T e6_j[11];                     /* '<S55>/1e6' */
  real_T DataStoreRead2_d[11];         /* '<S5>/Data Store Read2' */
  real_T Divide4_n[11];                /* '<S5>/Divide4' */
  real_T SFunction_k[44];              /* '<S1>/S-Function' */
  real_T DataStoreRead1_c[11];         /* '<S9>/Data Store Read1' */
  real_T Memory1_c[11];                /* '<S7>/Memory1' */
  real_T DataStoreRead1_jk[11];        /* '<S8>/Data Store Read1' */
  real_T u_dr[11];                     /* '<S8>/2' */
  real_T DataStoreRead3;               /* '<S8>/Data Store Read3' */
  real_T Divide1_an[11];               /* '<S8>/Divide1' */
  real_T Add1_k[11];                   /* '<S7>/Add1' */
  real_T Uk1_c;                        /* '<S6>/UD' */
  real_T Diff_o;                       /* '<S6>/Diff' */
  real_T Divide_m[11];                 /* '<S7>/Divide' */
  real_T u_gh[11];                     /* '<S8>/-1' */
  real_T Switch_h[11];                 /* '<S10>/Switch' */
  real_T Switch2[11];                  /* '<S10>/Switch2' */
  real_T Divide1_b[11];                /* '<S7>/Divide1' */
  real_T Add2_l[11];                   /* '<S7>/Add2' */
  real_T Gain[11];                     /* '<S9>/Gain' */
  real_T Switch_hr[11];                /* '<S11>/Switch' */
  real_T Switch2_a[11];                /* '<S11>/Switch2' */
  real_T DataStoreRead2_c[11];         /* '<S2>/Data Store Read2' */
  real_T Divide3_e[11];                /* '<S2>/Divide3' */
  real_T Divide1_lq[11];               /* '<S2>/Divide1' */
  real_T DataStoreRead1_a;             /* '<S4>/Data Store Read1' */
  real_T Switch2_e;                    /* '<S12>/Switch2' */
  real_T Divide2_f[11];                /* '<S2>/Divide2' */
  real_T Add1_b0[11];                  /* '<S2>/Add1' */
  real_T DataStoreRead1_ht;            /* '<S2>/Data Store Read1' */
  real_T Divide4_f;                    /* '<S2>/Divide4' */
  real_T DataStoreRead3_b;             /* '<S4>/Data Store Read3' */
  real_T Switch2_k;                    /* '<S13>/Switch2' */
  real_T Divide5_o;                    /* '<S2>/Divide5' */
  real_T TmpSignalConversionAtnpf12Inpor[12];
  real_T npf12[15];                    /* '<S2>/npf,12' */
  real_T Subtract2_j;                  /* '<S62>/Subtract2' */
  real_T DataStoreRead1_cr;            /* '<S62>/Data Store Read1' */
  real_T Divide4_nc;                   /* '<S62>/Divide4' */
  real_T Subtract3_j;                  /* '<S62>/Subtract3' */
  real_T Saturation_g;                 /* '<S62>/Saturation' */
  real_T Subtract1_l;                  /* '<S62>/Subtract1' */
  real_T Divide3_a[11];                /* '<S15>/Divide3' */
  real_T Divide1_hq[11];               /* '<S15>/Divide1' */
  real_T Sum2_j[11];                   /* '<S15>/Sum2' */
  real_T Divide6_k;                    /* '<S15>/Divide6' */
  real_T Switch2_kp;                   /* '<S56>/Switch2' */
  real_T Divide11_c[2];                /* '<S15>/Divide11' */
  real_T DataStoreRead3_n;             /* '<S15>/Data Store Read3' */
  real_T Switch_l;                     /* '<S56>/Switch' */
  real_T c_eob_mm[2];                  /* '<S15>/c_eob ' */
  real_T DataStoreRead1_ni;            /* '<S61>/Data Store Read1' */
  real_T RelationalOperator2_e;        /* '<S61>/Relational Operator2' */
  real_T LimDivtr;                     /* '<S61>/Lim. Div. tr.' */
  real_T Divide8[2];                   /* '<S15>/Divide8' */
  real_T SatDiv;                       /* '<S61>/Sat. Div' */
  real_T DataStoreRead2_a;             /* '<S61>/Data Store Read2' */
  real_T Switch2_d;                    /* '<S80>/Switch2' */
  real_T Switch_j;                     /* '<S80>/Switch' */
  real_T Divide15;                     /* '<S15>/Divide15' */
  real_T DataStoreRead4;               /* '<S15>/Data Store Read4' */
  real_T Switch2_i;                    /* '<S57>/Switch2' */
  real_T Divide_d[2];                  /* '<S15>/Divide ' */
  real_T Switch_b;                     /* '<S57>/Switch' */
  real_T Divide_j[11];                 /* '<S15>/Divide' */
  real_T DataStoreRead_l5;             /* '<S76>/Data Store Read' */
  real_T u_p[11];                      /* '<S76>/1' */
  real_T DataStoreRead1_i;             /* '<S74>/Data Store Read1' */
  real_T DataStoreRead_ak;             /* '<S74>/Data Store Read' */
  real_T Subtract3_i;                  /* '<S74>/Subtract3' */
  real_T Divide2_c;                    /* '<S74>/Divide2' */
  real_T Saturation1_a;                /* '<S74>/Saturation1' */
  real_T Divide_mg[11];                /* '<S55>/Divide ' */
  real_T Divide2_k[11];                /* '<S55>/Divide2' */
  real_T DataStoreRead2_pa;            /* '<S15>/Data Store Read2' */
  real_T u15_j;                        /* '<S15>/ 1//15 ' */
  real_T Divide9;                      /* '<S15>/Divide9' */
  real_T Saturation_j;                 /* '<S15>/Saturation' */
  real_T DataStoreRead2_lw;            /* '<S64>/Data Store Read2' */
  real_T Sum3_d;                       /* '<S64>/Sum3' */
  real_T DataStoreRead4_o;             /* '<S64>/Data Store Read4' */
  real_T DataStoreRead3_m;             /* '<S64>/Data Store Read3' */
  real_T Sum2_hd;                      /* '<S64>/Sum2' */
  real_T Divide1_m;                    /* '<S64>/Divide1' */
  real_T Divide6_k1;                   /* '<S64>/Divide6' */
  real_T Sum;                          /* '<S64>/Sum' */
  real_T Divide2_p;                    /* '<S64>/Divide2' */
  real_T Sum1_n;                       /* '<S64>/Sum1' */
  real_T Switch2_g;                    /* '<S84>/Switch2' */
  real_T Switch_m;                     /* '<S84>/Switch' */
  real_T Selector[49];                 /* '<S51>/Selector' */
  real_T TmpSignalConversionAtg5_termref[50];
  real_T DataStoreRead1_b;             /* '<S51>/Data Store Read1' */
  real_T DataStoreRead_pjy;            /* '<S51>/Data Store Read' */
  real_T Selector1[50];                /* '<S51>/Selector1' */
  real_T Divide6_f[50];                /* '<S51>/Divide6' */
  real_T Add2_h[50];                   /* '<S51>/Add2' */
  real_T g5_termref;                   /* '<S51>/g5_term,ref' */
  real_T Selector_c[50];               /* '<S45>/Selector' */
  real_T Selector1_m[50];              /* '<S45>/Selector1' */
  real_T g5ref;                        /* '<S45>/g5ref' */
  real_T Selector_o[49];               /* '<S50>/Selector' */
  real_T TmpSignalConversionAtg1_termref[50];
  real_T DataStoreRead1_ii;            /* '<S50>/Data Store Read1' */
  real_T DataStoreRead_mr;             /* '<S50>/Data Store Read' */
  real_T Selector1_o[50];              /* '<S50>/Selector1' */
  real_T Divide6_m[50];                /* '<S50>/Divide6' */
  real_T Add2_o[50];                   /* '<S50>/Add2' */
  real_T g1_termref;                   /* '<S50>/g1_term,ref' */
  real_T Selector_i[50];               /* '<S44>/Selector' */
  real_T Selector1_ob[50];             /* '<S44>/Selector1' */
  real_T g1ref;                        /* '<S44>/g1ref' */
  real_T Selector_j[49];               /* '<S49>/Selector' */
  real_T TmpSignalConversionAtg6_termref[50];
  real_T DataStoreRead1_iu;            /* '<S49>/Data Store Read1' */
  real_T DataStoreRead_fs;             /* '<S49>/Data Store Read' */
  real_T Selector1_j[50];              /* '<S49>/Selector1' */
  real_T Divide6_p[50];                /* '<S49>/Divide6' */
  real_T Add2_f5[50];                  /* '<S49>/Add2' */
  real_T g6_termref;                   /* '<S49>/g6_term,ref' */
  real_T Selector_om[50];              /* '<S43>/Selector' */
  real_T Selector1_d[50];              /* '<S43>/Selector1' */
  real_T g6ref;                        /* '<S43>/g6ref' */
  real_T Selector_cp[49];              /* '<S48>/Selector' */
  real_T TmpSignalConversionAtg4_termref[50];
  real_T DataStoreRead1_cb;            /* '<S48>/Data Store Read1' */
  real_T DataStoreRead_lw;             /* '<S48>/Data Store Read' */
  real_T Selector1_p[50];              /* '<S48>/Selector1' */
  real_T Divide6_n[50];                /* '<S48>/Divide6' */
  real_T Add2_i[50];                   /* '<S48>/Add2' */
  real_T g4_termref;                   /* '<S48>/g4_term,ref' */
  real_T Selector_n[50];               /* '<S42>/Selector' */
  real_T Selector1_pp[50];             /* '<S42>/Selector1' */
  real_T g4ref;                        /* '<S42>/g4ref' */
  real_T Selector_n4[49];              /* '<S47>/Selector' */
  real_T TmpSignalConversionAtg3_termref[50];
  real_T DataStoreRead1_pw;            /* '<S47>/Data Store Read1' */
  real_T DataStoreRead_d;              /* '<S47>/Data Store Read' */
  real_T Selector1_n[50];              /* '<S47>/Selector1' */
  real_T Divide6_nx[50];               /* '<S47>/Divide6' */
  real_T Add2_iy[50];                  /* '<S47>/Add2' */
  real_T g3_termref;                   /* '<S47>/g3_term,ref' */
  real_T Selector_k[50];               /* '<S41>/Selector' */
  real_T Selector1_c[50];              /* '<S41>/Selector1' */
  real_T g3ref;                        /* '<S41>/g3ref' */
  real_T Selector_p[49];               /* '<S46>/Selector' */
  real_T TmpSignalConversionAtg2_termref[50];
  real_T DataStoreRead1_el;            /* '<S46>/Data Store Read1' */
  real_T DataStoreRead_f0;             /* '<S46>/Data Store Read' */
  real_T Selector1_k[50];              /* '<S46>/Selector1' */
  real_T Divide6_a[50];                /* '<S46>/Divide6' */
  real_T Add2_hb[50];                  /* '<S46>/Add2' */
  real_T g2_termref;                   /* '<S46>/g2_term,ref' */
  real_T Selector_e[50];               /* '<S40>/Selector' */
  real_T Selector1_a[50];              /* '<S40>/Selector1' */
  real_T g2ref;                        /* '<S40>/g2ref' */
  real_T DataStoreRead1_eh[500];       /* '<S39>/Data Store Read1' */
  real_T DataStoreRead_o2[500];        /* '<S39>/Data Store Read' */
  real_T I1;                           /* '<S39>/I1' */
  real_T DataStoreRead1_ds[500];       /* '<S38>/Data Store Read1' */
  real_T DataStoreRead_bv[500];        /* '<S38>/Data Store Read' */
  real_T I1_m;                         /* '<S38>/I1' */
  real_T DataStoreRead1_c3[500];       /* '<S37>/Data Store Read1' */
  real_T DataStoreRead_bp[500];        /* '<S37>/Data Store Read' */
  real_T I1_a;                         /* '<S37>/I1' */
  real_T DataStoreRead1_n1[500];       /* '<S36>/Data Store Read1' */
  real_T DataStoreRead_fe[500];        /* '<S36>/Data Store Read' */
  real_T I1_n;                         /* '<S36>/I1' */
  real_T DataStoreRead1_f4[500];       /* '<S35>/Data Store Read1' */
  real_T DataStoreRead_oi[500];        /* '<S35>/Data Store Read' */
  real_T I1_nt;                        /* '<S35>/I1' */
  real_T DataStoreRead1_g[500];        /* '<S34>/Data Store Read1' */
  real_T DataStoreRead_n2[500];        /* '<S34>/Data Store Read' */
  real_T I1_k;                         /* '<S34>/I1' */
  real_T DataStoreRead1_di[500];       /* '<S33>/Data Store Read1' */
  real_T DataStoreRead_fy[500];        /* '<S33>/Data Store Read' */
  real_T I1_mn;                        /* '<S33>/I1' */
  real_T DataStoreRead1_g5[500];       /* '<S32>/Data Store Read1' */
  real_T DataStoreRead_dn[500];        /* '<S32>/Data Store Read' */
  real_T I1_f;                         /* '<S32>/I1' */
  real_T DataStoreRead1_gs[500];       /* '<S31>/Data Store Read1' */
  real_T DataStoreRead_hb[500];        /* '<S31>/Data Store Read' */
  real_T I1_h;                         /* '<S31>/I1' */
  real_T DataStoreRead1_ez[500];       /* '<S30>/Data Store Read1' */
  real_T DataStoreRead_dn5[500];       /* '<S30>/Data Store Read' */
  real_T I1_p;                         /* '<S30>/I1' */
  real_T DataStoreRead1_gn[500];       /* '<S29>/Data Store Read1' */
  real_T DataStoreRead_f3[500];        /* '<S29>/Data Store Read' */
  real_T I1_g;                         /* '<S29>/I1' */
  real_T DataStoreRead1_jw[500];       /* '<S19>/Data Store Read1' */
  real_T DataStoreRead_ow[500];        /* '<S19>/Data Store Read' */
  real_T Ipref;                        /* '<S19>/Ipref' */
  real_T Selector_h[50];               /* '<S21>/Selector' */
  real_T Selector1_k4[50];             /* '<S21>/Selector1' */
  real_T elong;                        /* '<S21>/elong' */
  real_T Add2_ho;                      /* '<S14>/Add2' */
  real_T DataStoreRead1_o;             /* '<S24>/Data Store Read1' */
  real_T Divide_c[4];                  /* '<S24>/Divide' */
  real_T Gain1;                        /* '<S4>/Gain1' */
  real_T Switch_o;                     /* '<S13>/Switch' */
  real_T Gain_b;                       /* '<S4>/Gain' */
  real_T Switch_mw;                    /* '<S12>/Switch' */
  uint8_T Compare[11];                 /* '<S70>/Compare' */
  uint8_T Compare_a[11];               /* '<S71>/Compare' */
  boolean_T RelationalOperator_p;      /* '<S5>/Relational Operator' */
  boolean_T RelationalOperator1_or;    /* '<S5>/Relational Operator1' */
  boolean_T Compare_b;                 /* '<S68>/Compare' */
  boolean_T RelationalOperator_k;      /* '<S69>/Relational Operator' */
  boolean_T RelationalOperator_n;      /* '<S75>/Relational Operator' */
  boolean_T RelationalOperator_o;      /* '<S66>/Relational Operator' */
  boolean_T Compare_m;                 /* '<S85>/Compare' */
  boolean_T RelationalOperator1_j;     /* '<S58>/Relational Operator1' */
  boolean_T Compare_c;                 /* '<S77>/Compare' */
  boolean_T RelationalOperator_m;      /* '<S58>/Relational Operator' */
  boolean_T RelationalOperator1_m;     /* '<S62>/Relational Operator1' */
  boolean_T Compare_i;                 /* '<S81>/Compare' */
  boolean_T RelationalOperator_f;      /* '<S73>/Relational Operator' */
  boolean_T Compare_bp;                /* '<S72>/Compare' */
  boolean_T LogicalOperator_o[11];     /* '<S53>/Logical Operator' */
  boolean_T Compare_g;                 /* '<S79>/Compare' */
  boolean_T Compare_o;                 /* '<S78>/Compare' */
  boolean_T LowerRelop1[11];           /* '<S10>/LowerRelop1' */
  boolean_T UpperRelop[11];            /* '<S10>/UpperRelop' */
  boolean_T LowerRelop1_b[11];         /* '<S11>/LowerRelop1' */
  boolean_T UpperRelop_g[11];          /* '<S11>/UpperRelop' */
  boolean_T LowerRelop1_a;             /* '<S12>/LowerRelop1' */
  boolean_T LowerRelop1_i;             /* '<S13>/LowerRelop1' */
  boolean_T LowerRelop1_j;             /* '<S56>/LowerRelop1' */
  boolean_T UpperRelop_d;              /* '<S56>/UpperRelop' */
  boolean_T LowerRelop1_l;             /* '<S80>/LowerRelop1' */
  boolean_T UpperRelop_a;              /* '<S80>/UpperRelop' */
  boolean_T LowerRelop1_d;             /* '<S57>/LowerRelop1' */
  boolean_T UpperRelop_j;              /* '<S57>/UpperRelop' */
  boolean_T RelationalOperator_e;      /* '<S76>/Relational Operator' */
  boolean_T LowerRelop1_o;             /* '<S84>/LowerRelop1' */
  boolean_T UpperRelop_f;              /* '<S84>/UpperRelop' */
  boolean_T UpperRelop_k;              /* '<S13>/UpperRelop' */
  boolean_T UpperRelop_l;              /* '<S12>/UpperRelop' */
} BlockIO_t15_2;

/* Block states (auto storage) for system '<Root>' */
typedef struct {
  real_T UD_DSTATE;                    /* '<S27>/UD' */
  real_T UD_DSTATE_b;                  /* '<S28>/UD' */
  real_T Limcontr_DSTATE[50];          /* '<S55>/Lim. contr.' */
  real_T Currcontr_DSTATE[31];         /* '<S55>/Curr. contr.' */
  real_T Currtermcontr_DSTATE[22];     /* '<S15>/Curr. term. contr' */
  real_T UD_DSTATE_c;                  /* '<S83>/UD' */
  real_T VScontr_DSTATE[5];            /* '<S60>/VS. contr' */
  real_T VScontrhl_DSTATE[5];          /* '<S60>/VS. contr hl' */
  real_T UD_DSTATE_g;                  /* '<S6>/UD' */
  real_T Memory2_PreviousInput;        /* '<S5>/Memory2' */
  real_T Memory1_PreviousInput;        /* '<S18>/Memory1' */
  real_T Memory_PreviousInput;         /* '<S26>/Memory' */
  real_T Memory1_PreviousInput_d;      /* '<S19>/Memory1' */
  real_T Memory2_PreviousInput_m;      /* '<S44>/Memory2' */
  real_T Memory1_PreviousInput_i;      /* '<S44>/Memory1' */
  real_T Memory2_PreviousInput_mc;     /* '<S40>/Memory2' */
  real_T Memory1_PreviousInput_g;      /* '<S40>/Memory1' */
  real_T Memory2_PreviousInput_a;      /* '<S41>/Memory2' */
  real_T Memory1_PreviousInput_l;      /* '<S41>/Memory1' */
  real_T Memory2_PreviousInput_b;      /* '<S42>/Memory2' */
  real_T Memory1_PreviousInput_h;      /* '<S42>/Memory1' */
  real_T Memory2_PreviousInput_f;      /* '<S45>/Memory2' */
  real_T Memory1_PreviousInput_f;      /* '<S45>/Memory1' */
  real_T Memory2_PreviousInput_j;      /* '<S43>/Memory2' */
  real_T Memory1_PreviousInput_k;      /* '<S43>/Memory1' */
  real_T Memory2_PreviousInput_e;      /* '<S29>/Memory2' */
  real_T Memory2_PreviousInput_ad;     /* '<S32>/Memory2' */
  real_T Memory2_PreviousInput_mc4;    /* '<S33>/Memory2' */
  real_T Memory2_PreviousInput_d;      /* '<S34>/Memory2' */
  real_T Memory2_PreviousInput_i;      /* '<S35>/Memory2' */
  real_T Memory2_PreviousInput_eq;     /* '<S36>/Memory2' */
  real_T Memory2_PreviousInput_br;     /* '<S37>/Memory2' */
  real_T Memory2_PreviousInput_n;      /* '<S38>/Memory2' */
  real_T Memory2_PreviousInput_c;      /* '<S39>/Memory2' */
  real_T Memory2_PreviousInput_jn;     /* '<S30>/Memory2' */
  real_T Memory2_PreviousInput_nq;     /* '<S31>/Memory2' */
  real_T Memory_PreviousInput_i;       /* '<S25>/Memory' */
  real_T Memory3_PreviousInput;        /* '<S52>/Memory3' */
  real_T Memory1_PreviousInput_i3[11]; /* '<S52>/Memory1' */
  real_T Memory1_PreviousInput_iu;     /* '<S64>/Memory1' */
  real_T Memory1_PreviousInput_c[11];  /* '<S66>/Memory1' */
  real_T Memory_PreviousInput_c[11];   /* '<S58>/Memory' */
  real_T Memory1_PreviousInput_fx;     /* '<S62>/Memory1' */
  real_T UniformRandomNumber_NextOutput;/* '<S63>/Uniform Random Number' */
  real_T scr_data[6500];               /* '<S5>/Data Store Memory' */
  real_T volt[10000];                  /* '<S5>/Data Store Memory1' */
  real_T c_a_tpl1_eob;                 /* '<S5>/Data Store Memory10' */
  real_T c_a_tpl2;                     /* '<S5>/Data Store Memory11' */
  real_T c_a_tpl_min;                  /* '<S5>/Data Store Memory12' */
  real_T y0;                           /* '<S5>/Data Store Memory13' */
  real_T c1_y0;                        /* '<S5>/Data Store Memory14' */
  real_T c2_y0;                        /* '<S5>/Data Store Memory15' */
  real_T t_tran2D;                     /* '<S5>/Data Store Memory16' */
  real_T max_VS_lim;                   /* '<S5>/Data Store Memory17' */
  real_T k_g4;                         /* '<S5>/Data Store Memory18' */
  real_T c_a_tpl1;                     /* '<S5>/Data Store Memory2' */
  real_T tcont2;                       /* '<S5>/Data Store Memory3' */
  real_T Ip_div;                       /* '<S5>/Data Store Memory4' */
  real_T ref_ramp;                     /* '<S5>/Data Store Memory5' */
  real_T dtcont2;                      /* '<S5>/Data Store Memory6' */
  real_T Ip_rd;                        /* '<S5>/Data Store Memory7' */
  real_T trd_ref;                      /* '<S5>/Data Store Memory8' */
  real_T Time_stop;                    /* '<S5>/Data Store Memory9' */
  real_T Memory1_PreviousInput_cd[11]; /* '<S7>/Memory1' */
  real_T ntur[12];                     /* '<S1>/Data Store Memory1' */
  real_T RupRd[6];                     /* '<S1>/Data Store Memory2' */
  real_T VS3_up;                       /* '<S1>/Data Store Memory3' */
  real_T Vcspf_up[11];                 /* '<S1>/Data Store Memory4' */
  real_T VS1_up;                       /* '<S1>/Data Store Memory5' */
  real_T Tu;                           /* '<S1>/Data Store Memory7' */
  real_T c_cur_max;                    /* '<S1>/Data Store Memory8' */
  real_T Imax[11];                     /* '<S1>/Data Store Memory9' */
  uint32_T RandSeed;                   /* '<S63>/Uniform Random Number' */
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
                                        * Referenced by: '<S4>/Gain'
                                        */
  real_T Gain1_Gain;                   /* Expression: -1
                                        * Referenced by: '<S4>/Gain1'
                                        */
  real_T Constant2_Value;              /* Expression: 1
                                        * Referenced by: '<S24>/Constant2'
                                        */
  real_T Constant1_Value;              /* Expression: 1
                                        * Referenced by: '<S24>/Constant1'
                                        */
  real_T Constant4_Value;              /* Expression: 1
                                        * Referenced by: '<S24>/Constant4'
                                        */
  real_T _Value;                       /* Expression: 1
                                        * Referenced by: '<S64>/2'
                                        */
  real_T _Value_e;                     /* Expression: 1
                                        * Referenced by: '<S64>/1'
                                        */
  real_T u15_Gain;                     /* Expression: 1/15
                                        * Referenced by: '<S15>/ 1//15 '
                                        */
  real_T Saturation_UpperSat;          /* Expression: 1
                                        * Referenced by: '<S15>/Saturation'
                                        */
  real_T Saturation_LowerSat;          /* Expression: 0
                                        * Referenced by: '<S15>/Saturation'
                                        */
  real_T Saturation1_UpperSat;         /* Expression: 1
                                        * Referenced by: '<S74>/Saturation1'
                                        */
  real_T Saturation1_LowerSat;         /* Expression: 0
                                        * Referenced by: '<S74>/Saturation1'
                                        */
  real_T _Value_o;                     /* Expression: 0.1
                                        * Referenced by: '<S15>/2'
                                        */
  real_T _Value_m;                     /* Expression: 0
                                        * Referenced by: '<S61>/1'
                                        */
  real_T SatDiv_UpperSat;              /* Expression: 1
                                        * Referenced by: '<S61>/Sat. Div'
                                        */
  real_T SatDiv_LowerSat;              /* Expression: 0
                                        * Referenced by: '<S61>/Sat. Div'
                                        */
  real_T LimDivtr_Threshold;           /* Expression: 1
                                        * Referenced by: '<S61>/Lim. Div. tr.'
                                        */
  real_T c_eob_Threshold;              /* Expression: 1
                                        * Referenced by: '<S15>/c_eob '
                                        */
  real_T _Value_f;                     /* Expression: 1
                                        * Referenced by: '<S15>/1'
                                        */
  real_T _Value_a;                     /* Expression: 1
                                        * Referenced by: '<S62>/1'
                                        */
  real_T Saturation_UpperSat_e;        /* Expression: 1
                                        * Referenced by: '<S62>/Saturation'
                                        */
  real_T Saturation_LowerSat_b;        /* Expression: 0
                                        * Referenced by: '<S62>/Saturation'
                                        */
  real_T SFunction1_P1_Size[2];        /* Computed Parameter: SFunction1_P1_Size
                                        * Referenced by: '<S5>/S-Function1'
                                        */
  real_T SFunction1_P1;                /* Expression: 1
                                        * Referenced by: '<S5>/S-Function1'
                                        */
  real_T SFunction2_P1_Size[2];        /* Computed Parameter: SFunction2_P1_Size
                                        * Referenced by: '<S5>/S-Function2'
                                        */
  real_T SFunction2_P1;                /* Expression: 12
                                        * Referenced by: '<S5>/S-Function2'
                                        */
  real_T Times_Gain;                   /* Expression: 1e-3
                                        * Referenced by: '<S5>/Time s'
                                        */
  real_T Memory2_X0;                   /* Expression: 0
                                        * Referenced by: '<S5>/Memory2'
                                        */
  real_T u_Gain;                       /* Expression: -1
                                        * Referenced by: '<S5>/-1'
                                        */
  real_T Ip1e4_Threshold;              /* Expression: -1e-4
                                        * Referenced by: '<S5>/Ip<1e-4 '
                                        */
  real_T Constant4_Value_l;            /* Expression: 50
                                        * Referenced by: '<S5>/Constant4'
                                        */
  real_T e6_Gain;                      /* Expression: 1e-6
                                        * Referenced by: '<S14>/1e-6'
                                        */
  real_T e6_Gain_d;                    /* Expression: 1e-6
                                        * Referenced by: '<S14>/1e-6   '
                                        */
  real_T Memory1_X0;                   /* Expression: 0
                                        * Referenced by: '<S18>/Memory1'
                                        */
  real_T e3_Gain;                      /* Expression: 1e-3
                                        * Referenced by: '<S18>/1e-3'
                                        */
  real_T Memory_X0;                    /* Expression: 0
                                        * Referenced by: '<S26>/Memory'
                                        */
  real_T switch1_Threshold;            /* Expression: 1
                                        * Referenced by: '<S18>/switch1'
                                        */
  real_T Constant4_Value_e;            /* Expression: 1
                                        * Referenced by: '<S18>/Constant4'
                                        */
  real_T u_UpperSat;                   /* Expression: 1
                                        * Referenced by: '<S18>/1 0'
                                        */
  real_T u_LowerSat;                   /* Expression: 0
                                        * Referenced by: '<S18>/1 0'
                                        */
  real_T Memory1_X0_c;                 /* Expression: 0
                                        * Referenced by: '<S19>/Memory1'
                                        */
  real_T c_eob_Threshold_d;            /* Expression: 1
                                        * Referenced by: '<S19>/c_eob'
                                        */
  real_T SFunction1_P1_Size_o[2];      /* Computed Parameter: SFunction1_P1_Size_o
                                        * Referenced by: '<S21>/S-Function1'
                                        */
  real_T SFunction1_P1_n;              /* Expression: 0
                                        * Referenced by: '<S21>/S-Function1'
                                        */
  real_T Constant4_Value_g;            /* Expression: 0
                                        * Referenced by: '<S14>/Constant4'
                                        */
  real_T e2_Gain;                      /* Expression: 1e2
                                        * Referenced by: '<S23>/1e2'
                                        */
  real_T SFunction1_P1_Size_h[2];      /* Computed Parameter: SFunction1_P1_Size_h
                                        * Referenced by: '<S44>/S-Function1'
                                        */
  real_T SFunction1_P1_h;              /* Expression: 1
                                        * Referenced by: '<S44>/S-Function1'
                                        */
  real_T Memory2_X0_k;                 /* Expression: 0
                                        * Referenced by: '<S44>/Memory2'
                                        */
  real_T c_eob1_Threshold;             /* Expression: 1
                                        * Referenced by: '<S44>/c_eob  1'
                                        */
  real_T Memory1_X0_k;                 /* Expression: 0
                                        * Referenced by: '<S44>/Memory1'
                                        */
  real_T c_eob_Threshold_h;            /* Expression: 1
                                        * Referenced by: '<S44>/c_eob  '
                                        */
  real_T SFunction1_P1_Size_l[2];      /* Computed Parameter: SFunction1_P1_Size_l
                                        * Referenced by: '<S50>/S-Function1'
                                        */
  real_T SFunction1_P1_b;              /* Expression: 1
                                        * Referenced by: '<S50>/S-Function1'
                                        */
  real_T c_eob_Threshold_g;            /* Expression: 1
                                        * Referenced by: '<S44>/c_eob'
                                        */
  real_T SFunction1_P1_Size_d[2];      /* Computed Parameter: SFunction1_P1_Size_d
                                        * Referenced by: '<S40>/S-Function1'
                                        */
  real_T SFunction1_P1_d;              /* Expression: 2
                                        * Referenced by: '<S40>/S-Function1'
                                        */
  real_T Memory2_X0_o;                 /* Expression: 0
                                        * Referenced by: '<S40>/Memory2'
                                        */
  real_T c_eob1_Threshold_a;           /* Expression: 1
                                        * Referenced by: '<S40>/c_eob  1'
                                        */
  real_T Memory1_X0_f;                 /* Expression: 0
                                        * Referenced by: '<S40>/Memory1'
                                        */
  real_T c_eob_Threshold_l;            /* Expression: 1
                                        * Referenced by: '<S40>/c_eob  '
                                        */
  real_T SFunction1_P1_Size_i[2];      /* Computed Parameter: SFunction1_P1_Size_i
                                        * Referenced by: '<S46>/S-Function1'
                                        */
  real_T SFunction1_P1_m;              /* Expression: 2
                                        * Referenced by: '<S46>/S-Function1'
                                        */
  real_T c_eob_Threshold_j;            /* Expression: 1
                                        * Referenced by: '<S40>/c_eob'
                                        */
  real_T SFunction1_P1_Size_n[2];      /* Computed Parameter: SFunction1_P1_Size_n
                                        * Referenced by: '<S41>/S-Function1'
                                        */
  real_T SFunction1_P1_m3;             /* Expression: 3
                                        * Referenced by: '<S41>/S-Function1'
                                        */
  real_T Memory2_X0_b;                 /* Expression: 0
                                        * Referenced by: '<S41>/Memory2'
                                        */
  real_T c_eob1_Threshold_n;           /* Expression: 1
                                        * Referenced by: '<S41>/c_eob  1'
                                        */
  real_T Memory1_X0_l;                 /* Expression: 0
                                        * Referenced by: '<S41>/Memory1'
                                        */
  real_T c_eob_Threshold_l0;           /* Expression: 1
                                        * Referenced by: '<S41>/c_eob  '
                                        */
  real_T SFunction1_P1_Size_hq[2];     /* Computed Parameter: SFunction1_P1_Size_hq
                                        * Referenced by: '<S47>/S-Function1'
                                        */
  real_T SFunction1_P1_l;              /* Expression: 3
                                        * Referenced by: '<S47>/S-Function1'
                                        */
  real_T c_eob_Threshold_m;            /* Expression: 1
                                        * Referenced by: '<S41>/c_eob'
                                        */
  real_T SFunction1_P1_Size_e[2];      /* Computed Parameter: SFunction1_P1_Size_e
                                        * Referenced by: '<S42>/S-Function1'
                                        */
  real_T SFunction1_P1_bc;             /* Expression: 4
                                        * Referenced by: '<S42>/S-Function1'
                                        */
  real_T Memory2_X0_kt;                /* Expression: 0
                                        * Referenced by: '<S42>/Memory2'
                                        */
  real_T c_eob1_Threshold_c;           /* Expression: 1
                                        * Referenced by: '<S42>/c_eob  1'
                                        */
  real_T Memory1_X0_fb;                /* Expression: 0
                                        * Referenced by: '<S42>/Memory1'
                                        */
  real_T c_eob_Threshold_b;            /* Expression: 1
                                        * Referenced by: '<S42>/c_eob  '
                                        */
  real_T SFunction1_P1_Size_h0[2];     /* Computed Parameter: SFunction1_P1_Size_h0
                                        * Referenced by: '<S48>/S-Function1'
                                        */
  real_T SFunction1_P1_he;             /* Expression: 4
                                        * Referenced by: '<S48>/S-Function1'
                                        */
  real_T c_eob_Threshold_ll;           /* Expression: 1
                                        * Referenced by: '<S42>/c_eob'
                                        */
  real_T SFunction1_P1_Size_o5[2];     /* Computed Parameter: SFunction1_P1_Size_o5
                                        * Referenced by: '<S45>/S-Function1'
                                        */
  real_T SFunction1_P1_o;              /* Expression: 5
                                        * Referenced by: '<S45>/S-Function1'
                                        */
  real_T Memory2_X0_d;                 /* Expression: 0
                                        * Referenced by: '<S45>/Memory2'
                                        */
  real_T c_eob1_Threshold_i;           /* Expression: 1
                                        * Referenced by: '<S45>/c_eob  1'
                                        */
  real_T Memory1_X0_c2;                /* Expression: 0
                                        * Referenced by: '<S45>/Memory1'
                                        */
  real_T c_eob_Threshold_n;            /* Expression: 1
                                        * Referenced by: '<S45>/c_eob  '
                                        */
  real_T SFunction1_P1_Size_c[2];      /* Computed Parameter: SFunction1_P1_Size_c
                                        * Referenced by: '<S51>/S-Function1'
                                        */
  real_T SFunction1_P1_c;              /* Expression: 5
                                        * Referenced by: '<S51>/S-Function1'
                                        */
  real_T c_eob_Threshold_e;            /* Expression: 1
                                        * Referenced by: '<S45>/c_eob'
                                        */
  real_T SFunction1_P1_Size_b[2];      /* Computed Parameter: SFunction1_P1_Size_b
                                        * Referenced by: '<S43>/S-Function1'
                                        */
  real_T SFunction1_P1_f;              /* Expression: 6
                                        * Referenced by: '<S43>/S-Function1'
                                        */
  real_T Memory2_X0_b2;                /* Expression: 0
                                        * Referenced by: '<S43>/Memory2'
                                        */
  real_T c_eob1_Threshold_p;           /* Expression: 1
                                        * Referenced by: '<S43>/c_eob  1'
                                        */
  real_T Memory1_X0_kx;                /* Expression: 0
                                        * Referenced by: '<S43>/Memory1'
                                        */
  real_T c_eob_Threshold_l3;           /* Expression: 1
                                        * Referenced by: '<S43>/c_eob  '
                                        */
  real_T SFunction1_P1_Size_p[2];      /* Computed Parameter: SFunction1_P1_Size_p
                                        * Referenced by: '<S49>/S-Function1'
                                        */
  real_T SFunction1_P1_fa;             /* Expression: 6
                                        * Referenced by: '<S49>/S-Function1'
                                        */
  real_T c_eob_Threshold_o;            /* Expression: 1
                                        * Referenced by: '<S43>/c_eob'
                                        */
  real_T e2_Gain_m;                    /* Expression: 1e-2
                                        * Referenced by: '<S23>/1e-2'
                                        */
  real_T Memory2_X0_n;                 /* Expression: 0
                                        * Referenced by: '<S29>/Memory2'
                                        */
  real_T c_eob_Threshold_do;           /* Expression: 1
                                        * Referenced by: '<S29>/c_eob'
                                        */
  real_T Memory2_X0_l;                 /* Expression: 0
                                        * Referenced by: '<S32>/Memory2'
                                        */
  real_T c_eob_Threshold_mt;           /* Expression: 1
                                        * Referenced by: '<S32>/c_eob'
                                        */
  real_T Memory2_X0_nw;                /* Expression: 0
                                        * Referenced by: '<S33>/Memory2'
                                        */
  real_T c_eob_Threshold_m4;           /* Expression: 1
                                        * Referenced by: '<S33>/c_eob'
                                        */
  real_T Memory2_X0_n4;                /* Expression: 0
                                        * Referenced by: '<S34>/Memory2'
                                        */
  real_T c_eob_Threshold_k;            /* Expression: 1
                                        * Referenced by: '<S34>/c_eob'
                                        */
  real_T Memory2_X0_i;                 /* Expression: 0
                                        * Referenced by: '<S35>/Memory2'
                                        */
  real_T c_eob_Threshold_d1;           /* Expression: 1
                                        * Referenced by: '<S35>/c_eob'
                                        */
  real_T Memory2_X0_iw;                /* Expression: 0
                                        * Referenced by: '<S36>/Memory2'
                                        */
  real_T c_eob_Threshold_nq;           /* Expression: 1
                                        * Referenced by: '<S36>/c_eob'
                                        */
  real_T Memory2_X0_p;                 /* Expression: 0
                                        * Referenced by: '<S37>/Memory2'
                                        */
  real_T c_eob_Threshold_f;            /* Expression: 1
                                        * Referenced by: '<S37>/c_eob'
                                        */
  real_T Memory2_X0_kc;                /* Expression: 0
                                        * Referenced by: '<S38>/Memory2'
                                        */
  real_T c_eob_Threshold_dn;           /* Expression: 1
                                        * Referenced by: '<S38>/c_eob'
                                        */
  real_T Memory2_X0_bx;                /* Expression: 0
                                        * Referenced by: '<S39>/Memory2'
                                        */
  real_T c_eob_Threshold_hv;           /* Expression: 1
                                        * Referenced by: '<S39>/c_eob'
                                        */
  real_T Memory2_X0_of;                /* Expression: 0
                                        * Referenced by: '<S30>/Memory2'
                                        */
  real_T c_eob_Threshold_nd;           /* Expression: 1
                                        * Referenced by: '<S30>/c_eob'
                                        */
  real_T Memory2_X0_m;                 /* Expression: 0
                                        * Referenced by: '<S31>/Memory2'
                                        */
  real_T c_eob_Threshold_nk;           /* Expression: 1
                                        * Referenced by: '<S31>/c_eob'
                                        */
  real_T Memory_X0_h;                  /* Expression: 0
                                        * Referenced by: '<S25>/Memory'
                                        */
  real_T _Threshold;                   /* Expression: 1
                                        * Referenced by: '<S17>/1'
                                        */
  real_T UD_InitialCondition;          /* Expression: ICPrevInput
                                        * Referenced by: '<S27>/UD'
                                        */
  real_T UD_InitialCondition_k;        /* Expression: ICPrevInput
                                        * Referenced by: '<S28>/UD'
                                        */
  real_T u15_Gain_m;                   /* Expression: 1/15
                                        * Referenced by: '<S15>/ 1//15'
                                        */
  real_T _Value_mx;                    /* Expression: 1
                                        * Referenced by: '<S52>/1'
                                        */
  real_T Constant_Value;               /* Expression: const
                                        * Referenced by: '<S68>/Constant'
                                        */
  real_T Memory3_X0;                   /* Expression: 0
                                        * Referenced by: '<S52>/Memory3'
                                        */
  real_T switch1_Threshold_p;          /* Expression: 1
                                        * Referenced by: '<S52>/switch1 '
                                        */
  real_T Saturation1_UpperSat_c;       /* Expression: 1
                                        * Referenced by: '<S52>/Saturation1'
                                        */
  real_T Saturation1_LowerSat_j;       /* Expression: 0
                                        * Referenced by: '<S52>/Saturation1'
                                        */
  real_T Memory1_X0_i;                 /* Expression: 0
                                        * Referenced by: '<S52>/Memory1'
                                        */
  real_T Memory1_X0_g;                 /* Expression: 0
                                        * Referenced by: '<S64>/Memory1'
                                        */
  real_T c_eob_Threshold_p;            /* Expression: 1
                                        * Referenced by: '<S64>/c_eob'
                                        */
  real_T c_eob_Threshold_a;            /* Expression: 1
                                        * Referenced by: '<S15>/c_eob'
                                        */
  real_T Limcontr_A[914];              /* Computed Parameter: Limcontr_A
                                        * Referenced by: '<S55>/Lim. contr.'
                                        */
  real_T Limcontr_B[364];              /* Computed Parameter: Limcontr_B
                                        * Referenced by: '<S55>/Lim. contr.'
                                        */
  real_T Limcontr_C[517];              /* Computed Parameter: Limcontr_C
                                        * Referenced by: '<S55>/Lim. contr.'
                                        */
  real_T Limcontr_D[187];              /* Computed Parameter: Limcontr_D
                                        * Referenced by: '<S55>/Lim. contr.'
                                        */
  real_T Limcontr_X0;                  /* Expression: 0
                                        * Referenced by: '<S55>/Lim. contr.'
                                        */
  real_T Currcontr_A[121];             /* Computed Parameter: Currcontr_A
                                        * Referenced by: '<S55>/Curr. contr.'
                                        */
  real_T Currcontr_B[121];             /* Computed Parameter: Currcontr_B
                                        * Referenced by: '<S55>/Curr. contr.'
                                        */
  real_T Currcontr_C[121];             /* Computed Parameter: Currcontr_C
                                        * Referenced by: '<S55>/Curr. contr.'
                                        */
  real_T Currcontr_X0;                 /* Expression: 0
                                        * Referenced by: '<S55>/Curr. contr.'
                                        */
  real_T switch1_Threshold_i;          /* Expression: 1
                                        * Referenced by: '<S52>/switch1'
                                        */
  real_T _Value_c;                     /* Expression: 1
                                        * Referenced by: '<S15>/1 '
                                        */
  real_T _Value_g;                     /* Expression: 1
                                        * Referenced by: '<S53>/1'
                                        */
  real_T e3_Gain_i;                    /* Expression: 1e3
                                        * Referenced by: '<S53>/1e3'
                                        */
  real_T Saturation_UpperSat_j;        /* Expression: 1
                                        * Referenced by: '<S53>/Saturation'
                                        */
  real_T Saturation_LowerSat_m;        /* Expression: -1
                                        * Referenced by: '<S53>/Saturation'
                                        */
  real_T Constant_Value_a;             /* Expression: const
                                        * Referenced by: '<S70>/Constant'
                                        */
  real_T Memory1_X0_a;                 /* Expression: 0
                                        * Referenced by: '<S66>/Memory1'
                                        */
  real_T Constant_Value_i;             /* Expression: const
                                        * Referenced by: '<S85>/Constant'
                                        */
  real_T Memory_X0_o;                  /* Expression: 0
                                        * Referenced by: '<S58>/Memory'
                                        */
  real_T Constant_Value_f;             /* Expression: const
                                        * Referenced by: '<S77>/Constant'
                                        */
  real_T Divcontr_X0;                  /* Expression: 0
                                        * Referenced by: '<S15>/Div. contr.'
                                        */
  real_T u_Threshold;                  /* Expression: 0.1
                                        * Referenced by: '<S58>/0.1'
                                        */
  real_T Memory1_X0_o;                 /* Expression: 0
                                        * Referenced by: '<S62>/Memory1'
                                        */
  real_T Constant_Value_ir;            /* Expression: const
                                        * Referenced by: '<S81>/Constant'
                                        */
  real_T switch1_Threshold_d;          /* Expression: 1
                                        * Referenced by: '<S62>/switch1'
                                        */
  real_T Div_rdcontr_X0;               /* Expression: 0
                                        * Referenced by: '<S15>/Div_rd contr'
                                        */
  real_T _Threshold_j;                 /* Expression: 1
                                        * Referenced by: '<S66>/1'
                                        */
  real_T Constant_Value_d;             /* Expression: const
                                        * Referenced by: '<S72>/Constant'
                                        */
  real_T _Value_k;                     /* Expression: 1
                                        * Referenced by: '<S54>/1'
                                        */
  real_T Currtermcontr_A[253];         /* Computed Parameter: Currtermcontr_A
                                        * Referenced by: '<S15>/Curr. term. contr'
                                        */
  real_T Currtermcontr_B[121];         /* Computed Parameter: Currtermcontr_B
                                        * Referenced by: '<S15>/Curr. term. contr'
                                        */
  real_T Currtermcontr_C[11];          /* Computed Parameter: Currtermcontr_C
                                        * Referenced by: '<S15>/Curr. term. contr'
                                        */
  real_T Currtermcontr_X0;             /* Expression: 0
                                        * Referenced by: '<S15>/Curr. term. contr'
                                        */
  real_T u01_Gain;                     /* Expression: 1e-3
                                        * Referenced by: '<S86>/0.001'
                                        */
  real_T u01_Gain_d;                   /* Expression: 1e-3
                                        * Referenced by: '<S89>/0.001'
                                        */
  real_T u01_Gain_k;                   /* Expression: 1e-3
                                        * Referenced by: '<S90>/0.001'
                                        */
  real_T u01_Gain_i;                   /* Expression: 1e-3
                                        * Referenced by: '<S91>/0.001'
                                        */
  real_T u01_Gain_m;                   /* Expression: 1e-3
                                        * Referenced by: '<S92>/0.001'
                                        */
  real_T u01_Gain_p;                   /* Expression: 1e-3
                                        * Referenced by: '<S93>/0.001'
                                        */
  real_T u01_Gain_g;                   /* Expression: 1e-3
                                        * Referenced by: '<S94>/0.001'
                                        */
  real_T u01_Gain_n;                   /* Expression: 1e-3
                                        * Referenced by: '<S95>/0.001'
                                        */
  real_T u01_Gain_e;                   /* Expression: 1e-3
                                        * Referenced by: '<S96>/0.001'
                                        */
  real_T u01_Gain_p4;                  /* Expression: 1e-3
                                        * Referenced by: '<S87>/0.001'
                                        */
  real_T u01_Gain_mt;                  /* Expression: 1e-3
                                        * Referenced by: '<S88>/0.001'
                                        */
  real_T Constant_Value_p;             /* Expression: 0
                                        * Referenced by: '<S71>/Constant'
                                        */
  real_T UniformRandomNumber_Minimum;  /* Expression: -1
                                        * Referenced by: '<S63>/Uniform Random Number'
                                        */
  real_T UniformRandomNumber_Maximum;  /* Expression: 1
                                        * Referenced by: '<S63>/Uniform Random Number'
                                        */
  real_T UniformRandomNumber_Seed;     /* Expression: 0
                                        * Referenced by: '<S63>/Uniform Random Number'
                                        */
  real_T u5_Gain;                      /* Expression: 1.75
                                        * Referenced by: '<S82>/1.75'
                                        */
  real_T UD_InitialCondition_n;        /* Expression: ICPrevInput
                                        * Referenced by: '<S83>/UD'
                                        */
  real_T e3_Gain_it;                   /* Expression: 2e3
                                        * Referenced by: '<S82>/2e3'
                                        */
  real_T VScontr_A[21];                /* Computed Parameter: VScontr_A
                                        * Referenced by: '<S60>/VS. contr'
                                        */
  real_T VScontr_B[5];                 /* Computed Parameter: VScontr_B
                                        * Referenced by: '<S60>/VS. contr'
                                        */
  real_T VScontr_C[5];                 /* Computed Parameter: VScontr_C
                                        * Referenced by: '<S60>/VS. contr'
                                        */
  real_T VScontr_D;                    /* Computed Parameter: VScontr_D
                                        * Referenced by: '<S60>/VS. contr'
                                        */
  real_T VScontr_X0;                   /* Expression: 0
                                        * Referenced by: '<S60>/VS. contr'
                                        */
  real_T Constant_Value_g;             /* Expression: const
                                        * Referenced by: '<S79>/Constant'
                                        */
  real_T VScontrhl_A[21];              /* Computed Parameter: VScontrhl_A
                                        * Referenced by: '<S60>/VS. contr hl'
                                        */
  real_T VScontrhl_B[5];               /* Computed Parameter: VScontrhl_B
                                        * Referenced by: '<S60>/VS. contr hl'
                                        */
  real_T VScontrhl_C[5];               /* Computed Parameter: VScontrhl_C
                                        * Referenced by: '<S60>/VS. contr hl'
                                        */
  real_T VScontrhl_D;                  /* Computed Parameter: VScontrhl_D
                                        * Referenced by: '<S60>/VS. contr hl'
                                        */
  real_T VScontrhl_X0;                 /* Expression: 0
                                        * Referenced by: '<S60>/VS. contr hl'
                                        */
  real_T c_eob_Threshold_bg;           /* Expression: 1
                                        * Referenced by: '<S60>/c_eob'
                                        */
  real_T Constant_Value_gf;            /* Expression: const
                                        * Referenced by: '<S78>/Constant'
                                        */
  real_T u5_Gain_a;                    /* Expression: 1/15
                                        * Referenced by: '<S61>/1//15'
                                        */
  real_T _Threshold_jk;                /* Expression: 1
                                        * Referenced by: '<S59>/1'
                                        */
  real_T G_curr_term_Gain[220];        /* Expression: [zeros(8,11); eye(11); zeros(1,11)]
                                        * Referenced by: '<S15>/G_curr_term'
                                        */
  real_T e6_Gain_n;                    /* Expression: 1e6
                                        * Referenced by: '<S55>/1e6'
                                        */
  real_T DataStoreMemory_InitialValue[6500];/* Expression: zeros(13,500)
                                             * Referenced by: '<S5>/Data Store Memory'
                                             */
  real_T DataStoreMemory1_InitialValue[10000];/* Expression: zeros(20,500)
                                               * Referenced by: '<S5>/Data Store Memory1'
                                               */
  real_T DataStoreMemory10_InitialValue;/* Expression: 0
                                         * Referenced by: '<S5>/Data Store Memory10'
                                         */
  real_T DataStoreMemory11_InitialValue;/* Expression: 0
                                         * Referenced by: '<S5>/Data Store Memory11'
                                         */
  real_T DataStoreMemory12_InitialValue;/* Expression: 0
                                         * Referenced by: '<S5>/Data Store Memory12'
                                         */
  real_T DataStoreMemory13_InitialValue;/* Expression: 0
                                         * Referenced by: '<S5>/Data Store Memory13'
                                         */
  real_T DataStoreMemory14_InitialValue;/* Expression: 0
                                         * Referenced by: '<S5>/Data Store Memory14'
                                         */
  real_T DataStoreMemory15_InitialValue;/* Expression: 0
                                         * Referenced by: '<S5>/Data Store Memory15'
                                         */
  real_T DataStoreMemory16_InitialValue;/* Expression: 0
                                         * Referenced by: '<S5>/Data Store Memory16'
                                         */
  real_T DataStoreMemory17_InitialValue;/* Expression: 0
                                         * Referenced by: '<S5>/Data Store Memory17'
                                         */
  real_T DataStoreMemory18_InitialValue;/* Expression: 0
                                         * Referenced by: '<S5>/Data Store Memory18'
                                         */
  real_T DataStoreMemory2_InitialValue;/* Expression: 0
                                        * Referenced by: '<S5>/Data Store Memory2'
                                        */
  real_T DataStoreMemory3_InitialValue;/* Expression: 0
                                        * Referenced by: '<S5>/Data Store Memory3'
                                        */
  real_T DataStoreMemory4_InitialValue;/* Expression: 0.1
                                        * Referenced by: '<S5>/Data Store Memory4'
                                        */
  real_T DataStoreMemory5_InitialValue;/* Expression: 1e-3
                                        * Referenced by: '<S5>/Data Store Memory5'
                                        */
  real_T DataStoreMemory6_InitialValue;/* Expression: 1e-3
                                        * Referenced by: '<S5>/Data Store Memory6'
                                        */
  real_T DataStoreMemory7_InitialValue;/* Expression: 0
                                        * Referenced by: '<S5>/Data Store Memory7'
                                        */
  real_T DataStoreMemory8_InitialValue;/* Expression: 0
                                        * Referenced by: '<S5>/Data Store Memory8'
                                        */
  real_T DataStoreMemory9_InitialValue;/* Expression: 0
                                        * Referenced by: '<S5>/Data Store Memory9'
                                        */
  real_T Memory1_X0_n;                 /* Expression: 0
                                        * Referenced by: '<S7>/Memory1'
                                        */
  real_T _Gain;                        /* Expression: 2
                                        * Referenced by: '<S8>/2'
                                        */
  real_T UD_InitialCondition_p;        /* Expression: ICPrevInput
                                        * Referenced by: '<S6>/UD'
                                        */
  real_T u_Gain_p;                     /* Expression: -1
                                        * Referenced by: '<S8>/-1'
                                        */
  real_T Gain_Gain_e;                  /* Expression: -1
                                        * Referenced by: '<S9>/Gain'
                                        */
  real_T wz1_Value[11];                /* Expression: [0 0 0 0 0 0 -1 -1 1 1 0]'
                                        * Referenced by: '<S2>/wz1'
                                        */
  real_T wz2_Value;                    /* Expression: 1
                                        * Referenced by: '<S2>/wz2'
                                        */
  real_T npf12_Gain[180];              /* Expression: eye(15,11+1)
                                        * Referenced by: '<S2>/npf,12'
                                        */
  real_T DataStoreMemory1_InitialValue_i[12];/* Expression: [554,554,554,554,554  248.6 115.2 185.9 169.9 216.8  459.4 1]
                                              * Referenced by: '<S1>/Data Store Memory1'
                                              */
  real_T DataStoreMemory2_InitialValue_h[6];/* Expression: [1; ones(5,1)*1e-6]
                                             * Referenced by: '<S1>/Data Store Memory2'
                                             */
  real_T DataStoreMemory3_InitialValue_b;/* Expression: 0
                                          * Referenced by: '<S1>/Data Store Memory3'
                                          */
  real_T DataStoreMemory4_InitialValue_e[11];/* Expression: zeros(11,1)
                                              * Referenced by: '<S1>/Data Store Memory4'
                                              */
  real_T DataStoreMemory5_InitialValue_e;/* Expression: 0
                                          * Referenced by: '<S1>/Data Store Memory5'
                                          */
  real_T DataStoreMemory7_InitialValue_p;/* Expression: 0
                                          * Referenced by: '<S1>/Data Store Memory7'
                                          */
  real_T DataStoreMemory8_InitialValue_k;/* Expression: 0
                                          * Referenced by: '<S1>/Data Store Memory8'
                                          */
  real_T DataStoreMemory9_InitialValue_f[11];/* Expression: ones(1,11)*1e6
                                              * Referenced by: '<S1>/Data Store Memory9'
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
    SimStruct childSFunctions[17];
    SimStruct *childSFunctionPtrs[17];
    struct _ssBlkInfo2 blkInfo2[17];
    struct _ssSFcnModelMethods2 methods2[17];
    struct _ssSFcnModelMethods3 methods3[17];
    struct _ssStatesInfo2 statesInfo2[17];
    struct {
      time_T sfcnPeriod[1];
      time_T sfcnOffset[1];
      int_T sfcnTsMap[1];
      struct _ssPortOutputs outputPortInfo[1];
      int_T oDims0[2];
      uint_T attribs[1];
      mxArray *params[1];
    } Sfcn0;

    struct {
      time_T sfcnPeriod[1];
      time_T sfcnOffset[1];
      int_T sfcnTsMap[1];
      struct _ssPortOutputs outputPortInfo[1];
      int_T oDims0[2];
      uint_T attribs[1];
      mxArray *params[1];
    } Sfcn1;

    struct {
      time_T sfcnPeriod[1];
      time_T sfcnOffset[1];
      int_T sfcnTsMap[1];
      struct _ssPortOutputs outputPortInfo[1];
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
    } Sfcn16;
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
 * Block '<S2>/Memory1' : Unused code path elimination
 * Block '<S2>/Memory2' : Unused code path elimination
 * Block '<S2>/Memory3' : Unused code path elimination
 * Block '<S2>/To Workspace1' : Unused code path elimination
 * Block '<S2>/To Workspace2' : Unused code path elimination
 * Block '<S2>/To Workspace3' : Unused code path elimination
 * Block '<S10>/Data Type Duplicate' : Unused code path elimination
 * Block '<S10>/Data Type Propagation' : Unused code path elimination
 * Block '<S11>/Data Type Duplicate' : Unused code path elimination
 * Block '<S11>/Data Type Propagation' : Unused code path elimination
 * Block '<S12>/Data Type Duplicate' : Unused code path elimination
 * Block '<S12>/Data Type Propagation' : Unused code path elimination
 * Block '<S13>/Data Type Duplicate' : Unused code path elimination
 * Block '<S13>/Data Type Propagation' : Unused code path elimination
 * Block '<S1>/Time' : Unused code path elimination
 * Block '<S5>/A' : Unused code path elimination
 * Block '<S5>/A  ' : Unused code path elimination
 * Block '<S14>/To Workspace1' : Unused code path elimination
 * Block '<S14>/To Workspace2' : Unused code path elimination
 * Block '<S14>/To Workspace3' : Unused code path elimination
 * Block '<S54>/1 ' : Unused code path elimination
 * Block '<S54>/Divide4' : Unused code path elimination
 * Block '<S54>/Memory1' : Unused code path elimination
 * Block '<S54>/Saturation' : Unused code path elimination
 * Block '<S54>/Subtract1' : Unused code path elimination
 * Block '<S54>/Subtract2' : Unused code path elimination
 * Block '<S54>/Subtract3' : Unused code path elimination
 * Block '<S56>/Data Type Duplicate' : Unused code path elimination
 * Block '<S56>/Data Type Propagation' : Unused code path elimination
 * Block '<S57>/Data Type Duplicate' : Unused code path elimination
 * Block '<S57>/Data Type Propagation' : Unused code path elimination
 * Block '<S15>/To Workspace' : Unused code path elimination
 * Block '<S80>/Data Type Duplicate' : Unused code path elimination
 * Block '<S80>/Data Type Propagation' : Unused code path elimination
 * Block '<S84>/Data Type Duplicate' : Unused code path elimination
 * Block '<S84>/Data Type Propagation' : Unused code path elimination
 * Block '<S5>/To Workspace21' : Unused code path elimination
 * Block '<S5>/To Workspace5' : Unused code path elimination
 * Block '<S5>/To Workspace7' : Unused code path elimination
 * Block '<S5>/klim' : Unused code path elimination
 * Block '<S5>/m' : Unused code path elimination
 * Block '<S5>/m  ' : Unused code path elimination
 * Block '<S5>/m   ' : Unused code path elimination
 * Block '<S5>/rsep' : Unused code path elimination
 * Block '<S5>/rsep1' : Unused code path elimination
 * Block '<S5>/xleft' : Unused code path elimination
 * Block '<S5>/xright' : Unused code path elimination
 * Block '<S5>/zsep' : Unused code path elimination
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
 * '<S2>'   : 't15_2/Pow. Supply MC 2/Commutation for Dina'
 * '<S3>'   : 't15_2/Pow. Supply MC 2/Pow. Supply MC 2'
 * '<S4>'   : 't15_2/Pow. Supply MC 2/Pow. Supply VS1,3'
 * '<S5>'   : 't15_2/Pow. Supply MC 2/kavin_contr'
 * '<S6>'   : 't15_2/Pow. Supply MC 2/Pow. Supply MC 2/Difference'
 * '<S7>'   : 't15_2/Pow. Supply MC 2/Pow. Supply MC 2/Pow. Supply MC 1'
 * '<S8>'   : 't15_2/Pow. Supply MC 2/Pow. Supply MC 2/Pow. Supply MC 1/MC rate'
 * '<S9>'   : 't15_2/Pow. Supply MC 2/Pow. Supply MC 2/Pow. Supply MC 1/MC satur.'
 * '<S10>'  : 't15_2/Pow. Supply MC 2/Pow. Supply MC 2/Pow. Supply MC 1/MC rate/Saturation Dynamic'
 * '<S11>'  : 't15_2/Pow. Supply MC 2/Pow. Supply MC 2/Pow. Supply MC 1/MC satur./Saturation Dynamic'
 * '<S12>'  : 't15_2/Pow. Supply MC 2/Pow. Supply VS1,3/Saturation Dynamic'
 * '<S13>'  : 't15_2/Pow. Supply MC 2/Pow. Supply VS1,3/Saturation Dynamic1'
 * '<S14>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1'
 * '<S15>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1'
 * '<S16>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Subsystem'
 * '<S17>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/Err.'
 * '<S18>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/Ics1_end'
 * '<S19>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/Ip_ref scr_data.dat'
 * '<S20>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/dZ//dt'
 * '<S21>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/elong_ref.dat'
 * '<S22>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/err(Ic) scr_data.dat'
 * '<S23>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/g1-g6.dat,g1_term-g6_term.dat'
 * '<S24>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/g4'
 * '<S25>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/Err./Trigger'
 * '<S26>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/Ics1_end/Trigger'
 * '<S27>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/dZ//dt/Difference'
 * '<S28>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/dZ//dt/Difference1'
 * '<S29>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/err(Ic) scr_data.dat/Icoil1 ref'
 * '<S30>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/err(Ic) scr_data.dat/Icoil10 ref'
 * '<S31>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/err(Ic) scr_data.dat/Icoil11 ref'
 * '<S32>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/err(Ic) scr_data.dat/Icoil2 ref'
 * '<S33>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/err(Ic) scr_data.dat/Icoil3 ref'
 * '<S34>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/err(Ic) scr_data.dat/Icoil4 ref'
 * '<S35>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/err(Ic) scr_data.dat/Icoil5 ref'
 * '<S36>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/err(Ic) scr_data.dat/Icoil6 ref'
 * '<S37>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/err(Ic) scr_data.dat/Icoil7 ref'
 * '<S38>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/err(Ic) scr_data.dat/Icoil8 ref'
 * '<S39>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/err(Ic) scr_data.dat/Icoil9 ref'
 * '<S40>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/g1-g6.dat,g1_term-g6_term.dat/Subsystem1'
 * '<S41>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/g1-g6.dat,g1_term-g6_term.dat/Subsystem2'
 * '<S42>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/g1-g6.dat,g1_term-g6_term.dat/Subsystem3'
 * '<S43>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/g1-g6.dat,g1_term-g6_term.dat/Subsystem5'
 * '<S44>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/g1-g6.dat,g1_term-g6_term.dat/Subsystem6'
 * '<S45>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/g1-g6.dat,g1_term-g6_term.dat/Zcontr'
 * '<S46>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/g1-g6.dat,g1_term-g6_term.dat/Subsystem1/g2_term,ref'
 * '<S47>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/g1-g6.dat,g1_term-g6_term.dat/Subsystem2/g3_term,ref'
 * '<S48>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/g1-g6.dat,g1_term-g6_term.dat/Subsystem3/g4_term,ref'
 * '<S49>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/g1-g6.dat,g1_term-g6_term.dat/Subsystem5/g6_term,ref'
 * '<S50>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/g1-g6.dat,g1_term-g6_term.dat/Subsystem6/g1_term,ref'
 * '<S51>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control inputs 1/g1-g6.dat,g1_term-g6_term.dat/Zcontr/g5_term,ref'
 * '<S52>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/ tt_kavin2.dat(1)'
 * '<S53>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/Curr. satur.1'
 * '<S54>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/Ip>cIp_end'
 * '<S55>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/Lim. contr.1'
 * '<S56>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/Saturation Dynamic'
 * '<S57>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/Saturation Dynamic1'
 * '<S58>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/Subsystem7'
 * '<S59>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/Subsystem8'
 * '<S60>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/VS VShl contr.'
 * '<S61>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/VS gain 1'
 * '<S62>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/div_divrd'
 * '<S63>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/dzdt noise1'
 * '<S64>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/scr_data.dat'
 * '<S65>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/t_tran2D'
 * '<S66>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/tt_kavin2.dat(1,4)'
 * '<S67>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/volt.dat'
 * '<S68>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/ tt_kavin2.dat(1)/Compare To Constant'
 * '<S69>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/ tt_kavin2.dat(1)/Ip<|cIp_end|'
 * '<S70>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/Curr. satur.1/Compare To Constant'
 * '<S71>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/Curr. satur.1/Compare To Zero'
 * '<S72>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/Ip>cIp_end/Compare To Constant1'
 * '<S73>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/Ip>cIp_end/Ip<cIp_end'
 * '<S74>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/Lim. contr.1/gain_cont2'
 * '<S75>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/Lim. contr.1/t_cont2'
 * '<S76>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/Lim. contr.1/t_cont2_2'
 * '<S77>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/Subsystem7/Compare To Constant1'
 * '<S78>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/Subsystem8/Compare To Constant1'
 * '<S79>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/VS VShl contr./Compare To Constant1'
 * '<S80>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/VS gain 1/Saturation Dynamic'
 * '<S81>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/div_divrd/Compare To Constant1'
 * '<S82>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/dzdt noise1/Subsystem'
 * '<S83>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/dzdt noise1/Subsystem/Difference'
 * '<S84>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/scr_data.dat/Saturation Dynamic'
 * '<S85>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/tt_kavin2.dat(1,4)/Compare To Constant1'
 * '<S86>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/volt.dat/volt1'
 * '<S87>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/volt.dat/volt10'
 * '<S88>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/volt.dat/volt11'
 * '<S89>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/volt.dat/volt2'
 * '<S90>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/volt.dat/volt3'
 * '<S91>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/volt.dat/volt4'
 * '<S92>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/volt.dat/volt5'
 * '<S93>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/volt.dat/volt6'
 * '<S94>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/volt.dat/volt7'
 * '<S95>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/volt.dat/volt8'
 * '<S96>'  : 't15_2/Pow. Supply MC 2/kavin_contr/Control1/volt.dat/volt9'
 */
#endif                                 /* RTW_HEADER_t15_2_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
