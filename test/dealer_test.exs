defmodule DealerTest do
  use ExUnit.Case
  use Dealer
  # do not add any more imports here to make your tests work!
  # It's part of the exercise!
  
  # You can delete this test as part of the clean up to make sure it works. 
  test "use Dealer imports Dealer.Card and Dealer.Deck" do
    assert Dealer.Deck.deck_loaded()
    assert Dealer.Card.card_loaded()
    assert deck_loaded() and card_loaded()

    assert length(deck()) == 52
    assert ~k|qh|.__struct__ == Dealer.Card
  end
  
  test "Dealer.Card struct has a rank and a suit" do
    struct_keys = Map.keys(%Dealer.Card{})
    assert :rank in struct_keys
    assert :suit in struct_keys
  end
  
  test "Dealer.Card.card(r, s) creates a card given rank and suit" do
    assert card(1, :spades) == %Dealer.Card{rank: 1, suit: :spades}
  end
  
  test "create a new card with string" do
    assert card("ad").rank == 1 
    assert card("5h").rank == 5
    assert card("5h").suit == :hearts
    assert card("qc").rank == 12
  end
  
  test "k card sigil function creates card" do
    card = ~k|as| 
    
    assert card.suit == :spades
    assert card.rank == 1
  end
  
  test "implements the inspect protocol with emojis" do
    # note there's a space after the emoji... prints better. 
    assert inspect(~k|as|) == "A♠️ "
  end
  
  test "bridge sort is by suit then rank, ace high" do
    sorted_bridge_hand = 
      [~k|4h|, ~k|3s|, ~k|2d|, ~k|3d|, ~k|8c|]
      |> Enum.sort(sort_fn(:bridge))
      |> inspect
      
    assert sorted_bridge_hand == "[3♠️ , 4♥️ , 3♦️ , 2♦️ , 8♣️ ]"
  end
  
  test "poker sort is by rank, ace high, suit order unchanged" do
    sorted_poker_hand = 
      [~k|4h|,  ~k|3s|, ~k|2d|, ~k|8c|, ~k|4s|]
      |> Enum.sort(sort_fn(:poker))
      |> inspect

    assert sorted_poker_hand == "[8♣️ , 4♥️ , 4♠️ , 3♠️ , 2♦️ ]"
  end
  
  test "decks have the right number of ranks and suits" do
    assert length(deck()) == 52
    
    jack_count = 
      deck() 
      |> Enum.filter(&(&1.rank == 11)) 
      |> length
      
    assert jack_count == 4
    
    spade_count = 
      deck() 
      |> Enum.filter(&(&1.suit == :spades)) 
      |> length

    assert spade_count == 13
  end
  
  test "deck deal builds hands, sorted for game" do
    hands = deal deck(), 4, 13, :bridge
    hand = hd(hands)
    sorted_hand = sort(hand, :bridge)
    
    assert length(hands) == 4
    assert length(hand) == 13
    assert ^sorted_hand = hand
  end
  
  test "hand sigil creates hand" do
    expected = [card(2, :hearts), card(10, :spades)]
    actual = ~h|2h 10s|
    assert ^actual = expected
  end
end
