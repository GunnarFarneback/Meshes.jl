# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    pointify(object)

Convert `object` into a vector of [`Point`](@ref).
"""
function pointify end

pointify(p::Point) = [p]

pointify(s::Sphere) = pointify(discretize(s))

pointify(t::Torus) = pointify(discretize(t))

pointify(p::Primitive) = pointify(boundary(p))

pointify(p::Polytope) = collect(vertices(p))

pointify(p::PolyArea) = vertices(p)

pointify(r::Ring) = vertices(r)

pointify(r::Rope) = vertices(r)

pointify(m::Multi) = pointify(collect(m))

pointify(p::PointSet) = collect(p)

pointify(m::Mesh) = vertices(m)

pointify(geoms) = mapreduce(pointify, vcat, geoms)
