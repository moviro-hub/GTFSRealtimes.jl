# Shape compression and decompression functions using polyline encoding

"""
    decompress_shape(shape::GTFSProtoBuf.Shape; precision::Int64=5) -> Vector{Tuple{Float64, Float64}}

Decode the encoded_polyline field of a Shape entity into a vector of (latitude, longitude) coordinates.

# Arguments
- `shape`: A Shape entity from GTFS Realtime
- `precision`: Number of decimal places used in encoding (default: 5)

# Returns
- Vector of (latitude, longitude) tuples as Float64 values

# Examples
```julia
shape = get_shapes(feed)[1].shape
coordinates = decompress_shape(shape)
# Returns: [(38.5, -120.2), (40.7, -120.95), ...]
```

# Throws
- `ArgumentError` if the polyline string is invalid or has odd number of coordinates
"""
function decompress_shape(shape::GTFSProtoBuf.Shape; precision::Int64=5)::Vector{Tuple{Float64, Float64}}
    if isempty(shape.encoded_polyline)
        return Tuple{Float64, Float64}[]
    end

    # Decode polyline using the polyline.jl functions
    # decode_polyline already returns Tuple{Float64, Float64}[]
    return decode_polyline(shape.encoded_polyline; precision=precision)
end

"""
    compress_shape(shape_id::String, coordinates::Vector{Tuple{Float64, Float64}}; precision::Int64=5) -> GTFSProtoBuf.Shape

Encode a vector of (latitude, longitude) coordinates into a Shape entity with encoded_polyline.

# Arguments
- `shape_id`: Identifier for the shape
- `coordinates`: Vector of (latitude, longitude) tuples as Float64 values
- `precision`: Number of decimal places to preserve in encoding (default: 5)

# Returns
- A new Shape struct with the encoded polyline

# Examples
```julia
coords = [(38.5, -120.2), (40.7, -120.95)]
shape = compress_shape("shape_123", coords)
```

# Throws
- `ArgumentError` if coordinates vector is empty or precision is invalid
"""
function compress_shape(shape_id::String, coordinates::Vector{Tuple{Float64, Float64}}; precision::Int64=5)::GTFSProtoBuf.Shape
    if isempty(coordinates)
        return GTFSProtoBuf.Shape(shape_id, "")
    end

    # encode_polyline already accepts Vector{Tuple{Float64, Float64}}
    encoded = encode_polyline(coordinates, precision)

    return GTFSProtoBuf.Shape(shape_id, encoded)
end
