defmodule Tide do
  @moduledoc """
  Application module
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Tide.Repo, []),
      supervisor(TideWeb.Endpoint, []),
      supervisor(Tide.Hosts.Supervisor, []),
      supervisor(Registry, [:unique, Job.Registry]),
      supervisor(Tide.Job.Supervisor, [])
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Tide.Supervisor)
  end
end
