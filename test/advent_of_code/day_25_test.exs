defmodule Day25Test do
  use ExUnit.Case, async: true
  doctest AdventOfCode.Day25

  test "part 1" do
    input = {15_113_849, 4_206_373}
    res = AdventOfCode.Day25.part1(input)
    assert res == 1_890_859
  end
end
