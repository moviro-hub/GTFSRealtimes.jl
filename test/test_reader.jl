using GTFSRealtimes, Test

@testset "Reader Function Tests" begin
    @testset "File Validation" begin
        # Test non-existent file
        @test_throws ArgumentError read_gtfs_realtime("nonexistent_file.pb")

        # Test empty file path
        @test_throws ArgumentError read_gtfs_realtime("")
    end

    @testset "Protobuf Parsing" begin
        # Create a temporary empty file
        temp_file = "temp_empty.pb"
        open(temp_file, "w") do f
            # Write empty content
        end

        try
            @test_throws ArgumentError read_gtfs_realtime(temp_file)
        finally
            rm(temp_file, force = true)
        end

        # Create a temporary file with invalid protobuf data
        temp_file = "temp_invalid.pb"
        open(temp_file, "w") do f
            write(f, "This is not protobuf data")
        end

        try
            @test_throws ArgumentError read_gtfs_realtime(temp_file)
        finally
            rm(temp_file, force = true)
        end
    end

    # Note: We don't test successful parsing without sample GTFS Realtime data
    # In a real test environment, you would include sample .pb files
    # with known GTFS Realtime content
end
