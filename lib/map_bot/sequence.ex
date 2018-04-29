defmodule MapBot.Sequence do
  @moduledoc """
  A simple GenServer to store sequence state.
  """

  use GenServer

  def start_link(state), do: GenServer.start_link(__MODULE__, state, name: __MODULE__)

  @impl true
  def init(state), do: {:ok, state}

  def next_int(), do: GenServer.call(__MODULE__, :next_int)

  @impl true
  def handle_call(:next_int, _from, next), do: {:reply, next, next + 1}
end
