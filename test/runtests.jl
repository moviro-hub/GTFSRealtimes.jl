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

# Include additional test files in this directory (test_*.jl files)
for file in filter(f -> startswith(f, "test_") && endswith(f, ".jl") && f != "runtests.jl", readdir(@__DIR__))
    include(joinpath(@__DIR__, file))
end
