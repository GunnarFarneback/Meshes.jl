# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

module Meshes

using Tables
using StaticArrays
using SparseArrays
using CircularArrays
using LinearAlgebra
using Random

using Bessels: gamma
using IterTools: ivec
using StatsBase: AbstractWeights, Weights, quantile
using Distances: PreMetric, Euclidean, Mahalanobis, evaluate
using ReferenceFrameRotations: EulerAngles, DCM
using NearestNeighbors: KDTree, BallTree, knn, inrange

import Tables
import Random
import Base: values, ==, +, -, *
import StatsBase: sample
import Distances: evaluate
import NearestNeighbors: MinkowskiMetric

# Transforms API
import TransformsBase: Transform
import TransformsBase: isrevertible, preprocess
import TransformsBase: apply, revert, reapply

# IO utils
include("ioutils.jl")

# numerical tolerances
include("tolerances.jl")

# basic types
include("vectors.jl")
include("points.jl")
include("angles.jl")

# rotations
include("rotations.jl")

# type traits
include("traits.jl")

# geometries
include("geometries.jl")

# collections
include("collections.jl")

# meshes
include("connectivities.jl")
include("topologies.jl")
include("toporelations.jl")
include("mesh.jl")

# mesh data
include("meshdata.jl")

# utilities
include("utils.jl")

# miscellaneous
include("paths.jl")
include("distances.jl")
include("neighborhoods.jl")
include("neighborsearch.jl")
include("supportfun.jl")
include("matrices.jl")

# views and partitions
include("views.jl")
include("partitions.jl")

# algorithms
include("viewing.jl")
include("merging.jl")
include("sampling.jl")
include("partitioning.jl")
include("intersections.jl")
include("discretization.jl")
include("simplification.jl")
include("refinement.jl")
include("boundingboxes.jl")
include("hulls.jl")

# transforms
include("transforms.jl")

