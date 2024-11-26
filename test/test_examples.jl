@eval module $(gensym())
using SymmetrySectors: SymmetrySectors
using Test: @test, @testset

@testset "examples" begin
  include(joinpath(pkgdir(SymmetrySectors), "examples", "README.jl"))
end
end
