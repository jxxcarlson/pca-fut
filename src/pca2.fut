-- | The code in Troels Henriksen's linalg.fut
-- lbrary was the starting point for this module.
--
-- At the moment the package has only one significant
-- product, the function principal_component, which
-- computes an approximation to the dominant eigenvalue
-- and eignevalue of of the covariance matrix using
-- the power method.  That method still needs work.
-- It needs a random seed and a convergence test.
--
-- See the README for examples

-- The "tests" in the comments below were run like this;
-- $ futhark repl
-- $ pca.scalar_mul 2 [1, -3]
-- [2.0f32, -6.0f32]

module pca = {

  -- zero_matrix 2 3
  -- --> [[0.0f32, 0.0f32, 0.0f32], [0.0f32, 0.0f32, 0.0f32]]
  let zero_matrix (m:i32) (n:i32) : [m][n]f32 =
    replicate m (replicate n 0f32)


  let kronecker_delta (i:i32) (j:i32) : f32 = if i == j then 1 else 0

  let kd = kronecker_delta

  let index_matrix (m:i32) (n:i32) : [m][n]i32 =
    replicate m (iota n)

  --  pca.identity_matrix 2
  --> [[1.0f32, 0.0f32], [0.0f32, 1.0f32]]
  let identity_matrix (m:i32) : [m][m]f32 =
    let
     indices = zip (iota m) (index_matrix m m)
    in
    map (\pair -> (map (kd pair.0) pair.1)) indices

  let diag_element (d: f32) (i: i32) (j: i32)  : f32 =
    if i == j then d else 0f32

  -- let dd = [1.3f32, 7.1]
  -- pca.diagonal_matrix 2 dd
  --> [[1.3f32, 0.0f32], [0.0f32, 7.1f32]]
  let diagonal_matrix (m:i32) (diag: [m]f32) : [m][m]f32 =
  let
   indices = zip (iota m) (index_matrix m m)
  in
  map (\pair -> (map (diag_element diag[pair.0] pair.0) pair.1)) indices

  -- pca.scalar_mul 2 [1, -3]
  -- --> [2.0f32, -6.0f32]
  let scalar_mul [n] (s: f32) (xs: [n]f32): [n]f32 = (map (\(x: f32) -> s*x) xs)


  -- pca.dotprod [1, 2] [-2, 1]
  -- --> 0.0f32
  let dotprod [n] (xs: [n]f32) (ys: [n]f32): f32 =
    (reduce (+) (0:f32) (map2 (*) xs ys))

  -- pca.vecadd [2, 3] [-2, -3]
  -- --> [0.0f32, 0.0f32]
  let vecadd [n] (xs: [n]f32) (ys: [n]f32) : [n]f32 = (map2 (+) xs ys)

  -- pca.vecsub [1, 4] [1, 4]
  -- -> [0.0f32, 0.0f32]
  let vecsub [n] (xs: [n]f32) (ys: [n]f32) : [n]f32 = (map2 (-) xs ys)

  let matrixsub [m][n] (a: [m][n]f32) (b: [m][n]f32) : [m][n]f32 =
    map2 vecsub a b

  let matrixadd [m][n] (a: [m][n]f32) (b: [m][n]f32) : [m][n]f32 =
    map2 vecadd a b

  let absolute_sum [m] (a: [m]f32) : f32 =
    reduce (\s x -> s + (f32.abs x))  0 a

  let l1_norm [m][n] (a: [m][n]f32) : f32 =
    absolute_sum (map absolute_sum a)

  let distance [m][n] (a: [m][n]f32) (b: [m][n]f32) : f32 =
    l1_norm (matrixsub a b)

  -- pca.norm_squared [1, 1]
  -- --> 2.0f32
  let norm_squared [n] (xs: [n]f32): f32 = (dotprod xs xs)

  -- pca.norm [1, 1]
  -- --> 1.4142135f32
  let norm [n] (xs: [n]f32): f32 =
     f32.sqrt (norm_squared xs)

  -- pca.normalize [1, 1]
  -- --> [0.70710677f32, 0.70710677f32]
  let normalize [n] (xs: [n]f32): [n]f32 =
    scalar_mul (1/(norm xs)) xs

