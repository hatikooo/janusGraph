defmodule Dealer.Deck do
  import Dealer.Card, only: [card: 2, sort_fn: 1]
  @ranks (1..13)
  @suits ~w[spades hearts diamonds clubs]a
  
  def deck() do
    for rank <- @ranks, suit <- @suits do
      card(rank, suit)
    end
  end
  
  def deal(deck, hands, cards, ordering \\ :default) do
    deck
    |> shuffle
    |> Enum.chunk_every(cards)
    |> Enum.take(hands)
    |> Enum.map(&sort(&1, ordering))
  end
  
  def sort(deck, ordering) do
    Enum.sort(deck, sort_fn(ordering))
  end
  
  def shuffle(deck), do: Enum.shuffle(deck)

  # h for hand
  def sigil_h(string, _opts) do
    string
    |> String.split(" ")
    |> Enum.map(&Dealer.Card.sigil_k(&1))
  end
  
  def deck_loaded, do: true
end