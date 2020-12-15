defmodule Day09Test do
  use ExUnit.Case, async: true
  doctest AdventOfCode.Day09

  test "part 1" do
    input = get_resource()
    res = AdventOfCode.Day09.part1(input, 25)
    assert res == 507_622_668
  end

  test "part 2" do
    input = get_resource()
    res = AdventOfCode.Day09.part2(input, 507_622_668)
    assert res == 76_688_505
  end

  def get_resource() do
    "priv/day_09.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
