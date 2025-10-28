# GTFSRealtimes.jl

A Julia package for downloading and reading GTFS Realtime feeds using Protocol Buffers.

## Overview

GTFSRealtimes.jl provides a comprehensive solution for working with GTFS Realtime feeds in Julia. It supports downloading feeds from transit agencies and parsing them using the official GTFS Realtime protobuf specification.

## Key Features

- **GTFS Realtime Support**: Download and read GTFS Realtime feeds from transit agencies
- **Protocol Buffer Integration**: Native support for GTFS Realtime protobuf format
- **Automatic Updates**: Protobuf definitions are automatically generated from the official GTFS Realtime specification
- **Compression Support**: Handles gzip-compressed feeds commonly used in production

## Quick Start

```julia
using GTFSRealtimes

# Download a GTFS Realtime feed
download_gtfs_realtime("https://api.example.com/gtfs-realtime/trip-updates", "trip_updates.pb")

# Read the downloaded feed
feed = read_gtfs_realtime("trip_updates.pb")

# Access feed data
println("Feed version: ", feed.header.gtfs_realtime_version)
println("Number of entities: ", length(feed.entities))
```

## Installation

```julia
using Pkg
Pkg.add(url="https://github.com/moviro-hub/GTFSRealtimes.jl")
```

## GTFS Realtime Specification

This package implements the official GTFS Realtime specification:
https://gtfs.org/documentation/realtime/reference/

The protobuf definitions are automatically generated from the official specification at:
https://gtfs.org/documentation/realtime/gtfs-realtime.proto

## License

This package is licensed under the MIT License.
