defmodule TideWeb.HostsController do

  use TideWeb, :controller

  plug(:find_host when action in [:show, :update, :delete])

  def index do
  end

  def create(conn, param) do
  end

  def show(conn, params) do
  end

  def update(conn, params) do
  end


  def delete(conn, params)do
  end

  defp find_host(conn = conn = %Plug.Conn{params: %{"id" => id}}, _opts) do
    case Tide.Schemas.hosts.get(id) do
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
