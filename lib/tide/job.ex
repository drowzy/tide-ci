defmodule Tide.Job do
  @moduledoc """
  Manages the lifecycle of a 'job'.
  This process starts a build and attaches a producer to stream the result,
  the result is aggregated to determine the status of the build
  """
  use GenStage
  require Logger

  @doc """
  """
  def start_link(opts \\ []) do
    GenStage.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(opts) do
    uri = Keyword.get(opts, :uri)
    repo = Keyword.get(opts, :repo)

    {:ok, pid, response} =
      repo
      |> Tide.Repository.archive!
      |> start_build(uri)

    {:consumer, %{
        repo: repo,
        uri: uri,
        response: response,
        status_stream: pid,
        log: [],
        status: :pending
     }, subscribe_to: [pid]
    }
  end

  def status(pid), do: GenStage.call(pid, :status)

  def log(pid), do: GenStage.call(pid, :log)

  def handle_events(events, _from, state) do
    {:noreply, [], process_events(events, state)}
  end

  def handle_info({_, :stop}, state) do
    Logger.info("STOPPING CONSUMER")
    {:stop, :normal, state}
  end

  def handle_call(:status, _from, %{status: status}, state),
    do: {:reply, {:ok, status}, state}

  def handle_call(:log, _from, %{status_stream: pid} = state) do
    stream = GenStage.stream([{pid, cancel: :transient}])

    {:reply, {:ok, stream}, state}
  end

  defp process_events(events, state),
    do: List.foldl(events, state, &process_event/2)

  defp process_event({:chunk, chunk}, %{log: log} = state) do
    Logger.info("Log :: #{inspect chunk}")
    %{state | log: [chunk | log], status: :building}
  end

  defp process_event({:headers, _headers}, state), do: state

  defp process_event({:status, code}, state) do
    case code do
      200 -> %{state | status: :started}
      _code -> %{state | status: :failed}
    end
  end

  defp start_build(tar_stream, uri) do
    {:ok, pid} =  Tide.Docker.Stream.start_link
    {:ok, response} = Tide.Docker.Client.build(uri, tar_stream, stream_to: pid)
    {:ok, pid, response}
  end

end
