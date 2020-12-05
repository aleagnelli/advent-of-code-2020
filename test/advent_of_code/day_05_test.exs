defmodule Day05Test do
  use ExUnit.Case
  doctest AdventOfCode.Day05

  test "part 1" do
    input = get_resource()
    res = AdventOfCode.Day05.part1(input)
    assert res == 848
  end

  test "part 2" do
    input = get_resource()
    res = AdventOfCode.Day05.part2(input)
    assert res == 682
  end

  def get_resource() do
    "priv/day_05.txt" |> File.read!()
  end
end
