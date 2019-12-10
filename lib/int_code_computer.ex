defmodule IntCodeComputer do

  def run(code, output) do
     case action(code, output) do
       {:done, result} -> result
       code -> run(code, output)
     end
  end

  defp halt(%{output: o}, :output), do: {:done, o}
  defp halt(%{0 => ret}, :zero), do: {:done, ret}
  defp halt(code, :code), do: {:done, code}

  @position 0
  @immediate 1
  defp action(code, output) do
    case opcode(code) do
      [9, 9 | _ ] ->
         halt(code, output)
      [opcode = 4 | modes] ->
        mode = modes(modes)
        result = operation(opcode, code, mode)
        # IO.puts "Ret #{inspect code.index}, next cmd #{inspect code[code.index]}"
        # IO.puts "Output: #{result}"
        ret = %{add_output(code, result) | index: index(code) + offset(opcode)}
        # IO.puts "Ret #{inspect ret.index}, next cmd #{inspect ret[ret.index]}"
        ret

      [opcode | opcode2_modes] ->
        # IO.puts "opcode #{opcode}, modes #{inspect opcode2_modes}"
        modes = modes(opcode2_modes)
        result = operation(opcode, code, modes)
        offset = offset(opcode)
        position = position(opcode, code, mode(:position, modes))
        update_code(offset, position, result, code)
    end
  end

  defp operation(_opcode = 1, code, modes), do: element(mode(:element1, modes), 1, code) + element(mode(:element2, modes), 2, code)
  defp operation(_opcode = 2, code, modes), do: element(mode(:element1, modes), 1, code) * element(mode(:element2, modes), 2, code)
  defp operation(_opcode = 3, code,_modes), do: input(code)
  defp operation(_opcode = 4, code, mode) when mode in [[@position], []], do: element(@position, 1, code)
  defp operation(_opcode = 4, code, [@immediate]), do: element(@immediate, 1, code)

  defp update_code(index_offset, position, value, code) do
    index = index(code)
    # IO.puts "Update code at #{position}, put #{value}, old index #{index}"
    %{Map.put(code, position, value) | index: index + index_offset}
  end

  defp position(opcode, code, @position) when opcode in [1,2] do
    code[index(code) + 3]
  end

  defp position(opcode, code, @immediate) when opcode in [1,2] do
    index(code) + 3
  end

  defp position(opcode, code, @position) when opcode in [3,4] do
    code[index(code) + 1]
  end

  defp position(opcode, code, @immediate) when opcode in [3,4] do
    index(code) + 1
  end

  defp offset(opcode) when opcode in [1,2], do: 4
  defp offset(opcode) when opcode in [3,4], do: 2
  defp modes([]), do: []
  defp modes([_ | modes]), do: modes

  defp mode(:position, [_, _, mode]), do: mode
  defp mode(:element1, [mode | _]), do: mode
  defp mode(:element2, [_, mode |_ ]), do: mode
  defp mode(_, _), do: @position

  defp element(@position, offset, code) do
    code[code[index(code) + offset]]
  end
  defp element(@immediate, offset, code) do
    code[index(code) + offset]
  end

  defp opcode(code) do
    Integer.digits(code[index(code)]) |> Enum.reverse()
  end

  defp index(%{index: i}), do: i

  defp input(%{input: i}), do: i
  defp output(%{output: o}), do: o

  defp add_output(code = %{output: o}, o1), do: %{code | output: o ++ [o1]}
end