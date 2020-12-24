defmodule Day24Test do
  use ExUnit.Case, async: true
  doctest AdventOfCode.Day24

  test "part 1" do
    input = get_resource()
    res = AdventOfCode.Day24.part1(input)
    assert res == 326
  end

  test "part 2" do
    input = get_resource()
    res = AdventOfCode.Day24.part2(input)
    assert res == 3979
  end

  def get_resource() do
    "priv/day_24.txt" |> File.read!()
  end
end
