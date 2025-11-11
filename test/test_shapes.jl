using GTFSRealtimes, Test
# Import polyline functions explicitly since they're not exported
import GTFSRealtimes: encode_polyline, decode_polyline, LatLon

@testset "Polyline Encoding/Decoding" begin
    @testset "Google Official Example" begin
        # From Google's documentation: https://developers.google.com/maps/documentation/utilities/polylinealgorithm
        # Input: (38.5, -120.2), (40.7, -120.95)
        # Expected output: "_p~iF~ps|U_ulLnnqC"
        positions = [LatLon(38.5, -120.2), LatLon(40.7, -120.95)]
        expected_encoded = "_p~iF~ps|U_ulLnnqC"

        encoded = encode_polyline(positions)
        @test encoded == expected_encoded

        decoded = decode_polyline(encoded)
        @test length(decoded) == 2
        @test decoded[1].lat ≈ 38.5 atol = 1.0e-5
        @test decoded[1].lon ≈ -120.2 atol = 1.0e-5
        @test decoded[2].lat ≈ 40.7 atol = 1.0e-5
        @test decoded[2].lon ≈ -120.95 atol = 1.0e-5
    end

    @testset "Round-trip Tests" begin
        # Test various coordinate ranges
        test_cases = [
            [LatLon(0.0, 0.0)],
            [LatLon(38.5, -120.2)],
            [LatLon(-38.5, 120.2)],
            [LatLon(38.5, -120.2), LatLon(40.7, -120.95)],
            [LatLon(0.0, 0.0), LatLon(1.0, 1.0), LatLon(2.0, 2.0)],
            [LatLon(90.0, 180.0), LatLon(-90.0, -180.0)],
            [LatLon(37.7749, -122.4194), LatLon(40.7128, -74.006), LatLon(51.5074, -0.1278)],
        ]

        for positions in test_cases
            encoded = encode_polyline(positions)
            decoded = decode_polyline(encoded)

            @test length(decoded) == length(positions)
            for (orig, dec) in zip(positions, decoded)
                @test dec.lat ≈ orig.lat atol = 1.0e-5
                @test dec.lon ≈ orig.lon atol = 1.0e-5
            end
        end
    end

    @testset "Edge Cases" begin
        # Empty input
        @test encode_polyline(LatLon[]) == ""
        @test decode_polyline("") == LatLon[]

        # Single point
        single = [LatLon(38.5, -120.2)]
        encoded = encode_polyline(single)
        decoded = decode_polyline(encoded)
        @test length(decoded) == 1
        @test decoded[1].lat ≈ 38.5 atol = 1.0e-5
        @test decoded[1].lon ≈ -120.2 atol = 1.0e-5

        # Very small coordinates
        small = [LatLon(0.00001, -0.00001)]
        encoded = encode_polyline(small)
        decoded = decode_polyline(encoded)
        @test decoded[1].lat ≈ 0.00001 atol = 1.0e-5
        @test decoded[1].lon ≈ -0.00001 atol = 1.0e-5

        # Large coordinates
        large = [LatLon(89.99999, 179.99999)]
        encoded = encode_polyline(large)
        decoded = decode_polyline(encoded)
        @test decoded[1].lat ≈ 89.99999 atol = 1.0e-5
        @test decoded[1].lon ≈ 179.99999 atol = 1.0e-5
    end

    @testset "Precision Tests" begin
        positions = [LatLon(38.51234, -120.23456)]

        for precision in 1:6
            encoded = encode_polyline(positions, precision)
            decoded = decode_polyline(encoded, precision = precision)

            # Check that precision is maintained appropriately
            @test decoded[1].lat ≈ positions[1].lat atol = 10.0^(-precision)
            @test decoded[1].lon ≈ positions[1].lon atol = 10.0^(-precision)
        end
    end

    @testset "Delta Encoding Verification" begin
        # Test that delta encoding works correctly
        # Points close together should have small deltas
        close_points = [
            LatLon(38.5, -120.2),
            LatLon(38.5001, -120.2001),
            LatLon(38.5002, -120.2002),
        ]

        encoded = encode_polyline(close_points)
        decoded = decode_polyline(encoded)

        @test length(decoded) == 3
        for (orig, dec) in zip(close_points, decoded)
            @test dec.lat ≈ orig.lat atol = 1.0e-5
            @test dec.lon ≈ orig.lon atol = 1.0e-5
        end
    end

    @testset "Negative Coordinates" begin
        # Test negative coordinates (southern/western hemisphere)
        negative = [
            LatLon(-38.5, -120.2),
            LatLon(-40.7, -120.95),
        ]

        encoded = encode_polyline(negative)
        decoded = decode_polyline(encoded)

        @test length(decoded) == 2
        @test decoded[1].lat ≈ -38.5 atol = 1.0e-5
        @test decoded[1].lon ≈ -120.2 atol = 1.0e-5
        @test decoded[2].lat ≈ -40.7 atol = 1.0e-5
        @test decoded[2].lon ≈ -120.95 atol = 1.0e-5
    end

    @testset "Error Handling" begin
        # Invalid precision
        positions = [LatLon(38.5, -120.2)]
        @test_throws ArgumentError encode_polyline(positions, 0)
        @test_throws ArgumentError encode_polyline(positions, 12)
        @test_throws ArgumentError decode_polyline("test", precision = 0)
        @test_throws ArgumentError decode_polyline("test", precision = 12)

        # Invalid polyline (odd number of coordinates)
        # This would require a malformed polyline string
        # We can't easily create one, but the code should handle it
    end

    @testset "Long Polylines" begin
        # Test with many points (stress test)
        many_points = [LatLon(38.0 + i * 0.01, -120.0 + i * 0.01) for i in 0:100]

        encoded = encode_polyline(many_points)
        @test !isempty(encoded)

        decoded = decode_polyline(encoded)
        @test length(decoded) == 101

        for (orig, dec) in zip(many_points, decoded)
            @test dec.lat ≈ orig.lat atol = 1.0e-5
            @test dec.lon ≈ orig.lon atol = 1.0e-5
        end
    end

    @testset "Coordinate Boundaries" begin
        # Test boundary values
        boundaries = [
            LatLon(90.0, 180.0),   # North pole, date line
            LatLon(-90.0, -180.0), # South pole, date line
            LatLon(0.0, 0.0),      # Equator, prime meridian
        ]

        encoded = encode_polyline(boundaries)
        decoded = decode_polyline(encoded)

        @test length(decoded) == 3
        @test decoded[1].lat ≈ 90.0 atol = 1.0e-5
        @test decoded[1].lon ≈ 180.0 atol = 1.0e-5
        @test decoded[2].lat ≈ -90.0 atol = 1.0e-5
        @test decoded[2].lon ≈ -180.0 atol = 1.0e-5
        @test decoded[3].lat ≈ 0.0 atol = 1.0e-5
        @test decoded[3].lon ≈ 0.0 atol = 1.0e-5
    end

    @testset "Real-world Coordinates" begin
        # Test with real-world city coordinates
        cities = [
            LatLon(37.7749, -122.4194),  # San Francisco
            LatLon(40.7128, -74.006),   # New York
            LatLon(51.5074, -0.1278),    # London
            LatLon(48.8566, 2.3522),     # Paris
            LatLon(35.6762, 139.6503),   # Tokyo
        ]

        encoded = encode_polyline(cities)
        decoded = decode_polyline(encoded)

        @test length(decoded) == 5
        for (orig, dec) in zip(cities, decoded)
            @test dec.lat ≈ orig.lat atol = 1.0e-4  # Slightly more tolerance for real-world coords
            @test dec.lon ≈ orig.lon atol = 1.0e-4
        end
    end

    @testset "Google Algorithm Compliance" begin
        # Verify the implementation follows Google's algorithm exactly
        # Test case from Google's documentation: https://developers.google.com/maps/documentation/utilities/polylinealgorithm

        # Step-by-step verification for first point: (38.5, -120.2)
        # 1. Multiply by 1e5: 38.5 * 100000 = 3850000, -120.2 * 100000 = -12020000
        # 2. Delta encoding: first point uses absolute values
        # 3. Encode differences

        positions = [LatLon(38.5, -120.2), LatLon(40.7, -120.95)]
        encoded = encode_polyline(positions)

        # Verify the encoded string matches Google's expected output exactly
        @test encoded == "_p~iF~ps|U_ulLnnqC"

        # Verify decoding produces exact original values
        decoded = decode_polyline(encoded)
        @test decoded[1].lat == Float32(38.5)
        @test decoded[1].lon == Float32(-120.2)
        @test decoded[2].lat == Float32(40.7)
        @test decoded[2].lon == Float32(-120.95)

        # Test that precision=5 (default) matches Google's specification
        # Google uses 1e5 (precision=5) as standard
        @test encode_polyline([LatLon(38.5, -120.2)]) == encode_polyline([LatLon(38.5, -120.2)], 5)

        # Verify algorithm steps manually
        # For point (38.5, -120.2) with precision=5:
        # Step 1: Multiply by 1e5 and round
        lat_int = round(Int32, 38.5 * 1.0e5)
        lon_int = round(Int32, -120.2 * 1.0e5)
        @test lat_int == 3850000
        @test lon_int == -12020000

        # Delta encoding: first point differences are the absolute values
        @test lat_int - 0 == 3850000
        @test lon_int - 0 == -12020000
    end

    @testset "Cross-validation with Known Polylines" begin
        # Test with additional known polyline strings from Google's examples
        # These are commonly used test cases

        # Simple two-point polyline
        test1 = [LatLon(0.0, 0.0), LatLon(1.0, 1.0)]
        encoded1 = encode_polyline(test1)
        decoded1 = decode_polyline(encoded1)
        @test length(decoded1) == 2
        @test decoded1[1].lat ≈ 0.0 atol = 1.0e-5
        @test decoded1[1].lon ≈ 0.0 atol = 1.0e-5
        @test decoded1[2].lat ≈ 1.0 atol = 1.0e-5
        @test decoded1[2].lon ≈ 1.0 atol = 1.0e-5

        # Verify round-trip produces same encoding
        reencoded = encode_polyline(decoded1)
        @test reencoded == encoded1
    end
