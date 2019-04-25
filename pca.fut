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

module pca = {

  let scalar_mul [n] (s: f32) (xs: [n]f32): [n]f32 = (map (\(x: f32) -> s*x) xs)

  let dotprod [n] (xs: [n]f32) (ys: [n]f32): f32 =
    (reduce (+) (0:f32) (map2 (*) xs ys))

  let vecadd [n] (xs: [n]f32) (ys: [n]f32) : [n]f32 = (map2 (+) xs ys)

  let vecsub [n] (xs: [n]f32) (ys: [n]f32) : [n]f32 = (map2 (-) xs ys)

  let orthogonalize [n] (xs: [n]f32) (ys: [n]f32): [n]f32 =
    let a = (dotprod xs ys)
    let b = (dotprod ys ys)
    let c = (a/b)
    let ys2 = scalar_mul c ys
    in
      (vecsub xs ys2)

  let norm_squared [n] (xs: [n]f32): f32 = (dotprod xs xs)

  let norm [n] (xs: [n]f32): f32 =
     f32.sqrt (norm_squared xs)

  let normalize [n] (xs: [n]f32): [n]f32 =
    scalar_mul (1/(norm xs)) xs

  let cross (xs: [3]f32) (ys: [3]f32): [3]f32 =
    ([xs[1]*ys[2]-xs[2]*ys[1],
        xs[2]*ys[0]-xs[0]*ys[2],
        xs[0]*ys[1]-xs[1]*ys[0]])

  let matmul [n][p][m] (xss: [n][p]f32) (yss: [p][m]f32): [n][m]f32 =
    map (\xs -> map (dotprod xs) (transpose yss)) xss

  let outer [n][m] (xs: [n]f32) (ys: [m]f32): [n][m]f32 =
    matmul (map (\x -> [x]) xs) [ys]

  let matvecmul [n][m] (xss: [n][m]f32) (ys: [m]f32) =
    map (dotprod ys) xss

  let matvecmul_weird [n][m] (xss: [n][m]f32) (ys: [n]f32) =
    matmul xss (replicate m ys)

  let kronecker' [m][n][p][q] (xss: [m][n]f32) (yss: [p][q]f32): [m][n][p][q]f32 =
    map (map (\x -> map (map (*x)) yss)) xss

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

  let dominant_eigenvector [n] (iterations: i32) (a: [n][n]f32) (v: [n]f32): [n]f32 =
     loop eigenvector = v for i < iterations do step a eigenvector

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

  let principal_component [m][n] (iterations: i32) (data: [m][n]f32): (f32, [n]f32) =
    let covariance_matrix = standard_covariance data
    let seed = map (\i -> (f32.i32 i)) (iota n)
    let dominant_eigenvector_ = dominant_eigenvector iterations covariance_matrix seed
    let dominant_eigenvlue_ = eigenvalue covariance_matrix dominant_eigenvector_
    in (dominant_eigenvlue_, dominant_eigenvector_)



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
