# PCA.fut

![Futhark (Runes)](./no-y-rune-hafstad.jpg)

The eventual aim of this package is to provide functions for Principal Component Analysis (PCA) using Futhark.  We quote from [futhark-lang.org](https://futhark-lang.org/):

> Futhark is a small programming language designed to be compiled to efficient parallel code. It is a statically typed, data-parallel, and purely functional array language in the ML family, and comes with a heavily optimising ahead-of-time compiler that presently generates GPU code via CUDA and OpenCL, although the language itself is hardware-agnostic and can also run on multicore CPUs. As a simple example, this function computes the average of an array of 64-bit floating-point numbers:
```
    let average (xs: []f64) = reduce (+) 0.0 xs / r64 (length xs)
```

The present package is very much a work-in-progress. It contains a plethora of basic linear algebra operations, the most interesing of which are as for PCA analysis:

1. `dominant_eigenvector 10 0.0000000001 s seed`: compute an approximate dominant eigenvector and eigenvalue of a symmetric matrix `s` using the given `seed` vector; do this in at most 10 iterations, but stop before if the cosine of the angle between successive approximations is greater than 1 - tolerance.

2. `dominant_eigenvector 10 0.0000000001 a seed subspace`: as above, but under the constraint that the the dominant eigenvector be orthogonal to a given subspace (presaented as the row space of a matrix)  With this function one can compute other eigenvectors. For example, to compute the subdomnant eigenvector, let the subspace be that spanned by the dominant eigenvector.

3. `pca.principal_component 10 0.0000000001 data`: compute the principal component of the given data.  For the moment, this function uses a very poorly chosen seed vector.  This flaw will be addressed shortly.  The first two argments are as in 1, 2 atove.

More detail on the use of these and other functions is presented as comments in the source code.  Meanhile, bleow  a short comlete example.  It uses the Futhark repl.  We will add notes on running the code on both the CPU and the GPU later this week.

(For some experiments integrating Futhark computations with an Elm UI, see [this repo](https://github.com/jxxcarlson/heat-futhark))

## Example: compute principal component from data/


```
$ futhark.repl
> :load pca.fut

> let data = [[1, -1], [0, 1], [-1, 0]]:[3][2]f32

> pca.principal_component 10 0.0000000001 data
  (3.0000005f32, [-0.7070709f32, 0.7071428f32])

```
