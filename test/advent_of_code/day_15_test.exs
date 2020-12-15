defmodule Day15Test do
  use ExUnit.Case
  doctest AdventOfCode.Day15

  test "part 1" do
    assert AdventOfCode.Day15.part1([1, 20, 8, 12, 0, 14]) == 492
  end

  @tag :skip
  @tag timeout: :infinity
  test "samples part 2" do
    assert AdventOfCode.Day15.part2([0, 3, 6]) == 175_594
    assert AdventOfCode.Day15.part2([1, 3, 2]) == 2578
    assert AdventOfCode.Day15.part2([2, 1, 3]) == 3_544_142
    assert AdventOfCode.Day15.part2([1, 2, 3]) == 261_214
    assert AdventOfCode.Day15.part2([2, 3, 1]) == 6_895_259
    assert AdventOfCode.Day15.part2([3, 2, 1]) == 18
    assert AdventOfCode.Day15.part2([3, 1, 2]) == 362
  end

  test "part 2" do
    assert AdventOfCode.Day15.part2([1, 20, 8, 12, 0, 14]) == 63_644
  end
end
