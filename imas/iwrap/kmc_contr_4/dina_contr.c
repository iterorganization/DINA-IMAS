#include <float.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


extern void t15_2_initialize(bool aa2);

extern void t15_2_output(int k_in, double a_in[],int k_out, double a_out[]); 


void dina_contr(double arr_in1[],double arr_out1[])

//double arr_in1[501], arr_out1[501]; 

{

static int first_call=0,  loop_count=0;
int  npf, n_gaps, ncam, i;
int n_input1, n_input2;
int n_output1, n_output2;

int KINT=500;

int k_in, k_out;

double input_1[KINT],input_2[KINT]; 
double output_1[KINT],output_2[KINT]; 

double a_in[KINT],a_out[KINT]; 


bool aa2;

printf(" Entering dina_contr loop, first_call =%4d %4d\n",first_call,loop_count);

first_call=first_call+1;


   npf=15;
   n_gaps=6;
   ncam=100;
    
   n_input1=15;
   n_input2=npf+n_gaps+ncam;
      
   n_output1=2;
   n_output2=15;

      k_in=15+123;
      k_out=15;


for (i=0;i<n_input1;i++)
{
	input_1[i]=arr_in1[i];
}
for (i=0;i<n_input2;i++)
{
input_2[i]=arr_in1[n_input1+i];
}

      if(first_call =1)
	  {
       t15_2_initialize(aa2);
	  }

for (i=0;i<15;i++)
{
	a_in[i]=input_1[i];
}

for (i=0;i<123;i++)
{
	a_in[i+15]=input_2[i];
}

      t15_2_output(k_in, a_in,k_out, a_out); 


for (i=0;i<2;i++)
{
	  output_1[i]=0.;
}
	  
	  for (i=0;i<15;i++)
{
	  output_2[i]=a_out[i];
}


for (i=0;i<n_output1;i++)
{
	arr_out1[i]=output_1[i];
}      
for (i=0;i<n_output2;i++)
{
	  arr_out1[n_output1+i]=output_2[i];
}

}
