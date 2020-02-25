import "pca"

let eigentest_ [n] (iterations : i32) (tolerance : f32) (a :[n][n]f32) : f32 =
  let b = pca.orthonormalize a
  let eigenvalues = iota n |> map f32.i32
  let diagonal_matrix = pca.diagonal_matrix n eigenvalues
  let symmetric_matrix = (pca.matmul (pca.matmul (transpose b) diagonal_matrix) b)
  let u = pca.unit_vector 1 n
  let eigenvector = (pca.dominant_eigenvector iterations tolerance symmetric_matrix u).1
  in
    pca.eigenvalue symmetric_matrix eigenvector

  let eigentest_2 [n] (iterations : i32) (tolerance : f32) (a :[n][n]f32) : f32 =
    let b = pca.orthonormalize a
    let eigenvalues = iota n |> map f32.i32 |> map (\x -> x * x)
    let diagonal_matrix = pca.diagonal_matrix n eigenvalues
    let symmetric_matrix = (pca.matmul (pca.matmul (transpose b) diagonal_matrix) b)
    let u = pca.unit_vector 1 n
    let eigenvector = (pca.dominant_eigenvector iterations tolerance symmetric_matrix u).1
    in
      pca.eigenvalue symmetric_matrix eigenvector

let eigentest [n] (iterations : i32) (tolerance : f32)  (a :[n][n]f32) : bool =
  let expected_eigenvalue =  f32.i32 (n - 1)
  let computed_eigenvalue = eigentest_ iterations tolerance a
  let difference = expected_eigenvalue - computed_eigenvalue |> f32.abs
  in
    difference < (f32.sqrt tolerance)



let ut = [[1f32, 1], [0, 1]]
let ut2 = [[2f32, 1.0], [0, 3]]
let ut2b = [[2f32, 0.1], [0, 3]]
let s2 = [[2f32, -1], [-1, 2]]

let three = [[1.0f32, 0.44, -0.02], [2.1, 0.2, -0.79], [0.1, 0.4, 0.8]]

let four = pca.kronecker s2 s2

let sixteen = pca.kronecker four four

let six = pca.kronecker ut2 three
