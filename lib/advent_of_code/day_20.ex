defmodule AdventOfCode.Day20 do
  def part1(input) do
    input
    |> parse_input()
    |> Enum.map(&generate_all_faces/1)
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

  defp generate_all_faces({name, tile}) do
    faces = [
      top_border(tile),
      bottom_border(tile),
      left_border(tile),
      right_border(tile)
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

  def part2(input) do
    tiles = parse_input(input)

    [corner | _] =
      tiles
      |> Enum.map(&generate_all_faces/1)
      |> get_corners()

    tiles = tiles |> Enum.map(&generate_all_orientation/1) |> Map.new()

    starting_tile_info = Map.get(tiles, corner) |> hd()

    full_image = build_image(Map.delete(tiles, corner), starting_tile_info)

    monsters =
      generate_all_orientation(full_image)
      |> Enum.map(& &1.tile)
      |> Enum.map(&count_sea_monsters/1)
      |> Enum.max()

    count_normal_roughness(full_image) - monsters * 15
  end

  defp build_image(tiles, starting_tile, image \\ [])

  defp build_image(tiles, starting_tile_info, image) do
    {row, tiles} = build_row(tiles, starting_tile_info)

    next =
      Enum.find_value(tiles, fn {name, candidates} ->
        match = Enum.find(candidates, fn c -> c.bottom == starting_tile_info.top end)
        match && {name, match}
      end)

    case next do
      nil -> complete_image([row | image])
      {name, match} -> build_image(Map.delete(tiles, name), match, [row | image])
    end
  end

  defp complete_image(tiles) do
    tiles |> Enum.flat_map(fn row -> Enum.map(row, & &1.tile) |> complete_row() end)
  end

  defp complete_row(tiles) do
    tiles
    |> Enum.map(fn tile ->
      tile |> remove_top_border() |> remove_bottom_border() |> remove_side_borders()
    end)
    |> Enum.zip()
    |> Enum.map(&(Tuple.to_list(&1) |> Enum.join("")))
  end

  defp remove_top_border(tile), do: tl(tile)
  defp remove_bottom_border(tile), do: Enum.reverse(tile) |> tl() |> Enum.reverse()
  defp remove_side_borders(tile), do: Enum.map(tile, &String.slice(&1, 1..-2))

  defp build_row(pool_tiles, corner) when is_map(corner), do: build_row(pool_tiles, [corner])

  defp build_row(pool_tiles, row) when is_list(row) do
    last_tile = List.first(row)

    next =
      pool_tiles
      |> Enum.find_value(fn {name, candidates} ->
        match = Enum.find(candidates, fn c -> c.left == last_tile.right end)

        match && {name, match}
      end)

    case next do
      nil ->
        {Enum.reverse(row), pool_tiles}

      {name, next_tile} ->
        build_row(Map.delete(pool_tiles, name), [next_tile | row])
    end
  end

  def generate_all_orientation({name, original}), do: {name, generate_all_orientation(original)}

  def generate_all_orientation(original) do
    rotated_90 = rotate_90(original)
    rotated_180 = rotate_90(rotated_90)
    rotated_270 = rotate_90(rotated_180)

    rotated = [original, rotated_90, rotated_180, rotated_270]
    flipped = rotated |> Enum.map(&flip_tile/1)

    all_orientation = rotated ++ flipped
    all_orientation |> Enum.map(&build_meta_info/1)
  end

  @spec count_sea_monsters(list(String.t())) :: non_neg_integer()
  defp count_sea_monsters(image) do
    Enum.chunk_every(image, 3, 1, :discard)
    |> Enum.filter(fn [_t, m, _b] -> String.contains?(m, "###") end)
    |> Enum.map(fn parts -> search_sea_monsters(parts) end)
    |> Enum.sum()
  end

  defp search_sea_monsters(parts = [t, m, b]) do
    if String.length(t) < 20 do
      0
    else
      top = ~r(^..................#.)
      mid = ~r(^#....##....##....###)
      bot = ~r(^.#..#..#..#..#..#...)
      next_search = parts |> Enum.map(&String.slice(&1, 1..-1))

      if Regex.run(top, t) && Regex.run(mid, m) && Regex.run(bot, b) != nil do
        1 + search_sea_monsters(next_search)
      else
        search_sea_monsters(next_search)
      end
    end
  end

  defp count_normal_roughness(image) do
    image
    |> Enum.map(&(String.graphemes(&1) |> Enum.frequencies() |> Map.get("#")))
    |> Enum.sum()
  end

  @spec flip_tile(list(String.t())) :: list(String.t())
  defp flip_tile(tile), do: Enum.map(tile, &String.reverse/1)

  @spec rotate_90(list(String.t())) :: list(String.t())
  defp rotate_90(tile) do
    tile
    |> Enum.map(&String.graphemes/1)
    |> Enum.zip()
    |> Enum.map(&(Tuple.to_list(&1) |> Enum.join() |> String.reverse()))
  end

  defp build_meta_info(tile) do
    %{
      tile: tile,
      top: top_border(tile),
      bottom: bottom_border(tile),
      left: left_border(tile),
      right: right_border(tile)
    }
  end

  defp left_border(tile), do: Enum.map(tile, &String.first/1) |> Enum.join()
  defp right_border(tile), do: Enum.map(tile, &String.last/1) |> Enum.join()
  defp top_border(tile), do: List.first(tile)
  defp bottom_border(tile), do: List.last(tile)
end
