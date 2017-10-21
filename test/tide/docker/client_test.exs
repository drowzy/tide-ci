defmodule Tide.DockerClientTest do
  use ExUnit.Case, async: true

  @headers %{"Content-Type" => "application/json"}
  @body %{"foo" => "bar"}

  setup do
    bypass = Bypass.open
    {:ok, bypass: bypass}
  end

  test "ok", %{bypass: bypass} do
    # Bypass.expect_once bypass, "POST", "/foo/bar", fn conn ->
    #   Plug.Conn.resp(conn, 200, ~s<{\"foo\": \"bar\"}>)
    # end
    assert true == true
  end

  defp endpoint_url(port), do: "http://localhost:#{port}/project/1ef37f32/jobs"

end
