# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    laplacematrix(mesh, weights=:uniform)

The Laplace-Beltrami (a.k.a. Laplacian) matrix of the `mesh`.
Optionally specify the discretization `weights` as either
`:uniform` or `:cotangent`.

## References

* Vallet, B & Lévy, B. 2008. [Spectral Geometry Processing with Manifold
  Harmonics](https://onlinelibrary.wiley.com/doi/10.1111/j.1467-8659.2008.01122.x)

* Zhang et al. 2007. [Spectral Methods for Mesh Processing and Analysis]
  (https://diglib.eg.org/handle/10.2312/egst.20071052.001-022)
"""
function laplacematrix(mesh, weights=:uniform)
  t = topology(mesh)
  𝒩 = Adjacency{0}(t)
  n = nvertices(t)
  L = spzeros(n, n)
  if weights == :uniform
    for i in 1:n
      js = 𝒩(i)
      for j in js
        L[i,j] = 1.0
      end
      L[i,i] = -sum(L[i,:])
    end
  elseif weights == :cotangent
    v = vertices(mesh)
    for i in 1:n
      js = CircularVector(𝒩(i))
      for k in 1:length(js)
        j₋, j, j₊ = js[k-1], js[k], js[k+1]
        vᵢ, vⱼ =  v[i],  v[j]
        v₋, v₊ = v[j₋], v[j₊]
        αᵢⱼ = ∠(vⱼ, v₋, vᵢ)
        βᵢⱼ = ∠(vᵢ, v₊, vⱼ)
        L[i,j] = cot(αᵢⱼ) + cot(βᵢⱼ)
      end
      L[i,i] = -sum(L[i,:])
    end
  else
    throw(ArgumentError("invalid discretization weights"))
  end
  L
end
