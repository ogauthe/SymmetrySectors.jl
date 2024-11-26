@eval module $(gensym())
using SymmetrySectors: SymmetrySectors
using Aqua: Aqua
using Test: @testset

@testset "Code quality (Aqua.jl)" begin
  # TODO: Reenable once dependencies are registered"
  # Aqua.test_all(SymmetrySectors)
end
end
