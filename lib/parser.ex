defmodule Parser do
  def file_to_int_list(path) when is_binary(path) do
    path
    |> File.open([:read], &IO.read(&1, :all))
    |> elem(1)
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end
end
