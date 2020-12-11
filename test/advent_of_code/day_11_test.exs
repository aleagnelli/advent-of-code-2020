defmodule Day11Test do
  use ExUnit.Case
  doctest AdventOfCode.Day11

  test "part 1" do
    input = get_resource()
    res = AdventOfCode.Day11.part1(input)
    assert res == 2281
  end

  test "part 2" do
    input = get_resource()
    res = AdventOfCode.Day11.part2(input)
    assert res == 2085
  end

  def get_resource() do
    "priv/day_11.txt" |> File.read!()
  end
end
