#include <cuda.h>
#include <iostream>
#define N 1024
using namespace std;
//nvcc -arch=sm_35 -rdc=true quicksort.cu -o a -lcudadevrt
//use above command to compile
__global__ void quicksort(int *a,int left,int right)
{   
        if(left<right)
        {
            int pivot=a[right];
            int PI=left;
            for(int i=left;i<right;i++)
            {
                if(a[i]<=pivot)
                {
                    int t = a[PI]^a[i];
                    a[PI] = t ^ a[PI];
                    a[i] = t ^ a[i];
                    PI++;
                }
            }
            int t = a[PI]^a[right];
            a[PI] = t ^ a[PI];
            a[right] = t ^ a[right];
            cudaStream_t s1,s2;
            cudaStreamCreateWithFlags(&s1,cudaStreamNonBlocking);
            quicksort<<<1,1,0,s1>>>(a,left,PI-1);
            cudaStreamDestroy(s1);
            cudaStreamCreateWithFlags(&s2,cudaStreamNonBlocking);
            quicksort<<<1,1,0,s2>>>(a,PI+1,right);
            cudaStreamDestroy(s2);
        }
}
int main(int argc,char *argv[])
{   
    int *a,*A_D;
    a=new int[N];
    for(int i=0;i<N;i++)
    {
        a[i]=N-i;
    }
    cudaMalloc((void**)&A_D,N*sizeof(int));
    cudaMemcpy(A_D,a,N*sizeof(int),cudaMemcpyHostToDevice);
    quicksort<<<1,1>>>(A_D,0,N-1);
    cudaMemcpy(a,A_D,N*sizeof(int),cudaMemcpyDeviceToHost);
    for(int i=0;i<N;i++)
    {
        cout<<a[i]<<" ";
    }
    cudaFree(A_D);
    delete(a);
    return 0;   
}
