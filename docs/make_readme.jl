using Literate: Literate
using SymmetrySectors: SymmetrySectors

Literate.markdown(
  joinpath(pkgdir(SymmetrySectors), "examples", "README.jl"),
  joinpath(pkgdir(SymmetrySectors));
  flavor=Literate.CommonMarkFlavor(),
  name="README",
)
