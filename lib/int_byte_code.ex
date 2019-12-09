defmodule IntCodeComputer do

  def run(result) when is_integer(result), do: result

  def run(input) do
    input
    |> action()
    |> run()
  end

  defp halt(%{0 => ret}), do: ret

  defp action(input) do
    opcode = opcode(input)
    case opcode do
      1 ->
        result = input[input[i + 1]] + input[input[input + 2]]
        offset = offset(opcode)
        position = position(opcode, input)
        update_code(offset, position, result, input)
      2 ->
        result = input[input[i + 1]] * input[input[input + 2]]
        offset = offset(opcode)
        position = position(opcode, input)
        update_code(offset, position, result, input)
      99 -> halt(input)
    end
  end


  defp update_code(index_offset, position, value, input) do
    index = index(input)
    %{Map.put(input, position, value) | index: index + index_offset}
  end

  defp position(opcode, input) when opcode in [1,2] do
    input[index(input + 3)]
  end

  defp offset(opcode) when opcode in [1,2], do: 4

  defp opcode(input), do: input[index(input)]

  defp index(%{index: i}), do: i
end