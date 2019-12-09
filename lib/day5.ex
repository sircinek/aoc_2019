defmodule Aoc2019.Day5 do
  @moduledoc """
  Day 5 of Advent of Code 2019.
  """

  @doc """
  First problem.

  ## Examples
  """
  def a(input \\ input()) do

  end

  @doc """
  Second problem.

  ## Examples
  """
  def b(input \\ input()) do

  end

  def result do
    IO.puts("Day1:")
    IO.puts("Part1: #{a()}")l
    IO.puts("Part2: #{b()}")
  end

  defp input do
    Parser.file_to_int_list("inputs/day5.txt")
  end
end
