using SymmetrySectors: SymmetrySectors
using Documenter: Documenter, DocMeta, deploydocs, makedocs

DocMeta.setdocmeta!(
  SymmetrySectors, :DocTestSetup, :(using SymmetrySectors); recursive=true
)

include("make_index.jl")

makedocs(;
  modules=[SymmetrySectors],
  authors="ITensor developers <support@itensor.org> and contributors",
  sitename="SymmetrySectors.jl",
  format=Documenter.HTML(;
    canonical="https://ITensor.github.io/SymmetrySectors.jl",
    edit_link="main",
    assets=String[],
  ),
  pages=["Home" => "index.md"],
)

deploydocs(;
  repo="github.com/ITensor/SymmetrySectors.jl", devbranch="main", push_preview=true
)
