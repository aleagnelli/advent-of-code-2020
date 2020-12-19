defmodule AdventOfCode.Utils do
  @doc """
      iex> AdventOfCode.Utils.combinations([1, 2, 3], 2)
      [[1,2], [1,3], [2,3]]
  """
  def combinations(_, 0), do: [[]]
  def combinations([], _size), do: []

  def combinations([head | tail], size) do
    current_combs = combinations(tail, size - 1) |> Enum.map(&[head | &1])
    current_combs ++ combinations(tail, size)
  end

  @spec trim_all(list(String.t())) :: list(String.t())
  @doc """
      iex> AdventOfCode.Utils.trim_all(["a", " b", "c ", " d ", "    ",])
      ["a", "b", "c", "d", ""]
  """
  def trim_all(list), do: Enum.map(list, &String.trim/1)
end
