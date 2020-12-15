defmodule AdventOfCode.Day15 do
  @doc """
      iex> AdventOfCode.Day15.part1([0, 3, 6])
      436
      iex> AdventOfCode.Day15.part1([1, 3, 2])
      1
      iex> AdventOfCode.Day15.part1([2, 1, 3])
      10
      iex> AdventOfCode.Day15.part1([1, 2, 3])
      27
      iex> AdventOfCode.Day15.part1([2, 3, 1])
      78
      iex> AdventOfCode.Day15.part1([3, 2, 1])
      438
      iex> AdventOfCode.Day15.part1([3, 1, 2])
      1836
  """
  def part1(input) do
    elves_game(input, 2020)
  end

  defp elves_game(input, number_of_turns) do
    initial_state =
      input
      |> Enum.with_index(1)
      |> Enum.reduce(%{}, fn {el, turn}, state -> Map.put(state, el, turn) end)

    play_until(initial_state, List.last(input), length(input), number_of_turns)
  end

  defp play_until(_state, last_number, turn, turn), do: last_number

  defp play_until(state, last_number, turn, number_of_turns) do
    new_number =
      case Map.fetch!(state, last_number) do
        {recent_turn, old_turn} -> recent_turn - old_turn
        _turn -> 0
      end

    this_turn = turn + 1

    new_state =
      Map.update(state, new_number, this_turn, fn
        {recent, _old} -> {this_turn, recent}
        old_turn -> {this_turn, old_turn}
      end)

    play_until(new_state, new_number, this_turn, number_of_turns)
  end

  def part2(input) do
    elves_game(input, 30_000_000)
  end
end
