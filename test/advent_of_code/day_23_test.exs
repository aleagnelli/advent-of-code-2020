defmodule Day23Test do
  use ExUnit.Case, async: true
  doctest AdventOfCode.Day23

  test "part 1" do
    input = "952438716"
    res = AdventOfCode.Day23.part1(input)
    assert res == "97342568"
  end

  test "part 2" do
    input = "952438716"
    res = AdventOfCode.Day23.part2(input)
    assert res == 902_208_073_192
  end
end
