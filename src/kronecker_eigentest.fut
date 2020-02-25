import "pca"

-- Test of the computation of the dominant eigenvalue
-- Example: the code below runs the power method 10
-- times on the matrix s10, whose dominant eigenvalue is 729
--
-- de 10 s10
-- 242.99998f32
--
-- The matrix s2 is a standard 2x2 symmetric matrix with dominant
-- eigenvalue 3.  The matrices s2n are repeated tensor products of s2

let s2 = [[2f32, -1], [-1, 2]]
let s4 = pca.kronecker s2 s2
let s6 = pca.kronecker s2 s4
let s8 = pca.kronecker s2 s6
let s10 = pca.kronecker s2 s8
let s20 = pca.kronecker s2 s10
let s40 = pca.kronecker s4 s10
let s60 = pca.kronecker s6 s10
let s80 = pca.kronecker s8 s10
let s100 = pca.kronecker s10 s10

let k2 = (3f32, s2)
let k4 = (9f32, s4)
let k6 = (27f32, s6)
let k8 = (81f32, s8)
let k10 = (243f32, s10)
let k20 = (729f32, s20)
let k40 = (2187f32, s40)
let k60 = (6561f32, s60)
let k80 = (19683f32, s80)
let k100 = (59049f32, s100)


-- let de (n :i32) (a :[n][n]f32) : (f32, [n]f32) =
--   pca.dominant_eigenvector 10 0.000001 a (pca.unit_vector 0 n)

-- de 10 s8
-- 81.0f32
--
-- de 10 s10
-- 242.99998f32
--
-- de 10 s20
-- 729.0f32
--
-- de 10 s40
-- 2187.002f32
--
-- de 10 s60
-- 6560.999f32
--
-- de 10 s80
-- 19682.998f32
--
-- de 10 s100
-- 59048.887f32
let de [n] (iterations: i32) (a :[n][n]f32) : f32 =
    (pca.dominant_eigenvector iterations 0.000001 a (pca.unit_vector 0 n)).0

let et [n] (iterations: i32) (a : [n][n]f32) (expected_eigenvalue : f32) : f32 =
   let
     computed_eigenvalue = (pca.dominant_eigenvector iterations 0.000001 a (pca.unit_vector 0 n)).0
   in
   f32.abs(computed_eigenvalue - expected_eigenvalue)


-- kt 10 k4
-- --> 1.9073486e-6f32
let kt [n] (iterations: i32) (data: (f32, [n][n]f32)) : f32 =
  let expected_eigenvalue = data.0
  let matrix = data.1
  in et iterations matrix expected_eigenvalue
