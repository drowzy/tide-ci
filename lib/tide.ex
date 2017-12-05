defmodule Tide do
  @moduledoc """
  Application module
  """
  use Application

  @repo_dir Application.get_env(:tide_ci, :repo_dir)
  @socket_dir Application.get_env(:tide_ci, :socket_dir)

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Tide.Boot, [[@repo_dir, @socket_dir]], restart: :transient),
      supervisor(Tide.Repo, []),
      supervisor(TideWeb.Endpoint, []),
      supervisor(Tide.Hosts.Supervisor, []),
      supervisor(Registry, [:unique, Job.Registry]),
      supervisor(Tide.Job.Supervisor, [])
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Tide.Supervisor)
  end
end
