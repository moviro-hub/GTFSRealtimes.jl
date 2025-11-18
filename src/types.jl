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
feed = read_gtfsrt("trip_updates.pb")
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
