module CardGames

using Random
using Reexport

export shuffle
export GuessYourTricks

include("common.jl")
include("GuessYourTricks.jl")

@reexport using .Common

end # module
