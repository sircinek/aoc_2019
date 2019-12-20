defmodule IntCodeComputer do

  def run_to_halt(code, output_type) do
    case action(code, output_type) do
      {:done, result} -> result
      {:output, code} -> run_to_halt(code, output_type)
      wait = {:wait_for_input, _code} -> wait
      code -> code
    end
  end

  def run_to_output(code) do
    action(code, :output)
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
      [_opcode = 3 | modes] ->
        handle_input_opcode(code, modes)

      [opcode = 4 | modes] ->
        mode = modes(modes)
        result = operation(opcode, code, mode)
        {:output, %{code | output: result, index: index(code) + offset(opcode)}}

      [opcode = 5 | modes] ->
        jump_if(& &1 != 0, modes, code, opcode)

      [opcode = 6 | modes] ->
        jump_if(& &1 == 0, modes, code, opcode)

      [opcode | modes] ->
        modes = modes(modes)
        result = operation(opcode, code, modes)
        offset = offset(opcode)
        position = position(opcode, code, mode(:position, modes))
        update_code(offset, position, result, code)
    end
  end

  defp operation(_opcode = 1, code, modes), do: element_1(modes, code) + element_2(modes, code)
  defp operation(_opcode = 2, code, modes), do: element_1(modes, code) * element_2(modes, code)
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

  defp update_code(index_offset, position, value, code) do
    %{Map.put(code, position, value) | index: index(code) + index_offset}
  end

  defp position(opcode, code, @position) when opcode in [1,2,7,8], do:
    code[index(code) + 3]
  defp position(opcode, code, @immediate) when opcode in [1,2,7,8], do:
    index(code) + 3
  defp position(opcode, code, @position) when opcode in [3,4], do:
    code[index(code) + 1]
  defp position(opcode, code, @immediate) when opcode in [3,4], do:
    index(code) + 1

  defp offset(opcode) when opcode in [1,2,7,8], do: 4
  defp offset(opcode) when opcode in [5,6], do: 3
  defp offset(opcode) when opcode in [3,4], do: 2
  defp modes([]), do: []
  defp modes([_ | modes]), do: modes

  defp mode(:position, [_, _, mode]), do: mode
  defp mode(:element1, [mode | _]), do: mode
  defp mode(:element2, [_, mode |_ ]), do: mode
  defp mode(_, _), do: @position

  defp element_1(modes, code), do: element(mode(:element1, modes), 1, code)

  defp element_2(modes, code), do: element(mode(:element2, modes), 2, code)

  defp element(@position, offset, code), do: code[code[index(code) + offset]]
  defp element(@immediate, offset, code), do: code[index(code) + offset]

  defp opcode(code) do
    Integer.digits(code[index(code)]) |> Enum.reverse()
  end

  defp index(%{index: i}), do: i

  defp handle_input_opcode(code, modes) do
    opcode = 3
    case input(code) do
      {:ok, {input_value, inputs}} ->
        code = update_input(code, inputs)
        modes = modes(modes)
        position = position(opcode, code, mode(:position, modes))
        offset = offset(opcode)
        update_code(offset, position, input_value, code)

      wait = {:wait_for_input, _code} ->
        wait
    end
  end

  def input(%{input: i}) do
    case :queue.out(i) do
      {{:value, v}, queue} -> {:ok, {v, queue}}
      {:empty, queue} -> {:wait_for_input, queue}
    end
  end

  def update_input(code, input), do: %{code| input: input}

  def output(%{output: o}), do: o
end