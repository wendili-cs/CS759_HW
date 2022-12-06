#include <cstddef>
#include <cuda.h>
#include <stdio.h>

using std::size_t;

// // this is without shared memory version
// __global__ void stencil_kernel(const float *image, const float *mask,
//                                float *output, unsigned int n, unsigned int R)
//                                {
//     unsigned int i = blockIdx.x * blockDim.x + threadIdx.x;
//     if (i < n) {
//         float o_i = 0.0;
//         for (unsigned int j = 0; j <= 2 * R; j++) {
//             int idx = i + j - R; // index of image
//             float img_v = (0 <= idx && idx < n) ? image[idx] : 1.0;
//             o_i += img_v * mask[j];
//         }
//         output[i] = o_i;
//     }
// };

__global__ void stencil_kernel(const float *image, const float *mask,
                               float *output, unsigned int n, unsigned int R) {
    // assign the varibles on shared memory
    extern __shared__ float sArray[];
    float *sMask = (float *)&sArray;
    float *spImage = (float *)&sMask[2 * R + 1];
    float *spOutput = (float *)&spImage[blockDim.x + 2 * R];

    // determine the index in global memory and shared memory
    int gIndex = blockIdx.x * blockDim.x + threadIdx.x;
    int sIndex = threadIdx.x;

    // copy mask from global memory to shared memory
    if (sIndex < 2 * R + 1) {
        sMask[sIndex] = mask[sIndex];
    }
    // copy the image main part
    spImage[R + sIndex] = (gIndex < n) ? image[gIndex] : 1.0;

    // copy the padding part of the original image (each length R for two sides)
    if (sIndex < R) {
        // the corrsponding in-duty left index and right index on the original
        // image (to global image index)
        int imgLIndex = gIndex - R, imgRIndex = gIndex + blockDim.x;
        spImage[sIndex] = imgLIndex < 0 ? 1.0 : image[imgLIndex];
        spImage[R + blockDim.x + sIndex] =
            imgRIndex >= n ? 1.0 : image[imgRIndex];
    }
    // else if (R <= sIndex && sIndex < 2 * R) {
    //     // sIndex are from [R, 2R), imgIndex are from [x + 1, x + R],
    //     // where x is the last thread index of
    //     // this block {x + 1 = (blockIdx.x + 1) * blockDim.x}
    //     int imgIndex = (blockIdx.x + 1) * blockDim.x + sIndex - R;
    //     spImage[blockDim.x + R + sIndex] =
    //         (imgIndex) >= n ? 1.0 : image[imgIndex];
    // }
    // spOutput[sIndex] = 0.0;
    __syncthreads();

    // only when it is in scope
    if (gIndex < n) {
        float o_i = 0.0;
        for (size_t j = 0; j <= 2 * R; j++) {
            o_i += spImage[j + sIndex] * sMask[j];
        }
        spOutput[sIndex] = o_i;
        output[gIndex] = spOutput[sIndex];
    }
};

__host__ void stencil(const float *image, const float *mask, float *output,
                      unsigned int n, unsigned int R,
                      unsigned int threads_per_block) {
    // launch kernel function
    const int numBlocks = (n + threads_per_block - 1) / threads_per_block;
    stencil_kernel<<<numBlocks, threads_per_block,
                     (2 * threads_per_block + 4 * R + 1) * sizeof(float)>>>(
        image, mask, output, n, R);
    cudaDeviceSynchronize();
};