defmodule Day07Test do
  use ExUnit.Case
  doctest AdventOfCode.Day07

  test "part 1" do
    input = get_resource()
    res = AdventOfCode.Day07.part1(input)
    assert res == 332
  end

  test "part 2" do
    input = get_resource()
    res = AdventOfCode.Day07.part2(input)
    assert res == 10_875
  end

  def get_resource() do
    "priv/day_07.txt" |> File.read!()
  end
end
