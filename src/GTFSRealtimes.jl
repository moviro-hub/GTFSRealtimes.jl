"""
    GTFSRealtimes

A Julia package for downloading and reading GTFS Realtime feeds using Protocol Buffers.

## Features

- **GTFS Realtime Support**: Download and read GTFS Realtime feeds from transit agencies
- **Protocol Buffer Integration**: Native support for GTFS Realtime protobuf format
- **Automatic Updates**: Protobuf definitions are automatically generated from the official GTFS Realtime specification
- **Compression Support**: Handles gzip-compressed feeds commonly used in production

## Main Functions

- [`download_gtfs_realtime`](@ref): Download GTFS Realtime feeds from URLs
- [`read_gtfs_realtime`](@ref): Read GTFS Realtime feeds from protobuf files

## Data Types

- [`GTFSRealtime`](@ref): Container for complete GTFS Realtime datasets
- `FeedMessage`: Raw protobuf message structure
- `FeedHeader`: Feed metadata and version information
- `FeedEntity`: Individual feed entities (trip updates, vehicle positions, alerts)

## Examples

```julia
using GTFSRealtimes

# Download a GTFS Realtime feed
download_gtfs_realtime("https://api.example.com/gtfs-realtime/trip-updates", "trip_updates.pb")

# Read the downloaded feed
feed = read_gtfs_realtime("trip_updates.pb")

# Access feed data
println("Feed version: ", feed.header.gtfs_realtime_version)
println("Number of entities: ", length(feed.entities))

# Check for specific entity types
if has_trip_updates(feed)
    println("Feed contains trip updates")
end

if has_vehicle_positions(feed)
    println("Feed contains vehicle positions")
end

if has_alerts(feed)
    println("Feed contains alerts")
end
```

## GTFS Realtime Specification

This package implements the official GTFS Realtime specification:
https://gtfs.org/documentation/realtime/reference/

The protobuf definitions are automatically generated from the official specification at:
https://gtfs.org/documentation/realtime/gtfs-realtime.proto
"""
module GTFSRealtimes

using ProtoBuf: decode, ProtoDecoder, PipeBuffer
using Downloads

# Include protobuf definitions
include("transit_realtime/transit_realtime.jl")
using .transit_realtime: transit_realtime as GTFSProtoBuf

# Include type definitions and I/O functions
include("types.jl")
include("io.jl")
include("polyline.jl")
include("shapes.jl")

# Export main functions
export download_gtfs_realtime, read_gtfs_realtime

# Export main types
export GTFSRealtime, LatLon

# Export GTFSProtoBuf types for advanced usage
export GTFSProtoBuf

# Export helper functions
export has_trip_updates, has_vehicle_positions, has_alerts, has_shapes, has_stops, has_trip_modifications
export get_trip_updates, get_vehicle_positions, get_alerts, get_shapes, get_stops, get_trip_modifications
export decompress_shape, compress_shape

# Implement the decode_protobuf function now that GTFSProtoBuf is available
function decode_protobuf(data::Vector{UInt8})
    # Create a decoder over an IO buffer for the protobuf data
    decoder = ProtoDecoder(IOBuffer(data))
    return decode(decoder, GTFSProtoBuf.FeedMessage)
end

end # module GTFSRealtimes
