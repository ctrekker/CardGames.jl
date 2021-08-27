# CardGames.jl
My collection of card game simulations. Perhaps later this will turn into a general implementation of card game systems

## Usage
The project is divided into two major categories, the common utilities and the game-specific utilities. Common utilities include those which are used across every card game. For example, structures related to cards, decks, etc. are located in common.

### Common Components
To create a deck of cards...
```julia
using CardGames
deck = Deck()
```

This will be an unshuffled deck of cards as you would find in a new package. To shuffle them, use the reexported `shuffle` function.
```julia
deck = shuffle(deck)
```
Or in one step
```julia
deck = Deck() |> shuffle  # or shuffle(Deck())
```

### Game-Specific Components
Game-Specific components are documented in the `docs/` folder. Each game is packaged in a specific submodule. For example, to include GuessYourTricks components...
```julia
using CardGames
using .GuessYourTricks
# Now you have exported GuessYourTricks components
```
- [GuessYourTricks](./docs/GuessYourTricks.md)
