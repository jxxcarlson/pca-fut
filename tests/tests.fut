import "../src/pca"

entry inv_test [n] (a: [n][n]f32) : [n][n]f32 =
  let b = pca.inv a
  in pca.matmul a b

-- | Make an orthonormal matrix $b$ given a nonsingular matrix $a$.
-- Then compute the product of b and its transpose.  It should be
-- the idenitty
entry otest [n] (a :[n][n]f32) : [n][n]f32 =
    let
      b = pca.orthonormalize_matrix a
    in
      pca.matmul b (transpose b)


-- Matrix inversion: verify that $a a^{-1} = 1$
-- ==
-- entry: inv_test
-- input { [[1.0f32, 1.0], [0.0, 1.0]]  }
-- output { [[1.0f32,0.0], [0.0,1.0]]  }
-- random input { [2][2]f32 }
-- output { [[1.0f32,0.0], [0.0,1.0]]  }
-- random input { [3][3]f32 }
-- output { [[1.0f32,0.0, 0.0], [0.0, 1.0, 0.0], [0.0,0.0,1.0]]  }


-- Test the orthonormalization process
-- ==
-- entry otest
-- random input { [3][3]f32 }
-- output { [[1.0f32,0.0, 0.0], [0.0, 1.0, 0.0], [0.0,0.0,1.0]]  }
