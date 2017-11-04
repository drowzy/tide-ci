defmodule Tide.Hosts.SSH.Tunnel do
  alias Tide.Hosts.{SSH, TcpProxy}

  use GenServer

  @root_dir Application.get_env(:tide_ci, :socket_dir)
  @docker_sock "/var/run/docker.sock"

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, opts)
  end

  def init(_opts) do
    {:ok, ls} = TcpProxy.listen(Path.join(@root_dir, "/test.sock"))
    {:ok, %{
        ls: ls,
        channel: nil,
        clients: []
     }}
  end

  def forward(pid, %SSH{} = t), do: GenServer.call(pid, {:forward, t})

  def handle_call({:forward, %SSH{} = ssh}, _from, %{ls: ls} = state) do
    pid = self()
    cb = &(send(pid, {:tcp_message, &1}))

    with {:open, ch} <- SSH.stream_local_forward(ssh, @docker_sock),
         {:ok, acceptor_pid} <- Task.Supervisor.start_child(Tide.Hosts.TaskSupervisor, fn -> acceptor(ls, cb, pid) end)
      do
        {:reply, :ok, %{state | channel: ch}}
      else
        error -> {:reply, error, state}
    end
  end

  defp acceptor(socket, callback, pid) do
    cs = TcpProxy.accept(socket, callback)
    send(pid, {:tcp_client, cs})
    acceptor(socket, callback, pid)
  end
end
