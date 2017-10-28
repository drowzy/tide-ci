defmodule Tide.Docker.Stream do
  @moduledoc """
  Process to turn an AsyncResponse into a GenStage producer
  """
  use GenStage
  require Logger

  def start_link(opts \\ []) do
    GenStage.start_link(__MODULE__, opts, opts)
  end

  def init(_) do
    {:producer, %{demand: 0, chunks: []}}
  end

  def handle_demand(demand, %{chunks: chunks} = state) when demand > 0 do
    {events, new_events} = Enum.split(chunks, demand)
    pending_demand = demand - length(events)

    {:noreply, events, %{state | chunks: new_events, demand: pending_demand}}
  end

  def handle_info(
        %HTTPoison.AsyncChunk{chunk: chunk},
        %{chunks: chunks, demand: demand} = state
      ) do
    {events, new_chunks} = Enum.split([
      {:chunk, Poison.decode!(chunk)} | chunks
    ], demand)

    {
      :noreply,
      events,
      %{state | chunks: new_chunks, demand: demand - length(events)}
    }
  end

  def handle_info(%HTTPoison.AsyncStatus{code: code}, state) do
    {:noreply, [{:status, code}], state}
  end

  def handle_info(%HTTPoison.AsyncHeaders{headers: headers}, state) do
    {:noreply, [{:headers, headers}], state}
  end

  def handle_info(%HTTPoison.AsyncEnd{}, %{chunks: chunks, demand: demand} = state) do
    {events, new_chunks} = Enum.split(chunks, demand)

    GenStage.async_info(self(), :stop)

    {:noreply, events, %{state | chunks: new_chunks}}
  end

  def handle_info(:stop, state), do: {:stop, :normal, state}
end
