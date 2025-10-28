using GTFSRealtimes, Test

@testset "Download Function Tests" begin
    @testset "Input Validation" begin
        # Test empty URL
        @test_throws ArgumentError download_gtfs_realtime("", "test.pb")

        # Test empty file path
        @test_throws ArgumentError download_gtfs_realtime("http://example.com", "")

        # Test invalid URL format (basic check)
        @test_throws ArgumentError download_gtfs_realtime("not-a-url", "test.pb")
    end

    @testset "Network Error Handling" begin
        # Test with non-existent domain
        @test_throws ArgumentError download_gtfs_realtime("http://nonexistent-domain-12345.com/feed", "test.pb")
    end

    # Note: We skip actual successful downloads to avoid network dependencies
    # In a real test environment, you might want to use a mock server or
    # a known test endpoint
end
