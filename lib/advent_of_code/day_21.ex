defmodule AdventOfCode.Day21 do
  @doc """
      iex> AdventOfCode.Day21.part1(\"\"\"
      ...>                          mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
      ...>                          trh fvjkl sbzzf mxmxvkd (contains dairy)
      ...>                          sqjhc fvjkl (contains soy)
      ...>                          sqjhc mxmxvkd sbzzf (contains fish)
      ...>                          \"\"\")
      5
  """
  def part1(input) do
    informations = input |> parse_input()

    dangerous =
      get_dangerous_foods(informations)
      |> Enum.map(&elem(&1, 1))
      |> Enum.reduce(&MapSet.union/2)

    informations
    |> Enum.flat_map(&elem(&1, 0))
    |> Enum.filter(&(not MapSet.member?(dangerous, &1)))
    |> length()
  end

  defp parse_input(input) do
    String.split(input, "\n", trim: true) |> Enum.map(&parse_allergens/1)
  end

  defp parse_allergens(row) do
    [foods, allergens] = row |> String.replace_suffix(")", "") |> String.split(" (contains ")
    foods = foods |> String.split(" ")
    allergens = allergens |> String.split(", ")
    {foods, allergens}
  end

  defp get_dangerous_foods(informations) do
    informations
    |> Enum.flat_map(fn {foods, allergens} ->
      allergens |> Enum.map(&{&1, foods})
    end)
    |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
    |> Enum.map(fn {allergen, list_of_foods} -> {allergen, get_common_foods(list_of_foods)} end)
  end

  defp get_common_foods(list_of_foods) do
    list_of_foods
    |> Enum.map(&MapSet.new/1)
    |> Enum.reduce(&MapSet.intersection/2)
  end

  @doc """
     iex> AdventOfCode.Day21.part2(\"\"\"
     ...>                          mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
     ...>                          trh fvjkl sbzzf mxmxvkd (contains dairy)
     ...>                          sqjhc fvjkl (contains soy)
     ...>                          sqjhc mxmxvkd sbzzf (contains fish)
     ...>                          \"\"\")
     "mxmxvkd,sqjhc,fvjkl"
  """
  def part2(input) do
    informations = input |> parse_input()

    get_dangerous_foods(informations)
    |> match_exactly()
    |> Enum.sort_by(&elem(&1, 0))
    |> Enum.map(fn {_n, foods} -> foods |> Enum.to_list() |> hd() end)
    |> Enum.join(",")
  end

  defp match_exactly(possibilities) do
    c = length(possibilities)

    case Enum.count(possibilities, fn {_a, foods} -> MapSet.size(foods) == 1 end) do
      ^c ->
        possibilities

      _ ->
        exactly = possibilities |> Enum.filter(fn {_a, foods} -> MapSet.size(foods) == 1 end)
        matched_foods = exactly |> Enum.flat_map(&elem(&1, 1)) |> MapSet.new()

        changed =
          possibilities
          |> Enum.filter(fn {_a, foods} -> MapSet.size(foods) != 1 end)
          |> Enum.map(fn {allergen, foods} ->
            foods = foods |> Enum.filter(&(not MapSet.member?(matched_foods, &1))) |> MapSet.new()
            {allergen, foods}
          end)

        match_exactly(exactly ++ changed)
    end
  end
end
