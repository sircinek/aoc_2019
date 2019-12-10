defmodule Aoc2019.Day7 do
  @moduledoc """
  Day 7 of Advent of Code 2019.
  """

  @doc """
  First problem.

  ## Examples
  iex> Aoc2019.Day7.a(Parser.line_commas_to_index_map("3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0", 0))
  {{4,3,2,1,0}, 43210}
  """
  def a(input \\ input()) do
    phases = 0..4
    for a <- phases,
        b <- phases,
        c <- phases,
        d <- phases,
        e <- phases,
        a != b,
        a != c,
        a != d,
        a != e,
        b != c,
        b != d,
        b != e,
        c != d,
        c != e,
        d != e,
      into: %{}
    do
      amps = 
        for {amp, phase} <- [{:a, a},{:b, b},{:c, c}, {:d, d}, {:e, e}] do
          {:ok, p} = Amplifier.start_link(input, phase)
          {amp, p}
        end
      calculate_output = fn {a, p}, i ->
        ret = Amplifier.calculate_output(p, i)
        IO.puts "Amp #{inspect a}, input: #{inspect i}, output: #{inspect ret}"
        ret
      end
      result = Enum.reduce(amps, 0, calculate_output)
      ret = {{a, b, c, d, e}, result}
      # IO.puts "Result #{inspect ret}"
      ret
    end
    |> Enum.max_by(fn {_, result} -> result end)
   
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
    Parser.file_one_line_commas_to_index_map("inputs/day7.txt")
  end
end
