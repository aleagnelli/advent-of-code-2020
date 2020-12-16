defmodule Day16Test do
  use ExUnit.Case, async: true
  doctest AdventOfCode.Day16

  test "part 1" do
    input = get_resource()
    res = AdventOfCode.Day16.part1(input)
    assert res == 21_996
  end

  test "part 2" do
    input = get_resource()
    res = AdventOfCode.Day16.part2(input)
    assert res == 650_080_463_519
  end

  def get_resource() do
    "priv/day_16.txt" |> File.read!()
  end
end
