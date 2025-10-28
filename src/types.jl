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
