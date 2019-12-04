defmodule Aoc2019.Day4 do
  @moduledoc """
  Day 1 of Advent of Code 2019.
  """

  @doc """
  First problem.

  ## Examples

  """
  def a do
    increment_and_check(min(), 0)
  end

  @doc """
  Second problem.

  ## Examples

  """
  def b do
    increment_and_check2(min(), 0)
  end

  defp increment_and_check(now, counter) do
    next = now + 1 
    if next < max() do
      if duplicate?(next) and no_decreasing?(next) do
        increment_and_check(next, counter + 1)
      else
        increment_and_check(next, counter)
      end
    else
      counter
    end
  end

  defp increment_and_check2(now, counter) do
    next = now + 1 
    if next < max() do
      if duplicate_chunks?(next) and no_decreasing?(next) do
        increment_and_check2(next, counter + 1)
      else
        increment_and_check2(next, counter)
      end
    else
      counter
    end
  end

  def duplicate_chunks?(num) do
    chunk_fun = fn
      i, {i, acc} -> 
        {:cont, {i, [i | acc]}}
      i, {_last, acc} -> 
        {:cont, Enum.reverse(acc), {i, [i]}}
    end

    after_fun = fn
      {_, []} -> {:cont, []}
      {_, chunk} -> {:cont, Enum.reverse(chunk), []}
    end

    num
    |> Integer.digits()
    |> Enum.chunk_while({-1, []}, chunk_fun, after_fun)
    |> Enum.reduce(false, fn x, f -> if length(x) == 2, do: true, else: f end)
  end

  defp duplicate?(num), do: num |> Integer.digits() |> Enum.dedup() |> length() != 6
  
  defp no_decreasing?(num), 
    do: num 
        |> Integer.digits()
        |> Enum.reduce({-1, true}, 
          fn i, {previous, flag} -> 
            if i >= previous do 
              {i, flag}
            else
              {i, false}
            end
          end)
        |> elem(1)

  def result do
    IO.puts("Day1:")
    IO.puts("Part1: #{a()}")
    IO.puts("Part2: #{b()}")
  end

  defp min, do: 183564
  defp max, do: 657474
end