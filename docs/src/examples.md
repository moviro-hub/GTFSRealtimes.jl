# Examples

## Basic Usage

### Downloading and Reading a Feed

```julia
using GTFSRealtimes

# Download a GTFS Realtime feed
download_gtfsrt("https://api.example.com/gtfs-realtime/trip-updates", "trip_updates.pb")

# Read the downloaded feed
feed = read_gtfsrt("trip_updates.pb")

# Access feed metadata
println("Feed version: ", feed.header.gtfs_realtime_version)
println("Feed timestamp: ", feed.header.timestamp)
println("Number of entities: ", length(feed.entities))
```

### Processing Trip Updates

```julia
using GTFSRealtimes

feed = read_gtfsrt("trip_updates.pb")

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

feed = read_gtfsrt("vehicle_positions.pb")

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
