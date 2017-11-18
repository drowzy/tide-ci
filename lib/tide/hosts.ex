defmodule Tide.Hosts do
  alias Tide.Hosts.{SSH}

  def connect(hostname, user, opts \\ []) do
    with {:ok, ssh} = SSH.connect(hostname, user, opts),
         {:ok, pid} = Tide.Hosts.Supervisor.register(ssh, []) do
      {:ok, pid}
    else
      reason -> {:error, reason}
    end
  end

  def disconnect(hostname) do
    case Tide.Hosts.Supervisor.find_host(hostname) do
      nil -> {:error, "Process does not exist"}
      pid -> GenServer.stop(pid, :normal)
    end
  end

  def connected?(hostname) do
    case Tide.Hosts.Supervisor.find_host(hostname) do
      nil -> false
      pid -> Process.alive?(pid)
    end
  end

  def busy?(_hostname) do
    false
  end

  def get_executor do
    [{_, pid, _, _} | rest] = Tide.Hosts.Supervisor.get_hosts

    GenServer.call(pid, :forward_host)
  end
end
