# Benchmarks for Matrix Multiplication

Comparison of matrix multiplication Benchmarks
for the C and Futhark backends. The Benchmarks
were run on a Macbook Pro.

```
 Model Identifier:	MacBookPro13,2
 Processor Name:	Dual-Core Intel Core i7
 Processor Speed:	3.3 GHz
 Total Number of Cores:	2
 L2 Cache (per Core):	256 KB
 L3 Cache:	4 MB
 Memory:	16 GB
 GPU: Intel Iris Graphics 550 1536 MB
 ```

## Compiled to C

```
$ npm run bench-cpu

> pca@1.0.0 bench /Users/carlson/dev/futhark/pca
> futhark bench-cpu benchmarks/bench_matmul.fut

Compiling benchmarks/bench_matmul.fut...
Results for benchmarks/bench_matmul.fut:
dataset [10][10]f32 [10][10]f32:           1.10μs (avg. of 10 runs; RSD: 0.27)
dataset [100][100]f32 [100][100]f32:    1283.90μs (avg. of 10 runs; RSD: 0.16)
dataset [200][200]f32 [200][200]f32:   12712.20μs (avg. of 10 runs; RSD: 0.16)
dataset [400][400]f32 [400][400]f32:   73264.50μs (avg. of 10 runs; RSD: 0.03)
```

## Compiled to OpenCL

```
$ npm run bench-gpu

> pca@1.0.0 bench-gpu /Users/carlson/dev/futhark/pca
> futhark bench --backend opencl benchmarks/bench_matmul.fut

Compiling benchmarks/bench_matmul.fut...
Results for benchmarks/bench_matmul.fut:
dataset [10][10]f32 [10][10]f32:         437.10μs (avg. of 10 runs; RSD: 0.22)
dataset [100][100]f32 [100][100]f32:     434.90μs (avg. of 10 runs; RSD: 0.55)
dataset [200][200]f32 [200][200]f32:     939.00μs (avg. of 10 runs; RSD: 0.05)
dataset [400][400]f32 [400][400]f32:    4744.10μs (avg. of 10 runs; RSD: 0.03)
```