  -- pca.normalize_rows [[1, 1], [1, -1]]
  -- --> [[0.70710677f32, 0.70710677f32], [0.70710677f32, -0.70710677f32]]
  let normalize_rows [m][n] (a: [m][n]f32): [m][n]f32 =
      map (\row -> normalize row) a

  -- | orthogonal_projection v a = orthogonal projection of v onto a
  let orthogonal_projection [n] (v: [n]f32) (a: [n]f32): [n]f32 =
     let c = (dotprod v a) / (dotprod a a)
     in scalar_mul c a

  -- pca.orthogonal_projection [1, 1] [1, 0]
  -- --> [1.0f32, 0.0f32]
  let zero_vector (n: i32): [n]f32 =
     map (\_ -> (f32.i32 0)) (iota n)

  -- pca.row_sum [[1,2,3]]
  -- [1.0f32, 2.0f32, 3.0f32]
  --
  -- pca.row_sum [[1,2,3], [3,2,1]]
  --> [4.0f32, 4.0f32, 4.0f32]
  let row_sum [m][n] (a: [m][n]f32): [n]f32 =
      reduce (\u  row -> vecadd row u) (zero_vector n)  a

  -- | orthogoonalize x y = the component of x perpendicular to y
  -- pca.orthogonal_complement [1,1] [1,0]
  --> [0.0f32, 1.0f32]
  let orthogonal_complement [n] (xs: [n]f32) (ys: [n]f32): [n]f32 =
    vecsub xs (orthogonal_projection xs ys)

  -- | Let a be a matrix whose rows are orthogonal.  then
  -- orthogonal_complement_to_row_space v a is perpendicular to the
  -- row space of a
  --
  -- pca.orthogonal_complement_to_row_space [[1, 0, 0], [0, 1, 0]] [1,1,1]
  -- --> [0.0f32, 0.0f32, 1.0f32]
  --
  -- The matrix below has the same row space as the matrix above
  -- pca.orthogonal_complement_to_row_space [[1, -2, 0], [2, 1, 0]] [1,1,1]
  -- --> [0.0f32, 0.0f32, 1.0f32]
  let orthogonal_complement_to_row_space [m][n] (a: [m][n]f32) (v: [n]f32): [n]f32 =
        reduce (\u  row -> vecsub u (orthogonal_projection u row)) v a

  -- let orthogonalize_matrix [m][n] (a: [m][n]f32): [m][n]f32 =
  --    reduce (\mat row -> mat ++ [orthogonal_complement_to_row_space row mat]) [a[0]] a[1:m:1]

  let orthogonal_complement_to_row_space_aux  [m][n] (k:i32) (a: [m][n]f32): [m][n]f32 =
    let newRow = orthogonal_complement_to_row_space a[0:k:1] a[k]
    in a[0:k:1] ++ [newRow] ++ a[k+1:m:1]

  -- pca.orthogonalize_matrix [[1, 1], [0, 1]]
  -- --> [[1.0f32, 1.0f32], [-0.5f32, 0.5f32]]
  let orthogonalize_matrix [m][n] (a: [m][n]f32): [m][n]f32 =
     loop output = a for i in 1...(m-1)  do orthogonal_complement_to_row_space_aux i output

  -- pca.orthonormalize_matrix [[1, 1], [0, 1]]
  -- --> [[0.70710677f32, 0.70710677f32], [-0.70710677f32, 0.70710677f32]]
  let orthonormalize_matrix [m][n] (a: [m][n]f32): [m][n]f32 =
    orthogonalize_matrix a |> map normalize



  -- pca.cross [1, 0, 0] [0, 1, 0]
  -- --> [0.0f32, 0.0f32, 1.0f32]
  let cross (xs: [3]f32) (ys: [3]f32): [3]f32 =
    ([xs[1]*ys[2]-xs[2]*ys[1],
        xs[2]*ys[0]-xs[0]*ys[2],
        xs[0]*ys[1]-xs[1]*ys[0]])

  -- pca.matmul  [[1, 1], [0, 1]] [[1, 2], [0, 1]]
  -- --> [[1.0f32, 3.0f32], [0.0f32, 1.0f32]]
  let matmul [n][p][m] (xss: [n][p]f32) (yss: [p][m]f32): [n][m]f32 =
    map (\xs -> map (dotprod xs) (transpose yss)) xss

