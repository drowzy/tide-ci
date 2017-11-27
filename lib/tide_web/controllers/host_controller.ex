defmodule TideWeb.HostsController do
  use TideWeb, :controller

  alias Tide.Schemas.Host

  plug(:find_host when action in [:show, :update, :delete])

  def index(conn, _params) do
    hosts = Host.list()

    conn
    |> put_status(:ok)
    |> json(hosts)
  end

  def create(conn, %{"user" => user} = params) do
    {status, entity} =
      with {:ok, %Host{id: id, hostname: hostname} = host} <- Host.create(params),
           {:ok, _pid} = Tide.Hosts.connect(hostname, user) do
        {:created, host}
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

  defp find_host(conn = conn = %Plug.Conn{params: %{"id" => id}}, _opts) do
    case Host.get(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{message: "resource #{id} not found"})
        |> halt()

      host ->
        assign(conn, :host, host)
    end
  end
end
