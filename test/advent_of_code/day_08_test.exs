defmodule Day08Test do
  use ExUnit.Case, async: true
  doctest AdventOfCode.Day08

  test "part 1" do
    input = get_resource()
    res = AdventOfCode.Day08.part1(input)
    assert res == 1489
  end

  test "part 2" do
    input = get_resource()
    res = AdventOfCode.Day08.part2(input)
    assert res == 1539
  end

  def get_resource() do
    "priv/day_08.txt" |> File.read!()
  end
end
