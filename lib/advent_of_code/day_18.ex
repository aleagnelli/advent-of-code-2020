defmodule AdventOfCode.Day18 do
  def part1(input) do
    String.split(input, "\n") |> Enum.map(&parse_and_evaluate/1) |> Enum.sum()
  end

  @doc """
      iex> AdventOfCode.Day18.parse_and_evaluate("1 + (2 * 3) + (4 * (5 + 6))")
      51
      iex> AdventOfCode.Day18.parse_and_evaluate("1 + 2 * 3 + 4 * 5 + 6")
      71
      iex> AdventOfCode.Day18.parse_and_evaluate("2 * 3 + (4 * 5)")
      26
      iex> AdventOfCode.Day18.parse_and_evaluate("5 + (8 * 3 + 9 + 3 * 4 * 3)")
      437
      iex> AdventOfCode.Day18.parse_and_evaluate("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))")
      12240
      iex> AdventOfCode.Day18.parse_and_evaluate("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2")
      13632
  """
  def parse_and_evaluate(input) do
    input |> parse_input() |> parse_expression() |> execute_expression()
  end

  defp parse_input(input) do
    input |> String.graphemes() |> Enum.filter(&(&1 != " "))
  end

  defp parse_expression([], ast), do: ast

  defp parse_expression([current | remaining], left) do
    case current do
      "+" ->
        {operation, rem} = build_operation(left, :+, remaining)
        parse_expression(rem, operation)

      "*" ->
        {operation, rem} = build_operation(left, :*, remaining)
        parse_expression(rem, operation)

      "(" ->
        parse_expression(remaining, left)

      ")" ->
        {left, remaining}

      _ ->
        :error
    end
  end

  defp parse_expression([current | remaining]) when current == "(" do
    {ast, rem} = parse_expression(remaining)
    parse_expression(rem, ast)
  end

  defp parse_expression([current | remaining]) do
    case Integer.parse(current) do
      err = :error ->
        err

      _ ->
        {left, rem} = parse_literal(remaining, current)
        parse_expression(rem, left)
    end
  end

  defp build_operation(left, op, rem) do
    {right, rem} = parse_literal(rem)
    {{op, left, right}, rem}
  end

  defp parse_literal(list, acc \\ "")
  defp parse_literal(rem = [], acc), do: {{:lit, String.to_integer(acc)}, rem}
  defp parse_literal([c | r], _acc) when c == "(", do: parse_expression(r)

  defp parse_literal(rem = [c | r], acc) do
    case Integer.parse(c) do
      :error -> {{:lit, String.to_integer(acc)}, rem}
      _ -> parse_literal(r, acc <> c)
    end
  end

  defp execute_expression({:lit, value}), do: value

  defp execute_expression({:+, left, right}),
    do: execute_expression(left) + execute_expression(right)

  defp execute_expression({:*, left, right}),
    do: execute_expression(left) * execute_expression(right)

  @doc """
    iex> AdventOfCode.Day18.parse_and_evaluate_2("5 + (8 * 3 + 9 + 3 * 4 * 3)")
    1445
    iex> AdventOfCode.Day18.parse_and_evaluate_2("8 * 3 + 9 + 3 * 4 * 3")
    1440
    iex> AdventOfCode.Day18.parse_and_evaluate_2("1 + (2 * 3) + (4 * (5 + 6))")
    51
    iex> AdventOfCode.Day18.parse_and_evaluate_2("1 + 2 * 3 + 4 * 5 + 6")
    231
    iex> AdventOfCode.Day18.parse_and_evaluate_2("2 * 3 + (4 * 5)")
    46
    iex> AdventOfCode.Day18.parse_and_evaluate_2("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))")
    669060
    iex> AdventOfCode.Day18.parse_and_evaluate_2("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2")
    23340
  """
  def part2(input) do
    String.split(input, "\n") |> Enum.map(&parse_and_evaluate_2/1) |> Enum.sum()
  end

  def parse_and_evaluate_2(input) do
    input |> parse_input() |> parse_expression_2() |> elem(0) |> execute_expression()
  end

  defp parse_expression_2([], ast), do: {ast, []}

  defp parse_expression_2([current | remaining], left) do
    case current do
      "+" ->
        {operation, rem} = build_operation_2(left, :+, remaining)
        parse_expression_2(rem, operation)

      "*" ->
        {lit, rem} = parse_literal_2(remaining)
        {right, rem} = consume_plus(lit, rem)
        operation = {:*, left, right}
        parse_expression_2(rem, operation)

      "(" ->
        parse_expression_2(remaining, left)

      ")" ->
        {left, remaining}

      _ ->
        :error
    end
  end

  defp build_operation_2(left, op, rem) do
    {right, rem} = parse_literal_2(rem)
    {{op, left, right}, rem}
  end

  defp consume_plus(left, ["+" | rem]) do
    {op, rem} = build_operation_2(left, :+, rem)
    consume_plus(op, rem)
  end

  defp consume_plus(left, rem), do: {left, rem}

  defp parse_expression_2([current | remaining]) when current == "(" do
    {ast, rem} = parse_expression_2(remaining)
    parse_expression_2(rem, ast)
  end

  defp parse_expression_2([current | remaining]) do
    case Integer.parse(current) do
      err = :error ->
        err

      _ ->
        {left, rem} = parse_literal_2(remaining, current)
        parse_expression_2(rem, left)
    end
  end

  defp parse_literal_2(list, acc \\ "")
  defp parse_literal_2(rem = [], acc), do: {{:lit, String.to_integer(acc)}, rem}
  defp parse_literal_2([c | r], _acc) when c == "(", do: parse_expression_2(r)

  defp parse_literal_2(rem = [c | r], acc) do
    case Integer.parse(c) do
      :error -> {{:lit, String.to_integer(acc)}, rem}
      _ -> parse_literal(r, acc <> c)
    end
  end
end
