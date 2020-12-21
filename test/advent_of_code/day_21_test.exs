defmodule Day21Test do
  use ExUnit.Case, async: true
  doctest AdventOfCode.Day21

  test "part 1" do
    input = get_resource()
    res = AdventOfCode.Day21.part1(input)
    assert res == 1885
  end

  test "part 2" do
    input = get_resource()
    res = AdventOfCode.Day21.part2(input)
    assert res == "fllssz,kgbzf,zcdcdf,pzmg,kpsdtv,fvvrc,dqbjj,qpxhfp"
  end

  def get_resource() do
    "priv/day_21.txt" |> File.read!()
  end
end
