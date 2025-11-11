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

"""
    has_trip_updates(feed::GTFSRealtime) -> Bool

Check if the feed contains any trip update entities.
"""
function has_trip_updates(feed::GTFSRealtime)::Bool
    return findfirst(entity -> entity.trip_update !== nothing, feed.entities) !== nothing
end

"""
    has_vehicle_positions(feed::GTFSRealtime) -> Bool

Check if the feed contains any vehicle position entities.
"""
function has_vehicle_positions(feed::GTFSRealtime)::Bool
    return findfirst(entity -> entity.vehicle !== nothing, feed.entities) !== nothing
end

"""
    has_alerts(feed::GTFSRealtime) -> Bool

Check if the feed contains any alert entities.
"""
function has_alerts(feed::GTFSRealtime)::Bool
    return findfirst(entity -> entity.alert !== nothing, feed.entities) !== nothing
end

"""
    has_shapes(feed::GTFSRealtime) -> Bool

Check if the feed contains any shape entities.
"""
function has_shapes(feed::GTFSRealtime)::Bool
    return findfirst(entity -> entity.shape !== nothing, feed.entities) !== nothing
end

"""
    has_stops(feed::GTFSRealtime) -> Bool

Check if the feed contains any stop entities.
"""
function has_stops(feed::GTFSRealtime)::Bool
    return findfirst(entity -> entity.stop !== nothing, feed.entities) !== nothing
end

"""
    has_trip_modifications(feed::GTFSRealtime) -> Bool

Check if the feed contains any trip modification entities.
"""
function has_trip_modifications(feed::GTFSRealtime)::Bool
    return findfirst(entity -> entity.trip_modifications !== nothing, feed.entities) !== nothing
end

"""
    get_trip_updates(feed::GTFSRealtime) -> Vector

Get all trip update entities from the feed.
"""
function get_trip_updates(feed::GTFSRealtime)
    return filter(entity -> entity.trip_update !== nothing, feed.entities)
end

"""
    get_vehicle_positions(feed::GTFSRealtime) -> Vector

Get all vehicle position entities from the feed.
"""
function get_vehicle_positions(feed::GTFSRealtime)
    return filter(entity -> entity.vehicle !== nothing, feed.entities)
end

"""
    get_alerts(feed::GTFSRealtime) -> Vector

Get all alert entities from the feed.
"""
function get_alerts(feed::GTFSRealtime)
    return filter(entity -> entity.alert !== nothing, feed.entities)
end

"""
    get_shapes(feed::GTFSRealtime) -> Vector

Get all shape entities from the feed.
"""
function get_shapes(feed::GTFSRealtime)
    return filter(entity -> entity.shape !== nothing, feed.entities)
end

"""
    get_stops(feed::GTFSRealtime) -> Vector

Get all stop entities from the feed.
"""
function get_stops(feed::GTFSRealtime)
    return filter(entity -> entity.stop !== nothing, feed.entities)
end

"""
    get_trip_modifications(feed::GTFSRealtime) -> Vector

Get all trip modification entities from the feed.
"""
function get_trip_modifications(feed::GTFSRealtime)
    return filter(entity -> entity.trip_modifications !== nothing, feed.entities)
end
