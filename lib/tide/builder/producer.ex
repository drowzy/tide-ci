defmodule Tide.Builder.Producer do
  use GenStage
  require Logger

  def start_link(opts \\ []) do
    name = Keyword.get(opts, :job_id, "test")
    GenStage.start_link(__MODULE__, opts, name: name)
  end

  def init(opts) do
    uri = Keyword.get(opts, :uri)
    stream = Keyword.get(opts, :tar_stream)

    {:ok, response} = Tide.Docker.Client.build(uri, stream, stream_to: self())

    {
      :producer,
      %{
        response: response,
        pending_demand: 0,
        status: :pending,
        chunks: []
      }
    }
  end

  def handle_demand(demand, %{chunks: chunks} = state) when demand > 0 do
    {events, new_events} = Enum.split(chunks, demand)
    pending_demand = demand - length(events)

    {:noreply, events, %{state | chunks: new_events, pending_demand: pending_demand}}
  end

  def handle_info(
        %HTTPoison.AsyncChunk{chunk: chunk},
        %{chunks: chunks, pending_demand: demand} = state
      ) do
    {events, new_chunks} = Enum.split([Poison.decode!(chunk) | chunks], demand)
    Logger.info("Received chunk #{chunk}")

    {
      :noreply,
      events,
      %{state | status: :processing, chunks: new_chunks, pending_demand: demand - length(events)}
    }
  end

  def handle_info(%HTTPoison.AsyncStatus{code: 200}, state) do
    Logger.info("received chunk code 200")
    {:noreply, [], state}
  end

  def handle_info(%HTTPoison.AsyncStatus{code: code}, state) do
    Logger.warn("Got status #{code} from")
    {:stop, {:error, code}, state}
  end

  def handle_info(%HTTPoison.AsyncHeaders{headers: headers}, state) do
    Logger.info("Receive headers #{inspect(headers)}")
    {:noreply, [], %{state | status: :started}}
  end

  def handle_info(%HTTPoison.AsyncEnd{}, %{chunks: chunks, pending_demand: demand} = state) do
    Logger.info("Receive of stream")
    {events, new_chunks} = Enum.split(chunks, demand)

    GenStage.async_info(self(), :stop)

    {:noreply, events, %{state | status: :done, pending_demand: 0, chunks: new_chunks}}
  end

  def handle_info(:stop, state), do: {:stop, :normal, state}

  defp next(%{pending_demand: 0} = state), do: state

  defp next(%{response: response} = state) do
    {:ok, response} = HTTPoison.stream_next(response)
    %{state | response: response}
  end
end
