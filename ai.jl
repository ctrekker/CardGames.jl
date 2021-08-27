using CardGames
using .GuessYourTricks
using Flux

# We will use a value-based policy optimization
@info "Initializing value function"
value_fn = Chain(
	Dense(52, 100, relu),
	Dense(100, 100, relu),
	Dense(100, 1, sigmoid)
)

game_count = 1000
@info "Sampling $game_count games"

function random_game(state::GameState)
	
end

