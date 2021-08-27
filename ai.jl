using Flux

using Pkg
Pkg.activate(".")

using CardGames
using .GuessYourTricks
using Random
using ProgressMeter

function random_game(players::Int, cards::Int)
	deck = shuffle(Deck())
	state_0 = GameState(deck, players, cards)
	state = state_0

	pms = possible_moves(state)
	while pms |> length > 0
		move = pms[rand(1:length(pms))]
		state = do_move(state, move)
		pms = possible_moves(state)
	end

	(state_0, state)
end

function hand_onehot(hand::Vector{Card})
	hand_encoded = zeros(Float32, 52)
	for card in hand
		hand_encoded[card.value * (card.suit + 1)] = 1.
	end
	hand_encoded
end
# function hands_onehot(hand)

function value_map(game_samples::Vector{Tuple{GameState, GameState}})
	first_player_hand(gamesample) = gamesample[1].hands[1]
	first_player_winner(gamesample) = Float32(argmax(gamesample[2].tricks) == 1)
	x = hcat(hand_onehot.(first_player_hand.(game_samples))...)
	y = transpose(first_player_winner.(game_samples))

	x, y
end

function main()
	# We will use a value-based policy optimization
	@info "Initializing value function"
	value_fn = Chain(
		Dense(52, 100, relu),
		Dense(100, 100, relu),
		Dense(100, 1, sigmoid)
	)

	game_count = 10000
	epochs = 10
	subepochs = 10

	game() = random_game(4, 4)
	get_game_samples(sample_size) = [game() for i in 1:sample_size]

	opt = ADAM(0.001)
	loss(x, y) = sum((value_fn(x) .- y) .^ 2)
	parameters = params(value_fn)


	@info "Training network"
	for epoch in 1:epochs
		@info "SET $epoch"
		game_samples = get_game_samples(game_count)
		x_train, y_train = value_map(game_samples)

		for subepoch in 1:subepochs
			@showprogress for i in 1:game_count
				x_data, y_data = x_train[:, i], y_train[:, i]

				grads = Flux.gradient(parameters) do
					loss(x_data, y_data)
				end
			
				# Update the parameters based on the chosen
				# optimiser (opt)
				Flux.Optimise.update!(opt, parameters, grads)
			end

			@show loss(x_train, y_train)
		end
	end
	

end

main()
