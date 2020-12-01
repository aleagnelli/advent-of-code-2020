defmodule Day01Test do
  use ExUnit.Case
  doctest AdventOfCode.Day01

  test "part 1" do
    input = get_resource()
    res = AdventOfCode.Day01.part1(input)
    assert res == 960_075
  end

  test "part 2" do
    input = get_resource()
    res = AdventOfCode.Day01.part2(input)
    assert res == 212_900_130
  end

  def get_resource() do
    "priv/day_01.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer(&1))
  end
end
