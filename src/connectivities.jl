# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    Connectivity(P, list)

A connectivity `list` for the vertices of a polytope
with type `P`. Indices are taken from a global vector
of [`Point`](@ref) items.

## Example

```julia
# points 1, 2 and 3 make up a triangle
points = [Point(0,0), Point(1,0), Point(0,1), ...]
Δ = Connectivity(Triangle, (1,2,3))
```
"""
struct Connectivity{N,P<:Polytope}
    list::NTuple{N,Int}
end

connect(list::NTuple{N,Int}, P::Type{<:Polytope}) where {N} = Connectivity{N,P}(list)
