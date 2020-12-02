defmodule Day02Test do
  use ExUnit.Case
  doctest AdventOfCode.Day02

  test "part 1" do
    input = get_resource()
    res = AdventOfCode.Day02.part1(input)
    assert res == 410
  end

  test "part 2" do
    input = get_resource()
    res = AdventOfCode.Day02.part2(input)
    assert res == 694
  end

  def get_resource() do
    "priv/day_02.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [rule, psw] = String.split(line, ":", trim: true)
      {String.trim(psw), rule}
    end)
  end
end
