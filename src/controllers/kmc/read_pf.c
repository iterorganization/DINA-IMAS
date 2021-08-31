#include <stdio.h>

#define nmax 9997
#define kf 15
#define mexPrintf printf

extern struct t15_mem6 mem6;

struct t15_mem6
{
	int kmax;
	double pf[nmax][kf];
	double t[nmax],tpl[nmax];
};




extern FILE*prob;
extern FILE*f2;

/* Subroutine */ int scen_read(int i_en, int npf, int indx, int  *n, 
		double *t_val, double *tpl_val, double *pf_val)
{
    int i, j, ii, nmax1;
    char s_ncam[50];

	float ss;

	static int kmax;
	static double pf[nmax][kf];
	static double t[nmax],tpl[nmax];
	int res;
	char b[1256];

//	FILE *prob;



	if(i_en > -1){goto l2;}

	mexPrintf(" i_en  %d  \n ",i_en);
	
	prob=fopen("general_data.dat","r");
	f2=prob;

	printf("---general_data.dat \n");

//	fscanf(prob, "%s ", &s_ncam);
 
	fgets(b,1255,prob);

	printf("%s  ",b);

    fscanf(prob, "%d ",&nmax1);

	fgets(b,1255,prob);
	printf("%s  ",b);

	printf(" nmax1===  %d \n ",nmax1);

	for (i = 1; i <= nmax1; ++i) {

	res=fscanf(prob, " \n %f",&ss);

	kmax=i;

	t[i]=ss;

	mexPrintf(" i res t %d %d %f \n",i,res,t[i]);

    //printf(" i %d \n ",i);
    //printf(" rc %g  ",rc[i]);
	fscanf(prob, "%f",&ss);
	tpl[i]=ss;
	mexPrintf(" i t tpl  %d %f %f \n ",i,t[i],tpl[i]);
    //printf(" zc %g  ",zc[i]);
	for (j = 1; j <= npf; ++j) {
	fscanf(prob, "%f",&ss);
	pf[i][j]=ss;
		mexPrintf("%f ",pf[i][j]);
     }
    	
	    fscanf(prob, "\n");

		mexPrintf(" \n   ");

						 
								 }

l1:

/* close (41) */

	mexPrintf(" l1 final  i res %d %d \n   ",i,res);

//	fclose(f);

//	return 0;


	kmax=kmax+1;
	i=kmax;
	t[i]=10000.;
	tpl[i]=tpl[i-1];
	for (j = 1; j <= npf; ++j) {
	pf[i][j]=pf[i-1][j];}

//	goto l2;


	i=0;
	t[i]=-1.e-5;
	tpl[i]=tpl[i+1];
	for (j = 1; j <= npf; ++j) {
	pf[i][j]=pf[i+1][j];}

l2:

//	mexPrintf(" kmax= indx %d %d \n ",kmax,indx);

//	return 0;
	
	kmax=mem6.kmax;

	mexPrintf(" +++ kmax= npf  %d %d \n ",kmax,npf);

	for (i = 0; i <= kmax; ++i) {
		t_val[i]=mem6.t[i];
		tpl_val[i]=mem6.tpl[i];
    	for (j = 1; j <= npf; ++j) {
		pf_val[j+i*npf]=mem6.pf[i][j];}
	}

//	mexPrintf("  return \n   ");
	n[0]=kmax;

//	mexPrintf("  return 2 n %d \n   ",n[0]);

    return 0;
} /* scen_read */

