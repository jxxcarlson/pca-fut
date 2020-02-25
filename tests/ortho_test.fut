
import "../src/pca"

let otest [n] (a :[n][n]f32) : bool =
  let
    b = pca.orthonormalize_matrix a
    approx_identity = pca.matmul b (transpose b)
    distance = pca.distance approx_identity (identity_matrix n)
  in
    (distance < 0.000001)

-- Orthogonalization test
-- ==
-- entry: otest
-- random input { [2][2]f32 }
-- output { true  }
-- random input { [3][3]f32 }
-- output { true }
-- input { [[1.0f32, 1.0], [0.0, 1.0]]  }
-- output { true }
