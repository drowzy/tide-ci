defmodule Tide.API do
  @moduledoc """
  """
  use Plug.Router
  require Logger

  plug(Plug.Logger)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  plug(:match)
  plug(:dispatch)

  @jobs [
    %{
      "id" => "3d44c531-beab-4025-896e-592a57a15de0",
      "status" => "started | failed | finished",
      "timestamp" => 1_508_616_202,
      "finished" => 1_508_616_235,
      "executor" => "node.dev.localhost",
      project_id: "f4baff84-4932-4f28-a943-0ec0b3146d87"
    },
    %{
      "id" => "3d44c531-beab-4025-896e-592a57a15de0",
      "status" => "started | failed | finished",
      "timestamp" => 1_508_616_202,
      "finished" => 1_508_616_235,
      "executor" => "node.dev.localhost",
      project_id: "f4baff84-4932-4f28-a943-0ec0b3146d87"
    }
  ]

  get "/jobs" do
    send_resp(conn, 200, encode(%{jobs: @jobs}))
  end

  get "jobs/:id" do
    case Enum.find(@jobs, &(&1["id"] == id)) do
      nil -> send_resp(conn, 404, encode(%{error: "Resource #{id} not found"}))
      job -> send_resp(conn, 200, encode(%{job: job}))
    end
  end

  delete "jobs/:id" do
    send_resp(conn, 204, "")
  end

  put "jobs/:id" do
  end

  post "jobs" do
  end

  defp encode(body), do: Poison.encode!(body)
  defp decode(body), do: Poison.decode!(body)
end
