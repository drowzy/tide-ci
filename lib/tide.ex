defmodule Tide do
  @moduledoc """
  Application module
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, Tide.API, [], port: 1666),
      supervisor(Task.Supervisor, [[name: Tide.Hosts.TaskSupervisor]]),
      supervisor(Tide.Hosts.Supervisor, []),
      supervisor(Tide.Job.Supervisor, [])
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Tide.Supervisor)
  end
end
