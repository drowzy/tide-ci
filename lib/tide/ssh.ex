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

  @doc """
  Forwards a socket to the hosts docker socket
  """
  def connect(pid, hostname), do: GenServer.call(pid, {:connect, hostname})

  @doc """
  Disconnect the tunnel
  """
  def disconnect(pid, hostname), do: GenServer.cast(pid, {:disconnect, hostname})

  @doc"""
  Retrieves the tunnel uri for the provided hostname
  """
  def tunnel_uri(pid, hostname), do: GenServer.call(pid, {:uri, hostname})

  @doc"""
  Checks is there's a open tunnel to the provided hostname
  """
  def up?(pid, hostname), do: GenServer.call(pid, {:up, hostname})

  def handle_cast({:disconnect, host}, %{hosts: hosts} = state) do
    {:noreply, %{state | hosts: remove(hosts, Map.get(hosts, host))}}
  end

  def handle_call({:connect, host}, _from, %{hosts: hosts} = state) do
    if Map.has_key?(hosts, host) do
      {:reply, {:error, :already_exists}, state}
    else
      {tunnel, proc} = tunnel_opts(host, "ubuntu")
      hosts = Map.put(hosts, host, %{tunnel: tunnel, hostname: host, proc: proc})

      {:reply, :ok, %{state | hosts: hosts}}
    end
  end

  def handle_call({:up, host}, _from, %{hosts: hosts} = state) do
    alive? = hosts
    |> Map.get(host)
    |> Map.get(:proc)
    |> Proc.alive?

    {:reply, {:ok, alive?}, state}
  end

  def handle_call({:uri, host}, _from, %{hosts: hosts} = state) do
    uri =
      hosts
      |> Map.get(host)
      |> Map.get(:tunnel)
      |> Tunnel.uri

    {:reply, {:ok, uri}, state}
  end

  def handle_info({pid, :data, :out, data}, state), do: {:noreply, state}
  def handle_info({pid, :data, :err, data}, state) do
    Logger.error("Error from process #{data}")
    {:noreply, state}
  end

  def handle_info({pid, :result, result}, %{hosts: hosts} = state) do
    entry = hosts
    |> Map.values
    |> Enum.find(fn %{proc: proc} -> proc.pid == pid end)

    hosts = remove(hosts, entry)

    {:noreply, %{state | hosts: hosts }}
  end

  def handle_info(res, state) do
    Logger.info("This should not be able to happend")
    {:noreply, state}
  end

  # TODO should be possible to provide user, pass,
  # or private key.
  defp tunnel_opts(host, user) do
    tunnel = Tunnel.new(from: socket_path(host), to: @target_socket)
    args = ["ssh", "-o", ~s(ExitOnForwardFailure\syes)] ++ Tunnel.args(tunnel) ++ ["#{user}@#{host}"]
    cmd = Application.app_dir(:tide_ci, "priv/wrapper.sh")

    Logger.info(Enum.join(args, " "))
    Logger.info(inspect args)
    # Tide.SSH.connect(Tide.SSH, "192.168.90.15")
    # proc = Porcelain.spawn("ssh", args, in: :receive, out: {:send, self()}, err: {:send, self()})
    proc = Porcelain.spawn(cmd, args, in: :receive, out: {:send, self()}, err: {:send, self()})

    Logger.info(inspect proc)

    {tunnel, proc}
  end

  defp remove(hosts, nil), do: hosts
  defp remove(hosts, %{proc: proc, hostname: hostname}) do
    res = Proc.stop(proc)

    Logger.info("Removing process #{inspect res}")

    _socket = remove_socket(hostname)

    Map.delete(hosts, hostname)
  end

  defp socket_path(host), do: "#{@socket_dir}/#{host}.sock"
  defp remove_socket(host) do
    case File.rm(socket_path(host)) do
      :ok -> {:ok, host}
      {:error, :enoent} -> {:ok, host}
      {:error, reason} -> {:error, reason}
    end
  end
end
