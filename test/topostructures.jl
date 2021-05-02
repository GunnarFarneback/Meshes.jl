@testset "Topostructures" begin
  function test_halfedge(connec, structure)
    @test nelements(structure) == length(connec)
    for e in 1:nelements(structure)
      inds = collect(indices(connec[e]))
      cvec = CircularVector(inds)
      segs = [connect((cvec[i], cvec[i+1]), Segment) for i in 1:length(cvec)]
      he = edgeonelem(structure, e)
      @test he.elem == e
      @test he.head ∈ inds
      @test boundary(connec[e], 0, s2) == inds
      @test boundary(connec[e], 1, s2) == segs
      for seg in segs
        @test boundary(seg, 0, structure) == collect(indices(seg))
      end
    end
  end

  connec = connect.([(1,2,3),(4,3,2)], Triangle)
  s1 = ElementListStructure(connec)
  s2 = convert(HalfEdgeStructure, s1)
  test_halfedge(connec, s2)
  @test adjacency(1, s2) == [2,3]
  @test adjacency(2, s2) == [4,3,1]
  @test adjacency(3, s2) == [1,2,4]
  @test adjacency(4, s2) == [3,2]
  s3 = convert(ElementListStructure, s2)
  @test s3 == s1

  connec = connect.([(1,2,6,5),(2,4,6),(4,3,5,6),(1,5,3)], Ngon)
  s1 = ElementListStructure(connec)
  s2 = convert(HalfEdgeStructure, s1)
  test_halfedge(connec, s2)
  s3 = convert(ElementListStructure, s2)
  @test s3 == s1
end
