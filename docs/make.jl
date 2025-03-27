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
    canonical="https://itensor.github.io/SymmetrySectors.jl",
    edit_link="main",
    assets=["assets/favicon.ico", "assets/extras.css"],
  ),
  pages=["Home" => "index.md", "Reference" => "reference.md"],
)

deploydocs(;
  repo="github.com/ITensor/SymmetrySectors.jl", devbranch="main", push_preview=true
)
