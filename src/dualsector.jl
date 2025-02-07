# This file defines type DualSector

using GradedUnitRanges: dual, isdual, nondual, nondual_type

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
GradedUnitRanges.dual(s::AbstractSector) = DualSector(s)
GradedUnitRanges.dual(s::DualSector) = nondual(s)

GradedUnitRanges.dual_type(S::Type{<:AbstractSector}) = DualSector{S}
function GradedUnitRanges.dual_type(
  ::Type{<:DualSector{NonDualSector}}
) where {NonDualSector}
  return NonDualSector
end

GradedUnitRanges.flip(s::AbstractSector) = dual(label_dual(s))
GradedUnitRanges.flip(s::DualSector) = label_dual(nondual(s))

GradedUnitRanges.isdual(::Type{<:DualSector}) = true

GradedUnitRanges.sector_type(DS::Type{<:DualSector}) = nondual_type(DS)

# =============================  SymmetrySectors interface  ================================
label_dual(s::DualSector) = dual(label_dual(dual(s)))

SymmetryStyle(DS::Type{<:DualSector}) = SymmetryStyle(nondual_type(DS))

function quantum_dimension(::NotAbelianStyle, s::DualSector)
  return quantum_dimension(NotAbelianStyle(), nondual(s))
end

trivial(DS::Type{<:DualSector}) = trivial(nondual_type(DS))

×(s1::DualSector, s2::DualSector) = dual(nondual(s1) × nondual(s2))
×(s1::DualSector, s2::AbstractSector) = throw("Not implemented")
×(s1::AbstractSector, s2::DualSector) = throw("Not implemented")

# ===============================  Fusion rule interface  ==================================
fusion_rule(c1::DualSector, c2::AbstractSector) = fusion_rule(label_dual(nondual(c1)), c2)
fusion_rule(c1::AbstractSector, c2::DualSector) = fusion_rule(c1, label_dual(nondual(c2)))
function fusion_rule(c1::DualSector, c2::DualSector)
  return fusion_rule(label_dual(nondual(c1)), label_dual(nondual(c2)))
end
