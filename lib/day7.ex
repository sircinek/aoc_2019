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
    _phases = 0..4
    |> combinations()
    |> Task.async_stream(simulation(input))
    |> Enum.max_by(fn {_, {_, result}} -> result end)
    |> elem(1)
  end

  @doc """
  Second problem.

  ## Examples
  """
  def b(input \\ input()) do
    _phases = 5..9
    |> combinations()
  end

  def result do
    IO.puts("Day1:")
    IO.puts("Part1: #{a()}")
    IO.puts("Part2: #{b()}")
  end

  defp combinations(phases) do
    options =
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
          d != e
      do
        {a,b,c,d,e}
      end
  end

  defp simulation(input) do
    fn(settings) ->
      amps = initialize_amps(settings, input)
      result = Enum.reduce(amps, 0, &calculate_output/2)
      {settings, result}
    end
  end

  defp calculate_output({amp, pid}, input) do
    Amplifier.calculate_output(pid, input)
  end

  defp initialize_amps({a,b,c,d,e}, input) do
    for {amp, phase} <- [{:a, a},{:b, b},{:c, c}, {:d, d}, {:e, e}] do
      {:ok, p} = Amplifier.start_link(input, phase)
      {amp, p}
    end
  end

  defp input do
    Parser.file_one_line_commas_to_index_map("inputs/day7.txt")
  end
end
