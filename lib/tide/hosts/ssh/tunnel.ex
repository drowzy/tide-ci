defmodule Tide.Hosts.SSH.Tunnel do
  alias Tide.Hosts.{SSH, TcpProxy}

  use GenServer
  require Logger

  @root_dir Application.get_env(:tide_ci, :socket_dir)
  @docker_sock "/var/run/docker.sock"

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, opts)
  end

  def init(_opts) do
    {:ok, ls} = TcpProxy.listen(Path.join(@root_dir, "/192.168.90.15.sock"))

    {
      :ok,
      %{
        ls: ls,
        channel: nil,
        ssh: nil,
        client: nil
      }
    }
  end

  def forward(pid, %SSH{} = t), do: GenServer.call(pid, {:forward, t})

  def handle_call({:forward, %SSH{} = ssh}, _from, %{ls: ls} = state) do
    pid = self()
    cb = &send(pid, {:tcp_message, &1})

    with {:open, ch} <- SSH.stream_local_forward(ssh, @docker_sock),
         {:ok, acceptor_pid} <-
           Task.Supervisor.start_child(Tide.Hosts.TaskSupervisor, fn -> acceptor(ls, cb, pid) end) do
      {:reply, :ok, %{state | channel: ch, ssh: ssh}}
    else
      error -> {:reply, error, state}
    end
  end

  def handle_info({:tcp_client, client}, state) do
    Logger.debug("TCP Client connetected")
    {:noreply, %{state | client: client}}
  end

  def handle_info({:ssh_cm, _, {:data, channel, _, data}}, %{client: client} = state) do
    Logger.debug("SSH data received on channel: #{channel}")
    :ok = TcpProxy.send_msg(client, data)
    {:noreply, state}
  end

  def handle_info({:ssh_cm, _, {:closed, channel}}, state) do
    Logger.debug("SSH channel closed: #{channel}")
    {:noreply, state}
  end

  def handle_info({:tcp_message, data}, %{ssh: %SSH{conn: conn}, channel: ch} = state) do
    Logger.debug("TCP message received")
    :ssh_connection.send(conn, ch, data)
    {:noreply, state}
  end

  defp acceptor(socket, callback, pid) do
    cs = TcpProxy.accept(socket, callback)
    send(pid, {:tcp_client, cs})
    acceptor(socket, callback, pid)
  end
end
