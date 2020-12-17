defmodule AdventOfCode.Day17 do
  @doc """
      iex> AdventOfCode.Day17.part1(\"\"\"
      ...>                          .#.
      ...>                          ..#
      ...>                          ###
      ...>                          \"\"\")
      112
  """
  def part1(input) do
    input |> parse_input() |> loop_cycles(6) |> MapSet.size()
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(&parse_row/1)
    |> MapSet.new()
  end

  defp parse_row({row, r_ndx}) do
    row
    |> String.split("", trim: true)
    |> Enum.with_index()
    |> Enum.filter(fn {state, _c_ndx} -> state == "#" end)
    |> Enum.map(fn {_state, c_ndx} -> {r_ndx, c_ndx, 0} end)
  end

  defp loop_cycles(cubes, 0), do: cubes
  defp loop_cycles(cubes, remaining), do: loop_cycles(cycle(cubes), remaining - 1)

  defp cycle(cubes) do
    survivor = cubes |> Enum.filter(&survive?(&1, cubes))
    spawned = get_activable(cubes)
    (survivor ++ spawned) |> MapSet.new()
  end

  defp survive?(cube, cubes) do
    neighbors_alive = neighbors(cube) |> Enum.count(&MapSet.member?(cubes, &1))
    2 <= neighbors_alive and neighbors_alive <= 3
  end

  defp neighbors({x, y, z}) do
    relative_positions()
    |> Enum.map(fn {rel_x, rel_y, rel_z} -> {x + rel_x, y + rel_y, z + rel_z} end)
  end

  defp relative_positions() do
    for rel_x <- -1..1,
        rel_y <- -1..1,
        rel_z <- -1..1 do
      {rel_x, rel_y, rel_z}
    end
    |> Enum.filter(&(&1 != {0, 0, 0}))
  end

  defp get_activable(cubes) do
    cubes
    |> Enum.flat_map(&neighbors(&1))
    |> Enum.group_by(& &1)
    |> Enum.map(fn {cube, l_cubes} -> {cube, length(l_cubes)} end)
    |> Enum.filter(fn {_cube, count} -> count == 3 end)
    |> Enum.map(&elem(&1, 0))
  end

  @doc """
     iex> AdventOfCode.Day17.part2(\"\"\"
     ...>                          .#.
     ...>                          ..#
     ...>                          ###
     ...>                          \"\"\")
     848
  """
  def part2(input) do
    input |> parse_input_2() |> loop_cycles_2(6) |> MapSet.size()
  end

  defp parse_input_2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(&parse_row_2/1)
    |> MapSet.new()
  end

  defp parse_row_2({row, r_ndx}) do
    row
    |> String.split("", trim: true)
    |> Enum.with_index()
    |> Enum.filter(fn {state, _c_ndx} -> state == "#" end)
    |> Enum.map(fn {_state, c_ndx} -> {r_ndx, c_ndx, 0, 0} end)
  end

  defp loop_cycles_2(cubes, 0), do: cubes
  defp loop_cycles_2(cubes, remaining), do: loop_cycles_2(cycle_2(cubes), remaining - 1)

  defp cycle_2(cubes) do
    survivor = cubes |> Enum.filter(&survive_2?(&1, cubes))
    spawned = get_activable_2(cubes)
    (survivor ++ spawned) |> MapSet.new()
  end

  defp survive_2?(cube, cubes) do
    neighbors_alive = neighbors_2(cube) |> Enum.count(&MapSet.member?(cubes, &1))
    2 <= neighbors_alive and neighbors_alive <= 3
  end

  defp neighbors_2({x, y, z, w}) do
    relative_positions_2()
    |> Enum.map(fn {rel_x, rel_y, rel_z, rel_w} ->
      {x + rel_x, y + rel_y, z + rel_z, w + rel_w}
    end)
  end

  defp relative_positions_2() do
    for rel_x <- -1..1,
        rel_y <- -1..1,
        rel_z <- -1..1,
        rel_w <- -1..1 do
      {rel_x, rel_y, rel_z, rel_w}
    end
    |> Enum.filter(&(&1 != {0, 0, 0, 0}))
  end

  defp get_activable_2(cubes) do
    cubes
    |> Enum.flat_map(&neighbors_2(&1))
    |> Enum.group_by(& &1)
    |> Enum.map(fn {cube, l_cubes} -> {cube, length(l_cubes)} end)
    |> Enum.filter(fn {_cube, count} -> count == 3 end)
    |> Enum.map(&elem(&1, 0))
  end
end
