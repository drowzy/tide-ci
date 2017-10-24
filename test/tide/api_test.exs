defmodule Tide.APITest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Tide.API

  @opts API.init([])
  @valid_payload %{}

  @invalid_payload %{}
  @missing_fields %{}

  test "GET /jobs" do
    conn =
      conn(:get, "/jobs", "")
      |> API.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
  end

  test "GET /jobs/{id}" do
    id = "3d44c531-beab-4025-896e-592a57a15de0"

    conn =
      conn(:get, "/jobs/#{id}", "")
      |> API.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
  end

  # test "POST /jobs valid payload" do
  #   conn = conn(:post, "/jobs", %{"job" => @valid_payload })
  #   |> put_req_header("content-type", "application/json")
  #   |> API.call(@opts)

  #   assert conn.state == :sent
  #   assert conn.status == 201
  #   assert Poison.decode!(conn.resp_body) == @valid_payload
  # end

  # test "POST /jobs missing fields" do
  #   conn = conn(:post, "/jobs", %{"job" => @missing_fields })
  #   |> put_req_header("content-type", "application/json")
  #   |> API.call(@opts)

  #   assert conn.state == :sent
  #   assert conn.status == 422
  # end

  test "DELETE /jobs" do
    id = "3d44c531-beab-4025-896e-592a57a15de0"

    conn =
      conn(:delete, "/jobs/#{id}", "")
      |> API.call(@opts)

    assert conn.state == :sent
    assert conn.status == 204
  end
end
