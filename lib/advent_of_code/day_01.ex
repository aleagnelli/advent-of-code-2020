defmodule AdventOfCode.Day01 do
  @doc """
      iex> AdventOfCode.Day01.part1([1721, 979, 366, 299, 675, 1456])
      514579
  """
  def part1(expenses) do
    combinations(expenses, 2)
    |> Enum.filter(fn [a | [b]] -> a + b == 2020 end)
    |> Enum.map(fn [a | [b]] -> a * b end)
    |> hd
  end

  @doc """
      iex> AdventOfCode.Day01.part2([1721, 979, 366, 299, 675, 1456])
      241861950
  """
  def part2(expenses) do
    combinations(expenses, 3)
    |> Enum.filter(fn [a | [b | [c]]] -> a + b + c == 2020 end)
    |> Enum.map(fn [a | [b | [c]]] -> a * b * c end)
    |> hd
  end

  @doc """
      iex> AdventOfCode.Day01.combinations([1,2,3], 2)
      [[1,2], [1,3], [2,3]]
  """
  def combinations(_, 0), do: [[]]
  def combinations([], _size), do: []

  def combinations([head | tail], size) do
    current_combs = combinations(tail, size - 1) |> Enum.map(&[head | &1])
    current_combs ++ combinations(tail, size)
  end
end
