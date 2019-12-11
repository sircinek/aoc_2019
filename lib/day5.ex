defmodule Aoc2019.Day5 do
  @moduledoc """
  Day 5 of Advent of Code 2019.
  """

  @doc """
  First problem.

  ## Examples
  """
  def a(input \\ input()) do
    input
    |> IntCodeComputer.add_input(1)
    |> IntCodeComputer.run_to_halt(:output)
  end

  @doc """
  Second problem.

  ## Examples
  """
  def b(input \\ input()) do
    input
    |> Map.put_new(:output, [])
    |> IntCodeComputer.add_input(5)
    |> IntCodeComputer.run_to_halt(:output)
  end

  def result do
    IO.puts("Day1:")
    IO.puts("Part1: #{a()}")
    IO.puts("Part2: #{b()}")
  end

  defp input do
    Parser.file_one_line_commas_to_index_map("inputs/day5.txt")
  end
end
