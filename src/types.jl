"""
    LatLon

NamedTuple type for latitude/longitude coordinates.

# Fields
- `lat::Float32`: Latitude in degrees
- `lon::Float32`: Longitude in degrees

# Examples
```julia
coord = (lat=38.5f0, lon=-120.2f0)
coord = LatLon(38.5, -120.2)
```
"""
const LatLon = NamedTuple{(:lat, :lon), Tuple{Float32, Float32}}

"""
    LatLon(lat::Number, lon::Number) -> LatLon

Constructor for creating a LatLon coordinate.

# Arguments
- `lat::Number`: Latitude in degrees (will be converted to Float32)
- `lon::Number`: Longitude in degrees (will be converted to Float32)

# Returns
- `LatLon`: NamedTuple with lat and lon fields

# Examples
```julia
coord = LatLon(38.5, -120.2)
coord.lat  # 38.5f0
coord.lon  # -120.2f0
```
"""
LatLon(lat::Number, lon::Number) = (lat = Float32(lat), lon = Float32(lon))

"""
    GTFSRealtime

Container for GTFS Realtime feed data with convenient access to header and entities.

# Fields
- `header`: Feed header containing metadata
- `entities`: Vector of feed entities (trip updates, vehicle positions, alerts)

# Constructors
- `GTFSRealtime()`: Create empty feed
- `GTFSRealtime(header, entities)`: Create with pre-populated data

# Examples
```julia
feed = read_gtfs_realtime("trip_updates.pb")
println("Feed version: ", feed.header.gtfs_realtime_version)
println("Number of entities: ", length(feed.entities))
```
"""
struct GTFSRealtime
    header::Union{GTFSProtoBuf.FeedHeader, Nothing}
    entities::Vector{GTFSProtoBuf.FeedEntity}
end

"""
    GTFSRealtime()

Create an empty GTFS Realtime feed.
"""
GTFSRealtime() = GTFSRealtime(nothing, GTFSProtoBuf.FeedEntity[])

# Use the default struct constructor for GTFSRealtime(header, entities)
