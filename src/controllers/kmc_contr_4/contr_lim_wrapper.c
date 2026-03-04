

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
void contr_lim_Outputs_wrapper(const real_T *u0,
			real_T *y0,
			const real_T *xD,
			const real_T  *n_in, const int_T  p_width0,
			const real_T  *n_out, const int_T  p_width1)
{
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_BEGIN --- EDIT HERE TO _END */
/* This sample sets the output equal to the input
         y0[0] = u0[0];
For complex signals use: y0[0].re = u0[0].re;
                         y0[0].im = u0[0].im;
                         y1[0].re = u1[0].re;
                         y1[0].im = u1[0].im;*/
static int kl,N_st; int i,j,k,N_in,N_out; static double y[100][100]; double s1;
FILE*f;

N_in=*n_in; N_out=*n_out;

printf("---contr_lim.flat \n");


if(kl==0){
	printf("3 +++cont_lim.flat \n");
f=fopen("controllers/contr_lim.flat","r");
fscanf(f,"%d ",&N_st);
for(i=0; i<N_st+N_out; i++) for(j=0;j<N_st+N_in; j++) fscanf(f,"%lf",y[i]+j);
fclose(f);

	printf(" end of reading cont_lim.flat \n");

/*mexPrintf(" i %d\n",i);*/
kl=1;}

for(j=0;j<N_out;j++) {{s1=0; for(k=0;k<N_st+N_in;k++) 
if (k<N_st) s1=s1+y[j+N_st][k]*xD[k]; else s1=s1+y[j+N_st][k]*u0[k-N_st];}
y0[j]=s1;}
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_END --- EDIT HERE TO _BEGIN */
}

/*
  * Updates function
  *
  */
void contr_lim_Update_wrapper(const real_T *u0,
			const real_T *y0,
			real_T *xD,
			const real_T  *n_in,  const int_T  p_width0,
			const real_T  *n_out,  const int_T  p_width1)
{
  /* %%%-SFUNWIZ_wrapper_Update_Changes_BEGIN --- EDIT HERE TO _END */
/*
 * Code example
 *   xD[0] = u0[0];
*/
static int kl,N_st; FILE*f;
int i,j,k,N_in,N_out; static double y[100][100]; double s1,xD_2[50];

N_in=*n_in; N_out=*n_out;

if(kl==0){
f=fopen("controllers/contr_lim.flat","r");
fscanf(f,"%d ",&N_st);
for(i=0; i<N_st+N_out; i++) for(j=0;j<N_st+N_in; j++) fscanf(f,"%lf",y[i]+j);
fclose(f);
	printf(" end of reading contr_lim.flat \n");

	kl=1;}

for(j=0;j<N_st;j++) {{s1=0; for(k=0;k<N_st+N_in;k++) 
if (k<N_st) s1=s1+y[j][k]*xD[k]; else s1=s1+y[j][k]*u0[k-N_st];}
xD_2[j]=s1;}
for(j=0;j<N_st;j++) xD[j]=xD_2[j];
/* %%%-SFUNWIZ_wrapper_Update_Changes_END --- EDIT HERE TO _BEGIN */
}
