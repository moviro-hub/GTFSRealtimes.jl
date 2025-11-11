# Implementation of Google's Encoded Polyline Algorithm Format
# See: https://developers.google.com/maps/documentation/utilities/polylinealgorithm

"""
    encode_polyline(positions::Vector{LatLon}, precision::Int64=5) -> String

Encode a sequence of latitude/longitude coordinates as a polyline string using Google's algorithm.

# Arguments
- `positions`: Vector of LatLon coordinates (in degrees)
- `precision`: Number of decimal places to preserve (default: 5)

# Returns
- Encoded polyline string

# Algorithm Steps (per Google's specification):
1. Take the decimal value and multiply by 10^precision, round to integer
2. Convert to binary (using two's complement for negatives)
3. Left-shift the binary value one bit
4. If original decimal was negative, invert this encoding
5. Break into 5-bit chunks (from right)
6. Reverse chunk order
7. OR each chunk with 0x20 if more chunks follow
8. Add 63 to each value and convert to ASCII

# Example
```julia
positions = [LatLon(38.5, -120.2), LatLon(40.7, -120.95)]
encoded = encode_polyline(positions)  # "_p~iF~ps|U_ulLnnqC"
```
"""
function encode_polyline(positions::Vector{LatLon}, precision::Int64 = 5)
    isempty(positions) && return ""
    !(1 ≤ precision ≤ 11) && throw(ArgumentError("precision must be between 1 and 11"))

    factor = 10.0^precision  # E5 format: 38.5° → 3850000
    chars = Char[]
    sizehint!(chars, length(positions) * 12)  # Performance optimization

    # Delta encoding: store differences from previous point
    previous_lat = zero(Int32)
    previous_lon = zero(Int32)

    for position in positions
        # Step 1: Convert to integers (38.5 * 100000 = 3850000)
        lat = round(Int32, position.lat * factor)
        lon = round(Int32, position.lon * factor)

        # Delta encoding: current - previous (can be negative)
        diff_lat = lat - previous_lat
        diff_lon = lon - previous_lon

        # Steps 2-8: Encode coordinate differences
        append!(chars, encode_coordinate(diff_lat))
        append!(chars, encode_coordinate(diff_lon))

        previous_lat = lat
        previous_lon = lon
    end

    return join(chars)
end

"""
    encode_coordinate(value::Int32) -> Vector{Char}

Encode a single coordinate difference following Google's algorithm steps 2-8.
"""
function encode_coordinate(value::Int32)
    chars = Char[]
    original_value = value

    # Steps 2-3: Left-shift by 1 (doubles value, makes room for sign bit)
    value = value << 1

    # Step 4: Invert bits if original was negative
    if original_value < 0
        value = ~value
    end

    # Steps 5-8: Break into 5-bit chunks, add continuation bits, convert to ASCII
    while value >= 0x20  # While needs more than 5 bits
        # Extract 5 bits, set continuation bit, shift to ASCII range
        push!(chars, Char((0x20 | (value & 0x1f)) + 63))
        value = value >> 5
    end

    # Final chunk (no continuation bit)
    push!(chars, Char(value + 63))

    return chars
end


"""
    decode_polyline(polyline::String; precision=5) -> Vector{LatLon}

Decode a polyline string back into latitude/longitude coordinates using Google's algorithm.

# Arguments
- `polyline`: Encoded polyline string
- `precision`: Number of decimal places used in encoding (default: 5)

# Returns
- Vector of LatLon coordinates (in degrees)

# Algorithm (reverse of encoding):
1. Convert ASCII characters back to values by subtracting 63
2. Extract 5-bit chunks and check continuation bits
3. Reassemble chunks into signed integers
4. Apply right-shift and two's complement inversion for negatives
5. Divide by 10^precision to get decimal coordinates
6. Apply delta decoding (cumulative sum)

# Example
```julia
encoded = "_p~iF~ps|U_ulLnnqC"
positions = decode_polyline(encoded)  # Returns LatLon coordinates
```
"""
function decode_polyline(polyline::String; precision::Int64 = 5)
    isempty(polyline) && return LatLon[]
    !(1 ≤ precision ≤ 11) && throw(ArgumentError("precision must be between 1 and 11"))

    factor = 10.0^precision
    bytes = Vector{UInt8}(polyline)

    # Phase 1: Decode all coordinate differences
    coords = Int32[]  # Alternating lat_diff, lon_diff, ...
    i = 1

    while i ≤ length(bytes)
        value, next_i = decode_coordinate(bytes, i)
        push!(coords, value)
        i = next_i
    end

    isodd(length(coords)) && throw(ArgumentError("Invalid polyline: odd number of coordinates"))

    # Phase 2: Delta decoding (convert differences to absolute coordinates)
    positions = LatLon[]
    sizehint!(positions, length(coords) ÷ 2)

    lat_sum = Int32(0)
    lon_sum = Int32(0)

    for i in 1:2:length(coords)
        # Add differences to running totals
        lat_sum += coords[i]
        lon_sum += coords[i + 1]

        # Convert back to degrees: 3850000 / 100000 = 38.5
        lat_deg = Float32(lat_sum / factor)
        lon_deg = Float32(lon_sum / factor)

        position = (lat = lat_deg, lon = lon_deg)
        push!(positions, position)
    end

    return positions
end

"""
    decode_coordinate(bytes::Vector{UInt8}, start_index::Int) -> (Int32, Int)

Decode a single coordinate value from the byte array, returning the value and next index.
"""
function decode_coordinate(bytes::Vector{UInt8}, start_index::Int)
    value = Int32(0)
    shift = 0
    i = start_index

    # Reconstruct value from 5-bit chunks
    while i ≤ length(bytes)
        chunk = bytes[i] - 0x3f  # Undo ASCII shift
        data_bits = chunk & 0x1f  # Extract 5-bit data
        value |= Int32(data_bits) << shift  # Accumulate at correct position

        has_more = (chunk & 0x20) != 0  # Check continuation bit
        i += 1

        !has_more && break
        shift += 5
    end

    # Reverse encoding steps: invert if negative, then right-shift
    if isodd(value)  # LSB indicates original was negative
        value = ~value
    end
    value = value >> 1

    return (value, i)
end
