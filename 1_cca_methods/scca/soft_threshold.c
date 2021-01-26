#include "mex.h"

/* w_threshold=soft_threshold(w, lambda)
   w is the dense column vector
*/
void CheckInput(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  /* Check for proper number of arguments. */
  if (nrhs < 1)
     mexErrMsgTxt("soft_threshold(W, lambda).\n");
  
  if(mxIsSparse(prhs[0]) || mxIsComplex(prhs[0]))
    mexErrMsgTxt("Input must be a dense real matrix\n");
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs,const mxArray *prhs[])
{
  double lambda;
  double *w;
  mwSize len, m, n, i;
  double *s; 
      
  CheckInput(nlhs, plhs, nrhs, prhs);
  
  m=mxGetM(prhs[0]);
  n=mxGetN(prhs[0]);
  w=mxGetPr(prhs[0]);
  if (nrhs>1)
    lambda=mxGetScalar(prhs[1]);
  else
    lambda=1;
  
  plhs[0]=mxCreateDoubleMatrix(m,n,mxREAL);
  s=mxGetPr(plhs[0]);
  len=m*n;
  
  for (i=0; i<len; ++i){
      if (w[i]>lambda){
          s[i]=w[i]-lambda;          
      }
      else if (w[i]<-lambda){
          s[i]=w[i]+lambda;          
      }
      else {
          s[i]=0;       
      }
  }  
}
