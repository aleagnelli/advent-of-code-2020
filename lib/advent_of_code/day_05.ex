defmodule AdventOfCode.Day05 do
  def part1(input) do
    parse_input(input) |> Enum.max()
  end

  def part2(input) do
    sorted_seats = parse_input(input) |> Enum.sort()

    Enum.zip(sorted_seats, tl(sorted_seats))
    |> Enum.filter(fn {f, s} -> s - f == 2 end)
    |> Enum.map(fn {_f, s} -> s - 1 end)
    |> hd()
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_seat/1)
    |> Enum.map(&elem(&1, 2))
  end

  @doc """
      iex> AdventOfCode.Day05.parse_seat("FBFBBFFRLR")
      {44, 5, 357}
      iex> AdventOfCode.Day05.parse_seat("BFFFBBFRRR")
      {70, 7, 567}
      iex> AdventOfCode.Day05.parse_seat("FFFBBBFRRR")
      {14, 7, 119}
      iex> AdventOfCode.Day05.parse_seat("BBFFBBFRLL")
      {102, 4, 820}
  """
  def parse_seat(seat) do
    <<row_encoded::binary-size(7)>> <> col_encoded = seat
    row = translate_row(row_encoded)
    col = translate_col(col_encoded)
    id = row * 8 + col
    {row, col, id}
  end

  defp translate_row(row_encoded), do: translate(row_encoded, 0, 127, "F", "B")
  defp translate_col(col_encoded), do: translate(col_encoded, 0, 7, "L", "R")

  defp translate(encoded, lower_bound, upper_bound, lower_grapheme, upper_grapheme) do
    encoded
    |> String.graphemes()
    |> Enum.reduce({lower_bound, upper_bound}, fn element, {lb, ub} ->
      cond do
        element == upper_grapheme ->
          new_lower_bound = ub - Integer.floor_div(ub - lb, 2)
          {new_lower_bound, ub}

        element == lower_grapheme ->
          new_upper_bound = lb + Integer.floor_div(ub - lb, 2)
          {lb, new_upper_bound}
      end
    end)
    |> elem(0)
  end
end
