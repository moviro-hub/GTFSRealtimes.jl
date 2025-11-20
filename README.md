# GTFSRealtimes.jl

[Documentation](https://moviro-hub.github.io/GTFSRealtimes.jl/)

A Julia package for downloading and reading GTFS Realtime feeds.

## Overview

GTFSRealtimes.jl supports downloading feeds from transit agencies and parsing them with the official GTFS Realtime protobuf specification.

## Installation

```julia
using Pkg
Pkg.add(url="https://github.com/moviro-hub/GTFSRealtimes.jl")
```

## Quick Start

```julia
using GTFSRealtimes

# Download a GTFS Realtime feed to disk
download_gtfsrt("https://api.example.com/gtfs-realtime/trip-updates", "trip_updates.pb")

# Read the downloaded feed from disk
feed = read_gtfsrt("trip_updates.pb")

# Or fetch and decode in one step
feed = fetch_gtfsrt("https://api.example.com/gtfs-realtime/trip-updates")

# Access feed data
println("Feed version: ", feed.header.gtfs_realtime_version)
println("Number of entities: ", length(feed.entities))
```

## GTFS Realtime Specification

This package implements the official GTFS Realtime specification:
https://gtfs.org/documentation/realtime/reference/

The protobuf definitions are generated from the official specification:
https://gtfs.org/documentation/realtime/gtfs-realtime.proto

## License

This package is licensed under the MIT License. See LICENSE file for details.
