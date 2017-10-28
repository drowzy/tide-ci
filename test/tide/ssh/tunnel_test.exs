defmodule Tide.SSH.TunnelTest do
  use ExUnit.Case

  alias Tide.SSH.Tunnel

  setup do
    # Temp.track!()
    # dir = Temp.mkdir!("tide-repo")
    tunnel = Tunnel.new(
      from: "/var/run/docker.sock",
      to: "/var/run/docker.sock",
      direction: :local,
    )
    {:ok, %{tunnel: tunnel}}
  end

  test "#new creates a %Tunnel struct", %{tunnel: tunnel} do
    assert tunnel.to == "/var/run/docker.sock"
    assert tunnel.to == "/var/run/docker.sock"
    assert tunnel.direction == :local
  end

  test "#uri returns a http+unix uri if path ends in .sock", %{tunnel: tunnel} do
    uri = tunnel
    |> Tunnel.uri
    |> String.contains?("http+unix://")
  end

  test "#uri returns a the local hostname if port forwarding", %{tunnel: tunnel} do
    uri = tunnel
    |> Map.put(:from, "4040")
    |> Tunnel.uri
    |> String.contains?("http://127.0.0.1")
  end

end
