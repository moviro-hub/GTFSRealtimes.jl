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

println("All tests completed successfully!")

# Include additional test files in this directory (test_*.jl files)
for file in filter(f -> startswith(f, "test_") && endswith(f, ".jl"), readdir(@__DIR__))
    # Avoid including this file again
    if file != basename(@__FILE__)
        include(joinpath(@__DIR__, file))
    end
end
