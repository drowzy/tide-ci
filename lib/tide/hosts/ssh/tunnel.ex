defmodule Tide.Hosts.SSH.Tunnel do
  alias Tide.Hosts.SSH

  @default_opts [:binary, active: false, reuseaddr: true, packet: 4]

  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, opts)
  end

  def init(opts) do
  end

  def forward(%SSH{} = t) do
  end
end
