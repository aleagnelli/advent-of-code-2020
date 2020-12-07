defmodule AdventOfCode.Day07 do
  @doc """
      iex> AdventOfCode.Day07.part1(\"\"\"
      ...>                          light red bags contain 1 bright white bag, 2 muted yellow bags.
      ...>                          dark orange bags contain 3 bright white bags, 4 muted yellow bags.
      ...>                          bright white bags contain 1 shiny gold bag.
      ...>                          muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
      ...>                          shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
      ...>                          dark olive bags contain 3 faded blue bags, 4 dotted black bags.
      ...>                          vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
      ...>                          faded blue bags contain no other bags.
      ...>                          dotted black bags contain no other bags.
      ...>                          \"\"\")
      4
  """
  def part1(input) do
    input
    |> parse_input_part_1()
    |> search_contained("shiny gold")
    |> MapSet.new()
    |> MapSet.size()
  end

  defp parse_input_part_1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.flat_map(&parse_row_part_1/1)
    |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
  end

  defp parse_row_part_1(row) do
    [container | [inside]] = Regex.scan(~r/(.*)contain(.*)/, row, capture: :all_but_first) |> hd()
    bag_container = String.replace(container, "bags", "") |> String.trim()

    contents =
      inside
      |> String.split(",", trim: true)
      |> Enum.filter(&(not String.contains?(&1, "no other bags")))
      |> Enum.map(fn bag_desc ->
        content =
          bag_desc |> String.replace(["bags", "bags.", "bag", "bag."], "") |> String.trim()

        Regex.scan(~r/^\d{0,2}\s(.*)/, content, capture: :all_but_first) |> hd() |> hd()
      end)

    Enum.map(contents, &{&1, bag_container})
  end

  defp search_contained(inverse_rules, searched_value) do
    containers = Map.get(inverse_rules, searched_value, [])

    if containers == [] do
      containers
    else
      indirect_containers = containers |> Enum.flat_map(&search_contained(inverse_rules, &1))

      containers ++ indirect_containers
    end
  end

  @doc """
      iex> AdventOfCode.Day07.part2(\"\"\"
      ...>                          shiny gold bags contain 2 dark red bags.
      ...>                          dark red bags contain 2 dark orange bags.
      ...>                          dark orange bags contain 2 dark yellow bags.
      ...>                          dark yellow bags contain 2 dark green bags.
      ...>                          dark green bags contain 2 dark blue bags.
      ...>                          dark blue bags contain 2 dark violet bags.
      ...>                          dark violet bags contain no other bags.
      ...>                          \"\"\")
      126
  """
  def part2(input) do
    rules = input |> parse_input_part_2()
    count_bags(rules, "shiny gold") - 1
  end

  defp parse_input_part_2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_row_part_2/1)
    |> Map.new()
  end

  defp parse_row_part_2(row) do
    [container | [inside]] = Regex.scan(~r/(.*)contain(.*)/, row, capture: :all_but_first) |> hd()
    bag_container = String.replace(container, "bags", "") |> String.trim()

    contents =
      inside
      |> String.split(",", trim: true)
      |> Enum.filter(&(not String.contains?(&1, "no other bags")))
      |> Enum.flat_map(fn bag_desc ->
        content =
          bag_desc
          |> String.replace(["bags", "bags.", "bag", "bag."], "")
          |> String.trim()

        [count | [color]] =
          Regex.scan(~r/^(\d{0,2})\s(.*)/, content, capture: :all_but_first)
          |> hd()

        [{color, String.to_integer(count)}]
      end)
      |> Enum.into(%{})

    {bag_container, contents}
  end

  defp count_bags(rules, searched_value) do
    contents = Map.get(rules, searched_value, %{})

    if contents == %{} do
      1
    else
      inside_bags =
        contents
        |> Enum.map(fn {color, quantity} -> quantity * count_bags(rules, color) end)
        |> Enum.sum()

      1 + inside_bags
    end
  end
end
