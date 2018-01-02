defmodule Tide.Hosts do
  alias Tide.Hosts.{SSH}

  def connect(id, hostname, user, opts \\ []) do
    with {:ok, ssh} = SSH.connect(hostname, user, opts),
         {:ok, pid} = Tide.Hosts.WorkerSupervisor.register(ssh, via_tuple(id), []) do
      {:ok, pid}
    else
      reason -> {:error, reason}
    end
  end

  def connected?(hostname) do
    case Tide.Hosts.WorkerSupervisor.find_host(hostname) do
      nil -> false
      pid -> Process.alive?(pid)
    end
  end

  def busy?(_hostname) do
    false
  end

  def get_executor do
    [{_, pid, _, _} | rest] = Tide.Hosts.WorkerSupervisor.get_hosts()

    GenServer.call(pid, :forward_host)
  end

  def disconnect(pid) when is_pid(pid), do: GenServer.stop(pid, :normal)
  def disconnect(name) do
    name
    |> via_tuple
    |> disconnect
  end

  defp via_tuple(host_id) do
    {:via, Registry, {Tide.Hosts.Registry, host_id}}
  end
end
