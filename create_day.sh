#!/usr/bin/env bash

day=$(printf "%02d" "${1}")
cat << EOF > "lib/advent_of_code/day_${day}.ex"
defmodule AdventOfCode.Day${day} do
  @doc """
      iex> AdventOfCode.Day${day}.part1()
      1
  """
  def part1(input) do
    0
  end

  @doc """
      iex> AdventOfCode.Day${day}.part2()
      1
  """
  def part2(input) do
    0
  end

end

EOF
touch "priv/day_${day}.txt"
cat << EOF > "test/advent_of_code/day_${day}_test.exs"
defmodule Day${day}Test do
  use ExUnit.Case
  doctest AdventOfCode.Day${day}

  test "part 1" do
    input = get_resource()
    res = AdventOfCode.Day${day}.part1(input)
    assert res == 1
  end

  test "part 2" do
    input = get_resource()
    res = AdventOfCode.Day${day}.part2(input)
    assert res == 1
  end

  def get_resource() do
    "priv/day_${day}.txt" |> File.read!()
  end
end

EOF
