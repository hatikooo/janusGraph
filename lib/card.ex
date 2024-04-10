defmodule Dealer.Card do
  defstruct suit: :spade, rank: 1
  
  def card(rank, suit) do
    __struct__(rank: rank, suit: suit)
  end
  
  def card(string), do: sigil_k(string)
  
  def card_name(card) do
    rank_name(card) <> suit_emoji(card)
  end
  
  defp suit_emoji(%{suit: :spades}), do: "♠️"
  defp suit_emoji(%{suit: :hearts}), do: "♥️"
  defp suit_emoji(%{suit: :diamonds}), do: "♦️"
  defp suit_emoji(%{suit: :clubs}), do: "♣️"
  
  defp rank_name(%{rank: 1}), do: "A"
  defp rank_name(%{rank: 11}), do: "J"
  defp rank_name(%{rank: 12}), do: "Q"
  defp rank_name(%{rank: 13}), do: "K"
  defp rank_name(%{rank: n}), do: to_string(n)
  
  def sort_fn(:poker), do: &poker_sort/2
  def sort_fn(:bridge), do: &bridge_sort/2
  def sort_fn(_default), do: &Kernel.>=/2
  
  def poker_sort(card1, card2) do
    rank_to_int(card1) >= rank_to_int(card2)
  end
  
  # bridge suits are alphabetical, strongest last
  def bridge_sort(card1, card2) do
    left = {card1.suit, rank_to_int(card1)}
    right = {card2.suit, rank_to_int(card2)}
    
    left >= right
  end
  
  defp rank_to_int(%{rank: 1}), do: 14
  defp rank_to_int(%{rank: rank}), do: rank
  
  # k for KARD (C is taken)
  def sigil_k(string_card, _options \\ []) do
    [string_rank, string_suit] = 
      case String.graphemes(string_card)  do
        ["1", "0", suit] -> ["10", suit]
        card_strings -> card_strings
      end
          
    card(string_to_rank(String.upcase string_rank), string_to_suit(String.upcase string_suit))
  end
  
  defp string_to_rank("A"), do: 1
  defp string_to_rank("J"), do: 11
  defp string_to_rank("Q"), do: 12
  defp string_to_rank("K"), do: 13
  defp string_to_rank(n), do: String.to_integer(n)
  
  defp string_to_suit("S"), do: :spades
  defp string_to_suit("H"), do: :hearts
  defp string_to_suit("D"), do: :diamonds
  defp string_to_suit("C"), do: :clubs
  
  def card_loaded, do: true
end

defimpl Inspect, for: Dealer.Card do
  def inspect(card, _opts) do
    Dealer.Card.card_name(card) <> " "
  end
end