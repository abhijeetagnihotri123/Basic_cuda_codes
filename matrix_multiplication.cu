#include <cuda.h>
#include <iostream>
#define N 1024
using namespace std;
__global__ void matrix_multiplication(int A[][N],int B[][N],int C[][N])
{   
    int id=threadIdx.x;
    __syncthreads();
    for(int j=0;j<N;j++)
    {
        for(int k=0;k<N;k++)
        {
            C[id][j]+=A[id][k]*B[k][j];
        }
    }
}
int A[N][N],B[N][N],C[N][N];
int main(int argc,char *argv[])
{   
    for(int i=0;i<N;i++)
    {
        for(int j=0;j<N;j++)
        {
            A[i][j]=2*i+j;
            C[i][j]=0;
            B[i][j]=2*j+i;
        }
    }
    int (*A_D)[N],(*B_D)[N],(*C_D)[N];
    cudaMalloc((void**)&A_D, (N*N)*sizeof(int));
    cudaMalloc((void**)&B_D, (N*N)*sizeof(int));
    cudaMalloc((void**)&C_D, (N*N)*sizeof(int));
    cudaMemcpy(A_D,A,N*N*sizeof(int),cudaMemcpyHostToDevice);
    cudaMemcpy(B_D,B,N*N*sizeof(int),cudaMemcpyHostToDevice);
    cudaMemcpy(C_D,C,N*N*sizeof(int),cudaMemcpyHostToDevice);
    matrix_multiplication<<<1,N>>>(A_D,B_D,C_D);
    cudaMemcpy(C,C_D,N*N*sizeof(int),cudaMemcpyDeviceToHost);
    // for(int i=0;i<N;i++)
    // {
    //     for(int j=0;j<N;j++)
    //     {
    //         cout<<C[i][j]<<" ";
    //     }
    //     cout<<endl;
    // }
    cudaFree(A_D);
    cudaFree(B_D);
    cudaFree(C_D);
    return 0;
}