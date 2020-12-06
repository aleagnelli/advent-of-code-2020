defmodule AdventOfCode.Day06 do
  @doc """
      iex> AdventOfCode.Day06.part1(\"\"\"
      ...>                           abc
      ...>
      ...>                           a
      ...>                           b
      ...>                           c
      ...>
      ...>                           ab
      ...>                           ac
      ...>
      ...>                           a
      ...>                           a
      ...>                           a
      ...>                           a
      ...>
      ...>                           b
      ...>                           \"\"\")
      11
  """
  def part1(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&count_uniq/1)
    |> Enum.sum()
  end

  defp count_uniq(group_answers) do
    group_answers
    |> String.replace("\n", "")
    |> String.graphemes()
    |> Enum.uniq()
    |> length()
  end

  @doc """
      iex> AdventOfCode.Day06.part2(\"\"\"
      ...>                           abc
      ...>
      ...>                           a
      ...>                           b
      ...>                           c
      ...>
      ...>                           ab
      ...>                           ac
      ...>
      ...>                           a
      ...>                           a
      ...>                           a
      ...>                           a
      ...>
      ...>                           b
      ...>                           \"\"\")
      6
  """
  def part2(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&count_common/1)
    |> Enum.sum()
  end

  defp count_common(group_answers) do
    person_answers = group_answers |> String.split("\n", trim: true)

    if length(person_answers) == 1 do
      String.length(hd(person_answers))
    else
      [head | tail] = person_answers |> Enum.map(&String.graphemes/1) |> Enum.map(&MapSet.new/1)

      tail
      |> Enum.reduce(head, fn el, acc -> MapSet.intersection(el, acc) end)
      |> MapSet.size()
    end
  end
end
