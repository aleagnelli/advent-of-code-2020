defmodule Day03Test do
  use ExUnit.Case, async: true
  doctest AdventOfCode.Day03

  test "sample part 1" do
    input = %{
      0 => "..##.......",
      1 => "#...#...#..",
      2 => ".#....#..#.",
      3 => "..#.#...#.#",
      4 => ".#...##..#.",
      5 => "..#.##.....",
      6 => ".#.#.#....#",
      7 => ".#........#",
      8 => "#.##...#...",
      9 => "#...##....#",
      10 => ".#..#...#.#"
    }

    res = AdventOfCode.Day03.part1(input)
    assert res == 7
  end

  test "part 1" do
    input = get_resource()
    res = AdventOfCode.Day03.part1(input)
    assert res == 242
  end

  test "sample part 2" do
    input = %{
      0 => "..##.......",
      1 => "#...#...#..",
      2 => ".#....#..#.",
      3 => "..#.#...#.#",
      4 => ".#...##..#.",
      5 => "..#.##.....",
      6 => ".#.#.#....#",
      7 => ".#........#",
      8 => "#.##...#...",
      9 => "#...##....#",
      10 => ".#..#...#.#"
    }

    res = AdventOfCode.Day03.part2(input)
    assert res == 336
  end

  test "part 2" do
    input = get_resource()
    res = AdventOfCode.Day03.part2(input)
    assert res == 2_265_549_792
  end

  def get_resource() do
    "priv/day_03.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.map(fn {row, ndx} -> {ndx, row} end)
    |> Map.new()
  end
end
