defmodule AdventOfCode.Day16 do
  @doc """
      iex> AdventOfCode.Day16.part1(\"\"\"
      ...>                          class: 1-3 or 5-7
      ...>                          row: 6-11 or 33-44
      ...>                          seat: 13-40 or 45-50
      ...>
      ...>                          your ticket:
      ...>                          7,1,14
      ...>
      ...>                          nearby tickets:
      ...>                          7,3,47
      ...>                          40,4,50
      ...>                          55,2,20
      ...>                          38,6,12
      ...>                          \"\"\")
      71
  """
  def part1(input) do
    {rules, _, tickets} = input |> parse_input()
    get_invalid_fields(tickets, rules) |> Enum.sum()
  end

  defp parse_input(input) do
    [rules, my_ticket, nearby_tickets] = input |> String.split("\n\n")
    {parse_rules(rules), parse_my_ticket(my_ticket), parse_nearby_ticket(nearby_tickets)}
  end

  defp parse_rules(rules) do
    rules
    |> String.split("\n", trim: true)
    |> Enum.map(fn el ->
      [rule_name, ranges] = String.split(el, ":", trim: true)

      ranges =
        String.split(ranges, " or ", trim: true)
        |> Enum.map(fn range ->
          [from, to] =
            String.split(range, "-") |> Enum.map(&String.trim/1) |> Enum.map(&String.to_integer/1)

          {from, to}
        end)

      {rule_name, ranges}
    end)
    |> Map.new()
  end

  defp parse_my_ticket(ticket) do
    String.split(ticket, "\n", trim: true)
    |> Enum.drop(1)
    |> hd()
    |> parse_ticket()
  end

  @spec parse_nearby_ticket(String.t()) :: list(list(integer))
  defp parse_nearby_ticket(tickets) do
    String.split(tickets, "\n", trim: true)
    |> Enum.drop(1)
    |> Enum.map(&parse_ticket/1)
  end

  @spec parse_ticket(String.t()) :: list(integer)
  defp parse_ticket(ticket) do
    String.split(ticket, ",", trim: true) |> Enum.map(&String.to_integer/1)
  end

  defp get_invalid_fields(tickets, rules) do
    Enum.flat_map(tickets, fn ticket ->
      Enum.filter(ticket, fn field ->
        not valid_field?(field, rules)
      end)
    end)
  end

  defp valid_field?(field, rules) do
    Enum.any?(rules, fn {_name, ranges} -> match_rule?(field, ranges) end)
  end

  defp match_rule?(field, ranges) do
    ranges |> Enum.any?(fn {from, to} -> from <= field and field <= to end)
  end

  def part2(input) do
    {rules, my_ticket, tickets} = input |> parse_input()

    get_valid_tickets(tickets, rules)
    |> assign_columns(rules)
    |> Enum.zip(my_ticket)
    |> Enum.filter(fn {name, _v} -> String.starts_with?(name, "departure") end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.reduce(&(&1 * &2))
  end

  defp get_valid_tickets(tickets, rules), do: Enum.filter(tickets, &valid_ticket?(&1, rules))

  defp valid_ticket?(ticket, rules) do
    not Enum.any?(ticket, fn field ->
      not valid_field?(field, rules)
    end)
  end

  defp assign_columns(tickets, rules) do
    tickets
    |> Enum.zip()
    |> Enum.map(&get_valid_rules(&1, rules))
    |> find_column_with_exclusion()
    |> Enum.map(&hd/1)
  end

  defp get_valid_rules(values, rules) do
    Enum.filter(rules, fn {_name, ranges} ->
      values |> Tuple.to_list() |> Enum.all?(fn value -> match_rule?(value, ranges) end)
    end)
    |> Enum.map(&elem(&1, 0))
  end

  defp find_column_with_exclusion(rules_matched) do
    if Enum.all?(rules_matched, fn rules -> length(rules) == 1 end) do
      rules_matched
    else
      rules_required = rules_matched |> Enum.filter(fn rules -> length(rules) == 1 end)
      names = rules_required |> List.flatten() |> MapSet.new()

      rules_matched
      |> Enum.map(fn rules ->
        if length(rules) == 1 do
          rules
        else
          rules |> Enum.filter(fn name -> not MapSet.member?(names, name) end)
        end
      end)
      |> find_column_with_exclusion()
    end
  end
end
