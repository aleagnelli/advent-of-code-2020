defmodule AdventOfCode.Day20 do
  def part1(input) do
    input
    |> parse_input()
    |> Enum.map(&generate_all_orientation/1)
    |> get_corners()
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce(fn el, el2 -> el * el2 end)
  end

  defp parse_input(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_tile/1)
  end

  defp parse_tile(tile) do
    [title | tile] = String.split(tile, "\n", trim: true)
    title = String.replace(title, ["Tile ", ":"], "")
    {title, tile}
  end

  defp generate_all_orientation({name, tile}) do
    faces = [
      List.first(tile),
      List.last(tile),
      tile |> Enum.map(&String.first/1) |> Enum.join(),
      tile |> Enum.map(&String.last/1) |> Enum.join()
    ]

    flipped = Enum.map(faces, &String.reverse/1)
    {name, faces ++ flipped}
  end

  defp get_corners(tiles) do
    tiles
    |> Enum.flat_map(&elem(&1, 1))
    |> Enum.frequencies()
    |> Enum.filter(fn {_f, count} -> count == 1 end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.map(fn face ->
      tiles |> Enum.find(fn {_name, faces} -> Enum.member?(faces, face) end)
    end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.frequencies()
    # we have also the flipped one which is being counted
    |> Enum.filter(fn {_n, count} -> count == 4 end)
    |> Enum.map(&elem(&1, 0))
  end

end
