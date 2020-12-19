defmodule AdventOfCode.Day01 do
  @doc """
      iex> AdventOfCode.Day01.part1([1721, 979, 366, 299, 675, 1456])
      514579
  """
  def part1(expenses) do
    AdventOfCode.Utils.combinations(expenses, 2)
    |> Enum.filter(fn [a | [b]] -> a + b == 2020 end)
    |> Enum.map(fn [a | [b]] -> a * b end)
    |> hd
  end

  @doc """
      iex> AdventOfCode.Day01.part2([1721, 979, 366, 299, 675, 1456])
      241861950
  """
  def part2(expenses) do
    AdventOfCode.Utils.combinations(expenses, 3)
    |> Enum.filter(fn [a | [b | [c]]] -> a + b + c == 2020 end)
    |> Enum.map(fn [a | [b | [c]]] -> a * b * c end)
    |> hd
  end
end
