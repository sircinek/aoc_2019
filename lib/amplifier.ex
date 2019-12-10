defmodule Amplifier do
  use GenServer

  def start_link(code, phase) do
    GenServer.start_link(__MODULE__, [code, phase])
  end

  def register_amplifier(pid, amplifier) do
    GenServer.handle_cast(pid, {:register_amplifier, amplifier})
  end

  def input_signal(pid, input) do
    send(pid, {:input, input})
  end

  def init([code, phase]) do
    {:noreply, %{code: code, phase: phase, amplifier: nil}, {:continue, phase}}
  end

  def handle_continue({:continue, phase}, data) do
    run_code(phase, data)
    {:noreply, data}
  end

  def handle_cast({:register_amplifier, amplifier}, data) do
    {:noreply, %{data| amplifier: amplifier}}
  end

  def handle_info({:input, input}, data = %{code: code}) do
    run_code(input, data)
  end

  def run_code(input, %{code: code, amplifier: _amp}) do
    code
    |> IntCodeComputer.add_input(input)
    |> IntCodeComputer.run(:output)
  end


end