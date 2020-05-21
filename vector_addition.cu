#include <cuda.h>
#include <iostream>
#define N 1024
using namespace std;
__global__ void add(int *a,int *b,int *c)
{
    int tid = threadIdx.x;
    if(tid < N)
    {
        c[tid]=a[tid]+b[tid];
    }
}
int main(int argc,char *argv[])
{   
    int *a,*b,*c,*A_D,*B_D,*C_D;
    a=new int[N];
    b=new int[N];
    c=new int[N];
    for(int i=0;i<N;i++)
    {
        a[i] = i+1;
        b[i] = 2*i+2;
    }
    cudaMalloc((void**)&A_D,N*sizeof(int));
    cudaMalloc((void**)&B_D,N*sizeof(int));
    cudaMemcpy(A_D,a,N*sizeof(int),cudaMemcpyHostToDevice);
    cudaMemcpy(B_D,b,N*sizeof(int),cudaMemcpyHostToDevice);
    //cudaMemcpy(C_D,c,N*sizeof(int),cudaMemcpyHostToDevice);
    add<<<1,N>>>(A_D,B_D,C_D);
    cudaMemcpy(c,C_D,N*sizeof(int),cudaMemcpyDeviceToHost);
    cout<<c[0];
    cudaFree(A_D);
    cudaFree(B_D);
    cudaFree(C_D);
    delete(a);
    delete(b);
    delete(c);
    return 0;
}