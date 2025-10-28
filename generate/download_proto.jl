#!/usr/bin/env julia

using Pkg
Pkg.activate(@__DIR__)
using Downloads

# Official GTFS Realtime protobuf URL
proto_url = "https://gtfs.org/documentation/realtime/gtfs-realtime.proto"

# Create proto directory
proto_dir = joinpath(@__DIR__, "proto")
mkpath(proto_dir)
# Download the .proto file
proto_file = joinpath(proto_dir, "gtfs-realtime.proto")
try
    # Download the .proto file
    Downloads.download(proto_url, proto_file)
    # option ;
    open(proto_file, "r+") do io
        lines = readlines(io)
    end
catch e
    error("Error downloading protobuf definition: $e")
end
