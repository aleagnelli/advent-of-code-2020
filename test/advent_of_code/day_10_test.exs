defmodule Day10Test do
  use ExUnit.Case
  doctest AdventOfCode.Day10

  test "part 1" do
    input = get_resource()
    res = AdventOfCode.Day10.part1(input)
    assert res == 2240
  end

  test "part 2" do
    input = get_resource()
    res = AdventOfCode.Day10.part2(input)
    assert res == 99_214_346_656_768
  end

  def get_resource() do
    "priv/day_10.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
