defmodule Amplifier do
  use GenServer

  def start_link(code, phase) do
    GenServer.start_link(__MODULE__, [code, phase])
  end

  def calculate_output(pid, input) do
    GenServer.call(pid, {:input, input})
  end

  def init([code, phase]) do
    {:ok, %{code: code}}
    {:ok, %{code: code}, {:continue, {:phase, phase}}}
  end

  def handle_continue({:phase, phase}, data) do
    code = run_code(phase, :code, data)
    {:noreply, %{data| code: code}}
  end

  def handle_call({:input, input}, _, data) do
    [result] = run_code(input, :output, data)
    {:reply, result, data}
  end

  def run_code(input, mode, %{code: code}) do
    code
    |> IntCodeComputer.add_input(input)
    |> IntCodeComputer.run(mode)
  end
end