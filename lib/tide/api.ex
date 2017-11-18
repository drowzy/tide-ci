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
      "id" => "1",
      "name" => "tide-ci",
      "repository" => %{
        "name" => "tide-ci",
        "path" => "~/tide/tide-ci",
        "uri" => "git@github.com:drowzy/tide-ci.git"
      },
      "timestamp" => 1_508_616_202,
      "finished" => 1_508_616_235,
      "executor" => "node.dev.localhost",
      project_id: "f4baff84-4932-4f28-a943-0ec0b3146d87"
    },
    %{
      "id" => "2",
      "repository" => %{
        "name" => "rql",
        "path" => "~/tide/rql",
        "uri" => "git@github.com:drowzy/rql.git"
      },
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

  put "jobs/:id/build" do
    job = Enum.find(@jobs, &(&1["id"] == id))
    %{"name" => name, "path" => path, "uri" => uri} = job["repository"]
    {:ok, job} = Tide.Job.start(uri, Tide.Hosts.get_executor())
    send_resp(conn, 201, encode(%{"status" => "started"}))
  end

  post "jobs" do
  end

  post "hosts" do
    %{"ip" => ip, "username" => user} = conn.body_params
    {:ok, _pid} = Tide.Hosts.connect(ip, user)
    send_resp(conn, 201, encode(%{"ip" => ip, "status" => "connected"}))
  end

  defp encode(body), do: Poison.encode!(body)
  defp decode(body), do: Poison.decode!(body)
end
