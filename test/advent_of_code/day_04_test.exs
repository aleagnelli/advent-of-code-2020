defmodule Day04Test do
  use ExUnit.Case, async: true
  doctest AdventOfCode.Day04

  test "part 1" do
    input = get_resource()
    res = AdventOfCode.Day04.part1(input)
    assert res == 245
  end

  test "part 2" do
    input = get_resource()
    res = AdventOfCode.Day04.part2(input)
    assert res == 133
  end

  def get_resource() do
    "priv/day_04.txt" |> File.read!()
  end
end
