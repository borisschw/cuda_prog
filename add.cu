#include <iostream>
#include <math.h>
#include <cuda_profiler_api.h>

// Kernel function to add the elements of two arrays
__global__
void add(int n, float *x, float *y)
{
  int i = threadIdx.x;
  y[i] = x[i] + y[i];
  // int index = blockIdx.x * blockDim.x + threadIdx.x;
  // int stride = blockDim.x * gridDim.x;
  // for (int i = index; i < n; i += stride)
  //   y[i] = x[i] + y[i];
}

int main(void)
{
  int N = 512;
  float *x, *y;
  cudaProfilerStart();
  // Allocate Unified Memory – accessible from CPU or GPU
  cudaMallocManaged(&x, N*sizeof(float));
  cudaMallocManaged(&y, N*sizeof(float));

  // initialize x and y arrays on the host
  for (int i = 0; i < N; i++) {
    x[i] = 1.0f;
    y[i] = 2.0f;
  }

  dim3 threadsPerBlock(N, N);

  // Run kernel on 1M elements on the GPU
  int blockSize = 512;
  // int numBlocks = (N + blockSize - 1) / blockSize;
  // std::cout << "blockSize = " << blockSize << std::endl;
  // std::cout << "numBlocks = " << numBlocks << std::endl;

  add<<<1, blockSize>>>(N, x, y);

  // Wait for GPU to finish before accessing on host
  cudaDeviceSynchronize();

  // Check for errors (all values should be 3.0f)
  float maxError = 0.0f;
  for (int i = 0; i < N; i++)
    maxError = fmax(maxError, fabs(y[i]-3.0f));
  std::cout << "Max error: " << maxError << std::endl;

  // Free memory
  cudaFree(x);
  cudaFree(y);
  cudaDeviceReset();
  cudaProfilerStop();

  return 0;
}