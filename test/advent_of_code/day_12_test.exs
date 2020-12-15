defmodule Day12Test do
  use ExUnit.Case, async: true
  doctest AdventOfCode.Day12

  test "part 1" do
    input = get_resource()
    res = AdventOfCode.Day12.part1(input)
    assert res == 1956
  end

  test "part 2" do
    input = get_resource()
    res = AdventOfCode.Day12.part2(input)
    assert res == 126_797
  end

  def get_resource() do
    "priv/day_12.txt" |> File.read!()
  end
end
