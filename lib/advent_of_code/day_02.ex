defmodule AdventOfCode.Day02 do
  @doc """
      iex> AdventOfCode.Day02.part1([{"abcde","1-3 a"},{"cdefg","1-3 b"},{"ccccccccc","2-9 c"}])
      2
  """
  def part1(passwords) do
    passwords |> Enum.count(fn {k, v} -> valid_password?(k, v) end)
  end

  @doc """
      iex> AdventOfCode.Day02.part2([{"abcde","1-3 a"},{"cdefg","1-3 b"},{"ccccccccc","2-9 c"}])
      1
  """
  def part2(passwords) do
    passwords |> Enum.count(fn {k, v} -> valid_password2?(k, v) end)
  end

  defp valid_password?(psw, rule) do
    {min_match, max_match, ch} = parse_rule(rule)
    count = psw |> String.graphemes() |> Enum.count(&(&1 == ch))
    min_match <= count and count <= max_match
  end

  defp valid_password2?(psw, rule) do
    {pos1, pos2, ch} = parse_rule(rule)
    c1 = String.at(psw, pos1 - 1)
    c2 = String.at(psw, pos2 - 1)
    (c1 == ch and not (c2 == ch)) or (not (c1 == ch) and c2 == ch)
  end

  defp parse_rule(rule) do
    [min_match, max_match, ch] = String.split(rule, ["-", " "])
    min_match = String.to_integer(min_match)
    max_match = String.to_integer(max_match)
    {min_match, max_match, ch}
  end
end
