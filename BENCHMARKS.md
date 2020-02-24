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
dataset [10][10]f32 [10][10]f32:               1.00μs (avg. of 10 runs; RSD: 0.00)
dataset [100][100]f32 [100][100]f32:        1173.40μs (avg. of 10 runs; RSD: 0.11)
dataset [200][200]f32 [200][200]f32:       13225.90μs (avg. of 10 runs; RSD: 0.16)
dataset [400][400]f32 [400][400]f32:       89079.20μs (avg. of 10 runs; RSD: 0.03)
dataset [800][800]f32 [800][800]f32:      647708.00μs (avg. of 10 runs; RSD: 0.06)
dataset [1600][1600]f32 [1600][1600]f32: 12832922.40μs (avg. of 10 runs; RSD: 0.04)
```

## Compiled to OpenCL

```
$ npm run bench-gpu

> pca@1.0.0 bench-gpu /Users/carlson/dev/futhark/pca
> futhark bench --backend opencl benchmarks/bench_matmul.fut

Compiling benchmarks/bench_matmul.fut...
Results for benchmarks/bench_matmul.fut:
dataset [10][10]f32 [10][10]f32:             296.10μs (avg. of 10 runs; RSD: 0.24)
dataset [100][100]f32 [100][100]f32:         348.20μs (avg. of 10 runs; RSD: 0.06)
dataset [200][200]f32 [200][200]f32:         921.70μs (avg. of 10 runs; RSD: 0.01)
dataset [400][400]f32 [400][400]f32:        5026.70μs (avg. of 10 runs; RSD: 0.03)
dataset [800][800]f32 [800][800]f32:       26640.50μs (avg. of 10 runs; RSD: 0.16)
dataset [1600][1600]f32 [1600][1600]f32:  151519.50μs (avg. of 10 runs; RSD: 0.04)
```
