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
    Enum.reduce(list, {:searching, [], 0}, fn el, acc ->
      case acc do
        {:searching, stack, sum_stack} ->
          case check_stack(stack, sum_stack, el, searched) do
            {:found, s, ss} -> {:end, s, ss}
            {:not_found, s, ss} -> {:searching, s, ss}
          end

        {:end, stack, sum} ->
          {:end, stack, sum}
      end
    end)
    |> elem(1)
  end

  defp check_stack(stack, sum_stack, new_el, searched) when sum_stack + new_el == searched,
    do: {:found, stack ++ [new_el], sum_stack + new_el}

  defp check_stack(stack, sum_stack, new_el, searched) when sum_stack + new_el > searched do
    new_stack = tl(stack)
    # reduce the stack until it's lower than the searched value
    check_stack(new_stack, Enum.sum(new_stack), new_el, searched)
  end

  defp check_stack(stack, sum_stack, new_el, _searched),
    do: {:not_found, stack ++ [new_el], sum_stack + new_el}
end
