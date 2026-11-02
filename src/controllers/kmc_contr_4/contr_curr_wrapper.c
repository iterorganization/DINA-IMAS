

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
#include <stdio.h>
/* %%%-SFUNWIZ_wrapper_includes_Changes_END --- EDIT HERE TO _BEGIN */
#define u_width 20
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
void contr_curr_Outputs_wrapper(const real_T *u0,
			real_T *y0,
			const real_T *xD,
			const real_T  *n_in, const int_T  p_width0,
			const real_T  *n_out, const int_T  p_width1,
			const real_T  *k_hl, const int_T  p_width2)
{
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_BEGIN --- EDIT HERE TO _END */
/* This sample sets the output equal to the input
         y0[0] = u0[0];
For complex signals use: y0[0].re = u0[0].re;
                         y0[0].im = u0[0].im;
                         y1[0].re = u1[0].re;
                         y1[0].im = u1[0].im;*/
static int kl,N_st,kl2,N_st2; int i,j,k,N_in,N_out,K_hl; static double y[100][100],y2[100][100]; double s1;
FILE*f;

N_in=*n_in; N_out=*n_out; K_hl=*k_hl;

if(K_hl==1){
if(kl==0){
	printf("1 +++cont_curr.flat \n");

f=fopen("controllers/cont_curr.flat","r");
fscanf(f,"%d ",&N_st);
for(i=0; i<N_st+N_out; i++) for(j=0;j<N_st+N_in; j++) fscanf(f,"%lf",y[i]+j);
fclose(f);
	printf("end of reading cont_curr.flat \n");
/*mexPrintf(" i %d\n",i);*/
kl=1;}

for(j=0;j<N_out;j++) {{s1=0; for(k=0;k<N_st+N_in;k++) 
if (k<N_st) s1=s1+y[j+N_st][k]*xD[k]; else s1=s1+y[j+N_st][k]*u0[k-N_st];}
y0[j]=s1;}}

if(K_hl>1){
if(kl2==0){
f=fopen("controllers/contr_cur_term.flat","r");
fscanf(f,"%d ",&N_st2);
for(i=0; i<N_st2+N_out; i++) for(j=0;j<N_st2+N_in; j++) fscanf(f,"%lf",y2[i]+j);
fclose(f);
	printf("end of reading contr_cur_term.flat \n");

/*mexPrintf(" i %d\n",i);*/
kl2=1;}

for(j=0;j<N_out;j++) {{s1=0; for(k=0;k<N_st2+N_in;k++) 
if (k<N_st2) s1=s1+y2[j+N_st2][k]*xD[k]; else s1=s1+y2[j+N_st2][k]*u0[k-N_st2];}
y0[j]=s1;}}
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_END --- EDIT HERE TO _BEGIN */
}

/*
  * Updates function
  *
  */
void contr_curr_Update_wrapper(const real_T *u0,
			const real_T *y0,
			real_T *xD,
			const real_T  *n_in,  const int_T  p_width0,
			const real_T  *n_out,  const int_T  p_width1,
			const real_T  *k_hl,  const int_T  p_width2)
{
  /* %%%-SFUNWIZ_wrapper_Update_Changes_BEGIN --- EDIT HERE TO _END */
/*
 * Code example
 *   xD[0] = u0[0];
*/

static int kl,N_st,kl2,N_st2; FILE*f;
int i,j,k,N_in,N_out,K_hl; static double y[100][100],y2[100][100]; double s1,xD_2[50];

N_in=*n_in; N_out=*n_out; K_hl=*k_hl;

printf("---cont_curr.flat \n");


if(K_hl==1){
if(kl==0){
f=fopen("controllers/cont_curr.flat","r");
fscanf(f,"%d ",&N_st);
for(i=0; i<N_st+N_out; i++) for(j=0;j<N_st+N_in; j++) fscanf(f,"%lf",y[i]+j);
fclose(f);
	printf("end of reading cont_curr.flat \n");

for(j=0;j<50;j++) xD[j]=0;
kl=1;}

for(j=0;j<N_st;j++) {{s1=0; for(k=0;k<N_st+N_in;k++) 
if (k<N_st) s1=s1+y[j][k]*xD[k]; else s1=s1+y[j][k]*u0[k-N_st];}
xD_2[j]=s1;}
for(j=0;j<N_st;j++) xD[j]=xD_2[j];}

if(K_hl>1){
if(kl2==0){
f=fopen("controllers/contr_cur_term.flat","r");
fscanf(f,"%d ",&N_st2);
for(i=0; i<N_st2+N_out; i++) for(j=0;j<N_st2+N_in; j++) fscanf(f,"%lf",y2[i]+j);
fclose(f);
	printf("end of reading contr_cur_term.flat \n");

for(j=0;j<50;j++) xD[j]=0;
kl2=1;}

for(j=0;j<N_st2;j++) {{s1=0; for(k=0;k<N_st2+N_in;k++) 
if (k<N_st2) s1=s1+y2[j][k]*xD[k]; else s1=s1+y2[j][k]*u0[k-N_st2];}
xD_2[j]=s1;}
for(j=0;j<N_st2;j++) xD[j]=xD_2[j];}
/* %%%-SFUNWIZ_wrapper_Update_Changes_END --- EDIT HERE TO _BEGIN */
}
