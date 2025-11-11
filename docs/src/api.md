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

### [`LatLon`](@id LatLon)

```julia
LatLon(lat::Number, lon::Number) -> LatLon
```

Constructor for creating a LatLon coordinate (NamedTuple with `lat` and `lon` fields).

**Arguments:**
- `lat::Number`: Latitude in degrees (will be converted to Float32)
- `lon::Number`: Longitude in degrees (will be converted to Float32)

**Returns:**
- `LatLon`: NamedTuple with `lat::Float32` and `lon::Float32` fields

**Examples:**
```julia
coord = LatLon(38.5, -120.2)
coord.lat  # 38.5f0
coord.lon  # -120.2f0
```

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
- `entities`: Vector of feed entities (trip updates, vehicle positions, alerts, shapes, stops, trip modifications)

## Helper Functions

### Entity Type Checks

- `has_trip_updates(feed::GTFSRealtime) -> Bool`: Check if the feed contains trip update entities
- `has_vehicle_positions(feed::GTFSRealtime) -> Bool`: Check if the feed contains vehicle position entities
- `has_alerts(feed::GTFSRealtime) -> Bool`: Check if the feed contains alert entities
- `has_shapes(feed::GTFSRealtime) -> Bool`: Check if the feed contains shape entities
- `has_stops(feed::GTFSRealtime) -> Bool`: Check if the feed contains stop entities
- `has_trip_modifications(feed::GTFSRealtime) -> Bool`: Check if the feed contains trip modification entities

### Entity Extraction

- `get_trip_updates(feed::GTFSRealtime) -> Vector`: Get all trip update entities from the feed
- `get_vehicle_positions(feed::GTFSRealtime) -> Vector`: Get all vehicle position entities from the feed
- `get_alerts(feed::GTFSRealtime) -> Vector`: Get all alert entities from the feed
- `get_shapes(feed::GTFSRealtime) -> Vector`: Get all shape entities from the feed
- `get_stops(feed::GTFSRealtime) -> Vector`: Get all stop entities from the feed
- `get_trip_modifications(feed::GTFSRealtime) -> Vector`: Get all trip modification entities from the feed

### Shape Compression and Decompression

- `decompress_shape`: Decode the encoded_polyline field of a Shape entity into coordinates
- `compress_shape`: Encode coordinates into a Shape entity with encoded_polyline

#### `decompress_shape`

```julia
decompress_shape(shape::GTFSProtoBuf.Shape; precision::Int64=5) -> Vector{LatLon}
```

Decode the encoded_polyline field of a Shape entity into a vector of LatLon coordinates.

**Arguments:**
- `shape`: A Shape entity from GTFS Realtime
- `precision`: Number of decimal places used in encoding (default: 5)

**Returns:**
- Vector of LatLon coordinates (NamedTuple with `lat` and `lon` fields)

**Examples:**
```julia
shape = get_shapes(feed)[1].shape
coordinates = decompress_shape(shape)
# Returns: [(lat=38.5f0, lon=-120.2f0), (lat=40.7f0, lon=-120.95f0), ...]
```

#### `compress_shape`

```julia
compress_shape(shape_id::String, coordinates::Vector{LatLon}; precision::Int64=5) -> GTFSProtoBuf.Shape
```

Encode a vector of LatLon coordinates into a Shape entity with encoded_polyline.

**Arguments:**
- `shape_id`: Identifier for the shape
- `coordinates`: Vector of LatLon coordinates (NamedTuple with `lat` and `lon` fields)
- `precision`: Number of decimal places to preserve in encoding (default: 5)

**Returns:**
- A new Shape struct with the encoded polyline

**Examples:**
```julia
coords = [LatLon(38.5, -120.2), LatLon(40.7, -120.95)]
shape = compress_shape("shape_123", coords)
```
