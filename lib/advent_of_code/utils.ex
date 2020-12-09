defmodule Utils do
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
