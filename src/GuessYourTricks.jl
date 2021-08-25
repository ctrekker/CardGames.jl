module GuessYourTricks

export GameState, GameTreeNode

using Random
using CardGames.Common

mutable struct GameState
    hands::Vector{Vector{Card}}
    battle::Vector{Union{Card, Nothing}}
    tricks::Vector{UInt8}
    lead::Union{Nothing, Card}
    current_player::Int
end
function GameState(deck::Vector{Card}, players::Int, cards::Int)
    hands = [deck[(off):players:(players * cards)] for off in 1:players]
    GameState(hands, [nothing for i in 1:players], zeros(UInt8, players), nothing, 1)
end
Base.copy(x::T) where T = T([deepcopy(getfield(x, k)) for k ∈ fieldnames(T)]...)
function current_hand(state::GameState)
    state.hands[state.current_player]
end
function players(state::GameState)
    length(state.hands)
end
function current_player(state::GameState)
    state.current_player
end
function winner(battle::Vector{Union{Nothing, Card}}, lead::Card)
    argmax(map(battle) do card
        card.suit == lead.suit ? card.value : 0
    end)
end
# Returns a list of the cards a player could play
function possible_moves(state::GameState)
    # If nobody has played the player can make any move
    if all(isnothing.(state.tricks)) || isnothing(state.lead)
        return collect(1:length(current_hand(state)))
    end
    # If the player has a card of same suit then they must play those
    hand = current_hand(state)
    same_suited = filter(collect(1:length(hand))) do card_idx
        hand[card_idx].suit == state.lead.suit
    end
    if length(same_suited) > 0
        return same_suited
    end

    return collect(1:length(current_hand(state)))
end

struct GameTreeNode
    state::GameState
    nodes::Vector{GameTreeNode}
end
function Base.getindex(n::GameTreeNode, i::Int)
    n.nodes[i]
end

function do_move(state::GameState, move::Int)
    new_state = copy(state)

    played_card = new_state.hands[current_player(state)][move]
    new_state.battle[current_player(state)] = played_card
    if all(isnothing.(state.battle))
        new_state.lead = played_card
    end
    deleteat!(new_state.hands[current_player(state)], move)

    # Advance player
    new_state.current_player = new_state.current_player % players(state) + 1

    # End of round condition
    if !any(isnothing.(new_state.battle))
        winning_player = winner(new_state.battle, new_state.lead)
        new_state.tricks[winning_player] += 1
        new_state.lead = nothing
        if length(new_state.hands[1]) != 0
            new_state.battle = [nothing for i in 1:players(new_state)]
            new_state.current_player = winning_player
        end
    end

    new_state
end

function do_round(node::GameTreeNode)
    for move in possible_moves(node.state)
        push!(node.nodes, GameTreeNode(do_move(node.state, move), []))
    end
    node
end

s = GameState(shuffle(Deck()), 5, 7)
n = GameTreeNode(s, [])
# println(do_round(n)[1])


end # module
