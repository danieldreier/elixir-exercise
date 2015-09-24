defmodule Player do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    {:ok, [:some_state]}
  end

  def handle_call(_req, _from, state) do
    {:reply, :response, state}
  end

  def handle_cast(_req, state) do
    {:noreply, state}
  end
end
