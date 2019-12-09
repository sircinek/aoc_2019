defmodule IntCodeComputer do

  def run(result) when is_integer(result), do: result

  def run(input) do
    input
    |> action()
    |> run()
  end

  defp halt(%{0 => ret}), do: ret

  @input_value 1
  defp action(input) do
    case opcode(input) do
      # [9,9 | _ ] ->
      99 ->
         halt(input)

      # [opcode1, opcode2|  modes] -> 
      opcode -> 
        result = operation(opcode, input)
        offset = offset(opcode)
        position = position(opcode, input)
        update_code(offset, position, result, input)
    end
  end

  defp operation(_opcode = 1, input), do: input[input[index(input) + 1]] + input[input[index(input) + 2]]
  defp operation(_opcode = 2, input), do: input[input[index(input)+ 1]] * input[input[index(input) + 2]]
  defp operation(_opcode = 3, _input), do: @input_value
  defp operation(_opcode = 4, input), do: IO.puts "Output: #{input[input[index(input) + 1]]}"

  defp update_code(index_offset, position, value, input) do
    index = index(input)
    %{Map.put(input, position, value) | index: index + index_offset}
  end

  defp position(opcode, input) when opcode in [1,2] do
    input[index(input) + 3]
  end
  defp position(opcode, input) when opcode in [3,4] do
    input[index(input) + 1]
  end

  defp offset(opcode) when opcode in [1,2], do: 4
  defp offset(opcode) when opcode in [3,4], do: 2

  defp opcode(input) do
    
    input[index(input)]
  end

  defp index(%{index: i}), do: i
end