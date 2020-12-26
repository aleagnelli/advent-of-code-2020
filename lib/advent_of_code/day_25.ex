defmodule AdventOfCode.Day25 do
  @doc """
      iex> AdventOfCode.Day25.part1({5764801, 17807724})
      14897079
  """
  def part1({card_pubk, door_pubk}) do
    size = loop_size(card_pubk)
    transform_until(door_pubk, door_pubk, size - 1)
  end

  @doc """
      iex> AdventOfCode.Day25.loop_size(5764801)
      8
      iex> AdventOfCode.Day25.loop_size(17807724)
      11
  """
  def loop_size(pk, size \\ 0, current \\ 1)
  def loop_size(pk, size, current) when current == pk, do: size
  def loop_size(pk, size, current), do: loop_size(pk, size + 1, transform(current, 7))

  defp transform(current, subject_number), do: rem(current * subject_number, 20_201_227)
  defp transform_until(current, _subject_number, 0), do: current

  defp transform_until(current, subject_number, times) do
    transform_until(transform(current, subject_number), subject_number, times - 1)
  end
end