export
  # points
  Point,
  Point1, Point2, Point3,
  Point1f, Point2f, Point3f,
  embeddim, paramdim,
  coordtype, coordinates,
  center, centroid, measure,
  ⪯, ≺, ⪰, ≻,

  # vectors
  Vec,
  Vec1, Vec2, Vec3,
  Vec1f, Vec2f, Vec3f,

  # linear algebra
  ⋅, ×,

  # angles
  ∠,

  # rotations
  ClockwiseAngle,
  CounterClockwiseAngle,
  EulerAngles,
  TaitBryanAngles,

  # domain traits
  Domain,
  embeddim, paramdim, coordtype,
  element, nelements,

  # data traits
  Data,
  domain, constructor, asarray,

  # domain/data alias
  DomainOrData,
  nitems,

  # geometries
  Geometry,
  embeddim, paramdim, coordtype,
  measure, area, volume, boundary,
  isconvex, issimplex, isperiodic,
  center, centroid, perimeter,

  # primitives
  Primitive,
  Line, Ray, Plane, BezierCurve,
  Box, Ball, Sphere, Cylinder, CylinderSurface,
  ncontrols, degree, Horner, DeCasteljau,
  radius, bottom, top, axis, isright, sides,
  measure, diagonal, origin, direction,

  # polytopes
  Polytope, Polygon, Polyhedron,
  Segment, Ngon, Triangle, Quadrangle,
  Pentagon, Hexagon, Heptagon,
  Octagon, Nonagon, Decagon,
  Chain, PolyArea,
  Tetrahedron, Pyramid, Hexahedron,
  vertices, nvertices,
  windingnumber, chains, segments,
  isclosed, issimple, hasholes,
  angles, innerangles, close!, open!,
  orientation, bridge, normal,

  # orientation algorithms
  WindingOrientation,
  TriangleOrientation,

  # point or geometry alias
  PointOrGeometry,

  # multi-types
  Multi,

  # collections
  Collection,
  PointSet,
  GeometrySet,

  # utililities
  signarea,
  sideof,
  householderbasis,
  mayberound,

  # paths
  Path,
  LinearPath, RandomPath,
  ShiftedPath, SourcePath,
  traverse,

  # neighborhoods
  Neighborhood,
  MetricBall,
  metric,
  radii,
  radius,
  isisotropic,

  # neighbordhood search
  NeighborSearchMethod,
  BoundedNeighborSearchMethod,
  BallSearch,
  KNearestSearch,
  KBallSearch,
  BoundedSearch,
  GlobalSearch,
  search!, search,
  maxneighbors,

  # miscellaneous
  supportfun,
  laplacematrix,
  measurematrix,
  adjacencymatrix,

  # connectivities
  Connectivity,
  paramdim, indices,
  connect, materialize,
  issimplex, pltype,

  # topologies
  Topology,
  vertices, elements, facets,
  nvertices, nelements, nfacets,
  element, facet,
  faces, nfaces,
  GridTopology,
  HalfEdgeTopology, HalfEdge,
  SimpleTopology,
  elem2cart, cart2elem,
  corner2cart, cart2corner,
  elem2corner, corner2elem,
  elementtype, facettype,
  isperiodic,
  half4elem, half4vert,
  half4edge, half4pair,
  edge4pair,
  connec4elem,

  # topological relations
  TopologicalRelation,
  Boundary, Coboundary, Adjacency,

  # meshes
  Mesh, Grid,
  CartesianGrid,
  RectilinearGrid,
  SimpleMesh,
  vertices, elements, facets,
  nvertices, nelements, nfacets,
  element, facet,
  faces, nfaces,
  topology,
  topoconvert,
  cart2vert,
  spacing,
  offset,

  # mesh data
  MeshData,
  meshdata,

  # views
  DomainView,
  DataView,

  # partitions
  Partition,
  indices, metadata,

  # viewing
  unview, indices, slice,

  # sampling
  SamplingMethod,
  DiscreteSamplingMethod,
  ContinuousSamplingMethod,
  UniformSampling,
  WeightedSampling,
  BallSampling,
  BlockSampling,
  RegularSampling,
  HomogeneousSampling,
  MinDistanceSampling,
  sample,

  # partitioning
  PartitionMethod,
  PredicatePartitionMethod,
  SPredicatePartitionMethod,
  UniformPartition,
  FractionPartition,
  BlockPartition,
  BisectPointPartition,
  BisectFractionPartition,
  BallPartition,
  PlanePartition,
  DirectionPartition,
  PredicatePartition,
  SpatialPredicatePartition,
  ProductPartition,
  HierarchicalPartition,
  partition, split,

  # intersection types
  IntersectionType,
  CrossingLines,
  OverlappingLines,
  OverlappingBoxes,
  FaceTouchingBoxes,
  CornerTouchingBoxes,
  CrossingSegments,
  MidTouchingSegments,
  CornerTouchingSegments,
  OverlappingSegments,
  CrossingRays,
  MidTouchingRays,
  CornerTouchingRays,
  OverlappingAgreeingRays,
  OverlappingOpposingRays,
  CrossingRaySegment,
  MidTouchingRaySegment,
  CornerTouchingRaySegment,
  OverlappingRaySegment,
  CrossingRayLine,
  TouchingRayLine,
  OverlappingRayLine,
  CrossingLineSegment,
  TouchingLineSegment,
  OverlappingLineSegment,
  CrossingRayBox,
  TouchingRayBox,
  IntersectingSegmentTriangle,
  IntersectingRayTriangle,
  CrossingSegmentPlane,
  TouchingSegmentPlane,
  OverlappingSegmentPlane,
  NoIntersection,

  # intersections
  Intersection,
  intersection,
  hasintersect,
  type,

  # discretization
  DiscretizationMethod,
  BoundaryDiscretizationMethod,
  FanTriangulation,
  RegularDiscretization,
  FIST, Dehn1899,
  Tetrahedralization,
  discretize,
  discretizewithin,
  simplexify,

  # simplification
  SimplificationMethod,
  DouglasPeucker,
  simplify,
  decimate,

  # refinement
  RefinementMethod,
  TriRefinement,
  QuadRefinement,
  CatmullClark,
  refine,

  # bounding boxes
  boundingbox,

  # hulls
  HullMethod,
  GrahamScan,
  hull,

  # transforms
  GeometricTransform,
  StatelessGeometricTransform,
  StdCoords,
  LambdaMuSmoothing,
  LaplaceSmoothing,
  TaubinSmoothing,

  # tolerances
  atol

end # module
