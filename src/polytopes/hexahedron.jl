# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    Hexahedron(p1, p2, ..., p8)

A hexahedron with points `p1`, `p2`, ..., `p8`.
"""
struct Hexahedron{Dim,T,V<:AbstractVector{Point{Dim,T}}} <: Polyhedron{Dim,T}
  vertices::V
end

nvertices(::Type{<:Hexahedron}) = 8
nvertices(h::Hexahedron) = nvertices(typeof(h))

function (h::Hexahedron)(u, v, w)
  A1, A2, A4, A3,
  A5, A6, A8, A7 = coordinates.(h.vertices)
  Point((1-u)*(1-v)*(1-w)*A1 +
            u*(1-v)*(1-w)*A2 +
            (1-u)*v*(1-w)*A3 +
                u*v*(1-w)*A4 +
            (1-u)*(1-v)*w*A5 +
                u*(1-v)*w*A6 +
                (1-u)*v*w*A7 +
                    u*v*w*A8)
end
