#include <cuda.h>
#include <iostream>
#define N 32
using namespace std;
__global__ void matrix_Add(int A[][N],int B[][N],int C[][N])
{
    int i=blockIdx.x;
    int j=threadIdx.x;
    __syncthreads();
    C[i][j]=A[i][j]+B[i][j];
    //printf("asjkdsl");
}
int main(int argc,char *argv[])
{   
    int A[N][N],B[N][N],C[N][N];
    for(int i=0;i<N;i++)
    {
        for(int j=0;j<N;j++)
        {
            A[i][j]=2*i+j;
            B[i][j]=i+2*j;
        }
    }
    int (*A_D)[N],(*B_D)[N],(*C_D)[N];
    cudaMalloc((void**)&A_D, (N*N)*sizeof(int));
    cudaMalloc((void**)&B_D, (N*N)*sizeof(int));
    cudaMalloc((void**)&C_D, (N*N)*sizeof(int));
    cudaMemcpy(A_D,A,N*N*sizeof(int),cudaMemcpyHostToDevice);
    cudaMemcpy(B_D,B,N*N*sizeof(int),cudaMemcpyHostToDevice);
    matrix_Add<<<N,N>>>(A_D,B_D,C_D);
    cudaMemcpy(C,C_D,N*N*sizeof(int),cudaMemcpyDeviceToHost);
    for(int i=0;i<N;i++)
    {
        for(int j=0;j<N;j++)
        {
            cout<<C[i][j]<<" ";
        }
        cout<<endl;
    }
    cudaFree(A_D);
    cudaFree(B_D);
    cudaFree(C_D);
    return 0;
}