defmodule TideWeb.ProjectController do
  use TideWeb, :controller
  require Logger

  alias Tide.Schemas.Project

  def index(conn, _params) do
    hosts = Project.list()

    respond(conn, {:ok, hosts})
  end

  def create(conn, params) do
    Logger.info("project/create requested with #{inspect(params)}")

    resp =
      case Project.create(params) do
        {:ok, project} ->
          {:created, project}

        {:error, changeset} ->
          Logger.error("Request error #{inspect(changeset.errors)}")
          {:unprocessable_entity, %{message: "Project could not be created"}}
      end

    respond(conn, resp)
  end

  def show(conn, %{"id" => id}) do
    resp =
      case Project.get!(id) do
        %Project{} = project -> {:ok, project}
        nil -> {:not_found, %{message: "Project with #{id} not found"}}
      end

    respond(conn, resp)
  end

  def update(conn, %{"id" => id} = params) do
    resp =
      with %Project{} = p <- Project.get!(id),
           {:ok, %Project{} = project} <- Project.update(p, params) do
        {:ok, project}
      else
        nil -> {:not_found, %{message: "Project with id #{id} not found"}}
        {:error, changeset} -> {:unprocessable_entity, %{message: "Error"}}
      end

    respond(conn, resp)
  end

  def delete(conn, %{"id" => id}) do
    resp =
      with %Project{} = project <- Project.get!(id),
           {:ok, _resp} <- Project.delete(project) do
        {:no_content, %{}}
      else
        nil -> {:not_found, %{message: "Project with #{id} not found"}}
        {:error, _changeset} -> %{message: "Could not delete"}
      end

    respond(conn, resp)
  end

  defp respond(conn, {status, resp}) do
    conn
    |> put_status(status)
    |> json(resp)
  end
end
