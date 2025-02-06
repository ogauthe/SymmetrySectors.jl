# This file defines type DualSector

using GradedUnitRanges: dual, nondual, sector_type

struct DualSector{NonDualSector<:AbstractSector} <: AbstractSector
  nondual::NonDualSector

  function DualSector(s::AbstractSector)
    return new{typeof(s)}(s)
  end
end

GradedUnitRanges.nondual(s::DualSector) = s.nondual
GradedUnitRanges.nondual(s::AbstractSector) = s

# ===================================  Base interface  =====================================
function Base.:(==)(s1::DualSector, s2::DualSector)
  return ==(nondual(s1), nondual(s2))
end

function Base.isless(s1::S, s2::S) where {S<:DualSector}
  return isless(nondual(s1), nondual(s2))
end

function Base.show(io::IO, s::DualSector)
  show(io, nondual(s))
  return print(io, "'")
end

# ================================  GradedUnitRanges interface  ============================
function GradedUnitRanges.sector_type(
  S::Type{<:DualSector{NonDualSector}}
) where {NonDualSector}
  return NonDualSector
end

GradedUnitRanges.dual(s::AbstractSector) = DualSector(s)
GradedUnitRanges.dual(s::DualSector) = nondual(s)

GradedUnitRanges.flip(s::AbstractSector) = dual(label_dual(s))
GradedUnitRanges.flip(s::DualSector) = label_dual(nondual(s))

GradedUnitRanges.isdual(s::AbstractSector) = false
GradedUnitRanges.isdual(s::DualSector) = true

# =============================  SymmetrySectors interface  ================================
label_dual(s::DualSector) = dual(label_dual(dual(s)))

SymmetryStyle(dual_type::Type{<:DualSector}) = SymmetryStyle(sector_type(dual_type))

function quantum_dimension(::NotAbelianStyle, s::DualSector)
  return quantum_dimension(NotAbelianStyle(), nondual(s))
end

trivial(dual_type::Type{<:DualSector}) = trivial(sector_type(dual_type))

×(s1::DualSector, s2::DualSector) = dual(nondual(s1) × nondual(s2))
×(s1::DualSector, s2::AbstractSector) = error("Not implemented")
×(s1::AbstractSector, s2::DualSector) = error("Not implemented")

# ===============================  Fusion rule interface  ==================================
fusion_rule(c1::DualSector, c2::AbstractSector) = fusion_rule(label_dual(nondual(c1)), c2)
fusion_rule(c1::AbstractSector, c2::DualSector) = fusion_rule(c1, label_dual(nondual(c2)))
function fusion_rule(c1::DualSector, c2::DualSector)
  return fusion_rule(label_dual(nondual(c1)), label_dual(nondual(c2)))
end
