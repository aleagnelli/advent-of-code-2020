defmodule AdventOfCode.Day03 do
  @spec part1(map) :: non_neg_integer()
  def part1(map) do
    counter(map, {0, 0}, {3, 1}, 0)
  end

  @spec part2(map) :: non_neg_integer()
  def part2(map) do
    progressions = [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
    counts = for prog <- progressions, do: counter(map, {0, 0}, prog, 0)
    Enum.reduce(counts, 1, fn el, acc -> el * acc end)
  end

  defp counter(map, {_x, y}, _, acc) when map_size(map) <= y, do: acc

  defp counter(map, {x, y}, prog = {prog_x, prog_y}, acc) do
    row = Map.fetch!(map, y)

    full_row =
      if x < String.length(row) do
        row
      else
        repeat_until(row, x)
      end

    pos = full_row |> String.at(x)

    if pos == "#" do
      counter(map, {x + prog_x, y + prog_y}, prog, acc + 1)
    else
      counter(map, {x + prog_x, y + prog_y}, prog, acc)
    end
  end

  defp repeat_until(s, x), do: repeat_until(s, x, s)

  defp repeat_until(s, x, acc) do
    if x < String.length(acc) do
      acc
    else
      repeat_until(s, x, acc <> s)
    end
  end
end
