defmodule Tide.DockerClientTest do
  use ExUnit.Case, async: true

  setup do
    Tesla.Mock.mock fn
      %{method: :get, url: "http://example.com/hello"} ->
        %Tesla.Env{status: 200, body: "hello"}
      %{method: :post, url: "http://example.com/world"} ->
        %Tesla.Env{status: 200, body: "hi!"}
    end
  end

  test "ok" do
    # Bypass.expect_once bypass, "POST", "/foo/bar", fn conn ->
    #   Plug.Conn.resp(conn, 200, ~s<{\"foo\": \"bar\"}>)
    # end
    assert true == true
  end

  defp endpoint_url(port), do: "http://localhost:#{port}/project/1ef37f32/jobs"

end
