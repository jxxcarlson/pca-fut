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


## Analysis


### Speedup

The third column is (CPU time)/(GPU time).

```
     CPU      GPU   Speedup
    1173      348      32.1
   13225      921      14.4
   89079     5026      17.7
  647708    26640      24.3
12832922   151519      84.7
```

### Scaling, CPU

Table of the rato:

```
       execution time for an input of size 2n
r =    --------------------------------------
       execution time for an input of size n
```

Straight, naive complexity theory for matrix
multiplication says that r should be
8 = cube of 2.

to
```
CPU        Ratio
1173         -
13225       11.3
89079        6.7
647708      72.4
12832922    19.8
```

### Scaling, GPU

The same computations for the GPU.

```
   GPU     Ratio
   348       -
   921      2.7
  5026      5.5
  6640      5.3
151519      5.7
```
