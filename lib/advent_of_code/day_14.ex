defmodule AdventOfCode.Day14 do
  @doc """
      iex> AdventOfCode.Day14.part1(\"\"\"
      ...>                          mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
      ...>                          mem[8] = 11
      ...>                          mem[7] = 101
      ...>                          mem[8] = 0
      ...>                          \"\"\")
      165
  """
  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_instruction/1)
    |> Enum.reduce({%{}, ""}, fn operation, {memory, mask} -> execute(operation, memory, mask) end)
    |> elem(0)
    |> Enum.map(&(elem(&1, 1) |> String.to_integer()))
    |> Enum.sum()
  end

  defp parse_instruction(instruction) do
    if String.starts_with?(instruction, "mask = ") do
      mask = instruction |> String.replace("mask = ", "")
      {:update_mask, mask |> String.graphemes()}
    else
      [mem, value] = instruction |> String.split(" = ", trim: true)
      address = mem |> String.replace(["mem[", "]"], "")
      {:write, {address, value}}
    end
  end

  defp execute({:update_mask, mask}, memory, _old_mask), do: {memory, mask}

  defp execute({:write, {address, value}}, memory, mask) do
    new_memory = Map.put(memory, address, masked_value(value, mask))
    {new_memory, mask}
  end

  defp masked_value(value, mask) do
    value
    |> String.to_integer()
    |> Integer.digits(2)
    |> Enum.map(&Integer.to_string/1)
    |> Enum.join("")
    |> String.pad_leading(36, "0")
    |> String.graphemes()
    |> Enum.zip(mask)
    |> Enum.map(fn
      {_bit, "0"} -> "0"
      {_bit, "1"} -> "1"
      {bit, "X"} -> bit
    end)
    |> Enum.join("")
    |> String.to_integer(2)
    |> Integer.to_string()
  end

  @doc """
      iex> AdventOfCode.Day14.part2(\"\"\"
      ...>                          mask = 000000000000000000000000000000X1001X
      ...>                          mem[42] = 100
      ...>                          mask = 00000000000000000000000000000000X0XX
      ...>                          mem[26] = 1
      ...>                          \"\"\")
      208
  """
  def part2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_instruction/1)
    |> Enum.reduce({%{}, ""}, fn operation, {memory, mask} ->
      execute_2(operation, memory, mask)
    end)
    |> elem(0)
    |> Enum.map(&(elem(&1, 1) |> String.to_integer()))
    |> Enum.sum()
  end

  defp execute_2({:update_mask, mask}, memory, _old_mask), do: {memory, mask}

  defp execute_2({:write, {address, value}}, memory, mask) do
    new_memory =
      masked_address(address, mask)
      |> Enum.reduce(memory, fn adrs, mem -> Map.put(mem, adrs, value) end)

    {new_memory, mask}
  end

  defp masked_address(value, mask) do
    value
    |> String.to_integer()
    |> Integer.digits(2)
    |> Enum.map(&Integer.to_string/1)
    |> Enum.join("")
    |> String.pad_leading(36, "0")
    |> String.graphemes()
    |> Enum.zip(mask)
    |> Enum.map(fn
      {bit, "0"} -> bit
      {_bit, "1"} -> "1"
      {_bit, "X"} -> "X"
    end)
    |> create_addresses()
    |> Enum.map(&(&1 |> Enum.join("") |> String.to_integer(2) |> Integer.to_string()))
  end

  defp create_addresses(masked) do
    Enum.reduce(masked, [[]], fn
      "X", acc -> duplicate_addresses(acc)
      el, acc -> add_single_bit(acc, el)
    end)
  end

  defp duplicate_addresses(addresses) do
    Enum.flat_map(addresses, fn address ->
      [add_single_bit([address], "1"), add_single_bit([address], "0")]
    end)
  end

  defp add_single_bit(addresses, bit) do
    Enum.map(addresses, fn address -> address ++ [bit] end)
  end
end
