# API Reference

```@meta
CurrentModule = GTFSRealtimes
```

## Data Types

```@docs
GTFSRealtime
```

## Main Functions

```@docs
download_gtfsrt
read_gtfsrt
```

## Entity Helpers

### Presence Checks

```@docs
has_trip_updates
has_vehicle_positions
has_alerts
has_shapes
has_stops
has_trip_modifications
```

### Entity Extraction

```@docs
get_trip_updates
get_vehicle_positions
get_alerts
get_shapes
get_stops
get_trip_modifications
```

## Shape Utilities

```@docs
decompress_shape
compress_shape
```
