defmodule Day17Test do
  use ExUnit.Case, async: true
  doctest AdventOfCode.Day17

  test "part 1" do
    input = get_resource()
    res = AdventOfCode.Day17.part1(input)
    assert res == 304
  end

  test "part 2" do
    input = get_resource()
    res = AdventOfCode.Day17.part2(input)
    assert res == 1868
  end

  def get_resource() do
    "priv/day_17.txt" |> File.read!()
  end
end
