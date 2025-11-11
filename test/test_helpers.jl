using GTFSRealtimes, Test

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
