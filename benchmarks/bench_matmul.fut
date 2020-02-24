-- ==
-- random input { [10][10]f32 [10][10]f32 }
-- random input { [100][100]f32 [100][100]f32 }
-- random input { [200][200]f32 [200][200]f32 }
-- random input { [400][400]f32 [400][400]f32 }

let dotprod xs ys = map2 (*) xs ys |> f32.sum

let matmul xss yss = map (\xs -> map (\ys -> dotprod xs ys) (transpose yss)) xss

let main = matmul
