defmodule Tide.DockerClientTest do
  use ExUnit.Case, async: true
  alias Tide.Docker.Client

  setup do
    bypass = Bypass.open
    {:ok, bypass: bypass}
  end

  test "Can send a stream to build endpoint", %{bypass: bypass} do
    Bypass.expect_once bypass, "POST", "/build", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"stream":"Step 1/4 : FROM ubuntu:14.04\n"}>)
    end

    assert %HTTPoison.Response{body: body} = Client.build(endpoint_url(bypass.port), Stream.take(["foo"], 1))
  end

  defp endpoint_url(port), do: "http://localhost:#{port}"

end
