defmodule Aoc2019.Day7 do
  @moduledoc """
  Day 7 of Advent of Code 2019.
  """

  @doc """
  First problem.

  ## Examples
  """
  def a(input \\ input()) do
    input
    |> Map.put_new(:output, [])
    |> Map.put_new(:input, 1)
    |> IntCodeComputer.run(:output)
    |> Enum.reject(& &1 == 0)
    |> Enum.at(0)
  end

  @doc """
  Second problem.

  ## Examples
  """
  def b(input \\ input()) do
    input
    |> Map.put_new(:output, [])
    |> Map.put_new(:input, 5)
    |> IntCodeComputer.run(:output)
    |> Enum.reject(& &1 == 0)
    |> Enum.at(0)
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
