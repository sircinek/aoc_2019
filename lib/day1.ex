defmodule Aoc2019.Day1 do
  @moduledoc """
  Day 1 of Advent of Code 2019.
  """

  @doc """
  First problem.

  ## Examples

      iex> Aoc2019.Day1.a([12])
      2

      iex> Aoc2019.Day1.a([14])
      2

      iex> Aoc2019.Day1.a([1969])
      654

      iex> Aoc2019.Day1.a([100756])
      33583

      iex> Aoc2019.Day1.a()
      3375962
  """
  def a(input \\ input()) do
    Enum.reduce(input, 0, fn mass, total -> fuel(mass) + total end)
  end

  @doc """
  Second problem.

  ## Examples

      iex> Aoc2019.Day1.b([12])
      2

      iex> Aoc2019.Day1.b([14])
      2

      iex> Aoc2019.Day1.b([1969])
      966

      iex> Aoc2019.Day1.b([100756])
      50346

      iex>Aoc2019.Day1.b()
      5061072
  """
  def b(input \\ input()) do
    Enum.reduce(input, 0, fn mass, total ->
      fuel = fuel(mass)
      sum_fuel(fuel, fuel) + total
    end)
  end

  def result do
    IO.puts("Day1:")
    IO.puts("Part1: #{a()}")
    IO.puts("Part2: #{b()}")
  end

  defp sum_fuel(amount, total) do
    case fuel(amount) do
      reduced_fuel when reduced_fuel > 0 ->
        sum_fuel(reduced_fuel, total + reduced_fuel)

      _ ->
        total
    end
  end

  defp fuel(mass), do: div(mass, 3) - 2

  defp input do
    Parser.file_to_int_list("inputs/day1.txt")
  end
end
