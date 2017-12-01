defmodule TideWeb.JobController do
  use TideWeb, :controller

  alias Tide.Schemas.Job

  plug(:find_job when action in [:show, :update, :delete])

  def index(conn, _params) do
    job = Job.list()

    conn
    |> put_status(:ok)
    |> json(job)
  end

  def create(conn, %{"user" => user} = params) do
    {status, entity} =
      with {:ok, %Job{id: id, name: name} = job} <- Job.create(params),
           {:ok, _pid} = Tide.Job.start(jobname, user) do
        {:created, job}
      else
        _ -> {:unprocessable_entity, %{error: "failed"}}
      end

    conn
    |> put_status(status)
    |> json(entity)
  end

  def show(conn, params) do
  end

  def update(conn, params) do
  end

  def delete(conn, params) do
  end

  defp find_job(conn = conn = %Plug.Conn{params: %{"id" => id}}, _opts) do
    case Job.get(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{message: "resource #{id} not found"})
        |> halt()

      job ->
        assign(conn, :job, job)
    end
  end
end
