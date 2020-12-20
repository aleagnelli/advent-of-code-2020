defmodule AdventOfCode.Day19 do
  alias AdventOfCode.Utils, as: AOCUtils

  @doc """
      iex> AdventOfCode.Day19.part1(\"\"\"
      ...>                          0: 4 1 5
      ...>                          1: 2 3 | 3 2
      ...>                          2: 4 4 | 5 5
      ...>                          3: 4 5 | 5 4
      ...>                          4: "a"
      ...>                          5: "b"
      ...>
      ...>                          ababbb
      ...>                          bababa
      ...>                          abbbab
      ...>                          aaabbb
      ...>                          aaaabbb
      ...>                          \"\"\")
      2
  """
  def part1(input) do
    execute(input, "0")
  end

  defp execute(input, starting_rule) do
    {rules, messages} = input |> parse_input()
    count_valid_messages(messages, rules, starting_rule)
  end

  defp parse_input(input) do
    [rules, messages] = input |> String.split("\n\n", trim: true)
    {parse_rules(rules), parse_messages(messages)}
  end

  defp parse_rules(rules) do
    rules |> String.split("\n", trim: true) |> Enum.map(&parse_rule/1) |> Map.new()
  end

  defp parse_rule(rule) do
    [name, matches] = String.replace(rule, "\"", "") |> String.split(":") |> AOCUtils.trim_all()
    {name, parse_matches(matches)}
  end

  defp parse_matches(matches) do
    String.split(matches, "|", trim: true)
    |> AOCUtils.trim_all()
    |> Enum.map(&String.split(&1, " "))
  end

  defp parse_messages(messages), do: String.split(messages, "\n", trim: true)

  defp count_valid_messages(messages, rules, starting_rule),
    do: messages |> Enum.map(&match_message(&1, rules, starting_rule)) |> Enum.count(&(&1 == ""))

  defp match_message(message, rules, current) do
    case rules[current] do
      [[c]] when c in ["a", "b"] ->
        consume_char(message, c)

      matches ->
        Enum.find_value(matches, fn match ->
          Enum.reduce(match, message, fn rule, msg -> msg && match_message(msg, rules, rule) end)
        end)
    end
  end

  defp consume_char("a" <> rest, "a"), do: rest
  defp consume_char("b" <> rest, "b"), do: rest
  defp consume_char(_, _), do: nil

  @doc """
     iex> AdventOfCode.Day19.part2(\"\"\"
     ...>                          42: 9 14 | 10 1
     ...>                          9: 14 27 | 1 26
     ...>                          10: 23 14 | 28 1
     ...>                          1: "a"
     ...>                          11: 42 31
     ...>                          5: 1 14 | 15 1
     ...>                          19: 14 1 | 14 14
     ...>                          12: 24 14 | 19 1
     ...>                          16: 15 1 | 14 14
     ...>                          31: 14 17 | 1 13
     ...>                          6: 14 14 | 1 14
     ...>                          2: 1 24 | 14 4
     ...>                          0: 8 11
     ...>                          13: 14 3 | 1 12
     ...>                          15: 1 | 14
     ...>                          17: 14 2 | 1 7
     ...>                          23: 25 1 | 22 14
     ...>                          28: 16 1
     ...>                          4: 1 1
     ...>                          20: 14 14 | 1 15
     ...>                          3: 5 14 | 16 1
     ...>                          27: 1 6 | 14 18
     ...>                          14: "b"
     ...>                          21: 14 1 | 1 14
     ...>                          25: 1 1 | 1 14
     ...>                          22: 14 14
     ...>                          8: 42
     ...>                          26: 14 22 | 1 20
     ...>                          18: 15 15
     ...>                          7: 14 5 | 1 21
     ...>                          24: 14 1
     ...>
     ...>                          abbbbbabbbaaaababbaabbbbabababbbabbbbbbabaaaa
     ...>                          bbabbbbaabaabba
     ...>                          babbbbaabbbbbabbbbbbaabaaabaaa
     ...>                          aaabbbbbbaaaabaababaabababbabaaabbababababaaa
     ...>                          bbbbbbbaaaabbbbaaabbabaaa
     ...>                          bbbababbbbaaaaaaaabbababaaababaabab
     ...>                          ababaaaaaabaaab
     ...>                          ababaaaaabbbaba
     ...>                          baabbaaaabbaaaababbaababb
     ...>                          abbbbabbbbaaaababbbbbbaaaababb
     ...>                          aaaaabbaabaaaaababaa
     ...>                          aaaabbaaaabbaaa
     ...>                          aaaabbaabbaaaaaaabbbabbbaaabbaabaaa
     ...>                          babaaabbbaaabaababbaabababaaab
     ...>                          aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba
     ...>                          \"\"\")
     12
  """
  def part2(input) do
    # executing from 8 instead of 0, also changed 8 manualy to avoid a premature failure
    # instead of match the first part of the or (42) as in puzzle input, it fails and try the second before failing
    input
    |> String.replace("8: 42", "8: 42 11 | 42 8")
    |> String.replace("11: 42 31", "11: 42 31 | 42 11 31")
    |> execute("8")
  end
end
