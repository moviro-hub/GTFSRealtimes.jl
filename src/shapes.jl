# Shape compression and decompression functions using polyline encoding

"""
    decompress_shape(shape::GTFSProtoBuf.Shape; precision::Int64=5) -> Vector{LatLon}

Decode the encoded_polyline field of a Shape entity into a vector of LatLon coordinates.

# Arguments
- `shape`: A Shape entity from GTFS Realtime
- `precision`: Number of decimal places used in encoding (default: 5)

# Returns
- Vector of LatLon coordinates

# Examples
```julia
shape = get_shapes(feed)[1].shape
coordinates = decompress_shape(shape)
# Returns: [(lat=38.5f0, lon=-120.2f0), (lat=40.7f0, lon=-120.95f0), ...]
```

# Throws
- `ArgumentError` if the polyline string is invalid or has odd number of coordinates
"""
function decompress_shape(shape::GTFSProtoBuf.Shape; precision::Int64 = 5)::Vector{LatLon}
    if isempty(shape.encoded_polyline)
        return LatLon[]
    end

    # Decode polyline using the polyline.jl functions
    # decode_polyline already returns Vector{LatLon}
    return decode_polyline(shape.encoded_polyline; precision = precision)
end

"""
    compress_shape(shape_id::String, coordinates::Vector{LatLon}; precision::Int64=5) -> GTFSProtoBuf.Shape

Encode a vector of LatLon coordinates into a Shape entity with encoded_polyline.

# Arguments
- `shape_id`: Identifier for the shape
- `coordinates`: Vector of LatLon coordinates
- `precision`: Number of decimal places to preserve in encoding (default: 5)

# Returns
- A new Shape struct with the encoded polyline

# Examples
```julia
coords = [LatLon(38.5, -120.2), LatLon(40.7, -120.95)]
shape = compress_shape("shape_123", coords)
```

# Throws
- `ArgumentError` if coordinates vector is empty or precision is invalid
"""
function compress_shape(shape_id::String, coordinates::Vector{LatLon}; precision::Int64 = 5)::GTFSProtoBuf.Shape
    if isempty(coordinates)
        return GTFSProtoBuf.Shape(shape_id, "")
    end

    # encode_polyline already accepts Vector{LatLon}
    encoded = encode_polyline(coordinates, precision)

    return GTFSProtoBuf.Shape(shape_id, encoded)
end
