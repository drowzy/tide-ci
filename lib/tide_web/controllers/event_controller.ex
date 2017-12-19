defmodule TideWeb.EventController do
  use TideWeb, :controller
  require Logger

  alias Tide.Schemas.Project
  alias Tide.Job

  @event "x-github-event"

  def handler(conn, params) do
    event =
      conn
      |> Plug.Conn.get_req_header(@event)
      |> List.first

    Logger.info("Recevied Event params: #{event}")

    res = case event do
      "push" -> handle_push(params)
      "ping" -> :ok
      nil -> :not_found
    end

    conn
    |> put_status(res)
    |> json(%{})
  end

  defp handle_push(params) do
    Logger.info("Handle push event for #{Kernel.get_in(params, ["repository", "full_name"])}")

    with %Project{} = project <- Project.get_by(slug: Kernel.get_in(params, ["repository", "full_name"])),
         {:ok, job} <- Job.start(project, Tide.Hosts.get_executor()) do
      :ok
      else
        reason ->
          Logger.error("Handle push event failed with reason: #{inspect reason}")
          :internal_server_error
      end
  end
end
