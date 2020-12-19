defmodule Day19Test do
  use ExUnit.Case, async: true
  doctest AdventOfCode.Day19

  test "part 1" do
    input = get_resource()
    res = AdventOfCode.Day19.part1(input)
    assert res == 139
  end

  test "part 2" do
    input = get_resource()
    res = AdventOfCode.Day19.part2(input)
    assert res == 289
  end

  def get_resource() do
    "priv/day_19.txt" |> File.read!()
  end
end
