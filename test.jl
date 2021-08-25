using CardGames
using .GuessYourTricks

function exec()
    s = GameState(shuffle(Deck()), 5, 5)
    n = GameTreeNode(s, [])
    # println(do_round!(n)[1])
    @info "Starting expansion"
    @time expand_game_tree!(n)
    @info "Completed expansion"
end

exec()
