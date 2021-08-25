module Common

export Card, Suit, Deck

struct Card
    value::UInt8
    suit::UInt8
end

Suit = (
    SPADES = 0,
    DIAMONDS = 1,
    CLUBS = 2,
    HEARTS = 3,
)

function Deck()
    deck = Card[]
    for i in 1:13
        push!(deck, Card(i, Suit.SPADES))
    end
    for i in 1:13
        push!(deck, Card(i, Suit.DIAMONDS))
    end
    for i in 13:-1:1
        push!(deck, Card(i, Suit.CLUBS))
    end
    for i in 13:-1:1
        push!(deck, Card(i, Suit.HEARTS))
    end
    deck
end

end # module
