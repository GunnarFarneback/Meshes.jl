# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

module MeshesMakieExt

using Meshes

using Makie: cgrad
using Makie: coloralpha
using Makie.Colors: Colorant

import Meshes: viz, viz!
import Meshes: ascolors
import Meshes: defaultscheme
import Makie

Makie.@recipe(Viz, object) do scene
  Makie.Attributes(
    color=:slategray3,
    alpha=nothing,
    colorscheme=nothing,
    pointsize=4,
    segmentsize=1.5,
    showfacets=false,
    facetcolor=:gray30
  )
end

# choose between 2D and 3D axis
Makie.args_preferred_axis(::Geometry{Dim}) where {Dim} = Dim === 3 ? Makie.LScene : Makie.Axis
Makie.args_preferred_axis(::Domain{Dim}) where {Dim} = Dim === 3 ? Makie.LScene : Makie.Axis

# color handling
include("colors.jl")

# utilities
include("utils.jl")

# viz recipes
include("simplemesh.jl")
include("cartesiangrid.jl")
include("subcartesiangrid.jl")
include("rectilineargrid.jl")
include("geometryset.jl")
include("fallbacks.jl")

end
