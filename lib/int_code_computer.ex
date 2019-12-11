defmodule IntCodeComputer do

  def run(code, output) do
    try do
      case action(code, output) do
        {:done, result} -> result
        code -> run(code, output)
      end
    catch caught -> caught
    end
  end

  def add_input(code, input_value) do
    update_fn =
      fn(nil) ->  {nil, :queue.in(input_value, :queue.new())}
        queue -> {queue, :queue.in(input_value, queue)}
      end

    code
    |> Map.get_and_update(:input, update_fn)
    |> elem(1)
  end

  defp halt(code, :output), do: {:done, output(code)}
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
        %{add_output(code, result) | index: index(code) + offset(opcode)}

      [opcode = 5 | modes] ->
        jump_if(& &1 != 0, modes, code, opcode)

      [opcode = 6 | modes] ->
        jump_if(& &1 == 0, modes, code, opcode)

      [opcode | modes] ->
        modes = modes(modes)
        result = operation(opcode, code, modes)
        offset = offset(opcode)
        position = position(opcode, code, mode(:position, modes))
        update_code(offset, position, result, code, opcode)
    end
  end

  defp operation(_opcode = 1, code, modes), do: element_1(modes, code) + element_2(modes, code)
  defp operation(_opcode = 2, code, modes), do: element_1(modes, code) * element_2(modes, code)
  defp operation(_opcode = 3, code,_modes), do: input(code)
  defp operation(_opcode = 4, code, modes), do: element_1(modes, code)
  defp operation(_opcode = 7, code, modes), do: less_or_equal(& &1 < &2, modes, code)
  defp operation(_opcode = 8, code, modes), do: less_or_equal(& &1 == &2, modes, code)

  defp less_or_equal(check, modes, code) do
    if check.(element_1(modes, code), element_2(modes, code)), do: 1, else: 0
  end

  defp jump_if(checker, modes, code, opcode) do
    modes = modes(modes)
    param1 = element_1(modes, code)
    param2 = element_2(modes, code)
    if checker.(param1) do
      %{code | index: param2}
    else
      %{code | index: index(code) + offset(opcode)}
    end
  end

  defp update_code(index_offset, position, value, code, _opcode = 3) do
    %{Map.put(code, position, value) | input: :queue.drop(code.input), index: index(code) + index_offset}
  end

  defp update_code(index_offset, position, value, code, _opcode) do
    %{Map.put(code, position, value) | index: index(code) + index_offset}
  end

  defp position(opcode, code, @position) when opcode in [1,2,7,8] do
    code[index(code) + 3]
  end

  defp position(opcode, code, @immediate) when opcode in [1,2,7,8] do
    index(code) + 3
  end

  defp position(opcode, code, @position) when opcode in [3,4] do
    code[index(code) + 1]
  end

  defp position(opcode, code, @immediate) when opcode in [3,4] do
    index(code) + 1
  end

  defp offset(opcode) when opcode in [1,2,7,8], do: 4
  defp offset(opcode) when opcode in [5,6], do: 3
  defp offset(opcode) when opcode in [3,4], do: 2
  defp modes([]), do: []
  defp modes([_ | modes]), do: modes

  defp mode(:position, [_, _, mode]), do: mode
  defp mode(:element1, [mode | _]), do: mode
  defp mode(:element2, [_, mode |_ ]), do: mode
  defp mode(_, _), do: @position

  defp element_1(modes, code) do
    element(mode(:element1, modes), 1, code)
  end

  defp element_2(modes, code) do
    element(mode(:element2, modes), 2, code)
  end

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

  defp input(code = %{input: i}) do
    case :queue.out(i) do
      {{:value, v}, _queue} -> v
      {:empty, _queue} -> throw({:break, code})
    end
  end
  defp output(%{output: o}), do: o

  defp add_output(code = %{output: o}, o1), do: %{code | output: o ++ [o1]}
end