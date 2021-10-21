"""
    struct Mesh{T}

* `x`: X-coordinate mesh in meters
* `y`: Y-coordinate mesh in meters
* `z`: Z-coordinate mesh in meters
* `connections`: defines which points are connected to eah other

"""

struct Mesh{T}
    x::Vector{T}
    y::Vector{T}
    z::Vector{T}
    connections::Vector{Vector{Int64}}
end

function mesh(p::AbstractSurfacePrimitive{T}, n_arc::Int64)::Mesh{T} where {T}
    vs = vertices(p, n_arc)
    x, y, z = broadcast(i -> getindex.(vs, i), (1,2,3))
    c = connections(p, n_arc)
    Mesh{T}(x,y,z,c)
end

function mesh(p::AbstractSurfacePrimitive{T}, n_arc::Int64, n_vert_lines::Int64)::Mesh{T} where {T}
    vs = vertices(p, n_arc)
    x, y, z = broadcast(i -> getindex.(vs, i), (1,2,3))
    c = connections(p, n_arc, n_vert_lines)
    Mesh{T}(x,y,z,c)
end

@recipe function f(m::Mesh{T}) where {T}
    seriestype := :mesh3d
    xguide --> "x"
    yguide --> "y"
    zguide --> "z"
    unitformat --> :slash
    label --> ""
    if occursin("GRBackend", string(typeof(plotattributes[:plot_object].backend)))
        linewidth --> 0.75
    else
        linewidth --> 0.1
    end
    linecolor --> :black
    seriescolor --> 1
    fillalpha --> 0.5
    connections := m.connections
    m.x*internal_length_unit, m.y*internal_length_unit, m.z*internal_length_unit
end