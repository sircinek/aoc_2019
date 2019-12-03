defmodule Parser do
  def file_to_int_list(path) when is_binary(path) do
    path
    |> File.open([:read], &IO.read(&1, :all))
    |> elem(1)
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end

  def file_one_line_commas_to_index_map(path, index \\ 0) when is_binary(path) do
    path
    |> File.open([:read], &IO.read(&1, :all))
    |> elem(1)
    |> line_commas_to_index_map(index)
  end

  def line_commas_to_index_map(line, index) do
    line
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce({%{}, 0}, fn e, {a, i} -> {Map.put(a, i, e), i+1} end)
    |> elem(0)
    |> Map.put(:index, index)
  end

  def read_file(path) when is_binary(path) do
    path
    |> File.open([:read], &IO.read(&1, :all))
    |> elem(1)
  end
end
