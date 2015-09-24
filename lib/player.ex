defmodule Player do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    {:ok, [:some_state]}
  end

  def handle_call(:ball, _from, state) do
    {:reply, maybe(), state}
  end

  def handle_cast(_req, state) do
    {:noreply, state}
  end

  # private

  defp maybe do
    maybe(:random.uniform)
  end

  defp maybe(num) when num > 0.33 do
    :hit
  end

  defp maybe(num) do
    :miss
  end

end
