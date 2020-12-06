defmodule Day06Test do
  use ExUnit.Case
  doctest AdventOfCode.Day06

  test "part 1" do
    input = get_resource()
    res = AdventOfCode.Day06.part1(input)
    assert res == 6506
  end

  test "part 2" do
    input = get_resource()
    res = AdventOfCode.Day06.part2(input)
    assert res == 3243
  end

  def get_resource() do
    "priv/day_06.txt" |> File.read!()
  end
end
