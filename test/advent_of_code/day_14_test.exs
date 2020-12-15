defmodule Day14Test do
  use ExUnit.Case, async: true
  doctest AdventOfCode.Day14

  test "part 1" do
    input = get_resource()
    res = AdventOfCode.Day14.part1(input)
    assert res == 7_997_531_787_333
  end

  test "part 2" do
    input = get_resource()
    res = AdventOfCode.Day14.part2(input)
    assert res == 3_564_822_193_820
  end

  def get_resource() do
    "priv/day_14.txt" |> File.read!()
  end
end
