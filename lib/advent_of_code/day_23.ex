defmodule AdventOfCode.Day23 do
  def part1(input) do
    crab_game(input, 100)
  end

  @doc """
      iex> AdventOfCode.Day23.crab_game("389125467", 10)
      "92658374"
      iex> AdventOfCode.Day23.crab_game("389125467", 100)
      "67384529"
  """
  def crab_game(input, moves) do
    input
    |> parse_input()
    |> move(moves, input |> String.first() |> String.to_integer())
    |> assemble()
  end

  defp parse_input(input) do
    labels = input |> String.split("", trim: true) |> Enum.map(&String.to_integer/1)

    labels
    |> Enum.zip(tl(labels) ++ [hd(labels)])
    |> Map.new()
  end

  defp move(cup_state, 0, _), do: cup_state

  defp move(cup_state, move, current_cup) do
    head_slice = cup_state[current_cup]
    last_slice = cup_state[cup_state[head_slice]]

    destination =
      get_destination(current_cup, [head_slice, cup_state[head_slice], last_slice], cup_state)

    new_state =
      cup_state
      |> Map.put(current_cup, cup_state[last_slice])
      |> Map.put(last_slice, cup_state[destination])
      |> Map.put(destination, head_slice)

    move(new_state, move - 1, Map.get(new_state, current_cup))
  end

  defp get_destination(destination, slice, cup_state) do
    attempt = if destination != 1, do: destination - 1, else: map_size(cup_state)

    if attempt in slice do
      get_destination(attempt, slice, cup_state)
    else
      attempt
    end
  end

  defp assemble(cup_state, current \\ 1, acc \\ "") do
    if String.length(acc) == 8 do
      acc
    else
      next = cup_state[current]
      assemble(cup_state, next, acc <> Integer.to_string(next))
    end
  end

  @doc """
      iex> AdventOfCode.Day23.part2("389125467")
      149245887792
  """
  def part2(input) do
    crab_game_2(input, 10_000_000)
  end

  def crab_game_2(input, moves) do
    final =
      input
      |> parse_input_2()
      |> move(moves, input |> String.first() |> String.to_integer())

    final[1] * final[final[1]]
  end

  defp parse_input_2(input) do
    labels = input |> String.split("", trim: true) |> Enum.map(&String.to_integer/1)

    starting_order = labels |> Enum.zip(tl(labels))

    first = labels |> List.first()
    last = labels |> List.last()
    max = labels |> Enum.max()

    remaining_order = (max + 1)..999_999 |> Enum.map(&{&1, &1 + 1})

    ([{1_000_000, first}, {last, max + 1}] ++ starting_order ++ remaining_order) |> Map.new()
  end
end
