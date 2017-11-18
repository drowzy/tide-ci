defmodule Tide.Hosts.SSH.Tunnel do
  alias Tide.Hosts.{SSH, TcpProxy}

  use GenServer
  require Logger

  @root_dir Application.get_env(:tide_ci, :socket_dir)
  @docker_sock "/var/run/docker.sock"

  def start_link(ssh, opts \\ []) do
    GenServer.start_link(__MODULE__, ssh, opts)
  end

  def init(%SSH{host: host} = ssh) do
    {:ok, ls} = TcpProxy.listen(Path.join(@root_dir, "/#{host}.sock"))

    send(self(), :forward)
    {
      :ok,
      %{
        ls: ls,
        channel: nil,
        ssh: ssh,
        client: nil
      }
    }
  end

  def handle_call(:forward_host, _from, %{ssh: ssh} = state), do: {:reply, ssh.host, state}

  def handle_info(:forward, %{ls: ls, ssh: ssh} = state) do
    pid = self()
    cb = &send(pid, {:tcp_message, &1})

    with {:open, ch} <- SSH.stream_local_forward(ssh, @docker_sock),
         {:ok, _acceptor_pid} <-
           Task.Supervisor.start_child(Tide.Hosts.TaskSupervisor, fn -> acceptor(ls, cb, pid) end) do
      {:noreply, %{state | channel: ch, ssh: ssh}}
    else
      error ->
        Logger.error("SSH forward to #{ssh.host} failed with #{inspect error}")
        Process.send_after(self(), :forward, 1000)
        {:noreply, state}
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
