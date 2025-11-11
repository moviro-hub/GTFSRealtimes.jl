using Documenter
using GTFSRealtimes

# Set up the documentation
makedocs(
    sitename = "GTFSRealtimes.jl",
    authors = "MOVIRO",
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", "false") == "true",
        canonical = "https://moviro-hub.github.io/GTFSRealtimes.jl/",
        assets = String[],
    ),
    pages = [
        "Home" => "index.md",
        "API Reference" => "api.md",
        "Examples" => "examples.md",
    ],
    checkdocs = :exports,
)

# Deploy documentation
deploydocs(
    repo = "github.com/moviro-hub/GTFSRealtimes.jl.git",
    devbranch = "main",
)
