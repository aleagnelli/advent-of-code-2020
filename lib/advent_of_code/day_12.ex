defmodule AdventOfCode.Day12 do
  @doc """
      iex> AdventOfCode.Day12.part1(\"\"\"
      ...>                          F10
      ...>                          N3
      ...>                          F7
      ...>                          R90
      ...>                          F11
      ...>                          \"\"\")
      25
  """
  def part1(input) do
    {{final_x, final_y}, _dir} =
      input
      |> String.split("\n", trim: true)
      |> Enum.reduce({{0, 0}, :east}, fn instruction, {{x, y}, dir} ->
        {action, amount} = parse_instruction(instruction)

        cond do
          action == "N" or (action == "F" and dir == :north) -> {{x, y + amount}, dir}
          action == "S" or (action == "F" and dir == :south) -> {{x, y - amount}, dir}
          action == "E" or (action == "F" and dir == :east) -> {{x + amount, y}, dir}
          action == "W" or (action == "F" and dir == :west) -> {{x - amount, y}, dir}
          action == "R" -> {{x, y}, rotate(dir, :right, rotation_step(amount))}
          action == "L" -> {{x, y}, rotate(dir, :left, rotation_step(amount))}
        end
      end)

    abs(final_x) + abs(final_y)
  end

  defp rotation_step(amount), do: rem(floor(amount / 90), 4)

  defp rotate(dir, _dir, 0), do: dir
  defp rotate(:north, :right, amount) when amount > 0, do: rotate(:east, :right, amount - 1)
  defp rotate(:east, :right, amount) when amount > 0, do: rotate(:south, :right, amount - 1)
  defp rotate(:south, :right, amount) when amount > 0, do: rotate(:west, :right, amount - 1)
  defp rotate(:west, :right, amount) when amount > 0, do: rotate(:north, :right, amount - 1)

  defp rotate(:north, :left, amount) when amount > 0, do: rotate(:west, :left, amount - 1)
  defp rotate(:west, :left, amount) when amount > 0, do: rotate(:south, :left, amount - 1)
  defp rotate(:south, :left, amount) when amount > 0, do: rotate(:east, :left, amount - 1)
  defp rotate(:east, :left, amount) when amount > 0, do: rotate(:north, :left, amount - 1)

  defp parse_instruction(instruction) do
    {action, value} = instruction |> String.split_at(1)
    {action, String.to_integer(value)}
  end

  @doc """
      iex> AdventOfCode.Day12.part2(\"\"\"
      ...>                          F10
      ...>                          N3
      ...>                          F7
      ...>                          R90
      ...>                          F11
      ...>                          \"\"\")
      286
  """
  def part2(input) do
    {{final_x, final_y}, _dir} =
      input
      |> String.split("\n", trim: true)
      |> Enum.reduce({{0, 0}, {10, 1}}, fn instruction, {ferry = {x, y}, wp = {wp_x, wp_y}} ->
        {action, amount} = parse_instruction(instruction)

        cond do
          action == "N" -> {ferry, {wp_x, wp_y + amount}}
          action == "S" -> {ferry, {wp_x, wp_y - amount}}
          action == "E" -> {ferry, {wp_x + amount, wp_y}}
          action == "W" -> {ferry, {wp_x - amount, wp_y}}
          action == "F" -> {{x + amount * wp_x, y + amount * wp_y}, wp}
          action == "R" -> {ferry, rotate_rel(wp, :right, rotation_step(amount))}
          action == "L" -> {ferry, rotate_rel(wp, :left, rotation_step(amount))}
        end
      end)

    abs(final_x) + abs(final_y)
  end

  defp rotate_rel(pos, _dir, 0), do: pos
  defp rotate_rel(pos = {0, 0}, _dir, _amount), do: pos
  defp rotate_rel({x, y}, :right, amount), do: rotate_rel({y, -x}, :right, amount - 1)
  defp rotate_rel({x, y}, :left, amount), do: rotate_rel({-y, x}, :left, amount - 1)
end
