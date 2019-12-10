defmodule Aoc2019.Day2 do
  @moduledoc """
  Day 2 of Advent of Code 2019.
  """

  @doc """
  First problem.

  ## Examples
    iex> Aoc2019.Day2(Parser.line_commas_to_index_map("1,9,10,3,2,3,11,0,99,30,40,50", 0))
    3500
  """
  # def a(res) when is_integer(res), do: res
  def a(input \\ input()) do
    IntCodeComputer.run(input, :zero)
  end

  @doc """
  Second problem.

  ## Examples

  """
  def b(input \\ input()) do
    pairs = for noun <- 0..99, verb <- 0..99, do: {noun, verb}
    Enum.reduce_while(pairs, 0,
      fn {noun, verb}, a ->
        case IntCodeComputer.run(%{input| 1 => noun, 2 => verb}, :zero) do
          19690720 -> {:halt, 100 * noun + verb}
          _ -> {:cont, a}
        end
      end)
  end

  def result do
    IO.puts("Day2:")
    IO.puts("Part1: #{a()}")
    IO.puts("Part2: #{b()}")
  end

  defp input do
    Parser.file_one_line_commas_to_index_map("inputs/day2.txt")
  end

end
