defmodule AdventOfCode.Day24 do
  @doc """
      iex> AdventOfCode.Day24.part1(\"\"\"
      ...>                          sesenwnenenewseeswwswswwnenewsewsw
      ...>                          neeenesenwnwwswnenewnwwsewnenwseswesw
      ...>                          seswneswswsenwwnwse
      ...>                          nwnwneseeswswnenewneswwnewseswneseene
      ...>                          swweswneswnenwsewnwneneseenw
      ...>                          eesenwseswswnenwswnwnwsewwnwsene
      ...>                          sewnenenenesenwsewnenwwwse
      ...>                          wenwwweseeeweswwwnwwe
      ...>                          wsweesenenewnwwnwsenewsenwwsesesenwne
      ...>                          neeswseenwwswnwswswnw
      ...>                          nenwswwsewswnenenewsenwsenwnesesenew
      ...>                          enewnwewneswsewnwswenweswnenwsenwsw
      ...>                          sweneswneswneneenwnewenewwneswswnese
      ...>                          swwesenesewenwneswnwwneseswwne
      ...>                          enesenwswwswneneswsenwnewswseenwsese
      ...>                          wnwnesenesenenwwnenwsewesewsesesew
      ...>                          nenewswnwewswnenesenwnesewesw
      ...>                          eneswnwswnwsenenwnwnwwseeswneewsenese
      ...>                          neswnwewnwnwseenwseesewsenwsweewe
      ...>                          wseweeenwnesenwwwswnew
      ...>                          \"\"\")
      10
  """
  def part1(input) do
    input
    |> parse_input()
    |> get_state()
    |> count_black()
  end

  defp parse_input(input) do
    input |> String.split("\n", trim: true) |> Enum.map(&parse_instruction/1)
  end

  defp parse_instruction(instruction, pos \\ {0, 0})
  defp parse_instruction("", pos), do: pos
  defp parse_instruction("se" <> rem, {x, y}), do: parse_instruction(rem, {x + 1, y - 1})
  defp parse_instruction("sw" <> rem, {x, y}), do: parse_instruction(rem, {x, y - 1})
  defp parse_instruction("ne" <> rem, {x, y}), do: parse_instruction(rem, {x, y + 1})
  defp parse_instruction("nw" <> rem, {x, y}), do: parse_instruction(rem, {x - 1, y + 1})

  # defp parse_instruction("n" <> rem, {x, y}), do: parse_instruction(rem, {x, y + 1})
  # defp parse_instruction("s" <> rem, {x, y}), do: parse_instruction(rem, {x, y - 1})
  defp parse_instruction("e" <> rem, {x, y}), do: parse_instruction(rem, {x + 1, y})
  defp parse_instruction("w" <> rem, {x, y}), do: parse_instruction(rem, {x - 1, y})

  defp get_state(instructions) do
    Enum.reduce(instructions, %{}, fn pos, state ->
      Map.update(state, pos, :black, fn
        :black -> :white
        :white -> :black
      end)
    end)
  end

  defp count_black(state) do
    Enum.count(state, fn {_, color} -> color == :black end)
  end

  @doc """
      iex> AdventOfCode.Day24.part2(\"\"\"
      ...>                          sesenwnenenewseeswwswswwnenewsewsw
      ...>                          neeenesenwnwwswnenewnwwsewnenwseswesw
      ...>                          seswneswswsenwwnwse
      ...>                          nwnwneseeswswnenewneswwnewseswneseene
      ...>                          swweswneswnenwsewnwneneseenw
      ...>                          eesenwseswswnenwswnwnwsewwnwsene
      ...>                          sewnenenenesenwsewnenwwwse
      ...>                          wenwwweseeeweswwwnwwe
      ...>                          wsweesenenewnwwnwsenewsenwwsesesenwne
      ...>                          neeswseenwwswnwswswnw
      ...>                          nenwswwsewswnenenewsenwsenwnesesenew
      ...>                          enewnwewneswsewnwswenweswnenwsenwsw
      ...>                          sweneswneswneneenwnewenewwneswswnese
      ...>                          swwesenesewenwneswnwwneseswwne
      ...>                          enesenwswwswneneswsenwnewswseenwsese
      ...>                          wnwnesenesenenwwnenwsewesewsesesew
      ...>                          nenewswnwewswnenesenwnesewesw
      ...>                          eneswnwswnwsenenwnwnwwseeswneewsenese
      ...>                          neswnwewnwnwseenwseesewsenwsweewe
      ...>                          wseweeenwnesenwwwswnew
      ...>                          \"\"\")
      2208
  """
  def part2(input) do
    input
    |> parse_input()
    |> get_state()
    |> flip_daily()
    |> count_black()
  end

  defp flip_daily(state, days \\ 100)
  defp flip_daily(state, 0), do: state

  defp flip_daily(state, days) do
    black_to_white =
      state
      |> Enum.filter(fn {_, color} -> color == :black end)
      |> Enum.map(fn {pos, _} -> {pos, count_black_neighbours(state, pos)} end)
      |> Enum.filter(fn {_, black_neighbours} -> black_neighbours == 0 or black_neighbours > 2 end)
      |> Enum.map(&elem(&1, 0))

    white_to_black =
      state
      |> Enum.filter(fn {_, color} -> color == :black end)
      |> Enum.flat_map(fn {pos, _} -> neighbours(pos) end)
      |> MapSet.new()
      |> Enum.filter(fn pos -> Map.get(state, pos, :white) == :white end)
      |> Enum.map(&{&1, count_black_neighbours(state, &1)})
      |> Enum.filter(fn {_, black_neighbours} -> black_neighbours == 2 end)
      |> Enum.map(&elem(&1, 0))

    state = Enum.reduce(black_to_white, state, &Map.put(&2, &1, :white))
    state = Enum.reduce(white_to_black, state, &Map.put(&2, &1, :black))

    flip_daily(state, days - 1)
  end

  defp neighbours({x, y}) do
    [
      {x + 1, y},
      {x - 1, y},
      {x, y + 1},
      {x, y - 1},
      {x - 1, y + 1},
      {x + 1, y - 1}
    ]
  end

  defp count_black_neighbours(state, pos) do
    neighbours(pos) |> Enum.count(&(Map.get(state, &1, :white) == :black))
  end
end
