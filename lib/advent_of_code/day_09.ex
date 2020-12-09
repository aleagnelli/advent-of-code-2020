defmodule AdventOfCode.Day09 do
  @doc """
      iex> AdventOfCode.Day09.part1([35,20,15,25,47,40,62,55,65,95,102,117,150,182,127,219,299,277,309,576], 5)
      127
  """
  def part1(input, preamble) do
    {preamble_part, remaining_list} = input |> Enum.split(preamble)
    find_error(preamble_part, remaining_list)
  end

  def find_error(_preamble_part, []), do: raise("No error found")

  def find_error(preamble_part, [head | tail]) do
    exists_sum? =
      Utils.combinations(preamble_part, 2)
      |> Enum.any?(fn [a | [b]] -> a + b == head end)

    if exists_sum? do
      new_preamble = tl(preamble_part) ++ [head]
      find_error(new_preamble, tail)
    else
      head
    end
  end

  @doc """
      iex> AdventOfCode.Day09.part2([35,20,15,25,47,40,62,55,65,95,102,117,150,182,127,219,299,277,309,576], 127)
      62
  """
  def part2(input, error) do
    contigous = find_contigous_set(input, error)
    {smallest, largest} = Enum.min_max(contigous)
    smallest + largest
  end

  defp find_contigous_set(list, searched) do
    list
    |> Enum.reduce_while({[], 0}, fn el, {window, sum_w} ->
      check_window(window ++ [el], sum_w + el, searched)
    end)
    |> elem(0)
  end

  defp check_window(window, sum_w, searched) when sum_w == searched, do: {:halt, {window, sum_w}}

  defp check_window(window, sum_w, searched) when sum_w > searched do
    new_window = tl(window)
    # reduce the window until it's lower than the searched value
    check_window(new_window, sum_w - hd(window), searched)
  end

  defp check_window(window, sum_w, _searched), do: {:cont, {window, sum_w}}
end
