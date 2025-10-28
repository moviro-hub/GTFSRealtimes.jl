using GTFSRealtimes, Test

@testset "Example Data Parsing" begin
    example_dir = joinpath(@__DIR__, "example")
    for file in filter(f -> endswith(f, ".pb"), readdir(example_dir))
        path = joinpath(example_dir, file)
        @testset "Parse $(file)" begin
            feed = read_gtfs_realtime(path)
            @test feed isa GTFSRealtime
            @test feed.header !== nothing
            @test feed.entities isa Vector{GTFSProtoBuf.FeedEntity}
            @test get_trip_updates(feed) isa Vector
            @test get_vehicle_positions(feed) isa Vector
            @test get_alerts(feed) isa Vector
        end
    end
end
