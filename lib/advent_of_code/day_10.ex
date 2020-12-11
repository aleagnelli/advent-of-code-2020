defmodule AdventOfCode.Day10 do
  @doc """
      iex> AdventOfCode.Day10.part1([16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4])
      35
      iex> AdventOfCode.Day10.part1(
      ...>   [28, 33, 18, 42, 31, 14, 46, 20, 48, 47, 24, 23, 49, 45, 19, 38, 39, 11, 1, 32, 25, 35, 8, 17, 7, 9, 4, 2, 34, 10, 3]
      ...> )
      220
  """
  def part1(input) do
    sorted_jolts = input |> Enum.sort() |> List.insert_at(0, 0)
    pair_jolts = sorted_jolts |> Enum.zip(tl(sorted_jolts))
    one_jolts = pair_jolts |> Enum.count(fn {a, b} -> b - a == 1 end)
    three_jolts = pair_jolts |> Enum.count(fn {a, b} -> b - a == 3 end)
    one_jolts * (three_jolts + 1)
  end

  @doc """
      iex> AdventOfCode.Day10.part2([16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4])
      8
      iex> AdventOfCode.Day10.part2(
      ...>   [28, 33, 18, 42, 31, 14, 46, 20, 48, 47, 24, 23, 49, 45, 19, 38, 39, 11, 1, 32, 25, 35, 8, 17, 7, 9, 4, 2, 34, 10, 3]
      ...> )
      19208
  """
  def part2(input) do
    jolts_graph = input |> Enum.sort() |> List.insert_at(0, 0) |> build_graph()
    {:ok, pid} = Agent.start(fn -> %{} end)
    count_ways(jolts_graph, 0, pid)
  end

  defp build_graph(jolts, graph \\ %{})
  defp build_graph([], graph), do: graph

  defp build_graph([jolt | remaining], graph) do
    children = remaining |> Enum.take_while(&(&1 <= jolt + 3))
    build_graph(remaining, Map.put(graph, jolt, children))
  end

  defp count_ways(jolts, curr_node, cache) do
    case Agent.get(cache, &Map.get(&1, curr_node)) do
      nil ->
        children = Map.get(jolts, curr_node)

        count =
          case children do
            [] -> 1
            _ -> Enum.map(children, &count_ways(jolts, &1, cache)) |> Enum.sum()
          end

        Agent.update(cache, &Map.put(&1, curr_node, count))
        count

      count ->
        count
    end
  end
end
