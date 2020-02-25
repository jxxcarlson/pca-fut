
import "../src/pca"

-- Here's the idea behind this test.  First, construct
-- a diagonal matrix with entries 0, 1, ... n

let eigentest_ [n] (iterations : i32) (tolerance : f32) (a :[n][n]f32) : f32 =
  let b = pca.orthonormalize a
  let eigenvalues = iota n |> map f32.i32 |> map (\x -> x * x)
  let diagonal_matrix = pca.diagonal_matrix n eigenvalues
  let symmetric_matrix = (pca.matmul (pca.matmul (transpose b) diagonal_matrix) b)
  let u = pca.unit_vector 1 n
  let eigenvector = (pca.dominant_eigenvector iterations tolerance symmetric_matrix u).1
  in
    pca.eigenvalue symmetric_matrix eigenvector


let eigentest [n] (iterations : i32) (tolerance : f32)  (a :[n][n]f32) : bool =
  let n_ = f32.i32 (n - 1)
  let expected_eigenvalue = n_ * n_
  let computed_eigenvalue = eigentest_ iterations tolerance a
  let difference = expected_eigenvalue - computed_eigenvalue |> f32.abs
  in
    difference < 0.1 -- (f32.sqrt tolerance)/10.0

entry test a = eigentest 10 0.00000001 a

-- Dominant eigenvector test
-- ==
-- entry: test
-- random input { [2][2]f32 }
-- output { true  }
-- random input { [3][3]f32 }
-- output { true }
-- random input { [5][5]f32 }
-- output { true }
-- random input { [6][6]f32 }
-- output { true }
