defmodule Day18Test do
  use ExUnit.Case, async: true
  doctest AdventOfCode.Day18

  test "part 1" do
    input = get_resource()
    res = AdventOfCode.Day18.part1(input)
    assert res == 13_976_444_272_545
  end

  test "part 2" do
    input = get_resource()
    res = AdventOfCode.Day18.part2(input)
    assert res == 88_500_956_630_893
  end

  def get_resource() do
    "priv/day_18.txt" |> File.read!()
  end
end
