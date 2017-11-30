defmodule TideWeb.ProjectController do
  use TideWeb, :controller

  alias Tide.Schemas.Project

  def index(conn, _params) do
    hosts = Project.list()

    conn
    |> put_status(:ok)
    |> json(hosts)
  end

  def create(conn, params) do
    {status, resp} =
      case Project.create(params) do
        {:ok, project} ->
          {:created, project}

        {:error, _changeset} ->
          {:unprocessable_entity, %{message: "Project could not be created"}}

        _changeset ->
          {:unprocessable_entity, %{message: "Project could not be created"}}
      end

    conn
    |> put_status(status)
    |> json(resp)
  end

  def show(conn, %{"id" => id}) do
    {status, resp} =
      case Project.get!(id) do
        %Project{} = project -> {:ok, project}
        nil -> {:not_found, %{message: "Project with #{id} not found"}}
      end

    conn
    |> put_status(status)
    |> json(resp)
  end

  def update(conn, %{"id" => id} = params) do
    {status, resp} =
      with %Project{} = p <- Project.get!(id),
           {:ok, %Project{} = project} <- Project.update(p, params) do
        {:ok, project}
      else
        nil -> {:not_found, %{message: "Project with id #{id} not found"}}
        {:error, changeset} -> {:unprocessable_entity, %{message: "Error"}}
      end

    conn
    |> put_status(status)
    |> json(resp)
  end

  def delete(conn, %{"id" => id}) do
    {status, resp} =
      with %Project{} = project <- Project.get!(id),
           {:ok, _resp} <- Project.delete(project) do
        {:no_content, %{}}
      else
        nil -> {:not_found, %{message: "Project with #{id} not found"}}
        {:error, _changeset} -> %{message: "Could not delete"}
      end

    conn
    |> put_status(status)
    |> json(resp)
  end
end
