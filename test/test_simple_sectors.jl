using GradedUnitRanges: dual, flip, isdual, nondual, sector_type
using SymmetrySectors:
  Fib,
  Ising,
  O2,
  SU,
  SU2,
  TrivialSector,
  DualSector,
  U1,
  Z,
  quantum_dimension,
  fundamental,
  istrivial,
  label_dual,
  trivial
using Test: @test, @testset, @test_throws
using TestExtras: @constinferred

@testset "Test SymmetrySectors Types" begin
  @testset "TrivialSector" begin
    q = TrivialSector()

    @test sector_type(q) === TrivialSector
    @test sector_type(typeof(q)) === TrivialSector
    @test (@constinferred quantum_dimension(q)) == 1
    @test q == q
    @test trivial(q) == q
    @test istrivial(q)

    @test label_dual(q) == q
    @test !isless(q, q)

    qb = dual(q)
    @test qb isa DualSector
    @test sector_type(qb) === TrivialSector
    @test isdual(qb)
    @test !isdual(q)
    @test qb == qb
    @test q != qb
    @test nondual(qb) == q
    @test dual(qb) == q
    @test !isless(qb, qb)
    @test flip(q) == qb
    @test flip(qb) == q
  end

  @testset "U(1)" begin
    q1 = U1(1)
    q2 = U1(2)
    q3 = U1(3)

    @test sector_type(q1) === U1{Int}
    @test sector_type(typeof(q1)) === U1{Int}
    @test quantum_dimension(q1) == 1
    @test quantum_dimension(q2) == 1
    @test (@constinferred quantum_dimension(q1)) == 1

    @test trivial(q1) == U1(0)
    @test trivial(U1) == U1(0)
    @test istrivial(U1(0))

    @test label_dual(U1(2)) == U1(-2)
    @test isless(U1(1), U1(2))
    @test !isless(U1(2), U1(1))
    @test U1(Int8(1)) == U1(1)
    @test U1(UInt32(1)) == U1(1)

    @test U1(0) == TrivialSector()
    @test TrivialSector() == U1(0)
    @test U1(-1) < TrivialSector()
    @test TrivialSector() < U1(1)
    @test U1(Int8(1)) < U1(Int32(2))

    q2b = dual(q2)
    @test q2b isa DualSector
    @test isdual(q2b)
    @test !isdual(q2)
    @test q2b == q2b
    @test q2b != q2
    @test q2b != U1(-2)
    @test nondual(q2b) == q2
    @test dual(q2b) == q2
    @test !isless(q2b, q2b)
    @test dual(q1) < q2b
    @test flip(q2) == dual(U1(-2))
    @test flip(q2b) == U1(-2)
  end

  @testset "Z₂" begin
    z0 = Z{2}(0)
    z1 = Z{2}(1)

    @test z0 == z0
    @test z0 != z1
    @test !(z0 < z0)
    @test !(z1 < z1)
    @test z0 < z1
    @test trivial(Z{2}) == Z{2}(0)
    @test istrivial(Z{2}(0))

    @test quantum_dimension(z0) == 1
    @test quantum_dimension(z1) == 1
    @test (@constinferred quantum_dimension(z0)) == 1

    @test label_dual(z0) == z0
    @test label_dual(z1) == z1

    @test label_dual(Z{2}(1)) == Z{2}(1)
    @test isless(Z{2}(0), Z{2}(1))
    @test !isless(Z{2}(1), Z{2}(0))
    @test Z{2}(0) == z0
    @test Z{2}(-3) == z1

    @test Z{2}(0) == TrivialSector()
    @test TrivialSector() < Z{2}(1)
    @test_throws MethodError U1(0) < Z{2}(1)
    @test Z{2}(0) != Z{2}(1)
    @test Z{2}(0) != Z{3}(0)
    @test Z{2}(0) != U1(0)

    z1b = dual(z1)
    @test z1b isa DualSector
    @test z1b == z1b
    @test z1 != z1b
    @test flip(z1) == z1b
    @test flip(z1b) == z1
  end

  @testset "O(2)" begin
    s0e = O2(0)
    s0o = O2(-1)
    s12 = O2(1//2)
    s1 = O2(1)

    @test trivial(O2) == s0e
    @test istrivial(s0e)

    @test (@constinferred quantum_dimension(s0e)) == 1
    @test (@constinferred quantum_dimension(s0o)) == 1
    @test (@constinferred quantum_dimension(s12)) == 2
    @test (@constinferred quantum_dimension(s1)) == 2

    @test (@constinferred label_dual(s0e)) == s0e
    @test (@constinferred label_dual(s0o)) == s0o
    @test (@constinferred label_dual(s12)) == s12
    @test (@constinferred label_dual(s1)) == s1

    @test s0o < s0e < s12 < s1
    @test s0e == TrivialSector()
    @test s0o < TrivialSector()
    @test TrivialSector() < s12

    s1b = dual(s1)
    @test s1b isa DualSector
    @test s1b == s1b
    @test s1b != s1
    @test flip(s1) == s1b
    @test flip(s1b) == s1
  end

  @testset "SU(2)" begin
    j1 = SU2(0)
    j2 = SU2(1//2)  # Rational will be cast to HalfInteger
    j3 = SU2(1)
    j4 = SU2(3//2)

    # alternative constructors
    @test j2 == SU{2}((1,))  # tuple SU(N)-like constructor
    @test j2 == SU{2,1}((1,))  # tuple constructor with explicit {N,N-1}
    @test j2 == SU((1,))  # infer N from tuple length
    @test j2 == SU{2}((Int8(1),))  # any Integer type accepted
    @test j2 == SU{2}((UInt32(1),))  # any Integer type accepted
    @test j2 == SU2(1 / 2)  # Float will be cast to HalfInteger
    @test_throws MethodError SU2((1,))  # avoid confusion between tuple and half-integer interfaces
    @test_throws MethodError SU{2,1}(1)  # avoid confusion

    @test trivial(SU{2}) == SU2(0)
    @test istrivial(SU2(0))
    @test fundamental(SU{2}) == SU2(1//2)

    @test quantum_dimension(j1) == 1
    @test quantum_dimension(j2) == 2
    @test quantum_dimension(j3) == 3
    @test quantum_dimension(j4) == 4
    @test (@constinferred quantum_dimension(j1)) == 1

    @test label_dual(j1) == j1
    @test label_dual(j2) == j2
    @test label_dual(j3) == j3
    @test label_dual(j4) == j4

    @test j1 < j2 < j3 < j4
    @test SU2(0) == TrivialSector()
    @test !(j2 < TrivialSector())
    @test TrivialSector() < j2
  end

  @testset "SU(N)" begin
    f3 = SU{3}((1, 0))
    f4 = SU{4}((1, 0, 0))
    ad3 = SU{3}((2, 1))
    ad4 = SU{4}((2, 1, 1))

    @test trivial(SU{3}) == SU{3}((0, 0))
    @test istrivial(SU{3}((0, 0)))
    @test trivial(SU{4}) == SU{4}((0, 0, 0))
    @test istrivial(SU{4}((0, 0, 0)))
    @test SU{3}((0, 0)) == TrivialSector()
    @test SU{4}((0, 0, 0)) == TrivialSector()

    @test fundamental(SU{3}) == f3
    @test fundamental(SU{4}) == f4

    @test label_dual(f3) == SU{3}((1, 1))
    @test label_dual(f4) == SU{4}((1, 1, 1))
    @test label_dual(ad3) == ad3
    @test label_dual(ad4) == ad4

    @test quantum_dimension(f3) == 3
    @test quantum_dimension(f4) == 4
    @test quantum_dimension(ad3) == 8
    @test quantum_dimension(ad4) == 15
    @test quantum_dimension(SU{3}((4, 2))) == 27
    @test quantum_dimension(SU{3}((3, 3))) == 10
    @test quantum_dimension(SU{3}((3, 0))) == 10
    @test quantum_dimension(SU{3}((0, 0))) == 1
    @test (@constinferred quantum_dimension(f3)) == 3
  end

  @testset "Fibonacci" begin
    ı = Fib("1")
    τ = Fib("τ")

    @test trivial(Fib) == ı
    @test istrivial(ı)
    @test ı == TrivialSector()

    @test label_dual(ı) == ı
    @test label_dual(τ) == τ

    @test (@constinferred quantum_dimension(ı)) == 1.0
    @test (@constinferred quantum_dimension(τ)) == ((1 + √5) / 2)

    @test ı < τ
  end

  @testset "Ising" begin
    ı = Ising("1")
    σ = Ising("σ")
    ψ = Ising("ψ")

    @test trivial(Ising) == ı
    @test istrivial(ı)
    @test ı == TrivialSector()

    @test label_dual(ı) == ı
    @test label_dual(σ) == σ
    @test label_dual(ψ) == ψ

    @test (@constinferred quantum_dimension(ı)) == 1.0
    @test (@constinferred quantum_dimension(σ)) == √2
    @test (@constinferred quantum_dimension(ψ)) == 1.0

    @test ı < σ < ψ
  end
end
