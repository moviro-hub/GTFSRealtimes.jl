# Examples

## Basic Usage

### Downloading and Reading a Feed

```julia
using GTFSRealtimes

# Download a GTFS Realtime feed
download_gtfs_realtime("https://api.example.com/gtfs-realtime/trip-updates", "trip_updates.pb")

# Read the downloaded feed
feed = read_gtfs_realtime("trip_updates.pb")

# Access feed metadata
println("Feed version: ", feed.header.gtfs_realtime_version)
println("Feed timestamp: ", feed.header.timestamp)
println("Number of entities: ", length(feed.entities))
```

### Working with Different Entity Types

```julia
using GTFSRealtimes

feed = read_gtfs_realtime("feed.pb")

# Check what types of entities are in the feed
if has_trip_updates(feed)
    println("Feed contains trip updates")
    trip_updates = get_trip_updates(feed)
    println("Number of trip updates: ", length(trip_updates))
end

if has_vehicle_positions(feed)
    println("Feed contains vehicle positions")
    vehicle_positions = get_vehicle_positions(feed)
    println("Number of vehicle positions: ", length(vehicle_positions))
end

if has_alerts(feed)
    println("Feed contains alerts")
    alerts = get_alerts(feed)
    println("Number of alerts: ", length(alerts))
end
```

### Processing Trip Updates

```julia
using GTFSRealtimes

feed = read_gtfs_realtime("trip_updates.pb")

if has_trip_updates(feed)
    for entity in get_trip_updates(feed)
        trip_update = entity.trip_update

        # Access trip information
        trip = trip_update.trip
        println("Trip ID: ", trip.trip_id)
        println("Route ID: ", trip.route_id)

        # Process stop time updates
        for stop_time_update in trip_update.stop_time_update
            println("Stop ID: ", stop_time_update.stop_id)

            if stop_time_update.arrival !== nothing
                println("Arrival delay: ", stop_time_update.arrival.delay)
            end

            if stop_time_update.departure !== nothing
                println("Departure delay: ", stop_time_update.departure.delay)
            end
        end
    end
end
```

### Processing Vehicle Positions

```julia
using GTFSRealtimes

feed = read_gtfs_realtime("vehicle_positions.pb")

if has_vehicle_positions(feed)
    for entity in get_vehicle_positions(feed)
        vehicle = entity.vehicle

        # Access vehicle information
        if vehicle.vehicle !== nothing
            println("Vehicle ID: ", vehicle.vehicle.id)
            println("Label: ", vehicle.vehicle.label)
        end

        # Access position information
        if vehicle.position !== nothing
            pos = vehicle.position
            println("Latitude: ", pos.latitude)
            println("Longitude: ", pos.longitude)
            println("Bearing: ", pos.bearing)
            println("Speed: ", pos.speed)
        end

        # Access trip information
        if vehicle.trip !== nothing
            trip = vehicle.trip
            println("Trip ID: ", trip.trip_id)
            println("Route ID: ", trip.route_id)
        end
    end
end
```

### Processing Alerts

```julia
using GTFSRealtimes

feed = read_gtfs_realtime("alerts.pb")

if has_alerts(feed)
    for entity in get_alerts(feed)
        alert = entity.alert

        # Access alert information
        for informed_entity in alert.informed_entity
            if informed_entity.route_id !== nothing
                println("Affected route: ", informed_entity.route_id)
            end

            if informed_entity.stop_id !== nothing
                println("Affected stop: ", informed_entity.stop_id)
            end
        end

        # Access alert text
        for text in alert.header_text.translation
            println("Alert header: ", text.text)
        end

        for text in alert.description_text.translation
            println("Alert description: ", text.text)
        end
    end
end
```

## Error Handling

```julia
using GTFSRealtimes

# Handle download errors
try
    download_gtfs_realtime("https://invalid-url.com/feed", "feed.pb")
catch e
    if isa(e, ArgumentError)
        println("Download failed: ", e.msg)
    else
        println("Unexpected error: ", e)
    end
end

# Handle read errors
try
    feed = read_gtfs_realtime("nonexistent.pb")
catch e
    if isa(e, ArgumentError)
        println("Read failed: ", e.msg)
    else
        println("Unexpected error: ", e)
    end
end
```
