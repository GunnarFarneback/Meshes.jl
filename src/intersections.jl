# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    g1 ∩ g2

Return the intersection of two geometries `g1` and `g2`.
"""
Base.intersect(g1::Geometry, g2::Geometry) = get(intersecttype(g1, g2))

"""
    intersecttype(g1, g2)

Return the intersection type of two geometries `g1` and `g2`.
"""
function intersecttype end

"""
    Intersection

An intersection type (e.g. crossing line segments, overlapping boxes).
"""
abstract type Intersection end

Base.get(I::Intersection) = I.value

struct NoIntersection <: Intersection end

Base.get(::NoIntersection) = nothing

# ------------------------
# LINE-LINE INTERSECTIONS
# ------------------------

struct CrossingLines{P<:Point} <: Intersection
  value::P
end

struct OverlappingLines{L<:Line} <: Intersection
  value::L
end

# ------------------------------
# SEGMENT-SEGMENT INTERSECTIONS
# ------------------------------

struct CrossingSegments{P<:Point} <: Intersection
  value::P
end

struct MidTouchingSegments{P<:Point} <: Intersection
  value::P
end

struct CornerTouchingSegments{P<:Point} <: Intersection
  value::P
end

struct OverlappingSegments{S<:Segment} <: Intersection
  value::S
end

# ----------------------
# BOX-BOX INTERSECTIONS
# ----------------------

struct OverlappingBoxes{B<:Box} <: Intersection
  value::B
end

struct FaceTouchingBoxes{B<:Box} <: Intersection
  value::B
end

struct CornerTouchingBoxes{P<:Point} <: Intersection
  value::P
end

# ----------------
# IMPLEMENTATIONS
# ----------------

include("intersections/lines.jl")
include("intersections/segments.jl")
include("intersections/boxes.jl")
