"""
    download_gtfs_realtime(url::String, file::String)

Download a GTFS Realtime feed from a URL and save it to a file.

# Arguments
- `url::String`: URL of the GTFS Realtime feed
- `file::String`: Local file path to save the feed

# Examples
```julia
download_gtfs_realtime("https://api.example.com/gtfs-realtime/trip-updates", "trip_updates.pb")
```

# Throws
- `ArgumentError`: If the URL is invalid or download fails
"""
function download_gtfs_realtime(url::String, file::String)
    if isempty(url)
        throw(ArgumentError("URL cannot be empty"))
    end

    if isempty(file)
        throw(ArgumentError("File path cannot be empty"))
    end

    return try
        println("Downloading GTFS Realtime feed from: $url")
        Downloads.download(url, file)

        if !isfile(file)
            throw(ArgumentError("Download failed - file not created"))
        end

        file_size = filesize(file)
        println("✓ Successfully downloaded feed ($file_size bytes)")
        println("  Saved to: $file")

    catch e
        if isa(e, Downloads.RequestError)
            throw(ArgumentError("Failed to download from URL '$url': $(string(e))"))
        elseif isa(e, ArgumentError)
            rethrow(e)
        else
            throw(ArgumentError("Unexpected error downloading feed: $(string(e))"))
        end
    end
end

"""
    read_gtfs_realtime(file::String) -> GTFSRealtime

Read a GTFS Realtime feed from a protobuf file.

# Arguments
- `file::String`: Path to the GTFS Realtime protobuf file

# Returns
- `GTFSRealtime`: Parsed feed data with header and entities

# Examples
```julia
feed = read_gtfs_realtime("trip_updates.pb")
println("Feed version: ", feed.header.gtfs_realtime_version)
println("Number of entities: ", length(feed.entities))
```

# Throws
- `ArgumentError`: If the file doesn't exist or cannot be read
- `ProtoBuf.ProtoError`: If the file is not valid protobuf data
"""
function read_gtfs_realtime(file::String)::GTFSRealtime
    if !isfile(file)
        throw(ArgumentError("File '$file' does not exist"))
    end

    try
        # Read the binary protobuf data
        data = read(file)

        if isempty(data)
            throw(ArgumentError("File '$file' is empty"))
        end

        # Decode the protobuf message
        feed_message = decode_protobuf(data)

        # Extract header and entities
        header = feed_message.header
        entities = collect(feed_message.entity)

        return GTFSRealtime(header, entities)

    catch e
        if isa(e, SystemError)
            throw(ArgumentError("Cannot read file '$file': $(e.msg)"))
        elseif isa(e, ArgumentError)
            rethrow(e)
        else
            throw(ArgumentError("Failed to parse GTFS Realtime feed: $e"))
        end
    end
end

# decode_protobuf function is implemented in the main module where GTFSProtoBuf is available