  let matmul2 [n][m][p] (x: [n][m]i32) (y: [m][p]i32): [n][p]i32 =
  map (\xr -> map (\yc -> reduce (+) 0 (map2 (*) xr yc))
                  (transpose y)) x

  -- pca.outer [2, 1] [3, 5]
  -- --> [[6.0f32, 10.0f32], [3.0f32, 5.0f32]]
  let outer [n][m] (xs: [n]f32) (ys: [m]f32): [n][m]f32 =
    matmul (map (\x -> [x]) xs) [ys]

  -- pca.matvecmul [[2, -1], [-1, 2]] [1, 0]
  -- --> [2.0f32, -1.0f32]
  let matvecmul [n][m] (xss: [n][m]f32) (ys: [m]f32) =
    map (dotprod ys) xss

  -- incorrect resul
  let matvecmul_weird [n][m] (xss: [n][m]f32) (ys: [n]f32) =
    matmul xss (replicate m ys)

  let kronecker' [m][n][p][q] (xss: [m][n]f32) (yss: [p][q]f32): [m][n][p][q]f32 =
    map (map (\x -> map (map (*x)) yss)) xss

  -- pca.kronecker [[1, 2], [0, 3]] [[2, -1], [-1, 2]]
  -- --> [[2.0f32, -1.0f32, 4.0f32, -2.0f32],
  -- --> [-1.0f32, 2.0f32, -2.0f32, 4.0f32],
  -- --> [0.0f32, -0.0f32, 6.0f32, -3.0f32],
  -- --> [-0.0f32, 0.0f32, -3.0f32, 6.0f32]]
  let kronecker [m][n][p][q] (xss: [m][n]f32) (yss: [p][q]f32): [][]f32 =
    kronecker' xss yss -- [m][n][p][q]
    |> map transpose   -- [m][p][n][q]
    |> flatten         -- [m*p][n][q]
    |> map flatten     -- [m*p][n*q]

  -- Matrix inversion is implemented with Gauss-Jordan.
  let gauss_jordan [n][m] (A: [n][m]f32): [n][m]f32 =
    loop A for i < n do
      let irow = A[0]
      let Ap = A[1:n]
      let v1 = irow[i]
      in  map (\k -> map (\j -> let x = unsafe( (irow[j] / v1) ) in
                                if k < n-1  -- Ap case
                                then unsafe( (Ap[k,j] - Ap[k,i] * x) )
                                else x      -- irow case
                         ) (iota m)
              ) (iota n)


  -- let a = [[2, -1], [-1, 2]] : [2][2]f32
  -- let b = pca.inv a
  -- pca.matmul a b
  -- --> [[1.0f32, 0.0f32], [0.0f32, 1.0f32]]
  let inv [n] (A: [n][n]f32): [n][n]f32 =
    -- Pad the matrix with the identity matrix.
    let Ap = map2 (\row i ->
                    map (\j -> if j < n then unsafe( row[j] )
                                     else if j == n+i
                                          then 1:f32
                                          else 0:f32
                        ) (iota (2*n))
                  ) A (iota n)
    let Ap' = gauss_jordan Ap
    -- Drop the identity matrix at the front.
    in Ap'[0:n, n:n*2]

  let ols [n][m] (X: [n][m]f32) (b: [n]f32): [m]f32 =
    matvecmul (matmul (inv (matmul (transpose X) X)) (transpose X)) b

  let covariance [m][n] (a: [m][n]f32): [n][n]f32 =
      (matmul (transpose a) a )

  let step [n] (a: [n][n]f32) (v: [n]f32): [n]f32 =
    matvecmul a v |> normalize

  -- | Compute the dominant eigenvector
  -- let s = [[2,-1],[-1,2]]:[2][2]f32
  -- let v = [1,2]:[2]f32
  -- pca.dominant_eigenvector 10 0.0000000001 s v
  -- -->(3.0000005f32, [-0.7070709f32, 0.7071428f32])
  let dominant_eigenvector [n] (max_iterations: i32) (tolerance: f32) (a: [n][n]f32) (v: [n]f32): (f32, [n]f32) =
     let v1 = normalize v
     let v2 = step a v1
     let
       (w2, _, _) = loop (u2, u1, j) = (v2, v1, 0)  while
         (dotprod u1 u2 < 1 - tolerance) || (j > max_iterations) do (step a u2, u2, j+1)
     let lambda = dotprod (matvecmul a w2) w2
     in
       (lambda, w2)

