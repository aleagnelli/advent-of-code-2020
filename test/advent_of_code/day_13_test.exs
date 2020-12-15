defmodule Day13Test do
  use ExUnit.Case, async: true
  doctest AdventOfCode.Day13

  test "part 1" do
    input = get_resource()
    res = AdventOfCode.Day13.part1(input)
    assert res == 3215
  end

  test "part 2" do
    input = get_resource()
    res = AdventOfCode.Day13.part2(input)
    assert res == 1_001_569_619_313_439
  end

  def get_resource() do
    "priv/day_13.txt" |> File.read!()
  end
end
