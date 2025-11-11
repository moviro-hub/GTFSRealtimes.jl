using GTFSRealtimes, Test

# Test basic module loading
@testset "Module Loading" begin
    @test GTFSRealtimes isa Module
end

# Test type definitions
@testset "Type Definitions" begin
    @test GTFSRealtime isa Type

    # Test empty feed creation
    feed = GTFSRealtime()
    @test feed isa GTFSRealtime
    @test feed.header === nothing
    @test isempty(feed.entities)
end

# Test helper functions
@testset "Helper Functions" begin
    feed = GTFSRealtime()

    @test !has_trip_updates(feed)
    @test !has_vehicle_positions(feed)
    @test !has_alerts(feed)
    @test !has_shapes(feed)
    @test !has_stops(feed)
    @test !has_trip_modifications(feed)

    @test isempty(get_trip_updates(feed))
    @test isempty(get_vehicle_positions(feed))
    @test isempty(get_alerts(feed))
    @test isempty(get_shapes(feed))
    @test isempty(get_stops(feed))
    @test isempty(get_trip_modifications(feed))
end

# Test download function (basic validation)
@testset "Download Function" begin
    # Test error handling for invalid inputs
    @test_throws ArgumentError download_gtfs_realtime("", "test.pb")
    @test_throws ArgumentError download_gtfs_realtime("http://example.com", "")

    # Note: We don't test actual downloads to avoid network dependencies in tests
end

# Test read function (basic validation)
@testset "Read Function" begin
    # Test error handling for non-existent files
    @test_throws ArgumentError read_gtfs_realtime("nonexistent.pb")

    # Note: We don't test actual file reading without sample data
end

println("All tests completed successfully!")

# Include additional test files in this directory (e.g., test_reader.jl, test_download.jl, test_example_read.jl)
for file in filter(f -> startswith(f, "test_") && endswith(f, ".jl"), readdir(@__DIR__))
    # Avoid including this file again
    if file != basename(@__FILE__)
        include(joinpath(@__DIR__, file))
    end
end
