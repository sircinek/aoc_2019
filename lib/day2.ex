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
  def a(res) when is_integer(res), do: res
  def a(input \\ input()) do
    input
    |> index()
    |> action(input)
    |> a()
  end

  @doc """
  Second problem.

  ## Examples

  """
  def b(input \\ input()) do
    pairs = for noun <- 0..99, verb <- 0..99, do: {noun, verb}
    Enum.reduce_while(pairs, 0,
      fn {noun, verb}, a ->
        case a(%{input| 1 => noun, 2 => verb}) do
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

  defp sum(i, input) do
    sum = fn a, b -> a + b end
    do_action(sum, i, input)
  end

  defp multiply(i, input) do
    multiply = fn a, b -> a * b end
   do_action(multiply, i, input)
  end

  defp halt(%{0 => ret}), do: ret

  defp action(i, input) do
    case Map.get(input, i) do
      1 -> sum(i, input)
      2 -> multiply(i, input)
      99 -> halt(input)
    end
  end

  defp do_action(fun, i, input) do
    a_i = Map.get(input, i + 1)
    b_i = Map.get(input, i + 2)
    res = fun.(input[a_i], input[b_i])
    pos = Map.get(input, i + 3)
    update_code(i, pos, res, input)
  end

  defp update_code(index, pos, value, input) do
    %{Map.put(input, pos, value) | index: index + 4}
  end
  defp index(%{index: i}), do: i

  defp input do
    Parser.file_one_line_commas_to_index_map("inputs/day2.txt")
  end

end
