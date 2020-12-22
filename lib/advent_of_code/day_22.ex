defmodule AdventOfCode.Day22 do
  @doc """
      iex> AdventOfCode.Day22.part1(\"\"\"
      ...>                          Player 1:
      ...>                          9
      ...>                          2
      ...>                          6
      ...>                          3
      ...>                          1
      ...>
      ...>                          Player 2:
      ...>                          5
      ...>                          8
      ...>                          4
      ...>                          7
      ...>                          10
      ...>                          \"\"\")
      306
  """
  def part1(input) do
    [p1, p2] = input |> parse_input()
    combat(p1, p2) |> score()
  end

  defp parse_input(input) do
    input |> String.split("\n\n", trim: true) |> Enum.map(&parse_player/1)
  end

  defp parse_player(player) do
    player
    |> String.split("\n", trim: true)
    |> Enum.drop(1)
    |> Enum.map(&String.to_integer/1)
  end

  defp combat([], winning_deck), do: winning_deck
  defp combat(winning_deck, []), do: winning_deck

  defp combat([c1 | deck1], [c2 | deck2]) when c1 > c2, do: combat(deck1 ++ [c1, c2], deck2)
  defp combat([c1 | deck1], [c2 | deck2]) when c1 < c2, do: combat(deck1, deck2 ++ [c2, c1])

  defp score(deck) do
    deck
    |> Enum.reverse()
    |> Enum.with_index(1)
    |> Enum.map(fn {a, b} -> a * b end)
    |> Enum.sum()
  end

  @doc """
     iex> AdventOfCode.Day22.part2(\"\"\"
     ...>                          Player 1:
     ...>                          43
     ...>                          19
     ...>
     ...>                          Player 2:
     ...>                          2
     ...>                          29
     ...>                          14
     ...>                          \"\"\")
     105

     iex> AdventOfCode.Day22.part2(\"\"\"
     ...>                          Player 1:
     ...>                          9
     ...>                          2
     ...>                          6
     ...>                          3
     ...>                          1
     ...>
     ...>                          Player 2:
     ...>                          5
     ...>                          8
     ...>                          4
     ...>                          7
     ...>                          10
     ...>                          \"\"\")
     291
  """
  def part2(input) do
    [p1, p2] = input |> parse_input()
    recursive_combat(p1, p2) |> elem(1) |> score()
  end

  defp recursive_combat(deck1, deck2, previous \\ MapSet.new())
  defp recursive_combat([], winning_deck, _), do: {:w2, winning_deck}
  defp recursive_combat(winning_deck, [], _), do: {:w1, winning_deck}

  defp recursive_combat(deck1 = [c1 | rem1], deck2 = [c2 | rem2], previous) do
    cond do
      MapSet.member?(previous, {deck1, deck2}) -> {:w1, deck1}
      c1 <= length(rem1) and c2 <= length(rem2) -> subcombat(deck1, deck2, previous)
      true -> classic_combat(deck1, deck2, previous)
    end
  end

  defp subcombat(deck1 = [c1 | rem1], deck2 = [c2 | rem2], previous) do
    case recursive_combat(Enum.take(rem1, c1), Enum.take(rem2, c2)) do
      {:w1, _} ->
        recursive_combat(rem1 ++ [c1, c2], rem2, MapSet.put(previous, {deck1, deck2}))

      {:w2, _} ->
        recursive_combat(rem1, rem2 ++ [c2, c1], MapSet.put(previous, {deck1, deck2}))
    end
  end

  defp classic_combat(deck1 = [c1 | rem1], deck2 = [c2 | rem2], previous) when c1 > c2 do
    recursive_combat(rem1 ++ [c1, c2], rem2, MapSet.put(previous, {deck1, deck2}))
  end

  defp classic_combat(deck1 = [c1 | rem1], deck2 = [c2 | rem2], previous) when c1 < c2 do
    recursive_combat(rem1, rem2 ++ [c2, c1], MapSet.put(previous, {deck1, deck2}))
  end
end
