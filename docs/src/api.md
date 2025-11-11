# API Reference

## Main Functions

### [`download_gtfs_realtime`](@id download_gtfs_realtime)

```julia
download_gtfs_realtime(url::String, file::String)
```

Download a GTFS Realtime feed from a URL and save it to a file.

**Arguments:**
- `url::String`: URL of the GTFS Realtime feed
- `file::String`: Local file path to save the feed

**Examples:**
```julia
download_gtfs_realtime("https://api.example.com/gtfs-realtime/trip-updates", "trip_updates.pb")
```

### [`read_gtfs_realtime`](@id read_gtfs_realtime)

```julia
read_gtfs_realtime(file::String) -> GTFSRealtime
```

Read a GTFS Realtime feed from a protobuf file.

**Arguments:**
- `file::String`: Path to the GTFS Realtime protobuf file

**Returns:**
- `GTFSRealtime`: Parsed feed data with header and entities

**Examples:**
```julia
feed = read_gtfs_realtime("trip_updates.pb")
```

## Data Types

### [`GTFSRealtime`](@id GTFSRealtime)

```julia
struct GTFSRealtime
    header::Union{FeedHeader, Nothing}
    entities::Vector{FeedEntity}
end
```

Container for GTFS Realtime feed data with convenient access to header and entities.

**Fields:**
- `header`: Feed header containing metadata (or `nothing` if not present)
- `entities`: Vector of feed entities (trip updates, vehicle positions, alerts)

## Helper Functions

### Entity Type Checks

- `has_trip_updates(feed::GTFSRealtime) -> Bool`: Check if the feed contains trip update entities
- `has_vehicle_positions(feed::GTFSRealtime) -> Bool`: Check if the feed contains vehicle position entities
- `has_alerts(feed::GTFSRealtime) -> Bool`: Check if the feed contains alert entities

### Entity Extraction

- `get_trip_updates(feed::GTFSRealtime) -> Vector`: Get all trip update entities from the feed
- `get_vehicle_positions(feed::GTFSRealtime) -> Vector`: Get all vehicle position entities from the feed
- `get_alerts(feed::GTFSRealtime) -> Vector`: Get all alert entities from the feed
