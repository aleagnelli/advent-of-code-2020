defmodule Day15Test do
  use ExUnit.Case
  doctest AdventOfCode.Day15

  test "part 1" do
    res = AdventOfCode.Day15.part1([1, 20, 8, 12, 0, 14])
    assert res == 492
  end

  test "part 2" do
    res = AdventOfCode.Day15.part2([1, 20, 8, 12, 0, 14])
    assert res == 63_644
  end
end
