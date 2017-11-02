defmodule Tide.Hosts.TcpProxy do
  @default_opts [:binary, active: false, reuseaddr: true, packet: 4]

  def listen(path, pid) do
    opts = @default_opts ++ [ifaddr: {:local, socket_path("/tmp/tide/sockets/test.sock")}]
    {:ok, ls} = :gen_tcp.listen(0, opts)

    accept(ls, pid)
  end

  def accept(socket, pid) do
    {:ok, client_socket} = :gen_tcp.accept(socket)
    {:ok, handler_pid} = Task.Supervisor.start_child(Tide.Hosts.TaskSupervisor, fn ->

    end)
  end

  defp handle_connection(socket, pid) do
    case :gen_tcp.recv(socket, 0) do
      {:error, :closed} ->
        IO.puts(:stder, "Socket is closed")
      {:ok, data} ->
        send(pid, {:tcp_proxy, data})
    end
  end

  defp socket_path(path), do: String.to_charlist(path)

end
