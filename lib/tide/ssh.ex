defmodule Tide.SSH do
  @socket_dir Application.get_env(:tide_ci, :socket_dir)
  @target_socket "/var/run/docker.sock"

  use GenServer
  require Logger

  alias Tide.SSH.Tunnel
  alias Porcelain.Process, as: Proc

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(opts) do
    :ok = File.mkdir_p(@socket_dir)
    {:ok, %{hosts: %{}}}
  end

  def connect(pid, hostname), do: GenServer.call(pid, {:connect, hostname})
  def disconnet(pid, hostname), do: GenServer.call(pid, {:disconnect, hostname})

  def up?(pid, hostname) do
    GenServer.call(pid, {:open, hostname})
  end

  def handle_call({:connect, host}, _from, %{hosts: hosts} = state) do
    if Map.has_key?(hosts, hosts) do
      {:reply, {:error, :already_exists}, state}
    else
      {tunnel, proc} = tunnel_opts(host, "ubuntu")
      new_state = Map.put(state, host, %{tunnel: tunnel, hostname: host, proc: proc})

      {:reply, :ok, new_state}
    end
  end

  def handle_info({pid, :data, :out, data}, state) do
    IO.puts("#{inspect data}")
    {:noreply, state}
  end

  def handle_info({pid, :result, result}, state) do
    IO.puts("Got result from spawn")
    # Remove the socket
    # delete the socket from disc
    {:noreply, state}
  end

  def handle_info(something, state) do
    IO.puts("Something else from the process")
    {:noreply, state}
  end

  # TODO should be possible to provide user, pass,
  # or private key.
  defp tunnel_opts(host, user) do
    tunnel = Tunnel.new(from: "#{@socket_dir}/#{host}.sock", to: @target_socket)
    args = Tunnel.args(tunnel)
    proc = Porcelain.spawn("ssh", args ++ ["#{user}@#{host}"], in: :receive, out: {:send, self()})

    {tunnel, proc}
  end
end
