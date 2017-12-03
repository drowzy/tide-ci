defmodule TideWeb.JobController do
  use TideWeb, :controller
  require Logger

  alias Tide.Schemas.Job
  alias Tide.Schemas.Project
  alias Tide.Hosts

  plug(:find_job when action in [:show, :update, :delete])
  plug(:load_project when action in [:index, :create])

  def index(conn = %Plug.Conn{assigns: %{project: project}}, _params) do
    job = Job.list_jobs(project.id)

    conn
    |> put_status(:ok)
    |> json(job)
  end

  def create(conn = %Plug.Conn{assigns: %{project: project}}, params) do
    resp =
      case Tide.Job.start(project, Hosts.get_executor()) do
        {:ok, %Job{} = job} -> {:created, job}
        error ->
          Logger.error("#{inspect error}")
          {:unprocessable_entity, %{error: "failed"}}
      end

    respond(conn, resp)
  end

  def show(conn, %{"id" => id}) do
    resp =
      case Job.get!(id) do
        %Job{} = job -> {:ok, job}
        nil -> {:not_found, %{message: "Job with #{id} not found"}}
      end

    respond(conn, resp)
  end

  defp load_project(conn = %Plug.Conn{params: %{"project_id" => project_id}}, _opts) do
    case Project.get!(project_id) do
      nil ->
        conn
        |> respond({:not_found, %{message: "Project #{project_id} not found"}})
        |> halt()

      project ->
        assign(conn, :project, project)
    end
  end

  defp find_job(conn = %Plug.Conn{params: %{"id" => id}}, _opts) do
    case Job.get(id) do
      nil ->
        conn
        |> respond({:not_found, %{message: "Job #{id} not found"}})
        |> halt()

      job ->
        assign(conn, :job, job)
    end
  end

  defp respond(conn, {status, resp}) do
    conn
    |> put_status(status)
    |> json(resp)
  end
end
