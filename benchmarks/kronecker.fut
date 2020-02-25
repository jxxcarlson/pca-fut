import "../src/kronecker_eigentest"

-- ==
-- random input { [10][10]f32 [10][10]f32 }
-- random input { [100][100]f32 [100][100]f32 }
-- random input { [200][200]f32 [200][200]f32 }
-- random input { [400][400]f32 [400][400]f32 }
-- random input { [800][800]f32 [800][800]f32 }
-- random input { [1600][1600]f32 [1600][1600]f32 }
-- random input { [3200][3200]f32 [3200][3200]f32 }
-- random input { [6400][6400]f32 [6400][6400]f32 }
-- random input { [12800][12800]f32 [12800][12800]f32 }


let test a = de 10 a

let main = test


-- $ futhark bench benchmarks/kronecker.fut
-- Results for benchmarks/kronecker.fut:
-- dataset [10][10]f32 [10][10]f32:                   2.20μs (avg. of 10 runs; RSD: 0.18)
-- dataset [100][100]f32 [100][100]f32:              55.30μs (avg. of 10 runs; RSD: 0.15)
-- dataset [200][200]f32 [200][200]f32:             228.50μs (avg. of 10 runs; RSD: 0.17)
-- dataset [400][400]f32 [400][400]f32:            1700.00μs (avg. of 10 runs; RSD: 0.46)
-- dataset [800][800]f32 [800][800]f32:            2934.00μs (avg. of 10 runs; RSD: 0.02)
-- dataset [1600][1600]f32 [1600][1600]f32:       10932.30μs (avg. of 10 runs; RSD: 0.06)
-- dataset [3200][3200]f32 [3200][3200]f32:       58445.00μs (avg. of 10 runs; RSD: 0.08)
-- dataset [6400][6400]f32 [6400][6400]f32:      163870.20μs (avg. of 10 runs; RSD: 0.04)

-- futhark bench --backend opencl benchmarks/kronecker.fut
-- Results for benchmarks/kronecker.fut:
-- dataset [10][10]f32 [10][10]f32:                2122.40μs (avg. of 10 runs; RSD: 0.16)
-- dataset [100][100]f32 [100][100]f32:            2622.10μs (avg. of 10 runs; RSD: 0.13)
-- dataset [200][200]f32 [200][200]f32:            2722.60μs (avg. of 10 runs; RSD: 0.08)
-- dataset [400][400]f32 [400][400]f32:            3619.30μs (avg. of 10 runs; RSD: 0.15)
-- dataset [800][800]f32 [800][800]f32:            4692.00μs (avg. of 10 runs; RSD: 0.07)
-- dataset [1600][1600]f32 [1600][1600]f32:        7891.70μs (avg. of 10 runs; RSD: 0.01)
-- dataset [3200][3200]f32 [3200][3200]f32:       16318.40μs (avg. of 10 runs; RSD: 0.17)
-- dataset [6400][6400]f32 [6400][6400]f32:       57560.70μs (avg. of 10 runs; RSD: 0.10)
-- dataset [12800][12800]f32 [12800][12800]f32:  161477.60μs (avg. of 10 runs; RSD: 0.02)
