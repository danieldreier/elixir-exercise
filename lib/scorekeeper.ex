
defmodule Scorekeeper do
  use GenServer

  # take a map of scores and increment the winner's
  # score by one point
  def increment(state, pid) do
    Map.put(state, pid, Map.get(state, pid, 0) + 1)
  end

  def is_victor?(state, pid) do
    case Map.get(state, pid, 0) do
      score when score >= 11 -> true
      score when score <  11 -> false
    end
  end

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    {:ok, Map.new}
  end

  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:won, pid}, _from, scores) do
    scores = increment(scores, pid)
    case is_victor?(scores, pid) do
      true  -> {:reply, {:you_won, scores}, scores}
      false -> {:reply, {:ok, scores}, scores}
    end
    # we still need to do something to start the next round
  end

  def handle_cast({:won, player}, state) do
    {:noreply, state}
  end

end
