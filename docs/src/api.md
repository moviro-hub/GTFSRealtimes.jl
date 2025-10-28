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
read_gtfs_realtime(file::String) -> GTFSRealtimeFeed
```

Read a GTFS Realtime feed from a protobuf file.

**Arguments:**
- `file::String`: Path to the GTFS Realtime protobuf file

**Returns:**
- `GTFSRealtimeFeed`: Parsed feed data with header, entities, and raw message

**Examples:**
```julia
feed = read_gtfs_realtime("trip_updates.pb")
```

## Data Types

### [`GTFSRealtimeFeed`](@id GTFSRealtimeFeed)

```julia
struct GTFSRealtimeFeed
    header::Any
    entities::Vector{Any}
    raw::Any
end
```

Container for GTFS Realtime feed data with convenient access to header and entities.

**Fields:**
- `header`: Feed header containing metadata
- `entities`: Vector of feed entities (trip updates, vehicle positions, alerts)
- `raw`: Raw protobuf message for advanced usage

## Helper Functions

### Entity Type Checks

- [`has_trip_updates`](@ref): Check if the feed contains trip update entities
- [`has_vehicle_positions`](@ref): Check if the feed contains vehicle position entities
- [`has_alerts`](@ref): Check if the feed contains alert entities

### Entity Extraction

- [`get_trip_updates`](@ref): Get all trip update entities from the feed
- [`get_vehicle_positions`](@ref): Get all vehicle position entities from the feed
- [`get_alerts`](@ref): Get all alert entities from the feed
