defmodule AdventOfCode.Day11 do
  @doc """
      iex> AdventOfCode.Day11.part1(\"\"\"
      ...>                          L.LL.LL.LL
      ...>                          LLLLLLL.LL
      ...>                          L.L.L..L..
      ...>                          LLLL.LL.LL
      ...>                          L.LL.LL.LL
      ...>                          L.LLLLL.LL
      ...>                          ..L.L.....
      ...>                          LLLLLLLLLL
      ...>                          L.LLLLLL.L
      ...>                          L.LLLLL.LL
      ...>                          \"\"\")
      37
  """
  def part1(input) do
    input
    |> parse_input()
    |> loop_step()
    |> count_seated()
  end

  defp parse_input(input) do
    String.split(input, "\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, row_index} ->
      String.split(row, "", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {state, col_index} -> {{row_index, col_index}, state} end)
    end)
    |> Map.new()
  end

  defp loop_step(seats) do
    new_seats = step(seats)

    if seats == new_seats do
      new_seats
    else
      loop_step(new_seats)
    end
  end

  defp step(seats) do
    with_occupied =
      seats
      |> Enum.filter(fn {_, state} -> empty?(state) end)
      |> Enum.reduce(seats, fn {coordinates, _}, acc ->
        if everyone_around_empty?(seats, coordinates) do
          Map.put(acc, coordinates, "#")
        else
          acc
        end
      end)

    seats
    |> Enum.filter(fn {_, state} -> occupied?(state) end)
    |> Enum.reduce(with_occupied, fn {coordinates, _}, acc ->
      if count_occupied_around(seats, coordinates) >= 4 do
        Map.put(acc, coordinates, "L")
      else
        acc
      end
    end)
  end

  defp neighbours({row, col}) do
    [
      {row - 1, col - 1},
      {row - 1, col},
      {row - 1, col + 1},
      {row, col - 1},
      {row, col + 1},
      {row + 1, col - 1},
      {row + 1, col},
      {row + 1, col + 1}
    ]
  end

  defp everyone_around_empty?(seats, coordinates) do
    neighbours(coordinates)
    |> Enum.all?(fn neighbour ->
      state = Map.get(seats, neighbour, "L")
      empty?(state) or floor?(state)
    end)
  end

  defp count_occupied_around(seats, coordinates) do
    neighbours(coordinates) |> Enum.count(&occupied?(Map.get(seats, &1, "L")))
  end

  defp count_seated(seats) do
    Enum.count(seats, fn {_, state} -> occupied?(state) end)
  end

  defp occupied?(state), do: state == "#"
  defp floor?(state), do: state == "."
  defp empty?(state), do: state == "L"

  @doc """
      iex> AdventOfCode.Day11.part2(\"\"\"
      ...>                          L.LL.LL.LL
      ...>                          LLLLLLL.LL
      ...>                          L.L.L..L..
      ...>                          LLLL.LL.LL
      ...>                          L.LL.LL.LL
      ...>                          L.LLLLL.LL
      ...>                          ..L.L.....
      ...>                          LLLLLLLLLL
      ...>                          L.LLLLLL.L
      ...>                          L.LLLLL.LL
      ...>                          \"\"\")
      26
  """
  def part2(input) do
    input
    |> parse_input()
    |> loop_step_2()
    |> count_seated()
  end

  defp loop_step_2(seats) do
    new_seats = step_2(seats)

    if seats == new_seats do
      new_seats
    else
      loop_step_2(new_seats)
    end
  end

  defp step_2(seats) do
    with_occupied =
      seats
      |> Enum.filter(fn {_, state} -> empty?(state) end)
      |> Enum.reduce(seats, fn {coordinates, _}, acc ->
        if everyone_around_empty_2?(seats, coordinates) do
          Map.put(acc, coordinates, "#")
        else
          acc
        end
      end)

    seats
    |> Enum.filter(fn {_, state} -> occupied?(state) end)
    |> Enum.reduce(with_occupied, fn {coordinates, _}, acc ->
      if count_occupied_around_2(seats, coordinates) >= 5 do
        Map.put(acc, coordinates, "L")
      else
        acc
      end
    end)
  end

  defp directions() do
    [
      {-1, -1},
      {-1, 0},
      {-1, +1},
      {0, -1},
      {0, +1},
      {+1, -1},
      {+1, 0},
      {+1, +1}
    ]
  end

  defp neighbours_in_sight(seats, coordinates) do
    directions()
    |> Enum.map(fn direction ->
      find_first_in_sight(seats, coordinates, direction)
    end)
  end

  defp find_first_in_sight(seats, {row, col}, dir = {r_dir, c_dir}) do
    coordinates = {row + r_dir, col + c_dir}

    if not floor?(Map.get(seats, coordinates, "L")) do
      coordinates
    else
      find_first_in_sight(seats, coordinates, dir)
    end
  end

  defp everyone_around_empty_2?(seats, coordinates) do
    neighbours_in_sight(seats, coordinates)
    |> Enum.all?(fn neighbour ->
      state = Map.get(seats, neighbour, "L")
      empty?(state) or floor?(state)
    end)
  end

  defp count_occupied_around_2(seats, coordinates) do
    neighbours_in_sight(seats, coordinates) |> Enum.count(&occupied?(Map.get(seats, &1, "L")))
  end
end
