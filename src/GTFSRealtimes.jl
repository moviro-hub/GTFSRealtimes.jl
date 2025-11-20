"""
    GTFSRealtimes

A Julia package for downloading and reading GTFS Realtime feeds using Protocol Buffers.

## Features

- **GTFS Realtime Support**: Download and read GTFS Realtime feeds from transit agencies
- **Protocol Buffer Integration**: Native support for GTFS Realtime protobuf format
- **Automatic Updates**: Protobuf definitions are automatically generated from the official GTFS Realtime specification
- **Compression Support**: Handles gzip-compressed feeds commonly used in production

## Main Functions

- [`download_gtfsrt`](@ref): Download GTFS Realtime feeds from URLs
- [`read_gtfsrt`](@ref): Read GTFS Realtime feeds from protobuf files

## Data Types

- [`GTFSRealtime`](@ref): Container for complete GTFS Realtime datasets
- `FeedMessage`: Raw protobuf message structure
- `FeedHeader`: Feed metadata and version information
- `FeedEntity`: Individual feed entities (trip updates, vehicle positions, alerts)

## Examples

```julia
using GTFSRealtimes

# Download a GTFS Realtime feed
download_gtfsrt("https://api.example.com/gtfs-realtime/trip-updates", "trip_updates.pb")

# Read the downloaded feed
feed = read_gtfsrt("trip_updates.pb")

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

# Include protobuf submodule with a name following julia conventions and export the module under this name
include("transit_realtime/transit_realtime.jl")
using .transit_realtime: transit_realtime as GTFSProtoBuf
export GTFSProtoBuf

include("types.jl")
include("io.jl")
include("helpers.jl")
include("shapes.jl")

# Export main type
export GTFSRealtime

# Export main functions
export download_gtfsrt, read_gtfsrt, fetch_gtfsrt

# Export helper functions
export has_trip_updates, has_vehicle_positions, has_alerts, has_shapes, has_stops, has_trip_modifications
export get_trip_updates, get_vehicle_positions, get_alerts, get_shapes, get_stops, get_trip_modifications

# Export LatLon type and shape compression/decompression functions
export decompress_shape, compress_shape
# public LatLon


end # module GTFSRealtimes
