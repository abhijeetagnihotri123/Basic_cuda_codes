#include <cuda.h>
#include <cuda_profiler_api.h>
#include <iostream>
#define N 1024
using namespace std;
__global__ void transpose(int A[][N])//,int B[][N],int C[][N])
{
    int id = threadIdx.x;
    for(int j=0;j<id;j++)
    {
        int t = A[id][j] ^ A[j][id];
        A[id][j] = t ^ A[id][j];
        A[j][id] = t ^ A[j][id];
    }
}
int A[N][N];
int main(int argc,char *argv[])
{
    for(int i=0;i<N;i++)
    {
        for(int j=0;j<N;j++)
        {
            A[i][j]=2*i+j;
          //  cout<<A[i][j]<<" ";
        }
        //cout<<endl;
    }
    int (*A_D)[N];
    cudaMalloc((void**)&A_D,(N*N)*sizeof(int));
    cudaMemcpy(A_D,A,(N*N)*sizeof(int),cudaMemcpyHostToDevice);
    transpose<<<1,N>>>(A_D);//,B_D,C_D);
    cudaMemcpy(A,A_D,(N*N)*sizeof(int),cudaMemcpyDeviceToHost);
    // for(int i=0;i<N;i++)
    // {
    //     for(int j=0;j<N;j++)
    //     {
    //         cout<<A[i][j]<<" ";
    //     }
    //     cout<<endl;
    // }
    cudaFree(A_D);
    return 0;
}