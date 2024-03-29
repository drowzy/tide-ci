defmodule Tide.Hosts.WorkerSupervisor do
  @moduledoc """
  """
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    children = [worker(Tide.Hosts.SSH.Tunnel, [], restart: :transient)]

    supervise(children, strategy: :simple_one_for_one)
  end

  def register(ssh, name, opts) do
    Supervisor.start_child(__MODULE__, [ssh, Keyword.merge(opts, name: name)])
  end

  def get_hosts, do: Supervisor.which_children(__MODULE__)

  def find_host(name) do
    IO.puts(name)
    IO.puts("inspect #{get_hosts()}")
    get_hosts()
    |> Enum.find(fn {%{name: process_name}, _, _, _} ->
         name == process_name
       end)
  end
end
