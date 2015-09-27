# next steps:
# add concept of multiple games
# end games

defmodule Scorekeeper do
  use GenServer

  # Determine whether the game has been won or should continue
  def game_state(state) do
    # this is intended to crash if the game erroneously reaches a state with
    # multiple winners due to players not respecting responses
    case Enum.filter(Map.to_list(state), fn({_pid, score}) -> score >= 11 end) do
      [{winner, _score}] -> {:winner, winner}
      []                 -> :ongoing
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

  # when a player wins a round they send a :won message to the scorekeeper
  # players are expected to stop playing after getting a :you_won or :you_lost
  # response.
  #
  # implemented using {:won, pid} instead of using :from to simplify testing
  def handle_call({:won, pid}, _from, scores) do
    scores = Map.put(state, pid, Map.get(state, pid, 0) + 1)
    case game_state(scores) do
      {:winner, ^pid}    -> {:reply, {:you_won,  scores}, scores}
      {:winner, _winner} -> {:reply, {:you_lost, scores}, scores}
      :ongoing           -> {:reply, {:ok,       scores}, scores}
    end
  end

  def handle_cast({:won, _player}, state) do
    {:noreply, state}
  end

end
