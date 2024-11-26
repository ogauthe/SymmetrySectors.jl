using Literate: Literate
using SymmetrySectors: SymmetrySectors

Literate.markdown(
  joinpath(pkgdir(SymmetrySectors), "examples", "README.jl"),
  joinpath(pkgdir(SymmetrySectors), "docs", "src");
  flavor=Literate.DocumenterFlavor(),
  name="index",
)
