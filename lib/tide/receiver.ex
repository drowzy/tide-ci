defmodule Tide.Reciever do
  use GenStage
  require Logger

  def start_link(opts \\ []) do
    name = Keyword.get(opts, :job_id, "test")
    GenStage.start_link(__MODULE__, opts, name: name)
  end

  def init(opts) do
    req_fn = Keyword.get(opts, :fn)
    args = opts
    |> Keyword.get(:args)
    |> Keyword.merge(stream_to: self())
    {:ok, response} = req_fn.(args)
    {:producer, %{
        response: response,
        headers: %{},
        status: nil,
        demand: 1,
        chunks: []
    }}
  end

  def handle_info(%HTTPoison.AsyncChunk{chunk: chunk}, %{chunks: chunks} = state) do
    Logger.info("received chunk #{chunk}")

    {:noreply, [], %{state | chunks: chunks ++ chunk}}
  end

  def handle_info(%HTTPoison.AsyncStatus{code: 200}, state) do
    {:noreply, [], next(state)}
  end

  def handle_info(%HTTPoison.AsyncStatus{code: code}, state) do
    Logger.warn "Got status #{code} from #{inspect state.source}"
    {:stop, {:error, code}, state}
  end

  def handle_info(%HTTPoison.AsyncHeaders{}, state) do
    {:noreply, [], next(state)}
  end

#   def handle_info(%HTTPoison.AsyncChunk{chunk: chunk}, %{demand: demand} = state) do
#     {:noreply, [chunk], stream_next(%S{state | demand: max(0, demand - 1)})}
#   end

  def handle_info(%HTTPoison.AsyncEnd{}, state) do
    GenStage.async_info(self(), :stop)
    {:noreply, [], %{state | demand: 0, response: nil}}
  end

  defp next(%{demand: 0} = state), do: state
  defp next(%{response: response} = state) do
    {:ok, response} = HTTPoison.stream_next(response)
    %{state | response: response}
  end

end
