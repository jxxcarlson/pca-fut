# PCA.fut

The eventual aim of this package is to provide functions for Principal Component Analysis (PCA).  It is a work-in-progress. In fact, it is barely started work.  For the moment it consists of various auxiliary linear algebra functions, plus one function that computes the first principal component: the dominant eigenvector and eignvalue of the covariance matrix.  Below is an example. The data is the matrix

```
data =
[
  [1, -1],
  [0,  1],
  [-1, 0]
]

```
The covariance matrix is the well-known symmetric matrix
```
C =
[
  [2, -1],
  [-1, 2]
]
```
The dominant eigenvalue is 3, and the dominant eigenvector is `[-0.707, 0.707]`.  Here is the example run in the futhark repl:

```
> :load pca.fut
> let data = pca.small_data
> data
[[1.0f32, -1.0f32], [0.0f32, 1.0f32], [-1.0f32, 0.0f32]]
> pca.principal_component 10 data
(3.0f32, [-0.7070948f32, 0.7071188f32])
```

The first argument of `pca.principal_componenent` is the number of iterations used in the power method.

NOTE: the first order of business is to use a random seed in `pca.principal_component` and to use a convergence test + a maximum number of iterations as the stopping criterion.  Next, we will work on getting the first k eigenvectors.


## Testing with the repl


### Scalar and Dot product
```
$ futhark repl
> :load linalg.fut
Loading linalg.fut

> module lin = mk_linalg f32

> let a = [1,2,3]:[3]f32
> lin.scalar_mul 2.0 a
[2.0f32, 4.0f32, 6.0f32]

> let b = [1,0,-1]:[3]f32
> lin.dotprod a b
-2.0f32
```
### Orthogonalize

```
> lin.orthogonalize a b
[0.3333333f32, -0.6666667f32, 0.3333333f32]
```
Thus `c = lin.orthogonalize a b` is perpendicular to `b`

### Matrix multiplication

```
> let m = [[1,1,0],[0,1,1],[0,0,1]]:[3][3]f32
> lin.matmul m m
[[1.0f32, 2.0f32, 1.0f32], [0.0f32, 1.0f32, 2.0f32], [0.0f32, 0.0f32, 1.0f32]]
```

### Matrix inverse

```
> lin.inv m
[[1.0f32, -1.0f32, 1.0f32], [0.0f32, 1.0f32, -1.0f32], [0.0f32, 0.0f32, 1.0f32]]
```

### Covariance matrix

```
> let u = [[1,1,0],[0,1,1]]:[2][3]f32
> lin.covariance u
[[2.0f32, 1.0f32], [1.0f32, 2.0f32]]
```

### Dominant eigenvector

```
let s = [[2, -1, 0], [-1, 2, -1], [0, -1, 2]]:[3][3]f32
let v = [1,1,1]:[3]f32

> let ev = lin.dominant_eigenvector 10 s v
> ev
[0.50000006f32, -0.70710665f32, 0.50000006f32]

> lin.eigenvalue s ev
3.4142134f32

> let w = [1,2,3]:[3]f32
> lin.center_vector w
[-1.0f32, 0.0f32, 1.0f32]
```
