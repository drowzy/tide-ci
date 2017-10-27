defmodule Tide.Build do
  use GenServer

  @doc """
  """
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(opts) do
    uri = Keyword.get(opts, :uri)
    repo = Keyword.get(opts, :repo)

    {:ok, pid, response} =
      repo
      |> Tide.Repository.archive!
      |> proccess_setup(uri)

    {:ok, %{
        repo: repo,
        uri: uri,
        status_pid: pid,
        response: response
     }
    }
  end

  def status(pid), do: GenServer.call(pid, :status)

  def handle_call(:status, _from, %{status_pid: pid} = state) do
    stream = GenStage.stream([{pid, cancel: :transient}])
    {:reply, {:ok, stream}, state}
  end

  defp proccess_setup(tar_stream, uri) do
    {:ok, pid} =  Tide.Build.Status.start_link
    {:ok, response} = Tide.Docker.Client.build(uri, tar_stream, stream_to: pid)
    {:ok, pid, response}
  end

end
