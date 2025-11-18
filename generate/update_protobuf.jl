#!/usr/bin/env julia

using Pkg
# Activate the generation project environment
Pkg.activate(@__DIR__)
using ProtoBuf

# Official GTFS Realtime protobuf URL
proto_url = "https://gtfs.org/documentation/realtime/gtfs-realtime.proto"
# Protobuf and output directories
proto_dir = joinpath(@__DIR__, "proto")
output_dir = joinpath(dirname(@__DIR__), "src")
# Proto filename
proto_file = "gtfs-realtime.proto"

# Download the .proto file
try
    Downloads.download(proto_url, joinpath(proto_dir, proto_file))
catch e
    error("Error downloading protobuf definition: $e")
end

# Generate Julia code from proto file
try
    protojl([proto_file], proto_dir, output_dir)
catch e
    error("Error generating protobuf files: $e")
end
