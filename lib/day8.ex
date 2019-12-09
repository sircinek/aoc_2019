defmodule Aoc2019.Day8 do
  @moduledoc """
  Day 8 of Advent of Code 2019.
  """
  @width 25
  @height 6

  @doc """
  First problem.

  ## Examples

  """
  def a(input \\ input()) do
    input
    |> Enum.chunk_every(@height * @width)
    |> Enum.map(fn(el) -> Enum.reduce(el, {0,0,0}, &count_digits/2) end)
    |> Enum.min_by(fn {zeros, _, _} -> zeros end)
    |> multiply()
  end

  @doc """
  Second problem.

  ## Examples

  """

  def b(input \\ input()) do
    input
    |> Enum.chunk_every(@width)
    |> Enum.chunk_every(@height)
    |> reduce_layers()
  end

  defp reduce_layers(layers) do
    result_map = 
      layers
      |> Enum.reduce(%{}, 
        fn layer, acc -> 
          {_, ret} = Enum.reduce(layer, {0, acc}, fn row, {row_no, acc} -> 
            {_, line} = Enum.reduce(row, {0, acc}, fn digit, {column_no, acc} -> 
              {_, map} = Map.get_and_update(acc, {column_no, row_no},
              fn val when val == 2 or val == nil -> {val, digit}
                val -> {val, val}
              end)
              {column_no + 1, map}  
            end)
            {row_no + 1, line}
          end)
          ret
        end)

    {_, res} = Enum.reduce(result_map, {{0, 0}, ""}, fn _, {{x, y}, txt} -> 
      new_acc = 
        case Map.get(result_map, {x, y}) do
          0 -> txt <> "X"
          1 -> txt <> " "
        end
      case x do
        24 -> {{0, y + 1}, new_acc <> "\n"}
        _ -> {{x + 1, y}, new_acc}
      end
    end)
    IO.puts "#{res}"
  end

  defp multiply({_, ones, twos}), do: ones * twos

  defp count_digits(0, {zeros, ones, twos}), do: {zeros + 1, ones, twos}
  defp count_digits(1, {zeros, ones, twos}), do: {zeros, ones + 1, twos}
  defp count_digits(2, {zeros, ones, twos}), do:  {zeros, ones, twos + 1}

  def input do
    "inputs/day8.txt"
    |> Parser.read_file()
    |> string_to_digits([])
  end

  defp string_to_digits(<<>>, acc), do: Enum.reverse(acc)
  defp string_to_digits(<<d,rem::binary>>, acc) do
    case d do
      ?0 -> string_to_digits(rem, [0|acc])
      ?1 -> string_to_digits(rem, [1|acc])
      ?2 -> string_to_digits(rem, [2|acc])
    end
  end
end