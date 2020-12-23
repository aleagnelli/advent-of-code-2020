defmodule Day22Test do
  use ExUnit.Case, async: true
  doctest AdventOfCode.Day22

  test "part 1" do
    input = get_resource()
    res = AdventOfCode.Day22.part1(input)
    assert res == 32_495
  end

  test "part 2" do
    input = get_resource()
    res = AdventOfCode.Day22.part2(input)
    assert res == 32_665
  end

  def get_resource() do
    "priv/day_22.txt" |> File.read!()
  end
end
