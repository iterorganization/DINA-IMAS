

/*
 * Include Files
 *
 */
#if defined(MATLAB_MEX_FILE)
#include "tmwtypes.h"
#include "simstruc_types.h"
#else
#include "rtwtypes.h"
#endif

/* %%%-SFUNWIZ_wrapper_includes_Changes_BEGIN --- EDIT HERE TO _END */
#include <math.h>
#include<stdio.h>
/* %%%-SFUNWIZ_wrapper_includes_Changes_END --- EDIT HERE TO _BEGIN */
#define u_width 
#define y_width 1
/*
 * Create external references here.  
 *
 */
/* %%%-SFUNWIZ_wrapper_externs_Changes_BEGIN --- EDIT HERE TO _END */
/* extern double func(double a); */
/* %%%-SFUNWIZ_wrapper_externs_Changes_END --- EDIT HERE TO _BEGIN */

/*
 * Output functions
 *
 */
void read_tt_kavin2_Outputs_wrapper(real_T *y0)
{
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_BEGIN --- EDIT HERE TO _END */
/* This sample sets the output equal to the input
      y0[0] = u0[0]; 
 For complex signals use: y0[0].re = u0[0].re; 
      y0[0].im = u0[0].im;
      y1[0].re = u1[0].re;
      y1[0].im = u1[0].im;
*/
int i; static int kl;
double y[43];
FILE*f;char b[256];

if(kl==0){

f=fopen("tt_kavin2.dat","r");
fgets(b,255,f);
fscanf(f,"%lf ",&y[0]); y[0]=y[0]*1e-3;

fscanf(f,"\n");
fgets(b,255,f);
/*for(i=1;i<4;i++) fscanf(f,"%lf %lf %lf",&y[i],&y[i]+1,&y[i]+2);*/
for(i=1;i<=3;i++) fscanf(f,"%lf",&y[i]);

fscanf(f,"\n");
fgets(b,255,f);
for(i=4;i<6;i++) fscanf(f,"%lf",&y[i]);
y0[0]=y[0];y0[1]=y[2];y0[2]=y[3];y0[3]=y[1];
y0[4]=y[4];y0[5]=y[5];
fclose(f);

f=fopen("control_data.dat","r");
fgets(b,255,f);
for(i=0; i<=13; i++) fscanf(f,"%lf",&y[i]);

fscanf(f,"\n");
fgets(b,255,f);
/*fscanf(f,"%s",&b);*/
/*mexPrintf("%s\n",b);*/
for(i=14; i<=25; i++) fscanf(f,"%lf",&y[i]);
fclose(f);
for(i=6;i<=31;i++) y0[i]=y[i-6];

f=fopen("turn.dat","r");fgets(b,255,f);
for(i=26; i<=37; i++) fscanf(f,"%lf",&y[i]);
fclose(f);
for(i=32;i<=43;i++) y0[i]=y[i-6];

kl=1;}
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_END --- EDIT HERE TO _BEGIN */
}
