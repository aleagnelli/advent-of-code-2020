defmodule AdventOfCode.Day04 do
  @mandatory_fields ["ecl", "pid", "eyr", "hcl", "byr", "iyr", "hgt"]
  @doc """
      iex> AdventOfCode.Day04.part1(\"\"\"
      ...>                          ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
      ...>                          byr:1937 iyr:2017 cid:147 hgt:183cm
      ...>
      ...>                          iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
      ...>                          hcl:#cfa07d byr:1929
      ...>
      ...>                          hcl:#ae17e1 iyr:2013
      ...>                          eyr:2024
      ...>                          ecl:brn pid:760753108 byr:1931
      ...>                          hgt:179cm
      ...>
      ...>                          hcl:#cfa07d eyr:2025 pid:166559648
      ...>                          iyr:2011 ecl:brn hgt:59in
      ...>                          \"\"\")
      2
  """
  def part1(input) do
    input
    |> parse_input()
    |> Enum.count(fn passport ->
      Enum.all?(@mandatory_fields, &Map.has_key?(passport, &1))
    end)
  end

  @doc """
      iex> AdventOfCode.Day04.part2(\"\"\"
      ...>                          eyr:1972 cid:100
      ...>                          hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926
      ...>
      ...>                          iyr:2019
      ...>                          hcl:#602927 eyr:1967 hgt:170cm
      ...>                          ecl:grn pid:012533040 byr:1946
      ...>
      ...>                          hcl:dab227 iyr:2012
      ...>                          ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277
      ...>
      ...>                          hgt:59cm ecl:zzz
      ...>                          eyr:2038 hcl:74454a iyr:2023
      ...>                          pid:3556412378 byr:2007
      ...>                          \"\"\")
      0

      iex> AdventOfCode.Day04.part2(\"\"\"
      ...>                          pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
      ...>                          hcl:#623a2f
      ...>
      ...>                          eyr:2029 ecl:blu cid:129 byr:1989
      ...>                          iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm
      ...>
      ...>                          hcl:#888785
      ...>                          hgt:164cm byr:2001 iyr:2015 cid:88
      ...>                          pid:545766238 ecl:hzl
      ...>                          eyr:2022
      ...>
      ...>                          iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
      ...>                          \"\"\")
      4
  """
  def part2(input) do
    input
    |> parse_input()
    |> Enum.count(fn passport ->
      @mandatory_fields |> Enum.all?(&validate_field(&1, passport))
    end)
  end

  @doc """
      iex> AdventOfCode.Day04.validate_field("byr", %{"byr" => "2002"})
      true
      iex> AdventOfCode.Day04.validate_field("byr", %{"byr" => "2003"})
      false

      iex> AdventOfCode.Day04.validate_field("hgt", %{"hgt" => "60in"})
      true
      iex> AdventOfCode.Day04.validate_field("hgt", %{"hgt" => "190cm"})
      true
      iex> AdventOfCode.Day04.validate_field("hgt", %{"hgt" => "190in"})
      false
      iex> AdventOfCode.Day04.validate_field("hgt", %{"hgt" => "190"})
      false

      iex> AdventOfCode.Day04.validate_field("hcl", %{"hcl" => "#123abc"})
      true
      iex> AdventOfCode.Day04.validate_field("hcl", %{"hcl" => "#123abz"})
      false
      iex> AdventOfCode.Day04.validate_field("hcl", %{"hcl" => "123abc"})
      false

      iex> AdventOfCode.Day04.validate_field("ecl", %{"ecl" => "brn"})
      true
      iex> AdventOfCode.Day04.validate_field("ecl", %{"ecl" => "wat"})
      false

      iex> AdventOfCode.Day04.validate_field("pid", %{"pid" => "000000001"})
      true
      iex> AdventOfCode.Day04.validate_field("pid", %{"pid" => "0123456789"})
      false
  """
  def validate_field("ecl", %{"ecl" => value}) do
    Enum.any?(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"], &(&1 == value))
  end

  def validate_field("pid", %{"pid" => value}), do: Regex.match?(~r/^[\d]{9}$/, value)

  def validate_field("eyr", %{"eyr" => value}), do: validate_bounds(value, 2020, 2030)

  def validate_field("hcl", %{"hcl" => value}), do: Regex.match?(~r/^#[\d|a-f]{6}$/, value)

  def validate_field("byr", %{"byr" => value}), do: validate_bounds(value, 1920, 2002)

  def validate_field("iyr", %{"iyr" => value}), do: validate_bounds(value, 2010, 2020)

  def validate_field("hgt", %{"hgt" => value}) do
    height = value |> String.replace("cm", "") |> String.replace("in", "")

    cond do
      String.ends_with?(value, "cm") -> validate_bounds(height, 150, 193)
      String.ends_with?(value, "in") -> validate_bounds(height, 59, 76)
      true -> false
    end
  end

  def validate_field(_, _), do: false

  defp validate_bounds(s_value, lower_bound, upper_bound) do
    i_value = String.to_integer(s_value)
    lower_bound <= i_value and i_value <= upper_bound
  end

  defp parse_input(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_passport(&1))
  end

  @spec parse_passport(String.t()) :: map()
  defp parse_passport(passport) do
    passport
    |> String.split("\n", trim: true)
    |> Enum.flat_map(&String.split(&1, " ", trim: true))
    |> Enum.map(&parse_attribute(&1))
    |> Map.new()
  end

  @spec parse_attribute(String.t()) :: tuple()
  defp parse_attribute(attribute) do
    [key | [value]] = String.split(attribute, ":", trim: true)
    {key, value}
  end
end
