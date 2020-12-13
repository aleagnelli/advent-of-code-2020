defmodule AdventOfCode.Day13 do
  @doc """
      iex> AdventOfCode.Day13.part1(\"\"\"
      ...>                          939
      ...>                          7,13,x,x,59,x,31,19
      ...>                          \"\"\")
      295
  """
  def part1(input) do
    {timestamp, busses_id} = input |> parse_input()

    {id, departure} =
      busses_id
      |> Enum.map(fn id -> {id, first_departure_after(id, timestamp)} end)
      |> Enum.min_by(&elem(&1, 1))

    (departure - timestamp) * id
  end

  defp parse_input(input) do
    [timestamp, busses] = input |> String.split("\n", trim: true)

    busses_id =
      busses
      |> String.split(",", trim: true)
      |> Enum.filter(&(&1 != "x"))
      |> Enum.map(&String.to_integer/1)

    {String.to_integer(timestamp), busses_id}
  end

  defp first_departure_after(id, timestamp, departure \\ 0)
  defp first_departure_after(_id, timestamp, departure) when departure >= timestamp, do: departure

  defp first_departure_after(id, timestamp, departure),
    do: first_departure_after(id, timestamp, departure + id)

  @doc """
      first input line is ignored
      iex> AdventOfCode.Day13.part2(\"\"\"
      ...>                          ignore
      ...>                          17,x,13,19
      ...>                          \"\"\")
      3417
      iex> AdventOfCode.Day13.part2(\"\"\"
      ...>                          ignore
      ...>                          67,7,59,61
      ...>                          \"\"\")
      754018
      iex> AdventOfCode.Day13.part2(\"\"\"
      ...>                          ignore
      ...>                          67,x,7,59,61
      ...>                          \"\"\")
      779210
      iex> AdventOfCode.Day13.part2(\"\"\"
      ...>                          ignore
      ...>                          67,7,x,59,61
      ...>                          \"\"\")
      1261476
      iex> AdventOfCode.Day13.part2(\"\"\"
      ...>                          ignore
      ...>                          1789,37,47,1889
      ...>                          \"\"\")
      1202161486
      iex> AdventOfCode.Day13.part2(\"\"\"
      ...>                          ignore
      ...>                          7,13,x,x,59,x,31,19
      ...>                          \"\"\")
      1068781
  """
  def part2(input) do
    busses_id = input |> parse_input_2()
    busses_id |> Enum.reduce(fn el, acc -> common_step(el, acc) end) |> elem(0)
  end

  def parse_input_2(input) do
    [_, busses] = input |> String.split("\n", trim: true)

    busses
    |> String.split(",", trim: true)
    |> Enum.with_index()
    |> Enum.filter(fn {id, _ndx} -> id != "x" end)
    |> Enum.map(fn {id, ndx} -> {String.to_integer(id), ndx} end)
  end

  defp common_step({id, ndx}, {step, delay}) do
    period = if delay == 0, do: step, else: delay

    new_id = step |> Stream.iterate(&(&1 + period)) |> Enum.find(&(rem(&1 + ndx, id) == 0))
    {new_id, lcm(period, id)}
  end

  defp lcm(a, b), do: div(a * b, Integer.gcd(a, b))
end