  -- | Compute the dominant eigenvector orthogonal to a given subspace
  --   > let subspace = [[-0.7070709f32, 0.7071428f32]]:[1][2]f32
  --   > pca.dominant_eigenvector2 10 0.0000000001 s v subspace
  --     (1.0000001f32, [0.7071427f32, 0.7070709f32])
  let dominant_eigenvector2 [m][n] (max_iterations: i32) (tolerance: f32) (a: [n][n]f32) (v: [n]f32) (subspace: [m][n]f32): (f32, [n]f32) =
          let v1 = normalize v
          let v2 = step a v1
          let
            (w2, _, _) = loop (u2, u1, j) = (v2, v1, 0)  while
              (dotprod u1 u2 < 1 - tolerance) || (j > max_iterations) do
                let u3 = step a u2 |> orthogonal_complement_to_row_space subspace
                in (u3, u2, j+1)
          let lambda = dotprod (matvecmul a w2) w2
          in
            (lambda, w2)


  let eigenvalue [n] (a: [n][n]f32) (v: [n]f32): f32 =
    dotprod (matvecmul a v) v

  let vector_mean [n] (xs: [n]f32): f32 =
    reduce (+) 0 xs / (f32.i32 n)

  let center_vector [n] (xs: [n]f32): [n]f32 =
     let
       mean = vector_mean xs
     in
       map (\x -> x - mean) xs

  let center_matrix_rows [m][n] (a: [m][n]f32): [m][n]f32 =
     map (\row -> center_vector row) a

  let center_matrix_cols [m][n] (a: [m][n]f32): [m][n]f32 =
     a |> transpose |> center_matrix_rows |> transpose

  let standard_covariance [m][n] (a: [m][n]f32): [n][n]f32 =
    covariance (center_matrix_cols a)

  -- } Compute the principal component for gicen datqa:
  -- > let data = [[1, -1], [0, 1], [-1, 0]]:[3][2]f32
  -- > pca.principal_component 10 0.0000000001 data
  -- (3.0000005f32, [-0.7070709f32, 0.7071428f32])
  let principal_component [m][n] (iterations: i32) (tolerance: f32) (data: [m][n]f32): (f32, [n]f32) =
    let covariance_matrix = standard_covariance data
    let seed = map (\i -> (f32.i32 i)) (iota n)
    in dominant_eigenvector iterations tolerance covariance_matrix seed

  -- | I think the below is incorrect
  let eigenvectors [m] (k: i32) (s: [m][m]f32): [m][m]f32 =
     loop output = s for i < k do matmul s output |> orthonormalize_matrix



 let data =
     [[7, 4, 3], [4, 1, 8], [6, 3, 5],
      [8, 6, 1], [8, 5, 7], [7, 2, 9],
      [5, 3, 3], [9, 5, 8], [7, 4, 5],
      [8, 2, 2]]:[10][3]f32

 let small_data =
   [[1, -1], [0, 1], [-1, 0]]:[3][2]f32
}

-- http://pillowlab.princeton.edu/teaching/mathtools16/slides/lec09_PCA.pdf
-- http://hiperfit.dk/pdf/troels-phd-thesis.pdf
-- http://web.mit.edu/18.06/www/Spring17/Power-Method.pdf
-- https://math.stackexchange.com/questions/768882/power-method-for-finding-all-eigenvectors


-- TESTS


let otest [n] (a :[n][n]f32) : [n][n]f32 =
  let
    b = orthonormalize_matrix a
  in
    matmul b (transpose b)


let inv_test [n] (a: [n][n]f32) : [n][n]f32 =
  let b = inv a
  in matmul a b


  -- TEST Matrices

  let ut = [[1f32, 1], [0, 1]]

  let lt = transpose ut

  let dm = [[2f32, 0], [0, 3]]

  let sm = [[2f32, -1], [-1, 2]]

  let id2 = [[1f32, 0], [0, 1]]

  let z2 = [[0f32, 0], [0, 0]]

  -- TESTS


  let otest [n] (a :[n][n]f32) : [n][n]f32 =
    let
      b = orthonormalize_matrix a
    in
      matmul b (transpose b)


  let inv_test [n] (a: [n][n]f32) : [n][n]f32 =
    let b = inv a
    in matmul a b
