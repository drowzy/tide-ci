defmodule Tide.Hosts.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    children = [
      supervisor(Task.Supervisor, [[name: Tide.Hosts.TaskSupervisor]]),
      supervisor(Tide.Hosts.WorkerSupervisor, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
