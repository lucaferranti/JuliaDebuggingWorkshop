using JuliaDebuggingWorkshop, Test

@testset "ieeelog" begin
    @test ieeelog(1.0) == 0
    @test isnan(ieeelog(-1.0))
    @test ieeelog(1) == 0
end

@test "vectorsum" begin
    @test vectorsum([1, 2, 3], [1, 2, 3]) == [2, 4, 6]
    @test_throws DimensionMismatch vectorsum([1, 2, 3], [1, 2, 3, 4])
end

@test "myloop" begin
    @test myloop([1, 2, 3],  [0.1, 0.001, 0.2]) == 2
end
