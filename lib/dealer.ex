defmodule Dealer do
  defmacro __using__(_opts) do
    quote do
      import Dealer.Card
      import Dealer.Deck
    end
  end
end
