@testset "TopologicalRelation" begin
  @testset "HalfEdgeStructure" begin
    # 2 triangles
    elems = connect.([(1,2,3),(4,3,2)])
    struc = HalfEdgeStructure(elems)
    ∂ = Boundary{2,0}(struc)
    @test ∂(1) == [2,3,1]
    @test ∂(2) == [3,2,4]
    ∂ = Boundary{2,1}(struc)
    @test ∂(1) == [1,3,2]
    @test ∂(2) == [1,4,5]
    𝒞 = Coboundary{0,1}(struc)
    @test 𝒞(1) == [2,3]
    @test 𝒞(2) == [4,1,2]
    @test 𝒞(3) == [3,1,5]
    @test 𝒞(4) == [5,4]
    𝒞 = Coboundary{0,2}(struc)
    @test 𝒞(1) == [1]
    @test 𝒞(2) == [2,1]
    @test 𝒞(3) == [1,2]
    @test 𝒞(4) == [2]
    𝒞 = Coboundary{1,2}(struc)
    @test 𝒞(1) == [2,1]
    @test 𝒞(2) == [1]
    @test 𝒞(3) == [1]
    @test 𝒞(4) == [2]
    @test 𝒞(5) == [2]
    𝒜 = Adjacency{0}(struc)
    @test 𝒜(1) == [2,3]
    @test 𝒜(2) == [4,3,1]
    @test 𝒜(3) == [1,2,4]
    @test 𝒜(4) == [3,2]

    # 2 triangles + 2 quadrangles
    elems = connect.([(1,2,6,5),(2,4,6),(4,3,5,6),(1,5,3)])
    struc = HalfEdgeStructure(elems)
    ∂ = Boundary{2,0}(struc)
    @test ∂(1) == [1,2,6,5]
    @test ∂(2) == [6,2,4]
    @test ∂(3) == [6,4,3,5]
    @test ∂(4) == [3,1,5]
    ∂ = Boundary{2,1}(struc)
    @test ∂(1) == [1,3,5,6]
    @test ∂(2) == [3,9,4]
    @test ∂(3) == [4,7,8,5]
    @test ∂(4) == [2,6,8]
    𝒞 = Coboundary{0,1}(struc)
    @test 𝒞(1) == [1,6,2]
    @test 𝒞(2) == [9,3,1]
    @test 𝒞(3) == [2,8,7]
    @test 𝒞(4) == [7,4,9]
    @test 𝒞(5) == [5,8,6]
    @test 𝒞(6) == [3,4,5]
    𝒞 = Coboundary{0,2}(struc)
    @test 𝒞(1) == [1,4]
    @test 𝒞(2) == [2,1]
    @test 𝒞(3) == [4,3]
    @test 𝒞(4) == [3,2]
    @test 𝒞(5) == [3,1,4]
    @test 𝒞(6) == [2,1,3]
    𝒞 = Coboundary{1,2}(struc)
    @test 𝒞(1) == [1]
    @test 𝒞(2) == [4]
    @test 𝒞(3) == [2,1]
    @test 𝒞(4) == [2,3]
    @test 𝒞(5) == [3,1]
    @test 𝒞(6) == [4,1]
    @test 𝒞(7) == [3]
    @test 𝒞(8) == [3,4]
    @test 𝒞(9) == [2]
    𝒜 = Adjacency{0}(struc)
    @test 𝒜(1) == [2,5,3]
    @test 𝒜(2) == [4,6,1]
    @test 𝒜(3) == [1,5,4]
    @test 𝒜(4) == [3,6,2]
    @test 𝒜(5) == [6,3,1]
    @test 𝒜(6) == [2,4,5]
  end
end
