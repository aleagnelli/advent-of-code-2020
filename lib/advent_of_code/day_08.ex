defmodule AdventOfCode.Day08 do
  @doc """
      iex> AdventOfCode.Day08.part1(\"\"\"
      ...>                          nop +0
      ...>                          acc +1
      ...>                          jmp +4
      ...>                          acc +3
      ...>                          jmp -3
      ...>                          acc -99
      ...>                          acc +1
      ...>                          jmp -4
      ...>                          acc +6
      ...>                          \"\"\")
      5
  """
  def part1(input) do
    boot_code = parse_input(input)
    {:loop, acc} = execute(boot_code)
    acc
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.map(&parse_instruction/1)
    |> Enum.into(%{})
  end

  defp parse_instruction({row, index}) do
    [instruction | [arg]] = row |> String.split(" ", trim: true, parts: 2)
    {index, {instruction, String.to_integer(arg), false}}
  end

  defp execute(boot_code, program_counter \\ 0, acc_value \\ 0)

  defp execute(boot_code, program_counter, acc_value)
       when program_counter < map_size(boot_code) do
    instruction = Map.fetch!(boot_code, program_counter)

    next_boot_code = update_instruction(boot_code, program_counter)

    case instruction do
      {_, _, true} ->
        {:loop, acc_value}

      {"nop", _, false} ->
        execute(next_boot_code, program_counter + 1, acc_value)

      {"acc", amount, false} ->
        execute(next_boot_code, program_counter + 1, acc_value + amount)

      {"jmp", amount, false} ->
        execute(next_boot_code, program_counter + amount, acc_value)

      true ->
        raise "Invalid instruction"
    end
  end

  defp execute(__boot_code, _program_counter, acc_value), do: {:ok, acc_value}

  defp update_instruction(boot_code, instruction_number) do
    Map.update!(boot_code, instruction_number, &put_elem(&1, 2, true))
  end

  @doc """
      iex> AdventOfCode.Day08.part2(\"\"\"
      ...>                          nop +0
      ...>                          acc +1
      ...>                          jmp +4
      ...>                          acc +3
      ...>                          jmp -3
      ...>                          acc -99
      ...>                          acc +1
      ...>                          jmp -4
      ...>                          acc +6
      ...>                          \"\"\")
      8
  """
  def part2(input) do
    boot_code = parse_input(input)

    corrupted_candidates =
      boot_code
      |> Enum.to_list()
      |> Enum.filter(&(is_jmp(&1) or is_nop(&1)))
      |> Enum.map(&elem(&1, 0))

    corrupted_candidates
    |> Enum.map(&update_boot_code(boot_code, &1))
    |> Enum.map(&execute/1)
    |> Enum.filter(&(elem(&1, 0) == :ok))
    |> hd()
    |> elem(1)
  end

  defp is_jmp({_, {"jmp", _, _}}), do: true
  defp is_jmp({_, {_, _, _}}), do: false
  defp is_nop({_, {"nop", _, _}}), do: true
  defp is_nop({_, {_, _, _}}), do: false

  defp update_boot_code(boot_code, instruction),
    do: Map.update!(boot_code, instruction, &switch_instruction/1)

  defp switch_instruction({"jmp", arg, false}), do: {"nop", arg, false}
  defp switch_instruction({"nop", arg, false}), do: {"jmp", arg, false}
end
