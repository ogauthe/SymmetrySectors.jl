using SymmetrySectors: SymmetrySectors
using Aqua: Aqua
using Test: @testset

@testset "Code quality (Aqua.jl)" begin
  Aqua.test_all(SymmetrySectors)
end
