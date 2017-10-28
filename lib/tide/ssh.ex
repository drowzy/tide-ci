defmodule Tide.SSH do
  @socket_dir Application.get_env(:tide, __MODULE__)
  alias Tide.SSH.Tunnel

  def forward(%Tunnel{} = t) do
  end

  def open? do
  end
end