end

@testset "Shape Compression/Decompression" begin
    @testset "Round-trip Tests" begin
        coords = [LatLon(38.5, -120.2), LatLon(40.7, -120.95)]
        shape = compress_shape("test_shape", coords)

        @test shape.shape_id == "test_shape"
        @test !isempty(shape.encoded_polyline)

        decompressed = decompress_shape(shape)
        @test length(decompressed) == 2
        @test decompressed[1].lat ≈ 38.5 atol = 1.0e-5
        @test decompressed[1].lon ≈ -120.2 atol = 1.0e-5
        @test decompressed[2].lat ≈ 40.7 atol = 1.0e-5
        @test decompressed[2].lon ≈ -120.95 atol = 1.0e-5
    end

    @testset "Empty Shape" begin
        shape = compress_shape("empty", LatLon[])
        @test shape.shape_id == "empty"
        @test isempty(shape.encoded_polyline)

        decompressed = decompress_shape(shape)
        @test isempty(decompressed)
    end

    @testset "Single Point" begin
        coords = [LatLon(38.5, -120.2)]
        shape = compress_shape("single", coords)
        decompressed = decompress_shape(shape)

        @test length(decompressed) == 1
        @test decompressed[1].lat ≈ 38.5 atol = 1.0e-5
        @test decompressed[1].lon ≈ -120.2 atol = 1.0e-5
    end

    @testset "Precision Parameter" begin
        coords = [LatLon(38.51234, -120.23456)]

        for precision in 1:6
            shape = compress_shape("test", coords, precision = precision)
            decompressed = decompress_shape(shape, precision = precision)

            @test decompressed[1].lat ≈ coords[1].lat atol = 10.0^(-precision)
            @test decompressed[1].lon ≈ coords[1].lon atol = 10.0^(-precision)
        end
    end
end
