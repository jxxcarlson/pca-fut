-- ==
-- random input { [10][10]f32 [10][10]f32 }
-- random input { [100][100]f32 [100][100]f32 }
-- random input { [200][200]f32 [200][200]f32 }
-- random input { [400][400]f32 [400][400]f32 }
-- random input { [800][800]f32 [800][800]f32 }

let matmul [n][m][p] (x: [n][m]f32) (y: [m][p]f32): [n][p]f32 =
map (\xr -> map (\yc -> reduce (+) 0 (map2 (*) xr yc))
                (transpose y)) x

let main = matmul
