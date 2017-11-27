defmodule TideWeb.JobController do
  use TideWeb, :controller

  alias Tide.Schemas.Job

  plug(:find_host when action in [:show, :update, :delete])

  def index(conn, _params) do
    hosts = Job.list()

    conn
    |> put_status(:ok)
    |> json(hosts)
  end

  def create(conn, params) do
  end

  def show(conn, params) do
  end

  def update(conn, params) do
  end

  def delete(conn, params) do
  end
end
