#!/usr/bin/env julia

using Pkg
# Activate the generation project environment
Pkg.activate(@__DIR__)
using ProtoBuf


# Get the project root directory
project_root = dirname(@__DIR__)
proto_dir = joinpath(@__DIR__, "proto")
output_dir = joinpath(project_root, "src")

# Check if proto file exists
gtfs_realtime_proto = joinpath(proto_dir, "gtfs-realtime.proto")

isfile(gtfs_realtime_proto) || error("gtfs-realtime.proto not found at $gtfs_realtime_proto")

try
    # Generate Julia code from proto file
    protojl(["gtfs-realtime.proto"], proto_dir, output_dir)
catch e
    error("Error generating protobuf files: $e")
end
