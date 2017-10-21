defmodule Tide do
  @moduledoc """
  Application module
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # supervisor(Ahab.Docker.Supervisor, []),
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: __MODULE__)
  end
end
